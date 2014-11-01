# pgsql
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
<<<<<<< HEAD
pgsql <- subset(x, x$DBMS=='pgsql')
pgsql$ATP = (pgsql$ATP-min(pgsql$ATP))/(max(pgsql$ATP)-min(pgsql$ATP))
pgsql$MAXMPL = (pgsql$MAXMPL-min(pgsql$MAXMPL))/(max(pgsql$MAXMPL)-min(pgsql$MAXMPL))
x = rbind(pgsql) 
x$ACTROWPOOL = (x$ACTROWPOOL-min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)-min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD-min(x$PCTREAD))/(max(x$PCTREAD)-min(x$PCTREAD))
x$PCTUPDATE = (x$PCTUPDATE-min(x$PCTUPDATE))/(max(x$PCTUPDATE)-min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS-min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)-min(x$NUMPROCESSORS))
=======
# pgsql
pgsql <- subset(x, x$DBMS=='pgsql')
pgsql$ATP = (pgsql$ATP-min(pgsql$ATP))/(max(pgsql$ATP)-min(pgsql$ATP))
pgsql$ATP[pgsql$ATP > 0.8 & pgsql$ATP <= 1] <- 5
pgsql$ATP[pgsql$ATP > 0.6 & pgsql$ATP <= 0.8] <- 4
pgsql$ATP[pgsql$ATP > 0.4 & pgsql$ATP <= 0.6] <- 3
pgsql$ATP[pgsql$ATP > 0.2 & pgsql$ATP <= 0.4] <- 2
pgsql$ATP[pgsql$ATP <= 0.2 ] <- 1
pgsql$ATP = (pgsql$ATP-min(pgsql$ATP))/(max(pgsql$ATP)-min(pgsql$ATP))
pgsql$MAXMPL = (pgsql$MAXMPL-min(pgsql$MAXMPL))/(max(pgsql$MAXMPL)-min(pgsql$MAXMPL))
pgsql$MAXMPL[pgsql$MAXMPL == 1] <- 5
pgsql$MAXMPL[pgsql$MAXMPL > 0.75 & pgsql$MAXMPL <= 1] <- 4
pgsql$MAXMPL[pgsql$MAXMPL > 0.5 & pgsql$MAXMPL <= 0.75] <- 3
pgsql$MAXMPL[pgsql$MAXMPL > 0.25 & pgsql$MAXMPL <= 0.50] <- 2
pgsql$MAXMPL[pgsql$MAXMPL<=0.25] <- 1
pgsql$MAXMPL = (pgsql$MAXMPL-min(pgsql$MAXMPL))/(max(pgsql$MAXMPL)-min(pgsql$MAXMPL))
pgsql$ACTROWPOOL = (pgsql$ACTROWPOOL-min(pgsql$ACTROWPOOL))/(max(pgsql$ACTROWPOOL)-min(pgsql$ACTROWPOOL))
pgsql$PCTREAD = (pgsql$PCTREAD-min(pgsql$PCTREAD))/(max(pgsql$PCTREAD)-min(pgsql$PCTREAD))
pgsql$PCTUPDATE = (pgsql$PCTUPDATE-min(pgsql$PCTUPDATE))/(max(pgsql$PCTUPDATE)-min(pgsql$PCTUPDATE))
pgsql$NUMPROCESSORS = (pgsql$NUMPROCESSORS-min(pgsql$NUMPROCESSORS))/(max(pgsql$NUMPROCESSORS)-min(pgsql$NUMPROCESSORS))
x = rbind(pgsql) 
>>>>>>> AnalysisQuery

med.fit <- lm(ATP ~ NUMPROCESSORS + PCTUPDATE  + PK + PK:PCTUPDATE, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PCTUPDATE + PK + PK:PCTUPDATE, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
<<<<<<< HEAD
=======
	-0.31180 -0.14269 -0.01694  0.09385  0.60009 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.45490    0.02880  15.794  < 2e-16 ***
	NUMPROCESSORS -0.06069    0.03476  -1.746   0.0824 .  
	PCTUPDATE     -0.57238    0.04896 -11.691  < 2e-16 ***
	PK            -0.29632    0.03880  -7.637 1.13e-12 ***
	PCTUPDATE:PK   0.39260    0.07438   5.278 3.62e-07 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1904 on 186 degrees of freedom
	Multiple R-squared:  0.4974,	Adjusted R-squared:  0.4866 
	F-statistic: 46.03 on 4 and 186 DF,  p-value: < 2.2e-16

----

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PCTUPDATE + PK + PK:PCTUPDATE, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
>>>>>>> AnalysisQuery
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
<<<<<<< HEAD
=======
	-0.80463 -0.26604  0.02151  0.23934  0.90121 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.42094    0.07285   5.778 3.17e-08 ***
	NUMPROCESSORS -0.26108    0.06022  -4.336 2.39e-05 ***
	ATP            0.17516    0.12149   1.442 0.151058    
	PCTREAD       -0.13035    0.07924  -1.645 0.101672    
	PCTUPDATE     -0.28153    0.08128  -3.463 0.000663 ***
	ACTROWPOOL    -0.07370    0.06207  -1.187 0.236573    
	PK             0.57059    0.05125  11.133  < 2e-16 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3267 on 184 degrees of freedom
	Multiple R-squared:  0.4811,	Adjusted R-squared:  0.4641 
	F-statistic: 28.43 on 6 and 184 DF,  p-value: < 2.2e-16

----

	Call:
	lm(formula = MAXMPL ~ NUMPROCESSORS + ATP + PCTREAD + PCTUPDATE + 
	    ACTROWPOOL + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
>>>>>>> AnalysisQuery
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
