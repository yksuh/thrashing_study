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

## ATP regression
> med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + PK + PCTUPDATE + PK:PCTUPDATE, data = x)
> summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + PK + PCTUPDATE + 
	    PK:PCTUPDATE, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.21572 -0.07459 -0.02958  0.00993  0.82692 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)   
	(Intercept)    0.004636   0.033896   0.137   0.8914   
	NUMPROCESSORS  0.067216   0.032791   2.050   0.0417 * 
	ACTROWPOOL     0.046506   0.035277   1.318   0.1890   
	PK             0.097364   0.037000   2.631   0.0092 **
	PCTUPDATE     -0.073238   0.049929  -1.467   0.1441   
	PK:PCTUPDATE  -0.135651   0.071663  -1.893   0.0599 . 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1848 on 191 degrees of freedom
	Multiple R-squared:   0.13,	Adjusted R-squared:  0.1073 
	F-statistic:  5.71 on 5 and 191 DF,  p-value: 6.197e-05

## MAXMPL regression followed by mediation via PK only through ATP
> out.fit <- lm(MAXMPL ~ ATP + PK, data = x)
> summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + PK, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.8421 -0.2026  0.1579  0.2254  0.2254 

	Coefficients:
		    Estimate Std. Error t value Pr(>|t|)    
	(Intercept)  0.77457    0.03014  25.699   <2e-16 ***
	ATP          0.13795    0.11115   1.241    0.216    
	PK           0.06745    0.04339   1.555    0.122    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3015 on 194 degrees of freedom
	Multiple R-squared:  0.02306,	Adjusted R-squared:  0.01299 
	F-statistic: 2.289 on 2 and 194 DF,  p-value: 0.104

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK", robustSE = TRUE, sims = 50)
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            0.00687      0.00160      0.01330    0.00
	ADE             0.06086     -0.00467      0.12382    0.12
	Total Effect    0.06774      0.00445      0.12824    0.04
	Prop. Mediated  0.09957      0.00642      1.20834    0.04

	Sample Size Used: 197 


	Simulations: 50

> sens.out <- medsens(med.out, effect.type = "indirect")
> summary(sens.out)

Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	       Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	 [1,] -0.9  0.2021      -0.0103       0.4144         0.81       0.6884
	 [2,] -0.8  0.1528      -0.0082       0.3138         0.64       0.5439
	 [3,] -0.7  0.1266      -0.0059       0.2592         0.49       0.4164
	 [4,] -0.6  0.1068      -0.0040       0.2175         0.36       0.3060
	 [5,] -0.5  0.0893      -0.0026       0.1813         0.25       0.2125
	 [6,] -0.4  0.0731      -0.0017       0.1480         0.16       0.1360
	 [7,] -0.3  0.0576      -0.0012       0.1164         0.09       0.0765
	 [8,] -0.2  0.0425      -0.0011       0.0862         0.04       0.0340
	 [9,] -0.1  0.0278      -0.0014       0.0571         0.01       0.0085
	[10,]  0.0  0.0134      -0.0026       0.0294         0.00       0.0000
	[11,]  0.1 -0.0007      -0.0094       0.0080         0.01       0.0085
	[12,]  0.2 -0.0147      -0.0321       0.0026         0.04       0.0340
	[13,]  0.3 -0.0287      -0.0592       0.0019         0.09       0.0765
	[14,]  0.4 -0.0427      -0.0876       0.0022         0.16       0.1360
	[15,]  0.5 -0.0572      -0.1175       0.0031         0.25       0.2125
	[16,]  0.6 -0.0728      -0.1502       0.0046         0.36       0.3060
	[17,]  0.7 -0.0910      -0.1887       0.0067         0.49       0.4164
	[18,]  0.8 -0.1159      -0.2411       0.0094         0.64       0.5439
	[19,]  0.9 -0.1646      -0.3412       0.0120         0.81       0.6884

	Rho at which ACME = 0: 0.1
	R^2_M*R^2_Y* at which ACME = 0: 0.01
	R^2_M~R^2_Y~ at which ACME = 0: 0.0085

> sens.out$r.square.y
[1] 0.02305875

> sens.out$r.square.m
[1] 0.130046

#### mediation via NUMPROCESSORS only through ATP
> out.fit <- lm(MAXMPL ~ ATP + NUMPROCESSORS, data = x)
> summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.72492 -0.21416  0.06878  0.24562  0.27513 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.72484    0.02979  24.330  < 2e-16 ***
	ATP            0.10395    0.10757   0.966 0.335062    
	NUMPROCESSORS  0.20635    0.05222   3.952 0.000109 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2918 on 194 degrees of freedom
	Multiple R-squared:  0.08457,	Adjusted R-squared:  0.07514 
	F-statistic: 8.962 on 2 and 194 DF,  p-value: 0.0001894

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS", robustSE = TRUE, sims = 50, conf.level=.9)
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 90% CI Lower 90% CI Upper p-value
	ACME           0.007978     0.000272     0.018329    0.08
	ADE            0.208389     0.141503     0.284094    0.00
	Total Effect   0.216367     0.149633     0.293346    0.00
	Prop. Mediated 0.034683     0.001448     0.096501    0.08

	Sample Size Used: 197 


	Simulations: 50

> summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	     Rho    ACME 90% CI Lower 90% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] 0.0  0.0070      -0.0013       0.0153         0.00       0.0000
	[2,] 0.1 -0.0025      -0.0089       0.0040         0.01       0.0080
	[3,] 0.2 -0.0122      -0.0244       0.0000         0.04       0.0319

	Rho at which ACME = 0: 0.1
	R^2_M*R^2_Y* at which ACME = 0: 0.01
	R^2_M~R^2_Y~ at which ACME = 0: 0.008 

>  sens.out$r.square.y
[1] 0.08457424
> sens.out$r.square.m
[1] 0.130046

#### mediation via both PK and NUMPROCESSORS only through ATP
> out.fit <- lm(MAXMPL ~ ATP + NUMPROCESSORS + PK, data = x)
> summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + NUMPROCESSORS + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.75992 -0.19488  0.09998  0.21725  0.30517 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.69481    0.03541  19.619  < 2e-16 ***
	ATP            0.08121    0.10817   0.751 0.453724    
	NUMPROCESSORS  0.20518    0.05203   3.943 0.000112 ***
	PK             0.06507    0.04185   1.555 0.121663    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2908 on 193 degrees of freedom
	Multiple R-squared:  0.0959,	Adjusted R-squared:  0.08184 
	F-statistic: 6.824 on 3 and 193 DF,  p-value: 0.0002148

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS", robustSE = TRUE, sims = 50, conf.level=.1)
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 10% CI Lower 10% CI Upper p-value
	ACME            0.00609      0.00421      0.00543    0.04
	ADE             0.21473      0.20725      0.22488    0.00
	Total Effect    0.22082      0.21149      0.23143    0.00
	Prop. Mediated  0.02185      0.02014      0.02386    0.04

	Sample Size Used: 197 


	Simulations: 50

#### mediation via PCTUPDATE through ATP
> out.fit <- lm(MAXMPL ~ ATP + NUMPROCESSORS + PK + PCTUPDATE, data = x)
> summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + NUMPROCESSORS + PK + PCTUPDATE, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.92350 -0.18137  0.07653  0.20193  0.40085 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.59909    0.03943  15.195  < 2e-16 ***
	ATP            0.21423    0.10668   2.008 0.046028 *  
	NUMPROCESSORS  0.19195    0.04953   3.876 0.000146 ***
	PK             0.06530    0.03977   1.642 0.102273    
	PCTUPDATE      0.25900    0.05557   4.661 5.89e-06 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2763 on 192 degrees of freedom
	Multiple R-squared:  0.1878,	Adjusted R-squared:  0.1709 
	F-statistic:  11.1 on 4 and 192 DF,  p-value: 4.055e-08

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE", robustSE = TRUE, conf.level=.1)
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 10% CI Lower 10% CI Upper p-value
	ACME            -0.0307      -0.0313      -0.0284       0
	ADE              0.2599       0.2529       0.2660       0
	Total Effect     0.2292       0.2222       0.2343       0
	Prop. Mediated  -0.1328      -0.1387      -0.1259       0

	Sample Size Used: 197 


	Simulations: 1000 

> sens.out <- medsens(med.out, effect.type = "indirect")
> summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	       Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	 [1,] -0.9  0.1979      -0.0293       0.4251         0.81       0.6371
	 [2,] -0.8  0.1319      -0.0178       0.2816         0.64       0.5034
	 [3,] -0.7  0.0994      -0.0115       0.2103         0.49       0.3854
	 [4,] -0.6  0.0779      -0.0075       0.1632         0.36       0.2832
	 [5,] -0.5  0.0614      -0.0048       0.1277         0.25       0.1966
	 [6,] -0.4  0.0478      -0.0032       0.0988         0.16       0.1258
	 [7,] -0.3  0.0360      -0.0022       0.0741         0.09       0.0708
	 [8,] -0.2  0.0252      -0.0017       0.0521         0.04       0.0315
	 [9,] -0.1  0.0151      -0.0017       0.0320         0.01       0.0079
	[10,]  0.0  0.0055      -0.0032       0.0141         0.00       0.0000
	[11,]  0.1 -0.0041      -0.0122       0.0040         0.01       0.0079
	[12,]  0.2 -0.0138      -0.0296       0.0019         0.04       0.0315
	[13,]  0.3 -0.0240      -0.0494       0.0015         0.09       0.0708
	[14,]  0.4 -0.0350      -0.0714       0.0014         0.16       0.1258
	[15,]  0.5 -0.0476      -0.0965       0.0014         0.25       0.1966
	[16,]  0.6 -0.0628      -0.1271       0.0016         0.36       0.2832
	[17,]  0.7 -0.0828      -0.1676       0.0020         0.49       0.3854
	[18,]  0.8 -0.1136      -0.2303       0.0031         0.64       0.5034
	[19,]  0.9 -0.1778      -0.3626       0.0071         0.81       0.6371

	Rho at which ACME = 0: 0.1
	R^2_M*R^2_Y* at which ACME = 0: 0.01
	R^2_M~R^2_Y~ at which ACME = 0: 0.0079 

### extra #####
> med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + PK + PCTREAD + PCTREAD:PK + PCTUPDATE + PCTUPDATE:PK, data = x)
## find best fit for ATP
> med.fit <- step(med.fit, direction="backward")
> summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTUPDATE + PK:PCTREAD + PK:PCTUPDATE, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.24716 -0.07104 -0.03192  0.02483  0.82579 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)   
	(Intercept)    0.04770    0.03357   1.421  0.15706   
	NUMPROCESSORS  0.07256    0.03192   2.273  0.02413 * 
	PK             0.12921    0.04294   3.009  0.00298 **
	PCTREAD       -0.07688    0.06032  -1.274  0.20405   
	PCTUPDATE     -0.10356    0.05418  -1.912  0.05743 . 
	PK:PCTREAD    -0.15415    0.08944  -1.723  0.08644 . 
	PK:PCTUPDATE  -0.17972    0.07664  -2.345  0.02005 * 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1797 on 190 degrees of freedom
	Multiple R-squared:  0.1818,	Adjusted R-squared:  0.156 
	F-statistic: 7.038 on 6 and 190 DF,  p-value: 8.86e-07

## find best fit for MAXMPL
## forward
> out.fit <- lm(MAXMPL ~ 1, data = x)
> out.fit <- step(out.fit, direction="forward", scope=( ~ ATP + NUMPROCESSORS + ACTROWPOOL + PCTUPDATE + PK + PCTREAD), data = x)
	Start:  AIC=-468.87
	MAXMPL ~ 1

		        Df Sum of Sq    RSS     AIC
	+ NUMPROCESSORS  1   1.44681 16.601 -483.33
	+ PCTUPDATE      1   1.40526 16.642 -482.84
	+ PCTREAD        1   0.74735 17.300 -475.20
	+ ACTROWPOOL     1   0.37836 17.669 -471.04
	+ PK             1   0.27617 17.771 -469.91
	+ ATP            1   0.19649 17.851 -469.03
	<none>                       18.047 -468.87

	Step:  AIC=-483.33
	MAXMPL ~ NUMPROCESSORS

		     Df Sum of Sq    RSS     AIC
	+ PCTUPDATE   1   1.35310 15.247 -498.08
	+ PCTREAD     1   0.78400 15.816 -490.86
	+ ACTROWPOOL  1   0.38494 16.216 -485.95
	+ PK          1   0.23622 16.364 -484.16
	<none>                    16.601 -483.33
	+ ATP         1   0.07953 16.521 -482.28

	Step:  AIC=-498.08
	MAXMPL ~ NUMPROCESSORS + PCTUPDATE

		     Df Sum of Sq    RSS     AIC
	+ ATP         1   0.38326 14.864 -501.10
	+ ACTROWPOOL  1   0.37593 14.871 -501.00
	+ PK          1   0.28117 14.966 -499.75
	+ PCTREAD     1   0.19559 15.052 -498.63
	<none>                    15.247 -498.08

	Step:  AIC=-501.1
	MAXMPL ~ NUMPROCESSORS + PCTUPDATE + ATP

		     Df Sum of Sq    RSS     AIC
	+ ACTROWPOOL  1   0.45646 14.408 -505.24
	+ PK          1   0.20578 14.658 -501.84
	<none>                    14.864 -501.10
	+ PCTREAD     1   0.09132 14.773 -500.31

	Step:  AIC=-505.24
	MAXMPL ~ NUMPROCESSORS + PCTUPDATE + ATP + ACTROWPOOL

		  Df Sum of Sq    RSS     AIC
	+ PK       1  0.201670 14.206 -506.02
	<none>                 14.408 -505.24
	+ PCTREAD  1  0.095852 14.312 -504.56

	Step:  AIC=-506.02
	MAXMPL ~ NUMPROCESSORS + PCTUPDATE + ATP + ACTROWPOOL + PK

		  Df Sum of Sq    RSS     AIC
	<none>                 14.206 -506.02
	+ PCTREAD  1  0.089169 14.117 -505.26

> summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ NUMPROCESSORS + PCTUPDATE + ATP + ACTROWPOOL + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.85836 -0.17391  0.06614  0.19075  0.44080 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.66086    0.04628  14.280  < 2e-16 ***
	NUMPROCESSORS  0.19081    0.04889   3.903 0.000132 ***
	PCTUPDATE      0.26169    0.05486   4.770 3.65e-06 ***
	ATP            0.23927    0.10578   2.262 0.024833 *  
	ACTROWPOOL    -0.12896    0.05229  -2.466 0.014540 *  
	PK             0.06464    0.03926   1.647 0.101274    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2727 on 191 degrees of freedom
	Multiple R-squared:  0.2128,	Adjusted R-squared:  0.1922 
	F-statistic: 10.33 on 5 and 191 DF,  p-value: 8.817e-09

## backward
> out.fit <- lm(MAXMPL ~ NUMPROCESSORS + PCTUPDATE + ATP + ACTROWPOOL + PK, data = x)
> out.fit <- step(out.fit, direction="backward", data = x)

	Start:  AIC=-505.26
	MAXMPL ~ ATP + NUMPROCESSORS + ACTROWPOOL + PCTUPDATE + PK + 
	    PCTREAD

		        Df Sum of Sq    RSS     AIC
	- PCTREAD        1   0.08917 14.206 -506.02
	<none>                       14.117 -505.26
	- PK             1   0.19499 14.312 -504.56
	- ATP            1   0.28084 14.398 -503.38
	- ACTROWPOOL     1   0.45676 14.574 -500.99
	- PCTUPDATE      1   1.03343 15.150 -493.34
	- NUMPROCESSORS  1   1.16956 15.286 -491.58

	Step:  AIC=-506.02
	MAXMPL ~ ATP + NUMPROCESSORS + ACTROWPOOL + PCTUPDATE + PK

		        Df Sum of Sq    RSS     AIC
	<none>                       14.206 -506.02
	- PK             1   0.20167 14.408 -505.24
	- ATP            1   0.38051 14.586 -502.81
	- ACTROWPOOL     1   0.45235 14.658 -501.84
	- NUMPROCESSORS  1   1.13299 15.339 -492.90
	- PCTUPDATE      1   1.69230 15.898 -485.85

> summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + NUMPROCESSORS + ACTROWPOOL + PCTUPDATE + 
	    PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.85836 -0.17391  0.06614  0.19075  0.44080 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.66086    0.04628  14.280  < 2e-16 ***
	ATP            0.23927    0.10578   2.262 0.024833 *  
	NUMPROCESSORS  0.19081    0.04889   3.903 0.000132 ***
	ACTROWPOOL    -0.12896    0.05229  -2.466 0.014540 *  
	PCTUPDATE      0.26169    0.05486   4.770 3.65e-06 ***
	PK             0.06464    0.03926   1.647 0.101274    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2727 on 191 degrees of freedom
	Multiple R-squared:  0.2128,	Adjusted R-squared:  0.1922 
	F-statistic: 10.33 on 5 and 191 DF,  p-value: 8.817e-09

> out.fit <- lm(MAXMPL ~ NUMPROCESSORS + PCTUPDATE + ATP + ACTROWPOOL, data = x)
> summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ NUMPROCESSORS + PCTUPDATE + ATP + ACTROWPOOL, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.82320 -0.18516  0.07368  0.20336  0.43841 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.69101    0.04269  16.187  < 2e-16 ***
	NUMPROCESSORS  0.19197    0.04910   3.910 0.000128 ***
	PCTUPDATE      0.26159    0.05511   4.747 4.03e-06 ***
	ATP            0.26192    0.10535   2.486 0.013769 *  
	ACTROWPOOL    -0.12954    0.05252  -2.466 0.014526 *  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2739 on 192 degrees of freedom
	Multiple R-squared:  0.2017,	Adjusted R-squared:  0.185 
	F-statistic: 12.13 on 4 and 192 DF,  p-value: 8.283e-09

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE")
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.04980     -0.09626     -0.00834    0.02
	ADE             0.26111      0.15663      0.37003    0.00
	Total Effect    0.21131      0.10825      0.31151    0.00
	Prop. Mediated -0.22515     -0.67281     -0.03684    0.02

	Sample Size Used: 197 


	Simulations: 1000 

> sens.out <- medsens(med.out, effect.type = "indirect")
> summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	       Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	 [1,] -0.5 -0.0952      -0.1946       0.0041         0.25       0.1712
	 [2,] -0.4 -0.0721      -0.1549       0.0106         0.16       0.1096
	 [3,] -0.3 -0.0545      -0.1221       0.0132         0.09       0.0616
	 [4,] -0.2 -0.0403      -0.0938       0.0132         0.04       0.0274
	 [5,] -0.1 -0.0283      -0.0684       0.0117         0.01       0.0068
	 [6,]  0.0 -0.0175      -0.0451       0.0100         0.00       0.0000
	 [7,]  0.1 -0.0069      -0.0246       0.0107         0.01       0.0068
	 [8,]  0.2  0.0043      -0.0122       0.0208         0.04       0.0274
	 [9,]  0.3  0.0173      -0.0089       0.0435         0.09       0.0616
	[10,]  0.4  0.0333      -0.0072       0.0738         0.16       0.1096
	[11,]  0.5  0.0543      -0.0032       0.1117         0.25       0.1712

	Rho at which ACME = 0: 0.2
	R^2_M*R^2_Y* at which ACME = 0: 0.04
	R^2_M~R^2_Y~ at which ACME = 0: 0.0274 

> sens.out$r.square.y
[1] 0.2372113
> sens.out$r.square.m
[1] 0.4493699

> out.fit <- lm(MAXMPL ~ ATP + NUMPROCESSORS + ACTROWPOOL + PCTUPDATE, data = x)
> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE")
> sens.out <- medsens(med.out, effect.type = "indirect")
> summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	       Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	 [1,] -0.5 -0.0958      -0.1959       0.0044         0.25       0.1736
	 [2,] -0.4 -0.0730      -0.1569       0.0109         0.16       0.1111
	 [3,] -0.3 -0.0556      -0.1247       0.0135         0.09       0.0625
	 [4,] -0.2 -0.0416      -0.0968       0.0136         0.04       0.0278
	 [5,] -0.1 -0.0298      -0.0717       0.0121         0.01       0.0069
	 [6,]  0.0 -0.0192      -0.0486       0.0102         0.00       0.0000
	 [7,]  0.1 -0.0087      -0.0277       0.0102         0.01       0.0069
	 [8,]  0.2  0.0024      -0.0135       0.0184         0.04       0.0278
	 [9,]  0.3  0.0154      -0.0091       0.0398         0.09       0.0625
	[10,]  0.4  0.0314      -0.0071       0.0699         0.16       0.1111
	[11,]  0.5  0.0526      -0.0029       0.1081         0.25       0.1736

	Rho at which ACME = 0: 0.2
	R^2_M*R^2_Y* at which ACME = 0: 0.04
	R^2_M~R^2_Y~ at which ACME = 0: 0.0278

> sens.out$r.square.y
[1] 0.2016719
> sens.out$r.square.m
[1] 0.130046

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
> sens.out <- medsens(med.out, effect.type = "indirect")
> summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.2  0.0371      -0.0007       0.0749         0.04       0.0280
	[2,] -0.1  0.0272      -0.0020       0.0565         0.01       0.0070
	[3,]  0.0  0.0177      -0.0040       0.0393         0.00       0.0000
	[4,]  0.1  0.0080      -0.0077       0.0237         0.01       0.0070
	[5,]  0.2 -0.0021      -0.0161       0.0119         0.04       0.0280
	[6,]  0.3 -0.0129      -0.0313       0.0055         0.09       0.0631
	[7,]  0.4 -0.0250      -0.0522       0.0023         0.16       0.1121
	[8,]  0.5 -0.0390      -0.0781       0.0000         0.25       0.1752

	Rho at which ACME = 0: 0.2
	R^2_M*R^2_Y* at which ACME = 0: 0.04
	R^2_M~R^2_Y~ at which ACME = 0: 0.028

> sens.out$r.square.y
[1] 0.2016719
> sens.out$r.square.m
[1] 0.130046

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "ACTROWPOOL")
> sens.out <- medsens(med.out, effect.type = "indirect")
> summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	       Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	 [1,] -0.9  0.1531      -0.0692       0.3754         0.81       0.5626
	 [2,] -0.8  0.1024      -0.0467       0.2515         0.64       0.4445
	 [3,] -0.7  0.0781      -0.0361       0.1923         0.49       0.3403
	 [4,] -0.6  0.0624      -0.0292       0.1540         0.36       0.2500
	 [5,] -0.5  0.0507      -0.0241       0.1255         0.25       0.1736
	 [6,] -0.4  0.0412      -0.0200       0.1024         0.16       0.1111
	 [7,] -0.3  0.0331      -0.0164       0.0826         0.09       0.0625
	 [8,] -0.2  0.0257      -0.0132       0.0647         0.04       0.0278
	 [9,] -0.1  0.0189      -0.0104       0.0481         0.01       0.0069
	[10,]  0.0  0.0122      -0.0081       0.0324         0.00       0.0000
	[11,]  0.1  0.0055      -0.0070       0.0179         0.01       0.0069
	[12,]  0.2 -0.0015      -0.0113       0.0083         0.04       0.0278
	[13,]  0.3 -0.0089      -0.0252       0.0073         0.09       0.0625
	[14,]  0.4 -0.0173      -0.0443       0.0097         0.16       0.1111
	[15,]  0.5 -0.0270      -0.0675       0.0135         0.25       0.1736
	[16,]  0.6 -0.0389      -0.0965       0.0186         0.36       0.2500
	[17,]  0.7 -0.0550      -0.1357       0.0257         0.49       0.3403
	[18,]  0.8 -0.0797      -0.1962       0.0368         0.64       0.4445
	[19,]  0.9 -0.1309      -0.3217       0.0600         0.81       0.5626

	Rho at which ACME = 0: 0.2
	R^2_M*R^2_Y* at which ACME = 0: 0.04
	R^2_M~R^2_Y~ at which ACME = 0: 0.0278

> sens.out$r.square.y
[1] 0.2016719
> sens.out$r.square.m
[1] 0.130046
