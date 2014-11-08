# mysql
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
# ATP normalization
mysql <- subset(x, x$DBMS=='mysql')
mysql$ATP = (mysql$ATP-min(mysql$ATP))/(max(mysql$ATP)-min(mysql$ATP))
mysql$MAXMPL = (mysql$MAXMPL-min(mysql$MAXMPL))/(max(mysql$MAXMPL)-min(mysql$MAXMPL))
x = rbind(mysql) 
x$ACTROWPOOL = (x$ACTROWPOOL-min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)-min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD-min(x$PCTREAD))/(max(x$PCTREAD)-min(x$PCTREAD))
x$PCTUPDATE = (x$PCTUPDATE-min(x$PCTUPDATE))/(max(x$PCTUPDATE)-min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS-min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)-min(x$NUMPROCESSORS))

> cor(x$NUMPROCESSORS, x$ATP)
[1] -0.06130778
> cor(x$PCTREAD, x$ATP)
[1] 0.1141366
> cor(x$PCTUPDATE, x$ATP)
[1] 0.00436664
> cor(x$ACTROWPOOL, x$ATP)
[1] 0.2523362
> cor(x$PK, x$ATP)
[1] -0.7105615

PK
ACTROWPOOL
PCTREAD
NUMPROCESSORS
PCTUPDATE

> cor(x$ATP, x$MAXMPL)
[1] -0.3740904
> cor(x$NUMPROCESSORS, x$MAXMPL)
[1] -0.04977185
> cor(x$PCTREAD, x$MAXMPL)
[1] -0.2984482
> cor(x$PCTUPDATE, x$MAXMPL)
[1] 0.4670519
> cor(x$ACTROWPOOL, x$MAXMPL)
[1] -0.1396393
> cor(x$PK, x$MAXMPL)
[1] 0.1011755

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

lavaan (0.5-17) converged normally after  28 iterations

  Number of observations                           201

  Estimator                                         ML
  Minimum Function Test Statistic                0.000
  Degrees of freedom                                 0
  Minimum Function Value               0.0000000000000

Model test baseline model:

  Minimum Function Test Statistic              291.089
  Degrees of freedom                                11
  P-value                                        0.000

User model versus baseline model:

  Comparative Fit Index (CFI)                    1.000
  Tucker-Lewis Index (TLI)                       1.000

Loglikelihood and Information Criteria:

  Loglikelihood user model (H0)               -362.081
  Loglikelihood unrestricted model (H1)       -362.081

  Number of free parameters                         13
  Akaike (AIC)                                 750.161
  Bayesian (BIC)                               793.104
  Sample-size adjusted Bayesian (BIC)          751.918

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
    NUMPROCE (a1)    -0.029    0.027   -1.061    0.289   -0.029   -0.049
    ACTROWPO (a2)     0.145    0.028    5.114    0.000    0.145    0.235
    PK       (a3)    -0.326    0.021  -15.347    0.000   -0.326   -0.705
    PCTUPDAT (a4)     0.057    0.031    1.854    0.064    0.057    0.092
    PCTREAD  (a5)     0.108    0.042    2.597    0.009    0.108    0.129
  MAXMPL ~
    ATP      (b1)    -1.091    0.135   -8.101    0.000   -1.091   -0.657
    NUMPROCE (c2)    -0.067    0.052   -1.275    0.202   -0.067   -0.067
    ACTROWPO (c3)     0.009    0.058    0.163    0.871    0.009    0.009
    PCTUPDAT (c4)     0.482    0.059    8.143    0.000    0.482    0.470
    PCTREAD  (c5)    -0.074    0.081   -0.909    0.364   -0.074   -0.053
    PK       (c6)    -0.303    0.060   -5.068    0.000   -0.303   -0.394

Variances:
    ATP               0.023    0.002                      0.023    0.422
    MAXMPL            0.082    0.008                      0.082    0.557

Defined parameters:
    INT_1            -0.019    0.010   -1.830    0.067   -0.019   -0.065
    INT_2            -0.035    0.014   -2.568    0.010   -0.035   -0.091
    INT_3            -0.004    0.004   -1.047    0.295   -0.004   -0.011

R-Square:

    ATP               0.578
    MAXMPL            0.443

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
-0.27727 -0.06939 -0.01080  0.06056  0.37485 

Coefficients:
                         Estimate Std. Error t value Pr(>|t|)    
(Intercept)               0.48913    0.02638  18.541  < 2e-16 ***
NUMPROCESSORS            -0.04166    0.03606  -1.155 0.249422    
ACTROWPOOL                0.12351    0.03253   3.797 0.000196 ***
PK                       -0.47990    0.02846 -16.865  < 2e-16 ***
PCTREAD                   0.18894    0.04355   4.338 2.32e-05 ***
PCTUPDATE                -0.14994    0.03336  -4.495 1.20e-05 ***
NUMPROCESSORS:ACTROWPOOL  0.02409    0.05851   0.412 0.681017    
PK:PCTREAD               -0.20625    0.06724  -3.068 0.002470 ** 
PK:PCTUPDATE              0.43365    0.04879   8.889 4.50e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.1188 on 192 degrees of freedom
Multiple R-squared:  0.7478,	Adjusted R-squared:  0.7373 
F-statistic: 71.15 on 8 and 192 DF,  p-value: < 2.2e-16

### regression on MAXMPL 
out.fit <- lm(MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + PCTREAD, data = x)
summary(out.fit)

Call:
lm(formula = MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + 
    PCTREAD, data = x)

Residuals:
    Min      1Q  Median      3Q     Max 
-0.7811 -0.1864  0.0650  0.2440  0.5675 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept)    0.81012    0.05864  13.816  < 2e-16 ***
ATP           -0.58942    0.09848  -5.985 1.02e-08 ***
ACTROWPOOL    -0.05869    0.06041  -0.972    0.332    
NUMPROCESSORS -0.05395    0.05641  -0.956    0.340    
PCTUPDATE      0.44395    0.06331   7.013 3.74e-11 ***
PCTREAD       -0.12293    0.08673  -1.417    0.158    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.309 on 195 degrees of freedom
Multiple R-squared:  0.3719,	Adjusted R-squared:  0.3558 
F-statistic: 23.09 on 5 and 195 DF,  p-value: < 2.2e-16

### mediation of NUMPROCESSORS via ATP on MAXMPL 
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            0.01765     -0.00813      0.04572    0.19
	ADE            -0.05456     -0.16248      0.05625    0.33
	Total Effect   -0.03691     -0.15074      0.08208    0.54
	Prop. Mediated -0.14346     -3.37185      4.17607    0.69

	Sample Size Used: 201 


	Simulations: 1000 

### moderated mediation of NUMPROCESSORS by ACTROWPOOL through ATP  on MAXMPL
test.modmed(med.out, covariates.1 = list (x$ACTROWPOOL < 0.5), covariates.2 = list (x$x$ACTROWPOOL >= 0.5), data = x)

		Test of ACME(covariates.1) - ACME(covariates.2) = 0

	data:  estimates from med.out
	ACME(covariates.1) - ACME(covariates.2) = 0, p-value = 0.976
	alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.03502385  0.04104264


		Test of ADE(covariates.1) - ADE(covariates.2) = 0

	data:  estimates from med.out
	ADE(covariates.1) - ADE(covariates.2) = 0.0048, p-value = 0.938
	alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.1521247  0.1492533


###  mediation of PCTREAD via ATP on MAXMPL 
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTREAD")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.05279     -0.09396     -0.01473    0.01
	ADE            -0.12299     -0.29239      0.05124    0.18
	Total Effect   -0.17579     -0.34928     -0.00184    0.05
	Prop. Mediated  0.28271     -0.01453      1.60526    0.06

	Sample Size Used: 201 


	Simulations: 1000

### moderated mediation of NUMPROCESSORS by PK through ATP on MAXMPL
test.modmed(med.out, covariates.1 = list (x$PK == 1), covariates.2 = list (x$PK == 0), data = x)

		Test of ACME(covariates.1) - ACME(covariates.2) = 0

	data:  estimates from med.out
	ACME(covariates.1) - ACME(covariates.2) = 8e-04, p-value = 0.99
	alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.05826371  0.06179250


		Test of ADE(covariates.1) - ADE(covariates.2) = 0

	data:  estimates from med.out
	ADE(covariates.1) - ADE(covariates.2) = 0.0032, p-value = 0.976
	alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.2430339  0.2292208


###  mediation of PCTUPDATE via ATP on MAXMPL 
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.03265     -0.06552     -0.00365    0.02
	ADE             0.44295      0.32370      0.57179    0.00
	Total Effect    0.41030      0.29028      0.53905    0.00
	Prop. Mediated -0.07747     -0.18780     -0.00911    0.02

	Sample Size Used: 201

### moderated mediation of PCTUPDATE by PK through ATP on MAXMPL
test.modmed(med.out, covariates.1 = list (x$PK == 1), covariates.2 = list (x$PK == 0), data = x)

	Test of ACME(covariates.1) - ACME(covariates.2) = 0

data:  estimates from med.out
ACME(covariates.1) - ACME(covariates.2) = 0.0012, p-value = 0.976
alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
95 percent confidence interval:
 -0.04132840  0.04530286


	Test of ADE(covariates.1) - ADE(covariates.2) = 0

data:  estimates from med.out
ADE(covariates.1) - ADE(covariates.2) = -0.0056, p-value = 0.962
alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
95 percent confidence interval:
 -0.1809940  0.1616833

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



lavaan (0.5-17) converged normally after  34 iterations

  Number of observations                           106

  Estimator                                         ML
  Minimum Function Test Statistic                0.000
  Degrees of freedom                                 0
  Minimum Function Value               0.0000000000000

Model test baseline model:

  Minimum Function Test Statistic              286.037
  Degrees of freedom                                 9
  P-value                                        0.000

User model versus baseline model:

  Comparative Fit Index (CFI)                    1.000
  Tucker-Lewis Index (TLI)                       1.000

Loglikelihood and Information Criteria:

  Loglikelihood user model (H0)                 16.149
  Loglikelihood unrestricted model (H1)         16.149

  Number of free parameters                         11
  Akaike (AIC)                                 -10.297
  Bayesian (BIC)                                19.001
  Sample-size adjusted Bayesian (BIC)          -15.752

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
    NUMPROCE (a1)    -0.066    0.017   -3.925    0.000   -0.066   -0.216
    ACTROWPO (a2)     0.011    0.017    0.652    0.514    0.011    0.036
    PCTUPDAT (a4)    -0.149    0.018   -8.078    0.000   -0.149   -0.479
    PCTREAD  (a5)     0.200    0.024    8.287    0.000    0.200    0.493
  MAXMPL ~
    ATP      (b1)    -2.188    0.273   -8.016    0.000   -2.188   -0.638
    NUMPROCE (c2)    -0.091    0.051   -1.798    0.072   -0.091   -0.087
    ACTROWPO (c3)     0.013    0.048    0.276    0.783    0.013    0.012
    PCTUPDAT (c4)     0.470    0.066    7.116    0.000    0.470    0.439
    PCTREAD  (c5)     0.235    0.087    2.700    0.007    0.235    0.169

Variances:
    ATP               0.004    0.001                      0.004    0.317
    MAXMPL            0.034    0.005                      0.034    0.212

Defined parameters:
    INT_3            -0.001    0.001   -0.648    0.517   -0.001   -0.008

R-Square:

    ATP               0.683
    MAXMPL            0.788


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
-0.17805 -0.04206  0.01137  0.04010  0.24237 

Coefficients:
                          Estimate Std. Error t value Pr(>|t|)    
(Intercept)               0.562327   0.018210  30.880  < 2e-16 ***
NUMPROCESSORS            -0.074077   0.029201  -2.537   0.0127 *  
ACTROWPOOL                0.004819   0.025767   0.187   0.8520    
PCTREAD                   0.200780   0.025004   8.030 1.96e-12 ***
PCTUPDATE                -0.149323   0.019028  -7.847 4.83e-12 ***
NUMPROCESSORS:ACTROWPOOL  0.016064   0.046976   0.342   0.7331    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.06776 on 100 degrees of freedom
Multiple R-squared:  0.6835,	Adjusted R-squared:  0.6677 
F-statistic:  43.2 on 5 and 100 DF,  p-value: < 2.2e-16

### regression on MAXMPL 
out.fit <- lm(MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + PCTREAD, data = y)
summary(out.fit)

Call:
lm(formula = MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + 
    PCTREAD, data = y)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.48420 -0.13782 -0.02185  0.11329  0.78988 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept)    1.61026    0.16318   9.868  < 2e-16 ***
ATP           -2.18768    0.28097  -7.786 6.53e-12 ***
ACTROWPOOL     0.01337    0.04988   0.268   0.7892    
NUMPROCESSORS -0.09095    0.05208  -1.746   0.0839 .  
PCTUPDATE      0.46997    0.06799   6.912 4.54e-10 ***
PCTREAD        0.23464    0.08947   2.622   0.0101 *  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.1905 on 100 degrees of freedom
Multiple R-squared:  0.7876,	Adjusted R-squared:  0.7769 
F-statistic: 74.15 on 5 and 100 DF,  p-value: < 2.2e-16



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


  Number of observations                            95

  Estimator                                         ML
  Minimum Function Test Statistic                0.000
  Degrees of freedom                                 0

Model test baseline model:

  Minimum Function Test Statistic               88.002
  Degrees of freedom                                 9
  P-value                                        0.000

User model versus baseline model:

  Comparative Fit Index (CFI)                    1.000
  Tucker-Lewis Index (TLI)                       1.000

Loglikelihood and Information Criteria:

  Loglikelihood user model (H0)               -102.773
  Loglikelihood unrestricted model (H1)       -102.773

  Number of free parameters                         11
  Akaike (AIC)                                 227.546
  Bayesian (BIC)                               255.638
  Sample-size adjusted Bayesian (BIC)          220.909

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
    NUMPROCE (a1)     0.007    0.036    0.189    0.850    0.007    0.013
    ACTROWPO (a2)     0.269    0.038    7.146    0.000    0.269    0.498
    PCTUPDAT (a4)     0.287    0.041    7.018    0.000    0.287    0.529
    PCTREAD  (a5)     0.004    0.059    0.074    0.941    0.004    0.006
  MAXMPL ~
    ATP      (b1)    -0.353    0.252   -1.401    0.161   -0.353   -0.198
    NUMPROCE (c2)    -0.132    0.087   -1.508    0.131   -0.132   -0.145
    ACTROWPO (c3)    -0.183    0.115   -1.601    0.109   -0.183   -0.191
    PCTUPDAT (c4)     0.093    0.124    0.755    0.450    0.093    0.097
    PCTREAD  (c5)    -0.200    0.145   -1.380    0.167   -0.200   -0.144

Variances:
    ATP               0.019    0.003                      0.019    0.456
    MAXMPL            0.112    0.016                      0.112    0.868

Defined parameters:
    INT_3             0.002    0.010    0.189    0.850    0.002    0.007

R-Square:

    ATP               0.544
    MAXMPL            0.132

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
-0.26232 -0.10215 -0.00793  0.08492  0.32454 

Coefficients:
                          Estimate Std. Error t value Pr(>|t|)    
(Intercept)              -0.073667   0.040882  -1.802   0.0749 .  
NUMPROCESSORS            -0.008742   0.060181  -0.145   0.8848    
ACTROWPOOL                0.255996   0.055568   4.607 1.36e-05 ***
PCTREAD                   0.005835   0.061009   0.096   0.9240    
PCTUPDATE                 0.286622   0.042186   6.794 1.19e-09 ***
NUMPROCESSORS:ACTROWPOOL  0.031914   0.098524   0.324   0.7468    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.1407 on 89 degrees of freedom
Multiple R-squared:  0.5445,	Adjusted R-squared:  0.5189 
F-statistic: 21.27 on 5 and 89 DF,  p-value: 6.124e-14


### regression on MAXMPL 
out.fit <- lm(MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + PCTREAD, data = y)
summary(out.fit)

Call:
lm(formula = MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + 
    PCTREAD, data = y)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.81845 -0.18794  0.09658  0.23426  0.50322 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept)    0.94258    0.09069  10.393   <2e-16 ***
ATP           -0.35301    0.26031  -1.356    0.178    
ACTROWPOOL    -0.18340    0.11837  -1.549    0.125    
NUMPROCESSORS -0.13165    0.09017  -1.460    0.148    
PCTUPDATE      0.09338    0.12773   0.731    0.467    
PCTREAD       -0.19973    0.14949  -1.336    0.185    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.3457 on 89 degrees of freedom
Multiple R-squared:  0.1317,	Adjusted R-squared:  0.08293 
F-statistic:   2.7 on 5 and 89 DF,  p-value: 0.02555
