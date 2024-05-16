from os.path import dirname, join
current_dir = dirname(__file__)
from tkinter import*


def register_to_binary(decimal_number):
    if decimal_number[0] == "R":                           #remove the notation of Register, change the string if the register is named with another letter
        decimal_number = decimal_number[1:]
    register_number = int(decimal_number)
    if register_number > 7:                                #check if the register number is out of the range (available number of registers)
        binary_number = "999"
        return binary_number
    binary_number = bin(register_number)[2:]               # Remove the '0b' prefix
    binary_number = binary_number.zfill(3)                 # Pad the binary number with leading zeros to make it 3 bits
    return binary_number


def Assemble():
    instruction=""
    IMM=""
    inputfile=label1Entry.get()                             #getting input file name with its format
    file_path = join(current_dir, inputfile+".txt")                #working in the same directory as the code
    outputfile="./"+label2Entry.get()                #setting the output file format to ".mem" file, can be changed according to desired output file format
    output_path= join(current_dir, outputfile+".mem")  

    
    with open(file_path, "r") as file:                      # Open the file in read mode   
        with open(output_path, "w") as output_file:         # Open the output file in write mode                 

            line_number = 0
            
            for line in file:                               # Loop over each line in the file
                line_without_commas_or_comments = line.split("#")[0].replace(",", " ").replace("(", " ").replace(")", "").replace('\xef\xbb\xbf', ' ')
                operands = line_without_commas_or_comments.split()                          # Split the line into words (operands)
                operands = [operand.upper() for operand in operands]                        # Convert operands to uppercase
                skipflag=False
                IMMflag=False
                variables = []                                      # Create variables for each word (operand)
                for i in range(len(operands)):
                    variable_name = "operand_" + str(i + 1)
                    variables.append(variable_name)

                if not variables:                                   #ignoring empty lines
                    continue
                else:
                    exec(', '.join(variables) + " = operands")      # Execute the variable assignments
                    line_number += 1                                # Increment the line counter

                    
                    if len(operands) >= 2 and operands[0] == ".ORG":    # Check for ".org" directive and adjust line number accordingly
                        org_value = int(operands[1], 16)
                        line_number = org_value-1

                    if operands[0] == ".ORG":                           #ignore ".org" line from checking for opcode
                        continue
                    else:
                        if operands == ['NOP']:
                            opcode="0000000"
                            instruction=(opcode+"000000000")

                        elif operands == ['RESET']:
                            opcode="0000001"
                            instruction=(opcode+"000000000")
                        
                        elif operands == ['INT']:
                            opcode="0000010"
                            instruction=(opcode+"000000000")
                        
                        elif operands == ['NOT']:
                            opcode="0001000"
                            Rdest=register_to_binary(operands[1])
                            instruction=(opcode+"000000"+Rdest)
                        
                        elif operands == ['NEG']:
                            opcode="0001001"
                            Rdest=register_to_binary(operands[1])
                            instruction=(opcode+"000000"+Rdest)
                        
                        elif operands[0] == "INC":
                            opcode="0001010"
                            Rdest=register_to_binary(operands[1])
                            instruction=(opcode+"000000"+Rdest)
                        
                        elif operands[0] == "DEC":
                            opcode="0001011"
                            Rdest=register_to_binary(operands[1])
                            instruction=(opcode+"000000"+Rdest)

                        elif operands[0] == "OUT":
                            opcode="0001100"
                            Rdest=register_to_binary(operands[1])
                            instruction=(opcode+"000000"+Rdest)

                        elif operands[0] == "IN":
                            opcode="0001101"
                            Rdest=register_to_binary(operands[1])
                            instruction=(opcode+"000000"+Rdest)

                        elif operands[0] == "MOV":
                            opcode="0101000"
                            Rsrc1=register_to_binary(operands[2])
                            print(Rsrc1)
                            Rdest=register_to_binary(operands[1])
                            print(Rdest)
                            instruction=(opcode+Rsrc1+"000"+Rdest)

                        elif operands[0] == "SWAP":
                            opcode="0101001"
                            Rsrc1=register_to_binary(operands[2])
                            Rdest=register_to_binary(operands[1])
                            instruction=(opcode+Rsrc1+"000"+Rdest)

                        
                        elif operands[0] == "ADD":
                            opcode="0110000"
                            Rsrc1=register_to_binary(operands[2])
                            Rsrc2=register_to_binary(operands[3])
                            Rdest=register_to_binary(operands[1])
                            instruction=(opcode+Rsrc1+Rsrc2+Rdest)

                        elif operands[0] == "ADDI":
                            opcode="0111000"
                            Rdest=register_to_binary(operands[1])
                            IMM=operands[3]
                            IMMflag=True
                            Rsrc1=register_to_binary(operands[2])
                            instruction=(opcode+Rsrc1+"000"+Rdest)

                        elif operands[0] == "SUB":
                            opcode="0110001"
                            Rsrc1=register_to_binary(operands[2])
                            Rsrc2=register_to_binary(operands[3])
                            Rdest=register_to_binary(operands[1])
                            instruction=(opcode+Rsrc1+Rsrc2+Rdest)
                        
                        elif operands[0] == "SUBI":
                            opcode="0111001"
                            Rdest=register_to_binary(operands[1])
                            IMM=operands[3]
                            IMMflag=True
                            Rsrc1=register_to_binary(operands[2])
                            instruction=(opcode+Rsrc1+"000"+Rdest)

                        elif operands[0] == "AND":
                            opcode="0110010"
                            Rsrc1=register_to_binary(operands[2])
                            Rsrc2=register_to_binary(operands[3])
                            Rdest=register_to_binary(operands[1])
                            instruction=(opcode+Rsrc1+Rsrc2+Rdest)
                        
                        elif operands[0] == "OR":
                            opcode="0110011"
                            Rsrc1=register_to_binary(operands[2])
                            Rsrc2=register_to_binary(operands[3])
                            Rdest=register_to_binary(operands[1])
                            instruction=(opcode+Rsrc1+Rsrc2+Rdest)

                        elif operands[0] == "XOR":
                            opcode="0110100"
                            Rsrc1=register_to_binary(operands[2])
                            Rsrc2=register_to_binary(operands[3])
                            Rdest=register_to_binary(operands[1])
                            instruction=(opcode+Rsrc1+Rsrc2+Rdest)
                        
                        elif operands[0] == "CMP":
                            opcode="0100000"
                            Rsrc1=register_to_binary(operands[1])
                            Rsrc2=register_to_binary(operands[2])
                            instruction=(opcode+Rsrc1+Rsrc2+"000")

                        elif operands[0] == "PUSH":
                            opcode="1001000"
                            Rdest=register_to_binary(operands[1])
                            instruction=(opcode+"000000"+Rdest)

                        elif operands[0] == "POP":
                            opcode="1001001"
                            Rdest=register_to_binary(operands[1])
                            instruction=(opcode+"000000"+Rdest)
                        
                        elif operands[0] == "LDM":
                            opcode="1010000"
                            Rdest=register_to_binary(operands[1])
                            IMM=operands[2]
                            IMMflag=True
                            instruction=(opcode+"000000"+Rdest)
                    
                        elif operands[0] == "LDD":
                            opcode="1011000"
                            Rsrc1=register_to_binary(operands[3])
                            IMM=operands[2]
                            IMMflag=True
                            Rdest=register_to_binary(operands[1])
                            instruction=(opcode+Rsrc1+"000"+Rdest)
                        
                        # STD R4, <16BIT>(R5)

                        elif operands[0] == "STD":
                            opcode="1011001"
                            Rsrc1=register_to_binary(operands[3])
                            IMM=operands[2]
                            IMMflag=True
                            Rdest=register_to_binary(operands[1])
                            instruction=(opcode+Rsrc1+"000"+Rdest)

                        elif operands[0] == "PROTECT":
                            opcode="1000000"
                            Rsrc1=register_to_binary(operands[1])
                            instruction=(opcode+Rsrc1+"000000")

                        elif operands[0] == "FREE":
                            opcode="1000001"
                            Rsrc1=register_to_binary(operands[1])
                            instruction=(opcode+Rsrc1+"000000")

                        elif operands[0] == "JZ":
                            opcode="1101000"
                            Rdest=register_to_binary(operands[1])
                            instruction=(opcode+"000000"+Rdest)

                        elif operands[0] == "JMP":
                            opcode="1101001"
                            Rdest=register_to_binary(operands[1])
                            instruction=(opcode+"000000"+Rdest)

                        elif operands[0] == "CALL":
                            opcode="1101010"
                            Rdest=register_to_binary(operands[1])
                            instruction=(opcode+"000000"+Rdest)
                        
                        elif operands[0] == "RET":
                            opcode="1100000"
                            instruction=(opcode+"000000000")

                        elif operands[0] == "RTI":
                            opcode="1100001"
                            instruction=(opcode+"000000000")

                        elif operands[0]>"0":                                #stores the value in the memory cache
                            instruction=operands[0]
                            output_file.write(instruction+"\n")
                            skipflag=True

                        else:
                            output_file.write("XXXXXXXX\n")
                            print("INVALID INSTRUCTION, FILLED WITH UNDEFINED")
                    
                    if skipflag:
                        continue
                    else:
                        if "999" in instruction:
                            output_file.write("XXXXXXXX\n")
                            print("REGISTER IS OUT OF RANGE, FILLED WITH UNDEFINED")
                            continue
                        else:
                            output_file.write(instruction+"\n")
                            if IMMflag:
                                line_number+=1
                                output_file.write(IMM+"\n")
                            

    Messagelabel=Label(text="File assembled successfully!")
    Messagelabel.pack()                    
                        

# GUI section
root = Tk()
root.title("Assembler App")
root.config(bg="black")  
root.minsize(400, 200)

label1 = Label(root, text="Input File", bg="black", fg="white") 
label1.pack()

label1Entry = Entry(root)
label1Entry.pack()

label2 = Label(root, text="Output File", bg="black", fg="white") 
label2.pack()

label2Entry = Entry(root)
label2Entry.pack()

button = Button(root, text="Assemble", command=Assemble, bg="black", fg="white") 
button.pack()

root.mainloop()