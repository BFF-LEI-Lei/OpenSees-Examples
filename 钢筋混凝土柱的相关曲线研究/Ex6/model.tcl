wipe; 
model basic -ndm 2 -ndf 3

node 1 0.0 0.0
node 2 0.0 0.0

fix 1 1 1 1
fix 2 0 1 0


# ----------����������  -----------------------------------------------------------------

# ----------������������    ���Ϻ�   ��ѹǿ��   ��ֵӦ��    ����ǿ��    ����ʱ��Ӧ�� 
uniaxialMaterial Concrete01  1      -3.45e4    -0.004     -2.07e4      -0.014

# ----------�����������    ���Ϻ�   ��ѹǿ��   ��ֵӦ��    ����ǿ��    ����ʱ��Ӧ�� 
uniaxialMaterial Concrete01  2      -3.45e4    -0.002      0.0         -0.006

#  ---------�ֽ�            ���Ϻ�  ����ǿ��      ��ģ      �նȱ�
uniaxialMaterial Steel01     3       $fy          $E       0.01



#  -------------- ������������ֽ����������--------------------------------------------------------------
#
#                           y
#                         /\
#                         |     
#              ---------------------- 2     ---   ---
#              |   o     o     o    |        |    _|_ cover
#              |                    |        |     |
#              |                    |        |     |
#     x <---   |          +         |        H     |
#              |                    |        |     |
#              |                    |        |    _|_
#              |   o     o     o    |        |     |   cover
#            1 ----------------------       ---   ---
#              |-------- B ---------|
#
#  



set y1 [expr $colDepth/2.0]
set z1 [expr $colWidth/2.0]

section Fiber 1 {

    # ---------������ά��Ԫ--------------------------------------------
   
    #----------������������--------------------------------------------
    patch rect          1         10            1          [expr $cover-$y1] [expr $cover-$z1] [expr $y1-$cover] [expr $z1-$cover]

    # ---------�����������--------------------------------------------
    patch rect          2         10            1          [expr -$y1]       [expr $z1-$cover]       $y1                $z1
    patch rect          2         10            1          [expr -$y1]       [expr -$z1]             $y1         [expr $cover-$z1]
    patch rect          2          2            1          [expr -$y1]       [expr $cover-$z1] [expr $cover-$y1] [expr $z1-$cover]
    patch rect          2          2            1          [expr $y1-$cover] [expr $cover-$z1]       $y1         [expr $z1-$cover]
 
    #----------�ֽ�----------------------------------------------------
    layer straight      3       $nbars         $As         [expr $y1-$cover] [expr $z1-$cover] [expr $y1-$cover] [expr $cover-$z1]
    layer straight      3       $nbars         $As         [expr $cover-$y1] [expr $z1-$cover] [expr $cover-$y1] [expr $cover-$z1]
}    


# ---------- �����������ά��Ԫ------------------------------------------------------------------------------

# ------------------------- ��Ԫ�� �ڵ��    �ڵ��  �����             X�ᶨλ����     Y�ᶨλ����
   element zeroLengthSection  1       1       2      1     -orient   1    0     0     0   1    0

# ---------- ����������  -----------------------------------------------------------------------------------

set axialLoad -$P

puts "axialLoad: $axialLoad"


# ---------- ����������-------------------------------
pattern Plain 1 "Constant" {
	load 2 $axialLoad 0.0 0.0
}

# ---------- ����������� -----------------------------------------------------------------------------------
integrator LoadControl 0.
system BandGeneral
test NormUnbalance 1.0e-9 10
numberer Plain
constraints Plain
algorithm Newton
analysis Static

#----------- ��������������һ��------------------------
set ok [analyze 1]
if { $ok <0 } { puts "Non-converged solution"; exit }


loadConst -time 0.0  	


 
