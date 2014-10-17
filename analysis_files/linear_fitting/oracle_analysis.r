# oracle
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
oracle <- subset(x, x$DBMS=='oracle')
oracle$ATP = (oracle$ATP-min(oracle$ATP))/(max(oracle$ATP)-min(oracle$ATP))
oracle$MAXMPL = (oracle$MAXMPL-min(oracle$MAXMPL))/(max(oracle$MAXMPL)-min(oracle$MAXMPL))
x = rbind(oracle) 
x$ACTROWPOOL = (x$ACTROWPOOL-min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)-min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD-min(x$PCTREAD))/(max(x$PCTREAD)-min(x$PCTREAD))
x$PCTUPDATE = (x$PCTUPDATE-min(x$PCTUPDATE))/(max(x$PCTUPDATE)-min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS-min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)-min(x$NUMPROCESSORS))

## ATP regression
> med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + PK + PCTUPDATE + PCTUPDATE:PK, data = x)
> summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + PK + PCTUPDATE + 
	    PCTUPDATE:PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.20945 -0.04999 -0.00221  0.02715  0.75185 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.19339    0.02194   8.813  7.1e-16 ***
	NUMPROCESSORS  0.05970    0.02132   2.800  0.00563 ** 
	ACTROWPOOL     0.03694    0.02236   1.652  0.10007    
	PK            -0.22909    0.02399  -9.551  < 2e-16 ***
	PCTUPDATE     -0.30279    0.03132  -9.668  < 2e-16 ***
	PK:PCTUPDATE   0.30622    0.04396   6.966  5.0e-11 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1168 on 193 degrees of freedom
	Multiple R-squared:  0.4236,	Adjusted R-squared:  0.4086 
	F-statistic: 28.36 on 5 and 193 DF,  p-value: < 2.2e-16

## MAXMPL regression followed by mediation via PK only through ATP
> out.fit <- lm(MAXMPL ~ ATP + PK, data = x)
> summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.56456 -0.46243  0.03531  0.43757  0.63908 

	Coefficients:
		     Estimate Std. Error t value Pr(>|t|)    
	(Intercept)  0.562957   0.050226  11.209   <2e-16 ***
	ATP         -0.277498   0.216304  -1.283    0.201    
	PK           0.001731   0.065540   0.026    0.979    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.4337 on 196 degrees of freedom
	Multiple R-squared:  0.009583,	Adjusted R-squared:  -0.0005233 
	F-statistic: 0.9482 on 2 and 196 DF,  p-value: 0.3892

#med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK", robustSE = TRUE, sim = 50)
> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK", robustSE = TRUE)
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            0.03129     -0.01195      0.08092    0.14
	ADE            -0.00145     -0.13406      0.13181    0.99
	Total Effect    0.02984     -0.08738      0.15816    0.67
	Prop. Mediated  0.23259     -6.98568      8.84890    0.74

	Sample Size Used: 199 


	Simulations: 1000

> sens.out <- medsens(med.out, effect.type = "indirect")
> summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.2 -0.0496      -0.1229       0.0238         0.04       0.0228
	[2,] -0.1  0.0066      -0.0692       0.0823         0.01       0.0057
	[3,]  0.0  0.0636      -0.0183       0.1454         0.00       0.0000

	Rho at which ACME = 0: -0.1
	R^2_M*R^2_Y* at which ACME = 0: 0.01
	R^2_M~R^2_Y~ at which ACME = 0: 0.0057

> sens.out$r.square.y
[1] 0.009582958
> sens.out$r.square.m
[1] 0.4235674

#### mediation by NUMPROCESSORS through ATP
> out.fit <- lm(MAXMPL ~ ATP + PK + NUMPROCESSORS, data = x)
> summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + PK + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.74765 -0.29949 -0.03425  0.32015  0.84451 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.71356    0.05065  14.089  < 2e-16 ***
	ATP           -0.10263    0.19722  -0.520    0.603    
	PK             0.03539    0.05945   0.595    0.552    
	NUMPROCESSORS -0.48335    0.07209  -6.705 2.12e-10 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3919 on 195 degrees of freedom
	Multiple R-squared:  0.1951,	Adjusted R-squared:  0.1827 
	F-statistic: 15.76 on 3 and 195 DF,  p-value: 3.243e-09

> #med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK", robustSE = TRUE, sim = 50)
> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS", robustSE = TRUE)
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.00594     -0.03728      0.02280    0.68
	ADE            -0.48630     -0.63575     -0.33772    0.00
	Total Effect   -0.49223     -0.64156     -0.34600    0.00
	Prop. Mediated  0.00966     -0.04710      0.07686    0.68

	Sample Size Used: 199 


	Simulations: 1000 

> sens.out <- medsens(med.out, effect.type = "indirect")
> summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.2  0.0213      -0.0058       0.0485         0.04       0.0186
	[2,] -0.1  0.0074      -0.0165       0.0313         0.01       0.0046
	[3,]  0.0 -0.0061      -0.0306       0.0183         0.00       0.0000
	[4,]  0.1 -0.0196      -0.0479       0.0086         0.01       0.0046
	[5,]  0.2 -0.0334      -0.0679       0.0010         0.04       0.0186

	Rho at which ACME = 0: 0
	R^2_M*R^2_Y* at which ACME = 0: 0
	R^2_M~R^2_Y~ at which ACME = 0: 0 

> sens.out$r.square.y
[1] 0.1951295
> sens.out$r.square.m
[1] 0.4235674

##### backward ####
## find best fit for ATP
> med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + PK + PCTREAD + PCTREAD:PK + PCTUPDATE + PCTUPDATE:PK, data = x)
> med.fit <- step(med.fit, direction="backward")
	Start:  AIC=-852.41
	ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + 
	    PK + PCTREAD + PCTREAD:PK + PCTUPDATE + PCTUPDATE:PK

		                   Df Sum of Sq    RSS     AIC
	- NUMPROCESSORS:ACTROWPOOL  1   0.00569 2.5134 -853.96
	<none>                                  2.5077 -852.41
	- PK:PCTREAD                1   0.06074 2.5684 -849.65
	- PK:PCTUPDATE              1   0.37231 2.8800 -826.87

	Step:  AIC=-853.96
	ATP ~ NUMPROCESSORS + ACTROWPOOL + PK + PCTREAD + PCTUPDATE + 
	    PK:PCTREAD + PK:PCTUPDATE

		        Df Sum of Sq    RSS     AIC
	<none>                       2.5134 -853.96
	- ACTROWPOOL     1   0.03615 2.5495 -853.12
	- PK:PCTREAD     1   0.06084 2.5742 -851.20
	- NUMPROCESSORS  1   0.09590 2.6093 -848.51
	- PK:PCTUPDATE   1   0.37115 2.8845 -828.55

> summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + PK + PCTREAD + 
	    PCTUPDATE + PK:PCTREAD + PK:PCTUPDATE, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.22683 -0.04484 -0.00062  0.02689  0.78723 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.15834    0.02454   6.453 8.82e-10 ***
	NUMPROCESSORS  0.05662    0.02097   2.700  0.00757 ** 
	ACTROWPOOL     0.03641    0.02197   1.658  0.09905 .  
	PK            -0.19266    0.02898  -6.647 3.04e-10 ***
	PCTREAD        0.11661    0.03898   2.992  0.00314 ** 
	PCTUPDATE     -0.25474    0.03471  -7.339 5.99e-12 ***
	PK:PCTREAD    -0.11634    0.05411  -2.150  0.03279 *  
	PK:PCTUPDATE   0.25825    0.04863   5.311 3.02e-07 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1147 on 191 degrees of freedom
	Multiple R-squared:  0.4494,	Adjusted R-squared:  0.4292 
	F-statistic: 22.27 on 7 and 191 DF,  p-value: < 2.2e-16

## find best fit for MAXMPL
## forward
> out.fit  <- lm(MAXMPL ~ 1, data = x)
> out.fit <- step(out.fit, direction="forward", scope=( ~ ATP + NUMPROCESSORS + ACTROWPOOL + PCTUPDATE + PK + PCTREAD), data = x)
	Start:  AIC=-331.63
	MAXMPL ~ 1

		        Df Sum of Sq    RSS     AIC
	+ NUMPROCESSORS  1    7.1140 30.102 -371.85
	+ PCTUPDATE      1    1.3633 35.853 -337.06
	<none>                       37.216 -331.63
	+ ATP            1    0.3565 36.860 -331.55
	+ PCTREAD        1    0.1496 37.067 -330.44
	+ PK             1    0.0471 37.169 -329.89
	+ ACTROWPOOL     1    0.0044 37.212 -329.66

	Step:  AIC=-371.85
	MAXMPL ~ NUMPROCESSORS

		     Df Sum of Sq    RSS     AIC
	+ PCTUPDATE   1   1.15881 28.944 -377.66
	<none>                    30.102 -371.85
	+ PCTREAD     1   0.18217 29.920 -371.06
	+ PK          1   0.10639 29.996 -370.56
	+ ATP         1   0.09353 30.009 -370.47
	+ ACTROWPOOL  1   0.00430 30.098 -369.88

	Step:  AIC=-377.66
	MAXMPL ~ NUMPROCESSORS + PCTUPDATE

		     Df Sum of Sq    RSS     AIC
	+ ATP         1   0.55531 28.388 -379.52
	<none>                    28.944 -377.66
	+ PK          1   0.09006 28.854 -376.28
	+ PCTREAD     1   0.00582 28.938 -375.70
	+ ACTROWPOOL  1   0.00258 28.941 -375.68

	Step:  AIC=-379.52
	MAXMPL ~ NUMPROCESSORS + PCTUPDATE + ATP

		     Df Sum of Sq    RSS     AIC
	<none>                    28.388 -379.52
	+ ACTROWPOOL  1 0.0174234 28.371 -377.64
	+ PCTREAD     1 0.0002322 28.388 -377.52
	+ PK          1 0.0001499 28.388 -377.52

> summary(out.fit)
	Call:
	lm(formula = MAXMPL ~ NUMPROCESSORS + PCTUPDATE + ATP, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.77738 -0.31218  0.01618  0.29228  0.89481 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.84043    0.04986  16.857  < 2e-16 ***
	NUMPROCESSORS -0.46123    0.07015  -6.575 4.35e-10 ***
	PCTUPDATE     -0.25683    0.07698  -3.336  0.00102 ** 
	ATP           -0.37635    0.19270  -1.953  0.05224 .  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3816 on 195 degrees of freedom
	Multiple R-squared:  0.2372,	Adjusted R-squared:  0.2255 
	F-statistic: 20.21 on 3 and 195 DF,  p-value: 1.895e-11

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE")
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            0.04679      0.00259      0.09936    0.04
	ADE            -0.25484     -0.40509     -0.11658    0.00
	Total Effect   -0.20804     -0.34826     -0.07350    0.00
	Prop. Mediated -0.21580     -0.86958     -0.00934    0.04

	Sample Size Used: 199 


	Simulations: 1000 

> sens.out <- medsens(med.out, effect.type = "indirect")
> summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.3 -0.0758      -0.1642       0.0126         0.09       0.0377
	[2,] -0.2 -0.0180      -0.1075       0.0716         0.04       0.0168
	[3,] -0.1  0.0389      -0.0544       0.1323         0.01       0.0042
	[4,]  0.0  0.0960      -0.0029       0.1948         0.00       0.0000

	Rho at which ACME = 0: -0.2
	R^2_M*R^2_Y* at which ACME = 0: 0.04
	R^2_M~R^2_Y~ at which ACME = 0: 0.0168

> sens.out$r.square.y
[1] 0.2372113
> sens.out$r.square.m
[1] 0.4506174

### backward
> out.fit <- lm(MAXMPL ~ ATP + PCTUPDATE + PK + NUMPROCESSORS, data = x)
> out.fit <- step(out.fit, direction="backward", data = x)
	Start:  AIC=-377.52
	MAXMPL ~ ATP + PCTUPDATE + PK + NUMPROCESSORS

		        Df Sum of Sq    RSS     AIC
	- PK             1    0.0001 28.388 -379.52
	<none>                       28.388 -377.52
	- ATP            1    0.4654 28.854 -376.28
	- PCTUPDATE      1    1.5663 29.954 -368.83
	- NUMPROCESSORS  1    6.2374 34.626 -339.99

	Step:  AIC=-379.52
	MAXMPL ~ ATP + PCTUPDATE + NUMPROCESSORS

		        Df Sum of Sq    RSS     AIC
	<none>                       28.388 -379.52
	- ATP            1    0.5553 28.944 -377.66
	- PCTUPDATE      1    1.6206 30.009 -370.47
	- NUMPROCESSORS  1    6.2934 34.682 -341.67

> summary(out.fit)
	Call:
	lm(formula = MAXMPL ~ ATP + PCTUPDATE + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.77738 -0.31218  0.01618  0.29228  0.89481 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.84043    0.04986  16.857  < 2e-16 ***
	ATP           -0.37635    0.19270  -1.953  0.05224 .  
	PCTUPDATE     -0.25683    0.07698  -3.336  0.00102 ** 
	NUMPROCESSORS -0.46123    0.07015  -6.575 4.35e-10 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3816 on 195 degrees of freedom
	Multiple R-squared:  0.2372,	Adjusted R-squared:  0.2255 
	F-statistic: 20.21 on 3 and 195 DF,  p-value: 1.895e-11

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS", sims = 200)
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.02191     -0.05832     -0.00144    0.02
	ADE            -0.45926     -0.59549     -0.30318    0.00
	Total Effect   -0.48117     -0.61810     -0.32774    0.00
	Prop. Mediated  0.04068      0.00271      0.12045    0.02

	Sample Size Used: 199 


	Simulations: 200 

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE", sims = 200)
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            0.04688      0.00866      0.09328    0.04
	ADE            -0.26391     -0.39385     -0.09438    0.00
	Total Effect   -0.21703     -0.33114     -0.06623    0.00
	Prop. Mediated -0.21738     -0.62781     -0.02146    0.04

	Sample Size Used: 199 


	Simulations: 200 
