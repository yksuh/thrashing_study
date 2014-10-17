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

## ## ATP regression
> med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + PK + PCTUPDATE + PK:PCTUPDATE, data = x)
> summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + PK + PCTUPDATE + 
	    PK:PCTUPDATE, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.36985 -0.21871  0.00455  0.12651  0.61037 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.284894   0.045554   6.254 2.21e-09 ***
	NUMPROCESSORS -0.450381   0.046170  -9.755  < 2e-16 ***
	ACTROWPOOL     0.004101   0.047891   0.086   0.9318    
	PK             0.037492   0.050341   0.745   0.4572    
	PCTUPDATE      0.147673   0.066171   2.232   0.0267 *  
	PK:PCTUPDATE  -0.043900   0.095353  -0.460   0.6457    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2623 on 210 degrees of freedom
	Multiple R-squared:  0.3308,	Adjusted R-squared:  0.3148 
	F-statistic: 20.76 on 5 and 210 DF,  p-value: < 2.2e-16

## MAXMPL regression followed by mediation via PK only through ATP
> out.fit <- lm(MAXMPL ~ ATP + PK, data = x)
> summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.64243 -0.05273 -0.00971  0.09015  0.42354 

	Coefficients:
		    Estimate Std. Error t value Pr(>|t|)    
	(Intercept)  0.64266    0.02838  22.648   <2e-16 ***
	ATP         -0.14692    0.06062  -2.424   0.0162 *  
	PK          -0.03274    0.03836  -0.854   0.3942    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2816 on 213 degrees of freedom
	Multiple R-squared:  0.03055,	Adjusted R-squared:  0.02145 
	F-statistic: 3.356 on 2 and 213 DF,  p-value: 0.03671

> out.fit <- lm(MAXMPL ~ ATP + NUMPROCESSORS, data = x)
> summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.52048 -0.12037  0.00837  0.14107  0.55214 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.41987    0.03350  12.534  < 2e-16 ***
	ATP            0.12291    0.06467   1.901   0.0587 .  
	NUMPROCESSORS  0.40046    0.05284   7.578 1.06e-12 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2503 on 213 degrees of freedom
	Multiple R-squared:  0.2338,	Adjusted R-squared:  0.2266 
	F-statistic:  32.5 on 2 and 213 DF,  p-value: 4.795e-13

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS", robustSE = TRUE)
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            -0.0563      -0.1017      -0.0111    0.01
	ADE              0.4019       0.2841       0.5119    0.00
	Total Effect     0.3455       0.2613       0.4260    0.00
	Prop. Mediated  -0.1639      -0.2744      -0.0347    0.01

	Sample Size Used: 216 


	Simulations: 1000

> sens.out <- medsens(med.out, effect.type = "indirect")
> summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	     Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] 0.1 -0.0136      -0.0579       0.0307         0.01       0.0051
	[2,] 0.2  0.0291      -0.0153       0.0735         0.04       0.0205

	Rho at which ACME = 0: 0.1
	R^2_M*R^2_Y* at which ACME = 0: 0.01
	R^2_M~R^2_Y~ at which ACME = 0: 0.0051 

> sens.out$r.square.y
[1] 0.2338273
> sens.out$r.square.m
[1] 0.3307787

## find best fit for MAXMPL
## forward
> out.fit  <- lm(MAXMPL ~ 1, data = x)
> out.fit <- step(out.fit, direction="forward", scope=( ~ ATP + NUMPROCESSORS + ACTROWPOOL + PCTUPDATE + PK + PCTREAD), data = x)
> summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ NUMPROCESSORS + PCTUPDATE + ATP, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.57354 -0.06943  0.03207  0.12515  0.50398 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.45987    0.03537  13.002  < 2e-16 ***
	NUMPROCESSORS  0.41348    0.05201   7.950 1.09e-13 ***
	PCTUPDATE     -0.13861    0.04532  -3.058  0.00251 ** 
	ATP            0.15873    0.06451   2.461  0.01467 *  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2455 on 212 degrees of freedom
	Multiple R-squared:  0.2662,	Adjusted R-squared:  0.2558 
	F-statistic: 25.64 on 3 and 212 DF,  p-value: 3.434e-14

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            -0.0704      -0.1273      -0.0138    0.01
	ADE              0.4115       0.3128       0.5125    0.00
	Total Effect     0.3410       0.2649       0.4274    0.00
	Prop. Mediated  -0.2041      -0.4111      -0.0404    0.01

	Sample Size Used: 216 


	Simulations: 1000

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE")
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            0.01977      0.00207      0.04487    0.02
	ADE            -0.13657     -0.22382     -0.05427    0.00
	Total Effect   -0.11680     -0.20556     -0.02981    0.00
	Prop. Mediated -0.15925     -0.84804     -0.01606    0.02

	Sample Size Used: 216 


	Simulations: 1000 

> sens.out <- medsens(med.out, effect.type = "indirect")
> summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	     Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] 0.0  0.0234      -0.0041       0.0510         0.00       0.0000
	[2,] 0.1  0.0094      -0.0107       0.0296         0.01       0.0049
	[3,] 0.2 -0.0047      -0.0233       0.0139         0.04       0.0196
	[4,] 0.3 -0.0193      -0.0440       0.0053         0.09       0.0442
	[5,] 0.4 -0.0350      -0.0704       0.0005         0.16       0.0786

	Rho at which ACME = 0: 0.2
	R^2_M*R^2_Y* at which ACME = 0: 0.04
	R^2_M~R^2_Y~ at which ACME = 0: 0.0196 

> sens.out$r.square.y
[1] 0.2662033
> sens.out$r.square.m
[1] 0.3307787

##### backward ####
> out.fit <- lm(MAXMPL ~ ATP + PCTUPDATE + PK + NUMPROCESSORS, data = x)
> out.fit <- step(out.fit, direction="backward", data = x)
> summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + PCTUPDATE + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.57354 -0.06943  0.03207  0.12515  0.50398 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.45987    0.03537  13.002  < 2e-16 ***
	ATP            0.15873    0.06451   2.461  0.01467 *  
	PCTUPDATE     -0.13861    0.04532  -3.058  0.00251 ** 
	NUMPROCESSORS  0.41348    0.05201   7.950 1.09e-13 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2455 on 212 degrees of freedom
	Multiple R-squared:  0.2662,	Adjusted R-squared:  0.2558 
	F-statistic: 25.64 on 3 and 212 DF,  p-value: 3.434e-14

> out.fit <- lm(MAXMPL ~ ATP + PCTUPDATE + NUMPROCESSORS, data = x)
> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE")
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            0.01998      0.00265      0.04701    0.01
	ADE            -0.13910     -0.23168     -0.04990    0.00
	Total Effect   -0.11911     -0.20858     -0.03093    0.01
	Prop. Mediated -0.15821     -0.79150     -0.01634    0.02

	Sample Size Used: 216 


	Simulations: 1000

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            -0.0707      -0.1317      -0.0165    0.01
	ADE              0.4134       0.3075       0.5132    0.00
	Total Effect     0.3427       0.2564       0.4291    0.00
	Prop. Mediated  -0.2010      -0.4131      -0.0469    0.01

	Sample Size Used: 216 


	Simulations: 1000 

> sens.out <- medsens(med.out, effect.type = "indirect")
> summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	     Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] 0.1 -0.0291      -0.0859       0.0278         0.01       0.0049
	[2,] 0.2  0.0147      -0.0420       0.0713         0.04       0.0196

	Rho at which ACME = 0: 0.2
	R^2_M*R^2_Y* at which ACME = 0: 0.04
	R^2_M~R^2_Y~ at which ACME = 0: 0.0196

> sens.out$r.square.y
[1] 0.2662033
> sens.out$r.square.m
[1] 0.3307787
