# oracle
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
oracle <- subset(x, x$DBMS=='oracle')
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
x = rbind(oracle) 

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
	-0.73284 -0.33432 -0.08006  0.34368  0.96619 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.79051    0.08263   9.567  < 2e-16 ***
	NUMPROCESSORS -0.44615    0.07738  -5.766  3.2e-08 ***
	ATP           -0.45192    0.23275  -1.942  0.05364 .  
	PCTREAD       -0.01634    0.09954  -0.164  0.86979    
	PCTUPDATE     -0.26281    0.09330  -2.817  0.00536 ** 
	ACTROWPOOL     0.01864    0.08065   0.231  0.81750    
	PK            -0.01205    0.06457  -0.187  0.85214    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.4187 on 192 degrees of freedom
	Multiple R-squared:  0.2033,	Adjusted R-squared:  0.1784 
	F-statistic: 8.165 on 6 and 192 DF,  p-value: 7.13e-08


med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS", robustSE = TRUE)
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.02715     -0.06787      0.00397    0.09
	ADE            -0.44627     -0.58248     -0.29888    0.00
	Total Effect   -0.47342     -0.60922     -0.31229    0.00
	Prop. Mediated  0.05185     -0.00959      0.14178    0.09

	Sample Size Used: 199 


	Simulations: 1000

sens.out <- medsens(med.out, effect.type = "both")
summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.3  0.0275      -0.0055       0.0606         0.09       0.0419
	[2,] -0.2  0.0082      -0.0193       0.0356         0.04       0.0186
	[3,] -0.1 -0.0098      -0.0378       0.0182         0.01       0.0047
	[4,]  0.0 -0.0270      -0.0602       0.0062         0.00       0.0000

	Rho at which ACME = 0: -0.2
	R^2_M*R^2_Y* at which ACME = 0: 0.04
	R^2_M~R^2_Y~ at which ACME = 0: 0.0186 


	Mediation Sensitivity Analysis for Average Direct Effect

	Sensitivity Region

	     Rho     ADE 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] 0.9 -0.1259      -0.4497       0.1978         0.81       0.3773

	Rho at which ADE = 0: 0.9
	R^2_M*R^2_Y* at which ADE = 0: 0.81
	R^2_M~R^2_Y~ at which ADE = 0: 0.3773 

> sens.out$r.square.y
[1] 0.2032898
> sens.out$r.square.m
[1] 0.415412

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK", robustSE = TRUE)
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		        Estimate 95% CI Lower 95% CI Upper p-value
	ACME            0.050663    -0.000747     0.115207    0.05
	ADE            -0.011489    -0.130231     0.103236    0.85
	Total Effect    0.039174    -0.075277     0.156191    0.52
	Prop. Mediated  0.582217    -7.025444    12.484710    0.54

	Sample Size Used: 199 


	Simulations: 1000

> sens.out <- medsens(med.out, effect.type = "both")
> summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.3 -0.0971      -0.1955       0.0013         0.09       0.0419
	[2,] -0.2 -0.0300      -0.1286       0.0686         0.04       0.0186
	[3,] -0.1  0.0369      -0.0659       0.1397         0.01       0.0047
	[4,]  0.0  0.1039      -0.0059       0.2137         0.00       0.0000

	Rho at which ACME = 0: -0.2
	R^2_M*R^2_Y* at which ACME = 0: 0.04
	R^2_M~R^2_Y~ at which ACME = 0: 0.0186 


	Mediation Sensitivity Analysis for Average Direct Effect

	Sensitivity Region

	      Rho     ADE 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.3  0.0886      -0.0329       0.2101         0.09       0.0419
	[2,] -0.2  0.0524      -0.0659       0.1707         0.04       0.0186
	[3,] -0.1  0.0193      -0.0972       0.1358         0.01       0.0047
	[4,]  0.0 -0.0121      -0.1279       0.1038         0.00       0.0000
	[5,]  0.1 -0.0427      -0.1591       0.0736         0.01       0.0047
	[6,]  0.2 -0.0739      -0.1919       0.0441         0.04       0.0186
	[7,]  0.3 -0.1067      -0.2277       0.0142         0.09       0.0419

	Rho at which ADE = 0: 0
	R^2_M*R^2_Y* at which ADE = 0: 0
	R^2_M~R^2_Y~ at which ADE = 0: 0 

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE", robustSE = TRUE)
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME             0.0662      -0.0101       0.1500    0.08
	ADE             -0.2633      -0.4566      -0.0724    0.00
	Total Effect    -0.1972      -0.3816      -0.0100    0.04
	Prop. Mediated  -0.3186      -2.8246       0.1451    0.12

	Sample Size Used: 199 


	Simulations: 1000 

> sens.out <- medsens(med.out, effect.type = "both")
> summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.3 -0.1286      -0.2589       0.0017         0.09       0.0419
	[2,] -0.2 -0.0396      -0.1701       0.0908         0.04       0.0186
	[3,] -0.1  0.0488      -0.0871       0.1846         0.01       0.0047
	[4,]  0.0  0.1372      -0.0079       0.2822         0.00       0.0000

	Rho at which ACME = 0: -0.2
	R^2_M*R^2_Y* at which ACME = 0: 0.04
	R^2_M~R^2_Y~ at which ACME = 0: 0.0186 


	Mediation Sensitivity Analysis for Average Direct Effect

	Sensitivity Region

	      Rho     ADE 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.7  0.1939      -0.0492       0.4370         0.49       0.2282
	[2,] -0.6  0.0835      -0.1372       0.3041         0.36       0.1677
	[3,] -0.5  0.0011      -0.2050       0.2072         0.25       0.1164
	[4,] -0.4 -0.0654      -0.2614       0.1306         0.16       0.0745
	[5,] -0.3 -0.1220      -0.3107       0.0667         0.09       0.0419
	[6,] -0.2 -0.1723      -0.3556       0.0110         0.04       0.0186

	Rho at which ADE = 0: -0.5
	R^2_M*R^2_Y* at which ADE = 0: 0.25
	R^2_M~R^2_Y~ at which ADE = 0: 0.1164
