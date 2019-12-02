wipe;						                                                           
model basic -ndm 2 -ndf 3;				                                                
if { [file exists output] == 0 } {                                                   
  file mkdir output;
}  
node 1 0 0;					                                                           
node 2 0 3.0;
node 3 0 6.0;
fix 1 1 1 1; 			                                                               
geomTransf Linear 1;		                                                                          
element elasticBeamColumn    1      1      2       0.25   3.0e10   5.2e-3      1;	
element elasticBeamColumn    2      2      3       0.25   3.0e10   5.2e-3      1;	
recorder Node      -file   output/disp_3.out        -time          -node 3    -dof 1 2 3      disp;	
recorder Node      -file   output/disp_2.out        -time          -node 2    -dof 1 2 3      disp;		   
recorder Node      -file   output/reaction_1.out    -time          -node 1    -dof 1 2 3      reaction;			  
recorder Drift     -file   output/drift_1.out       -time    -iNode 1 -jNode 2  -dof 1       -perpDirn 2 ;		  
recorder Drift     -file   output/drift_2.out       -time    -iNode 2 -jNode 3  -dof 1       -perpDirn 2 ;		  
recorder Element   -file   output/force_1.out       -time          -ele 1                     globalForce;	           
pattern Plain 1 Linear {
   load   2      0.       -1.0e5      0.;
   load   3      0.       -1.0e5      0.;
}
constraints Plain;     				                                                          
numberer Plain;					                                                             
system BandGeneral;				                                                              
test NormDispIncr 1.0e-8 6 2; 			                                                      
algorithm Newton;					                                                         
integrator LoadControl 0.1;				                                                      
analysis Static					                                                              
analyze 10;					                                                              
puts "�����������..."
loadConst -time 0.0;				                                                               
pattern Plain 2 Linear {
	load 2   0.5 0.0 0.0;			                                                               
	load 3   1.0 0.0 0.0;			                                                               	
}
integrator DisplacementControl 3 1 0.001;		                                                       
analyze 500;			                                                                               
puts "ˮƽpushover�������..."


