# Overall: 33.4% (close to suboptimal)
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
# ATP normalization
# db2
db2 <- subset(x, x$DBMS=='db2')
db2$ATP = (db2$ATP-min(db2$ATP))/(max(db2$ATP)-min(db2$ATP))
db2$MAXMPL = (db2$MAXMPL-min(db2$MAXMPL))/(max(db2$MAXMPL)-min(db2$MAXMPL))
# oracle
oracle <- subset(x, x$DBMS=='oracle')
oracle$ATP = (oracle$ATP-min(oracle$ATP))/(max(oracle$ATP)-min(oracle$ATP))
oracle$MAXMPL = (oracle$MAXMPL-min(oracle$MAXMPL))/(max(oracle$MAXMPL)-min(oracle$MAXMPL))
# mysql
mysql <- subset(x, x$DBMS=='mysql')
mysql$ATP = (mysql$ATP-min(mysql$ATP))/(max(mysql$ATP)-min(pgsql$ATP))
mysql$MAXMPL = (mysql$MAXMPL-min(mysql$MAXMPL))/(max(mysql$MAXMPL)-min(mysql$MAXMPL))
# pgsql
pgsql <- subset(x, x$DBMS=='pgsql')
pgsql$ATP = (pgsql$ATP-min(pgsql$ATP))/(max(pgsql$ATP)-min(pgsql$ATP))
pgsql$MAXMPL = (pgsql$MAXMPL-min(pgsql$MAXMPL))/(max(pgsql$MAXMPL)-min(pgsql$MAXMPL))
# sqlserver
sqlserver <- subset(x, x$DBMS=='sqlserver')
sqlserver$ATP = (sqlserver$ATP-min(sqlserver$ATP))/(max(sqlserver$ATP)-min(sqlserver$ATP))
sqlserver$MAXMPL = (sqlserver$MAXMPL-min(sqlserver$MAXMPL))/(max(sqlserver$MAXMPL)-min(sqlserver$MAXMPL))
x = rbind(db2,oracle,mysql,pgsql,sqlserver) 
#x$ATP = (x$ATP-min(x$ATP))/(max(x$ATP)-min(x$ATP))
#x$MAXMPL = (x$MAXMPL-min(x$MAXMPL))/(max(x$MAXMPL)-min(x$MAXMPL))x$ACTROWPOOL = (x$ACTROWPOOL-min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)-min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD-min(x$PCTREAD))/(max(x$PCTREAD)-min(x$PCTREAD))
x$PCTUPDATE = (x$PCTUPDATE-min(x$PCTUPDATE))/(max(x$PCTUPDATE)-min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS-min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)-min(x$NUMPROCESSORS))

> med.fit <- lm(ATP ~ NUMPROCESSORS + PK + PCTUPDATE + PK:PCTUPDATE, data = x)
> summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK + PCTUPDATE + PK:PCTUPDATE, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.31735 -0.13451 -0.09765  0.10101  0.90127 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.31757    0.01722  18.440  < 2e-16 ***
	NUMPROCESSORS -0.07736    0.02007  -3.854 0.000123 ***
	PK            -0.18568    0.02243  -8.279 3.96e-16 ***
	PCTUPDATE     -0.20426    0.02911  -7.017 4.18e-12 ***
	PK:PCTUPDATE   0.21672    0.04219   5.137 3.36e-07 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2496 on 999 degrees of freedom
	Multiple R-squared:  0.09942,	Adjusted R-squared:  0.09581 
	F-statistic: 27.57 on 4 and 999 DF,  p-value: < 2.2e-16

> out.fit <- lm(MAXMPL ~ PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS + PK, data = x)
> summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.75393 -0.35564  0.03002  0.33491  0.52922 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.646930   0.037646  17.185  < 2e-16 ***
	PCTUPDATE      0.009928   0.032443   0.306    0.760    
	ACTROWPOOL    -0.078076   0.042883  -1.821    0.069 .  
	ATP           -0.068210   0.047695  -1.430    0.153    
	NUMPROCESSORS -0.033597   0.030794  -1.091    0.276    
	PK             0.119935   0.024532   4.889 1.18e-06 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3802 on 998 degrees of freedom
	Multiple R-squared:  0.03379,	Adjusted R-squared:  0.02895 
	F-statistic:  6.98 on 5 and 998 DF,  p-value: 2.022e-06

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS", robustSE = TRUE, conf.level=.1, sims = 100)
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 10% CI Lower 10% CI Upper p-value
	ACME            0.00573      0.00507      0.00616    0.08
	ADE            -0.03183     -0.03960     -0.02515    0.42
	Total Effect   -0.02610     -0.03268     -0.02124    0.48
	Prop. Mediated -0.11062     -0.12731     -0.09180    0.52

	Sample Size Used: 1004 


	Simulations: 100 

> sens.out <- medsens(med.out, effect.type = "both")



> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK", robustSE = TRUE, conf.level = .1, sims = 100)
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 10% CI Lower 10% CI Upper p-value
	ACME            0.00765      0.00655      0.00788    0.04
	ADE             0.11697      0.11274      0.11756    0.00
	Total Effect    0.12462      0.11946      0.12694    0.00
	Prop. Mediated  0.05965      0.05355      0.06587    0.04

	Sample Size Used: 1004 


	Simulations: 100 

> sens.out <- medsens(med.out, effect.type = "both")
> summary(sens.out)
	
	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Rho at which ACME = 0: 0
	R^2_M*R^2_Y* at which ACME = 0: 0
	R^2_M~R^2_Y~ at which ACME = 0: 0 


	Mediation Sensitivity Analysis for Average Direct Effect

	Sensitivity Region

	      Rho    ADE 10% CI Lower 10% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.3 0.0035       -6e-04       0.0076         0.09       0.0783

	Rho at which ADE = 0: -0.3
	R^2_M*R^2_Y* at which ADE = 0: 0.09
	R^2_M~R^2_Y~ at which ADE = 0: 0.0783
### If we gather data, direct effects from PK or NUMPROCESSORS are too strong, the indirect effects through ATP time seem hidden.
