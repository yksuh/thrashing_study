# pgsql
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
pgsql <- subset(x, x$DBMS=='pgsql')
pgsql$ATP = (pgsql$ATP-min(pgsql$ATP))/(max(pgsql$ATP)-min(pgsql$ATP))
pgsql$MAXMPL = (pgsql$MAXMPL-min(pgsql$MAXMPL))/(max(pgsql$MAXMPL)-min(pgsql$MAXMPL))
x = rbind(pgsql) 
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
	-0.31115 -0.12407 -0.01243  0.10325  0.58091 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.46035    0.02756  16.705  < 2e-16 ***
	NUMPROCESSORS -0.03388    0.03326  -1.019     0.31    
	PCTUPDATE     -0.59306    0.04685 -12.660  < 2e-16 ***
	PK            -0.28410    0.03712  -7.653 1.03e-12 ***
	PCTUPDATE:PK   0.37563    0.07117   5.278 3.62e-07 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1821 on 186 degrees of freedom
	Multiple R-squared:  0.533,	Adjusted R-squared:  0.523 
	F-statistic: 53.08 on 4 and 186 DF,  p-value: < 2.2e-16

out.fit <- lm(MAXMPL ~ NUMPROCESSORS + ATP + PCTREAD + PCTUPDATE + ACTROWPOOL + PK, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ NUMPROCESSORS + ATP + PCTREAD + PCTUPDATE + 
	    ACTROWPOOL + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.66634 -0.22952  0.03932  0.20326  0.83721 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.42892    0.06916   6.202 3.60e-09 ***
	NUMPROCESSORS -0.22381    0.05540  -4.040 7.85e-05 ***
	ATP            0.27179    0.11775   2.308  0.02210 *  
	PCTREAD       -0.16262    0.07349  -2.213  0.02814 *  
	PCTUPDATE     -0.22990    0.07792  -2.950  0.00359 ** 
	ACTROWPOOL    -0.06185    0.05742  -1.077  0.28281    
	PK             0.56311    0.04746  11.865  < 2e-16 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3022 on 184 degrees of freedom
	Multiple R-squared:  0.4985,	Adjusted R-squared:  0.4822 
	F-statistic: 30.49 on 6 and 184 DF,  p-value: < 2.2e-16

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK", robustSE = TRUE)
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.04048     -0.08516     -0.00114    0.04
	ADE             0.56402      0.47539      0.65257    0.00
	Total Effect    0.52353      0.44141      0.60700    0.00
	Prop. Mediated -0.07410     -0.17898     -0.00209    0.04

	Sample Size Used: 191 


	Simulations: 1000

sens.out <- medsens(med.out, effect.type = "both")
summary(sens.out)
	
	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	     Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] 0.1 -0.0372      -0.1115       0.0372         0.01       0.0023
	[2,] 0.2  0.0045      -0.0692       0.0782         0.04       0.0094
	[3,] 0.3  0.0484      -0.0266       0.1234         0.09       0.0211

	Rho at which ACME = 0: 0.2
	R^2_M*R^2_Y* at which ACME = 0: 0.04
	R^2_M~R^2_Y~ at which ACME = 0: 0.0094 


	Mediation Sensitivity Analysis for Average Direct Effect

	Sensitivity Region

	     Rho    ADE 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] 0.9 0.1119      -0.0705       0.2942         0.81       0.1897

	Rho at which ADE = 0: 0.9
	R^2_M*R^2_Y* at which ADE = 0: 0.81
	R^2_M~R^2_Y~ at which ADE = 0: 0.1897

> sens.out$r.square.y
[1] 0.4985336
> sens.out$r.square.m
[1] 0.5330371

##################################################################################################################################
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK", robustSE = TRUE)
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.04020     -0.08961     -0.00176    0.04
	ADE             0.56298      0.48091      0.64994    0.00
	Total Effect    0.52278      0.44323      0.60729    0.00
	Prop. Mediated -0.07440     -0.17592     -0.00301    0.04

	Sample Size Used: 191 


	Simulations: 1000 

sens.out <- medsens(med.out, effect.type = "both")
summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	     Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] 0.1 -0.0372      -0.1115       0.0372         0.01       0.0023
	[2,] 0.2  0.0045      -0.0692       0.0782         0.04       0.0094
	[3,] 0.3  0.0484      -0.0266       0.1234         0.09       0.0211

	Rho at which ACME = 0: 0.2
	R^2_M*R^2_Y* at which ACME = 0: 0.04
	R^2_M~R^2_Y~ at which ACME = 0: 0.0094 


	Mediation Sensitivity Analysis for Average Direct Effect

	Sensitivity Region

	     Rho    ADE 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] 0.9 0.1119      -0.0705       0.2942         0.81       0.1897

	Rho at which ADE = 0: 0.9
	R^2_M*R^2_Y* at which ADE = 0: 0.81
	R^2_M~R^2_Y~ at which ADE = 0: 0.1897 

> sens.out$r.square.y
[1] 0.4985336
> sens.out$r.square.m
[1] 0.5330371
