# sqlserver
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
sqlserver <- subset(x, x$DBMS=='sqlserver')
sqlserver$ATP = (sqlserver$ATP-min(sqlserver$ATP))/(max(sqlserver$ATP)-min(sqlserver$ATP))
sqlserver$MAXMPL = (sqlserver$MAXMPL-min(sqlserver$MAXMPL))/(max(sqlserver$MAXMPL)-min(sqlserver$MAXMPL))
sqlserver$ACTROWPOOL = (sqlserver$ACTROWPOOL-min(sqlserver$ACTROWPOOL))/(max(sqlserver$ACTROWPOOL)-min(sqlserver$ACTROWPOOL))
sqlserver$PCTREAD = (sqlserver$PCTREAD-min(sqlserver$PCTREAD))/(max(sqlserver$PCTREAD)-min(sqlserver$PCTREAD))
sqlserver$PCTUPDATE = (sqlserver$PCTUPDATE-min(sqlserver$PCTUPDATE))/(max(sqlserver$PCTUPDATE)-min(sqlserver$PCTUPDATE))
sqlserver$NUMPROCESSORS = (sqlserver$NUMPROCESSORS-min(sqlserver$NUMPROCESSORS))/(max(sqlserver$NUMPROCESSORS)-min(sqlserver$NUMPROCESSORS))
x = rbind(sqlserver) 
x <- subset(x, x$MAXMPL < 1)
cor(x$ATP, x$MAXMPL)
0.0780273
cor(x$NUMPROCESSORS, x$MAXMPL)
0.3394955
cor(x$ACTROWPOOL, x$MAXMPL)
-0.03382419
cor(x$PCTREAD, x$MAXMPL)
-0.1351801
cor(x$PCTUPDATE, x$MAXMPL)
0.2519522

re <- subset(x, x$PCTREAD!=0)
re <- subset(re, select = -PCTUPDATE)
cor(re$NUMPROCESSORS, re$MAXMPL)
-0.4344381

cor(re$ATP, re$MAXMPL)
0.9358192
cor(re$ACTROWPOOL, re$MAXMPL)
-0.01805696
cor(re$PCTREAD, re$MAXMPL)
0.1538361
cor(re$PCTREAD, re$ATP)
0.2026989

up <- subset(x, x$PCTUPDATE!=0)
up <- subset(up, select = -PCTREAD)
cor(up$NUMPROCESSORS, up$MAXMPL)
0.4628616
cor(up$ACTROWPOOL, up$MAXMPL)
-0.05995041
cor(up$ATP, up$MAXMPL)
-0.1283564
cor(up$PCTUPDATE, up$MAXMPL)
-0.1050089
cor(up$NUMPROCESSORS, up$ATP)
-0.5895696
cor(up$PK, up$ATP)
0.007317581
cor(up$ACTROWPOOL, up$ATP)
0.02088331
cor(up$PCTUPDATE, up$ATP)
-0.02026292


#############################################
med.fit <- lm(ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK + PCTUPDATE + PCTUPDATE:PK, data = x)
summary(med.fit)

Call:
lm(formula = ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK + 
    PCTUPDATE + PCTUPDATE:PK, data = x)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.36521 -0.20784  0.00249  0.12130  0.60913 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept)    0.29653    0.04577   6.479 6.52e-10 ***
NUMPROCESSORS -0.45073    0.04629  -9.738  < 2e-16 ***
PK             0.02285    0.06072   0.376   0.7071    
PCTREAD       -0.03120    0.08003  -0.390   0.6971    
PCTUPDATE      0.13508    0.07375   1.832   0.0684 .  
PK:PCTREAD     0.05097    0.12019   0.424   0.6719    
PK:PCTUPDATE  -0.02437    0.10564  -0.231   0.8178    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.2628 on 209 degrees of freedom
Multiple R-squared:  0.3314,	Adjusted R-squared:  0.3122 
F-statistic: 17.27 on 6 and 209 DF,  p-value: 3.443e-16

out.fit <- lm(MAXMPL ~ PK + PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + PCTREAD + PCTUPDATE + ACTROWPOOL + 
	    ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.67411 -0.06342  0.01581  0.10419  0.51075 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.458880   0.040980  11.198  < 2e-16 ***
	PK            -0.015881   0.029188  -0.544 0.586966    
	PCTREAD        0.075876   0.048558   1.563 0.119660    
	PCTUPDATE     -0.167790   0.043513  -3.856 0.000153 ***
	ACTROWPOOL     0.003692   0.039041   0.095 0.924756    
	ATP            0.183561   0.056229   3.265 0.001281 ** 
	NUMPROCESSORS  0.520837   0.045340  11.487  < 2e-16 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2138 on 209 degrees of freedom
	Multiple R-squared:  0.4517,	Adjusted R-squared:  0.4359 
	F-statistic: 28.69 on 6 and 209 DF,  p-value: < 2.2e-16

#### thrashing or not thrashing #############
x = rbind(sqlserver) 
x$MAXMPL[x$MAXMPL < 1] <- 0
out.fit <-  glm(MAXMPL ~ PK + PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, family="binomial", data = x)
summary(out.fit)

	Call:
	glm(formula = MAXMPL ~ PK + PCTREAD + PCTUPDATE + ACTROWPOOL + 
	    ATP + NUMPROCESSORS, family = "binomial", data = x)

	Deviance Residuals: 
	     Min        1Q    Median        3Q       Max  
	-2.90344  -0.31070  -0.05788   0.17127   2.54083  

	Coefficients:
		      Estimate Std. Error z value Pr(>|z|)    
	(Intercept)    -2.3492     0.7074  -3.321 0.000897 ***
	PK              0.1411     0.5172   0.273 0.785049    
	PCTREAD         1.2969     0.8016   1.618 0.105693    
	PCTUPDATE      -6.7250     1.3098  -5.134 2.83e-07 ***
	ACTROWPOOL      0.4510     0.6811   0.662 0.507878    
	ATP            -6.3379     4.0524  -1.564 0.117822    
	NUMPROCESSORS   5.9858     1.1409   5.246 1.55e-07 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	(Dispersion parameter for binomial family taken to be 1)

	    Null deviance: 262.52  on 215  degrees of freedom
	Residual deviance: 100.94  on 209  degrees of freedom
	AIC: 114.94

	Number of Fisher Scoring iterations: 8

1-out.fit$deviance/out.fit$null.deviance
[1] 0.6154995

> confint(out.fit)
Waiting for profiling to be done...
                    2.5 %     97.5 %
(Intercept)    -3.8378490 -1.0376258
PK             -0.8784265  1.1687153
PCTREAD        -0.1999550  3.0034778
PCTUPDATE      -9.6389550 -4.4515596
ACTROWPOOL     -0.8791967  1.8159571
ATP           -18.2528582 -0.0440968
NUMPROCESSORS   3.9960826  8.5139364


#####

















y <- subset(x, x$MAXMPL < 1)

cor(y$NUMPROCESSORS, y$MAXMPL)
0.34

cor(y$ACTROWPOOL, y$MAXMPL)
-0.03

cor(y$PCTREAD, y$MAXMPL)
-0.14

cor(y$PCTUPDATE, y$MAXMPL)
0.25

cor(y$ATP, y$MAXMPL)
0.08

cor(y$PK, y$MAXMPL)
-0.04

pdf("sqlserver_scaled_var_rel_on_thrashing.pdf")
par(mfrow=c(3,2), oma=c(0, 0, 2, 0))
plot(y$NUMPROCESSORS, y$MAXMPL, main='# of Processors vs. Max MPL (c.e.: 0.34)', xlim=c(0, 1), ylim=c(0, 1), xlab='Number of Processors', ylab='Max MPL')
plot(y$ACTROWPOOL, y$MAXMPL, main='Active Row Pool vs. Max MPL (c.e.: -0.03)', xlim=c(0, 1), ylim=c(0, 1), xlab='Active Row Pool', ylab='Max MPL')
plot(y$PCTREAD, y$MAXMPL, main='PRS vs. Max MPL (c.e.:  -0.14)', xlim=c(0, 1), ylim=c(0, 1), xlab='Percentage of Rows from SELECT (PRS)', ylab='Max MPL')
plot(y$PCTUPDATE, y$MAXMPL, main='PRU vs. Max MPL (c.e.: 0.25)', xlim=c(0, 1), ylim=c(0, 1), xlab='Percentage of Rows from UPDATE (PRU)', ylab='Max MPL')
plot(y$ATP, y$MAXMPL, main='ATP time vs. Max MPL (c.e.: 0.08)', xlim=c(0, 1), ylim=c(0, 1), xlab='Average Transaction Processing Time (ATP time)', ylab='Max MPL')
plot(y$PK, y$MAXMPL, main='Presence of PK vs. Max MPL (c.e.: -0.04)', xlim=c(0, 1), ylim=c(0, 1), xlab='Presence of Primary Key (PK)', ylab='Max MPL')
title(adj=0.5, main = "SQL Server - Variables' Relationship (on per-DBMS scaled thrashing data)", outer=TRUE)
#text(0.25, 0.5, "Variables' Relationship (on feature-scaled data)")
dev.off()


> nrow(x)
[1] 165

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
	-0.67411 -0.06342  0.01581  0.10419  0.51075 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.458880   0.040980  11.198  < 2e-16 ***
	NUMPROCESSORS  0.520837   0.045340  11.487  < 2e-16 ***
	ATP            0.183561   0.056229   3.265 0.001281 ** 
	PCTREAD        0.075876   0.048558   1.563 0.119660    
	PCTUPDATE     -0.167790   0.043513  -3.856 0.000153 ***
	ACTROWPOOL     0.003692   0.039041   0.095 0.924756    
	PK            -0.015881   0.029188  -0.544 0.586966    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2138 on 209 degrees of freedom
	Multiple R-squared:  0.4517,	Adjusted R-squared:  0.4359 
	F-statistic: 28.69 on 6 and 209 DF,  p-value: < 2.2e-16

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
