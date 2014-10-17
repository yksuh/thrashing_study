# sqlserver
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
sqlserver <- subset(x, x$DBMS=='sqlserver')
sqlserver$ATP = (sqlserver$ATP-min(sqlserver$ATP))/(max(sqlserver$ATP)-min(sqlserver$ATP))
sqlserver$MAXMPL = (sqlserver$MAXMPL-min(sqlserver$MAXMPL))/(max(sqlserver$MAXMPL)-min(sqlserver$MAXMPL))
x = rbind(sqlserver) 
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
	-0.36827 -0.22070  0.00524  0.12718  0.61242 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.28694    0.03866   7.422 2.79e-12 ***
	NUMPROCESSORS -0.45038    0.04606  -9.778  < 2e-16 ***
	PCTUPDATE      0.14767    0.06601   2.237   0.0263 *  
	PK             0.03749    0.05022   0.747   0.4562    
	PCTUPDATE:PK  -0.04390    0.09513  -0.461   0.6449    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2617 on 211 degrees of freedom
	Multiple R-squared:  0.3308,	Adjusted R-squared:  0.3181 
	F-statistic: 26.07 on 4 and 211 DF,  p-value: < 2.2e-16

out.fit <- lm(MAXMPL ~ NUMPROCESSORS + ATP + PCTREAD + PCTUPDATE + ACTROWPOOL + PK, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ NUMPROCESSORS + ATP + PCTREAD + PCTUPDATE + 
	    ACTROWPOOL + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.55858 -0.06339  0.02285  0.12832  0.52556 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.472138   0.047215  10.000  < 2e-16 ***
	NUMPROCESSORS  0.416244   0.052237   7.968 1.03e-13 ***
	ATP            0.162063   0.064783   2.502  0.01313 *  
	PCTREAD        0.007046   0.055944   0.126  0.89990    
	PCTUPDATE     -0.134294   0.050132  -2.679  0.00798 ** 
	ACTROWPOOL     0.007113   0.044980   0.158  0.87450    
	PK            -0.041793   0.033629  -1.243  0.21534    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2464 on 209 degrees of freedom
	Multiple R-squared:  0.2718,	Adjusted R-squared:  0.2509 
	F-statistic:    13 on 6 and 209 DF,  p-value: 1.767e-12

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS", robustSE = TRUE)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            -0.0729      -0.1213      -0.0269       0
	ADE              0.4166       0.3061       0.5287       0
	Total Effect     0.3436       0.2600       0.4240       0
	Prop. Mediated  -0.2093      -0.3273      -0.0887       0

	Sample Size Used: 216 


	Simulations: 1000 

sens.out <- medsens(med.out, effect.type = "both")
summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	     Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] 0.1 -0.0306      -0.0739       0.0127         0.01       0.0049
	[2,] 0.2  0.0131      -0.0299       0.0561         0.04       0.0195

	Rho at which ACME = 0: 0.2
	R^2_M*R^2_Y* at which ACME = 0: 0.04
	R^2_M~R^2_Y~ at which ACME = 0: 0.0195 


	Mediation Sensitivity Analysis for Average Direct Effect

	Sensitivity Region

	     Rho     ADE 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] 0.6  0.1004      -0.0271       0.2278         0.36       0.1755
	[2,] 0.7  0.0034      -0.1336       0.1404         0.49       0.2388
	[3,] 0.8 -0.1454      -0.2998       0.0091         0.64       0.3119

	Rho at which ADE = 0: 0.7
	R^2_M*R^2_Y* at which ADE = 0: 0.49
	R^2_M~R^2_Y~ at which ADE = 0: 0.2388

> sens.out$r.square.y
[1] 0.2717694
> sens.out$r.square.m
[1] 0.3307554
