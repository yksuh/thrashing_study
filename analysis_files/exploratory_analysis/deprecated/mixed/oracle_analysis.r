# oracle
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
oracle <- subset(x, x$DBMS=='oracle')
oracle$ATP = (oracle$ATP-min(oracle$ATP))/(max(oracle$ATP)-min(oracle$ATP))
oracle$MAXMPL = (oracle$MAXMPL-min(oracle$MAXMPL))/(max(oracle$MAXMPL)-min(oracle$MAXMPL))
oracle$ACTROWPOOL = (oracle$ACTROWPOOL-min(oracle$ACTROWPOOL))/(max(oracle$ACTROWPOOL)-min(oracle$ACTROWPOOL))
oracle$PCTREAD = (oracle$PCTREAD-min(oracle$PCTREAD))/(max(oracle$PCTREAD)-min(oracle$PCTREAD))
oracle$PCTUPDATE = (oracle$PCTUPDATE-min(oracle$PCTUPDATE))/(max(oracle$PCTUPDATE)-min(oracle$PCTUPDATE))
oracle$NUMPROCESSORS = (oracle$NUMPROCESSORS-min(oracle$NUMPROCESSORS))/(max(oracle$NUMPROCESSORS)-min(oracle$NUMPROCESSORS))
x = rbind(oracle) 
x <- subset(x, x$MAXMPL < 1)
cor(x$PCTREAD, x$MAXMPL)
0.1792937
cor(x$PCTUPDATE, x$MAXMPL)
-0.2333767

re <- subset(x, x$PCTREAD!=0)
re <- subset(re, select = -PCTUPDATE)
cor(re$PCTREAD, re$MAXMPL)
0.07934656
cor(re$PCTREAD, re$ATP)
0.000507219

up <- subset(x, x$PCTUPDATE!=0)
up <- subset(up, select = -PCTREAD)
cor(up$PCTUPDATE, up$MAXMPL)
-0.06793111
cor(up$PCTUPDATE, up$ATP)
0.01865397

#x$PCTUPDATE[x$PCTUPDATE == 0] <- NA
#x$PCTREAD[x$PCTREAD == 0] <- NA
med.fit <- lm(ATP ~ NUMPROCESSORS + PK + PCTUPDATE + PCTUPDATE:PK, data = x)
summary(med.fit)
med.fit <- lm(ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK, data = x)
summary(med.fit)

med.fit <- lm(ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK + PCTUPDATE + PCTUPDATE:PK, data = x)
summary(med.fit)

x <- subset(x, x$PCTUPDATE >= 0.5)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK + 
	    PCTUPDATE + PCTUPDATE:PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.22374 -0.03272 -0.00048  0.01484  0.76245 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.20954    0.03549   5.903 5.62e-08 ***
	NUMPROCESSORS  0.02363    0.03642   0.649 0.518046    
	PK            -0.21422    0.05085  -4.213 5.78e-05 ***
	PCTREAD        0.10227    0.05930   1.725 0.087902 .  
	PCTUPDATE     -0.28426    0.05606  -5.071 1.98e-06 ***
	PK:PCTREAD    -0.09975    0.09446  -1.056 0.293670    
	PK:PCTUPDATE   0.28680    0.07994   3.588 0.000532 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1358 on 94 degrees of freedom
	Multiple R-squared:  0.4193,	Adjusted R-squared:  0.3823 
	F-statistic: 11.31 on 6 and 94 DF,  p-value: 1.757e-09

out.fit <- lm(MAXMPL ~ PK + PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + PCTREAD + PCTUPDATE + ACTROWPOOL + 
	    ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.35807 -0.11455 -0.05592  0.16155  0.57508 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.40585    0.06158   6.590 2.52e-09 ***
	PK            -0.03054    0.04585  -0.666    0.507    
	PCTREAD        0.04561    0.07271   0.627    0.532    
	PCTUPDATE     -0.07388    0.06660  -1.109    0.270    
	ACTROWPOOL    -0.03800    0.05675  -0.670    0.505    
	ATP           -0.13977    0.14522  -0.962    0.338    
	NUMPROCESSORS -0.25067    0.05652  -4.435 2.50e-05 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2116 on 94 degrees of freedom
	Multiple R-squared:  0.2352,	Adjusted R-squared:  0.1864 
	F-statistic: 4.818 on 6 and 94 DF,  p-value: 0.0002502

#### thrashing or not thrashing
x = rbind(oracle) 
x$MAXMPL[x$MAXMPL < 1] <- 0
out.fit <-  glm(MAXMPL ~ PK + PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, family="binomial", data = x)
summary(out.fit)

	Call:
	glm(formula = MAXMPL ~ PK + PCTREAD + PCTUPDATE + ACTROWPOOL + 
	    ATP + NUMPROCESSORS, family = "binomial", data = x)

	Deviance Residuals: 
	    Min       1Q   Median       3Q      Max  
	-1.6246  -1.0264  -0.5439   1.0334   2.0836  

	Coefficients:
		      Estimate Std. Error z value Pr(>|z|)    
	(Intercept)    0.86758    0.42619   2.036   0.0418 *  
	PK             0.22924    0.33190   0.691   0.4898    
	PCTREAD       -0.04725    0.52269  -0.090   0.9280    
	PCTUPDATE     -0.89672    0.48095  -1.864   0.0623 .  
	ACTROWPOOL     0.16480    0.41493   0.397   0.6912    
	ATP           -1.73625    1.38163  -1.257   0.2089    
	NUMPROCESSORS -1.81291    0.42240  -4.292 1.77e-05 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	(Dispersion parameter for binomial family taken to be 1)

	    Null deviance: 275.83  on 198  degrees of freedom
	Residual deviance: 246.81  on 192  degrees of freedom
	AIC: 260.81

	Number of Fisher Scoring iterations: 4

1-out.fit$deviance/out.fit$null.deviance
[1] 0.1052047

confint(out.fit)
Waiting for profiling to be done...
                    2.5 %      97.5 %
(Intercept)    0.04500553  1.72353980
PK            -0.42043389  0.88418042
PCTREAD       -1.06726567  0.99688883
PCTUPDATE     -1.85414617  0.03795484
ACTROWPOOL    -0.64928213  0.98267242
ATP           -4.87344676  0.73285315
NUMPROCESSORS -2.67345578 -1.00980195

























y <- subset(x, x$MAXMPL < 1)
cor(y$NUMPROCESSORS, y$MAXMPL)
-0.45

cor(y$ACTROWPOOL, y$MAXMPL)
-0.05

cor(y$PCTREAD, y$MAXMPL)
-0.18

cor(y$PCTUPDATE, y$MAXMPL)
-0.23

cor(y$ATP, y$MAXMPL)
0.01

cor(y$PK, y$MAXMPL)
-0.01

pdf("oracle_scaled_var_rel_on_thrashing.pdf")
par(mfrow=c(3,2), oma=c(0, 0, 2, 0))
plot(y$NUMPROCESSORS, y$MAXMPL, main='# of Processors vs. Max MPL (c.e.: -0.45)', xlim=c(0, 1), ylim=c(0, 1), xlab='Number of Processors', ylab='Max MPL')
plot(y$ACTROWPOOL, y$MAXMPL, main='Active Row Pool vs. Max MPL (c.e.: -0.05)', xlim=c(0, 1), ylim=c(0, 1), xlab='Active Row Pool', ylab='Max MPL')
plot(y$PCTREAD, y$MAXMPL, main='PRS vs. Max MPL (c.e.:  -0.18)', xlim=c(0, 1), ylim=c(0, 1), xlab='Percentage of Rows from SELECT (PRS)', ylab='Max MPL')
plot(y$PCTUPDATE, y$MAXMPL, main='PRU vs. Max MPL (c.e.: -0.23)', xlim=c(0, 1), ylim=c(0, 1), xlab='Percentage of Rows from UPDATE (PRU)', ylab='Max MPL')
plot(y$ATP, y$MAXMPL, main='ATP time vs. Max MPL (c.e.: 0.01)', xlim=c(0, 1), ylim=c(0, 1), xlab='Average Transaction Processing Time (ATP time)', ylab='Max MPL')
plot(y$PK, y$MAXMPL, main='Presence of PK vs. Max MPL (c.e.: -0.01)', xlim=c(0, 1), ylim=c(0, 1), xlab='Presence of Primary Key (PK)', ylab='Max MPL')
title(adj=0.5, main = "Oracle - Variables' Relationship (on per-DBMS scaled thrashing data)", outer=TRUE)
#text(0.25, 0.5, "Variables' Relationship (on feature-scaled data)")
dev.off()



> nrow(x)
[1] 112

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
	-0.85404 -0.31335  0.09264  0.30812  0.82436 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.84052    0.07547  11.138   <2e-16 ***
	NUMPROCESSORS -0.45720    0.07068  -6.469    8e-10 ***
	ATP           -0.30374    0.21258  -1.429   0.1547    
	PCTREAD        0.03005    0.09091   0.331   0.7413    
	PCTUPDATE     -0.21576    0.08521  -2.532   0.0121 *  
	ACTROWPOOL     0.01315    0.07366   0.179   0.8585    
	PK             0.03739    0.05898   0.634   0.5269    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3824 on 192 degrees of freedom
	Multiple R-squared:  0.2286,	Adjusted R-squared:  0.2045 
	F-statistic: 9.482 on 6 and 192 DF,  p-value: 4.029e-09

----

x = read.csv(file="expl.dat",head=TRUE,sep="\t")
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
x = rbind(oracle) 
med.fit <- lm(ATP ~ NUMPROCESSORS + PCTUPDATE + PK + PK:PCTUPDATE, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PCTUPDATE + PK + PK:PCTUPDATE, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.22907 -0.04896 -0.00347  0.03017  0.81615 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.14994    0.02109   7.109 2.18e-11 ***
	NUMPROCESSORS  0.07913    0.02421   3.268  0.00128 ** 
	PCTUPDATE     -0.23707    0.03556  -6.667 2.65e-10 ***
	PK            -0.18051    0.02723  -6.629 3.27e-10 ***
	PCTUPDATE:PK   0.23761    0.04992   4.760 3.77e-06 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1326 on 194 degrees of freedom
	Multiple R-squared:  0.271,	Adjusted R-squared:  0.256 
	F-statistic: 18.03 on 4 and 194 DF,  p-value: 1.318e-12

----

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
	-0.76225 -0.35266 -0.08073  0.36065  0.86665 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.75312    0.07977   9.441  < 2e-16 ***
	NUMPROCESSORS -0.45193    0.07858  -5.751 3.44e-08 ***
	ATP           -0.24224    0.21929  -1.105    0.271    
	PCTREAD       -0.02996    0.09989  -0.300    0.765    
	PCTUPDATE     -0.22988    0.09173  -2.506    0.013 *  
	ACTROWPOOL     0.01414    0.08149   0.174    0.862    
	PK             0.01603    0.06275   0.256    0.799    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.4215 on 192 degrees of freedom
	Multiple R-squared:  0.1928,	Adjusted R-squared:  0.1676 
	F-statistic: 7.642 on 6 and 192 DF,  p-value: 2.27e-07

----

	Call:
	lm(formula = MAXMPL ~ NUMPROCESSORS + ATP + PCTREAD + PCTUPDATE + 
	    ACTROWPOOL + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.78865 -0.30300  0.00401  0.30366  0.88813 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.826209   0.075856  10.892  < 2e-16 ***
	NUMPROCESSORS -0.461103   0.071040  -6.491 7.11e-10 ***
	ATP           -0.382774   0.213682  -1.791  0.07482 .  
	PCTREAD        0.003814   0.091381   0.042  0.96676    
	PCTUPDATE     -0.255793   0.085654  -2.986  0.00319 ** 
	ACTROWPOOL     0.025408   0.074040   0.343  0.73185    
	PK             0.001316   0.059282   0.022  0.98232    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3844 on 192 degrees of freedom
	Multiple R-squared:  0.2377,	Adjusted R-squared:  0.2139 
	F-statistic: 9.978 on 6 and 192 DF,  p-value: 1.388e-09

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS", robustSE = TRUE)
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.02201     -0.06392      0.00529    0.15
	ADE            -0.46110     -0.58929     -0.31822    0.00
	Total Effect   -0.48311     -0.61493     -0.33837    0.00
	Prop. Mediated  0.04077     -0.01254      0.12649    0.15

	Sample Size Used: 199 


	Simulations: 1000

sens.out <- medsens(med.out, effect.type = "both")
summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.3  0.0272      -0.0043       0.0587         0.09       0.0401
	[2,] -0.2  0.0095      -0.0164       0.0353         0.04       0.0178
	[3,] -0.1 -0.0071      -0.0328       0.0187         0.01       0.0045
	[4,]  0.0 -0.0229      -0.0530       0.0072         0.00       0.0000

	Rho at which ACME = 0: -0.1
	R^2_M*R^2_Y* at which ACME = 0: 0.01
	R^2_M~R^2_Y~ at which ACME = 0: 0.0045 


	Mediation Sensitivity Analysis for Average Direct Effect

	Sensitivity Region

	     Rho     ADE 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] 0.9 -0.1696      -0.4706       0.1314         0.81        0.361

	Rho at which ADE = 0: 0.9
	R^2_M*R^2_Y* at which ADE = 0: 0.81
	R^2_M~R^2_Y~ at which ADE = 0: 0.361 

> sens.out$r.square.y
[1] 0.2376887
> sens.out$r.square.m
[1] 0.415412
