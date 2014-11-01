# sqlserver
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
# sqlserver
sqlserver <- subset(x, x$DBMS=='sqlserver')
sqlserver$ACTROWPOOL = (sqlserver$ACTROWPOOL-min(sqlserver$ACTROWPOOL))/(max(sqlserver$ACTROWPOOL)-min(sqlserver$ACTROWPOOL))
sqlserver$PCTREAD = (sqlserver$PCTREAD-min(sqlserver$PCTREAD))/(max(sqlserver$PCTREAD)-min(sqlserver$PCTREAD))
sqlserver$PCTUPDATE = (sqlserver$PCTUPDATE-min(sqlserver$PCTUPDATE))/(max(sqlserver$PCTUPDATE)-min(sqlserver$PCTUPDATE))
sqlserver$NUMPROCESSORS = (sqlserver$NUMPROCESSORS-min(sqlserver$NUMPROCESSORS))/(max(sqlserver$NUMPROCESSORS)-min(sqlserver$NUMPROCESSORS))
sqlserver$ATP = (sqlserver$ATP-min(sqlserver$ATP))/(max(sqlserver$ATP)-min(sqlserver$ATP))
sqlserver$MAXMPL = (sqlserver$MAXMPL-min(sqlserver$MAXMPL))/(max(sqlserver$MAXMPL)-min(sqlserver$MAXMPL))
sqlserver$MAXMPL[sqlserver$MAXMPL == 1] <- 5
sqlserver$MAXMPL[sqlserver$MAXMPL > 0.75 & sqlserver$MAXMPL <= 1] <- 4
sqlserver$MAXMPL[sqlserver$MAXMPL > 0.5 & sqlserver$MAXMPL <= 0.75] <- 3
sqlserver$MAXMPL[sqlserver$MAXMPL > 0.25 & sqlserver$MAXMPL <= 0.50] <- 2
sqlserver$MAXMPL[sqlserver$MAXMPL<=0.25] <- 1
sqlserver$MAXMPL = (sqlserver$MAXMPL-min(sqlserver$MAXMPL))/(max(sqlserver$MAXMPL)-min(sqlserver$MAXMPL))
x = rbind(sqlserver) 

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
	-0.56447 -0.14545  0.03574  0.15405  0.61920 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.404712   0.051585   7.846 2.19e-13 ***
	NUMPROCESSORS  0.427110   0.057072   7.484 1.98e-12 ***
	ATP           -0.015937   0.070779  -0.225 0.822069    
	PCTREAD        0.009551   0.061123   0.156 0.875982    
	PCTUPDATE     -0.214807   0.054772  -3.922 0.000119 ***
	ACTROWPOOL     0.019510   0.049144   0.397 0.691777    
	PK            -0.039888   0.036741  -1.086 0.278889    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2692 on 209 degrees of freedom
	Multiple R-squared:  0.3404,	Adjusted R-squared:  0.3215 
	F-statistic: 17.98 on 6 and 209 DF,  p-value: < 2.2e-16

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS", robustSE = TRUE)
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            0.00698     -0.04005      0.05136    0.73
	ADE             0.42798      0.31655      0.54899    0.00
	Total Effect    0.43496      0.34437      0.52257    0.00
	Prop. Mediated  0.01795     -0.08143      0.13216    0.73

	Sample Size Used: 216 


	Simulations: 1000 

sens.out <- medsens(med.out, effect.type = "both")
summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.1 -0.0391      -0.0829       0.0047         0.01       0.0044
	[2,]  0.0  0.0072      -0.0360       0.0504         0.00       0.0000

	Rho at which ACME = 0: 0
	R^2_M*R^2_Y* at which ACME = 0: 0
	R^2_M~R^2_Y~ at which ACME = 0: 0 


	Mediation Sensitivity Analysis for Average Direct Effect

	Sensitivity Region

	     Rho     ADE 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] 0.6  0.0820      -0.0554       0.2194         0.36       0.1589
	[2,] 0.7 -0.0239      -0.1718       0.1239         0.49       0.2163

	Rho at which ADE = 0: 0.7
	R^2_M*R^2_Y* at which ADE = 0: 0.49
	R^2_M~R^2_Y~ at which ADE = 0: 0.2163


> sens.out$r.square.y
[1] 0.3404484
> sens.out$r.square.m
[1] 0.3307554

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK", robustSE = TRUE)
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		        Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.000224    -0.005662     0.004130    0.94
	ADE            -0.037767    -0.107118     0.036749    0.29
	Total Effect   -0.037990    -0.108169     0.036220    0.30
	Prop. Mediated  0.002043    -0.317116     0.538002    0.91

	Sample Size Used: 216 


	Simulations: 1000 

> sens.out <- medsens(med.out, effect.type = "both")
> summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	       Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	 [1,] -0.9  0.0551      -0.0876       0.1978         0.81       0.3575
	 [2,] -0.8  0.0398      -0.0521       0.1317         0.64       0.2825
	 [3,] -0.7  0.0316      -0.0360       0.0993         0.49       0.2163
	 [4,] -0.6  0.0256      -0.0263       0.0775         0.36       0.1589
	 [5,] -0.5  0.0205      -0.0195       0.0605         0.25       0.1104
	 [6,] -0.4  0.0158      -0.0144       0.0461         0.16       0.0706
	 [7,] -0.3  0.0115      -0.0103       0.0332         0.09       0.0397
	 [8,] -0.2  0.0073      -0.0068       0.0213         0.04       0.0177
	 [9,] -0.1  0.0033      -0.0038       0.0104         0.01       0.0044
	[10,]  0.0 -0.0006      -0.0044       0.0032         0.00       0.0000
	[11,]  0.1 -0.0044      -0.0135       0.0047         0.01       0.0044
	[12,]  0.2 -0.0081      -0.0243       0.0082         0.04       0.0177
	[13,]  0.3 -0.0117      -0.0358       0.0124         0.09       0.0397
	[14,]  0.4 -0.0153      -0.0481       0.0175         0.16       0.0706
	[15,]  0.5 -0.0189      -0.0618       0.0240         0.25       0.1104
	[16,]  0.6 -0.0228      -0.0781       0.0325         0.36       0.1589
	[17,]  0.7 -0.0274      -0.0993       0.0444         0.49       0.2163
	[18,]  0.8 -0.0339      -0.1312       0.0634         0.64       0.2825
	[19,]  0.9 -0.0474      -0.1971       0.1023         0.81       0.3575

	Rho at which ACME = 0: 0
	R^2_M*R^2_Y* at which ACME = 0: 0
	R^2_M~R^2_Y~ at which ACME = 0: 0 


	Mediation Sensitivity Analysis for Average Direct Effect

	Sensitivity Region

	       Rho     ADE 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	 [1,] -0.9 -0.0846      -0.2480       0.0788         0.81       0.3575
	 [2,] -0.8 -0.0688      -0.1875       0.0500         0.64       0.2825
	 [3,] -0.7 -0.0611      -0.1609       0.0387         0.49       0.2163
	 [4,] -0.6 -0.0561      -0.1451       0.0328         0.36       0.1589
	 [5,] -0.5 -0.0524      -0.1344       0.0297         0.25       0.1104
	 [6,] -0.4 -0.0493      -0.1267       0.0281         0.16       0.0706
	 [7,] -0.3 -0.0467      -0.1209       0.0275         0.09       0.0397
	 [8,] -0.2 -0.0443      -0.1164       0.0278         0.04       0.0177
	 [9,] -0.1 -0.0421      -0.1129       0.0288         0.01       0.0044
	[10,]  0.0 -0.0399      -0.1103       0.0305         0.00       0.0000
	[11,]  0.1 -0.0377      -0.1084       0.0329         0.01       0.0044
	[12,]  0.2 -0.0355      -0.1071       0.0362         0.04       0.0177
	[13,]  0.3 -0.0331      -0.1066       0.0404         0.09       0.0397
	[14,]  0.4 -0.0304      -0.1069       0.0460         0.16       0.0706
	[15,]  0.5 -0.0274      -0.1082       0.0535         0.25       0.1104
	[16,]  0.6 -0.0236      -0.1112       0.0639         0.36       0.1589
	[17,]  0.7 -0.0187      -0.1168       0.0794         0.49       0.2163
	[18,]  0.8 -0.0110      -0.1279       0.1059         0.64       0.2825
	[19,]  0.9  0.0048      -0.1564       0.1661         0.81       0.3575

	Rho at which ADE = 0: 0.9
	R^2_M*R^2_Y* at which ADE = 0: 0.81
	R^2_M~R^2_Y~ at which ADE = 0: 0.3575

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE", robustSE = TRUE)
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.00230     -0.01746      0.01171    0.71
	ADE            -0.21165     -0.31721     -0.10211    0.00
	Total Effect   -0.21395     -0.32158     -0.10072    0.00
	Prop. Mediated  0.00869     -0.07103      0.07859    0.71

	Sample Size Used: 216 


	Simulations: 1000

> sens.out <- medsens(med.out, effect.type = "both")
> summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.2  0.0286      -0.0002       0.0573         0.04       0.0177
	[2,] -0.1  0.0129      -0.0053       0.0310         0.01       0.0044
	[3,]  0.0 -0.0024      -0.0167       0.0120         0.00       0.0000
	[4,]  0.1 -0.0174      -0.0381       0.0033         0.01       0.0044

	Rho at which ACME = 0: 0
	R^2_M*R^2_Y* at which ACME = 0: 0
	R^2_M~R^2_Y~ at which ACME = 0: 0 


	Mediation Sensitivity Analysis for Average Direct Effect

	Sensitivity Region

	     Rho     ADE 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] 0.6 -0.1179      -0.2458       0.0101         0.36       0.1589
	[2,] 0.7 -0.0881      -0.2297       0.0536         0.49       0.2163
	[3,] 0.8 -0.0423      -0.2084       0.1238         0.64       0.2825
	[4,] 0.9  0.0524      -0.1716       0.2764         0.81       0.3575

	Rho at which ADE = 0: 0.8
	R^2_M*R^2_Y* at which ADE = 0: 0.64
	R^2_M~R^2_Y~ at which ADE = 0: 0.2825 



y <- subset(x, x$PK == 0)
cor(y$PCTUPDATE, y$MAXMPL)
y <- subset(x, x$PK == 1)
cor(y$PCTUPDATE, y$MAXMPL)
y <- subset(x, x$PK == 0)
cor(y$PCTUPDATE, y$ATP)
y <- subset(x, x$PK == 1)
cor(y$PCTUPDATE, y$ATP)

> y <- subset(x, x$PK == 0)
> cor(y$PCTUPDATE, y$MAXMPL)
[1] -0.1330634
> y <- subset(x, x$PK == 1)
> cor(y$PCTUPDATE, y$MAXMPL)
[1] -0.2025411
> y <- subset(x, x$PK == 0)
> cor(y$PCTUPDATE, y$ATP)
[1] 0.1795936
> y <- subset(x, x$PK == 1)
> cor(y$PCTUPDATE, y$ATP)
[1] 0.1472567
