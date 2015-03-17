# Overall: 33.4% (close to suboptimal)
library(aod)
library(ggplot2)
x = read.csv(file="cnfm.dat",head=TRUE,sep="\t")
x <- subset(x, x$ATP < 120000)
x <- subset(x, x$MAXMPL < 1100)
# ATP normalization
# mysql
mysql <- subset(x, x$DBMS=='mysql')
mysql_r <- subset(mysql, mysql$PCTREAD!=0)
mysql_r <- subset(mysql_r, select = -PCTUPDATE)
mysql_r$ATP = (mysql_r$ATP-min(mysql_r$ATP))/(max(mysql_r$ATP)-min(mysql_r$ATP))
mysql_r$MAXMPL = (mysql_r$MAXMPL-min(mysql_r$MAXMPL))/(max(mysql_r$MAXMPL)-min(mysql_r$MAXMPL))
mysql <- mysql_r
#### gother each DBMS' samples
x = rbind(mysql)
#x <- x[!is.na(x$MAXMPL),]
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD/min(x$PCTREAD))/(max(x$PCTREAD)/min(x$PCTREAD))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
nrow(x)
#104
#x <- subset(x, x$MAXMPL < 1)
#nrow(x)
#45

med.fit <- lm(ATP ~ NUMPROCESSORS + PK, data = x)
summary(med.fit)

	### all samples
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.21398 -0.13991 -0.08745 -0.05724  0.82688 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.71605    0.06288  11.388  < 2e-16 ***
	NUMPROCESSORS -0.11857    0.08504  -1.394    0.166    
	PK            -0.48631    0.05597  -8.689 9.01e-14 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2795 on 97 degrees of freedom
	Multiple R-squared:  0.4407,	Adjusted R-squared:  0.4292 
	F-statistic: 38.22 on 2 and 97 DF,  p-value: 5.752e-13

	## only thrashing samples
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	      Min        1Q    Median        3Q       Max 
	-0.059298 -0.010245  0.000744  0.011821  0.027641 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.558951   0.005427  103.00  < 2e-16 ***
	NUMPROCESSORS -0.093091   0.007797  -11.94 4.38e-15 ***
	PK            -0.475974   0.009747  -48.84  < 2e-16 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.01831 on 42 degrees of freedom
	Multiple R-squared:  0.9853,	Adjusted R-squared:  0.9846 
	F-statistic:  1411 on 2 and 42 DF,  p-value: < 2.2e-16

out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.3548 -0.1804 -0.1258  0.3759  0.8632 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)
	(Intercept)     1.3698     1.3869   0.988    0.329
	PK             -1.3131     1.1898  -1.104    0.276
	ATP            -1.3669     1.3949  -0.980    0.333
	NUMPROCESSORS   0.3201     0.2625   1.220    0.230

	Residual standard error: 0.2941 on 41 degrees of freedom
	Multiple R-squared:  0.3283,	Adjusted R-squared:  0.2791 
	F-statistic:  6.68 on 3 and 41 DF,  p-value: 0.000893

###### logistic ####
x = rbind(mysql)
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
X2 = 152.3, df = 3, P(> X2) = 0.0

> 1-out.fit$deviance/out.fit$null.deviance
[1] 0.6035987

### update-only
library(aod)
library(ggplot2)
x = read.csv(file="cnfm.dat",head=TRUE,sep="\t")
x <- subset(x, x$ATP < 120000)
x <- subset(x, x$MAXMPL < 1100)
# ATP normalization
# mysql
mysql <- subset(x, x$DBMS=='mysql')
mysql_w <- subset(mysql, mysql$PCTUPDATE!=0)
mysql_w <- subset(mysql_w, select = -PCTREAD)
mysql_w$ATP = (mysql_w$ATP-min(mysql_w$ATP))/(max(mysql_w$ATP)-min(mysql_w$ATP))
mysql_w$MAXMPL = (mysql_w$MAXMPL-min(mysql_w$MAXMPL))/(max(mysql_w$MAXMPL)-min(mysql_w$MAXMPL))
mysql <- mysql_w
x = rbind(mysql)
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTUPDATE = (x$PCTUPDATE/min(x$PCTUPDATE))/(max(x$PCTUPDATE)/min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
nrow(x)
#[1] 160
x <- subset(x, x$MAXMPL < 1)
nrow(x)
#[1] 25

> cor.test(x$NUMPROCESSORS, x$ATP)

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -0.2658, df = 158, p-value = 0.7907
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1757254  0.1344567
	sample estimates:
		cor 
	-0.02114312

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -0.5078, df = 29, p-value = 0.6154
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.4337953  0.2694164
	sample estimates:
		cor 
	-0.09388657 

med.fit <- lm(ATP ~ NUMPROCESSORS, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.5039 -0.1535 -0.1032  0.1737  0.4946 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.48125    0.08530   5.642 9.63e-06 ***
	NUMPROCESSORS  0.03015    0.13894   0.217     0.83    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2425 on 23 degrees of freedom
	Multiple R-squared:  0.002044,	Adjusted R-squared:  -0.04135 
	F-statistic: 0.0471 on 1 and 23 DF,  p-value: 0.8301

out.fit <- lm(MAXMPL ~ ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.21091 -0.10984 -0.08984 -0.02696  0.66669 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)
	(Intercept)    0.04498    0.13944   0.323    0.750
	ATP            0.21100    0.22077   0.956    0.350
	NUMPROCESSORS -0.10414    0.14726  -0.707    0.487

	Residual standard error: 0.2567 on 22 degrees of freedom
	Multiple R-squared:  0.05803,	Adjusted R-squared:  -0.0276 
	F-statistic: 0.6777 on 2 and 22 DF,  p-value: 0.5181
