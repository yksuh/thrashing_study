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

med.fit <- lm(ATP ~ NUMPROCESSORS + PCTUPDATE  + PK + PK:PCTUPDATE, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PCTUPDATE + PK + PK:PCTUPDATE, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.30220 -0.06118 -0.02234  0.04448  0.44176 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.59472    0.02100  28.322  < 2e-16 ***
	NUMPROCESSORS -0.02976    0.02435  -1.222    0.223    
	PCTUPDATE     -0.20811    0.03465  -6.006  9.1e-09 ***
	PK            -0.53123    0.02774 -19.153  < 2e-16 ***
	PCTUPDATE:PK   0.50201    0.05060   9.921  < 2e-16 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1338 on 196 degrees of freedom
	Multiple R-squared:  0.6738,	Adjusted R-squared:  0.6671 
	F-statistic: 101.2 on 4 and 196 DF,  p-value: < 2.2e-16

out.fit <- lm(MAXMPL ~ NUMPROCESSORS + ATP + PCTREAD + PCTUPDATE + ACTROWPOOL + PK, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ NUMPROCESSORS + ATP + PCTREAD + PCTUPDATE + 
	    ACTROWPOOL + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.68894 -0.15883  0.02775  0.23346  0.66716 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    1.079203   0.077367  13.949  < 2e-16 ***
	NUMPROCESSORS -0.066801   0.053318  -1.253    0.212    
	ATP           -1.090110   0.136969  -7.959 1.42e-13 ***
	PCTREAD       -0.073627   0.082473  -0.893    0.373    
	PCTUPDATE      0.482025   0.060253   8.000 1.11e-13 ***
	ACTROWPOOL     0.009391   0.058650   0.160    0.873    
	PK            -0.303037   0.060867  -4.979 1.41e-06 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2917 on 194 degrees of freedom
	Multiple R-squared:  0.443,	Adjusted R-squared:  0.4258 
	F-statistic: 25.72 on 6 and 194 DF,  p-value: < 2.2e-16

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK", robustSE = TRUE)
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME             0.3607       0.2507       0.4827    0.00
	ADE             -0.3025      -0.4418      -0.1593    0.00
	Total Effect     0.0583      -0.0368       0.1511    0.21
	Prop. Mediated   5.1002     -33.1950      48.4577    0.21

	Sample Size Used: 201 


	Simulations: 1000 

sens.out <- medsens(med.out, effect.type = "both")
summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.6 -0.0389      -0.1969       0.1190         0.36       0.0654
	[2,] -0.5  0.1012      -0.0580       0.2605         0.25       0.0454

	Rho at which ACME = 0: -0.6
	R^2_M*R^2_Y* at which ACME = 0: 0.36
	R^2_M~R^2_Y~ at which ACME = 0: 0.0654 


	Mediation Sensitivity Analysis for Average Direct Effect

	Sensitivity Region

	      Rho     ADE 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.6  0.0865      -0.0521       0.2251         0.36       0.0654
	[2,] -0.5 -0.0129      -0.1453       0.1194         0.25       0.0454
	[3,] -0.4 -0.0903      -0.2195       0.0389         0.16       0.0291

	Rho at which ADE = 0: -0.5
	R^2_M*R^2_Y* at which ADE = 0: 0.25
	R^2_M~R^2_Y~ at which ADE = 0: 0.0454

> sens.out$r.square.y
[1] 0.443036
> sens.out$r.square.m
[1] 0.6737662
