# mysql
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
mysql <- subset(x, x$DBMS=='mysql')
mysql$ATP = (mysql$ATP-min(mysql$ATP))/(max(mysql$ATP)-min(mysql$ATP))
mysql$MAXMPL = (mysql$MAXMPL-min(mysql$MAXMPL))/(max(mysql$MAXMPL)-min(mysql$MAXMPL))
mysql$ACTROWPOOL = (mysql$ACTROWPOOL-min(mysql$ACTROWPOOL))/(max(mysql$ACTROWPOOL)-min(mysql$ACTROWPOOL))
mysql$PCTREAD = (mysql$PCTREAD-min(mysql$PCTREAD))/(max(mysql$PCTREAD)-min(mysql$PCTREAD))
mysql$PCTUPDATE = (mysql$PCTUPDATE-min(mysql$PCTUPDATE))/(max(mysql$PCTUPDATE)-min(mysql$PCTUPDATE))
mysql$NUMPROCESSORS = (mysql$NUMPROCESSORS-min(mysql$NUMPROCESSORS))/(max(mysql$NUMPROCESSORS)-min(mysql$NUMPROCESSORS))
x = rbind(mysql)
x <- subset(x, x$MAXMPL < 1)
cor(x$PCTREAD, x$MAXMPL)
-0.06549266
cor(x$PCTUPDATE, x$MAXMPL)
0.5273006

re <- subset(x, x$PCTREAD!=0)
re <- subset(re, select = -PCTUPDATE)
cor(re$PCTREAD, re$MAXMPL)
0.1884961
cor(re$PCTREAD, re$ATP)
-0.02081751

up <- subset(x, x$PCTUPDATE!=0)
up <- subset(up, select = -PCTREAD)
cor(up$PCTUPDATE, up$MAXMPL)
0.550914
cor(up$PCTUPDATE, up$ATP)
-0.08827596

#############################################
med.fit <- lm(ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK + PCTUPDATE + PCTUPDATE:PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK + 
	    PCTUPDATE + PCTUPDATE:PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.29921 -0.06572 -0.00697  0.04927  0.43397 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.55303    0.02250  24.583  < 2e-16 ***
	NUMPROCESSORS -0.03539    0.02344  -1.510  0.13275    
	PK            -0.47896    0.03079 -15.554  < 2e-16 ***
	PCTREAD        0.19713    0.04690   4.203 4.02e-05 ***
	PCTUPDATE     -0.14957    0.03610  -4.143 5.11e-05 ***
	PK:PCTREAD    -0.23712    0.07253  -3.269  0.00127 ** 
	PK:PCTUPDATE   0.43232    0.05280   8.188 3.47e-14 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1286 on 194 degrees of freedom
	Multiple R-squared:  0.7017,	Adjusted R-squared:  0.6925 
	F-statistic: 76.07 on 6 and 194 DF,  p-value: < 2.2e-16

out.fit <- lm(MAXMPL ~ PK + PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + PCTREAD + PCTUPDATE + ACTROWPOOL + 
	    ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.69127 -0.16818  0.03026  0.22594  0.62579 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    1.087504   0.076569  14.203  < 2e-16 ***
	PK            -0.302520   0.060240  -5.022 1.16e-06 ***
	PCTREAD       -0.014159   0.081624  -0.173    0.862    
	PCTUPDATE      0.492651   0.059633   8.261 2.21e-14 ***
	ACTROWPOOL     0.005987   0.058046   0.103    0.918    
	ATP           -1.117140   0.135558  -8.241 2.51e-14 ***
	NUMPROCESSORS -0.070944   0.052768  -1.344    0.180    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2887 on 194 degrees of freedom
	Multiple R-squared:  0.4479,	Adjusted R-squared:  0.4309 
	F-statistic: 26.23 on 6 and 194 DF,  p-value: < 2.2e-16

#### thrashing or not thrashing #############
x = rbind(mysql) 
x$MAXMPL[x$MAXMPL < 1] <- 0
out.fit <-  glm(MAXMPL ~ PK + PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, family="binomial", data = x)
summary(out.fit)

	Call:
	glm(formula = MAXMPL ~ PK + PCTREAD + PCTUPDATE + ACTROWPOOL + 
	    ATP + NUMPROCESSORS, family = "binomial", data = x)

	Deviance Residuals: 
	    Min       1Q   Median       3Q      Max  
	-2.7378  -0.6642   0.3164   0.7798   1.7653  

	Coefficients:
		      Estimate Std. Error z value Pr(>|z|)    
	(Intercept)     3.6735     0.6983   5.260 1.44e-07 ***
	PK             -2.8560     0.6133  -4.657 3.21e-06 ***
	PCTREAD        -0.6433     0.7358  -0.874    0.382    
	PCTUPDATE       3.6046     0.7174   5.024 5.05e-07 ***
	ACTROWPOOL      0.2386     0.5314   0.449    0.653    
	ATP            -8.3657     1.3577  -6.162 7.20e-10 ***
	NUMPROCESSORS  -0.3216     0.4685  -0.686    0.492    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	(Dispersion parameter for binomial family taken to be 1)

	    Null deviance: 267.55  on 200  degrees of freedom
	Residual deviance: 178.47  on 194  degrees of freedom
	AIC: 192.47

	Number of Fisher Scoring iterations: 5

> 1-out.fit$deviance/out.fit$null.deviance
[1] 0.3329512

> confint(out.fit)
Waiting for profiling to be done...
                    2.5 %     97.5 %
(Intercept)     2.3616408  5.1171173
PK             -4.1427824 -1.7210140
PCTREAD        -2.1805824  0.7562691
PCTUPDATE       2.2921013  5.1226324
ACTROWPOOL     -0.7962949  1.2985757
ATP           -11.1854132 -5.8343631
NUMPROCESSORS  -1.2472743  0.5983812














y <- subset(x, x$MAXMPL < 1)

cor(y$NUMPROCESSORS, y$MAXMPL)
-0.08

cor(y$ACTROWPOOL, y$MAXMPL)
-0.16

cor(y$PCTREAD, y$MAXMPL)
-0.07

cor(y$PCTUPDATE, y$MAXMPL)
0.53

cor(y$ATP, y$MAXMPL)
-0.34

cor(y$PK, y$MAXMPL)
0.35

pdf("mysql_scaled_var_rel_on_thrashing.pdf")
par(mfrow=c(3,2), oma=c(0, 0, 2, 0))
plot(y$NUMPROCESSORS, y$MAXMPL, main='# of Processors vs. Max MPL (c.e.: -0.08)', xlim=c(0, 1), ylim=c(0, 1), xlab='Number of Processors', ylab='Max MPL')
plot(y$ACTROWPOOL, y$MAXMPL, main='Active Row Pool vs. Max MPL (c.e.: -0.16)', xlim=c(0, 1), ylim=c(0, 1), xlab='Active Row Pool', ylab='Max MPL')
plot(y$PCTREAD, y$MAXMPL, main='PRS vs. Max MPL (c.e.:  -0.07)', xlim=c(0, 1), ylim=c(0, 1), xlab='Percentage of Rows from SELECT (PRS)', ylab='Max MPL')
plot(y$PCTUPDATE, y$MAXMPL, main='PRU vs. Max MPL (c.e.: 0.53)', xlim=c(0, 1), ylim=c(0, 1), xlab='Percentage of Rows from UPDATE (PRU)', ylab='Max MPL')
plot(y$ATP, y$MAXMPL, main='ATP time vs. Max MPL (c.e.: -0.34)', xlim=c(0, 1), ylim=c(0, 1), xlab='Average Transaction Processing Time (ATP time)', ylab='Max MPL')
plot(y$PK, y$MAXMPL, main='Presence of PK vs. Max MPL (c.e.: 0.35)', xlim=c(0, 1), ylim=c(0, 1), xlab='Presence of Primary Key (PK)', ylab='Max MPL')
title(adj=0.5, main = "MySQL - Variables' Relationship (on per-DBMS scaled thrashing data)", outer=TRUE)
#text(0.25, 0.5, "Variables' Relationship (on feature-scaled data)")
dev.off()


> nrow(x)
[1] 79

med.fit <- lm(ATP ~ NUMPROCESSORS + PCTUPDATE  + PK + PK:PCTUPDATE, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PCTUPDATE + PK + PK:PCTUPDATE, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.30220 -0.06118 -0.02234  0.04448  0.44176 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.59472    0.02100  28.322  < 2e-16 ***
	NUMPROCESSORS -0.02976    0.02435  -1.222    0.223    
	PCTUPDATE     -0.20811    0.03465  -6.006  9.1e-09 ***
	PK            -0.53123    0.02774 -19.153  < 2e-16 ***
	PCTUPDATE:PK   0.50201    0.05060   9.921  < 2e-16 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1338 on 196 degrees of freedom
	Multiple R-squared:  0.6738,	Adjusted R-squared:  0.6671 
	F-statistic: 101.2 on 4 and 196 DF,  p-value: < 2.2e-16

out.fit <- lm(MAXMPL ~ NUMPROCESSORS + ATP + PCTREAD + PCTUPDATE + ACTROWPOOL + PK, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ NUMPROCESSORS + ATP + PCTREAD + PCTUPDATE + 
	    ACTROWPOOL + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.69127 -0.16818  0.03026  0.22594  0.62579 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    1.087504   0.076569  14.203  < 2e-16 ***
	NUMPROCESSORS -0.070944   0.052768  -1.344    0.180    
	ATP           -1.117140   0.135558  -8.241 2.51e-14 ***
	PCTREAD       -0.014159   0.081624  -0.173    0.862    
	PCTUPDATE      0.492651   0.059633   8.261 2.21e-14 ***
	ACTROWPOOL     0.005987   0.058046   0.103    0.918    
	PK            -0.302520   0.060240  -5.022 1.16e-06 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2887 on 194 degrees of freedom
	Multiple R-squared:  0.4479,	Adjusted R-squared:  0.4309 
	F-statistic: 26.23 on 6 and 194 DF,  p-value: < 2.2e-16

---

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
x = rbind(mysql) 

med.fit <- lm(ATP ~ NUMPROCESSORS + PCTUPDATE  + PK + PK:PCTUPDATE, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PCTUPDATE + PK + PK:PCTUPDATE, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.30789 -0.10352 -0.02407  0.08160  0.45042 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.66170    0.02355  28.093  < 2e-16 ***
	NUMPROCESSORS -0.05818    0.02731  -2.130   0.0344 *  
	PCTUPDATE     -0.18512    0.03887  -4.763 3.71e-06 ***
	PK            -0.61270    0.03111 -19.694  < 2e-16 ***
	PCTUPDATE:PK   0.44401    0.05676   7.823 3.13e-13 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.15 on 196 degrees of freedom
	Multiple R-squared:  0.7128,	Adjusted R-squared:  0.7069 
	F-statistic: 121.6 on 4 and 196 DF,  p-value: < 2.2e-16

----

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PCTUPDATE + PK + PK:PCTUPDATE, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.30220 -0.06118 -0.02234  0.04448  0.44176 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.59472    0.02100  28.322  < 2e-16 ***
	NUMPROCESSORS -0.02976    0.02435  -1.222    0.223    
	PCTUPDATE     -0.20811    0.03465  -6.006  9.1e-09 ***
	PK            -0.53123    0.02774 -19.153  < 2e-16 ***
	PCTUPDATE:PK   0.50201    0.05060   9.921  < 2e-16 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1338 on 196 degrees of freedom
	Multiple R-squared:  0.6738,	Adjusted R-squared:  0.6671 
	F-statistic: 101.2 on 4 and 196 DF,  p-value: < 2.2e-16

out.fit <- lm(MAXMPL ~ NUMPROCESSORS + ATP + PCTREAD + PCTUPDATE + ACTROWPOOL + PK, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ NUMPROCESSORS + ATP + PCTREAD + PCTUPDATE + 
	    ACTROWPOOL + PK, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.8882 -0.2907  0.0674  0.3105  0.5719 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    1.06121    0.09542  11.122  < 2e-16 ***
	NUMPROCESSORS -0.06787    0.06198  -1.095    0.275    
	ATP           -0.95419    0.14960  -6.378 1.28e-09 ***
	PCTREAD       -0.14327    0.09495  -1.509    0.133    
	PCTUPDATE      0.47693    0.06942   6.871 8.48e-11 ***
	ACTROWPOOL    -0.01382    0.06732  -0.205    0.838    
	PK            -0.37085    0.08022  -4.623 6.89e-06 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3368 on 194 degrees of freedom
	Multiple R-squared:  0.3739,	Adjusted R-squared:  0.3545 
	F-statistic: 19.31 on 6 and 194 DF,  p-value: < 2.2e-16

----

	Call:
	lm(formula = MAXMPL ~ NUMPROCESSORS + ATP + PCTREAD + PCTUPDATE + 
	    ACTROWPOOL + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.68894 -0.15883  0.02775  0.23346  0.66716 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    1.079203   0.077367  13.949  < 2e-16 ***
	NUMPROCESSORS -0.066801   0.053318  -1.253    0.212    
	ATP           -1.090110   0.136969  -7.959 1.42e-13 ***
	PCTREAD       -0.073627   0.082473  -0.893    0.373    
	PCTUPDATE      0.482025   0.060253   8.000 1.11e-13 ***
	ACTROWPOOL     0.009391   0.058650   0.160    0.873    
	PK            -0.303037   0.060867  -4.979 1.41e-06 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2917 on 194 degrees of freedom
	Multiple R-squared:  0.443,	Adjusted R-squared:  0.4258 
	F-statistic: 25.72 on 6 and 194 DF,  p-value: < 2.2e-16

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK", robustSE = TRUE)
> summary(med.out)

Causal Mediation Analysis 

Quasi-Bayesian Confidence Intervals

               Estimate 95% CI Lower 95% CI Upper p-value
ACME             0.4124       0.2641       0.5493    0.00
ADE             -0.3672      -0.5133      -0.2139    0.00
Total Effect     0.0452      -0.0620       0.1634    0.38
Prop. Mediated   5.8480     -47.2769      74.9153    0.38

Sample Size Used: 201 


Simulations: 1000 

----

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME             0.3607       0.2507       0.4827    0.00
	ADE             -0.3025      -0.4418      -0.1593    0.00
	Total Effect     0.0583      -0.0368       0.1511    0.21
	Prop. Mediated   5.1002     -33.1950      48.4577    0.21

	Sample Size Used: 201 


	Simulations: 1000 

sens.out <- medsens(med.out, effect.type = "both")
summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.5 -0.0549      -0.2353       0.1256         0.25       0.0450
	[2,] -0.4  0.0959      -0.0881       0.2799         0.16       0.0288

	Rho at which ACME = 0: -0.5
	R^2_M*R^2_Y* at which ACME = 0: 0.25
	R^2_M~R^2_Y~ at which ACME = 0: 0.045 


	Mediation Sensitivity Analysis for Average Direct Effect

	Sensitivity Region

	      Rho     ADE 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.5  0.0894      -0.0686       0.2475         0.25       0.0450
	[2,] -0.4 -0.0307      -0.1833       0.1218         0.16       0.0288
	[3,] -0.3 -0.1313      -0.2812       0.0187         0.09       0.0162

	Rho at which ADE = 0: -0.4
	R^2_M*R^2_Y* at which ADE = 0: 0.16
	R^2_M~R^2_Y~ at which ADE = 0: 0.0288 

-----
	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.6 -0.0389      -0.1969       0.1190         0.36       0.0654
	[2,] -0.5  0.1012      -0.0580       0.2605         0.25       0.0454

	Rho at which ACME = 0: -0.6
	R^2_M*R^2_Y* at which ACME = 0: 0.36
	R^2_M~R^2_Y~ at which ACME = 0: 0.0654 


	Mediation Sensitivity Analysis for Average Direct Effect

	Sensitivity Region

	      Rho     ADE 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.6  0.0865      -0.0521       0.2251         0.36       0.0654
	[2,] -0.5 -0.0129      -0.1453       0.1194         0.25       0.0454
	[3,] -0.4 -0.0903      -0.2195       0.0389         0.16       0.0291

	Rho at which ADE = 0: -0.5
	R^2_M*R^2_Y* at which ADE = 0: 0.25
	R^2_M~R^2_Y~ at which ADE = 0: 0.0454

----
> sens.out$r.square.y
[1] 0.3739004
> sens.out$r.square.m
[1] 0.7127983

> sens.out$r.square.y
[1] 0.443036
> sens.out$r.square.m
[1] 0.6737662
