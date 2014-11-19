# Overall: 33.4% (close to suboptimal)
library(aod)
library(ggplot2)
x = read.csv(file="cnfm.dat",head=TRUE,sep="\t")
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
nrow(x)
84
x <- subset(x, x$MAXMPL < 1)
nrow(x)
1

cor.test(x$NUMPROCESSORS, x$ATP)

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -10.3907, df = 82, p-value < 2.2e-16
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.8335559 -0.6435025
	sample estimates:
	       cor 
	-0.7538883 

cor.test(x$PK, x$ATP)

	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -0.5778, df = 82, p-value = 0.565
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2743292  0.1528021
	sample estimates:
		cor 
	-0.06367925

med.fit <- lm(ATP ~ NUMPROCESSORS + PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.78462 -0.04357 -0.01163  0.11336  0.30814 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.981899   0.039288  24.992   <2e-16 ***
	NUMPROCESSORS -0.072008   0.006868 -10.485   <2e-16 ***
	PK            -0.048470   0.036630  -1.323    0.189    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1675 on 81 degrees of freedom
	Multiple R-squared:  0.5775,	Adjusted R-squared:  0.567 
	F-statistic: 55.35 on 2 and 81 DF,  p-value: 7.027e-16

cor.test(x$NUMPROCESSORS, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = 0.7892, df = 82, p-value = 0.4322
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1299872  0.2957180
	sample estimates:
	       cor 
	0.08682773 

cor.test(x$PK, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = -0.9529, df = 82, p-value = 0.3434
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.3120496  0.1122579
	sample estimates:
	       cor 
	-0.1046561

out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.92181 -0.01109  0.01337  0.02438  0.14434 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.842019   0.074303  11.332   <2e-16 ***
	PK            -0.014874   0.023724  -0.627   0.5325    
	ATP            0.146429   0.071197   2.057   0.0430 *  
	NUMPROCESSORS  0.013906   0.006756   2.058   0.0428 *  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1073 on 80 degrees of freedom
	Multiple R-squared:  0.06708,	Adjusted R-squared:  0.0321 
	F-statistic: 1.918 on 3 and 80 DF,  p-value: 0.1334

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
[1] 128
x <- subset(x, x$MAXMPL < 1)
nrow(x)
[1] 108

cor.test(x$NUMPROCESSORS, x$ATP)

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -1.4902, df = 126, p-value = 0.1387
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.29831937  0.04290887
	sample estimates:
	       cor 
	-0.1316015 

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -1.303, df = 106, p-value = 0.1954
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.30724514  0.06495369
	sample estimates:
	       cor 
	-0.1255615 

> med.fit <- lm(ATP ~ NUMPROCESSORS, data = x)
> summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.69635 -0.03636  0.08292  0.17452  0.36132 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.75403    0.04460   16.91   <2e-16 ***
	NUMPROCESSORS -0.11535    0.07741   -1.49    0.139    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2935 on 126 degrees of freedom
	Multiple R-squared:  0.01732,	Adjusted R-squared:  0.00952 
	F-statistic: 2.221 on 1 and 126 DF,  p-value: 0.1387

	Call:
	lm(formula = ATP ~ NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.72650 -0.02808  0.06012  0.14765  0.32210 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.77511    0.04445  17.436   <2e-16 ***
	NUMPROCESSORS -0.09721    0.07461  -1.303    0.195    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2672 on 106 degrees of freedom
	Multiple R-squared:  0.01577,	Adjusted R-squared:  0.00648 
	F-statistic: 1.698 on 1 and 106 DF,  p-value: 0.1954

> cor.test(x$NUMPROCESSORS, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = -1.5768, df = 126, p-value = 0.1173
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.30526855  0.03527501
	sample estimates:
	      cor 
	-0.139107 

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = -4.5563, df = 106, p-value = 1.399e-05
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.5514868 -0.2335771
	sample estimates:
	       cor 
	-0.4046881 

> cor.test(x$ATP, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -2.4519, df = 126, p-value = 0.01558
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.37311296 -0.04140196
	sample estimates:
	       cor 
	-0.2133993

	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = 1.7821, df = 106, p-value = 0.07759
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.0190275  0.3483073
	sample estimates:
	      cor 
	0.1705597 

out.fit <- lm(MAXMPL ~ ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.36287 -0.16703 -0.12148 -0.02792  0.92892 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.46264    0.09451   4.895 2.97e-06 ***
	ATP           -0.28358    0.10442  -2.716  0.00755 ** 
	NUMPROCESSORS -0.17935    0.09153  -1.960  0.05228 .  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.344 on 125 degrees of freedom
	Multiple R-squared:  0.07398,	Adjusted R-squared:  0.05917 
	F-statistic: 4.993 on 2 and 125 DF,  p-value: 0.008197

	Call:
	lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	Residuals:
	      Min        1Q    Median        3Q       Max 
	-0.036571 -0.014716 -0.001444  0.009174  0.041910 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.032373   0.005712   5.668 1.28e-07 ***
	ATP            0.008658   0.006345   1.364    0.175    
	NUMPROCESSORS -0.021455   0.004913  -4.367 2.96e-05 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.01745 on 105 degrees of freedom
	Multiple R-squared:  0.1783,	Adjusted R-squared:  0.1627 
	F-statistic:  11.4 on 2 and 105 DF,  p-value: 3.321e-05

