# Overall: (close to suboptimal)
library(aod)
library(ggplot2)
x = read.csv(file="cnfm.dat",head=TRUE,sep="\t")
x <- subset(x, x$ATP < 120000)
x <- subset(x, x$MAXMPL < 1100)
#x$MAXMPL[x$MAXMPL == 1100] <- 10000
# ATP normalization
# oracle
oracle <- subset(x, x$DBMS=='oracle')
oracle_r <- subset(oracle, oracle$PCTREAD!=0)
oracle_r <- subset(oracle_r, select = -PCTUPDATE)
oracle_r$ATP = (oracle_r$ATP-min(oracle_r$ATP))/(max(oracle_r$ATP)-min(oracle_r$ATP))
oracle_r$MAXMPL = (oracle_r$MAXMPL-min(oracle_r$MAXMPL))/(max(oracle_r$MAXMPL)-min(oracle_r$MAXMPL))
oracle <- oracle_r
#### gother each DBMS' samples
x = rbind(oracle)
#x <- x[!is.na(x$MAXMPL),]
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD/min(x$PCTREAD))/(max(x$PCTREAD)/min(x$PCTREAD))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
nrow(x)
#[1] 102
#x <- subset(x, x$MAXMPL < 1)
nrow(x)
#[1] 56

med.fit <- lm(ATP ~ NUMPROCESSORS + PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.33304 -0.14029 -0.06953  0.11846  0.74812 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.48367    0.07088   6.824 8.66e-09 ***
	NUMPROCESSORS -0.23421    0.09340  -2.508  0.01525 *  
	PK            -0.17324    0.05968  -2.903  0.00538 ** 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2184 on 53 degrees of freedom
	Multiple R-squared:  0.2003,	Adjusted R-squared:  0.1701 
	F-statistic: 6.638 on 2 and 53 DF,  p-value: 0.002676

out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.5925 -0.2436  0.0581  0.2373  0.5657 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.68450    0.14108   4.852 1.15e-05 ***
	PK            -0.16009    0.09331  -1.716   0.0922 .  
	ATP           -0.36686    0.19948  -1.839   0.0716 .  
	NUMPROCESSORS  0.11021    0.14345   0.768   0.4458    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3172 on 52 degrees of freedom
	Multiple R-squared:  0.1203,	Adjusted R-squared:  0.06957 
	F-statistic: 2.371 on 3 and 52 DF,  p-value: 0.08104

###### logistic ####
x = rbind(oracle)
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
X2 = 19.4, df = 3, P(> X2) = 0.00023
> 1-out.fit$deviance/out.fit$null.deviance
[1] 0.165257

### update-only
library(aod)
library(ggplot2)
x = read.csv(file="cnfm.dat",head=TRUE,sep="\t")
x <- subset(x, x$ATP < 120000)
x <- subset(x, x$MAXMPL < 1100)
# ATP normalization
# oracle
oracle <- subset(x, x$DBMS=='oracle')
oracle_w <- subset(oracle, oracle$PCTUPDATE!=0)
oracle_w <- subset(oracle_w, select = -PCTREAD)
oracle_w$ATP = (oracle_w$ATP-min(oracle_w$ATP))/(max(oracle_w$ATP)-min(oracle_w$ATP))
oracle_w$MAXMPL = (oracle_w$MAXMPL-min(oracle_w$MAXMPL))/(max(oracle_w$MAXMPL)-min(oracle_w$MAXMPL))
oracle <- oracle_w
x = rbind(oracle)
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTUPDATE = (x$PCTUPDATE/min(x$PCTUPDATE))/(max(x$PCTUPDATE)/min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))

nrow(x)
[1] 160
#x <- subset(x, x$MAXMPL < 1)
nrow(x)
[1] 30


med.fit <- lm(ATP ~ NUMPROCESSORS, data = x)
summary(med.fit)

Call:
lm(formula = ATP ~ NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.46735 -0.25360 -0.01662  0.28839  0.52868 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.56573    0.04513  12.536   <2e-16 ***
	NUMPROCESSORS -0.12588    0.07339  -1.715   0.0883 .  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2972 on 158 degrees of freedom
	Multiple R-squared:  0.01828,	Adjusted R-squared:  0.01207 
	F-statistic: 2.942 on 1 and 158 DF,  p-value: 0.08828

	Call:
	lm(formula = ATP ~ NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.18619 -0.05740 -0.05732  0.02310  0.26439 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.29902    0.05433   5.504    7e-06 ***
	NUMPROCESSORS -0.24152    0.06557  -3.683 0.000975 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1199 on 28 degrees of freedom
	Multiple R-squared:  0.3264,	Adjusted R-squared:  0.3023 
	F-statistic: 13.57 on 1 and 28 DF,  p-value: 0.0009752

out.fit <- lm(MAXMPL ~ ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.76531 -0.13670  0.00412  0.18224  0.61025 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.61418    0.06118  10.039  < 2e-16 ***
	ATP            0.75258    0.07637   9.855  < 2e-16 ***
	NUMPROCESSORS -0.33330    0.07110  -4.688 5.96e-06 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2853 on 157 degrees of freedom
	Multiple R-squared:  0.4605,	Adjusted R-squared:  0.4537 
	F-statistic: 67.02 on 2 and 157 DF,  p-value: < 2.2e-16

	Call:
	lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	Residuals:
	      Min        1Q    Median        3Q       Max 
	-0.037068 -0.004150 -0.004133  0.005968  0.035234 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)   
	(Intercept)    0.03367    0.01147   2.936  0.00672 **
	ATP            0.02769    0.02765   1.002  0.32539   
	NUMPROCESSORS -0.02953    0.01169  -2.527  0.01767 * 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.01754 on 27 degrees of freedom
	Multiple R-squared:  0.3611,	Adjusted R-squared:  0.3138 
	F-statistic: 7.631 on 2 and 27 DF,  p-value: 0.002361

