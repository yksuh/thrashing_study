# Overall: 33.4% (close to suboptimal)
library(aod)
library(ggplot2)
x = read.csv(file="cnfm.dat",head=TRUE,sep="\t")
#x = read.csv(file="raw_cnfm.dat",head=TRUE,sep="\t")
x <- subset(x, x$ATP < 120000)
x <- subset(x, x$MAXMPL < 1100)
# ATP normalization
# pgsql
pgsql <- subset(x, x$DBMS=='pgsql')
pgsql_r <- subset(pgsql, pgsql$PCTREAD!=0)
pgsql_r <- subset(pgsql_r, select = -PCTUPDATE)
pgsql_r$ATP = (pgsql_r$ATP-min(pgsql_r$ATP))/(max(pgsql_r$ATP)-min(pgsql_r$ATP))
pgsql_r$MAXMPL = (pgsql_r$MAXMPL-min(pgsql_r$MAXMPL))/(max(pgsql_r$MAXMPL)-min(pgsql_r$MAXMPL))
pgsql <- pgsql_r
#### gother each DBMS' samples
x = rbind(pgsql)
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD/min(x$PCTREAD))/(max(x$PCTREAD)/min(x$PCTREAD))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))

nrow(x)
108
x <- subset(x, x$MAXMPL < 1)
nrow(x)
1

med.fit <- lm(ATP ~ NUMPROCESSORS + PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.77966 -0.09420  0.00074  0.12166  0.32536 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.977759   0.035189  27.786   <2e-16 ***
	NUMPROCESSORS -0.078144   0.006017 -12.988   <2e-16 ***
	PK            -0.037015   0.029833  -1.241    0.217    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1548 on 105 degrees of freedom
	Multiple R-squared:  0.617,	Adjusted R-squared:  0.6097 
	F-statistic: 84.59 on 2 and 105 DF,  p-value: < 2.2e-16

#library(MASS)
#step <- stepAIC(out.fit, direction="both")

out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.93049 -0.00118  0.00798  0.01958  0.12840 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.855534   0.062152  13.765   <2e-16 ***
	PK            -0.012276   0.018365  -0.668   0.5053    
	ATP            0.130357   0.059640   2.186   0.0311 *  
	NUMPROCESSORS  0.013856   0.005936   2.334   0.0215 * 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.09459 on 104 degrees of freedom
	Multiple R-squared:  0.06082,	Adjusted R-squared:  0.03373 
	F-statistic: 2.245 on 3 and 104 DF,  p-value: 0.08746

	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	       Min         1Q     Median         3Q        Max 
	-0.0077208 -0.0044928  0.0007008  0.0041208  0.0102266 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)  
	(Intercept)    0.167953   0.078920   2.128   0.0774 .
	PK            -0.001799   0.005421  -0.332   0.7513  
	ATP           -0.071459   0.064561  -1.107   0.3108  
	NUMPROCESSORS -0.534549   0.216065  -2.474   0.0482 *
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.007153 on 6 degrees of freedom
	Multiple R-squared:  0.8398,	Adjusted R-squared:  0.7597 
	F-statistic: 10.48 on 3 and 6 DF,  p-value: 0.008438

###### logistic ####
x = rbind(pgsql)
x$MAXMPL[x$MAXMPL == 1] <- 2
x$MAXMPL[x$MAXMPL < 1] <- 1 ### thrashing
x$MAXMPL[x$MAXMPL == 2] <- 0### no thrashing
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
library(aod)
library(ggplot2)
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
summary(out.fit)
wald.test(b = coef(out.fit), Sigma = vcov(out.fit), Terms = 2:4)
Wald test:
----------

Chi-squared test:
X2 = 6.7, df = 3, P(> X2) = 0.081

> 1-out.fit$deviance/out.fit$null.deviance
[1] 0.06081725

### update-only
library(aod)
library(ggplot2)
x = read.csv(file="cnfm.dat",head=TRUE,sep="\t")
x <- subset(x, x$ATP < 120000)
x <- subset(x, x$MAXMPL < 1100)
# ATP normalization
# pgsql
pgsql <- subset(x, x$DBMS=='pgsql')
pgsql_w <- subset(pgsql, pgsql$PCTUPDATE!=0)
pgsql_w <- subset(pgsql_w, select = -PCTREAD)
pgsql_w$ATP = (pgsql_w$ATP-min(pgsql_w$ATP))/(max(pgsql_w$ATP)-min(pgsql_w$ATP))
pgsql_w$MAXMPL = (pgsql_w$MAXMPL-min(pgsql_w$MAXMPL))/(max(pgsql_w$MAXMPL)-min(pgsql_w$MAXMPL))
pgsql <- pgsql_w
x = rbind(pgsql)
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTUPDATE = (x$PCTUPDATE/min(x$PCTUPDATE))/(max(x$PCTUPDATE)/min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
nrow(x)
#[1] 160
x <- subset(x, x$MAXMPL < 1)
nrow(x)
#[1] 139

med.fit <- lm(ATP ~ NUMPROCESSORS, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.71051 -0.05032  0.03663  0.15043  0.34669 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.76771    0.04268  17.986   <2e-16 ***
	NUMPROCESSORS -0.11440    0.06633  -1.725    0.087 .  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2443 on 129 degrees of freedom
	Multiple R-squared:  0.02254,	Adjusted R-squared:  0.01496 
	F-statistic: 2.974 on 1 and 129 DF,  p-value: 0.08698

out.fit <- lm(MAXMPL ~ ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.44510 -0.16737 -0.01529  0.14605  0.57053 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.39246    0.07117   5.514 1.86e-07 ***
	ATP            0.11758    0.07839   1.500    0.136    
	NUMPROCESSORS -0.32834    0.05973  -5.497 2.01e-07 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2175 on 128 degrees of freedom
	Multiple R-squared:  0.2183,	Adjusted R-squared:  0.2061 
	F-statistic: 17.87 on 2 and 128 DF,  p-value: 1.425e-07

