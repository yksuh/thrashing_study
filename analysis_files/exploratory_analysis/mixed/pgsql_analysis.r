# pgsql
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
pgsql <- subset(x, x$DBMS=='pgsql')
pgsql$ATP = (pgsql$ATP-min(pgsql$ATP))/(max(pgsql$ATP)-min(pgsql$ATP))
pgsql$MAXMPL = (pgsql$MAXMPL-min(pgsql$MAXMPL))/(max(pgsql$MAXMPL)-min(pgsql$MAXMPL))
pgsql$ACTROWPOOL = (pgsql$ACTROWPOOL-min(pgsql$ACTROWPOOL))/(max(pgsql$ACTROWPOOL)-min(pgsql$ACTROWPOOL))
pgsql$PCTREAD = (pgsql$PCTREAD-min(pgsql$PCTREAD))/(max(pgsql$PCTREAD)-min(pgsql$PCTREAD))
pgsql$PCTUPDATE = (pgsql$PCTUPDATE-min(pgsql$PCTUPDATE))/(max(pgsql$PCTUPDATE)-min(pgsql$PCTUPDATE))
pgsql$NUMPROCESSORS = (pgsql$NUMPROCESSORS-min(pgsql$NUMPROCESSORS))/(max(pgsql$NUMPROCESSORS)-min(pgsql$NUMPROCESSORS))
x = rbind(pgsql) 
x <- subset(x, x$MAXMPL < 1)
cor(x$PCTREAD, x$MAXMPL)
-0.04992521
cor(x$PCTUPDATE, x$MAXMPL)

re <- subset(x, x$PCTREAD!=0)
re <- subset(re, select = -PCTUPDATE)
cor(re$PCTREAD, re$MAXMPL)
-0.1612675
cor(re$PCTREAD, re$ATP)
0.0302427

up <- subset(x, x$PCTUPDATE!=0)
up <- subset(up, select = -PCTREAD)
cor(up$PCTUPDATE, up$MAXMPL)
-0.1123671
cor(up$PCTUPDATE, up$ATP)
0.1340215

#############################################
med.fit <- lm(ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK + PCTUPDATE + PCTUPDATE:PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK + 
	    PCTUPDATE + PCTUPDATE:PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.30939 -0.10344 -0.01109  0.09579  0.62325 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.42779    0.03072  13.927  < 2e-16 ***
	NUMPROCESSORS -0.03768    0.03178  -1.186   0.2373    
	PK            -0.32519    0.04342  -7.490 2.78e-12 ***
	PCTREAD        0.11565    0.05443   2.125   0.0349 *  
	PCTUPDATE     -0.54787    0.04955 -11.056  < 2e-16 ***
	PK:PCTREAD     0.12510    0.08214   1.523   0.1295    
	PK:PCTUPDATE   0.43183    0.07582   5.695 4.80e-08 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.174 on 184 degrees of freedom
	Multiple R-squared:  0.5784,	Adjusted R-squared:  0.5647 
	F-statistic: 42.08 on 6 and 184 DF,  p-value: < 2.2e-16

out.fit <- lm(MAXMPL ~ PK + PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + PCTREAD + PCTUPDATE + ACTROWPOOL + 
	    ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.70372 -0.23728  0.03227  0.20004  0.96966 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.47836    0.07198   6.646 3.32e-10 ***
	PK             0.54148    0.04939  10.962  < 2e-16 ***
	PCTREAD       -0.17912    0.07648  -2.342  0.02025 *  
	PCTUPDATE     -0.21741    0.08110  -2.681  0.00801 ** 
	ACTROWPOOL    -0.09055    0.05976  -1.515  0.13143    
	ATP            0.27388    0.12254   2.235  0.02662 *  
	NUMPROCESSORS -0.23064    0.05766  -4.000 9.16e-05 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3145 on 184 degrees of freedom
	Multiple R-squared:  0.4636,	Adjusted R-squared:  0.4461 
	F-statistic: 26.51 on 6 and 184 DF,  p-value: < 2.2e-16

#### thrashing or not thrashing #############
x = rbind(pgsql) 
x$MAXMPL[x$MAXMPL < 1] <- 0
out.fit <-  glm(MAXMPL ~ PK + PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, family="binomial", data = x)
summary(out.fit)

	Call:
	glm(formula = MAXMPL ~ PK + PCTREAD + PCTUPDATE + ACTROWPOOL + 
	    ATP + NUMPROCESSORS, family = "binomial", data = x)

	Deviance Residuals: 
	    Min       1Q   Median       3Q      Max  
	-1.9543  -0.5774  -0.2119   0.6319   3.2110  

	Coefficients:
		      Estimate Std. Error z value Pr(>|z|)    
	(Intercept)    -0.9521     0.6795  -1.401   0.1611    
	PK              3.8649     0.5782   6.684 2.33e-11 ***
	PCTREAD        -1.0990     0.6284  -1.749   0.0803 .  
	PCTUPDATE      -1.5040     0.7570  -1.987   0.0469 *  
	ACTROWPOOL     -0.5506     0.5352  -1.029   0.3036    
	ATP             2.7063     1.0921   2.478   0.0132 *  
	NUMPROCESSORS  -2.6936     0.6072  -4.436 9.17e-06 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	(Dispersion parameter for binomial family taken to be 1)

	    Null deviance: 255.91  on 190  degrees of freedom
	Residual deviance: 154.33  on 184  degrees of freedom
	AIC: 168.33

	Number of Fisher Scoring iterations: 5

> 1-out.fit$deviance/out.fit$null.deviance
[1] 0.3969248

> confint(out.fit)
Waiting for profiling to be done...
                   2.5 %      97.5 %
(Intercept)   -2.3408043  0.34701518
PK             2.8174770  5.10488788
PCTREAD       -2.3640237  0.11780805
PCTUPDATE     -3.0460506 -0.05632545
ACTROWPOOL    -1.6195644  0.49150525
ATP            0.6426814  4.96221141
NUMPROCESSORS -3.9617741 -1.56642999








y <- subset(x, x$MAXMPL < 1)

cor(y$NUMPROCESSORS, y$MAXMPL)
0.15

cor(y$ACTROWPOOL, y$MAXMPL)
-0.09

cor(y$PCTREAD, y$MAXMPL)
-0.05

cor(y$PCTUPDATE, y$MAXMPL)
-0.10

cor(y$ATP, y$MAXMPL)
-0.08

cor(y$PK, y$MAXMPL)
0.37

pdf("pgsql_scaled_var_rel_on_thrashing.pdf")
par(mfrow=c(3,2), oma=c(0, 0, 2, 0))
plot(y$NUMPROCESSORS, y$MAXMPL, main='# of Processors vs. Max MPL (c.e.: 0.15)', xlim=c(0, 1), ylim=c(0, 1), xlab='Number of Processors', ylab='Max MPL')
plot(y$ACTROWPOOL, y$MAXMPL, main='Active Row Pool vs. Max MPL (c.e.: -0.09)', xlim=c(0, 1), ylim=c(0, 1), xlab='Active Row Pool', ylab='Max MPL')
plot(y$PCTREAD, y$MAXMPL, main='PRS vs. Max MPL (c.e.:  -0.05)', xlim=c(0, 1), ylim=c(0, 1), xlab='Percentage of Rows from SELECT (PRS)', ylab='Max MPL')
plot(y$PCTUPDATE, y$MAXMPL, main='PRU vs. Max MPL (c.e.: -0.10)', xlim=c(0, 1), ylim=c(0, 1), xlab='Percentage of Rows from UPDATE (PRU)', ylab='Max MPL')
plot(y$ATP, y$MAXMPL, main='ATP time vs. Max MPL (c.e.: -0.08)', xlim=c(0, 1), ylim=c(0, 1), xlab='Average Transaction Processing Time (ATP time)', ylab='Max MPL')
plot(y$PK, y$MAXMPL, main='Presence of PK vs. Max MPL (c.e.: 0.38)', xlim=c(0, 1), ylim=c(0, 1), xlab='Presence of Primary Key (PK)', ylab='Max MPL')
title(adj=0.5, main = "PostgreSQL - Variables' Relationship (on per-DBMS scaled thrashing data)", outer=TRUE)
#text(0.25, 0.5, "Variables' Relationship (on feature-scaled data)")
dev.off()

> nrow(x)
[1] 122

med.fit <- lm(ATP ~ NUMPROCESSORS + PCTUPDATE  + PK + PK:PCTUPDATE, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PCTUPDATE + PK + PK:PCTUPDATE, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.31115 -0.12407 -0.01243  0.10325  0.58091 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.46035    0.02756  16.705  < 2e-16 ***
	NUMPROCESSORS -0.03388    0.03326  -1.019     0.31    
	PCTUPDATE     -0.59306    0.04685 -12.660  < 2e-16 ***
	PK            -0.28410    0.03712  -7.653 1.03e-12 ***
	PCTUPDATE:PK   0.37563    0.07117   5.278 3.62e-07 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1821 on 186 degrees of freedom
	Multiple R-squared:  0.533,	Adjusted R-squared:  0.523 
	F-statistic: 53.08 on 4 and 186 DF,  p-value: < 2.2e-16

out.fit <- lm(MAXMPL ~ NUMPROCESSORS + ATP + PCTREAD + PCTUPDATE + ACTROWPOOL + PK, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ NUMPROCESSORS + ATP + PCTREAD + PCTUPDATE + 
	    ACTROWPOOL + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.70372 -0.23728  0.03227  0.20004  0.96966 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.47836    0.07198   6.646 3.32e-10 ***
	NUMPROCESSORS -0.23064    0.05766  -4.000 9.16e-05 ***
	ATP            0.27388    0.12254   2.235  0.02662 *  
	PCTREAD       -0.17912    0.07648  -2.342  0.02025 *  
	PCTUPDATE     -0.21741    0.08110  -2.681  0.00801 ** 
	ACTROWPOOL    -0.09055    0.05976  -1.515  0.13143    
	PK             0.54148    0.04939  10.962  < 2e-16 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3145 on 184 degrees of freedom
	Multiple R-squared:  0.4636,	Adjusted R-squared:  0.4461 
	F-statistic: 26.51 on 6 and 184 DF,  p-value: < 2.2e-16

----

x = read.csv(file="expl.dat",head=TRUE,sep="\t")
pgsql <- subset(x, x$DBMS=='pgsql')
pgsql$ATP = (pgsql$ATP-min(pgsql$ATP))/(max(pgsql$ATP)-min(pgsql$ATP))
pgsql$ATP[pgsql$ATP > 0.8 & pgsql$ATP <= 1] <- 5
pgsql$ATP[pgsql$ATP > 0.6 & pgsql$ATP <= 0.8] <- 4
pgsql$ATP[pgsql$ATP > 0.4 & pgsql$ATP <= 0.6] <- 3
pgsql$ATP[pgsql$ATP > 0.2 & pgsql$ATP <= 0.4] <- 2
pgsql$ATP[pgsql$ATP <= 0.2 ] <- 1
pgsql$ATP = (pgsql$ATP-min(pgsql$ATP))/(max(pgsql$ATP)-min(pgsql$ATP))
pgsql$MAXMPL = (pgsql$MAXMPL-min(pgsql$MAXMPL))/(max(pgsql$MAXMPL)-min(pgsql$MAXMPL))
pgsql$MAXMPL[pgsql$MAXMPL == 1] <- 5
pgsql$MAXMPL[pgsql$MAXMPL > 0.75 & pgsql$MAXMPL <= 1] <- 4
pgsql$MAXMPL[pgsql$MAXMPL > 0.5 & pgsql$MAXMPL <= 0.75] <- 3
pgsql$MAXMPL[pgsql$MAXMPL > 0.25 & pgsql$MAXMPL <= 0.50] <- 2
pgsql$MAXMPL[pgsql$MAXMPL<=0.25] <- 1
pgsql$MAXMPL = (pgsql$MAXMPL-min(pgsql$MAXMPL))/(max(pgsql$MAXMPL)-min(pgsql$MAXMPL))
pgsql$ACTROWPOOL = (pgsql$ACTROWPOOL-min(pgsql$ACTROWPOOL))/(max(pgsql$ACTROWPOOL)-min(pgsql$ACTROWPOOL))
pgsql$PCTREAD = (pgsql$PCTREAD-min(pgsql$PCTREAD))/(max(pgsql$PCTREAD)-min(pgsql$PCTREAD))
pgsql$PCTUPDATE = (pgsql$PCTUPDATE-min(pgsql$PCTUPDATE))/(max(pgsql$PCTUPDATE)-min(pgsql$PCTUPDATE))
pgsql$NUMPROCESSORS = (pgsql$NUMPROCESSORS-min(pgsql$NUMPROCESSORS))/(max(pgsql$NUMPROCESSORS)-min(pgsql$NUMPROCESSORS))
x = rbind(pgsql) 

med.fit <- lm(ATP ~ NUMPROCESSORS + PCTUPDATE  + PK + PK:PCTUPDATE, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PCTUPDATE + PK + PK:PCTUPDATE, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.31180 -0.14269 -0.01694  0.09385  0.60009 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.45490    0.02880  15.794  < 2e-16 ***
	NUMPROCESSORS -0.06069    0.03476  -1.746   0.0824 .  
	PCTUPDATE     -0.57238    0.04896 -11.691  < 2e-16 ***
	PK            -0.29632    0.03880  -7.637 1.13e-12 ***
	PCTUPDATE:PK   0.39260    0.07438   5.278 3.62e-07 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1904 on 186 degrees of freedom
	Multiple R-squared:  0.4974,	Adjusted R-squared:  0.4866 
	F-statistic: 46.03 on 4 and 186 DF,  p-value: < 2.2e-16

----

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PCTUPDATE + PK + PK:PCTUPDATE, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.31115 -0.12407 -0.01243  0.10325  0.58091 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.46035    0.02756  16.705  < 2e-16 ***
	NUMPROCESSORS -0.03388    0.03326  -1.019     0.31    
	PCTUPDATE     -0.59306    0.04685 -12.660  < 2e-16 ***
	PK            -0.28410    0.03712  -7.653 1.03e-12 ***
	PCTUPDATE:PK   0.37563    0.07117   5.278 3.62e-07 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1821 on 186 degrees of freedom
	Multiple R-squared:  0.533,	Adjusted R-squared:  0.523 
	F-statistic: 53.08 on 4 and 186 DF,  p-value: < 2.2e-16

out.fit <- lm(MAXMPL ~ NUMPROCESSORS + ATP + PCTREAD + PCTUPDATE + ACTROWPOOL + PK, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ NUMPROCESSORS + ATP + PCTREAD + PCTUPDATE + 
	    ACTROWPOOL + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.80463 -0.26604  0.02151  0.23934  0.90121 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.42094    0.07285   5.778 3.17e-08 ***
	NUMPROCESSORS -0.26108    0.06022  -4.336 2.39e-05 ***
	ATP            0.17516    0.12149   1.442 0.151058    
	PCTREAD       -0.13035    0.07924  -1.645 0.101672    
	PCTUPDATE     -0.28153    0.08128  -3.463 0.000663 ***
	ACTROWPOOL    -0.07370    0.06207  -1.187 0.236573    
	PK             0.57059    0.05125  11.133  < 2e-16 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3267 on 184 degrees of freedom
	Multiple R-squared:  0.4811,	Adjusted R-squared:  0.4641 
	F-statistic: 28.43 on 6 and 184 DF,  p-value: < 2.2e-16

----

	Call:
	lm(formula = MAXMPL ~ NUMPROCESSORS + ATP + PCTREAD + PCTUPDATE + 
	    ACTROWPOOL + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.66634 -0.22952  0.03932  0.20326  0.83721 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.42892    0.06916   6.202 3.60e-09 ***
	NUMPROCESSORS -0.22381    0.05540  -4.040 7.85e-05 ***
	ATP            0.27179    0.11775   2.308  0.02210 *  
	PCTREAD       -0.16262    0.07349  -2.213  0.02814 *  
	PCTUPDATE     -0.22990    0.07792  -2.950  0.00359 ** 
	ACTROWPOOL    -0.06185    0.05742  -1.077  0.28281    
	PK             0.56311    0.04746  11.865  < 2e-16 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3022 on 184 degrees of freedom
	Multiple R-squared:  0.4985,	Adjusted R-squared:  0.4822 
	F-statistic: 30.49 on 6 and 184 DF,  p-value: < 2.2e-16

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK", robustSE = TRUE)
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.04048     -0.08516     -0.00114    0.04
	ADE             0.56402      0.47539      0.65257    0.00
	Total Effect    0.52353      0.44141      0.60700    0.00
	Prop. Mediated -0.07410     -0.17898     -0.00209    0.04

	Sample Size Used: 191 


	Simulations: 1000

sens.out <- medsens(med.out, effect.type = "both")
summary(sens.out)
	
	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	     Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] 0.1 -0.0372      -0.1115       0.0372         0.01       0.0023
	[2,] 0.2  0.0045      -0.0692       0.0782         0.04       0.0094
	[3,] 0.3  0.0484      -0.0266       0.1234         0.09       0.0211

	Rho at which ACME = 0: 0.2
	R^2_M*R^2_Y* at which ACME = 0: 0.04
	R^2_M~R^2_Y~ at which ACME = 0: 0.0094 


	Mediation Sensitivity Analysis for Average Direct Effect

	Sensitivity Region

	     Rho    ADE 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] 0.9 0.1119      -0.0705       0.2942         0.81       0.1897

	Rho at which ADE = 0: 0.9
	R^2_M*R^2_Y* at which ADE = 0: 0.81
	R^2_M~R^2_Y~ at which ADE = 0: 0.1897

> sens.out$r.square.y
[1] 0.4985336
> sens.out$r.square.m
[1] 0.5330371

##################################################################################################################################
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK", robustSE = TRUE)
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.04020     -0.08961     -0.00176    0.04
	ADE             0.56298      0.48091      0.64994    0.00
	Total Effect    0.52278      0.44323      0.60729    0.00
	Prop. Mediated -0.07440     -0.17592     -0.00301    0.04

	Sample Size Used: 191 


	Simulations: 1000 

sens.out <- medsens(med.out, effect.type = "both")
summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	     Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] 0.1 -0.0372      -0.1115       0.0372         0.01       0.0023
	[2,] 0.2  0.0045      -0.0692       0.0782         0.04       0.0094
	[3,] 0.3  0.0484      -0.0266       0.1234         0.09       0.0211

	Rho at which ACME = 0: 0.2
	R^2_M*R^2_Y* at which ACME = 0: 0.04
	R^2_M~R^2_Y~ at which ACME = 0: 0.0094 


	Mediation Sensitivity Analysis for Average Direct Effect

	Sensitivity Region

	     Rho    ADE 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] 0.9 0.1119      -0.0705       0.2942         0.81       0.1897

	Rho at which ADE = 0: 0.9
	R^2_M*R^2_Y* at which ADE = 0: 0.81
	R^2_M~R^2_Y~ at which ADE = 0: 0.1897 

> sens.out$r.square.y
[1] 0.4985336
> sens.out$r.square.m
[1] 0.5330371
