# pgsql
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
# ATP normalization
pgsql <- subset(x, x$DBMS=='pgsql')
pgsql$ATP = (pgsql$ATP-min(pgsql$ATP))/(max(pgsql$ATP)-min(pgsql$ATP))
pgsql$MAXMPL = (pgsql$MAXMPL-min(pgsql$MAXMPL))/(max(pgsql$MAXMPL)-min(pgsql$MAXMPL))
x = rbind(pgsql) 
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

lavaan (0.5-17) converged normally after  27 iterations

  Number of observations                           191

  Estimator                                         ML
  Minimum Function Test Statistic                0.000
  Degrees of freedom                                 0
  Minimum Function Value               0.0000000000000

Model test baseline model:

  Minimum Function Test Statistic              264.779
  Degrees of freedom                                11
  P-value                                        0.000

User model versus baseline model:

  Comparative Fit Index (CFI)                    1.000
  Tucker-Lewis Index (TLI)                       1.000

Loglikelihood and Information Criteria:

  Loglikelihood user model (H0)               -436.158
  Loglikelihood unrestricted model (H1)       -436.158

  Number of free parameters                         13
  Akaike (AIC)                                 898.316
  Bayesian (BIC)                               940.596
  Sample-size adjusted Bayesian (BIC)          899.417

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
    NUMPROCE (a1)    -0.040    0.034   -1.189    0.234   -0.040   -0.061
    ACTROWPO (a2)     0.009    0.035    0.255    0.799    0.009    0.013
    PK       (a3)    -0.148    0.027   -5.468    0.000   -0.148   -0.280
    PCTUPDAT (a4)    -0.363    0.040   -9.062    0.000   -0.363   -0.516
    PCTREAD  (a5)     0.167    0.044    3.828    0.000    0.167    0.218
  MAXMPL ~
    ATP      (b1)     0.272    0.116    2.352    0.019    0.272    0.171
    NUMPROCE (c2)    -0.224    0.054   -4.116    0.000   -0.224   -0.212
    ACTROWPO (c3)    -0.062    0.056   -1.097    0.272   -0.062   -0.056
    PCTUPDAT (c4)    -0.230    0.076   -3.006    0.003   -0.230   -0.205
    PCTREAD  (c5)    -0.163    0.072   -2.255    0.024   -0.163   -0.134
    PK       (c6)     0.563    0.047   12.088    0.000    0.563    0.667

Variances:
    ATP               0.034    0.004                      0.034    0.499
    MAXMPL            0.088    0.009                      0.088    0.501

Defined parameters:
    INT_1             0.054    0.011    4.741    0.000    0.054    0.144
    INT_2            -0.025    0.008   -3.121    0.002   -0.025   -0.061
    INT_3            -0.000    0.001   -0.249    0.804   -0.000   -0.001

R-Square:

    ATP               0.501
    MAXMPL            0.499

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
-0.30809 -0.10373 -0.00736  0.08902  0.61227 

Coefficients:
                         Estimate Std. Error t value Pr(>|t|)    
(Intercept)               0.41460    0.03904  10.620  < 2e-16 ***
NUMPROCESSORS            -0.02477    0.05291  -0.468   0.6403    
ACTROWPOOL                0.02666    0.04823   0.553   0.5811    
PK                       -0.32598    0.04364  -7.470 3.24e-12 ***
PCTREAD                   0.11466    0.05470   2.096   0.0375 *  
PCTUPDATE                -0.54807    0.04978 -11.009  < 2e-16 ***
NUMPROCESSORS:ACTROWPOOL -0.02601    0.08417  -0.309   0.7576    
PK:PCTREAD                0.12778    0.08266   1.546   0.1239    
PK:PCTUPDATE              0.43403    0.07627   5.691 4.98e-08 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.1748 on 182 degrees of freedom
Multiple R-squared:  0.5792,	Adjusted R-squared:  0.5607 
F-statistic: 31.31 on 8 and 182 DF,  p-value: < 2.2e-16

### regression on MAXMPL 
out.fit <- lm(MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + PCTREAD, data = x)
summary(out.fit)

Call:
lm(formula = MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + 
    PCTREAD, data = x)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.66359 -0.35782 -0.02281  0.38028  0.65717 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept)    0.81005    0.08116   9.981  < 2e-16 ***
ATP           -0.24221    0.14507  -1.670 0.096683 .  
ACTROWPOOL    -0.07065    0.07607  -0.929 0.354238    
NUMPROCESSORS -0.21623    0.07340  -2.946 0.003633 ** 
PCTUPDATE     -0.39637    0.10156  -3.903 0.000133 ***
PCTREAD       -0.06915    0.09681  -0.714 0.475932    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.4004 on 185 degrees of freedom
Multiple R-squared:  0.1149,	Adjusted R-squared:  0.09096 
F-statistic: 4.802 on 5 and 185 DF,  p-value: 0.0003755

### mediation of NUMPROCESSORS via ATP on MAXMPL 
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
summary(med.out)

Causal Mediation Analysis 

Quasi-Bayesian Confidence Intervals

               Estimate 95% CI Lower 95% CI Upper p-value
ACME            0.00902     -0.00606      0.03545    0.31
ADE            -0.21667     -0.36477     -0.08024    0.00
Total Effect   -0.20765     -0.35734     -0.07010    0.00
Prop. Mediated -0.03444     -0.23375      0.03057    0.31

Sample Size Used: 191 


Simulations: 1000 

### moderated mediation of NUMPROCESSORS by ACTROWPOOL through ATP  on MAXMPL
test.modmed(med.out, covariates.1 = list (x$ACTROWPOOL < 0.5), covariates.2 = list (x$x$ACTROWPOOL >= 0.5), data = x)

	Test of ACME(covariates.1) - ACME(covariates.2) = 0

data:  estimates from med.out
ACME(covariates.1) - ACME(covariates.2) = -0.0012, p-value = 0.93
alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
95 percent confidence interval:
 -0.03186116  0.02750803


	Test of ADE(covariates.1) - ADE(covariates.2) = 0

data:  estimates from med.out
ADE(covariates.1) - ADE(covariates.2) = 6e-04, p-value = 0.976
alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
95 percent confidence interval:
 -0.1993953  0.2089655


###  mediation of PCTREAD via ATP on MAXMPL 
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTREAD")
summary(med.out)

Causal Mediation Analysis 

Quasi-Bayesian Confidence Intervals

               Estimate 95% CI Lower 95% CI Upper p-value
ACME            -0.0416      -0.1049       0.0101    0.10
ADE             -0.0686      -0.2748       0.1372    0.47
Total Effect    -0.1101      -0.3079       0.0765    0.25
Prop. Mediated   0.2633      -2.8575       2.9579    0.33

Sample Size Used: 191 


Simulations: 1000 

### moderated mediation of NUMPROCESSORS by PK through ATP on MAXMPL
test.modmed(med.out, covariates.1 = list (x$PK == 1), covariates.2 = list (x$PK == 0), data = x)

	Test of ACME(covariates.1) - ACME(covariates.2) = 0

data:  estimates from med.out
ACME(covariates.1) - ACME(covariates.2) = 6e-04, p-value = 0.962
alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
95 percent confidence interval:
 -0.07483792  0.07813368


	Test of ADE(covariates.1) - ADE(covariates.2) = 0

data:  estimates from med.out
ADE(covariates.1) - ADE(covariates.2) = -0.0049, p-value = 0.972
alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
95 percent confidence interval:
 -0.2939530  0.2596455



###  mediation of PCTUPDATE via ATP on MAXMPL 
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE")
summary(med.out)

Causal Mediation Analysis 

Quasi-Bayesian Confidence Intervals

               Estimate 95% CI Lower 95% CI Upper p-value
ACME            0.08863     -0.00947      0.19482    0.07
ADE            -0.40295     -0.58976     -0.21163    0.00
Total Effect   -0.31432     -0.47739     -0.13739    0.00
Prop. Mediated -0.27780     -0.80941      0.02575    0.07

Sample Size Used: 191 


Simulations: 1000

### moderated mediation of PCTUPDATE by PK through ATP on MAXMPL
test.modmed(med.out, covariates.1 = list (x$PK == 1), covariates.2 = list (x$PK == 0), data = x)

	Test of ACME(covariates.1) - ACME(covariates.2) = 0

data:  estimates from med.out
ACME(covariates.1) - ACME(covariates.2) = 0.005, p-value = 0.982
alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
95 percent confidence interval:
 -0.1438097  0.1536802


	Test of ADE(covariates.1) - ADE(covariates.2) = 0

data:  estimates from med.out
ADE(covariates.1) - ADE(covariates.2) = -0.0056, p-value = 0.956
alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
95 percent confidence interval:
 -0.2793301  0.2783218


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

lavaan (0.5-17) converged normally after  29 iterations

  Number of observations                           107

  Estimator                                         ML
  Minimum Function Test Statistic                0.000
  Degrees of freedom                                 0
  Minimum Function Value               0.0000000000000

Model test baseline model:

  Minimum Function Test Statistic              129.304
  Degrees of freedom                                 9
  P-value                                        0.000

User model versus baseline model:

  Comparative Fit Index (CFI)                    1.000
  Tucker-Lewis Index (TLI)                       1.000

Loglikelihood and Information Criteria:

  Loglikelihood user model (H0)               -163.215
  Loglikelihood unrestricted model (H1)       -163.215

  Number of free parameters                         11
  Akaike (AIC)                                 348.429
  Bayesian (BIC)                               377.830
  Sample-size adjusted Bayesian (BIC)          343.075

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
    NUMPROCE (a1)    -0.125    0.045   -2.767    0.006   -0.125   -0.166
    ACTROWPO (a2)    -0.015    0.047   -0.322    0.748   -0.015   -0.019
    PCTUPDAT (a4)    -0.548    0.052  -10.570    0.000   -0.548   -0.700
    PCTREAD  (a5)     0.119    0.057    2.084    0.037    0.119    0.138
  MAXMPL ~
    ATP      (b1)     0.417    0.158    2.639    0.008    0.417    0.364
    NUMPROCE (c2)    -0.057    0.076   -0.747    0.455   -0.057   -0.066
    ACTROWPO (c3)     0.035    0.076    0.465    0.642    0.035    0.040
    PCTUPDAT (c4)    -0.145    0.121   -1.195    0.232   -0.145   -0.162
    PCTREAD  (c5)    -0.330    0.095   -3.474    0.001   -0.330   -0.335

Variances:
    ATP               0.033    0.005                      0.033    0.383
    MAXMPL            0.088    0.012                      0.088    0.779

Defined parameters:
    INT_3             0.002    0.006    0.319    0.750    0.002    0.003

R-Square:

    ATP               0.617
    MAXMPL            0.221


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
-0.33164 -0.15200 -0.00441  0.10403  0.54723 

Coefficients:
                          Estimate Std. Error t value Pr(>|t|)    
(Intercept)               0.469499   0.049549   9.476 1.28e-15 ***
NUMPROCESSORS            -0.125380   0.078446  -1.598   0.1131    
ACTROWPOOL               -0.015439   0.069366  -0.223   0.8243    
PCTREAD                   0.118710   0.058639   2.024   0.0456 *  
PCTUPDATE                -0.547701   0.053335 -10.269  < 2e-16 ***
NUMPROCESSORS:ACTROWPOOL  0.001018   0.125144   0.008   0.9935    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.1873 on 101 degrees of freedom
Multiple R-squared:  0.6168,	Adjusted R-squared:  0.5978 
F-statistic: 32.51 on 5 and 101 DF,  p-value: < 2.2e-16

### regression on MAXMPL 
out.fit <- lm(MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + PCTREAD, data = y)
summary(out.fit)

Call:
lm(formula = MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + 
    PCTREAD, data = y)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.63761 -0.17257 -0.05802  0.15483  0.80548 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)   
(Intercept)    0.27556    0.10335   2.666  0.00894 **
ATP            0.41681    0.16260   2.563  0.01184 * 
ACTROWPOOL     0.03548    0.07860   0.451  0.65266   
NUMPROCESSORS -0.05705    0.07857  -0.726  0.46946   
PCTUPDATE     -0.14472    0.12460  -1.161  0.24819   
PCTREAD       -0.32978    0.09770  -3.375  0.00105 **
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.306 on 101 degrees of freedom
Multiple R-squared:  0.2206,	Adjusted R-squared:  0.182 
F-statistic: 5.718 on 5 and 101 DF,  p-value: 0.0001095

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

lavaan (0.5-17) converged normally after  25 iterations

  Number of observations                            84

  Estimator                                         ML
  Minimum Function Test Statistic                0.000
  Degrees of freedom                                 0
  Minimum Function Value               0.0000000000000

Model test baseline model:

  Minimum Function Test Statistic               82.402
  Degrees of freedom                                 9
  P-value                                        0.000

User model versus baseline model:

  Comparative Fit Index (CFI)                    1.000
  Tucker-Lewis Index (TLI)                       1.000

Loglikelihood and Information Criteria:

  Loglikelihood user model (H0)                -99.952
  Loglikelihood unrestricted model (H1)        -99.952

  Number of free parameters                         11
  Akaike (AIC)                                 221.903
  Bayesian (BIC)                               248.642
  Sample-size adjusted Bayesian (BIC)          213.942

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
    NUMPROCE (a1)     0.064    0.039    1.649    0.099    0.064    0.141
    ACTROWPO (a2)     0.048    0.041    1.193    0.233    0.048    0.102
    PCTUPDAT (a4)    -0.109    0.047   -2.296    0.022   -0.109   -0.221
    PCTREAD  (a5)     0.241    0.051    4.732    0.000    0.241    0.455
  MAXMPL ~
    ATP      (b1)     0.392    0.197    1.992    0.046    0.392    0.217
    NUMPROCE (c2)    -0.407    0.071   -5.737    0.000   -0.407   -0.498
    ACTROWPO (c3)    -0.164    0.074   -2.222    0.026   -0.164   -0.192
    PCTUPDAT (c4)    -0.237    0.088   -2.688    0.007   -0.237   -0.266
    PCTREAD  (c5)    -0.014    0.103   -0.140    0.888   -0.014   -0.015

Variances:
    ATP               0.021    0.003                      0.021    0.614
    MAXMPL            0.067    0.010                      0.067    0.610

Defined parameters:
    INT_3             0.003    0.003    0.982    0.326    0.003    0.014

R-Square:

    ATP               0.386
    MAXMPL            0.390

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
-0.31058 -0.06141 -0.02006  0.02249  0.62243 

Coefficients:
                         Estimate Std. Error t value Pr(>|t|)    
(Intercept)               0.01989    0.04590   0.433   0.6659    
NUMPROCESSORS             0.09189    0.06507   1.412   0.1619    
ACTROWPOOL                0.07301    0.06152   1.187   0.2389    
PCTREAD                   0.24146    0.05270   4.582 1.72e-05 ***
PCTUPDATE                -0.10750    0.04920  -2.185   0.0319 *  
NUMPROCESSORS:ACTROWPOOL -0.05648    0.10335  -0.546   0.5863    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.1485 on 78 degrees of freedom
Multiple R-squared:  0.388,	Adjusted R-squared:  0.3487 
F-statistic: 9.889 on 5 and 78 DF,  p-value: 2.379e-07


### regression on MAXMPL 
out.fit <- lm(MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + PCTREAD, data = y)
summary(out.fit)

Call:
lm(formula = MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + 
    PCTREAD, data = y)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.67981 -0.15966  0.02673  0.20247  0.38426 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept)    1.09086    0.07213  15.123  < 2e-16 ***
ATP            0.39161    0.20406   1.919   0.0586 .  
ACTROWPOOL    -0.16414    0.07668  -2.141   0.0354 *  
NUMPROCESSORS -0.40697    0.07362  -5.528 4.15e-07 ***
PCTUPDATE     -0.23682    0.09145  -2.590   0.0115 *  
PCTREAD       -0.01447    0.10704  -0.135   0.8928    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.2682 on 78 degrees of freedom
Multiple R-squared:  0.3897,	Adjusted R-squared:  0.3506 
F-statistic: 9.962 on 5 and 78 DF,  p-value: 2.141e-07

