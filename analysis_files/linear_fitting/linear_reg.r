# Overall: 33.4% (close to suboptimal)
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
# ATP normalization
# db2
db2 <- subset(x, x$DBMS=='db2')
db2$ATP = (db2$ATP-min(db2$ATP))/(max(db2$ATP)-min(db2$ATP))
db2$MAXMPL = (db2$MAXMPL-min(db2$MAXMPL))/(max(db2$MAXMPL)-min(db2$MAXMPL))
# oracle
oracle <- subset(x, x$DBMS=='oracle')
oracle$ATP = (oracle$ATP-min(oracle$ATP))/(max(oracle$ATP)-min(oracle$ATP))
oracle$MAXMPL = (oracle$MAXMPL-min(oracle$MAXMPL))/(max(oracle$MAXMPL)-min(oracle$MAXMPL))
# mysql
mysql <- subset(x, x$DBMS=='mysql')
mysql$ATP = (mysql$ATP-min(mysql$ATP))/(max(mysql$ATP)-min(pgsql$ATP))
mysql$MAXMPL = (mysql$MAXMPL-min(mysql$MAXMPL))/(max(mysql$MAXMPL)-min(mysql$MAXMPL))
# pgsql
pgsql <- subset(x, x$DBMS=='pgsql')
pgsql$ATP = (pgsql$ATP-min(pgsql$ATP))/(max(pgsql$ATP)-min(pgsql$ATP))
pgsql$MAXMPL = (pgsql$MAXMPL-min(pgsql$MAXMPL))/(max(pgsql$MAXMPL)-min(pgsql$MAXMPL))
# sqlserver
sqlserver <- subset(x, x$DBMS=='sqlserver')
sqlserver$ATP = (sqlserver$ATP-min(sqlserver$ATP))/(max(sqlserver$ATP)-min(sqlserver$ATP))
sqlserver$MAXMPL = (sqlserver$MAXMPL-min(sqlserver$MAXMPL))/(max(sqlserver$MAXMPL)-min(sqlserver$MAXMPL))
x = rbind(db2,oracle,mysql,pgsql,sqlserver) 
#x$ATP = (x$ATP-min(x$ATP))/(max(x$ATP)-min(x$ATP))
#x$MAXMPL = (x$MAXMPL-min(x$MAXMPL))/(max(x$MAXMPL)-min(x$MAXMPL))x$ACTROWPOOL = (x$ACTROWPOOL-min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)-min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD-min(x$PCTREAD))/(max(x$PCTREAD)-min(x$PCTREAD))
x$PCTUPDATE = (x$PCTUPDATE-min(x$PCTUPDATE))/(max(x$PCTUPDATE)-min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS-min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)-min(x$NUMPROCESSORS))

med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + PK + PCTUPDATE + PCTUPDATE:PK, data = x)
out.fit <- lm(MAXMPL ~ ATP + PK, data = x)
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK", robustSE = TRUE)
sens.out <- medsens(med.out, effect.type = "indirect")
summary(med.out)
summary(sens.out)
sens.out$r.square.y
sens.out$r.square.m

summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + PK + PCTUPDATE + 
	    PCTUPDATE:PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.34245 -0.14385 -0.08922  0.10547  0.87561 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.27469    0.02464  11.149  < 2e-16 ***
	NUMPROCESSORS -0.07707    0.02002  -3.849 0.000126 ***
	ACTROWPOOL     0.06801    0.02801   2.428 0.015350 *  
	PK            -0.18528    0.02238  -8.281 3.90e-16 ***
	PCTUPDATE     -0.20396    0.02904  -7.024 3.99e-12 ***
	PK:PCTUPDATE   0.21680    0.04208   5.152 3.11e-07 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.249 on 998 degrees of freedom
	Multiple R-squared:  0.1047,	Adjusted R-squared:  0.1002 
	F-statistic: 23.34 on 5 and 998 DF,  p-value: < 2.2e-16

> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            0.00731     -0.00068      0.01665    0.09
	ADE             0.11962      0.07084      0.16603    0.00
	Total Effect    0.12693      0.08022      0.17307    0.00
	Prop. Mediated  0.05758     -0.00540      0.14997    0.09

	Sample Size Used: 1004 


	Simulations: 1000 

summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.70863 -0.38417  0.01242  0.30287  0.48153 

	Coefficients:
		    Estimate Std. Error t value Pr(>|t|)    
	(Intercept)  0.58913    0.01935  30.444  < 2e-16 ***
	ATP         -0.07066    0.04674  -1.512    0.131    
	PK           0.11953    0.02455   4.869  1.3e-06 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3805 on 1001 degrees of freedom
	Multiple R-squared:  0.02931,	Adjusted R-squared:  0.02737 
	F-statistic: 15.11 on 2 and 1001 DF,  p-value: 3.413e-07

summary(med.out)

	Call:
	lm(formula = MAXMPL ~ ATP + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.70863 -0.38417  0.01242  0.30287  0.48153 

	Coefficients:
		    Estimate Std. Error t value Pr(>|t|)    
	(Intercept)  0.58913    0.01935  30.444  < 2e-16 ***
	ATP         -0.07066    0.04674  -1.512    0.131    
	PK           0.11953    0.02455   4.869  1.3e-06 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3805 on 1001 degrees of freedom
	Multiple R-squared:  0.02931,	Adjusted R-squared:  0.02737 
	F-statistic: 15.11 on 2 and 1001 DF,  p-value: 3.413e-07

summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.1 -0.0130      -0.0282       0.0022         0.01       0.0087
	[2,]  0.0  0.0131      -0.0025       0.0287         0.00       0.0000

	Rho at which ACME = 0: -0.1
	R^2_M*R^2_Y* at which ACME = 0: 0.01
	R^2_M~R^2_Y~ at which ACME = 0: 0.0087


sens.out$r.square.y
[1] 0.02931289
sens.out$r.square.m
[1] 0.1047084

-----------

med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + PK + PCTUPDATE + PCTUPDATE:PK, data = x)
out.fit <- lm(MAXMPL ~ ATP + NUMPROCESSORS, data = x)
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS", robustSE = TRUE)
sens.out <- medsens(med.out, effect.type = "indirect")
summary(med.out)

summary(sens.out)

Mediation Sensitivity Analysis for Average Causal Mediation Effect

Sensitivity Region

      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
[1,] -0.1 -0.0015      -0.0083       0.0053         0.01       0.0089

Rho at which ACME = 0: -0.1
R^2_M*R^2_Y* at which ACME = 0: 0.01
R^2_M~R^2_Y~ at which ACME = 0: 0.0089 

$r.square.y
[1] 0.007462195

$r.square.m
[1] 0.1047084

med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + PK + PCTUPDATE + PCTUPDATE*PK, data = x)
out.fit <- lm(MAXMPL ~ ATP + PCTUPDATE + PCTREAD, data = x)
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE")
sens.out <- medsens(med.out, effect.type = "indirect")
summary(med.out)
summary(sens.out)
sens.out$r.square.y
sens.out$r.square.m

> summary(med.out)

Causal Mediation Analysis 

Quasi-Bayesian Confidence Intervals

               Estimate 95% CI Lower 95% CI Upper p-value
ACME            0.01127      0.00151      0.02322    0.02
ADE            -0.01749     -0.08993      0.05154    0.63
Total Effect   -0.00622     -0.07912      0.06640    0.85
Prop. Mediated -0.15368     -4.11836      4.83929    0.85

Sample Size Used: 1004 


Simulations: 1000 

> summary(sens.out)

Mediation Sensitivity Analysis for Average Causal Mediation Effect

Sensitivity Region

      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
[1,] -0.1 -0.0058      -0.0237       0.0121         0.01       0.0089

Rho at which ACME = 0: -0.1
R^2_M*R^2_Y* at which ACME = 0: 0.01
R^2_M~R^2_Y~ at which ACME = 0: 0.0089 

> sens.out$r.square.y
[1] 0.009368421
> sens.out$r.square.m
[1] 0.1047084


--------

med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + PK + PCTREAD + PCTREAD:PK + PCTUPDATE + PCTUPDATE:PK, data = x)
med.reduced <- step(med.fit, direction="backward")
summary(med.reduced)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + PK + PCTUPDATE + PK:PCTUPDATE, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.34245 -0.14385 -0.08922  0.10547  0.87561 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.27469    0.02464  11.149  < 2e-16 ***
	NUMPROCESSORS -0.07707    0.02002  -3.849 0.000126 ***
	ACTROWPOOL     0.06801    0.02801   2.428 0.015350 *  
	PK            -0.18528    0.02238  -8.281 3.90e-16 ***
	PCTUPDATE     -0.20396    0.02904  -7.024 3.99e-12 ***
	PK:PCTUPDATE   0.21680    0.04208   5.152 3.11e-07 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.249 on 998 degrees of freedom
	Multiple R-squared:  0.1047,	Adjusted R-squared:  0.1002 
	F-statistic: 23.34 on 5 and 998 DF,  p-value: < 2.2e-16

med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + PK + PCTUPDATE + PK:PCTUPDATE, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + PK + PCTUPDATE + 
	    PK:PCTUPDATE, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.34245 -0.14385 -0.08922  0.10547  0.87561 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.27469    0.02464  11.149  < 2e-16 ***
	NUMPROCESSORS -0.07707    0.02002  -3.849 0.000126 ***
	ACTROWPOOL     0.06801    0.02801   2.428 0.015350 *  
	PK            -0.18528    0.02238  -8.281 3.90e-16 ***
	PCTUPDATE     -0.20396    0.02904  -7.024 3.99e-12 ***
	PK:PCTUPDATE   0.21680    0.04208   5.152 3.11e-07 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.249 on 998 degrees of freedom
	Multiple R-squared:  0.1047,	Adjusted R-squared:  0.1002 
	F-statistic: 23.34 on 5 and 998 DF,  p-value: < 2.2e-16

out.fit <- lm(MAXMPL ~ ATP + NUMPROCESSORS + ACTROWPOOL + PK + PCTUPDATE + , data = x)






min.model <- lm(MAXMPL ~ 1, data = x)
fwd.model <- step(min.model, direction="forward", scope=( ~ ATP + NUMPROCESSORS + ACTROWPOOL + PCTUPDATE + PK + PCTREAD), data = x)


datasets <- list(T1 = x)
mediators <- c("ATP")
outcome <- c("MAXMPL")
treatment <- c("NUMPROCESSORS")
covariates <- c("ACTROWPOOL + PK + PCTUPDATE + PCTREAD")
med.out <- mediations(datasets, treatment, mediators, outcome, covariates, families=c("gaussian", "gaussian"), interaction=TRUE)
summary(med.out)
plot(med.out)

library(mediation)
med.fit <- lm(ATP ~ NUMPROCESSORS + PK + PCTUPDATE + PK:PCTUPDATE, data = x)
out.fit <- lm(MAXMPL ~ ATP + NUMPROCESSORS + ACTROWPOOL + PK + PCTUPDATE + , data = x)

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
summary(med.out)

Causal Mediation Analysis 

Quasi-Bayesian Confidence Intervals

               Estimate 95% CI Lower 95% CI Upper p-value
ACME            0.00924      0.00176      0.01890    0.01
ADE            -0.03247     -0.09276      0.02535    0.29
Total Effect   -0.02322     -0.08370      0.03340    0.46
Prop. Mediated -0.19712     -3.63369      3.54960    0.47

Sample Size Used: 1004 


Simulations: 1000

sens.cont <- medsens(med.out, effect.type="both")

Mediation Sensitivity Analysis for Average Causal Mediation Effect

Sensitivity Region

      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
[1,] -0.1 -0.0015      -0.0086       0.0056         0.01       0.0089

Rho at which ACME = 0: -0.1
R^2_M*R^2_Y* at which ACME = 0: 0.01
R^2_M~R^2_Y~ at which ACME = 0: 0.0089 

Mediation Sensitivity Analysis for Average Direct Effect

Sensitivity Region

       Rho     ADE 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
 [1,] -0.7  0.0845      -0.0004       0.1693         0.49       0.4354
 [2,] -0.6  0.0564      -0.0194       0.1321         0.36       0.3199
 [3,] -0.5  0.0353      -0.0347       0.1053         0.25       0.2222
 [4,] -0.4  0.0182      -0.0480       0.0845         0.16       0.1422
 [5,] -0.3  0.0036      -0.0602       0.0673         0.09       0.0800
 [6,] -0.2 -0.0096      -0.0717       0.0526         0.04       0.0355
 [7,] -0.1 -0.0217      -0.0830       0.0395         0.01       0.0089
 [8,]  0.0 -0.0334      -0.0944       0.0276         0.00       0.0000
 [9,]  0.1 -0.0449      -0.1062       0.0163         0.01       0.0089
[10,]  0.2 -0.0567      -0.1188       0.0054         0.04       0.0355

Rho at which ADE = 0: -0.3
R^2_M*R^2_Y* at which ADE = 0: 0.09
R^2_M~R^2_Y~ at which ADE = 0: 0.08

$r.square.y
[1] 0.007462195

$r.square.m
[1] 0.1047084

library(mediation)
med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + PK + PCTUPDATE + PK:PCTUPDATE, data = x)
out.fit <- lm(MAXMPL ~ ATP + PCTUPDATE, data = x)

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE")
summary(med.out)
sens.cont <- medsens(med.out, effect.type="both")

res <- multimed("MAXMPL", "ATP", data = x, treat = "PCTUPDATE", design = "single")

out.fit <- lm(MAXMPL ~ ATP + PCTUPDATE, data = x)

