# db2
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
db2 <- subset(x, x$DBMS=='db2')
db2$ATP = (db2$ATP-min(db2$ATP))/(max(db2$ATP)-min(db2$ATP))
db2$MAXMPL = (db2$MAXMPL-min(db2$MAXMPL))/(max(db2$MAXMPL)-min(db2$MAXMPL))
x = rbind(db2) 
x$ACTROWPOOL = (x$ACTROWPOOL-min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)-min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD-min(x$PCTREAD))/(max(x$PCTREAD)-min(x$PCTREAD))
x$PCTUPDATE = (x$PCTUPDATE-min(x$PCTUPDATE))/(max(x$PCTUPDATE)-min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS-min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)-min(x$NUMPROCESSORS))

library(lavaan)
thrashing_model <- '
     # mediator
      ATP ~ a1*NUMPROCESSORS+a2*ACTROWPOOL+a3*PK+a4*PCTUPDATE+a5*PCTREAD
    # dependent variable
      MAXMPL ~ b1*ATP + c2*NUMPROCESSORS + c3*ACTROWPOOL + c4*PCTUPDATE + c5*PCTREAD + c6*PK
    # interactions
     INT_1 := a3*a4
     INT_2 := a3*a5
     INT_3 := a1*a2
     '
fit <- sem(thrashing_model, data = x)
summary(fit, fit.measures = TRUE, standardized=TRUE, rsq=T) 

	lavaan (0.5-17) converged normally after  25 iterations

	  Number of observations                           197

	  Estimator                                         ML
	  Minimum Function Test Statistic                0.000
	  Degrees of freedom                                 0
	  Minimum Function Value               0.0000000000000

	Model test baseline model:

	  Minimum Function Test Statistic               83.246
	  Degrees of freedom                                11
	  P-value                                        0.000

	User model versus baseline model:

	  Comparative Fit Index (CFI)                    1.000
	  Tucker-Lewis Index (TLI)                       1.000

	Loglikelihood and Information Criteria:

	  Loglikelihood user model (H0)               -404.794
	  Loglikelihood unrestricted model (H1)       -404.794

	  Number of free parameters                         13
	  Akaike (AIC)                                 835.589
	  Bayesian (BIC)                               878.270
	  Sample-size adjusted Bayesian (BIC)          837.087

	Root Mean Square Error of Approximation:

	  RMSEA                                          0.000
	  90 Percent Confidence Interval          0.000  0.000
	  P-value RMSEA <= 0.05                          1.000

	Standardized Root Mean Square Residual:

	  SRMR                                           0.000

	Parameter estimates:

	  Information                                 Expected
	  Standard Errors                             Standard

		           Estimate  Std.err  Z-value  P(>|z|)   Std.lv  Std.all
	Regressions:
	  ATP ~
	    NUMPROCE (a1)     0.070    0.032    2.193    0.028    0.070    0.143
	    ACTROWPO (a2)     0.044    0.034    1.278    0.201    0.044    0.083
	    PK       (a3)     0.044    0.026    1.705    0.088    0.044    0.112
	    PCTUPDAT (a4)    -0.193    0.038   -5.061    0.000   -0.193   -0.364
	    PCTREAD  (a5)    -0.149    0.044   -3.375    0.001   -0.149   -0.242
	  MAXMPL ~
	    ATP      (b1)     0.211    0.107    1.980    0.048    0.211    0.136
	    NUMPROCE (c2)     0.194    0.048    4.040    0.000    0.194    0.258
	    ACTROWPO (c3)    -0.130    0.051   -2.525    0.012   -0.130   -0.160
	    PCTUPDAT (c4)     0.230    0.061    3.798    0.000    0.230    0.280
	    PCTREAD  (c5)    -0.076    0.068   -1.116    0.265   -0.076   -0.080
	    PK       (c6)     0.064    0.039    1.650    0.099    0.064    0.105

	Variances:
	    ATP               0.032    0.003                      0.032    0.838
	    MAXMPL            0.072    0.007                      0.072    0.782

	Defined parameters:
	    INT_1            -0.008    0.005   -1.645    0.100   -0.008   -0.041
	    INT_2            -0.006    0.004   -1.557    0.120   -0.006   -0.027
	    INT_3             0.003    0.003    1.107    0.268    0.003    0.012

	R-Square:

	    ATP               0.162
	    MAXMPL            0.218

### mediation test
### regression on ATP 
library(mediation)
med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + PK + PCTREAD + PCTREAD:PK + PCTUPDATE + PCTUPDATE:PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + 
	    PK + PCTREAD + PCTREAD:PK + PCTUPDATE + PCTUPDATE:PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.27443 -0.07393 -0.02672  0.02506  0.79739 

	Coefficients:
		                 Estimate Std. Error t value Pr(>|t|)   
	(Intercept)               0.03304    0.04117   0.802   0.4233   
	NUMPROCESSORS             0.05941    0.05330   1.115   0.2664   
	ACTROWPOOL                0.03028    0.04917   0.616   0.5387   
	PK                        0.12807    0.04302   2.977   0.0033 **
	PCTREAD                  -0.07663    0.06040  -1.269   0.2061   
	PCTUPDATE                -0.10358    0.05425  -1.909   0.0578 . 
	NUMPROCESSORS:ACTROWPOOL  0.02592    0.08572   0.302   0.7627   
	PK:PCTREAD               -0.15082    0.08962  -1.683   0.0940 . 
	PK:PCTUPDATE             -0.17800    0.07678  -2.318   0.0215 * 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1799 on 188 degrees of freedom
	Multiple R-squared:  0.1884,	Adjusted R-squared:  0.1538 
	F-statistic: 5.453 on 8 and 188 DF,  p-value: 3.423e-06

### regression on MAXMPL 
out.fit <- lm(MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + PCTREAD, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + 
	    PCTREAD, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.81283 -0.17604  0.07398  0.20103  0.46736 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.71367    0.04713  15.143  < 2e-16 ***
	ATP            0.23266    0.10841   2.146 0.033118 *  
	ACTROWPOOL    -0.13019    0.05249  -2.480 0.013990 *  
	NUMPROCESSORS  0.19554    0.04917   3.977 9.89e-05 ***
	PCTUPDATE      0.22923    0.06205   3.694 0.000288 ***
	PCTREAD       -0.07882    0.06969  -1.131 0.259464    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2737 on 191 degrees of freedom
	Multiple R-squared:  0.207,	Adjusted R-squared:  0.1862 
	F-statistic:  9.97 on 5 and 191 DF,  p-value: 1.721e-08

### mediation of NUMPROCESSORS via ATP on MAXMPL 
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME           0.016019     0.000658     0.039659    0.04
	ADE            0.193063     0.101389     0.284689    0.00
	Total Effect   0.209082     0.117710     0.301486    0.00
	Prop. Mediated 0.072849     0.003127     0.204238    0.04

	Sample Size Used: 197 


	Simulations: 1000 

### moderated mediation of NUMPROCESSORS by ACTROWPOOL through ATP  on MAXMPL
test.modmed(med.out, covariates.1 = list (x$ACTROWPOOL < 0.5), covariates.2 = list (x$x$ACTROWPOOL >= 0.5), data = x)

	Test of ACME(covariates.1) - ACME(covariates.2) = 0

data:  estimates from med.out
ACME(covariates.1) - ACME(covariates.2) = 4e-04, p-value = 0.956
alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
95 percent confidence interval:
 -0.03138100  0.03439588


	Test of ADE(covariates.1) - ADE(covariates.2) = 0

data:  estimates from med.out
ADE(covariates.1) - ADE(covariates.2) = 0.003, p-value = 0.942
alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
95 percent confidence interval:
 -0.1284971  0.1354462

###  mediation of PCTREAD via ATP on MAXMPL 
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTREAD")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.03512     -0.08002     -0.00238    0.04
	ADE            -0.08282     -0.21961      0.04664    0.22
	Total Effect   -0.11793     -0.25348      0.01366    0.07
	Prop. Mediated  0.26625     -0.58417      2.12609    0.11

	Sample Size Used: 197 


	Simulations: 1000 

### moderated mediation of NUMPROCESSORS by PK through ATP on MAXMPL
test.modmed(med.out, covariates.1 = list (x$PK == 1), covariates.2 = list (x$PK == 0), data = x)

	Test of ACME(covariates.1) - ACME(covariates.2) = 0

data:  estimates from med.out
ACME(covariates.1) - ACME(covariates.2) = 2e-04, p-value = 0.99
alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
95 percent confidence interval:
 -0.05097854  0.05721213


	Test of ADE(covariates.1) - ADE(covariates.2) = 0

data:  estimates from med.out
ADE(covariates.1) - ADE(covariates.2) = 1e-04, p-value = 0.972
alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
95 percent confidence interval:
 -0.1796930  0.1915405

###  mediation of PCTUPDATE via ATP on MAXMPL 
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE")
summary(med.out)

	Test of ACME(covariates.1) - ACME(covariates.2) = 0

data:  estimates from med.out
ACME(covariates.1) - ACME(covariates.2) = 2e-04, p-value = 0.99
alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
95 percent confidence interval:
 -0.05097854  0.05721213


	Test of ADE(covariates.1) - ADE(covariates.2) = 0

data:  estimates from med.out
ADE(covariates.1) - ADE(covariates.2) = 1e-04, p-value = 0.972
alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
95 percent confidence interval:
 -0.1796930  0.1915405

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE")
summary(med.out)
> summary(med.out)

Causal Mediation Analysis 

Quasi-Bayesian Confidence Intervals

               Estimate 95% CI Lower 95% CI Upper p-value
ACME           -0.04389     -0.09299     -0.00101    0.04
ADE             0.23019      0.11184      0.34606    0.00
Total Effect    0.18629      0.07611      0.29516    0.00
Prop. Mediated -0.22616     -0.82634     -0.00644    0.04

Sample Size Used: 197 


Simulations: 1000

### moderated mediation of PCTUPDATE by PK through ATP on MAXMPL
test.modmed(med.out, covariates.1 = list (x$PK == 1), covariates.2 = list (x$PK == 0), data = x)

Test of ACME(covariates.1) - ACME(covariates.2) = 0

data:  estimates from med.out
ACME(covariates.1) - ACME(covariates.2) = 0.0011, p-value = 0.938
alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
95 percent confidence interval:
 -0.06089191  0.06087991


	Test of ADE(covariates.1) - ADE(covariates.2) = 0

data:  estimates from med.out
ADE(covariates.1) - ADE(covariates.2) = -0.001, p-value = 0.978
alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
95 percent confidence interval:
 -0.1821091  0.1648538


y <- subset(x, x$PK == 0) # non-pk
library(lavaan)
thrashing_model <- '
     # mediator
      ATP ~ a1*NUMPROCESSORS+a2*ACTROWPOOL+a4*PCTUPDATE+a5*PCTREAD
    # dependent variable
      MAXMPL ~ b1*ATP + c2*NUMPROCESSORS + c3*ACTROWPOOL + c4*PCTUPDATE + c5*PCTREAD
    # interactions
     INT_3 := a1*a2
     '
fit <- sem(thrashing_model, data = y)
summary(fit, fit.measures = TRUE, standardized=TRUE, rsq=T) 

  Number of observations                           101

  Estimator                                         ML
  Minimum Function Test Statistic                0.000
  Degrees of freedom                                 0
  Minimum Function Value               0.0000000000000

Model test baseline model:

  Minimum Function Test Statistic               46.844
  Degrees of freedom                                 9
  P-value                                        0.000

User model versus baseline model:

  Comparative Fit Index (CFI)                    1.000
  Tucker-Lewis Index (TLI)                       1.000

Loglikelihood and Information Criteria:

  Loglikelihood user model (H0)               -101.189
  Loglikelihood unrestricted model (H1)       -101.189

  Number of free parameters                         11
  Akaike (AIC)                                 224.378
  Bayesian (BIC)                               253.144
  Sample-size adjusted Bayesian (BIC)          218.401

Root Mean Square Error of Approximation:

  RMSEA                                          0.000
  90 Percent Confidence Interval          0.000  0.000
  P-value RMSEA <= 0.05                          1.000

Standardized Root Mean Square Residual:

  SRMR                                           0.000

Parameter estimates:

  Information                                 Expected
  Standard Errors                             Standard

                   Estimate  Std.err  Z-value  P(>|z|)   Std.lv  Std.all
Regressions:
  ATP ~
    NUMPROCE (a1)     0.098    0.031    3.217    0.001    0.098    0.293
    ACTROWPO (a2)     0.033    0.033    1.013    0.311    0.033    0.092
    PCTUPDAT (a4)    -0.104    0.037   -2.805    0.005   -0.104   -0.285
    PCTREAD  (a5)    -0.077    0.041   -1.857    0.063   -0.077   -0.189
  MAXMPL ~
    ATP      (b1)     0.019    0.222    0.086    0.932    0.019    0.008
    NUMPROCE (c2)     0.297    0.072    4.145    0.000    0.297    0.376
    ACTROWPO (c3)    -0.129    0.074   -1.749    0.080   -0.129   -0.152
    PCTUPDAT (c4)     0.252    0.086    2.935    0.003    0.252    0.293
    PCTREAD  (c5)     0.008    0.094    0.090    0.928    0.008    0.009

Variances:
    ATP               0.015    0.002                      0.015    0.837
    MAXMPL            0.075    0.011                      0.075    0.752

Defined parameters:
    INT_3             0.003    0.003    0.968    0.333    0.003    0.027

R-Square:

    ATP               0.163
    MAXMPL            0.248


### mediation test
### regression on ATP 
library(mediation)
med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + PCTREAD + PCTUPDATE, data = y)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + 
	    PCTREAD + PCTUPDATE, data = y)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.16094 -0.04648 -0.01716  0.02533  0.75908 

	Coefficients:
		                 Estimate Std. Error t value Pr(>|t|)   
	(Intercept)               0.04318    0.03383   1.276  0.20495   
	NUMPROCESSORS             0.04147    0.05195   0.798  0.42664   
	ACTROWPOOL               -0.01204    0.04733  -0.254  0.79971   
	PCTREAD                  -0.07594    0.04210  -1.804  0.07444 . 
	PCTUPDATE                -0.10273    0.03782  -2.716  0.00784 **
	NUMPROCESSORS:ACTROWPOOL  0.11434    0.08384   1.364  0.17583   
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1254 on 95 degrees of freedom
	Multiple R-squared:  0.1795,	Adjusted R-squared:  0.1363 
	F-statistic: 4.157 on 5 and 95 DF,  p-value: 0.001853

### regression on MAXMPL 
out.fit <- lm(MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + PCTREAD, data = y)
summary(out.fit)


Call:
lm(formula = MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + 
    PCTREAD, data = y)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.73015 -0.21223  0.03656  0.20424  0.45878 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept)    0.62735    0.06738   9.311 4.92e-15 ***
ATP            0.01902    0.22918   0.083 0.934037    
ACTROWPOOL    -0.12937    0.07625  -1.697 0.093060 .  
NUMPROCESSORS  0.29671    0.07380   4.020 0.000116 ***
PCTUPDATE      0.25205    0.08854   2.847 0.005412 ** 
PCTREAD        0.00847    0.09656   0.088 0.930286    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.2829 on 95 degrees of freedom
Multiple R-squared:  0.2482,	Adjusted R-squared:  0.2087 
F-statistic: 6.274 on 5 and 95 DF,  p-value: 4.51e-05

y <- subset(x, x$PK == 1) # pk
#nrow(y)
library(lavaan)
thrashing_model <- '
     # mediator
      ATP ~ a1*NUMPROCESSORS+a2*ACTROWPOOL+a4*PCTUPDATE+a5*PCTREAD
    # dependent variable
      MAXMPL ~ b1*ATP + c2*NUMPROCESSORS + c3*ACTROWPOOL + c4*PCTUPDATE + c5*PCTREAD
    # interactions
     INT_3 := a1*a2
     '
fit <- sem(thrashing_model, data = y)
summary(fit, fit.measures = TRUE, standardized=TRUE, rsq=T)

  Number of observations                            96

  Estimator                                         ML
  Minimum Function Test Statistic                0.000
  Degrees of freedom                                 0

Model test baseline model:

  Minimum Function Test Statistic               41.553
  Degrees of freedom                                 9
  P-value                                        0.000

User model versus baseline model:

  Comparative Fit Index (CFI)                    1.000
  Tucker-Lewis Index (TLI)                       1.000

Loglikelihood and Information Criteria:

  Loglikelihood user model (H0)               -137.382
  Loglikelihood unrestricted model (H1)       -137.382

  Number of free parameters                         11
  Akaike (AIC)                                 296.764
  Bayesian (BIC)                               324.972
  Sample-size adjusted Bayesian (BIC)          290.240

Root Mean Square Error of Approximation:

  RMSEA                                          0.000
  90 Percent Confidence Interval          0.000  0.000
  P-value RMSEA <= 0.05                          1.000

Standardized Root Mean Square Residual:

  SRMR                                           0.000

Parameter estimates:

  Information                                 Expected
  Standard Errors                             Standard

                   Estimate  Std.err  Z-value  P(>|z|)   Std.lv  Std.all
Regressions:
  ATP ~
    NUMPROCE (a1)     0.045    0.055    0.820    0.412    0.045    0.076
    ACTROWPO (a2)     0.049    0.059    0.820    0.412    0.049    0.076
    PCTUPDAT (a4)    -0.279    0.066   -4.244    0.000   -0.279   -0.427
    PCTREAD  (a5)    -0.224    0.080   -2.793    0.005   -0.224   -0.281
  MAXMPL ~
    ATP      (b1)     0.231    0.118    1.959    0.050    0.231    0.196
    NUMPROCE (c2)     0.112    0.064    1.754    0.079    0.112    0.160
    ACTROWPO (c3)    -0.130    0.069   -1.898    0.058   -0.130   -0.173
    PCTUPDAT (c4)     0.202    0.083    2.438    0.015    0.202    0.262
    PCTREAD  (c5)    -0.181    0.096   -1.880    0.060   -0.181   -0.193

Variances:
    ATP               0.047    0.007                      0.047    0.821
    MAXMPL            0.063    0.009                      0.063    0.790

Defined parameters:
    INT_3             0.002    0.004    0.581    0.561    0.002    0.006

R-Square:

    ATP               0.179
    MAXMPL            0.210

### mediation test
### regression on ATP 
library(mediation)
med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + PCTREAD + PCTUPDATE, data = y)
summary(med.fit)

Call:
lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + 
    PCTREAD + PCTUPDATE, data = y)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.23437 -0.13007 -0.03760  0.04571  0.77263 

Coefficients:
                         Estimate Std. Error t value Pr(>|t|)    
(Intercept)               0.14783    0.06286   2.352  0.02087 *  
NUMPROCESSORS             0.07827    0.09517   0.822  0.41298    
ACTROWPOOL                0.07653    0.08891   0.861  0.39169    
PCTREAD                  -0.22361    0.08275  -2.702  0.00823 ** 
PCTUPDATE                -0.27818    0.06785  -4.100 9.05e-05 ***
NUMPROCESSORS:ACTROWPOOL -0.06603    0.15259  -0.433  0.66626    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.2244 on 90 degrees of freedom
Multiple R-squared:  0.1809,	Adjusted R-squared:  0.1354 
F-statistic: 3.976 on 5 and 90 DF,  p-value: 0.002644

### regression on MAXMPL 
out.fit <- lm(MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + PCTREAD, data = y)
summary(out.fit)

Call:
lm(formula = MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + 
    PCTREAD, data = y)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.87464 -0.07387  0.06705  0.16490  0.39584 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept)    0.80312    0.06487  12.381   <2e-16 ***
ATP            0.23078    0.12168   1.897   0.0611 .  
ACTROWPOOL    -0.13020    0.07087  -1.837   0.0695 .  
NUMPROCESSORS  0.11226    0.06611   1.698   0.0929 .  
PCTUPDATE      0.20160    0.08541   2.360   0.0204 *  
PCTREAD       -0.18102    0.09942  -1.821   0.0720 .  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.2593 on 90 degrees of freedom
Multiple R-squared:  0.2097,	Adjusted R-squared:  0.1658 
F-statistic: 4.776 on 5 and 90 DF,  p-value: 0.0006443
