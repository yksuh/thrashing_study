# sqlserver
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
x <- subset(x, x$MAXMPL<1100)
sqlserver <- subset(x, x$DBMS=='sqlserver')
sqlserver$ATP = (sqlserver$ATP-min(sqlserver$ATP))/(max(sqlserver$ATP)-min(sqlserver$ATP))
sqlserver$MAXMPL = (sqlserver$MAXMPL-min(sqlserver$MAXMPL))/(max(sqlserver$MAXMPL)-min(sqlserver$MAXMPL))
sqlserver$ACTROWPOOL = (sqlserver$ACTROWPOOL-min(sqlserver$ACTROWPOOL))/(max(sqlserver$ACTROWPOOL)-min(sqlserver$ACTROWPOOL))
sqlserver$PCTREAD = (sqlserver$PCTREAD-min(sqlserver$PCTREAD))/(max(sqlserver$PCTREAD)-min(sqlserver$PCTREAD))
sqlserver$PCTUPDATE = (sqlserver$PCTUPDATE-min(sqlserver$PCTUPDATE))/(max(sqlserver$PCTUPDATE)-min(sqlserver$PCTUPDATE))
sqlserver$NUMPROCESSORS = (sqlserver$NUMPROCESSORS-min(sqlserver$NUMPROCESSORS))/(max(sqlserver$NUMPROCESSORS)-min(sqlserver$NUMPROCESSORS))
x = rbind(sqlserver) 

> nrow(x)
[1] 165

med.fit <- lm(ATP ~ NUMPROCESSORS + PCTUPDATE  + PK + PK:PCTUPDATE, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PCTUPDATE + PK + PK:PCTUPDATE, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.39812 -0.21501 -0.04116  0.16654  0.59366 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.28028    0.05123   5.471 1.69e-07 ***
	NUMPROCESSORS -0.55069    0.06313  -8.724 3.32e-15 ***
	PCTUPDATE      0.19852    0.08831   2.248   0.0259 *  
	PK             0.10512    0.07218   1.456   0.1472    
	PCTUPDATE:PK  -0.13162    0.12241  -1.075   0.2839    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2888 on 160 degrees of freedom
	Multiple R-squared:  0.3248,	Adjusted R-squared:  0.3079 
	F-statistic: 19.24 on 4 and 160 DF,  p-value: 6.115e-13

out.fit <- lm(MAXMPL ~ NUMPROCESSORS + ATP + PCTREAD + PCTUPDATE + ACTROWPOOL + PK, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ NUMPROCESSORS + ATP + PCTREAD + PCTUPDATE + 
	    ACTROWPOOL + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.65587 -0.12911  0.09189  0.18753  0.49284 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.51219    0.05709   8.972 8.03e-16 ***
	NUMPROCESSORS  0.34215    0.06907   4.954 1.86e-06 ***
	ATP            0.26908    0.07150   3.764 0.000236 ***
	PCTREAD       -0.10332    0.07914  -1.306 0.193608    
	PCTUPDATE      0.12806    0.06242   2.052 0.041864 *  
	ACTROWPOOL    -0.03392    0.05470  -0.620 0.536118    
	PK            -0.05176    0.04118  -1.257 0.210653    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2621 on 158 degrees of freedom
	Multiple R-squared:  0.222,	Adjusted R-squared:  0.1924 
	F-statistic: 7.514 on 6 and 158 DF,  p-value: 4.256e-07

---

# sqlserver
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
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
x = rbind(sqlserver) 

med.fit <- lm(ATP ~ NUMPROCESSORS + PCTUPDATE  + PK + PK:PCTUPDATE, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PCTUPDATE + PK + PK:PCTUPDATE, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.41677 -0.21621 -0.07117  0.15160  0.66611 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.28374    0.04356   6.514 5.28e-10 ***
	NUMPROCESSORS -0.47278    0.05190  -9.110  < 2e-16 ***
	PCTUPDATE      0.20057    0.07438   2.697  0.00757 ** 
	PK             0.03743    0.05658   0.661  0.50906    
	PCTUPDATE:PK  -0.04782    0.10718  -0.446  0.65594    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2948 on 211 degrees of freedom
	Multiple R-squared:  0.3121,	Adjusted R-squared:  0.299 
	F-statistic: 23.93 on 4 and 211 DF,  p-value: 2.465e-16

----

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
	-0.56506 -0.14583  0.03651  0.15351  0.62003 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.402679   0.050867   7.916 1.42e-13 ***
	NUMPROCESSORS  0.430120   0.055888   7.696 5.48e-13 ***
	ATP           -0.008816   0.062876  -0.140 0.888627    
	PCTREAD        0.009348   0.061176   0.153 0.878700    
	PCTUPDATE     -0.215336   0.055036  -3.913 0.000123 ***
	ACTROWPOOL     0.019457   0.049147   0.396 0.692590    
	PK            -0.040056   0.036733  -1.090 0.276765    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2692 on 209 degrees of freedom
	Multiple R-squared:  0.3404,	Adjusted R-squared:  0.3214 
	F-statistic: 17.97 on 6 and 209 DF,  p-value: < 2.2e-16

---

	Call:
	lm(formula = MAXMPL ~ NUMPROCESSORS + ATP + PCTREAD + PCTUPDATE + 
	    ACTROWPOOL + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.55858 -0.06339  0.02285  0.12832  0.52556 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.472138   0.047215  10.000  < 2e-16 ***
	NUMPROCESSORS  0.416244   0.052237   7.968 1.03e-13 ***
	ATP            0.162063   0.064783   2.502  0.01313 *  
	PCTREAD        0.007046   0.055944   0.126  0.89990    
	PCTUPDATE     -0.134294   0.050132  -2.679  0.00798 ** 
	ACTROWPOOL     0.007113   0.044980   0.158  0.87450    
	PK            -0.041793   0.033629  -1.243  0.21534    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2464 on 209 degrees of freedom
	Multiple R-squared:  0.2718,	Adjusted R-squared:  0.2509 
	F-statistic:    13 on 6 and 209 DF,  p-value: 1.767e-12

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS", robustSE = TRUE)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            -0.0729      -0.1213      -0.0269       0
	ADE              0.4166       0.3061       0.5287       0
	Total Effect     0.3436       0.2600       0.4240       0
	Prop. Mediated  -0.2093      -0.3273      -0.0887       0

	Sample Size Used: 216 


	Simulations: 1000 

sens.out <- medsens(med.out, effect.type = "both")
summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	     Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] 0.1 -0.0306      -0.0739       0.0127         0.01       0.0049
	[2,] 0.2  0.0131      -0.0299       0.0561         0.04       0.0195

	Rho at which ACME = 0: 0.2
	R^2_M*R^2_Y* at which ACME = 0: 0.04
	R^2_M~R^2_Y~ at which ACME = 0: 0.0195 


	Mediation Sensitivity Analysis for Average Direct Effect

	Sensitivity Region

	     Rho     ADE 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] 0.6  0.1004      -0.0271       0.2278         0.36       0.1755
	[2,] 0.7  0.0034      -0.1336       0.1404         0.49       0.2388
	[3,] 0.8 -0.1454      -0.2998       0.0091         0.64       0.3119

	Rho at which ADE = 0: 0.7
	R^2_M*R^2_Y* at which ADE = 0: 0.49
	R^2_M~R^2_Y~ at which ADE = 0: 0.2388


----
> sens.out$r.square.y
[1] 0.3403505
> sens.out$r.square.m
[1] 0.3120641

---

> sens.out$r.square.y
[1] 0.2717694
> sens.out$r.square.m
[1] 0.3307554


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
