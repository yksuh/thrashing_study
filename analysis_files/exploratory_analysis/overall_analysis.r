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
mysql$ATP = (mysql$ATP-min(mysql$ATP))/(max(mysql$ATP)-min(mysql$ATP))
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
x$ACTROWPOOL = (x$ACTROWPOOL-min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)-min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD-min(x$PCTREAD))/(max(x$PCTREAD)-min(x$PCTREAD))
x$PCTUPDATE = (x$PCTUPDATE-min(x$PCTUPDATE))/(max(x$PCTUPDATE)-min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS-min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)-min(x$NUMPROCESSORS))

> cor(x$NUMPROCESSORS, x$ATP)
[1] -0.122788
> cor(x$PCTREAD, x$ATP)
[1] 0.08402555
> cor(x$PCTUPDATE, x$ATP)
[1] -0.145902
> cor(x$PK, x$ATP)
[1] -0.2029692
> cor(x$ACTROWPOOL, x$ATP)
[1] 0.07663052

> cor(x$ATP, x$MAXMPL)
[1] -0.07951011
> cor(x$NUMPROCESSORS, x$MAXMPL)
[1] -0.02375046
> cor(x$PCTREAD, x$MAXMPL)
[1] -0.059297
> cor(x$PCTUPDATE, x$MAXMPL)
[1] 0.01913866
> cor(x$ACTROWPOOL, x$MAXMPL)
[1] -0.0620389
> cor(x$PK, x$MAXMPL)
[1] 0.1646099

<<<<<<< Updated upstream
=======
###### alternative

med.fit <- lm(ATP ~ NUMPROCESSORS + PCTUPDATE + PK, data = x)
summary(med.fit)
out.fit <- lm(MAXMPL ~ PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS + PCTUPDATE, data = x)
summary(out.fit)

library(lavaan)
thrashing_model <- '
     # mediator
      ATP ~ a1*NUMPROCESSORS+a3*PK+a4*PCTUPDATE
    # dependent variable
      MAXMPL ~ b1*ATP+c1*NUMPROCESSORS+c2*ACTROWPOOL+c4*PCTUPDATE+c5*PCTREAD
   # interactions
     '
fit <- sem(thrashing_model, estimator="DWLS", data = x)
summary(fit, fit.measures = TRUE, standardized=TRUE, rsq=T)

db2: 8.6/19.9
ss: 33.1/26.8
pgsql: 95.6 / 57.5
mysql: 49.7 / 32.4
oracle: 29.0 / 23.8

avg: 43.2 / 32.04
overall: 7.28 / 0.86

##### expected ...

med.fit <- lm(ATP ~ NUMPROCESSORS + PK + PCTUPDATE, data = x)
summary(med.fit)
out.fit <- lm(MAXMPL ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS + PK, data = x)
summary(out.fit)
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS", robustSE = TRUE, conf.level=.1, sims = 100)
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK", robustSE = TRUE, conf.level = .1, sims = 100)
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE", robustSE = TRUE, conf.level = .1, sims = 100)
sens.out <- medsens(med.out, effect.type = "both")

>>>>>>> Stashed changes
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

> out.fit <- lm(MAXMPL ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS + PK, data = x)
> summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + 
	    NUMPROCESSORS + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.76003 -0.33345  0.03219  0.33729  0.51504 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.66578    0.03924  16.966  < 2e-16 ***
	PCTREAD       -0.06920    0.04109  -1.684   0.0925 .  
	PCTUPDATE     -0.01534    0.03572  -0.430   0.6676    
	ACTROWPOOL    -0.07896    0.04285  -1.843   0.0657 .  
	ATP           -0.06617    0.04767  -1.388   0.1654    
	NUMPROCESSORS -0.03204    0.03078  -1.041   0.2981    
	PK             0.11938    0.02451   4.871 1.29e-06 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3798 on 997 degrees of freedom
	Multiple R-squared:  0.03653,	Adjusted R-squared:  0.03073 
	F-statistic:   6.3 on 6 and 997 DF,  p-value: 1.627e-06

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


### conflicting mediation effects made by PK (positive) and NUMPROCESSORS (negative) on DBMS thrashing
### no mediation looks happening.
### If we gather data, direct effects from PK or NUMPROCESSORS are too strong, the indirect effects through ATP time seem hidden. 
### PK and NUMPROCESSORS make confounding effects, so the overall amount of variance explained so low.

> sens.out <- medsens(med.out, effect.type = "both")
> summary(sens.out)

Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.1 -0.0063      -0.0136       0.0010         0.01       0.0087
	[2,]  0.0  0.0053      -0.0017       0.0123         0.00       0.0000

	Rho at which ACME = 0: 0
	R^2_M*R^2_Y* at which ACME = 0: 0
	R^2_M~R^2_Y~ at which ACME = 0: 0 


	Mediation Sensitivity Analysis for Average Direct Effect

	Sensitivity Region

	       Rho     ADE 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	 [1,] -0.6  0.0552      -0.0188       0.1291         0.36       0.3114
	 [2,] -0.5  0.0346      -0.0344       0.1037         0.25       0.2163
	 [3,] -0.4  0.0179      -0.0480       0.0838         0.16       0.1384
	 [4,] -0.3  0.0034      -0.0605       0.0674         0.09       0.0779
	 [5,] -0.2 -0.0096      -0.0724       0.0531         0.04       0.0346
	 [6,] -0.1 -0.0218      -0.0840       0.0404         0.01       0.0087
	 [7,]  0.0 -0.0336      -0.0958       0.0286         0.00       0.0000
	 [8,]  0.1 -0.0453      -0.1080       0.0174         0.01       0.0087
	 [9,]  0.2 -0.0574      -0.1211       0.0064         0.04       0.0346

	Rho at which ADE = 0: -0.3
	R^2_M*R^2_Y* at which ADE = 0: 0.09
	R^2_M~R^2_Y~ at which ADE = 0: 0.0779 

> sens.out$r.square.y
[1] 0.03378934
> sens.out$r.square.m
[1] 0.1047084

> sens.out$r.square.m
[1] 0.09941911
> sens.out$r.square.y
[1] 0.03378934

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK", robustSE = TRUE, conf.level = .1, sims = 100)
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 10% CI Lower 10% CI Upper p-value
	ACME            0.00773      0.00624      0.00742    0.02
	ADE             0.12221      0.11620      0.12446    0.00
	Total Effect    0.12994      0.12513      0.13107    0.00
	Prop. Mediated  0.05283      0.04836      0.05997    0.02

	Sample Size Used: 1004 


	Simulations: 100 

> sens.out <- medsens(med.out, effect.type = "both")
> summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Rho at which ACME = 0: 0
	R^2_M*R^2_Y* at which ACME = 0: 0
	R^2_M~R^2_Y~ at which ACME = 0: 0 


	Mediation Sensitivity Analysis for Average Direct Effect

	Rho at which ADE = 0: 0.6
	R^2_M*R^2_Y* at which ADE = 0: 0.36
	R^2_M~R^2_Y~ at which ADE = 0: 0.3114 

> sens.out$r.square.y
[1] 0.03378934
> sens.out$r.square.m
[1] 0.1047084

############################################################################################################################
> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK", robustSE = TRUE)
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            0.00712     -0.00183      0.01673    0.11
	ADE             0.12076      0.07244      0.17041    0.00
	Total Effect    0.12787      0.07967      0.17671    0.00
	Prop. Mediated  0.05410     -0.01319      0.14533    0.11

	Sample Size Used: 1004 


	Simulations: 1000

> sens.out <- medsens(med.out, effect.type = "both")
> summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.1 -0.0145      -0.0300       0.0011         0.01       0.0087
	[2,]  0.0  0.0126      -0.0033       0.0286         0.00       0.0000

	Rho at which ACME = 0: 0
	R^2_M*R^2_Y* at which ACME = 0: 0
	R^2_M~R^2_Y~ at which ACME = 0: 0 


	Mediation Sensitivity Analysis for Average Direct Effect

	Sensitivity Region

	     Rho     ADE 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] 0.5  0.0320      -0.0228       0.0869         0.25       0.2163
	[2,] 0.6  0.0058      -0.0533       0.0649         0.36       0.3114
	[3,] 0.7 -0.0292      -0.0950       0.0367         0.49       0.4239

	Rho at which ADE = 0: 0.6
	R^2_M*R^2_Y* at which ADE = 0: 0.36
	R^2_M~R^2_Y~ at which ADE = 0: 0.3114 

> sens.out$r.square.y
[1] 0.03378934
> sens.out$r.square.m
[1] 0.1047084
############################################################################################################################
> library(mediation)
> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE", robustSE = TRUE)
> summary(med.out)

Causal Mediation Analysis 

Quasi-Bayesian Confidence Intervals

               Estimate 95% CI Lower 95% CI Upper p-value
ACME            0.00665     -0.00221      0.01609    0.13
ADE             0.01173     -0.05302      0.07503    0.75
Total Effect    0.01838     -0.04576      0.08339    0.61
Prop. Mediated  0.11813     -3.38692      2.56093    0.66

Sample Size Used: 1004 


Simulations: 1000 


> test.modmed(med.out, covariates.1 = list (x$PK == 1), covariates.2 = list (x$PK == 0), data = x)
