# mysql
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
mysql <- subset(x, x$DBMS=='mysql')
mysql$ATP = (mysql$ATP-min(mysql$ATP))/(max(mysql$ATP)-min(mysql$ATP))
mysql$MAXMPL = (mysql$MAXMPL-min(mysql$MAXMPL))/(max(mysql$MAXMPL)-min(mysql$MAXMPL))
x = rbind(mysql) 
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
	-0.27827 -0.07607 -0.01200  0.06532  0.38981 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.52202    0.02301  22.690  < 2e-16 ***
	NUMPROCESSORS -0.02438    0.02252  -1.083     0.28    
	ACTROWPOOL     0.13748    0.02338   5.880 1.76e-08 ***
	PK            -0.52573    0.02564 -20.501  < 2e-16 ***
	PCTUPDATE     -0.20564    0.03202  -6.422 1.00e-09 ***
	PK:PCTUPDATE   0.49468    0.04677  10.577  < 2e-16 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1236 on 195 degrees of freedom
	Multiple R-squared:  0.7229,	Adjusted R-squared:  0.7158 
	F-statistic: 101.7 on 5 and 195 DF,  p-value: < 2.2e-16

## MAXMPL regression followed by mediation via PK only through ATP
> out.fit <- lm(MAXMPL ~ ATP + PK, data = x)
> summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + PK, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.8254 -0.2949  0.1066  0.2421  0.6738 

	Coefficients:
		    Estimate Std. Error t value Pr(>|t|)    
	(Intercept)  1.19214    0.08304  14.357  < 2e-16 ***
	ATP         -1.01349    0.15050  -6.734 1.74e-10 ***
	PK          -0.25576    0.06971  -3.669 0.000313 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3472 on 198 degrees of freedom
	Multiple R-squared:  0.1947,	Adjusted R-squared:  0.1866 
	F-statistic: 23.93 on 2 and 198 DF,  p-value: 4.901e-10

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK", robustSE = TRUE)
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME             0.3360       0.1986       0.4775    0.00
	ADE             -0.2587      -0.4482      -0.0623    0.00
	Total Effect     0.0774      -0.0261       0.1782    0.14
	Prop. Mediated   3.7894     -21.6763      48.9113    0.14

	Sample Size Used: 201 


	Simulations: 1000

> sens.out <- medsens(med.out, effect.type = "indirect")
> summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.6 -0.1139      -0.2641       0.0362         0.36       0.0803
	[2,] -0.5  0.0257      -0.1305       0.1819         0.25       0.0558
	[3,] -0.4  0.1460      -0.0178       0.3098         0.16       0.0357

	Rho at which ACME = 0: -0.5
	R^2_M*R^2_Y* at which ACME = 0: 0.25
	R^2_M~R^2_Y~ at which ACME = 0: 0.0558

#### mediation by NUMPROCESSORS through ATP
> out.fit <- lm(MAXMPL ~ ATP + NUMPROCESSORS, data = x)
> summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.83637 -0.27237  0.09672  0.31349  0.47716 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.96639    0.05396  17.908  < 2e-16 ***
	ATP           -0.62858    0.10930  -5.751 3.32e-08 ***
	NUMPROCESSORS -0.07227    0.06518  -1.109    0.269    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3577 on 198 degrees of freedom
	Multiple R-squared:  0.1452,	Adjusted R-squared:  0.1366 
	F-statistic: 16.82 on 2 and 198 DF,  p-value: 1.787e-07

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS", robustSE = TRUE)
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME             0.0159      -0.0123       0.0462    0.26
	ADE             -0.0732      -0.1985       0.0576    0.26
	Total Effect    -0.0574      -0.1879       0.0761    0.40
	Prop. Mediated  -0.1113      -3.5309       2.7889    0.62

	Sample Size Used: 201 


	Simulations: 1000 

> sens.out <- medsens(med.out, effect.type = "indirect")
> summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	       Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	 [1,] -0.9 -0.0392      -0.1181       0.0396         0.81       0.1919
	 [2,] -0.8 -0.0147      -0.0441       0.0147         0.64       0.1516
	 [3,] -0.7 -0.0053      -0.0173       0.0066         0.49       0.1161
	 [4,] -0.6 -0.0001      -0.0057       0.0055         0.36       0.0853
	 [5,] -0.5  0.0035      -0.0048       0.0118         0.25       0.0592
	 [6,] -0.4  0.0063      -0.0062       0.0188         0.16       0.0379
	 [7,] -0.3  0.0087      -0.0077       0.0251         0.09       0.0213
	 [8,] -0.2  0.0109      -0.0090       0.0309         0.04       0.0095
	 [9,] -0.1  0.0131      -0.0103       0.0365         0.01       0.0024
	[10,]  0.0  0.0153      -0.0115       0.0422         0.00       0.0000
	[11,]  0.1  0.0177      -0.0128       0.0482         0.01       0.0024
	[12,]  0.2  0.0203      -0.0142       0.0548         0.04       0.0095
	[13,]  0.3  0.0233      -0.0158       0.0625         0.09       0.0213
	[14,]  0.4  0.0270      -0.0177       0.0717         0.16       0.0379
	[15,]  0.5  0.0317      -0.0203       0.0836         0.25       0.0592
	[16,]  0.6  0.0380      -0.0239       0.0999         0.36       0.0853
	[17,]  0.7  0.0474      -0.0300       0.1248         0.49       0.1161
	[18,]  0.8  0.0636      -0.0423       0.1695         0.64       0.1516
	[19,]  0.9  0.1009      -0.0782       0.2800         0.81       0.1919

	Rho at which ACME = 0: -0.6
	R^2_M*R^2_Y* at which ACME = 0: 0.36
	R^2_M~R^2_Y~ at which ACME = 0: 0.0853 

> sens.out$r.square.y
	[1] 0.1452498
> sens.out$r.square.m
	[1] 0.7228946

#### mediation by NUMPROCESSORS+PK through ATP
> out.fit <- lm(MAXMPL ~ ATP + PK + NUMPROCESSORS, data = x)
> summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + PK + NUMPROCESSORS, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.7782 -0.2914  0.1113  0.2368  0.7187 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    1.23414    0.08866  13.920  < 2e-16 ***
	ATP           -1.02942    0.15067  -6.832 1.02e-10 ***
	PK            -0.26049    0.06966  -3.739 0.000242 ***
	NUMPROCESSORS -0.08431    0.06323  -1.333 0.183950    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3465 on 197 degrees of freedom
	Multiple R-squared:  0.2019,	Adjusted R-squared:  0.1897 
	F-statistic: 16.61 on 3 and 197 DF,  p-value: 1.161e-09

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS", robustSE = TRUE)
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME             0.0246      -0.0192       0.0727    0.28
	ADE             -0.0833      -0.2120       0.0417    0.21
	Total Effect    -0.0587      -0.1928       0.0738    0.41
	Prop. Mediated  -0.1667      -4.6511       4.4970    0.65

	Sample Size Used: 201 


	Simulations: 1000 

> sens.out <- medsens(med.out, effect.type = "indirect")
> summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	       Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	 [1,] -0.9 -0.0723      -0.2067       0.0621         0.81       0.1791
	 [2,] -0.8 -0.0329      -0.0953       0.0295         0.64       0.1415
	 [3,] -0.7 -0.0158      -0.0466       0.0150         0.49       0.1084
	 [4,] -0.6 -0.0056      -0.0187       0.0074         0.36       0.0796
	 [5,] -0.5  0.0015      -0.0066       0.0096         0.25       0.0553
	 [6,] -0.4  0.0071      -0.0081       0.0223         0.16       0.0354
	 [7,] -0.3  0.0120      -0.0111       0.0350         0.09       0.0199
	 [8,] -0.2  0.0164      -0.0140       0.0469         0.04       0.0088
	 [9,] -0.1  0.0207      -0.0167       0.0582         0.01       0.0022
	[10,]  0.0  0.0251      -0.0193       0.0695         0.00       0.0000
	[11,]  0.1  0.0297      -0.0217       0.0811         0.01       0.0022
	[12,]  0.2  0.0347      -0.0242       0.0936         0.04       0.0088
	[13,]  0.3  0.0403      -0.0267       0.1074         0.09       0.0199
	[14,]  0.4  0.0469      -0.0295       0.1233         0.16       0.0354
	[15,]  0.5  0.0549      -0.0327       0.1424         0.25       0.0553
	[16,]  0.6  0.0650      -0.0368       0.1669         0.36       0.0796
	[17,]  0.7  0.0791      -0.0425       0.2008         0.49       0.1084
	[18,]  0.8  0.1012      -0.0523       0.2548         0.64       0.1415
	[19,]  0.9  0.1470      -0.0761       0.3702         0.81       0.1791

	Rho at which ACME = 0: -0.5
	R^2_M*R^2_Y* at which ACME = 0: 0.25
	R^2_M~R^2_Y~ at which ACME = 0: 0.0553

> sens.out$r.square.y
[1] 0.2018945
> sens.out$r.square.m
[1] 0.7228946

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK", robustSE = TRUE)
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME             0.3416       0.2144       0.4820    0.00
	ADE             -0.2614      -0.4558      -0.0860    0.01
	Total Effect     0.0803      -0.0241       0.1834    0.14
	Prop. Mediated   3.6888     -34.6174      42.1745    0.14

	Sample Size Used: 201 


	Simulations: 1000

> sens.out <- medsens(med.out, effect.type = "indirect")
> summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.6 -0.1099      -0.2611       0.0412         0.36       0.0796
	[2,] -0.5  0.0310      -0.1265       0.1885         0.25       0.0553
	[3,] -0.4  0.1524      -0.0132       0.3180         0.16       0.0354

	Rho at which ACME = 0: -0.5
	R^2_M*R^2_Y* at which ACME = 0: 0.25
	R^2_M~R^2_Y~ at which ACME = 0: 0.0553

### best fit for MAXMPL
## forward
> out.fit  <- lm(MAXMPL ~ 1, data = x)
> out.fit <- step(out.fit, direction="forward", scope=( ~ ATP + NUMPROCESSORS + ACTROWPOOL + PCTUPDATE + PK + PCTREAD), data = x)
	Start:  AIC=-382.78
	MAXMPL ~ 1

		        Df Sum of Sq    RSS     AIC
	+ PCTUPDATE      1    6.4646 23.171 -430.24
	+ ATP            1    4.1473 25.488 -411.08
	+ PCTREAD        1    2.6397 26.996 -399.53
	+ ACTROWPOOL     1    0.5779 29.058 -384.74
	+ PK             1    0.3034 29.332 -382.85
	<none>                       29.636 -382.78
	+ NUMPROCESSORS  1    0.0734 29.562 -381.28

	Step:  AIC=-430.24
	MAXMPL ~ PCTUPDATE

		        Df Sum of Sq    RSS     AIC
	+ ATP            1    4.1927 18.978 -468.36
	+ ACTROWPOOL     1    0.6056 22.565 -433.57
	+ PCTREAD        1    0.4761 22.695 -432.42
	<none>                       23.171 -430.24
	+ PK             1    0.1626 23.008 -429.66
	+ NUMPROCESSORS  1    0.0326 23.138 -428.53

	Step:  AIC=-468.36
	MAXMPL ~ PCTUPDATE + ATP

		        Df Sum of Sq    RSS     AIC
	+ PK             1   2.25626 16.722 -491.80
	+ PCTREAD        1   0.19011 18.788 -468.39
	<none>                       18.978 -468.36
	+ NUMPROCESSORS  1   0.09394 18.884 -467.36
	+ ACTROWPOOL     1   0.07307 18.905 -467.14

	Step:  AIC=-491.8
	MAXMPL ~ PCTUPDATE + ATP + PK

		        Df Sum of Sq    RSS     AIC
	<none>                       16.722 -491.80
	+ NUMPROCESSORS  1  0.143726 16.578 -491.54
	+ PCTREAD        1  0.079815 16.642 -490.77
	+ ACTROWPOOL     1  0.005312 16.717 -489.87

> summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PCTUPDATE + ATP + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.67621 -0.18438  0.04445  0.26389  0.60692 

	Coefficients:
		    Estimate Std. Error t value Pr(>|t|)    
	(Intercept)  1.03949    0.07164  14.510  < 2e-16 ***
	PCTUPDATE    0.50561    0.05511   9.174  < 2e-16 ***
	ATP         -1.08916    0.12656  -8.606 2.39e-15 ***
	PK          -0.30275    0.05872  -5.156 6.13e-07 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2913 on 197 degrees of freedom
	Multiple R-squared:  0.4357,	Adjusted R-squared:  0.4272 
	F-statistic: 50.71 on 3 and 197 DF,  p-value: < 2.2e-16

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK")
> sens.out <- medsens(med.out, effect.type = "indirect")
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME             0.3582       0.2727       0.4466    0.00
	ADE             -0.3039      -0.4204      -0.1842    0.00
	Total Effect     0.0543      -0.0305       0.1443    0.24
	Prop. Mediated   5.3687     -63.3276      55.5685    0.24

	Sample Size Used: 201 

> summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.6 -0.0256      -0.1411       0.0898         0.36       0.0563
	[2,] -0.5  0.1111      -0.0078       0.2300         0.25       0.0391

	Rho at which ACME = 0: -0.6
	R^2_M*R^2_Y* at which ACME = 0: 0.36
	R^2_M~R^2_Y~ at which ACME = 0: 0.0563

> sens.out$r.square.y
[1] 0.4357475
> sens.out$r.square.m
[1] 0.7228946

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE")
> summary(med.out)

Causal Mediation Analysis 

Quasi-Bayesian Confidence Intervals

               Estimate 95% CI Lower 95% CI Upper p-value
ACME            -0.0295      -0.0877       0.0188    0.25
ADE              0.5057       0.3942       0.6063    0.00
Total Effect     0.4762       0.3525       0.5952    0.00
Prop. Mediated  -0.0586      -0.2128       0.0348    0.25

Sample Size Used: 201 


Simulations: 1000 

> sens.out <- medsens(med.out, effect.type = "indirect")
> summary(sens.out)

Mediation Sensitivity Analysis for Average Causal Mediation Effect

Sensitivity Region

      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
[1,] -0.9 -0.0129      -0.1656       0.1399         0.81       0.1266
[2,] -0.8 -0.0568      -0.1263       0.0126         0.64       0.1001
[3,] -0.6 -0.0067      -0.0372       0.0238         0.36       0.0563
[4,] -0.5  0.0336      -0.0049       0.0722         0.25       0.0391

Rho at which ACME = 0: -0.6
R^2_M*R^2_Y* at which ACME = 0: 0.36
R^2_M~R^2_Y~ at which ACME = 0: 0.0563 

> sens.out$r.square.y
[1] 0.4357475
> sens.out$r.square.m
[1] 0.7228946

## find best fit for ATP
med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + PK + PCTUPDATE + PK:PCTUPDATE, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + PK + PCTUPDATE + 
	    PK:PCTUPDATE, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.27827 -0.07607 -0.01200  0.06532  0.38981 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.52202    0.02301  22.690  < 2e-16 ***
	NUMPROCESSORS -0.02438    0.02252  -1.083     0.28    
	ACTROWPOOL     0.13748    0.02338   5.880 1.76e-08 ***
	PK            -0.52573    0.02564 -20.501  < 2e-16 ***
	PCTUPDATE     -0.20564    0.03202  -6.422 1.00e-09 ***
	PK:PCTUPDATE   0.49468    0.04677  10.577  < 2e-16 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1236 on 195 degrees of freedom
	Multiple R-squared:  0.7229,	Adjusted R-squared:  0.7158 
	F-statistic: 101.7 on 5 and 195 DF,  p-value: < 2.2e-16

## find best fit for MAXMPL
## forward
> out.fit  <- lm(MAXMPL ~ 1, data = x)
> out.fit <- step(out.fit, direction="forward", scope=( ~ ATP + NUMPROCESSORS + ACTROWPOOL + PCTUPDATE + PK + PCTREAD), data = x)
	Start:  AIC=-382.78
	MAXMPL ~ 1

		        Df Sum of Sq    RSS     AIC
	+ PCTUPDATE      1    6.4646 23.171 -430.24
	+ ATP            1    4.1473 25.488 -411.08
	+ PCTREAD        1    2.6397 26.996 -399.53
	+ ACTROWPOOL     1    0.5779 29.058 -384.74
	+ PK             1    0.3034 29.332 -382.85
	<none>                       29.636 -382.78
	+ NUMPROCESSORS  1    0.0734 29.562 -381.28

	Step:  AIC=-430.24
	MAXMPL ~ PCTUPDATE

		        Df Sum of Sq    RSS     AIC
	+ ATP            1    4.1927 18.978 -468.36
	+ ACTROWPOOL     1    0.6056 22.565 -433.57
	+ PCTREAD        1    0.4761 22.695 -432.42
	<none>                       23.171 -430.24
	+ PK             1    0.1626 23.008 -429.66
	+ NUMPROCESSORS  1    0.0326 23.138 -428.53

	Step:  AIC=-468.36
	MAXMPL ~ PCTUPDATE + ATP

		        Df Sum of Sq    RSS     AIC
	+ PK             1   2.25626 16.722 -491.80
	+ PCTREAD        1   0.19011 18.788 -468.39
	<none>                       18.978 -468.36
	+ NUMPROCESSORS  1   0.09394 18.884 -467.36
	+ ACTROWPOOL     1   0.07307 18.905 -467.14

	Step:  AIC=-491.8
	MAXMPL ~ PCTUPDATE + ATP + PK

		        Df Sum of Sq    RSS     AIC
	<none>                       16.722 -491.80
	+ NUMPROCESSORS  1  0.143726 16.578 -491.54
	+ PCTREAD        1  0.079815 16.642 -490.77
	+ ACTROWPOOL     1  0.005312 16.717 -489.87

> summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PCTUPDATE + ATP + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.67621 -0.18438  0.04445  0.26389  0.60692 

	Coefficients:
		    Estimate Std. Error t value Pr(>|t|)    
	(Intercept)  1.03949    0.07164  14.510  < 2e-16 ***
	PCTUPDATE    0.50561    0.05511   9.174  < 2e-16 ***
	ATP         -1.08916    0.12656  -8.606 2.39e-15 ***
	PK          -0.30275    0.05872  -5.156 6.13e-07 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2913 on 197 degrees of freedom
	Multiple R-squared:  0.4357,	Adjusted R-squared:  0.4272 
	F-statistic: 50.71 on 3 and 197 DF,  p-value: < 2.2e-16

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK")
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME             0.3592       0.2708       0.4522    0.00
	ADE             -0.3038      -0.4186      -0.1816    0.00
	Total Effect     0.0554      -0.0348       0.1432    0.22
	Prop. Mediated   5.2670     -67.2555      69.6937    0.22

	Sample Size Used: 201 


	Simulations: 1000 

> sens.out <- medsens(med.out, effect.type = "indirect")
> summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.6 -0.0256      -0.1411       0.0898         0.36       0.0563
	[2,] -0.5  0.1111      -0.0078       0.2300         0.25       0.0391

	Rho at which ACME = 0: -0.6
	R^2_M*R^2_Y* at which ACME = 0: 0.36
	R^2_M~R^2_Y~ at which ACME = 0: 0.0563

> sens.out$r.square.y
[1] 0.4357475
> sens.out$r.square.m
[1] 0.7228946 


> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE")
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            -0.0291      -0.0783       0.0243    0.26
	ADE              0.5062       0.4018       0.6122    0.00
	Total Effect     0.4771       0.3617       0.5921    0.00
	Prop. Mediated  -0.0594      -0.1860       0.0469    0.26

	Sample Size Used: 201 


	Simulations: 1000

##### backward ####
> out.fit <- lm(MAXMPL ~ ATP + PCTUPDATE + PK + NUMPROCESSORS, data = x)
> out.fit <- step(out.fit, direction="backward", data = x)
	Start:  AIC=-491.54
	MAXMPL ~ ATP + PCTUPDATE + PK + NUMPROCESSORS

		        Df Sum of Sq    RSS     AIC
	- NUMPROCESSORS  1    0.1437 16.722 -491.80
	<none>                       16.578 -491.54
	- PK             1    2.3060 18.884 -467.36
	- ATP            1    6.3960 22.974 -427.96
	- PCTUPDATE      1    7.0741 23.652 -422.11

	Step:  AIC=-491.8
	MAXMPL ~ ATP + PCTUPDATE + PK

		    Df Sum of Sq    RSS     AIC
	<none>                   16.722 -491.80
	- PK         1    2.2563 18.978 -468.36
	- ATP        1    6.2863 23.008 -429.66
	- PCTUPDATE  1    7.1438 23.866 -422.30

>  summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + PCTUPDATE + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.67621 -0.18438  0.04445  0.26389  0.60692 

	Coefficients:
		    Estimate Std. Error t value Pr(>|t|)    
	(Intercept)  1.03949    0.07164  14.510  < 2e-16 ***
	ATP         -1.08916    0.12656  -8.606 2.39e-15 ***
	PCTUPDATE    0.50561    0.05511   9.174  < 2e-16 ***
	PK          -0.30275    0.05872  -5.156 6.13e-07 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2913 on 197 degrees of freedom
	Multiple R-squared:  0.4357,	Adjusted R-squared:  0.4272 
	F-statistic: 50.71 on 3 and 197 DF,  p-value: < 2.2e-16

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE")
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            -0.0315      -0.0851       0.0175     0.2
	ADE              0.5075       0.3991       0.6191     0.0
	Total Effect     0.4761       0.3596       0.5982     0.0
	Prop. Mediated  -0.0646      -0.2057       0.0333     0.2

	Sample Size Used: 201 


	Simulations: 1000 

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK")
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME             0.3589       0.2770       0.4522     0.0
	ADE             -0.3032      -0.4170      -0.1860     0.0
	Total Effect     0.0557      -0.0260       0.1471     0.2
	Prop. Mediated   5.4951     -43.2268      60.3582     0.2

	Sample Size Used: 201 


	Simulations: 1000

> sens.out <- medsens(med.out, effect.type = "indirect")
> summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.6 -0.0256      -0.1411       0.0898         0.36       0.0563
	[2,] -0.5  0.1111      -0.0078       0.2300         0.25       0.0391

	Rho at which ACME = 0: -0.6
	R^2_M*R^2_Y* at which ACME = 0: 0.36
	R^2_M~R^2_Y~ at which ACME = 0: 0.0563 

> sens.out$r.square.y
[1] 0.4357475
> sens.out$r.square.m
[1] 0.7228946
