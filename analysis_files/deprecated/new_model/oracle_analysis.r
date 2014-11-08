# oracle
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
oracle <- subset(x, x$DBMS=='oracle')
oracle$ATP = (oracle$ATP-min(oracle$ATP))/(max(oracle$ATP)-min(oracle$ATP))
oracle$MAXMPL = (oracle$MAXMPL-min(oracle$MAXMPL))/(max(oracle$MAXMPL)-min(oracle$MAXMPL))
x = rbind(oracle) 
x$ACTROWPOOL = (x$ACTROWPOOL-min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)-min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD-min(x$PCTREAD))/(max(x$PCTREAD)-min(x$PCTREAD))
x$PCTUPDATE = (x$PCTUPDATE-min(x$PCTUPDATE))/(max(x$PCTUPDATE)-min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS-min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)-min(x$NUMPROCESSORS))

> cor(x$NUMPROCESSORS, x$ATP)
[1] 0.1098935
> cor(x$PCTREAD, x$ATP)
[1] 0.267628
> cor(x$PCTUPDATE, x$ATP)
[1] -0.355188
> cor(x$ACTROWPOOL, x$ATP)
[1] 0.1048952
> cor(x$PK, x$ATP)
[1] -0.3455648

PCTUPDATE
PK
ACTROWPOOL
PCTREAD
NUMPROCESSORS

> cor(x$ATP, x$MAXMPL)
[1] -0.09787458
> cor(x$NUMPROCESSORS, x$MAXMPL)
[1] -0.4372105
> cor(x$PCTREAD, x$MAXMPL)
[1] 0.06340293
> cor(x$PCTUPDATE, x$MAXMPL)
[1] -0.1913905
> cor(x$ACTROWPOOL, x$MAXMPL)
[1] 0.01082654
> cor(x$PK, x$MAXMPL)
[1] 0.03558359

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

lavaan (0.5-17) converged normally after  26 iterations

  Number of observations                           199

  Estimator                                         ML
  Minimum Function Test Statistic                0.000
  Degrees of freedom                                 0

Model test baseline model:

  Minimum Function Test Statistic              122.450
  Degrees of freedom                                11
  P-value                                        0.000

User model versus baseline model:

  Comparative Fit Index (CFI)                    1.000
  Tucker-Lewis Index (TLI)                       1.000

Loglikelihood and Information Criteria:

  Loglikelihood user model (H0)               -415.869
  Loglikelihood unrestricted model (H1)       -415.869

  Number of free parameters                         13
  Akaike (AIC)                                 857.739
  Bayesian (BIC)                               900.552
  Sample-size adjusted Bayesian (BIC)          859.367

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
    NUMPROCE (a1)     0.052    0.023    2.228    0.026    0.052    0.133
    ACTROWPO (a2)     0.038    0.024    1.540    0.123    0.038    0.092
    PK       (a3)    -0.108    0.018   -5.973    0.000   -0.108   -0.357
    PCTUPDAT (a4)    -0.124    0.027   -4.597    0.000   -0.124   -0.309
    PCTREAD  (a5)     0.056    0.030    1.865    0.062    0.056    0.125
  MAXMPL ~
    ATP      (b1)    -0.383    0.210   -1.824    0.068   -0.383   -0.134
    NUMPROCE (c2)    -0.461    0.070   -6.608    0.000   -0.461   -0.415
    ACTROWPO (c3)     0.025    0.073    0.349    0.727    0.025    0.022
    PCTUPDAT (c4)    -0.256    0.084   -3.040    0.002   -0.256   -0.223
    PCTREAD  (c5)     0.004    0.090    0.042    0.966    0.004    0.003
    PK       (c6)     0.001    0.058    0.023    0.982    0.001    0.002

Variances:
    ATP               0.016    0.002                      0.016    0.709
    MAXMPL            0.143    0.014                      0.143    0.762

Defined parameters:
    INT_1             0.013    0.004    3.601    0.000    0.013    0.110
    INT_2            -0.006    0.003   -1.783    0.075   -0.006   -0.045
    INT_3             0.002    0.002    1.268    0.205    0.002    0.012

R-Square:

    ATP               0.291
    MAXMPL            0.238

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
-0.22439 -0.04847 -0.00045  0.02584  0.78748 

Coefficients:
                         Estimate Std. Error t value Pr(>|t|)    
(Intercept)               0.16521    0.02671   6.186 3.70e-09 ***
NUMPROCESSORS             0.03835    0.03485   1.100  0.27261    
ACTROWPOOL                0.02283    0.03018   0.756  0.45032    
PK                       -0.19278    0.02903  -6.642 3.18e-10 ***
PCTREAD                   0.11652    0.03904   2.985  0.00321 ** 
PCTUPDATE                -0.25506    0.03476  -7.337 6.17e-12 ***
NUMPROCESSORS:ACTROWPOOL  0.03670    0.05588   0.657  0.51208    
PK:PCTREAD               -0.11624    0.05419  -2.145  0.03321 *  
PK:PCTUPDATE              0.25868    0.04870   5.311 3.03e-07 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.1149 on 190 degrees of freedom
Multiple R-squared:  0.4506,	Adjusted R-squared:  0.4275 
F-statistic: 19.48 on 8 and 190 DF,  p-value: < 2.2e-16


### regression on MAXMPL 
out.fit <- lm(MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + PCTREAD, data = x)
summary(out.fit)

Call:
lm(formula = MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + 
    PCTREAD, data = x)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.78827 -0.30344  0.00339  0.30357  0.88849 

Coefficients:
               Estimate Std. Error t value Pr(>|t|)    
(Intercept)    0.827007   0.066630  12.412  < 2e-16 ***
ATP           -0.384624   0.196260  -1.960   0.0515 .  
ACTROWPOOL     0.025445   0.073828   0.345   0.7307    
NUMPROCESSORS -0.460947   0.070509  -6.537 5.45e-10 ***
PCTUPDATE     -0.256064   0.084564  -3.028   0.0028 ** 
PCTREAD        0.003907   0.091048   0.043   0.9658    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.3834 on 193 degrees of freedom
Multiple R-squared:  0.2377,	Adjusted R-squared:  0.2179 
F-statistic: 12.04 on 5 and 193 DF,  p-value: 3.738e-10

### mediation of NUMPROCESSORS via ATP on MAXMPL 
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
summary(med.out)

Causal Mediation Analysis 

Quasi-Bayesian Confidence Intervals

                Estimate 95% CI Lower 95% CI Upper p-value
ACME           -0.021866    -0.054772    -0.000524    0.04
ADE            -0.457733    -0.605726    -0.312800    0.00
Total Effect   -0.479599    -0.625592    -0.332221    0.00
Prop. Mediated  0.041916     0.000880     0.113867    0.04

Sample Size Used: 199 


Simulations: 1000 

### moderated mediation of NUMPROCESSORS by ACTROWPOOL through ATP  on MAXMPL
test.modmed(med.out, covariates.1 = list (x$ACTROWPOOL < 0.5), covariates.2 = list (x$x$ACTROWPOOL >= 0.5), data = x)

	Test of ACME(covariates.1) - ACME(covariates.2) = 0

data:  estimates from med.out
ACME(covariates.1) - ACME(covariates.2) = -7e-04, p-value = 0.998
alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
95 percent confidence interval:
 -0.04274586  0.03819935


	Test of ADE(covariates.1) - ADE(covariates.2) = 0

data:  estimates from med.out
ADE(covariates.1) - ADE(covariates.2) = -0.0012, p-value = 0.998
alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
95 percent confidence interval:
 -0.1956364  0.1915813


###  mediation of PCTREAD via ATP on MAXMPL 
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTREAD")
summary(med.out)

Causal Mediation Analysis 

Quasi-Bayesian Confidence Intervals

                Estimate 95% CI Lower 95% CI Upper p-value
ACME           -0.022467    -0.058679     0.000839    0.07
ADE             0.005498    -0.168444     0.183409    0.99
Total Effect   -0.016969    -0.195599     0.159283    0.84
Prop. Mediated  0.080366    -3.547822     2.947257    0.86

Sample Size Used: 199 


Simulations: 1000 

### moderated mediation of NUMPROCESSORS by PK through ATP on MAXMPL
test.modmed(med.out, covariates.1 = list (x$PK == 1), covariates.2 = list (x$PK == 0), data = x)

	Test of ACME(covariates.1) - ACME(covariates.2) = 0

data:  estimates from med.out
ACME(covariates.1) - ACME(covariates.2) = -8e-04, p-value = 0.96
alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
95 percent confidence interval:
 -0.04605692  0.04691639


	Test of ADE(covariates.1) - ADE(covariates.2) = 0

data:  estimates from med.out
ADE(covariates.1) - ADE(covariates.2) = 0.0019, p-value = 0.982
alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
95 percent confidence interval:
 -0.2464857  0.2526254

###  mediation of PCTUPDATE via ATP on MAXMPL 
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE")
summary(med.out)

Causal Mediation Analysis 

Quasi-Bayesian Confidence Intervals

                Estimate 95% CI Lower 95% CI Upper p-value
ACME            0.046379     0.000335     0.102039    0.05
ADE            -0.255129    -0.427049    -0.090910    0.00
Total Effect   -0.208750    -0.369721    -0.048355    0.01
Prop. Mediated -0.213444    -1.044700     0.016605    0.06

Sample Size Used: 199 


Simulations: 1000 


### moderated mediation of PCTUPDATE by PK through ATP on MAXMPL
test.modmed(med.out, covariates.1 = list (x$PK == 1), covariates.2 = list (x$PK == 0), data = x)

	Test of ACME(covariates.1) - ACME(covariates.2) = 0

data:  estimates from med.out
ACME(covariates.1) - ACME(covariates.2) = 6e-04, p-value = 0.976
alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
95 percent confidence interval:
 -0.07717751  0.07115807


	Test of ADE(covariates.1) - ADE(covariates.2) = 0

data:  estimates from med.out
ADE(covariates.1) - ADE(covariates.2) = -0.0032, p-value = 0.966
alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
95 percent confidence interval:
 -0.2313068  0.2201823


lavaan (0.5-17) converged normally after  29 iterations

  Number of observations                            97

  Estimator                                         ML
  Minimum Function Test Statistic                0.000
  Degrees of freedom                                 0
  Minimum Function Value               0.0000000000000

Model test baseline model:

  Minimum Function Test Statistic               96.213
  Degrees of freedom                                 9
  P-value                                        0.000

User model versus baseline model:

  Comparative Fit Index (CFI)                    1.000
  Tucker-Lewis Index (TLI)                       1.000

Loglikelihood and Information Criteria:

  Loglikelihood user model (H0)               -140.680
  Loglikelihood unrestricted model (H1)       -140.680

  Number of free parameters                         11
  Akaike (AIC)                                 303.360
  Bayesian (BIC)                               331.682
  Sample-size adjusted Bayesian (BIC)          296.947

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
    NUMPROCE (a1)     0.129    0.042    3.086    0.002    0.129    0.241
    ACTROWPO (a2)     0.073    0.043    1.728    0.084    0.073    0.134
    PCTUPDAT (a4)    -0.263    0.047   -5.577    0.000   -0.263   -0.490
    PCTREAD  (a5)     0.110    0.053    2.073    0.038    0.110    0.181
  MAXMPL ~
    ATP      (b1)     0.181    0.227    0.797    0.425    0.181    0.085
    NUMPROCE (c2)    -0.706    0.097   -7.245    0.000   -0.706   -0.619
    ACTROWPO (c3)    -0.025    0.096   -0.260    0.795   -0.025   -0.021
    PCTUPDAT (c4)     0.143    0.121    1.183    0.237    0.143    0.125
    PCTREAD  (c5)    -0.035    0.121   -0.294    0.769   -0.035   -0.028

Variances:
    ATP               0.024    0.003                      0.024    0.582
    MAXMPL            0.120    0.017                      0.120    0.637

Defined parameters:
    INT_3             0.009    0.006    1.514    0.130    0.009    0.032

R-Square:

    ATP               0.418
    MAXMPL            0.363

## non primary key
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
-0.27801 -0.08542 -0.01948  0.05289  0.78519 

Coefficients:
                         Estimate Std. Error t value Pr(>|t|)    
(Intercept)               0.13369    0.04388   3.046  0.00303 ** 
NUMPROCESSORS             0.08500    0.07151   1.189  0.23766    
ACTROWPOOL                0.04284    0.05944   0.721  0.47292    
PCTREAD                   0.10928    0.05437   2.010  0.04741 *  
PCTUPDATE                -0.26348    0.04850  -5.432  4.6e-07 ***
NUMPROCESSORS:ACTROWPOOL  0.08723    0.11446   0.762  0.44796    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.1598 on 91 degrees of freedom
Multiple R-squared:  0.4215,	Adjusted R-squared:  0.3897 
F-statistic: 13.26 on 5 and 91 DF,  p-value: 1.056e-09

### regression on MAXMPL 
out.fit <- lm(MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + PCTREAD, data = y)
summary(out.fit)

Call:
lm(formula = MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + 
    PCTREAD, data = y)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.73420 -0.27427 -0.00074  0.26135  0.93494 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept)    0.72097    0.09132   7.895 6.30e-12 ***
ATP            0.18070    0.23400   0.772    0.442    
ACTROWPOOL    -0.02502    0.09950  -0.251    0.802    
NUMPROCESSORS -0.70631    0.10065  -7.017 3.92e-10 ***
PCTUPDATE      0.14304    0.12479   1.146    0.255    
PCTREAD       -0.03544    0.12442  -0.285    0.776    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.3578 on 91 degrees of freedom
Multiple R-squared:  0.363,	Adjusted R-squared:  0.328 
F-statistic: 10.37 on 5 and 91 DF,  p-value: 6.81e-08

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


lavaan (0.5-17) converged normally after  47 iterations

  Number of observations                           102

  Estimator                                         ML
  Minimum Function Test Statistic                0.000
  Degrees of freedom                                 0
  Minimum Function Value               0.0000000000000

Model test baseline model:

  Minimum Function Test Statistic               58.810
  Degrees of freedom                                 9
  P-value                                        0.000

User model versus baseline model:

  Comparative Fit Index (CFI)                    1.000
  Tucker-Lewis Index (TLI)                       1.000

Loglikelihood and Information Criteria:

  Loglikelihood user model (H0)                189.783
  Loglikelihood unrestricted model (H1)        189.783

  Number of free parameters                         11
  Akaike (AIC)                                -357.566
  Bayesian (BIC)                              -328.691
  Sample-size adjusted Bayesian (BIC)         -363.436

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
    NUMPROCE (a1)    -0.006    0.001   -4.788    0.000   -0.006   -0.422
    ACTROWPO (a2)    -0.000    0.001   -0.085    0.932   -0.000   -0.007
    PCTUPDAT (a4)     0.003    0.002    1.787    0.074    0.003    0.177
    PCTREAD  (a5)     0.000    0.002    0.142    0.887    0.000    0.014
  MAXMPL ~
    ATP      (b1)   -13.308    6.927   -1.921    0.055  -13.308   -0.180
    NUMPROCE (c2)    -0.409    0.100   -4.087    0.000   -0.409   -0.377
    ACTROWPO (c3)     0.037    0.097    0.384    0.701    0.037    0.032
    PCTUPDAT (c4)    -0.444    0.109   -4.064    0.000   -0.444   -0.387
    PCTREAD  (c5)    -0.001    0.119   -0.006    0.995   -0.001   -0.001

Variances:
    ATP               0.000    0.000                      0.000    0.792
    MAXMPL            0.131    0.018                      0.131    0.710

Defined parameters:
    INT_3             0.000    0.000    0.085    0.932    0.000    0.003

R-Square:

    ATP               0.208
    MAXMPL            0.290


### mediation test
### regression on ATP 
library(mediation)
med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + PCTREAD + PCTUPDATE, data = y)
summary(med.fit)

Call:
lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + 
    PCTREAD + PCTUPDATE, data = y)

Residuals:
       Min         1Q     Median         3Q        Max 
-0.0097121 -0.0037144  0.0001229  0.0033284  0.0136573 

Coefficients:
                           Estimate Std. Error t value Pr(>|t|)    
(Intercept)               8.302e-03  1.457e-03   5.699 1.32e-07 ***
NUMPROCESSORS            -6.084e-03  2.207e-03  -2.757  0.00699 ** 
ACTROWPOOL               -3.193e-05  1.983e-03  -0.016  0.98719    
PCTREAD                   2.403e-04  1.747e-03   0.138  0.89088    
PCTUPDATE                 2.747e-03  1.585e-03   1.733  0.08627 .  
NUMPROCESSORS:ACTROWPOOL -2.216e-04  3.545e-03  -0.063  0.95029    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.005339 on 96 degrees of freedom
Multiple R-squared:  0.2082,	Adjusted R-squared:  0.167 
F-statistic: 5.049 on 5 and 96 DF,  p-value: 0.000376

### regression on MAXMPL 
out.fit <- lm(MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + PCTREAD, data = y)
summary(out.fit)

Call:
lm(formula = MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + 
    PCTREAD, data = y)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.86608 -0.28058  0.02096  0.29345  0.65848 

Coefficients:
                Estimate Std. Error t value Pr(>|t|)    
(Intercept)    9.653e-01  1.080e-01   8.938 2.85e-14 ***
ATP           -1.331e+01  7.140e+00  -1.864 0.065387 .  
ACTROWPOOL     3.732e-02  1.000e-01   0.373 0.709969    
NUMPROCESSORS -4.092e-01  1.032e-01  -3.965 0.000142 ***
PCTUPDATE     -4.440e-01  1.126e-01  -3.943 0.000153 ***
PCTREAD       -6.992e-04  1.222e-01  -0.006 0.995447    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.3735 on 96 degrees of freedom
Multiple R-squared:  0.2905,	Adjusted R-squared:  0.2535 
F-statistic:  7.86 on 5 and 96 DF,  p-value: 3.08e-06
