# Overall: 33.4% (close to suboptimal)
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
# ATP normalization
# db2
db2 <- subset(x, x$DBMS=='db2')
db2$ATP = (db2$ATP-min(db2$ATP))/(max(db2$ATP)-min(db2$ATP))
db2$ATP[db2$ATP > 0.8 & db2$ATP <= 1] <- 5
db2$ATP[db2$ATP > 0.6 & db2$ATP <= 0.8] <- 4
db2$ATP[db2$ATP > 0.4 & db2$ATP <= 0.6] <- 3
db2$ATP[db2$ATP > 0.2 & db2$ATP <= 0.4] <- 2
db2$ATP[db2$ATP <= 0.2 ] <- 1
db2$ATP = (db2$ATP-min(db2$ATP))/(max(db2$ATP)-min(db2$ATP))
db2$MAXMPL = (db2$MAXMPL-min(db2$MAXMPL))/(max(db2$MAXMPL)-min(db2$MAXMPL))
db2$MAXMPL[db2$MAXMPL == 1] <- 5
db2$MAXMPL[db2$MAXMPL > 0.75 & db2$MAXMPL <= 1] <- 4
db2$MAXMPL[db2$MAXMPL > 0.5 & db2$MAXMPL <= 0.75] <- 3
db2$MAXMPL[db2$MAXMPL > 0.25 & db2$MAXMPL <= 0.50] <- 2
db2$MAXMPL[db2$MAXMPL<=0.25] <- 1
db2$MAXMPL = (db2$MAXMPL-min(db2$MAXMPL))/(max(db2$MAXMPL)-min(db2$MAXMPL))
db2$ACTROWPOOL = (db2$ACTROWPOOL-min(db2$ACTROWPOOL))/(max(db2$ACTROWPOOL)-min(db2$ACTROWPOOL))
db2$PCTREAD = (db2$PCTREAD-min(db2$PCTREAD))/(max(db2$PCTREAD)-min(db2$PCTREAD))
db2$PCTUPDATE = (db2$PCTUPDATE-min(db2$PCTUPDATE))/(max(db2$PCTUPDATE)-min(db2$PCTUPDATE))
db2$NUMPROCESSORS = (db2$NUMPROCESSORS-min(db2$NUMPROCESSORS))/(max(db2$NUMPROCESSORS)-min(db2$NUMPROCESSORS))
# oracle
oracle <- subset(x, x$DBMS=='oracle')
oracle$ATP = (oracle$ATP-min(oracle$ATP))/(max(oracle$ATP)-min(oracle$ATP))
oracle$ATP[oracle$ATP > 0.8 & oracle$ATP <= 1] <- 5
oracle$ATP[oracle$ATP > 0.6 & oracle$ATP <= 0.8] <- 4
oracle$ATP[oracle$ATP > 0.4 & oracle$ATP <= 0.6] <- 3
oracle$ATP[oracle$ATP > 0.2 & oracle$ATP <= 0.4] <- 2
oracle$ATP[oracle$ATP <= 0.2 ] <- 1
oracle$ATP = (oracle$ATP-min(oracle$ATP))/(max(oracle$ATP)-min(oracle$ATP))
oracle$MAXMPL = (oracle$MAXMPL-min(oracle$MAXMPL))/(max(oracle$MAXMPL)-min(oracle$MAXMPL))
oracle$MAXMPL[oracle$MAXMPL == 1] <- 5
oracle$MAXMPL[oracle$MAXMPL > 0.75 & oracle$MAXMPL <= 1] <- 4
oracle$MAXMPL[oracle$MAXMPL > 0.5 & oracle$MAXMPL <= 0.75] <- 3
oracle$MAXMPL[oracle$MAXMPL > 0.25 & oracle$MAXMPL <= 0.50] <- 2
oracle$MAXMPL[oracle$MAXMPL<=0.25] <- 1
oracle$MAXMPL = (oracle$MAXMPL-min(oracle$MAXMPL))/(max(oracle$MAXMPL)-min(oracle$MAXMPL))
oracle$ACTROWPOOL = (oracle$ACTROWPOOL-min(oracle$ACTROWPOOL))/(max(oracle$ACTROWPOOL)-min(oracle$ACTROWPOOL))
oracle$PCTREAD = (oracle$PCTREAD-min(oracle$PCTREAD))/(max(oracle$PCTREAD)-min(oracle$PCTREAD))
oracle$PCTUPDATE = (oracle$PCTUPDATE-min(oracle$PCTUPDATE))/(max(oracle$PCTUPDATE)-min(oracle$PCTUPDATE))
oracle$NUMPROCESSORS = (oracle$NUMPROCESSORS-min(oracle$NUMPROCESSORS))/(max(oracle$NUMPROCESSORS)-min(oracle$NUMPROCESSORS))
# mysql
mysql <- subset(x, x$DBMS=='mysql')
mysql$ATP = (mysql$ATP-min(mysql$ATP))/(max(mysql$ATP)-min(mysql$ATP))
mysql$ATP[mysql$ATP > 0.8 & mysql$ATP <= 1] <- 5
mysql$ATP[mysql$ATP > 0.6 & mysql$ATP <= 0.8] <- 4
mysql$ATP[mysql$ATP > 0.4 & mysql$ATP <= 0.6] <- 3
mysql$ATP[mysql$ATP > 0.2 & mysql$ATP <= 0.4] <- 2
mysql$ATP[mysql$ATP <= 0.2 ] <- 1
mysql$ATP = (mysql$ATP-min(mysql$ATP))/(max(mysql$ATP)-min(mysql$ATP))
mysql$MAXMPL = (mysql$MAXMPL-min(mysql$MAXMPL))/(max(mysql$MAXMPL)-min(mysql$MAXMPL))
mysql$MAXMPL[mysql$MAXMPL == 1] <- 5
mysql$MAXMPL[mysql$MAXMPL > 0.75 & mysql$MAXMPL <= 1] <- 4
mysql$MAXMPL[mysql$MAXMPL > 0.5 & mysql$MAXMPL <= 0.75] <- 3
mysql$MAXMPL[mysql$MAXMPL > 0.25 & mysql$MAXMPL <= 0.50] <- 2
mysql$MAXMPL[mysql$MAXMPL<=0.25] <- 1
mysql$MAXMPL = (mysql$MAXMPL-min(mysql$MAXMPL))/(max(mysql$MAXMPL)-min(mysql$MAXMPL))
mysql$ACTROWPOOL = (mysql$ACTROWPOOL-min(mysql$ACTROWPOOL))/(max(mysql$ACTROWPOOL)-min(mysql$ACTROWPOOL))
mysql$PCTREAD = (mysql$PCTREAD-min(mysql$PCTREAD))/(max(mysql$PCTREAD)-min(mysql$PCTREAD))
mysql$PCTUPDATE = (mysql$PCTUPDATE-min(mysql$PCTUPDATE))/(max(mysql$PCTUPDATE)-min(mysql$PCTUPDATE))
mysql$NUMPROCESSORS = (mysql$NUMPROCESSORS-min(mysql$NUMPROCESSORS))/(max(mysql$NUMPROCESSORS)-min(mysql$NUMPROCESSORS))
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
# sqlserver
sqlserver <- subset(x, x$DBMS=='sqlserver')
sqlserver$ACTROWPOOL = (sqlserver$ACTROWPOOL-min(sqlserver$ACTROWPOOL))/(max(sqlserver$ACTROWPOOL)-min(sqlserver$ACTROWPOOL))
sqlserver$PCTREAD = (sqlserver$PCTREAD-min(sqlserver$PCTREAD))/(max(sqlserver$PCTREAD)-min(sqlserver$PCTREAD))
sqlserver$PCTUPDATE = (sqlserver$PCTUPDATE-min(sqlserver$PCTUPDATE))/(max(sqlserver$PCTUPDATE)-min(sqlserver$PCTUPDATE))
sqlserver$NUMPROCESSORS = (sqlserver$NUMPROCESSORS-min(sqlserver$NUMPROCESSORS))/(max(sqlserver$NUMPROCESSORS)-min(sqlserver$NUMPROCESSORS))
sqlserver$ATP = (sqlserver$ATP-min(sqlserver$ATP))/(max(sqlserver$ATP)-min(sqlserver$ATP))
sqlserver$ATP[sqlserver$ATP > 0.8 & sqlserver$ATP <= 1] <- 5
sqlserver$ATP[sqlserver$ATP > 0.6 & sqlserver$ATP <= 0.8] <- 4
sqlserver$ATP[sqlserver$ATP > 0.4 & sqlserver$ATP <= 0.6] <- 3
sqlserver$ATP[sqlserver$ATP > 0.2 & sqlserver$ATP <= 0.4] <- 2
sqlserver$ATP[sqlserver$ATP <= 0.2 ] <- 1
sqlserver$ATP = (sqlserver$ATP-min(sqlserver$ATP))/(max(sqlserver$ATP)-min(sqlserver$ATP))
sqlserver$MAXMPL = (sqlserver$MAXMPL-min(sqlserver$MAXMPL))/(max(sqlserver$MAXMPL)-min(sqlserver$MAXMPL))
sqlserver$MAXMPL[sqlserver$MAXMPL == 1] <- 5
sqlserver$MAXMPL[sqlserver$MAXMPL > 0.75 & sqlserver$MAXMPL <= 1] <- 4
sqlserver$MAXMPL[sqlserver$MAXMPL > 0.5 & sqlserver$MAXMPL <= 0.75] <- 3
sqlserver$MAXMPL[sqlserver$MAXMPL > 0.25 & sqlserver$MAXMPL <= 0.50] <- 2
sqlserver$MAXMPL[sqlserver$MAXMPL<=0.25] <- 1
sqlserver$MAXMPL = (sqlserver$MAXMPL-min(sqlserver$MAXMPL))/(max(sqlserver$MAXMPL)-min(sqlserver$MAXMPL))
x = rbind(db2,oracle,mysql,pgsql,sqlserver) 
x$ACTROWPOOL = (x$ACTROWPOOL-min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)-min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD-min(x$PCTREAD))/(max(x$PCTREAD)-min(x$PCTREAD))
x$PCTUPDATE = (x$PCTUPDATE-min(x$PCTUPDATE))/(max(x$PCTUPDATE)-min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS-min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)-min(x$NUMPROCESSORS))

> cor(x$NUMPROCESSORS, x$ATP)
[1] -0.1262903
> cor(x$PCTREAD, x$ATP)
[1] 0.05245677
> cor(x$PK, x$ATP)
[1] -0.2166788
> cor(x$PCTUPDATE, x$ATP)
-0.1078481
> cor(x$ACTROWPOOL, x$ATP)
[1] 0.07394266
> cor(x$ATP, x$MAXMPL)
[1] -0.1007889
>  cor(x$NUMPROCESSORS, x$MAXMPL)
[1] 0.0006660305
> cor(x$PCTREAD, x$MAXMPL)
[1] -0.05633367
>  cor(x$PCTUPDATE, x$MAXMPL)
[1] 0.008980045
> cor(x$ACTROWPOOL, x$MAXMPL)
[1] -0.05982288
> cor(x$PK, x$MAXMPL)
[1] 0.1547508

med.fit <- lm(ATP ~ NUMPROCESSORS + PK + PCTUPDATE + PCTUPDATE:PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK + PCTUPDATE + PCTUPDATE:PK, 
	    data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.3167 -0.1438 -0.1008  0.1092  0.9638 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.31675    0.01893  16.731  < 2e-16 ***
	NUMPROCESSORS -0.08691    0.02207  -3.939 8.77e-05 ***
	PK            -0.19367    0.02466  -7.854 1.03e-14 ***
	PCTUPDATE     -0.17204    0.03200  -5.376 9.48e-08 ***
	PK:PCTUPDATE   0.19096    0.04638   4.118 4.15e-05 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2744 on 999 degrees of freedom
	Multiple R-squared:  0.08805,	Adjusted R-squared:  0.0844 
	F-statistic: 24.11 on 4 and 999 DF,  p-value: < 2.2e-16

	-----

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK + PCTUPDATE + PCTUPDATE:PK, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.31739 -0.13452 -0.09765  0.10099  0.90127 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.31761    0.01722  18.440  < 2e-16 ***
	NUMPROCESSORS -0.07736    0.02007  -3.854 0.000124 ***
	PK            -0.18572    0.02243  -8.279 3.94e-16 ***
	PCTUPDATE     -0.20427    0.02911  -7.016 4.19e-12 ***
	PK:PCTUPDATE   0.21675    0.04219   5.137 3.35e-07 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2497 on 999 degrees of freedom
	Multiple R-squared:  0.09942,	Adjusted R-squared:  0.09581 
	F-statistic: 27.57 on 4 and 999 DF,  p-value: < 2.2e-16


out.fit <- lm(MAXMPL ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS + PK, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + 
	    NUMPROCESSORS + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.70530 -0.41064 -0.03958  0.39791  0.58366 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.59000    0.03612  16.333  < 2e-16 ***
	PCTREAD       -0.08037    0.04521  -1.778   0.0758 .  
	PCTUPDATE     -0.03035    0.03919  -0.775   0.4387    
	ACTROWPOOL    -0.06100    0.03536  -1.725   0.0848 .  
	ATP           -0.10025    0.04791  -2.092   0.0367 *  
	NUMPROCESSORS -0.01162    0.03388  -0.343   0.7317    
	PK             0.11776    0.02706   4.353 1.48e-05 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.418 on 997 degrees of freedom
	Multiple R-squared:  0.03472,	Adjusted R-squared:  0.02892 
	F-statistic: 5.978 on 6 and 997 DF,  p-value: 3.759e-06

	-----

	Call:
	lm(formula = MAXMPL ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + 
	    NUMPROCESSORS + PK, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.7600 -0.3335  0.0322  0.3373  0.5151 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.64604    0.03308  19.528  < 2e-16 ***
	PCTREAD       -0.06920    0.04109  -1.684   0.0925 .  
	PCTUPDATE     -0.01534    0.03572  -0.429   0.6677    
	ACTROWPOOL    -0.05922    0.03214  -1.843   0.0656 .  
	ATP           -0.06614    0.04766  -1.388   0.1655    
	NUMPROCESSORS -0.03204    0.03078  -1.041   0.2981    
	PK             0.11938    0.02451   4.871 1.29e-06 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3798 on 997 degrees of freedom
	Multiple R-squared:  0.03653,	Adjusted R-squared:  0.03073 
	F-statistic:   6.3 on 6 and 997 DF,  p-value: 1.628e-06

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS", robustSE = TRUE, conf.level=.1, sims = 100)
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK", robustSE = TRUE, conf.level = .1, sims = 100)
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE", robustSE = TRUE, conf.level = .1, sims = 100)
sens.out <- medsens(med.out, effect.type = "both")

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS", robustSE = TRUE)
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            0.00854      0.00106      0.01852    0.02
	ADE            -0.01067     -0.07685      0.05372    0.74
	Total Effect   -0.00213     -0.06775      0.06101    0.94
	Prop. Mediated -0.06342     -3.56913      4.56808    0.95

	Sample Size Used: 1004 


	Simulations: 1000 

----
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

sens.out <- medsens(med.out, effect.type = "both")
### conflicting mediation effects made by PK (positive) and NUMPROCESSORS (negative) on DBMS thrashing
### no mediation looks happening.
### If we gather data, direct effects from PK or NUMPROCESSORS are too strong, the indirect effects through ATP time seem hidden. 
### PK and NUMPROCESSORS make confounding effects, so the overall amount of variance explained so low.

> sens.out <- medsens(med.out, effect.type = "both")
> summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.1 -0.0044      -0.0125       0.0037         0.01       0.0088
	[2,]  0.0  0.0087      -0.0001       0.0175         0.00       0.0000

	Rho at which ACME = 0: -0.1
	R^2_M*R^2_Y* at which ACME = 0: 0.01
	R^2_M~R^2_Y~ at which ACME = 0: 0.0088 


	Mediation Sensitivity Analysis for Average Direct Effect

	Sensitivity Region

	       Rho     ADE 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	 [1,] -0.5  0.0652      -0.0096       0.1400         0.25       0.2201
	 [2,] -0.4  0.0464      -0.0249       0.1178         0.16       0.1408
	 [3,] -0.3  0.0301      -0.0390       0.0993         0.09       0.0792
	 [4,] -0.2  0.0154      -0.0524       0.0833         0.04       0.0352
	 [5,] -0.1  0.0017      -0.0656       0.0689         0.01       0.0088
	 [6,]  0.0 -0.0116      -0.0789       0.0556         0.00       0.0000
	 [7,]  0.1 -0.0249      -0.0927       0.0430         0.01       0.0088
	 [8,]  0.2 -0.0385      -0.1075       0.0305         0.04       0.0352
	 [9,]  0.3 -0.0530      -0.1239       0.0180         0.09       0.0792
	[10,]  0.4 -0.0689      -0.1426       0.0048         0.16       0.1408

	Rho at which ADE = 0: -0.1
	R^2_M*R^2_Y* at which ADE = 0: 0.01
	R^2_M~R^2_Y~ at which ADE = 0: 0.0088 

-------------------------------------------------------

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

------
> sens.out$r.square.y
[1] 0.0347248
> sens.out$r.square.m
[1] 0.0880479

-----

> sens.out$r.square.y
[1] 0.03652878
> sens.out$r.square.m
[1] 0.09941995

----
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK", robustSE = TRUE)
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            0.01216      0.00125      0.02491    0.03
	ADE             0.11808      0.06184      0.17516    0.00
	Total Effect    0.13024      0.07633      0.18473    0.00
	Prop. Mediated  0.09120      0.00957      0.21887    0.03

	Sample Size Used: 1004 


	Simulations: 1000 

sens.out <- medsens(med.out, effect.type = "both")
summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.1 -0.0093      -0.0261       0.0075         0.01       0.0088

	Rho at which ACME = 0: -0.1
	R^2_M*R^2_Y* at which ACME = 0: 0.01
	R^2_M~R^2_Y~ at which ACME = 0: 0.0088 


	Mediation Sensitivity Analysis for Average Direct Effect

	Sensitivity Region

	     Rho     ADE 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] 0.4  0.0390      -0.0184       0.0963         0.16       0.1408
	[2,] 0.5  0.0137      -0.0468       0.0741         0.25       0.2201
	[3,] 0.6 -0.0173      -0.0824       0.0478         0.36       0.3169
	[4,] 0.7 -0.0587      -0.1311       0.0138         0.49       0.4313

	Rho at which ADE = 0: 0.5
	R^2_M*R^2_Y* at which ADE = 0: 0.25
	R^2_M~R^2_Y~ at which ADE = 0: 0.2201 

>  sens.out$r.square.y
[1] 0.0347248
>  sens.out$r.square.m
[1] 0.0880479

----

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

------

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE", robustSE = TRUE)
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		        Estimate 95% CI Lower 95% CI Upper p-value
	ACME            0.008062     0.000107     0.018812    0.04
	ADE            -0.031368    -0.110182     0.039066    0.44
	Total Effect   -0.023306    -0.102525     0.048560    0.56
	Prop. Mediated -0.123874    -2.758395     2.908508    0.58

	Sample Size Used: 1004 


	Simulations: 1000 

sens.out <- medsens(med.out, effect.type = "both")
summary(sens.out)

Mediation Sensitivity Analysis for Average Causal Mediation Effect

Sensitivity Region

      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
[1,] -0.1 -0.0081       -0.023       0.0067         0.01       0.0088

Rho at which ACME = 0: -0.1
R^2_M*R^2_Y* at which ACME = 0: 0.01
R^2_M~R^2_Y~ at which ACME = 0: 0.0088 


Mediation Sensitivity Analysis for Average Direct Effect

Sensitivity Region

       Rho     ADE 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
 [1,] -0.7  0.0896      -0.0087       0.1880         0.49       0.4313
 [2,] -0.6  0.0613      -0.0278       0.1504         0.36       0.3169
 [3,] -0.5  0.0401      -0.0434       0.1236         0.25       0.2201
 [4,] -0.4  0.0228      -0.0572       0.1027         0.16       0.1408
 [5,] -0.3  0.0078      -0.0700       0.0856         0.09       0.0792
 [6,] -0.2 -0.0057      -0.0822       0.0709         0.04       0.0352
 [7,] -0.1 -0.0182      -0.0943       0.0578         0.01       0.0088
 [8,]  0.0 -0.0304      -0.1066       0.0459         0.00       0.0000
 [9,]  0.1 -0.0424      -0.1194       0.0346         0.01       0.0088
[10,]  0.2 -0.0548      -0.1332       0.0236         0.04       0.0352
[11,]  0.3 -0.0679      -0.1485       0.0126         0.09       0.0792
[12,]  0.4 -0.0824      -0.1661       0.0013         0.16       0.1408

Rho at which ADE = 0: -0.2
R^2_M*R^2_Y* at which ADE = 0: 0.04
R^2_M~R^2_Y~ at which ADE = 0: 0.0352 

-----

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

y <- subset(x, x$PK == 0)
med.fit <- lm(ATP ~ NUMPROCESSORS + PCTUPDATE, data = y)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PCTUPDATE, data = y)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.3158 -0.2056 -0.1011  0.2409  0.8371 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.31606    0.02025  15.605  < 2e-16 ***
	NUMPROCESSORS -0.07346    0.03029  -2.425   0.0156 *  
	PCTUPDATE     -0.20429    0.03131  -6.525 1.62e-10 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2685 on 520 degrees of freedom
	Multiple R-squared:  0.08561,	Adjusted R-squared:  0.08209 
	F-statistic: 24.34 on 2 and 520 DF,  p-value: 7.846e-11

out.fit <- lm(MAXMPL ~ PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS + PCTUPDATE, data = y)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS + 
	    PCTUPDATE, data = y)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.70199 -0.40446 -0.00471  0.38930  0.57964 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.56637    0.04515  12.545   <2e-16 ***
	PCTREAD       -0.09485    0.05800  -1.635   0.1026    
	ACTROWPOOL    -0.04236    0.04629  -0.915   0.3606    
	ATP           -0.03914    0.06452  -0.607   0.5443    
	NUMPROCESSORS  0.02007    0.04478   0.448   0.6542    
	PCTUPDATE      0.11603    0.05247   2.211   0.0275 *  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3944 on 517 degrees of freedom
	Multiple R-squared:  0.03086,	Adjusted R-squared:  0.02148 
	F-statistic: 3.292 on 5 and 517 DF,  p-value: 0.006162


y <- subset(x, x$PK == 1)
med.fit <- lm(ATP ~ NUMPROCESSORS + PCTUPDATE, data = y)
summary(med.fit)

Call:
lm(formula = ATP ~ NUMPROCESSORS + PCTUPDATE, data = y)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.14557 -0.12085 -0.09503 -0.04984  0.90130 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept)    0.13358    0.01848   7.229 1.94e-12 ***
NUMPROCESSORS -0.08140    0.02609  -3.120  0.00192 ** 
PCTUPDATE      0.01236    0.02785   0.444  0.65737    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.2276 on 478 degrees of freedom
Multiple R-squared:  0.02049,	Adjusted R-squared:  0.01639 
F-statistic: 4.999 on 2 and 478 DF,  p-value: 0.007104

out.fit <- lm(MAXMPL ~ PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS + PCTUPDATE, data = y)
summary(out.fit)

Call:
lm(formula = MAXMPL ~ PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS + 
    PCTUPDATE, data = y)

Residuals:
    Min      1Q  Median      3Q     Max 
-0.8286 -0.2515  0.1864  0.2900  0.4875 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept)    0.84099    0.03975  21.159  < 2e-16 ***
PCTREAD       -0.03542    0.05681  -0.624  0.53323    
ACTROWPOOL    -0.08032    0.04351  -1.846  0.06549 .  
ATP           -0.01651    0.07191  -0.230  0.81849    
NUMPROCESSORS -0.08390    0.04114  -2.039  0.04196 *  
PCTUPDATE     -0.15491    0.04792  -3.233  0.00131 ** 
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.3551 on 475 degrees of freedom
Multiple R-squared:  0.0374,	Adjusted R-squared:  0.02727 
F-statistic: 3.691 on 5 and 475 DF,  p-value: 0.002751

> test.modmed(med.out, covariates.1 = list (x$PK == 1), covariates.2 = list (x$PK == 0), data = x)

	Test of ACME(covariates.1) - ACME(covariates.2) = 0

data:  estimates from med.out
ACME(covariates.1) - ACME(covariates.2) = 1e-04, p-value = 0.992
alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
95 percent confidence interval:
 -0.01236105  0.01267306


	Test of ADE(covariates.1) - ADE(covariates.2) = 0

data:  estimates from med.out
ADE(covariates.1) - ADE(covariates.2) = 8e-04, p-value = 0.968
alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
95 percent confidence interval:
 -0.1045509  0.1084276


-----
library(lavaan)
thrashing_model <- '
     # mediator
      ATP ~ a1*NUMPROCESSORS+a3*PK+a4*PCTUPDATE
    # dependent variable
     # MAXMPL ~ b1*ATP+c1*NUMPROCESSORS+c2*ACTROWPOOL+c4*PCTUPDATE+c5*PCTREAD+c3*PK
      MAXMPL ~ b1*ATP+c1*NUMPROCESSORS+c2*ACTROWPOOL+c4*PCTUPDATE+c5*PCTREAD+c3*PK
   # interactions
    # INT_1 := a3*a4
	'
#fit <- sem(thrashing_model, estimator="DWLS", data = x)
#fit <- sem(thrashing_model, data = x)
fit <- sem(thrashing_model,estimator="WLSMV", data = x)
#fit <- sem(thrashing_model,estimator="MLMVS", data = x)
#fit <- sem(thrashing_model,estimator="MLR", data = x)
summary(fit, fit.measures = TRUE, standardized=TRUE, rsq=T)

---

lavaan (0.5-17) converged normally after  72 iterations

  Number of observations                          1004

  Estimator                                       DWLS      Robust
  Minimum Function Test Statistic                4.729       6.394
  Degrees of freedom                                 2           2
  P-value (Chi-square)                           0.094       0.041
  Scaling correction factor                                  0.743
  Shift parameter                                            0.032
    for simple second-order correction (Mplus variant)

Model test baseline model:

  Minimum Function Test Statistic              129.741     120.370
  Degrees of freedom                                11          11
  P-value                                        0.000       0.000

User model versus baseline model:

  Comparative Fit Index (CFI)                    0.977       0.960
  Tucker-Lewis Index (TLI)                       0.874       0.779

Root Mean Square Error of Approximation:

  RMSEA                                          0.037       0.047
  90 Percent Confidence Interval          0.000  0.081       0.008  0.090
  P-value RMSEA <= 0.05                          0.618       0.471

Standardized Root Mean Square Residual:

  SRMR                                           0.011       0.011

Parameter estimates:

  Information                                 Expected
  Standard Errors                           Robust.sem

                   Estimate  Std.err  Z-value  P(>|z|)   Std.lv  Std.all
Regressions:
  ATP ~
    NUMPROCE (a1)    -0.089    0.021   -4.186    0.000   -0.089   -0.122
    PK       (a3)    -0.123    0.017   -7.089    0.000   -0.123   -0.213
    PCTUPDAT (a4)    -0.083    0.024   -3.407    0.001   -0.083   -0.109
  MAXMPL ~
    ATP      (b1)    -0.107    0.045   -2.346    0.019   -0.107   -0.072
    NUMPROCE (c1)    -0.013    0.034   -0.369    0.712   -0.013   -0.012
    ACTROWPO (c2)    -0.064    0.035   -1.815    0.069   -0.064   -0.057
    PCTUPDAT (c4)    -0.032    0.039   -0.814    0.416   -0.032   -0.028
    PCTREAD  (c5)    -0.081    0.045   -1.792    0.073   -0.081   -0.062
    PK       (c3)     0.116    0.027    4.313    0.000    0.116    0.137

Covariances:
  NUMPROCESSORS ~~
    PK                0.006    0.006    0.899    0.369    0.006    0.028
    PCTUPDATE        -0.001    0.005   -0.236    0.813   -0.001   -0.007
    ACTROWPOOL       -0.002    0.005   -0.457    0.648   -0.002   -0.015
    PCTREAD           0.003    0.004    0.820    0.412    0.003    0.027
  PK ~~
    PCTUPDATE         0.002    0.006    0.406    0.684    0.002    0.013
    ACTROWPOOL       -0.005    0.006   -0.810    0.418   -0.005   -0.026
    PCTREAD          -0.004    0.005   -0.707    0.480   -0.004   -0.023
  PCTUPDATE ~~
    ACTROWPOOL       -0.002    0.004   -0.444    0.657   -0.002   -0.014
    PCTREAD          -0.052    0.003  -14.781    0.000   -0.052   -0.427
  ACTROWPOOL ~~
    PCTREAD          -0.001    0.004   -0.205    0.838   -0.001   -0.006

Intercepts:
    ATP               0.285    0.020   14.534    0.000    0.285    0.994
    MAXMPL            0.594    0.038   15.694    0.000    0.594    1.401
    NUMPROCESSORS     0.399    0.012   32.181    0.000    0.399    1.016
    PK                0.479    0.016   30.357    0.000    0.479    0.959
    PCTUPDATE         0.377    0.012   31.929    0.000    0.377    1.008
    ACTROWPOOL        0.499    0.012   42.189    0.000    0.499    1.332
    PCTREAD           0.137    0.010   13.394    0.000    0.137    0.423

Variances:
    ATP               0.076    0.005                      0.076    0.926
    MAXMPL            0.174    0.004                      0.174    0.965
    NUMPROCESSORS     0.154    0.004                      0.154    1.000
    PK                0.250    0.001                      0.250    1.000
    PCTUPDATE         0.140    0.004                      0.140    1.000
    ACTROWPOOL        0.140    0.004                      0.140    1.000
    PCTREAD           0.104    0.008                      0.104    1.000

R-Square:

    ATP               0.074
    MAXMPL            0.035
