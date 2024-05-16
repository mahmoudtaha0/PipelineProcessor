import os
import glob
def sync():
    top_level = os.getcwd().split('\\')[-1]
    version = get_version()
    file_paths = count_files_with_extensions()
    folders = get_folder_hierarchy()
    file_config = "vhdl_novitalcheck 0 vhdl_nodebug 0 vhdl_1164 1 cover_nofec 0 file_type vhdl group_id 0 vhdl_noload 0 vhdl_synth 0 vhdl_enable0In 0 vhdl_disableopt 0 last_compile 1 folder {0} vhdl_vital 0 cover_excludedefault 0 vhdl_warn1 1 vhdl_warn2 1 vhdl_showsource 0 vhdl_explicit 1 vhdl_warn3 1 vhdl_0InOptions {{}} cover_covercells 0 voptflow 1 vhdl_warn4 1 vhdl_options {{}} cover_optlevel 3 vhdl_warn5 1 toggle - ood 1 compile_to work cover_noshort 0 compile_order {1} cover_nosub 0 dont_compile 0 vhdl_use93 " + version
    file_lines = []
    file_lines.append("Project_Files_Count = {0}\n".format(len(file_paths)))
    for i, path in enumerate(file_paths):
        file_lines.append("Project_File_{0} = {1}\n".format(i, path.replace('\\','/')))
        parent_folder = path.split('\\')[-2]
        parent_folder = parent_folder if parent_folder != top_level else "{Top Level}"
        file_lines.append("Project_File_P_{0} = {1}\n".format(i, file_config.format(parent_folder, i)))
    folder_lines = []
    folder_lines.append("Project_Folder_Count = {0}\n".format(len(folders)))
    for i,folder in enumerate(folders):
        folder_lines.append("Project_Folder_{0} = {1}\n".format(i, folder[0]))
        folder_lines.append("Project_Folder_P_{0} = folder {1}\n".format(i, folder[1]))
    modify_and_add_to_file(file_lines)
    modify_and_add_to_file(folder_lines, False)

def get_version(version = "2008"):
    file_path = glob.glob("*.mpf")[0]
    with open(file_path, 'r') as file:
        lines = file.readlines()
    for i, line in enumerate(lines):
        if line.startswith('VHDL93'):
            try:
                v = line.split(' = ')[1]
            except:
                lines[i] = 'VHDL93 = 2008\n'
                break
            if v is None or v.strip() != '2002' and v.strip() != '2008':
                lines[i] = 'VHDL93 = 2008\n'
                break
            version = v.strip()
            break
    with open(file_path, 'w') as file:
        file.writelines(lines)
    return version

def modify_and_add_to_file(new_content, is_file = True):
    file_path = glob.glob("*.mpf")[0]
    with open(file_path, 'r') as file:
        lines = file.readlines()
    
    # Find the line index where the change should start
    start_index = -1
    for index, line in enumerate(lines):
        if line.startswith(f"Project_{'Files' if is_file else 'Folder'}_Count"):
            start_index = index
            break
    end_index = -1
    for index, line in enumerate(lines):
        if line.startswith(f"Project_{'File' if is_file else 'Folder'}_P_"):
            end_index = index
    
    if start_index == -1 or end_index == -1:
        print("Lines were not found in the file.")
        return
    
    # Modify the lines starting from the found index
    new_lines = lines[:start_index]  # Keep all lines before the start index unchanged

    # Adding new content based on the description provided
    new_lines += new_content

    new_lines += lines[end_index+1:]
    # Write everything back to the file
    with open(file_path, 'w') as file:
        file.writelines(new_lines)

def count_files_with_extensions(extensions = ('.do', '.vhd')):
    directory = os.getcwd()
    # List to hold file paths
    file_paths = []

    # Walk through all directories and files in the directory
    for root, _, files in os.walk(directory):
        # Loop through each file in the current root
        for filename in files:
            # Check if the file ends with a specified extension
            if any(filename.lower().endswith(ext) for ext in extensions):
                # Construct absolute path
                full_path = os.path.join(root, filename)
                file_paths.append(full_path)


    # Return the count of found files
    return file_paths

def get_folder_hierarchy(exclude = ("work")):
    directory = os.getcwd()
    folder_hierarchy = []
    top_level = os.getcwd().split('\\')[-1]
    # Use os.walk to traverse the directory tree
    for root, dirs, _ in os.walk(directory):
        # Parent folder is the root directory
        parent_folder = os.path.basename(root)

        # Loop through each directory in 'dirs'
        for dir_name in dirs:
            if dir_name in exclude: continue
            # Append tuple (directory name, parent folder name) to the list
            folder_hierarchy.append((dir_name, parent_folder if parent_folder != top_level else "{Top Level}"))

    return folder_hierarchy

def setup():
    # Open and read any ModelSim project file (we normally have one per project)
    for file in glob.glob("*.mpf"):
        with open(file, "r") as f, open(file+".new", "w") as g:
            for line in f:
                if "Project_File_" in line and "Project_File_P_" not in line:
                    values = line.split(' = ')
                    value = '$PWD' + values[1].split("/".join(os.getcwd().split('\\')))[1]
                    g.write('{0} = {1}\n'.format(values[0].strip(), value.strip()))
                    continue
                g.write(line.strip() + "\n")

def fixup():
    # Open and read any ModelSim project file (we normally have one per project)
    for file in glob.glob("*.mpf"):
        in_file_section = 0
        # We use the fact that a file property line immediately follows the file name
        current_name = ""
        pf = {}
        with open(file+".new", "r") as f, open(file, "w") as g:
            for line in f:
                if "Project_File_P_" in line:
                    # In addition, sort the "key value" pairs in the property line
                    # since ModelSim randomly shuffles them as well
                    pp = {}
                    prop = line.partition(" = ")[2].split(" ")
                    i = 0
                    while(i<len(prop)):
                        key = prop[i]
                        value = prop[i+1]
                        # A property value that has a space is enclosed in { .. }
                        if "{}" not in value and "{" in value:
                            i = i + 1
                            value = value + " " + prop[i+1]
                        # Another hack: ignore property "last_compile" since it always changes
                        if "last_compile" in key:
                            value = "1"
                        # Another hack: ignore property "ood"
                        if "ood" in key:
                            value = "0"
                        pp[key] = value.strip()
                        i = i + 2
                    sorted_prop = ""
                    for k,v in sorted(pp.items()):
                        sorted_prop = sorted_prop + " {0} {1}".format(k,v)
                    pf[current_name] = sorted_prop.lstrip() + "\n"
                    in_file_section = 1
                    continue
                if "Project_File_" in line:
                    current_name = line.partition(" = ")[2]
                    in_file_section = 1
                    # When we are already at it, make sure project files are relative to the $PWD
                    if "$PWD" not in line:
                        g.write("; Warning: Path {0} is not relative to the $PWD!\n".format(current_name.strip()))
                    continue
                # We are not in the file section any more since we are here
                if in_file_section:
                    # Flush out our file list in a predictable order
                    i = 0
                    for k,v in sorted(pf.items()):
                        g.write("Project_File_{0} = {1}".format(i, k))
                        g.write("Project_File_P_{0} = {1}".format(i, v))
                        i = i + 1
                    in_file_section = 0
                g.write(line.strip() + "\n") # Trim whitespaces that ModelSim sometimes adds randomly
        # Lastly, replace old mpf file with the new one
        os.remove(file+".new")


sync()
setup()
fixup()