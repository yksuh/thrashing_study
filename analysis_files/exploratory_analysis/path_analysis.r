### exclude moderation
library(sem)
data <- readMoments(diag=FALSE, names=c('numProcs', 'ROSE', 'READ_SF', 'PK', 'ATPT', 'ThrashingPT'))
0
0 0
0 0 0
-0.19 0 0.01 -0.30
0.11 0.13 0.02 0.25 -0.17 
model=matrix(c(
	'numProcs -> ThrashingPT',  'a', NA,
 	'ROSE -> ThrashingPT',      'b', NA,
 	'READ_SF -> ThrashingPT',   'c', NA,
	'PK -> ThrashingPT',     'd', NA,
	'ATPT -> ThrashingPT',     'e', NA,
	'PK -> ATPT',   	'f', NA,
	'READ_SF -> ATPT',      'u', NA,
 	'numProcs -> ATPT',      'v', NA,
	'numProcs <-> numProcs',      'w', NA,
	'ROSE <-> ROSE',      'x', NA,
	'READ_SF <-> READ_SF',      'y', NA,
	'PK <-> PK',      'z', NA,
	'ATPT <-> ATPT',      'g', NA,
	'ThrashingPT <-> ThrashingPT',      'h', NA
	),
 	ncol=3, byrow=TRUE)
path.model <- sem(model, data, 1000)
summary(path.model)

 Model Chisquare =  -1.663669e-13   Df =  7 Pr(>Chisq) = 1
 AIC =  28
 BIC =  -48.35429

 Normalized Residuals
      Min.    1st Qu.     Median       Mean    3rd Qu.       Max. 
-4.360e-16  0.000e+00  0.000e+00 -2.422e-17  0.000e+00  0.000e+00 

 R-square for Endogenous Variables
ThrashingPT        ATPT 
     0.0982      0.1262 

 Parameter Estimates
  Estimate    Std Error  z value     Pr(>|z|)                                  
a  0.09384413 0.03065906   3.0608934  2.206776e-03 ThrashingPT <--- numProcs   
b  0.13000000 0.03004471   4.3268841  1.512335e-05 ThrashingPT <--- ROSE       
c  0.02085031 0.03004643   0.6939362  4.877222e-01 ThrashingPT <--- READ_SF    
d  0.22449073 0.03155408   7.1144755  1.123393e-12 ThrashingPT <--- PK         
e -0.08503090 0.03214120  -2.6455423  8.156009e-03 ThrashingPT <--- ATPT       
f -0.30000000 0.02957490 -10.1437370  3.533192e-24 ATPT <--- PK                
u  0.01000000 0.02957490   0.3381246  7.352693e-01 ATPT <--- READ_SF           
v -0.19000000 0.02957490  -6.4243667  1.324196e-10 ATPT <--- numProcs          
w  1.00000000 0.04474374  22.3494966 1.221126e-110 numProcs <--> numProcs      
x  1.00000000 0.04474374  22.3494966 1.221126e-110 ROSE <--> ROSE              
y  1.00000000 0.04474374  22.3494966 1.221126e-110 READ_SF <--> READ_SF        
z  1.00000000 0.04474374  22.3494966 1.221126e-110 PK <--> PK                  
g  0.87380000 0.03909708  22.3494966 1.221126e-110 ATPT <--> ATPT              
h  0.90178220 0.04034911  22.3494966 1.221126e-110 ThrashingPT <--> ThrashingPT

 Iterations =  0 

### include moderation

library(sem)
data <- readMoments(diag=FALSE, names=c('numProcs', 'ROSE', 'READ_SF', 'PK', 'READ_SF_PK', 'numProcs_ROSE', 'ATPT', 'ThrashingPT'))
0
0 0
0 0 0
0 0 0 0
0 0 0 0 0
-0.19 0 0.01 -0.30 0.03 0.11
0.11 0.13 0.02 0 0 0.25 -0.17 

model=matrix(c(
	'numProcs -> ThrashingPT',  'a', NA,
 	'ROSE -> ThrashingPT',      'b', NA,
 	'READ_SF -> ThrashingPT',   'c', NA,
	'PK -> ThrashingPT',     'd', NA,
	'ATPT -> ThrashingPT',     'e', NA,
	'PK -> ATPT',   	'f', NA,
	'READ_SF -> ATPT',      'u', NA,
 	'numProcs -> ATPT',      'v', NA,
	'READ_SF_PK -> ATPT',      'i', NA,### interaction between READ_SF and PK
	'numProcs_ROSE <-> ATPT',      'j', NA,### interaction between numProcs ROSE and PK
	'numProcs <-> numProcs',      'w', NA,
	'ROSE <-> ROSE',      'x', NA,
	'READ_SF <-> READ_SF',      'y', NA,
	'PK <-> PK',      'z', NA,
	'READ_SF_PK <-> READ_SF_PK',      'k', NA,
	'numProcs_ROSE <-> numProcs_ROSE',      'l', NA,
	'ATPT <-> ATPT',      'g', NA,
	'ThrashingPT <-> ThrashingPT',      'h', NA
	),
 	ncol=3, byrow=TRUE)
path.model <- sem(model, data, 1000)
summary(path.model)

 Model Chisquare =  80.65449   Df =  18 Pr(>Chisq) = 6.581309e-10
 AIC =  116.6545
 BIC =  -43.68511

 Normalized Residuals
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
 0.0000  0.0000  0.0000  0.2705  0.0000  8.4940 

 R-square for Endogenous Variables
ThrashingPT        ATPT 
     0.0549      0.1271 

 Parameter Estimates
  Estimate    Std Error  z value     Pr(>|z|)     
a  0.07753605 0.03138663   2.4703528  1.349799e-02
b  0.13000000 0.03075770   4.2265837  2.372660e-05
c  0.02170863 0.03075946   0.7057545  4.803408e-01
d -0.05125887 0.03230289  -1.5868201  1.125534e-01
e -0.17086290 0.03290394  -5.1927798  2.071771e-07
f -0.30000000 0.02935407 -10.2200465  1.612636e-24
u  0.01000000 0.02935407   0.3406682  7.333534e-01
v -0.19000000 0.02935407  -6.4726961  9.626947e-11
i  0.03000000 0.02935407   1.0220046  3.067787e-01
j  0.11000000 0.02976384   3.6957603  2.192298e-04
w  1.00000000 0.04474374  22.3494966 1.221126e-110
x  1.00000000 0.04474374  22.3494966 1.221126e-110
y  1.00000000 0.04474374  22.3494966 1.221126e-110
z  1.00000000 0.04474374  22.3494966 1.221126e-110
k  1.00000000 0.04474374  22.3494966 1.221126e-110
l  1.00000000 0.04474374  22.3494966 1.221126e-110
g  0.87290000 0.03905681  22.3494966 1.221126e-110
h  0.94509017 0.04228687  22.3494966 1.221126e-110
                                  
a ThrashingPT <--- numProcs       
b ThrashingPT <--- ROSE           
c ThrashingPT <--- READ_SF        
d ThrashingPT <--- PK             
e ThrashingPT <--- ATPT           
f ATPT <--- PK                    
u ATPT <--- READ_SF               
v ATPT <--- numProcs              
i ATPT <--- READ_SF_PK            
j ATPT <--> numProcs_ROSE         
w numProcs <--> numProcs          
x ROSE <--> ROSE                  
y READ_SF <--> READ_SF            
z PK <--> PK                      
k READ_SF_PK <--> READ_SF_PK      
l numProcs_ROSE <--> numProcs_ROSE
g ATPT <--> ATPT                  
h ThrashingPT <--> ThrashingPT    

 Iterations =  0 
