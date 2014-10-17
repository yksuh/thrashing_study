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

## ATP regression
> med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + PK + PCTUPDATE + PCTUPDATE:PK, data = x)
> summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + PK + PCTUPDATE + 
	    PK:PCTUPDATE, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.31663 -0.12358 -0.01232  0.10523  0.57906 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.45457    0.03267  13.912  < 2e-16 ***
	NUMPROCESSORS -0.03396    0.03334  -1.019    0.310    
	ACTROWPOOL     0.01147    0.03469   0.331    0.741    
	PK            -0.28411    0.03721  -7.635 1.17e-12 ***
	PCTUPDATE     -0.59302    0.04696 -12.629  < 2e-16 ***
	PK:PCTUPDATE   0.37617    0.07136   5.271 3.75e-07 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1826 on 185 degrees of freedom
	Multiple R-squared:  0.5333,	Adjusted R-squared:  0.5207 
	F-statistic: 42.28 on 5 and 185 DF,  p-value: < 2.2e-16

## MAXMPL regression followed by mediation via PK only through ATP
> out.fit <- lm(MAXMPL ~ ATP + PK, data = x)
> summary(out.fit)

Call:
	lm(formula = MAXMPL ~ ATP + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.74871 -0.24401 -0.04424  0.25572  0.82755 

	Coefficients:
		    Estimate Std. Error t value Pr(>|t|)    
	(Intercept)  0.17228    0.03806   4.527 1.06e-05 ***
	ATP          0.39966    0.09253   4.319 2.53e-05 ***
	PK           0.57165    0.04903  11.659  < 2e-16 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3213 on 188 degrees of freedom
	Multiple R-squared:  0.4211,	Adjusted R-squared:  0.4149 
	F-statistic: 68.37 on 2 and 188 DF,  p-value: < 2.2e-16

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK", robustSE = TRUE)
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            -0.0589      -0.0946      -0.0281       0
	ADE              0.5717       0.4944       0.6559       0
	Total Effect     0.5128       0.4210       0.6059       0
	Prop. Mediated  -0.1119      -0.2093      -0.0506       0

	Sample Size Used: 191 


	Simulations: 1000

sens.out <- medsens(med.out, effect.type = "indirect")
	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	     Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] 0.3 -0.0296      -0.0877       0.0285         0.09       0.0243
	[2,] 0.4  0.0066      -0.0517       0.0648         0.16       0.0432
	[3,] 0.5  0.0496      -0.0113       0.1105         0.25       0.0675

	Rho at which ACME = 0: 0.4
	R^2_M*R^2_Y* at which ACME = 0: 0.16
	R^2_M~R^2_Y~ at which ACME = 0: 0.0432 

> sens.out$r.square.y
[1] 0.4210822
> sens.out$r.square.m
[1] 0.5333131

#### mediation by NUMPROCESSORS through ATP
> out.fit <- lm(MAXMPL ~ ATP + NUMPROCESSORS, data = x)
> summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.58560 -0.43378 -0.03379  0.43769  0.63010 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.56221    0.04796  11.723  < 2e-16 ***
	ATP            0.06391    0.11408   0.560  0.57602    
	NUMPROCESSORS -0.19907    0.07561  -2.633  0.00917 ** 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.4141 on 188 degrees of freedom
	Multiple R-squared:  0.038,	Adjusted R-squared:  0.02777 
	F-statistic: 3.713 on 2 and 188 DF,  p-value: 0.02621

#### mediation by NUMPROCESSORS+PK through ATP
> out.fit <- lm(MAXMPL ~ ATP + PK + NUMPROCESSORS, data = x)
> summary(out.fit)

Call:
lm(formula = MAXMPL ~ ATP + PK + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.74605 -0.25890  0.05776  0.24472  0.76834 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.26304    0.04344   6.055 7.53e-09 ***
	ATP            0.38499    0.08929   4.312 2.62e-05 ***
	PK             0.57747    0.04730  12.209  < 2e-16 ***
	NUMPROCESSORS -0.22084    0.05658  -3.903 0.000132 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3097 on 187 degrees of freedom
	Multiple R-squared:  0.4647,	Adjusted R-squared:  0.4561 
	F-statistic: 54.11 on 3 and 187 DF,  p-value: < 2.2e-16

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS", robustSE = TRUE)
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            -0.0130      -0.0415       0.0101    0.24
	ADE             -0.2214      -0.3282      -0.1157    0.00
	Total Effect    -0.2344      -0.3460      -0.1247    0.00
	Prop. Mediated   0.0505      -0.0563       0.1775    0.24

	Sample Size Used: 191 


	Simulations: 1000

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK", robustSE = TRUE)
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            -0.0582      -0.0979      -0.0230       0
	ADE              0.5771       0.4887       0.6628       0
	Total Effect     0.5190       0.4271       0.6087       0
	Prop. Mediated  -0.1113      -0.2084      -0.0436       0

	Sample Size Used: 191 


	Simulations: 1000 

> sens.out <- medsens(med.out, effect.type = "indirect")
> summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	     Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] 0.2 -0.0584      -0.1189       0.0021         0.04       0.0100
	[2,] 0.3 -0.0283      -0.0874       0.0309         0.09       0.0225
	[3,] 0.4  0.0067      -0.0524       0.0659         0.16       0.0400
	[4,] 0.5  0.0484      -0.0131       0.1099         0.25       0.0625

	Rho at which ACME = 0: 0.4
	R^2_M*R^2_Y* at which ACME = 0: 0.16
	R^2_M~R^2_Y~ at which ACME = 0: 0.04 

> sens.out$r.square.y
[1] 0.4646933

> sens.out$r.square.m
[1] 0.5333131

### best fit for MAXMPL
## forward
> out.fit  <- lm(MAXMPL ~ 1, data = x)
> out.fit <- step(out.fit, direction="forward", scope=( ~ ATP + NUMPROCESSORS + ACTROWPOOL + PCTUPDATE + PK + PCTREAD), data = x)
	Start:  AIC=-330.39
	MAXMPL ~ 1

		        Df Sum of Sq    RSS     AIC
	+ PK             1   12.1870 21.328 -414.72
	+ PCTUPDATE      1    1.7503 31.765 -338.64
	+ NUMPROCESSORS  1    1.2197 32.295 -335.48
	<none>                       33.515 -330.39
	+ ACTROWPOOL     1    0.1284 33.386 -329.13
	+ ATP            1    0.0847 33.430 -328.88
	+ PCTREAD        1    0.0197 33.495 -328.51

	Step:  AIC=-414.72
	MAXMPL ~ PK

		        Df Sum of Sq    RSS     AIC
	+ PCTUPDATE      1   1.99520 19.333 -431.48
	+ ATP            1   1.92554 19.402 -430.79
	+ NUMPROCESSORS  1   1.60359 19.724 -427.65
	<none>                       21.328 -414.72
	+ ACTROWPOOL     1   0.08013 21.248 -413.44
	+ PCTREAD        1   0.02049 21.307 -412.90

	Step:  AIC=-431.48
	MAXMPL ~ PK + PCTUPDATE

		        Df Sum of Sq    RSS     AIC
	+ NUMPROCESSORS  1   1.69478 17.638 -447.00
	+ ATP            1   0.39790 18.935 -433.45
	+ PCTREAD        1   0.28278 19.050 -432.30
	<none>                       19.333 -431.48
	+ ACTROWPOOL     1   0.10003 19.233 -430.47

	Step:  AIC=-447
	MAXMPL ~ PK + PCTUPDATE + NUMPROCESSORS

		     Df Sum of Sq    RSS     AIC
	+ ATP         1  0.285344 17.353 -448.12
	+ PCTREAD     1  0.246868 17.391 -447.70
	<none>                    17.638 -447.00
	+ ACTROWPOOL  1  0.093917 17.544 -446.02

	Step:  AIC=-448.12
	MAXMPL ~ PK + PCTUPDATE + NUMPROCESSORS + ATP

		     Df Sum of Sq    RSS     AIC
	+ PCTREAD     1   0.44001 16.913 -451.03
	<none>                    17.353 -448.12
	+ ACTROWPOOL  1   0.09871 17.254 -447.21

	Step:  AIC=-451.03
	MAXMPL ~ PK + PCTUPDATE + NUMPROCESSORS + ATP + PCTREAD

		     Df Sum of Sq    RSS     AIC
	<none>                    16.913 -451.03
	+ ACTROWPOOL  1   0.10598 16.807 -450.23
> out.fit <- lm(formula = MAXMPL ~ PK + PCTUPDATE + NUMPROCESSORS + ATP + PCTREAD, data = x)
> summary(out.fit)
	Call:
	lm(formula = MAXMPL ~ PK + PCTUPDATE + NUMPROCESSORS + ATP + 
	    PCTREAD, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.68027 -0.23028  0.03951  0.20952  0.80569 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.39792    0.06292   6.324 1.86e-09 ***
	PK             0.56377    0.04748  11.874  < 2e-16 ***
	PCTUPDATE     -0.22889    0.07795  -2.936  0.00374 ** 
	NUMPROCESSORS -0.22437    0.05542  -4.048 7.57e-05 ***
	ATP            0.26945    0.11778   2.288  0.02328 *  
	PCTREAD       -0.16127    0.07351  -2.194  0.02949 *  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3024 on 185 degrees of freedom
	Multiple R-squared:  0.4954,	Adjusted R-squared:  0.4817 
	F-statistic: 36.32 on 5 and 185 DF,  p-value: < 2.2e-16

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK")
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            -0.0384      -0.0781      -0.0069    0.01
	ADE              0.5632       0.4681       0.6529    0.00
	Total Effect     0.5248       0.4315       0.6134    0.00
	Prop. Mediated  -0.0696      -0.1518      -0.0137    0.01

	Sample Size Used: 191 


	Simulations: 1000

> sens.out <- medsens(med.out, effect.type = "indirect")
> summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	     Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] 0.1 -0.0364      -0.1022       0.0294         0.01       0.0024
	[2,] 0.2  0.0054      -0.0597       0.0704         0.04       0.0094
	[3,] 0.3  0.0493      -0.0162       0.1149         0.09       0.0212

	Rho at which ACME = 0: 0.2
	R^2_M*R^2_Y* at which ACME = 0: 0.04
	R^2_M~R^2_Y~ at which ACME = 0: 0.0094 

> sens.out$r.square.y
[1] 0.4953713
> sens.out$r.square.m
[1] 0.5333131

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE")
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            -0.1136      -0.2129      -0.0174    0.02
	ADE             -0.2303      -0.3871      -0.0765    0.00
	Total Effect    -0.3438      -0.4759      -0.2098    0.00
	Prop. Mediated   0.3341       0.0528       0.7068    0.02

	Sample Size Used: 191 


	Simulations: 1000

> sens.out <- medsens(med.out, effect.type = "indirect")
> summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	     Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] 0.1 -0.0757      -0.2118       0.0603         0.01       0.0024
	[2,] 0.2  0.0112      -0.1243       0.1467         0.04       0.0094
	[3,] 0.3  0.1033      -0.0323       0.2388         0.09       0.0212

	Rho at which ACME = 0: 0.2
	R^2_M*R^2_Y* at which ACME = 0: 0.04
	R^2_M~R^2_Y~ at which ACME = 0: 0.0094 

> sens.out$r.square.y
[1] 0.4953713
> sens.out$r.square.m
[1] 0.5333131

##### extra ####
## find best fit for ATP
med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + PK + PCTUPDATE + PK:PCTUPDATE, data = x)
summary(med.fit)

## find best fit for MAXMPL
## forward
> out.fit  <- lm(MAXMPL ~ 1, data = x)
> out.fit <- step(out.fit, direction="forward", scope=( ~ ATP + NUMPROCESSORS + ACTROWPOOL + PCTUPDATE + PK + PCTREAD), data = x)
> summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + PCTUPDATE + NUMPROCESSORS + ATP + 
	    PCTREAD, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.68027 -0.23028  0.03951  0.20952  0.80569 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.39792    0.06292   6.324 1.86e-09 ***
	PK             0.56377    0.04748  11.874  < 2e-16 ***
	PCTUPDATE     -0.22889    0.07795  -2.936  0.00374 ** 
	NUMPROCESSORS -0.22437    0.05542  -4.048 7.57e-05 ***
	ATP            0.26945    0.11778   2.288  0.02328 *  
	PCTREAD       -0.16127    0.07351  -2.194  0.02949 *  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3024 on 185 degrees of freedom
	Multiple R-squared:  0.4954,	Adjusted R-squared:  0.4817 
	F-statistic: 36.32 on 5 and 185 DF,  p-value: < 2.2e-16

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
> summary(med.out)

Causal Mediation Analysis 

Quasi-Bayesian Confidence Intervals

               Estimate 95% CI Lower 95% CI Upper p-value
ACME           -0.00919     -0.03525      0.01009    0.33
ADE            -0.22634     -0.33523     -0.11458    0.00
Total Effect   -0.23553     -0.34981     -0.12590    0.00
Prop. Mediated  0.03386     -0.04441      0.15709    0.33

Sample Size Used: 191 


Simulations: 1000 

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE")
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            -0.1152      -0.2161      -0.0192    0.02
	ADE             -0.2299      -0.3885      -0.0779    0.00
	Total Effect    -0.3451      -0.4808      -0.2126    0.00
	Prop. Mediated   0.3396       0.0510       0.7004    0.02

	Sample Size Used: 191 


	Simulations: 1000

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK")
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.04023     -0.07908     -0.00491    0.02
	ADE             0.56382      0.47468      0.65777    0.00
	Total Effect    0.52359      0.44090      0.60896    0.00
	Prop. Mediated -0.07517     -0.15886     -0.00896    0.02

	Sample Size Used: 191 


	Simulations: 1000 

> sens.out <- medsens(med.out, effect.type = "indirect")
> summary(sens.out)

Mediation Sensitivity Analysis for Average Causal Mediation Effect

Sensitivity Region

     Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
[1,] 0.1 -0.0364      -0.1022       0.0294         0.01       0.0024
[2,] 0.2  0.0054      -0.0597       0.0704         0.04       0.0094
[3,] 0.3  0.0493      -0.0162       0.1149         0.09       0.0212

Rho at which ACME = 0: 0.2
R^2_M*R^2_Y* at which ACME = 0: 0.04
R^2_M~R^2_Y~ at which ACME = 0: 0.0094 

> sens.out$r.square.y
> sens.out$r.square.m

> sens.out$r.square.y
 [1] 0.4953713
> sens.out$r.square.m
 [1] 0.5333131

##### backward ####
> out.fit <- lm(MAXMPL ~ ATP + PCTUPDATE + PK + NUMPROCESSORS, data = x)
> out.fit <- step(out.fit, direction="backward", data = x)
> summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + PCTUPDATE + PK + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.65293 -0.23397  0.04812  0.22896  0.79901 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.37887    0.06295   6.018 9.19e-09 ***
	ATP            0.20054    0.11467   1.749   0.0820 .  
	PCTUPDATE     -0.19342    0.07703  -2.511   0.0129 *  
	PK             0.55257    0.04768  11.588  < 2e-16 ***
	NUMPROCESSORS -0.23029    0.05592  -4.118 5.74e-05 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3054 on 186 degrees of freedom
	Multiple R-squared:  0.4822,	Adjusted R-squared:  0.4711 
	F-statistic: 43.31 on 4 and 186 DF,  p-value: < 2.2e-16


> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK", sims = 100)
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.02999     -0.06085     -0.00381    0.02
	ADE             0.56025      0.46572      0.65264    0.00
	Total Effect    0.53026      0.43102      0.62246    0.00
	Prop. Mediated -0.05518     -0.11908     -0.00712    0.02

	Sample Size Used: 191 


	Simulations: 100

> sens.out <- medsens(med.out, effect.type = "indirect")
> summary(sens.out)

	Sensitivity Region

	     Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] 0.0 -0.0570      -0.1218       0.0078         0.00       0.0000
	[2,] 0.1 -0.0155      -0.0791       0.0481         0.01       0.0024
	[3,] 0.2  0.0273      -0.0362       0.0908         0.04       0.0097

	Rho at which ACME = 0: 0.1
	R^2_M*R^2_Y* at which ACME = 0: 0.01
	R^2_M~R^2_Y~ at which ACME = 0: 0.0024

> sens.out$r.square.m
[1] 0.5333131
> sens.out$r.square.y
[1] 0.4822425

####---

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE")
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            -0.0885      -0.1886       0.0134    0.10
	ADE             -0.1911      -0.3378      -0.0420    0.01
	Total Effect    -0.2796      -0.3917      -0.1646    0.00
	Prop. Mediated   0.3256      -0.0488       0.7743    0.10

	Sample Size Used: 191 


	Simulations: 1000 

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
> summary(med.out)

Causal Mediation Analysis 

Quasi-Bayesian Confidence Intervals

               Estimate 95% CI Lower 95% CI Upper p-value
ACME           -0.00703     -0.02775      0.00785    0.31
ADE            -0.23152     -0.33503     -0.12323    0.00
Total Effect   -0.23855     -0.34305     -0.13005    0.00
Prop. Mediated  0.02284     -0.03375      0.12632    0.31

Sample Size Used: 191 


Simulations: 1000
