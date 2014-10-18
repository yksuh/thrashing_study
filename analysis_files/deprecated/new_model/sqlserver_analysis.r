# sqlserver
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
# ATP normalization
sqlserver <- subset(x, x$DBMS=='sqlserver')
sqlserver$ATP = (sqlserver$ATP-min(sqlserver$ATP))/(max(sqlserver$ATP)-min(sqlserver$ATP))
sqlserver$MAXMPL = (sqlserver$MAXMPL-min(sqlserver$MAXMPL))/(max(sqlserver$MAXMPL)-min(sqlserver$MAXMPL))
x = rbind(sqlserver) 
x$ACTROWPOOL = (x$ACTROWPOOL-min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)-min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD-min(x$PCTREAD))/(max(x$PCTREAD)-min(x$PCTREAD))
x$PCTUPDATE = (x$PCTUPDATE-min(x$PCTUPDATE))/(max(x$PCTUPDATE)-min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS-min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)-min(x$NUMPROCESSORS))

cor(x$NUMPROCESSORS, x$ATP)
cor(x$PCTREAD, x$ATP)
cor(x$PCTUPDATE, x$ATP)
cor(x$ACTROWPOOL, x$ATP)
cor(x$PK, x$ATP)

> cor(x$NUMPROCESSORS, x$ATP)
[1] -0.5532443
> cor(x$PCTREAD, x$ATP)
[1] -0.09008949
> cor(x$PCTUPDATE, x$ATP)
[1] 0.164305
> cor(x$ACTROWPOOL, x$ATP)
[1] 0.004834028
> cor(x$PK, x$ATP)
[1] 0.02529076

> cor(x$ATP, x$MAXMPL)
[1] -0.1650325
> cor(x$NUMPROCESSORS, x$MAXMPL)
[1] 0.46993
> cor(x$PCTREAD, x$MAXMPL)
[1] 0.08793122
> cor(x$PCTUPDATE, x$MAXMPL)
[1] -0.1673061
> cor(x$ACTROWPOOL, x$MAXMPL)
[1] 0.01020708
> cor(x$PK, x$MAXMPL)
[1] -0.06175093

NUMPROCESSORS
PCTUPDATE
PK
PCTREAD
ACTROWPOOL

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

  Number of observations                           216

  Estimator                                         ML
  Minimum Function Test Statistic                0.000
  Degrees of freedom                                 0
  Minimum Function Value               0.0000000000000

Model test baseline model:

  Minimum Function Test Statistic              155.064
  Degrees of freedom                                11
  P-value                                        0.000

User model versus baseline model:

  Comparative Fit Index (CFI)                    1.000
  Tucker-Lewis Index (TLI)                       1.000

Loglikelihood and Information Criteria:

  Loglikelihood user model (H0)               -506.645
  Loglikelihood unrestricted model (H1)       -506.645

  Number of free parameters                         13
  Akaike (AIC)                                1039.290
  Bayesian (BIC)                              1083.168
  Sample-size adjusted Bayesian (BIC)         1041.974

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
    NUMPROCE (a1)    -0.450    0.046   -9.874    0.000   -0.450   -0.550
    ACTROWPO (a2)     0.004    0.047    0.087    0.931    0.004    0.005
    PK       (a3)     0.021    0.035    0.595    0.552    0.021    0.033
    PCTUPDAT (a4)     0.123    0.052    2.365    0.018    0.123    0.146
    PCTREAD  (a5)    -0.009    0.059   -0.162    0.872   -0.009   -0.010
  MAXMPL ~
    ATP      (b1)     0.162    0.064    2.543    0.011    0.162    0.180
    NUMPROCE (c2)     0.416    0.051    8.101    0.000    0.416    0.567
    ACTROWPO (c3)     0.007    0.044    0.161    0.872    0.007    0.009
    PCTUPDAT (c4)    -0.134    0.049   -2.723    0.006   -0.134   -0.177
    PCTREAD  (c5)     0.007    0.055    0.128    0.898    0.007    0.008
    PK       (c6)    -0.042    0.033   -1.263    0.206   -0.042   -0.074

Variances:
    ATP               0.067    0.006                      0.067    0.670
    MAXMPL            0.059    0.006                      0.059    0.728

Defined parameters:
    INT_1             0.003    0.004    0.579    0.562    0.003    0.005
    INT_2            -0.000    0.001   -0.157    0.875   -0.000   -0.000
    INT_3            -0.002    0.021   -0.087    0.931   -0.002   -0.003

R-Square:

    ATP               0.330
    MAXMPL            0.272

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
-0.36819 -0.20752  0.00249  0.12115  0.60492 

Coefficients:
                          Estimate Std. Error t value Pr(>|t|)    
(Intercept)               0.292307   0.057652   5.070 8.80e-07 ***
NUMPROCESSORS            -0.445340   0.077746  -5.728 3.54e-08 ***
ACTROWPOOL                0.008437   0.069534   0.121   0.9035    
PK                        0.022847   0.061012   0.374   0.7084    
PCTREAD                  -0.031196   0.080410  -0.388   0.6984    
PCTUPDATE                 0.135081   0.074101   1.823   0.0698 .  
NUMPROCESSORS:ACTROWPOOL -0.010783   0.124603  -0.087   0.9311    
PK:PCTREAD                0.050973   0.120769   0.422   0.6734    
PK:PCTUPDATE             -0.024373   0.106144  -0.230   0.8186    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.2641 on 207 degrees of freedom
Multiple R-squared:  0.3314,	Adjusted R-squared:  0.3056 
F-statistic: 12.83 on 8 and 207 DF,  p-value: 6.024e-15

### regression on MAXMPL 
out.fit <- lm(MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + PCTREAD, data = x)
summary(out.fit)

Call:
lm(formula = MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + 
    PCTREAD, data = x)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.58133 -0.06817  0.03057  0.12497  0.50293 

Coefficients:
               Estimate Std. Error t value Pr(>|t|)    
(Intercept)    0.453688   0.044878  10.109  < 2e-16 ***
ATP            0.158808   0.064814   2.450  0.01510 *  
ACTROWPOOL     0.007127   0.045039   0.158  0.87443    
NUMPROCESSORS  0.413357   0.052253   7.911 1.44e-13 ***
PCTUPDATE     -0.135084   0.050193  -2.691  0.00769 ** 
PCTREAD        0.009334   0.055987   0.167  0.86776    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.2467 on 210 degrees of freedom
Multiple R-squared:  0.2664,	Adjusted R-squared:  0.2489 
F-statistic: 15.25 on 5 and 210 DF,  p-value: 8.809e-13

### mediation of NUMPROCESSORS via ATP on MAXMPL 
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
summary(med.out)

Causal Mediation Analysis 

Quasi-Bayesian Confidence Intervals

               Estimate 95% CI Lower 95% CI Upper p-value
ACME           -0.07110     -0.13191     -0.00952    0.02
ADE             0.41296      0.31574      0.51057    0.00
Total Effect    0.34185      0.26056      0.42433    0.00
Prop. Mediated -0.20415     -0.42709     -0.02952    0.02

Sample Size Used: 216 


Simulations: 1000 


### moderated mediation of NUMPROCESSORS by ACTROWPOOL through ATP  on MAXMPL
test.modmed(med.out, covariates.1 = list (x$ACTROWPOOL < 0.5), covariates.2 = list (x$x$ACTROWPOOL >= 0.5), data = x)

	Test of ACME(covariates.1) - ACME(covariates.2) = 0

data:  estimates from med.out
ACME(covariates.1) - ACME(covariates.2) = 0.0012, p-value = 0.984
alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
95 percent confidence interval:
 -0.07576827  0.08550116


	Test of ADE(covariates.1) - ADE(covariates.2) = 0

data:  estimates from med.out
ADE(covariates.1) - ADE(covariates.2) = -0.0035, p-value = 0.944
alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
95 percent confidence interval:
 -0.1522999  0.1414097


###  mediation of PCTREAD via ATP on MAXMPL 
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTREAD")
summary(med.out)

Causal Mediation Analysis 

Quasi-Bayesian Confidence Intervals

                Estimate 95% CI Lower 95% CI Upper p-value
ACME           -0.000829    -0.021088     0.019215    0.94
ADE             0.006807    -0.096316     0.117153    0.88
Total Effect    0.005978    -0.102084     0.119521    0.90
Prop. Mediated  0.014659    -3.195683     2.495968    0.95

Sample Size Used: 216 


Simulations: 1000 


### moderated mediation of NUMPROCESSORS by PK through ATP on MAXMPL
test.modmed(med.out, covariates.1 = list (x$PK == 1), covariates.2 = list (x$PK == 0), data = x)

	Test of ACME(covariates.1) - ACME(covariates.2) = 0

data:  estimates from med.out
ACME(covariates.1) - ACME(covariates.2) = 1e-04, p-value = 0.974
alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
95 percent confidence interval:
 -0.02898010  0.02866487


	Test of ADE(covariates.1) - ADE(covariates.2) = 0

data:  estimates from med.out
ADE(covariates.1) - ADE(covariates.2) = 0.0027, p-value = 0.99
alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
95 percent confidence interval:
 -0.1496727  0.1568483


###  mediation of PCTUPDATE via ATP on MAXMPL 
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE")
summary(med.out)

Causal Mediation Analysis 

Quasi-Bayesian Confidence Intervals

               Estimate 95% CI Lower 95% CI Upper p-value
ACME            0.01945      0.00109      0.04773    0.03
ADE            -0.13504     -0.23001     -0.03353    0.01
Total Effect   -0.11559     -0.21157     -0.01591    0.02
Prop. Mediated -0.15657     -0.97550      0.00217    0.05

Sample Size Used: 216 


Simulations: 1000 

### moderated mediation of PCTUPDATE by PK through ATP on MAXMPL
test.modmed(med.out, covariates.1 = list (x$PK == 1), covariates.2 = list (x$PK == 0), data = x)

	Test of ACME(covariates.1) - ACME(covariates.2) = 0

data:  estimates from med.out
ACME(covariates.1) - ACME(covariates.2) = 0.0013, p-value = 0.934
alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
95 percent confidence interval:
 -0.03248252  0.03781229


	Test of ADE(covariates.1) - ADE(covariates.2) = 0

data:  estimates from med.out
ADE(covariates.1) - ADE(covariates.2) = -0.0031, p-value = 0.988
alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
95 percent confidence interval:
 -0.1499754  0.1311522

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

lavaan (0.5-17) converged normally after  27 iterations

  Number of observations                           112

  Estimator                                         ML
  Minimum Function Test Statistic                0.000
  Degrees of freedom                                 0
  Minimum Function Value               0.0000000000000

Model test baseline model:

  Minimum Function Test Statistic              106.244
  Degrees of freedom                                 9
  P-value                                        0.000

User model versus baseline model:

  Comparative Fit Index (CFI)                    1.000
  Tucker-Lewis Index (TLI)                       1.000

Loglikelihood and Information Criteria:

  Loglikelihood user model (H0)               -171.210
  Loglikelihood unrestricted model (H1)       -171.210

  Number of free parameters                         11
  Akaike (AIC)                                 364.420
  Bayesian (BIC)                               394.323
  Sample-size adjusted Bayesian (BIC)          359.560

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
    NUMPROCE (a1)    -0.427    0.063   -6.787    0.000   -0.427   -0.531
    ACTROWPO (a2)     0.011    0.065    0.167    0.867    0.011    0.013
    PCTUPDAT (a4)     0.135    0.072    1.889    0.059    0.135    0.164
    PCTREAD  (a5)    -0.031    0.078   -0.402    0.688   -0.031   -0.035
  MAXMPL ~
    ATP      (b1)     0.225    0.081    2.770    0.006    0.225    0.238
    NUMPROCE (c2)     0.560    0.064    8.736    0.000    0.560    0.737
    ACTROWPO (c3)    -0.055    0.056   -0.989    0.322   -0.055   -0.070
    PCTUPDAT (c4)    -0.133    0.062   -2.138    0.032   -0.133   -0.172
    PCTREAD  (c5)     0.008    0.067    0.118    0.906    0.008    0.009

Variances:
    ATP               0.065    0.009                      0.065    0.685
    MAXMPL            0.048    0.006                      0.048    0.565

Defined parameters:
    INT_3            -0.005    0.028   -0.167    0.868   -0.005   -0.007

R-Square:

    ATP               0.315
    MAXMPL            0.435

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
-0.36781 -0.21007 -0.05267  0.13953  0.60740 

Coefficients:
                         Estimate Std. Error t value Pr(>|t|)    
(Intercept)               0.27600    0.06827   4.043 0.000100 ***
NUMPROCESSORS            -0.41222    0.10815  -3.811 0.000232 ***
ACTROWPOOL                0.02225    0.09515   0.234 0.815540    
PCTREAD                  -0.03120    0.07977  -0.391 0.696528    
PCTUPDATE                 0.13508    0.07351   1.838 0.068937 .  
NUMPROCESSORS:ACTROWPOOL -0.02920    0.17343  -0.168 0.866634    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.262 on 106 degrees of freedom
Multiple R-squared:  0.3153,	Adjusted R-squared:  0.283 
F-statistic: 9.762 on 5 and 106 DF,  p-value: 1.082e-07

### regression on MAXMPL 
out.fit <- lm(MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + PCTREAD, data = y)
summary(out.fit)

Call:
lm(formula = MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + 
    PCTREAD, data = y)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.52419 -0.11517  0.02277  0.11224  0.50120 

Coefficients:
               Estimate Std. Error t value Pr(>|t|)    
(Intercept)    0.435847   0.055988   7.785 4.94e-12 ***
ATP            0.224754   0.083411   2.695   0.0082 ** 
ACTROWPOOL    -0.054924   0.057056  -0.963   0.3379    
NUMPROCESSORS  0.560493   0.065948   8.499 1.31e-13 ***
PCTUPDATE     -0.133429   0.064136  -2.080   0.0399 *  
PCTREAD        0.007854   0.068563   0.115   0.9090    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.225 on 106 degrees of freedom
Multiple R-squared:  0.4345,	Adjusted R-squared:  0.4079 
F-statistic: 16.29 on 5 and 106 DF,  p-value: 6.723e-12



y <- subset(x, x$PK == 1) # non-pk
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

lavaan (0.5-17) converged normally after  28 iterations

  Number of observations                           104

  Estimator                                         ML
  Minimum Function Test Statistic                0.000
  Degrees of freedom                                 0
  Minimum Function Value               0.0000000000000

Model test baseline model:

  Minimum Function Test Statistic               61.803
  Degrees of freedom                                 9
  P-value                                        0.000

User model versus baseline model:

  Comparative Fit Index (CFI)                    1.000
  Tucker-Lewis Index (TLI)                       1.000

Loglikelihood and Information Criteria:

  Loglikelihood user model (H0)               -170.927
  Loglikelihood unrestricted model (H1)       -170.927

  Number of free parameters                         11
  Akaike (AIC)                                 363.854
  Bayesian (BIC)                               392.942
  Sample-size adjusted Bayesian (BIC)          358.193

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
    NUMPROCE (a1)    -0.476    0.066   -7.218    0.000   -0.476   -0.573
    ACTROWPO (a2)    -0.003    0.069   -0.045    0.964   -0.003   -0.004
    PCTUPDAT (a4)     0.110    0.075    1.458    0.145    0.110    0.127
    PCTREAD  (a5)     0.021    0.089    0.240    0.811    0.021    0.021
  MAXMPL ~
    ATP      (b1)     0.086    0.095    0.905    0.365    0.086    0.101
    NUMPROCE (c2)     0.257    0.078    3.300    0.001    0.257    0.366
    ACTROWPO (c3)     0.073    0.067    1.096    0.273    0.073    0.099
    PCTUPDAT (c4)    -0.139    0.074   -1.892    0.059   -0.139   -0.190
    PCTREAD  (c5)     0.019    0.086    0.222    0.824    0.019    0.022

Variances:
    ATP               0.069    0.010                      0.069    0.652
    MAXMPL            0.064    0.009                      0.064    0.847

Defined parameters:
    INT_3             0.001    0.033    0.045    0.964    0.001    0.002

R-Square:

    ATP               0.348
    MAXMPL            0.153

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
-0.37304 -0.20674 -0.00248  0.12550  0.56070 

Coefficients:
                          Estimate Std. Error t value Pr(>|t|)    
(Intercept)               0.333113   0.074031   4.500 1.87e-05 ***
NUMPROCESSORS            -0.480157   0.113389  -4.235 5.17e-05 ***
ACTROWPOOL               -0.006865   0.103183  -0.067    0.947    
PCTREAD                   0.021431   0.092146   0.233    0.817    
PCTUPDATE                 0.109981   0.077681   1.416    0.160    
NUMPROCESSORS:ACTROWPOOL  0.009146   0.181665   0.050    0.960    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.2699 on 98 degrees of freedom
Multiple R-squared:  0.3483,	Adjusted R-squared:  0.3151 
F-statistic: 10.48 on 5 and 98 DF,  p-value: 4.499e-08

### regression on MAXMPL 
out.fit <- lm(MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + PCTREAD, data = y)
summary(out.fit)

Call:
lm(formula = MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + 
    PCTREAD, data = y)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.58696 -0.06604  0.03481  0.11962  0.43043 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept)    0.47690    0.06964   6.848 6.62e-10 ***
ATP            0.08573    0.09757   0.879  0.38173    
ACTROWPOOL     0.07296    0.06859   1.064  0.29007    
NUMPROCESSORS  0.25727    0.08032   3.203  0.00183 ** 
PCTUPDATE     -0.13918    0.07579  -1.836  0.06934 .  
PCTREAD        0.01922    0.08903   0.216  0.82951    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.2607 on 98 degrees of freedom
Multiple R-squared:  0.153,	Adjusted R-squared:  0.1098 
F-statistic: 3.542 on 5 and 98 DF,  p-value: 0.005501

