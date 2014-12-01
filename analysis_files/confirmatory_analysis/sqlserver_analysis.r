# Overall: 33.4% (close to suboptimal)
library(aod)
library(ggplot2)
#x = read.csv(file="cnfm.dat",head=TRUE,sep="\t")
x = read.csv(file="revised_cnfm.dat",head=TRUE,sep="\t")
#x$MAXMPL[x$MAXMPL == 1100] <- 10000
# ATP normalization
# sqlserver
sqlserver <- subset(x, x$DBMS=='sqlserver')
sqlserver_r <- subset(sqlserver, sqlserver$PCTREAD!=0)
sqlserver_r <- subset(sqlserver_r, select = -PCTUPDATE)
sqlserver_r$ATP = (sqlserver_r$ATP-min(sqlserver_r$ATP))/(max(sqlserver_r$ATP)-min(sqlserver_r$ATP))
sqlserver_r$MAXMPL = (sqlserver_r$MAXMPL-min(sqlserver_r$MAXMPL))/(max(sqlserver_r$MAXMPL)-min(sqlserver_r$MAXMPL))
sqlserver <- sqlserver_r
#### gother each DBMS' samples
x = rbind(sqlserver)
#x <- x[!is.na(x$MAXMPL),]
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD/min(x$PCTREAD))/(max(x$PCTREAD)/min(x$PCTREAD))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
nrow(x)
[1] 120
x <- subset(x, x$MAXMPL < 1)
nrow(x)
12

med.fit <- lm(ATP ~ NUMPROCESSORS + PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.34119 -0.20854 -0.01934  0.15858  0.56843 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.41151    0.04849   8.487 7.62e-14 ***
	NUMPROCESSORS -0.58252    0.06994  -8.329 1.76e-13 ***
	PK             0.09287    0.04478   2.074   0.0403 *  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2453 on 117 degrees of freedom
	Multiple R-squared:  0.3864,	Adjusted R-squared:  0.3759 
	F-statistic: 36.84 on 2 and 117 DF,  p-value: 3.904e-13

out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.60273 -0.10586  0.03822  0.17831  0.31157 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.70767    0.06260  11.305  < 2e-16 ***
	PK             0.22540    0.04632   4.867 3.61e-06 ***
	ATP           -0.27351    0.09391  -2.913   0.0043 ** 
	NUMPROCESSORS  0.23092    0.08966   2.576   0.0113 *  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2491 on 116 degrees of freedom
	Multiple R-squared:  0.3333,	Adjusted R-squared:  0.3161 
	F-statistic: 19.33 on 3 and 116 DF,  p-value: 3.113e-10

##### logistic by per-DBMS ####
x = rbind(sqlserver)
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
X2 = 58.0, df = 3, P(> X2) = 1.6e-12

> 1-out.fit$deviance/out.fit$null.deviance
[1] 0.3333082

### update-only
library(aod)
library(ggplot2)
x = read.csv(file="cnfm.dat",head=TRUE,sep="\t")
x$MAXMPL[x$MAXMPL == 1100] <- 10000

# ATP normalization
# sqlserver
sqlserver <- subset(x, x$DBMS=='sqlserver')
sqlserver_w <- subset(sqlserver, sqlserver$PCTUPDATE!=0)
sqlserver_w <- subset(sqlserver_w, select = -PCTREAD)
sqlserver_w$ATP = (sqlserver_w$ATP-min(sqlserver_w$ATP))/(max(sqlserver_w$ATP)-min(sqlserver_w$ATP))
sqlserver_w$MAXMPL = (sqlserver_w$MAXMPL-min(sqlserver_w$MAXMPL))/(max(sqlserver_w$MAXMPL)-min(sqlserver_w$MAXMPL))
sqlserver <- sqlserver_w
x = rbind(sqlserver)
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTUPDATE = (x$PCTUPDATE/min(x$PCTUPDATE))/(max(x$PCTUPDATE)/min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))

nrow(x)
[1] 160
x <- subset(x, x$MAXMPL < 1)
> nrow(x)
[1] 129

> med.fit <- lm(ATP ~ NUMPROCESSORS, data = x)
> summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.28211 -0.19796 -0.02041  0.12734  0.55702 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.52444    0.03804   13.79   <2e-16 ***
	NUMPROCESSORS -0.65170    0.06187  -10.53   <2e-16 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2505 on 158 degrees of freedom
	Multiple R-squared:  0.4125,	Adjusted R-squared:  0.4088 
	F-statistic:   111 on 1 and 158 DF,  p-value: < 2.2e-16

	Call:
	lm(formula = ATP ~ NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.08047 -0.06076 -0.01140  0.04744  0.25403 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.20947    0.01643  12.749   <2e-16 ***
	NUMPROCESSORS -0.25684    0.02635  -9.749   <2e-16 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.0861 on 127 degrees of freedom
	Multiple R-squared:  0.428,	Adjusted R-squared:  0.4235 
	F-statistic: 95.04 on 1 and 127 DF,  p-value: < 2.2e-16

out.fit <- lm(MAXMPL ~ ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.25337 -0.15999  0.02367  0.07058  0.71206 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)   -0.30565    0.04965  -6.156 5.99e-09 ***
	ATP            1.21753    0.06996  17.403  < 2e-16 ***
	NUMPROCESSORS  0.59352    0.07098   8.361 3.14e-14 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2203 on 157 degrees of freedom
	Multiple R-squared:  0.6683,	Adjusted R-squared:  0.6641 
	F-statistic: 158.2 on 2 and 157 DF,  p-value: < 2.2e-16

	Call:
	lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	Residuals:
	      Min        1Q    Median        3Q       Max 
	-0.046980 -0.009026 -0.001419  0.015779  0.025289 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)   0.015627   0.005707   2.738 0.007073 ** 
	ATP           0.074126   0.020414   3.631 0.000409 ***
	NUMPROCESSORS 0.039294   0.008014   4.903 2.85e-06 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.01981 on 126 degrees of freedom
	Multiple R-squared:  0.162,	Adjusted R-squared:  0.1487 
	F-statistic: 12.18 on 2 and 126 DF,  p-value: 1.462e-05
