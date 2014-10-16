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
      ATP ~ a1*NUMPROCESSORS+a2*ACTROWPOOL+a3*PK+a4*PCTUPDATE
    # dependent variable
      MAXMPL ~ b1*ATP
   # interactions
       INT_1 := a3*a4
       INT_2 := a1*a2
     '
fit <- sem(thrashing_model, estimator="DWLS", data = x)
summary(fit, fit.measures = TRUE, standardized=TRUE, rsq=T)



library(lavaan)
thrashing_model <- '
     # mediator
      ATP ~ a1*NUMPROCESSORS+a2*ACTROWPOOL+a3*PK+a4*PCTUPDATE
    # dependent variable
      MAXMPL ~ b1*ATP
   # interactions
       INT_1 := a3*a4
       INT_2 := a1*a2
     '
fit <- sem(thrashing_model, estimator="DWLS", data = x)
summary(fit, fit.measures = TRUE, standardized=TRUE, rsq=T)

	lavaan (0.5-17) converged normally after  45 iterations

	  Number of observations                           197

	  Estimator                                       DWLS
	  Minimum Function Test Statistic               42.819
	  Degrees of freedom                                 4
	  P-value (Chi-square)                           0.000

	Model test baseline model:

	  Minimum Function Test Statistic               71.420
	  Degrees of freedom                                 9
	  P-value                                        0.000

	User model versus baseline model:

	  Comparative Fit Index (CFI)                    0.378
	  Tucker-Lewis Index (TLI)                      -0.399

	Root Mean Square Error of Approximation:

	  RMSEA                                          0.223
	  90 Percent Confidence Interval          0.165  0.285
	  P-value RMSEA <= 0.05                          0.000

	Standardized Root Mean Square Residual:

	  SRMR                                           0.098

	Parameter estimates:

	  Information                                 Expected
	  Standard Errors                             Standard

		           Estimate  Std.err  Z-value  P(>|z|)   Std.lv  Std.all
	Regressions:
	  ATP ~
	    NUMPROCE (a1)     0.081    0.037    2.172    0.030    0.081    0.164
	    ACTROWPO (a2)     0.041    0.036    1.146    0.252    0.041    0.077
	    PK       (a3)     0.052    0.029    1.807    0.071    0.052    0.132
	    PCTUPDAT (a4)    -0.125    0.038   -3.325    0.001   -0.125   -0.233
	  MAXMPL ~
	    ATP      (b1)     0.145    0.079    1.828    0.068    0.145    0.094

	Covariances:
	  NUMPROCESSORS ~~
	    ACTROWPOOL        0.001    0.011    0.062    0.950    0.001    0.004
	    PK                0.007    0.014    0.465    0.642    0.007    0.033
	    PCTUPDATE         0.003    0.011    0.260    0.795    0.003    0.019
	  ACTROWPOOL ~~
	    PK                0.001    0.013    0.087    0.931    0.001    0.006
	    PCTUPDATE        -0.001    0.010   -0.087    0.930   -0.001   -0.006
	  PK ~~
	    PCTUPDATE        -0.007    0.013   -0.522    0.602   -0.007   -0.037

	Variances:
	    ATP               0.035    0.011                      0.035    0.893
	    MAXMPL            0.091    0.010                      0.091    0.991
	    NUMPROCESSORS     0.162    0.009                      0.162    1.000
	    ACTROWPOOL        0.140    0.008                      0.140    1.000
	    PK                0.251    0.001                      0.251    1.000
	    PCTUPDATE         0.136    0.009                      0.136    1.000

	Defined parameters:
	    INT_1            -0.007    0.004   -1.619    0.105   -0.007   -0.031
	    INT_2             0.003    0.003    1.012    0.311    0.003    0.013

	R-Square:

	    ATP               0.107
	    MAXMPL            0.009
## for db2
library(lavaan)
thrashing_model <- '
     # mediator
      ATP ~ a4*PCTUPDATE+a5*PCTREAD+a3*PK
    # dependent variable
      MAXMPL ~ b1*ATP + c2*NUMPROCESSORS + c4*PCTUPDATE
    # interactions
     '
fit <- sem(thrashing_model, estimator="DWLS", orthogonal = TRUE, data = x)
summary(fit, fit.measures = TRUE, standardized=TRUE, rsq=T) 


library(lavaan)
thrashing_model <- '
     # mediator
      ATP ~ a1*NUMPROCESSORS+a4*PCTUPDATE+a5*PCTREAD
    # dependent variable
      MAXMPL ~ b1*ATP + c2*NUMPROCESSORS + c3*ACTROWPOOL + c4*PCTUPDATE
    # interactions
     '
#fit <- sem(thrashing_model, estimator="DWLS", orthogonal = TRUE, data = x)
fit <- sem(thrashing_model, data = x)
summary(fit, fit.measures = TRUE, standardized=TRUE, rsq=T) 

lavaan (0.5-17) converged normally after  21 iterations

  Number of observations                           197

  Estimator                                         ML
  Minimum Function Test Statistic                2.936
  Degrees of freedom                                 2
  P-value (Chi-square)                           0.230

Model test baseline model:

  Minimum Function Test Statistic               77.657
  Degrees of freedom                                 9
  P-value                                        0.000

User model versus baseline model:

  Comparative Fit Index (CFI)                    0.986
  Tucker-Lewis Index (TLI)                       0.939

Loglikelihood and Information Criteria:

  Loglikelihood user model (H0)               -266.687
  Loglikelihood unrestricted model (H1)       -265.219

  Number of free parameters                          9
  Akaike (AIC)                                 551.373
  Bayesian (BIC)                               580.922
  Sample-size adjusted Bayesian (BIC)          552.410

Root Mean Square Error of Approximation:

  RMSEA                                          0.049
  90 Percent Confidence Interval          0.000  0.158
  P-value RMSEA <= 0.05                          0.385

Standardized Root Mean Square Residual:

  SRMR                                           0.023

Parameter estimates:

  Information                                 Expected
  Standard Errors                             Standard

                   Estimate  Std.err  Z-value  P(>|z|)   Std.lv  Std.all
Regressions:
  ATP ~
    NUMPROCE (a1)     0.072    0.032    2.236    0.025    0.072    0.148
    PCTUPDAT (a4)    -0.197    0.038   -5.134    0.000   -0.197   -0.372
    PCTREAD  (a5)    -0.155    0.045   -3.479    0.001   -0.155   -0.252
  MAXMPL ~
    ATP      (b1)     0.262    0.104    2.530    0.011    0.262    0.168
    NUMPROCE (c2)     0.192    0.048    3.961    0.000    0.192    0.254
    ACTROWPO (c3)    -0.130    0.052   -2.510    0.012   -0.130   -0.159
    PCTUPDAT (c4)     0.262    0.054    4.809    0.000    0.262    0.317

Variances:
    ATP               0.033    0.003                      0.033    0.857
    MAXMPL            0.073    0.007                      0.073    0.795

R-Square:

    ATP               0.143
    MAXMPL            0.205








library(lavaan)
thrashing_model <- '
     # mediator
      ATP ~ a1*NUMPROCESSORS+a4*PCTUPDATE
    # dependent variable
      MAXMPL ~ b1*ATP + c3*ACTROWPOOL+ c5*PK
    # interactions
    # INT_1 := a3*a4
    # INT_2 := a3*a5
     #INT_3 := a1*a2
     '
fit <- sem(thrashing_model, data = x)
summary(fit, fit.measures = TRUE, standardized=TRUE, rsq=T) 

lavaan (0.5-17) converged normally after  21 iterations

  Number of observations                           197

  Estimator                                         ML
  Minimum Function Test Statistic                2.936
  Degrees of freedom                                 2
  P-value (Chi-square)                           0.230

Model test baseline model:

  Minimum Function Test Statistic               77.657
  Degrees of freedom                                 9
  P-value                                        0.000

User model versus baseline model:

  Comparative Fit Index (CFI)                    0.986
  Tucker-Lewis Index (TLI)                       0.939

Loglikelihood and Information Criteria:

  Loglikelihood user model (H0)               -266.687
  Loglikelihood unrestricted model (H1)       -265.219

  Number of free parameters                          9
  Akaike (AIC)                                 551.373
  Bayesian (BIC)                               580.922
  Sample-size adjusted Bayesian (BIC)          552.410

Root Mean Square Error of Approximation:

  RMSEA                                          0.049
  90 Percent Confidence Interval          0.000  0.158
  P-value RMSEA <= 0.05                          0.385

Standardized Root Mean Square Residual:

  SRMR                                           0.023

Parameter estimates:

  Information                                 Expected
  Standard Errors                             Standard

                   Estimate  Std.err  Z-value  P(>|z|)   Std.lv  Std.all
Regressions:
  ATP ~
    NUMPROCE (a1)     0.072    0.032    2.236    0.025    0.072    0.148
    PCTUPDAT (a4)    -0.197    0.038   -5.134    0.000   -0.197   -0.372
    PCTREAD  (a5)    -0.155    0.045   -3.479    0.001   -0.155   -0.252
  MAXMPL ~
    ATP      (b1)     0.262    0.104    2.530    0.011    0.262    0.168
    NUMPROCE (c2)     0.192    0.048    3.961    0.000    0.192    0.254
    ACTROWPO (c3)    -0.130    0.052   -2.510    0.012   -0.130   -0.159
    PCTUPDAT (c4)     0.262    0.054    4.809    0.000    0.262    0.317

Variances:
    ATP               0.033    0.003                      0.033    0.857
    MAXMPL            0.073    0.007                      0.073    0.795

R-Square:

    ATP               0.143
    MAXMPL            0.205

library(lavaan)
thrashing_model <- '
     # mediator
      ATP ~ a1*NUMPROCESSORS+c3*ACTROWPOOL+a3*PK+a4*PCTUPDATE+a5*PCTREAD
    # dependent variable
      MAXMPL ~ c1*ATP+c2*NUMPROCESSORS+c3*ACTROWPOOL+c4*PK+c5*PCTUPDATE+c6*PCTREAD
    # interactions
     #INT_1 := a3*a4
     #INT_2 := a3*a5
     #INT_3 := a1*a2
     '
fit <- sem(thrashing_model, estimator="DWLS", orthogonal = TRUE, data = x)
summary(fit, fit.measures = TRUE, standardized=TRUE, rsq=T) 

	lavaan (0.5-17) converged normally after  60 iterations

	  Number of observations                           197

	  Estimator                                       DWLS
	  Minimum Function Test Statistic               13.529
	  Degrees of freedom                                 4
	  P-value (Chi-square)                           0.009

	Model test baseline model:

	  Minimum Function Test Statistic               54.328
	  Degrees of freedom                                 9
	  P-value                                        0.000

	User model versus baseline model:

	  Comparative Fit Index (CFI)                    0.790
	  Tucker-Lewis Index (TLI)                       0.527

	Root Mean Square Error of Approximation:

	  RMSEA                                          0.110
	  90 Percent Confidence Interval          0.049  0.177
	  P-value RMSEA <= 0.05                          0.051

	Standardized Root Mean Square Residual:

	  SRMR                                           0.204

	Parameter estimates:

	  Information                                 Expected
	  Standard Errors                             Standard

		           Estimate  Std.err  Z-value  P(>|z|)   Std.lv  Std.all
	Regressions:
	  ATP ~
	    PK       (a3)     0.033    0.018    1.871    0.061    0.033    0.314
	    NUMPROCE (a2)     0.080    0.029    2.817    0.005    0.080    0.609
	    PCTREAD  (a4)    -0.064    0.023   -2.842    0.004   -0.064   -0.383
	  MAXMPL ~
	    ATP      (c1)     2.536    0.901    2.815    0.005    2.536    0.445
	    ACTROWPO (c2)    -0.129    0.060   -2.151    0.031   -0.129   -0.159

	Covariances:
	  PK ~~
	    NUMPROCESSORS     0.007    0.014    0.458    0.647    0.007    0.033
	    PCTREAD          -0.005    0.011   -0.468    0.640   -0.005   -0.033
	    ACTROWPOOL        0.004    0.013    0.282    0.778    0.004    0.020
	  NUMPROCESSORS ~~
	    PCTREAD           0.002    0.010    0.239    0.811    0.002    0.018
	    ACTROWPOOL        0.003    0.011    0.284    0.776    0.003    0.020
	  PCTREAD ~~
	    ACTROWPOOL       -0.004    0.008   -0.507    0.612   -0.004   -0.035

	Variances:
	    ATP               0.001    0.001                      0.001    0.372
	    MAXMPL            0.072    0.014                      0.072    0.781
	    PK                0.251    0.001                      0.251    1.000
	    NUMPROCESSORS     0.162    0.009                      0.162    1.000
	    PCTREAD           0.101    0.017                      0.101    1.000
	    ACTROWPOOL        0.140    0.008                      0.140    1.000

	Defined parameters:
	    INT_1            -0.002    0.001   -1.500    0.134   -0.002   -0.120

	R-Square:

	    ATP               0.628
	    MAXMPL            0.219


library(mediation)
med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + PK + PCTREAD + PCTUPDATE + PCTUPDATE:PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + 
	    PK + PCTREAD + PCTUPDATE + PCTUPDATE:PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.25541 -0.08356 -0.03340  0.03048  0.79176 

	Coefficients:
		                 Estimate Std. Error t value Pr(>|t|)   
	(Intercept)               0.05277    0.03966   1.331  0.18487   
	NUMPROCESSORS             0.05799    0.05355   1.083  0.28018   
	ACTROWPOOL                0.03278    0.04938   0.664  0.50757   
	PK                        0.08875    0.03631   2.445  0.01542 * 
	PCTREAD                  -0.14516    0.04483  -3.238  0.00142 **
	PCTUPDATE                -0.13091    0.05202  -2.517  0.01268 * 
	NUMPROCESSORS:ACTROWPOOL  0.02456    0.08613   0.285  0.77582   
	PK:PCTUPDATE             -0.12445    0.07022  -1.772  0.07795 . 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1808 on 189 degrees of freedom
	Multiple R-squared:  0.1761,	Adjusted R-squared:  0.1456 
	F-statistic: 5.772 on 7 and 189 DF,  p-value: 4.509e-06

out.fit <- lm(MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + PCTREAD + PK, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + 
	    PCTREAD + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.84778 -0.15428  0.06585  0.19442  0.49463 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.68322    0.05056  13.514  < 2e-16 ***
	ATP            0.21142    0.10874   1.944 0.053348 .  
	ACTROWPOOL    -0.12960    0.05227  -2.479 0.014030 *  
	NUMPROCESSORS  0.19427    0.04896   3.968 0.000103 ***
	PCTUPDATE      0.23047    0.06180   3.729 0.000253 ***
	PCTREAD       -0.07604    0.06941  -1.096 0.274681    
	PK             0.06358    0.03925   1.620 0.106894    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2726 on 190 degrees of freedom
	Multiple R-squared:  0.2178,	Adjusted R-squared:  0.1931 
	F-statistic: 8.817 on 6 and 190 DF,  p-value: 1.747e-08

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		        Estimate 95% CI Lower 95% CI Upper p-value
	ACME            0.015179    -0.000781     0.040339    0.08
	ADE             0.192678     0.096233     0.291490    0.00
	Total Effect    0.207857     0.114119     0.301586    0.00
	Prop. Mediated  0.066781    -0.004312     0.222802    0.08

	Sample Size Used: 197 


	Simulations: 1000

test.modmed(med.out, covariates.1 = list (x$ACTROWPOOL < 0.5), covariates.2 = list (x$x$ACTROWPOOL >= 0.5), data = x)

		Test of ACME(covariates.1) - ACME(covariates.2) = 0

	data:  estimates from med.out
	ACME(covariates.1) - ACME(covariates.2) = 4e-04, p-value = 0.974
	alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.02841169  0.03181880


		Test of ADE(covariates.1) - ADE(covariates.2) = 0

	data:  estimates from med.out
	ADE(covariates.1) - ADE(covariates.2) = -0.0033, p-value = 0.986
	alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.1461225  0.1302809

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.04046     -0.08942      0.00261    0.07
	ADE             0.23194      0.10808      0.35617    0.00
	Total Effect    0.19148      0.07770      0.30363    0.00
	Prop. Mediated -0.20344     -0.71760      0.01231    0.07

	Sample Size Used: 197 


	Simulations: 1000 

test.modmed(med.out, covariates.1 = list (x$PK == 1), covariates.2 = list (x$PK == 0), data = x)

		Test of ACME(covariates.1) - ACME(covariates.2) = 0

	data:  estimates from med.out
	ACME(covariates.1) - ACME(covariates.2) = 9e-04, p-value = 0.954
	alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.06202893  0.05972620


		Test of ADE(covariates.1) - ADE(covariates.2) = 0

	data:  estimates from med.out
	ADE(covariates.1) - ADE(covariates.2) = -0.0038, p-value = 0.978
	alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.1720626  0.1645096

