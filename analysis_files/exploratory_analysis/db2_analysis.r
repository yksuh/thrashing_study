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

med.fit <- lm(ATP ~ NUMPROCESSORS + PCTUPDATE  + PK + PK:PCTUPDATE, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PCTUPDATE + PK + PK:PCTUPDATE, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.19260 -0.07600 -0.02929  0.01015  0.85072 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)   
	(Intercept)    0.02714    0.02934   0.925  0.35613   
	NUMPROCESSORS  0.06741    0.03285   2.052  0.04153 * 
	PCTUPDATE     -0.07288    0.05002  -1.457  0.14677   
	PK             0.09805    0.03707   2.645  0.00884 **
	PCTUPDATE:PK  -0.13698    0.07179  -1.908  0.05789 . 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1852 on 192 degrees of freedom
	Multiple R-squared:  0.1221,	Adjusted R-squared:  0.1038 
	F-statistic: 6.678 on 4 and 192 DF,  p-value: 4.72e-05

> out.fit <- lm(MAXMPL ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS + PK, data = x)
> summary(out.fit)

Call:
lm(formula = MAXMPL ~ NUMPROCESSORS + ATP + PCTREAD + PCTUPDATE + 
    ACTROWPOOL + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.84778 -0.15428  0.06585  0.19442  0.49463 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.68322    0.05056  13.514  < 2e-16 ***
	NUMPROCESSORS  0.19427    0.04896   3.968 0.000103 ***
	ATP            0.21142    0.10874   1.944 0.053348 .  
	PCTREAD       -0.07604    0.06941  -1.096 0.274681    
	PCTUPDATE      0.23047    0.06180   3.729 0.000253 ***
	ACTROWPOOL    -0.12960    0.05227  -2.479 0.014030 *  
	PK             0.06358    0.03925   1.620 0.106894    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2726 on 190 degrees of freedom
	Multiple R-squared:  0.2178,	Adjusted R-squared:  0.1931 
	F-statistic: 8.817 on 6 and 190 DF,  p-value: 1.747e-08

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS", robustSE = TRUE, conf.level=.1, sims = 100)
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 10% CI Lower 10% CI Upper p-value
	ACME             0.0142       0.0120       0.0143    0.06
	ADE              0.1950       0.1893       0.2020    0.00
	Total Effect     0.2092       0.2034       0.2150    0.00
	Prop. Mediated   0.0627       0.0579       0.0683    0.06

	Sample Size Used: 197 


	Simulations: 1000 

sens.out <- medsens(med.out, effect.type = "both")
summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Rho at which ACME = 0: 0.1
	R^2_M*R^2_Y* at which ACME = 0: 0.01
	R^2_M~R^2_Y~ at which ACME = 0: 0.0069 


	Mediation Sensitivity Analysis for Average Direct Effect

	Sensitivity Region

	      Rho     ADE 10% CI Lower 10% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.9 -0.0046      -0.0193       0.0101         0.81       0.5562

	Rho at which ADE = 0: -0.9
	R^2_M*R^2_Y* at which ADE = 0: 0.81
	R^2_M~R^2_Y~ at which ADE = 0: 0.5562 

sens.out$r.square.y
sens.out$r.square.m

> sens.out$r.square.y
[1] 0.2177873
> sens.out$r.square.m
[1] 0.1221305

