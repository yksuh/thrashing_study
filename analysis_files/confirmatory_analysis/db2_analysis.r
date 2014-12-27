# Overall: 33.4% (close to suboptimal)
library(aod)
library(ggplot2)
x = read.csv(file="cnfm.dat",head=TRUE,sep="\t")
x <- subset(x, x$ATP < 120000)
x <- subset(x, x$MAXMPL < 1100)
# ATP normalization
# db2
db2 <- subset(x, x$DBMS=='db2')
db2_r <- subset(db2, db2$PCTREAD!=0)
db2_r <- subset(db2_r, select = -PCTUPDATE)
db2_r$ATP = (db2_r$ATP-min(db2_r$ATP))/(max(db2_r$ATP)-min(db2_r$ATP))
db2_r$MAXMPL = (db2_r$MAXMPL-min(db2_r$MAXMPL))/(max(db2_r$MAXMPL)-min(db2_r$MAXMPL))
db2 <- db2_r
x = rbind(db2)
#x <- x[!is.na(x$MAXMPL),]
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD/min(x$PCTREAD))/(max(x$PCTREAD)/min(x$PCTREAD))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
nrow(x)
#[1] 105
x <- subset(x, x$MAXMPL < 1)
nrow(x)
#[1] 25

med.fit <- lm(ATP ~ NUMPROCESSORS + PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.18792 -0.08547 -0.03816  0.04773  0.79765 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)
	(Intercept)    0.06793    0.07993   0.850    0.405
	NUMPROCESSORS  0.13442    0.11834   1.136    0.268
	PK            -0.11932    0.08032  -1.486    0.152

	Residual standard error: 0.1951 on 22 degrees of freedom
	Multiple R-squared:  0.1174,	Adjusted R-squared:  0.03718 
	F-statistic: 1.463 on 2 and 22 DF,  p-value: 0.2531

out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.56576 -0.10899  0.01681  0.16788  0.40282 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)   
	(Intercept)    0.36672    0.11517   3.184  0.00446 **
	PK            -0.18646    0.11946  -1.561  0.13348   
	ATP            0.08867    0.30227   0.293  0.77214   
	NUMPROCESSORS  0.19681    0.17263   1.140  0.26712   
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2766 on 21 degrees of freedom
	Multiple R-squared:  0.1567,	Adjusted R-squared:  0.03628 
	F-statistic: 1.301 on 3 and 21 DF,  p-value: 0.3003

##### logistic by per-DBMS ####
x = rbind(db2)
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
X2 = 27.2, df = 3, P(> X2) = 5.4e-06

> 1-out.fit$deviance/out.fit$null.deviance
[1] 0.2120741

### update-only
library(aod)
library(ggplot2)
x = read.csv(file="cnfm.dat",head=TRUE,sep="\t")
x <- subset(x, x$ATP < 120000)
x <- subset(x, x$MAXMPL < 1100)
# ATP normalization
# db2
db2 <- subset(x, x$DBMS=='db2')
db2_w <- subset(db2, db2$PCTUPDATE!=0)
db2_w <- subset(db2_w, select = -PCTREAD)
db2_w$ATP = (db2_w$ATP-min(db2_w$ATP))/(max(db2_w$ATP)-min(db2_w$ATP))
db2_w$MAXMPL = (db2_w$MAXMPL-min(db2_w$MAXMPL))/(max(db2_w$MAXMPL)-min(db2_w$MAXMPL))
db2 <- db2_w
x = rbind(db2)
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTUPDATE = (x$PCTUPDATE/min(x$PCTUPDATE))/(max(x$PCTUPDATE)/min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
nrow(x)
[1] 128
#x <- subset(x, x$MAXMPL < 1)
nrow(x)
[1] 4

med.fit <- lm(ATP ~ NUMPROCESSORS, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS, data = x)

	Residuals:
	     33      81     192     213 
	 0.1341 -0.1987 -0.2682  0.3328 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)
	(Intercept)    -0.5299     0.5010  -1.058    0.401
	NUMPROCESSORS   1.1971     0.6268   1.910    0.196

	Residual standard error: 0.3465 on 2 degrees of freedom
	Multiple R-squared:  0.6458,	Adjusted R-squared:  0.4688 
	F-statistic: 3.647 on 1 and 2 DF,  p-value: 0.1964


out.fit <- lm(MAXMPL ~ ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	Residuals:
	     33      81     192     213 
	-0.1662 -0.3137  0.3324  0.1475 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)
	(Intercept)     1.8250     0.9177   1.989    0.297
	ATP             1.0136     1.0372   0.977    0.507
	NUMPROCESSORS  -1.9862     1.5451  -1.286    0.421

	Residual standard error: 0.5083 on 1 degrees of freedom
	Multiple R-squared:  0.6242,	Adjusted R-squared:  -0.1273 
	F-statistic: 0.8307 on 2 and 1 DF,  p-value: 0.613
