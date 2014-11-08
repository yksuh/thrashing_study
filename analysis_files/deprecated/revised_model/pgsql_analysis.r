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
      ATP ~ a1*NUMPROCESSORS+a3*PK+a4*PCTUPDATE
    # dependent variable
      MAXMPL ~ b1*ATP+c1*NUMPROCESSORS+c2*ACTROWPOOL+c3*PK+c4*PCTUPDATE+c5*PCTREAD
   # interactions
       INT_1 := a3*a4
     '
fit <- sem(thrashing_model, data = x)
summary(fit, fit.measures = TRUE, standardized=TRUE, rsq=T)

lavaan (0.5-17) converged normally after  28 iterations

  Number of observations                           191

  Estimator                                         ML
  Minimum Function Test Statistic               14.155
  Degrees of freedom                                 2
  P-value (Chi-square)                           0.001

Model test baseline model:

  Minimum Function Test Statistic              264.779
  Degrees of freedom                                11
  P-value                                        0.000

User model versus baseline model:

  Comparative Fit Index (CFI)                    0.952
  Tucker-Lewis Index (TLI)                       0.737

Loglikelihood and Information Criteria:

  Loglikelihood user model (H0)               -443.236
  Loglikelihood unrestricted model (H1)       -436.158

  Number of free parameters                         11
  Akaike (AIC)                                 908.472
  Bayesian (BIC)                               944.247
  Sample-size adjusted Bayesian (BIC)          909.403

Root Mean Square Error of Approximation:

  RMSEA                                          0.178
  90 Percent Confidence Interval          0.099  0.271
  P-value RMSEA <= 0.05                          0.006

Standardized Root Mean Square Residual:

  SRMR                                           0.034

Parameter estimates:

  Information                                 Expected
  Standard Errors                             Standard

                   Estimate  Std.err  Z-value  P(>|z|)   Std.lv  Std.all
Regressions:
  ATP ~
    NUMPROCE (a1)    -0.037    0.035   -1.045    0.296   -0.037   -0.055
    PK       (a3)    -0.147    0.028   -5.238    0.000   -0.147   -0.278
    PCTUPDAT (a4)    -0.430    0.037  -11.530    0.000   -0.430   -0.612
  MAXMPL ~
    ATP      (b1)     0.272    0.111    2.441    0.015    0.272    0.170
    NUMPROCE (c1)    -0.224    0.054   -4.119    0.000   -0.224   -0.211
    ACTROWPO (c2)    -0.062    0.056   -1.098    0.272   -0.062   -0.056
    PK       (c3)     0.563    0.046   12.157    0.000    0.563    0.665
    PCTUPDAT (c4)    -0.230    0.080   -2.877    0.004   -0.230   -0.204
    PCTREAD  (c5)    -0.163    0.070   -2.339    0.019   -0.163   -0.133

Variances:
    ATP               0.037    0.004                      0.037    0.537
    MAXMPL            0.088    0.009                      0.088    0.497

Defined parameters:
    INT_1             0.063    0.013    4.818    0.000    0.063    0.170

R-Square:

    ATP               0.463
    MAXMPL            0.503

#####

library(lavaan)
thrashing_model <- '
     # mediator
      ATP ~ a3*PK+a4*PCTUPDATE+a2*NUMPROCESSORS
    # dependent variable
      MAXMPL ~ b1*ATP + c2*NUMPROCESSORS + c4*PCTUPDATE + c5*PCTREAD + c6*PK
    # interactions
     INT_1 := a3*a4'
fit <- sem(thrashing_model, data = x)
summary(fit, standardized=TRUE, rsq=T) 



library(lavaan)
thrashing_model <- '
     # mediator
      ATP ~ a3*PK+a4*PCTUPDATE+a5*PCTREAD
    # dependent variable
      MAXMPL ~ b1*ATP + c2*NUMPROCESSORS + c4*PCTUPDATE + c5*PCTREAD + c6*PK
    # interactions
     INT_1 := a3*a4'
fit <- sem(thrashing_model, data = x)
summary(fit, standardized=TRUE, rsq=T) 

	lavaan (0.5-17) converged normally after  24 iterations

	  Number of observations                           191

	  Estimator                                         ML
	  Minimum Function Test Statistic                1.403
	  Degrees of freedom                                 1
	  P-value (Chi-square)                           0.236

	Parameter estimates:

	  Information                                 Expected
	  Standard Errors                             Standard

		           Estimate  Std.err  Z-value  P(>|z|)   Std.lv  Std.all
	Regressions:
	  ATP ~
	    PK       (a3)    -0.150    0.027   -5.515    0.000   -0.150   -0.283
	    PCTUPDAT (a4)    -0.363    0.040   -9.025    0.000   -0.363   -0.515
	    PCTREAD  (a5)     0.165    0.044    3.780    0.000    0.165    0.216
	  MAXMPL ~
	    ATP      (b1)     0.269    0.115    2.333    0.020    0.269    0.170
	    NUMPROCE (c2)    -0.224    0.054   -4.129    0.000   -0.224   -0.213
	    PCTUPDAT (c4)    -0.229    0.077   -2.988    0.003   -0.229   -0.205
	    PCTREAD  (c5)    -0.161    0.072   -2.231    0.026   -0.161   -0.133
	    PK       (c6)     0.564    0.047   12.055    0.000    0.564    0.669

	Variances:
	    ATP               0.035    0.004                      0.035    0.502
	    MAXMPL            0.089    0.009                      0.089    0.507

	Defined parameters:
	    INT_1             0.054    0.011    4.765    0.000    0.054    0.146

	R-Square:

	    ATP               0.498
	    MAXMPL            0.493






library(lavaan)
thrashing_model <- '
     # mediator
      ATP ~ a1*NUMPROCESSORS+a2*ACTROWPOOL+a3*PK+a4*PCTUPDATE+a5*PCTREAD
    # dependent variable
      MAXMPL ~ b1*ATP + c2*NUMPROCESSORS + c3*ACTROWPOOL + c4*PCTUPDATE + c5*PCTREAD + c6*PK
    # interactions
     INT_1 := a3*a4
     INT_3 := a1*a2'
fit <- sem(thrashing_model, data = x)
summary(fit, standardized=TRUE, rsq=T) 

	lavaan (0.5-17) converged normally after  27 iterations

	  Number of observations                           191

	  Estimator                                         ML
	  Minimum Function Test Statistic                0.000
	  Degrees of freedom                                 0
	  Minimum Function Value               0.0000000000000

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
	    INT_3            -0.000    0.001   -0.249    0.804   -0.000   -0.001

	R-Square:

	    ATP               0.501
	    MAXMPL            0.499

library(mediation)
med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + PK + PCTREAD + PCTUPDATE + PCTUPDATE:PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + 
	    PK + PCTREAD + PCTUPDATE + PCTUPDATE:PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.32910 -0.11070 -0.00706  0.10067  0.60201 

	Coefficients:
		                 Estimate Std. Error t value Pr(>|t|)    
	(Intercept)               0.40003    0.03803  10.519  < 2e-16 ***
	NUMPROCESSORS            -0.02624    0.05310  -0.494    0.622    
	ACTROWPOOL                0.02260    0.04834   0.468    0.641    
	PK                       -0.28703    0.03577  -8.025 1.19e-13 ***
	PCTREAD                   0.17070    0.04112   4.151 5.07e-05 ***
	PCTUPDATE                -0.52618    0.04791 -10.984  < 2e-16 ***
	NUMPROCESSORS:ACTROWPOOL -0.02250    0.08445  -0.266    0.790    
	PK:PCTUPDATE              0.38169    0.06860   5.564 9.25e-08 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1755 on 183 degrees of freedom
	Multiple R-squared:  0.5737,	Adjusted R-squared:  0.5573 
	F-statistic: 35.18 on 7 and 183 DF,  p-value: < 2.2e-16

out.fit <- lm(MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + PCTREAD + PK, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + 
	    PCTREAD + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.66634 -0.22952  0.03932  0.20326  0.83721 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.42892    0.06916   6.202 3.60e-09 ***
	ATP            0.27179    0.11775   2.308  0.02210 *  
	ACTROWPOOL    -0.06185    0.05742  -1.077  0.28281    
	NUMPROCESSORS -0.22381    0.05540  -4.040 7.85e-05 ***
	PCTUPDATE     -0.22990    0.07792  -2.950  0.00359 ** 
	PCTREAD       -0.16262    0.07349  -2.213  0.02814 *  
	PK             0.56311    0.04746  11.865  < 2e-16 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3022 on 184 degrees of freedom
	Multiple R-squared:  0.4985,	Adjusted R-squared:  0.4822 
	F-statistic: 30.49 on 6 and 184 DF,  p-value: < 2.2e-16

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.00975     -0.03204      0.00542    0.27
	ADE            -0.22259     -0.33153     -0.11140    0.00
	Total Effect   -0.23234     -0.33838     -0.12211    0.00
	Prop. Mediated  0.03674     -0.02823      0.16045    0.27

	Sample Size Used: 191 


	Simulations: 1000

test.modmed(med.out, covariates.1 = list (x$ACTROWPOOL < 0.5), covariates.2 = list (x$x$ACTROWPOOL >= 0.5), data = x)

		Test of ACME(covariates.1) - ACME(covariates.2) = 0

	data:  estimates from med.out
	ACME(covariates.1) - ACME(covariates.2) = -1e-04, p-value = 0.996
	alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.02918042  0.02823620


		Test of ADE(covariates.1) - ADE(covariates.2) = 0

	data:  estimates from med.out
	ADE(covariates.1) - ADE(covariates.2) = -7e-04, p-value = 0.986
	alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.1530285  0.1508995


med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            -0.0977      -0.1872      -0.0166    0.02
	ADE             -0.2326      -0.3876      -0.0909    0.00
	Total Effect    -0.3303      -0.4574      -0.2020    0.00
	Prop. Mediated   0.2905       0.0472       0.6399    0.02

	Sample Size Used: 191 


	Simulations: 1000 


test.modmed(med.out, covariates.1 = list (x$PK == 1), covariates.2 = list (x$PK == 0), data = x)

	Test of ACME(covariates.1) - ACME(covariates.2) = 0

	data:  estimates from med.out
	ACME(covariates.1) - ACME(covariates.2) = 0.0024, p-value = 0.948
	alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.1259795  0.1171565


		Test of ADE(covariates.1) - ADE(covariates.2) = 0

	data:  estimates from med.out
	ADE(covariates.1) - ADE(covariates.2) = 2e-04, p-value = 0.998
	alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.2391574  0.2081055

