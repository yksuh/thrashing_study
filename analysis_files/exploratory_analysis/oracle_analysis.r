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

med.fit <- lm(ATP ~ NUMPROCESSORS + PCTUPDATE + PK + PK:PCTUPDATE, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PCTUPDATE + PK + PK:PCTUPDATE, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.19357 -0.04112  0.00035  0.02915  0.76169 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.21271    0.01866  11.402  < 2e-16 ***
	NUMPROCESSORS  0.05975    0.02142   2.790   0.0058 ** 
	PCTUPDATE     -0.30351    0.03145  -9.649  < 2e-16 ***
	PK            -0.22983    0.02409  -9.541  < 2e-16 ***
	PCTUPDATE:PK   0.30661    0.04415   6.944 5.59e-11 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1173 on 194 degrees of freedom
	Multiple R-squared:  0.4154,	Adjusted R-squared:  0.4034 
	F-statistic: 34.46 on 4 and 194 DF,  p-value: < 2.2e-16

out.fit <- lm(MAXMPL ~ NUMPROCESSORS + ATP + PCTREAD + PCTUPDATE + ACTROWPOOL + PK, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ NUMPROCESSORS + ATP + PCTREAD + PCTUPDATE + 
	    ACTROWPOOL + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.78865 -0.30300  0.00401  0.30366  0.88813 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.826209   0.075856  10.892  < 2e-16 ***
	NUMPROCESSORS -0.461103   0.071040  -6.491 7.11e-10 ***
	ATP           -0.382774   0.213682  -1.791  0.07482 .  
	PCTREAD        0.003814   0.091381   0.042  0.96676    
	PCTUPDATE     -0.255793   0.085654  -2.986  0.00319 ** 
	ACTROWPOOL     0.025408   0.074040   0.343  0.73185    
	PK             0.001316   0.059282   0.022  0.98232    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3844 on 192 degrees of freedom
	Multiple R-squared:  0.2377,	Adjusted R-squared:  0.2139 
	F-statistic: 9.978 on 6 and 192 DF,  p-value: 1.388e-09

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS", robustSE = TRUE)
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.02201     -0.06392      0.00529    0.15
	ADE            -0.46110     -0.58929     -0.31822    0.00
	Total Effect   -0.48311     -0.61493     -0.33837    0.00
	Prop. Mediated  0.04077     -0.01254      0.12649    0.15

	Sample Size Used: 199 


	Simulations: 1000

sens.out <- medsens(med.out, effect.type = "both")
summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.3  0.0272      -0.0043       0.0587         0.09       0.0401
	[2,] -0.2  0.0095      -0.0164       0.0353         0.04       0.0178
	[3,] -0.1 -0.0071      -0.0328       0.0187         0.01       0.0045
	[4,]  0.0 -0.0229      -0.0530       0.0072         0.00       0.0000

	Rho at which ACME = 0: -0.1
	R^2_M*R^2_Y* at which ACME = 0: 0.01
	R^2_M~R^2_Y~ at which ACME = 0: 0.0045 


	Mediation Sensitivity Analysis for Average Direct Effect

	Sensitivity Region

	     Rho     ADE 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] 0.9 -0.1696      -0.4706       0.1314         0.81        0.361

	Rho at which ADE = 0: 0.9
	R^2_M*R^2_Y* at which ADE = 0: 0.81
	R^2_M~R^2_Y~ at which ADE = 0: 0.361 

> sens.out$r.square.y
[1] 0.2376887
> sens.out$r.square.m
[1] 0.415412
