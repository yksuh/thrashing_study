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
     INT_3 := a1*a2'
fit <- sem(thrashing_model, data = x)
summary(fit, standardized=TRUE, rsq=T) 

	lavaan (0.5-17) converged normally after  26 iterations

	  Number of observations                           199

	  Estimator                                         ML
	  Minimum Function Test Statistic                0.000
	  Degrees of freedom                                 0

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
	    INT_3             0.002    0.002    1.268    0.205    0.002    0.012

	R-Square:

	    ATP               0.291
	    MAXMPL            0.238

library(mediation)
med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + PK + PCTREAD + PCTUPDATE + PCTUPDATE:PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + 
	    PK + PCTREAD + PCTUPDATE + PCTUPDATE:PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.20835 -0.05132 -0.00115  0.02908  0.76919 

	Coefficients:
		                 Estimate Std. Error t value Pr(>|t|)    
	(Intercept)               0.18338    0.02556   7.173 1.57e-11 ***
	NUMPROCESSORS             0.03974    0.03517   1.130   0.2600    
	ACTROWPOOL                0.02306    0.03047   0.757   0.4501    
	PK                       -0.22903    0.02382  -9.614  < 2e-16 ***
	PCTREAD                   0.05619    0.02733   2.056   0.0411 *  
	PCTUPDATE                -0.27992    0.03308  -8.461 6.85e-15 ***
	NUMPROCESSORS:ACTROWPOOL  0.03704    0.05641   0.657   0.5122    
	PK:PCTUPDATE              0.30670    0.04366   7.024 3.68e-11 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.116 on 191 degrees of freedom
	Multiple R-squared:  0.4373,	Adjusted R-squared:  0.4167 
	F-statistic: 21.21 on 7 and 191 DF,  p-value: < 2.2e-16

out.fit <- lm(MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + PCTREAD + PK, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + 
	    PCTREAD + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.78865 -0.30300  0.00401  0.30366  0.88813 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.826209   0.075856  10.892  < 2e-16 ***
	ATP           -0.382774   0.213682  -1.791  0.07482 .  
	ACTROWPOOL     0.025408   0.074040   0.343  0.73185    
	NUMPROCESSORS -0.461103   0.071040  -6.491 7.11e-10 ***
	PCTUPDATE     -0.255793   0.085654  -2.986  0.00319 ** 
	PCTREAD        0.003814   0.091381   0.042  0.96676    
	PK             0.001316   0.059282   0.022  0.98232    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3844 on 192 degrees of freedom
	Multiple R-squared:  0.2377,	Adjusted R-squared:  0.2139 
	F-statistic: 9.978 on 6 and 192 DF,  p-value: 1.388e-09

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.02273     -0.06098      0.00157    0.07
	ADE            -0.46082     -0.60054     -0.32781    0.00
	Total Effect   -0.48355     -0.62673     -0.35203    0.00
	Prop. Mediated  0.04201     -0.00315      0.12663    0.07

	Sample Size Used: 199 


	Simulations: 1000

test.modmed(med.out, covariates.1 = list (x$ACTROWPOOL < 0.5), covariates.2 = list (x$x$ACTROWPOOL >= 0.5), data = x)

		Test of ACME(covariates.1) - ACME(covariates.2) = 0

	data:  estimates from med.out
	ACME(covariates.1) - ACME(covariates.2) = 5e-04, p-value = 0.954
	alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.04508970  0.04485731


		Test of ADE(covariates.1) - ADE(covariates.2) = 0

	data:  estimates from med.out
	ADE(covariates.1) - ADE(covariates.2) = 0.0026, p-value = 0.98
	alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.1866231  0.1941980

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            0.04750     -0.00505      0.11198    0.08
	ADE            -0.25828     -0.43141     -0.09770    0.00
	Total Effect   -0.21078     -0.37017     -0.05590    0.01
	Prop. Mediated -0.21626     -1.03020      0.03119    0.08

	Sample Size Used: 199 


	Simulations: 1000


test.modmed(med.out, covariates.1 = list (x$PK == 1), covariates.2 = list (x$PK == 0), data = x)

		Test of ACME(covariates.1) - ACME(covariates.2) = 0

	data:  estimates from med.out
	ACME(covariates.1) - ACME(covariates.2) = -0.0019, p-value = 0.986
	alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.07845928  0.07573423


		Test of ADE(covariates.1) - ADE(covariates.2) = 0

	data:  estimates from med.out
	ADE(covariates.1) - ADE(covariates.2) = 0.0045, p-value = 0.97
	alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.2351366  0.2527408
