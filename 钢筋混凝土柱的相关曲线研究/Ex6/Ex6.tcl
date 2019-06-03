#  ------------------------------------------------------------------------------------
#  | ���Ŵ�ѧ       ��Ȫ��¬��ʢ��������                                                  |
#  | 2011��3��                                                                          |
#  |                                                                                    |
#  | ����6��   �ֽ������������������о�                                                 |
#  | ��λ: m��sec��kN��kPa                                                               |
#  |                                                                                    |
#  |                                                                                    |
#  ------------------------------------------------------------------------------------
# 
#                           _____
#                           |   |       /_
#                           |   |       \ \ M
#                           |   |          \
#                           |   |          |                   
#         --------------- 1 |   | 2<-------|----    P
#                           |   |          |
#                           |   |          /
#                           |   |         /
#                           -----
#

set P 0.0;                                                                                                    # ���ó�ʼ������
set incrP 20;
set Flag 1;

set fileID [open "mp.out"  "w"]

set criterion -0.003


# ----- ���øֽ���� -----------------------------
	set fy 4.14e5;                                                                                         # ����ǿ��
	set E  2.0e8;                                                                                         # ����ģ��

# ----- ����������  ------------------------------
	set colWidth 0.4064
	set colDepth 0.4064
	set cover    0.0635
	
# ----- ����ֽ���� ------------------------------
	set d [expr $colDepth-$cover]; 
        set As   6.45e-4;                                                                                     # �ֽ����
        set nbars 4;                                                                                          # ÿ�Ÿֽ�����

# -----������������ ------------------------------
	set epsy [expr $fy/$E];                                                                               # �ֽ�����ʱ��Ӧ��
	set Ky [expr 2.10*$epsy/$d]
	puts "Estimated yield curvature: $Ky"
	set mu 15
	set maxK  [expr $Ky*$mu]


# ------��������---------------------------------------------------------------------------------------

while { $Flag > 0  && $P <= 10000}  {
	
	# ------------------ ��ȡmodel.tcl�ļ� --------------------
	source model.tcl

	# ------------------��ȡ����Ӧ������� ---------------------
	set e1 [ nodeDisp 2  1]
	set e3 [ nodeDisp 2  3]

	set Flag  1;

	if { $e1 <  $criterion }  { 
          # ----------------�������ѹ���Ƿ�̫��---------------------
          puts " ����ѹ��̫��..."
	  
	  set Flag 0  ;                                                                                         # ����ѭ��

	} else {
	  # -----------------������� ---------------------------------
		 pattern Plain 2 "Linear" {
			load 2 0.0 0.0 1.0
	         }
     
		 set numIncr 1000; 
		 set dK [expr $maxK/$numIncr]
		 puts "dK: $dK"
		
		 # --------�������:����λ�ƿ��Ƽ���,�����ڽڵ�2�ĵ�3�����ɶ�-----------------------------
		
		 # ----------------------------�ڵ�� ���ɶȺ� λ������ <���� ��Сλ������ ���λ������> 
                 integrator DisplacementControl  2       3      $dK      1      $dK         $dK;
		 
		 set maxStrain [expr $e1-$e3*$colDepth/2.0];                                                     #�������ѹӦ�� 
		   
		 set step 0  

		 # -------���ӽڵ�2��ת��ֱ���ﵽ���Ӧ���׼-------------------------------------------           
		 while  { $maxStrain>$criterion } {
		  	set ok [analyze 1]
			if { $ok<0} { exit; }
			set step [expr $step+1] 
		  
			set e1 [nodeDisp 2  1]
			set e3 [nodeDisp 2  3]
			set maxStrain [expr $e1-$e3*$colDepth/2.0]
		    }

	    set moment [getTime];                                                                               # ʱ����Լ�����ʽ2��ϵ������ʩ�ӵ����
            

	    puts "step: $step,  maxStrain: $maxStrain, Moment: $moment"

	    #-------------�ѽ����¼���ļ���-------------------------------------------------------------
            puts -nonewline $fileID "\n";       
	    set data " $moment       $P"
	    puts -nonewline $fileID $data ;  
		 
	}   ;                                                                                                      

	set P [expr $P + $incrP]; # update P
}  ; 

close $fileID
puts "���-���ʷ������..."


 

 
 
 
 


