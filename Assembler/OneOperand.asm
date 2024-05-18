# all numbers in hex format
# we always start by reset signal
# this is a commented line
# You should ignore empty lines

# ---------- Don't forget to Reset before you start anything ---------- #

.ORG 0  #this means the the following line would be  at address  0 , and this is the reset address
A0

.ORG A0
NOP            #No change
NOT R1         #R1 =FFFFFFFF , C--> no change, N --> 1, Z --> 0
INC R1	       #R1 =00000000 , C --> 1 , N --> 0 , Z --> 1
IN R1	       #R1= 5,add 5 on the in port,flags no change	
IN R2          #R2= 10,add 10 on the in port, flags no change
NOT R2	       #R2= FFFFFFEF, C--> no change, N -->1,Z-->0
INC R1         #R1= 6, C --> 0, N -->0, Z-->0
OUT R1
OUT R2
DEC R2	       #R2= FFFFFFEE, C--> 0, N -->1, Z-->0
NEG R2	       #R2= 00000012, C--> 0, N -->0, Z-->0
OUT R2