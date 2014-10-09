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

library(lavaan)
thrashing_model <- '
     # mediator
      ATP ~ a1*NUMPROCESSORS+a2*ACTROWPOOL+a3*PK+a4*PCTUPDATE+a5*PCTREAD
    # dependent variable
      MAXMPL ~ b1*ATP + c2*NUMPROCESSORS + c3*ACTROWPOOL + c4*PCTUPDATE + c5*PCTREAD + c6*PK
    # interactions
     INT_1 := a3*a4
     '
fit <- sem(thrashing_model, data = x)
summary(fit, standardized=TRUE, rsq=T) 

	lavaan (0.5-17) converged normally after  28 iterations

	  Number of observations                           199

	  Estimator                                         ML
	  Minimum Function Test Statistic                0.001
	  Degrees of freedom                                 1
	  P-value (Chi-square)                           0.982

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
	    ATP      (b1)    -0.385    0.193   -1.990    0.047   -0.385   -0.135
	    NUMPROCE (c2)    -0.461    0.069   -6.638    0.000   -0.461   -0.415
	    ACTROWPO (c3)     0.025    0.073    0.350    0.726    0.025    0.022
	    PCTUPDAT (c4)    -0.256    0.083   -3.075    0.002   -0.256   -0.223
	    PCTREAD  (c5)     0.004    0.090    0.044    0.965    0.004    0.003

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

library(mediation)
med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + PK + PCTREAD + PCTUPDATE + PCTUPDATE:PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + PK + PCTREAD + 
	    PCTUPDATE + PCTUPDATE:PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.19661 -0.04690 -0.00500  0.02983  0.76893 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.17646    0.02326   7.586 1.39e-12 ***
	NUMPROCESSORS  0.05818    0.02116   2.750  0.00653 ** 
	ACTROWPOOL     0.03676    0.02217   1.658  0.09897 .  
	PK            -0.22894    0.02379  -9.625  < 2e-16 ***
	PCTREAD        0.05623    0.02729   2.061  0.04068 *  
	PCTUPDATE     -0.27962    0.03303  -8.465 6.51e-15 ***
	PK:PCTUPDATE   0.30631    0.04359   7.027 3.59e-11 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1158 on 192 degrees of freedom
	Multiple R-squared:  0.436,	Adjusted R-squared:  0.4184 
	F-statistic: 24.74 on 6 and 192 DF,  p-value: < 2.2e-16

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

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		        Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.022240    -0.057372    -0.000261    0.04
	ADE            -0.462040    -0.597996    -0.326272    0.00
	Total Effect   -0.484281    -0.620939    -0.346578    0.00
	Prop. Mediated  0.042754     0.000483     0.124462    0.04

	Sample Size Used: 199 


	Simulations: 1000

test.modmed(med.out, covariates.1 = list (x$ACTROWPOOL < 0.5), covariates.2 = list (x$x$ACTROWPOOL >= 0.5), data = x)

	Test of ACME(covariates.1) - ACME(covariates.2) = 0

	data:  estimates from med.out
	ACME(covariates.1) - ACME(covariates.2) = -3e-04, p-value = 0.992
	alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.04011533  0.04144188


		Test of ADE(covariates.1) - ADE(covariates.2) = 0

	data:  estimates from med.out
	ADE(covariates.1) - ADE(covariates.2) = 0.0043, p-value = 0.956
	alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.1944299  0.1909630


med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTREAD")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.02113     -0.05713      0.00231    0.09
	ADE             0.00463     -0.17978      0.18431    0.96
	Total Effect   -0.01650     -0.20764      0.15851    0.85
	Prop. Mediated  0.07080     -4.12045      3.31715    0.86

	Sample Size Used: 199 


	Simulations: 1000

test.modmed(med.out, covariates.1 = list (x$PK == 1), covariates.2 = list (x$PK == 0), data = x)

		Test of ACME(covariates.1) - ACME(covariates.2) = 0

	data:  estimates from med.out
	ACME(covariates.1) - ACME(covariates.2) = 0.0012, p-value = 0.986
	alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.04515186  0.04837604


		Test of ADE(covariates.1) - ADE(covariates.2) = 0

	data:  estimates from med.out
	ADE(covariates.1) - ADE(covariates.2) = 0.0069, p-value = 0.94
	alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.2417825  0.2446658

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            0.04852      0.00231      0.10704    0.04
	ADE            -0.25714     -0.43297     -0.08653    0.00
	Total Effect   -0.20862     -0.37666     -0.04682    0.01
	Prop. Mediated -0.22565     -1.26202     -0.00417    0.05

	Sample Size Used: 199 


	Simulations: 1000 

test.modmed(med.out, covariates.1 = list (x$PK == 1), covariates.2 = list (x$PK == 0), data = x)

		Test of ACME(covariates.1) - ACME(covariates.2) = 0

	data:  estimates from med.out
	ACME(covariates.1) - ACME(covariates.2) = 8e-04, p-value = 0.94
	alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.07135794  0.07173333


		Test of ADE(covariates.1) - ADE(covariates.2) = 0

	data:  estimates from med.out
	ADE(covariates.1) - ADE(covariates.2) = 0.0024, p-value = 0.972
	alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.2397969  0.2381966
