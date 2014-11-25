# Overall: 33.4% (close to suboptimal)
library(aod)
library(ggplot2)
#x = read.csv(file="cnfm.dat",head=TRUE,sep="\t")
x = read.csv(file="raw_cnfm.dat",head=TRUE,sep="\t")
x$MAXMPL[x$MAXMPL == 1100] <- 10000
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

### update-only
library(aod)
library(ggplot2)
x = read.csv(file="cnfm.dat",head=TRUE,sep="\t")
x$MAXMPL[x$MAXMPL == 1100] <- 10000

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
[1] 160
x <- subset(x, x$MAXMPL < 1)
nrow(x)
[1] 139

> med.fit <- lm(ATP ~ NUMPROCESSORS, data = x)
> summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.69290 -0.05504  0.05082  0.16207  0.36929 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.75509    0.04018  18.795   <2e-16 ***
	NUMPROCESSORS -0.12437    0.06533  -1.904   0.0588 .  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2646 on 158 degrees of freedom
	Multiple R-squared:  0.02242,	Adjusted R-squared:  0.01624 
	F-statistic: 3.624 on 1 and 158 DF,  p-value: 0.05877

	Call:
	lm(formula = ATP ~ NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.71624 -0.04652  0.03532  0.14426  0.34402 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.77650    0.03973  19.543   <2e-16 ***
	NUMPROCESSORS -0.12053    0.06272  -1.922   0.0567 .  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2388 on 137 degrees of freedom
	Multiple R-squared:  0.02624,	Adjusted R-squared:  0.01914 
	F-statistic: 3.692 on 1 and 137 DF,  p-value: 0.05674

out.fit <- lm(MAXMPL ~ ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.34027 -0.14549 -0.10579 -0.04504  0.97153 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.46284    0.08718   5.309  3.7e-07 ***
	ATP           -0.27986    0.09597  -2.916  0.00406 ** 
	NUMPROCESSORS -0.22494    0.07971  -2.822  0.00539 ** 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3192 on 157 degrees of freedom
	Multiple R-squared:  0.08361,	Adjusted R-squared:  0.07193 
	F-statistic: 7.162 on 2 and 157 DF,  p-value: 0.001055

	Call:
	lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	Residuals:
	      Min        1Q    Median        3Q       Max 
	-0.035816 -0.013821 -0.003834  0.007588  0.058283 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.029232   0.005883   4.969 1.99e-06 ***
	ATP            0.012448   0.006500   1.915   0.0576 .  
	NUMPROCESSORS -0.026673   0.004836  -5.516 1.69e-07 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.01817 on 136 degrees of freedom
	Multiple R-squared:  0.2207,	Adjusted R-squared:  0.2093 
	F-statistic: 19.26 on 2 and 136 DF,  p-value: 4.308e-08

