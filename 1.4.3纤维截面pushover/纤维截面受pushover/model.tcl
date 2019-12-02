wipe						                                                      
model basic -ndm 2 -ndf 3				                                                  
if { [file exists output] == 0 } {                                                                         
  file mkdir output
}  
node 1 0 0					
node 2 6 0
node 3 0 3
node 4 6 3
fix 1 1 1 1			
fix 2 1 1 1 
uniaxialMaterial Concrete01  1     -34473.8    -0.005     -24131.66     -0.02
uniaxialMaterial Concrete01  2     27579.04    -0.002        0.0        -0.006
uniaxialMaterial Steel01     3      248200.     2.1e8       0.02
section Fiber 1 {
    patch rect          1          8            8               -0.22         -0.22          0.22         0.22
    patch rect          2         10            1               -0.25          0.22          0.25         0.25
    patch rect          2         10            1               -0.25         -0.25          0.25        -0.22
    patch rect          2          2            1               -0.25         -0.22         -0.22         0.22
    patch rect          2          2            1                0.22         -0.22          0.25         0.22
    layer straight      3          3         4.91e-4             0.22          0.22          0.22         -0.22
    layer straight      3          3         4.91e-4            -0.22          0.22         -0.22         -0.22
}                                                     
section       Elastic         2        3.0e7       0.15        4.5e-3;                                          
geomTransf Linear 1; 	
geomTransf Linear 2; 	
element dispBeamColumn    1      1      3         5         1       1;	
element dispBeamColumn    2      2      4         5         1       1;
element dispBeamColumn    3      3      4         5         2       2;
recorder Node    -file output/disp_34.out        -time   -node  3 4            -dof 1 2 3  disp;					
recorder Node    -file output/reaction_12.out    -time   -node  1 2            -dof 1 2 3  reaction;					
recorder Drift   -file output/drift_1.out        -time   -iNode 1 2 -jNode 3 4 -dof 1      -perpDirn 2 ;				
recorder Element -file output/force_12.out       -time   -ele   1 2                        globalForce;						
recorder Element -file output/foce_3.out         -time   -ele   3                          globalForce;						
recorder Element -file output/forcecolsec_1.out  -time   -ele   1 2            section 1   force;				
recorder Element -file output/defocolsec_1.out   -time   -ele   1 2            section 1   deformation;				
recorder Element -file output/forcecolsec_5.out  -time   -ele   1 2            section 5   force;		
recorder Element -file output/defocolsec_5.out   -time   -ele   1 2            section 5   deformation;		
recorder Element -file output/forcebeamsec_1.out -time   -ele   3              section 1   force;				
recorder Element -file output/defobeamsec_1.out  -time   -ele   3              section 1   deformation;				
recorder Element -file output/forcebeamsec_5.out -time   -ele   3              section 5   force;		
recorder Element -file output/defobeamsec_5.out  -time   -ele   3              section 5   deformation;	
pattern Plain 1 Linear {
   eleLoad -ele 3 -type -beamUniform -65.33;
}
constraints Plain;     				
numberer Plain;					
system BandGeneral;				
test NormDispIncr 1.0e-8 6 2; 				
algorithm NewtonLineSearch 0.75;					
integrator LoadControl 0.1;				
analysis Static				
analyze 10;					
puts "�����������..."
loadConst -time 0.0;
pattern Plain 2 Linear {
	load 3 1.0 0.0 0.0;			
	load 4 1.0 0.0 0.0;			
}
integrator DisplacementControl 3 1 0.001;	
analyze 300;
puts "ˮƽ���������..."








