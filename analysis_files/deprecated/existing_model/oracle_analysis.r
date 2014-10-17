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

### lavaan test
library(lavaan)
thrashing_model <- '
    # mediator
      ATP ~ a1*NUMPROCESSORS+a2*ACTROWPOOL+a3*PK+a4*PCTUPDATE+a5*PCTREAD
    # dependent variable
      MAXMPL ~ b1*ATP + c2*NUMPROCESSORS + c3*ACTROWPOOL + c4*PCTUPDATE + c5*PCTREAD
    # interactions
     INT_1 := a3*a4
     INT_2 := a3*a5
     INT_3 := a1*a2
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
	ACME           -0.022240    -0.057372    -0.000261    0.04
	ADE            -0.462040    -0.597996    -0.326272    0.00
	Total Effect   -0.484281    -0.620939    -0.346578    0.00
	Prop. Mediated  0.042754     0.000483     0.124462    0.04

	Sample Size Used: 199 


	Simulations: 1000

### moderated mediation of NUMPROCESSORS by ACTROWPOOL through ATP  on MAXMPL
test.modmed(med.out, covariates.1 = list (x$ACTROWPOOL < 0.5), covariates.2 = list (x$x$ACTROWPOOL >= 0.5), data = x)

		Test of ACME(covariates.1) - ACME(covariates.2) = 0

	data:  estimates from med.out
	ACME(covariates.1) - ACME(covariates.2) = 2e-04, p-value = 0.994
	alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.04049512  0.03867803


		Test of ADE(covariates.1) - ADE(covariates.2) = 0

	data:  estimates from med.out
	ADE(covariates.1) - ADE(covariates.2) = -4e-04, p-value = 0.978
	alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.1959408  0.1928798

###  mediation of PCTREAD via ATP on MAXMPL 
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTREAD")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.02189     -0.05890      0.00240    0.09
	ADE             0.00443     -0.17226      0.18973    0.97
	Total Effect   -0.01746     -0.19459      0.16665    0.84
	Prop. Mediated  0.08638     -3.14318      4.67299    0.83

	Sample Size Used: 199 


	Simulations: 1000 

### moderated mediation of NUMPROCESSORS by PK through ATP on MAXMPL
test.modmed(med.out, covariates.1 = list (x$PK == 1), covariates.2 = list (x$PK == 0), data = x)

		Test of ACME(covariates.1) - ACME(covariates.2) = 0

	data:  estimates from med.out
	ACME(covariates.1) - ACME(covariates.2) = 5e-04, p-value = 0.976
	alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.04826438  0.04806803


		Test of ADE(covariates.1) - ADE(covariates.2) = 0

	data:  estimates from med.out
	ADE(covariates.1) - ADE(covariates.2) = 0.0057, p-value = 0.974
	alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.2275165  0.2607655

###  mediation of PCTUPDATE via ATP on MAXMPL 
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            0.04688      0.00291      0.09937    0.04
	ADE            -0.25813     -0.42450     -0.10164    0.00
	Total Effect   -0.21125     -0.37553     -0.05667    0.00
	Prop. Mediated -0.21725     -0.92870     -0.01119    0.04

	Sample Size Used: 199 


Simulations: 1000

### moderated mediation of PCTUPDATE by PK through ATP on MAXMPL
test.modmed(med.out, covariates.1 = list (x$PK == 1), covariates.2 = list (x$PK == 0), data = x)

		Test of ACME(covariates.1) - ACME(covariates.2) = 0

	data:  estimates from med.out
	ACME(covariates.1) - ACME(covariates.2) = 6e-04, p-value = 0.96
	alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.07476223  0.07327457


		Test of ADE(covariates.1) - ADE(covariates.2) = 0

	data:  estimates from med.out
	ADE(covariates.1) - ADE(covariates.2) = 1e-04, p-value = 0.994
	alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.2194763  0.2305763

