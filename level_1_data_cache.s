#============================================================#
#                   Dolphin Anti-Emulation                   #
#------------------------------------------------------------#
# Author  : Star                                             #
# Date    : Oct 28 2020                                      #
# File    : level_1_data_cache.s                             #
# Version : 1.0.0.0                                          #
#============================================================#

#============================================================#
#                           Source                           #
#============================================================#

# Ciphertext
lis       r3, 0x1F16
addi      r3, r3, 0x081E

# Key
bcl+      20, 31, loc_key_end
loc_key_start:
.string   "Mastah08/06/2020\ni'm not known for being a piece of shit loser that needs to hack on this pegi 3 game in order to win (unlike your bf frozen)\0\0"
loc_key_end:
mflr      r4

# Count
li        r5, 0

# Modify the instruction "xor r7, r7, r0" to "nor r7, r7, r0"
li        r0, 0x00F8
addi      r6, r4, loc_xor_crypt_xor - loc_key_start
sth       r0, 0x0002(r6)

# The modified instruction will not be visible to the instruction fetching mechanism because we do not update main memory
sync
icbi       0, r6
isync

loc_xor_crypt_for_loop:
not       r0, r5
clrlslwi  r6, r0, 30, 3
srw       r0, r3, r6
clrlwi    r7, r0, 24
lbzx      r0, r4, r5

loc_xor_crypt_xor:
xor       r7, r7, r0

li        r0, 0xFF
slw       r0, r0, r6
andc      r3, r3, r0
slw       r0, r7, r6
or        r3, r3, r0

addi      r5, r5, 1
cmplwi    r5, 0x8D
blt+      loc_xor_crypt_for_loop

# Return: 0x53746172 on Wii
#         0x00FFFF91 on Dolphin
#============================================================#