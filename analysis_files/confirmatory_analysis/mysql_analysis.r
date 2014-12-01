# Overall: 33.4% (close to suboptimal)
library(aod)
library(ggplot2)
x = read.csv(file="cnfm.dat",head=TRUE,sep="\t")
x$MAXMPL[x$MAXMPL == 1100] <- 10000
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
104
x <- subset(x, x$MAXMPL < 1)
nrow(x)
45

cor.test(x$NUMPROCESSORS, x$ATP)

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -0.8184, df = 102, p-value = 0.415
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2691695  0.1135869
	sample estimates:
		cor 
	-0.08076819

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -2.7825, df = 43, p-value = 0.00798
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.6137756 -0.1096559
	sample estimates:
	       cor 
	-0.3906168

cor.test(x$PK, x$ATP)

	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -7.7449, df = 102, p-value = 7.263e-12
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.7170773 -0.4711560
	sample estimates:
	      cor 
	-0.608527

	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -24.9863, df = 43, p-value < 2.2e-16
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.9819767 -0.9408308
	sample estimates:
	       cor 
	-0.9672448

med.fit <- lm(ATP ~ NUMPROCESSORS + PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.22183 -0.14996 -0.08943 -0.05989  0.74597 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.64960    0.05961  10.897  < 2e-16 ***
	NUMPROCESSORS -0.11499    0.08148  -1.411    0.161    
	PK            -0.41257    0.05261  -7.842 4.72e-12 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.268 on 101 degrees of freedom
	Multiple R-squared:  0.3825,	Adjusted R-squared:  0.3703 
	F-statistic: 31.28 on 2 and 101 DF,  p-value: 2.678e-11

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

cor.test(x$NUMPROCESSORS, x$MAXMPL)

	Pearson's product-moment correlation

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = -1.4114, df = 102, p-value = 0.1612
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.32240187  0.05566453
	sample estimates:
	       cor 
	-0.1384075

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = 4.2522, df = 43, p-value = 0.0001119
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.2981589 0.7222610
	sample estimates:
	      cor 
	0.5440755

cor.test(x$PK, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 10.4063, df = 102, p-value < 2.2e-16
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.6092123 0.7996769
	sample estimates:
	      cor 
	0.7176059

	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = -0.1994, df = 43, p-value = 0.8429
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.3210646  0.2655075
	sample estimates:
		cor 
	-0.03039528 

cor.test(x$ATP, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -2.1663, df = 102, p-value = 0.03262
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.3866915 -0.0178546
	sample estimates:
	       cor 
	-0.2097217 

	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -0.7279, df = 43, p-value = 0.4706
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.3911963  0.1893340
	sample estimates:
	       cor 
	-0.1103317

out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.81367 -0.23678 -0.09022  0.18441  0.63281 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)   -0.01386    0.10299  -0.135    0.893    
	PK             0.90301    0.07816  11.553  < 2e-16 ***
	ATP            0.50594    0.11654   4.341  3.4e-05 ***
	NUMPROCESSORS -0.09863    0.09637  -1.023    0.309    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3138 on 100 degrees of freedom
	Multiple R-squared:  0.6009,	Adjusted R-squared:  0.589 
	F-statistic:  50.2 on 3 and 100 DF,  p-value: < 2.2e-16

	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	      Min        1Q    Median        3Q       Max 
	-0.018103 -0.009203 -0.006419  0.019180  0.044042 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)
	(Intercept)    0.06994    0.07081   0.988    0.329
	PK            -0.06699    0.06071  -1.104    0.276
	ATP           -0.12389    0.12643  -0.980    0.333
	NUMPROCESSORS  0.01633    0.01339   1.220    0.230

	Residual standard error: 0.01501 on 41 degrees of freedom
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
x$MAXMPL[x$MAXMPL == 1100] <- 10000
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
[1] 160
x <- subset(x, x$MAXMPL < 1)
> nrow(x)
[1] 31

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

> med.fit <- lm(ATP ~ NUMPROCESSORS, data = x)
> summary(med.fit)

	Call:
	lm(formula = ATP ~ PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.44058 -0.11996  0.02574  0.03621  0.55942 

	Coefficients:
		    Estimate Std. Error t value Pr(>|t|)    
	(Intercept)  0.71131    0.02552  27.877  < 2e-16 ***
	PK          -0.27073    0.03609  -7.503 4.27e-12 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2282 on 158 degrees of freedom
	Multiple R-squared:  0.2627,	Adjusted R-squared:  0.258 
	F-statistic: 56.29 on 1 and 158 DF,  p-value: 4.265e-12

	Call:
	lm(formula = ATP ~ NUMPROCESSORS, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.5720 -0.1819  0.1484  0.1656  0.4323 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.58511    0.04035  14.501   <2e-16 ***
	NUMPROCESSORS -0.01744    0.06562  -0.266    0.791    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2657 on 158 degrees of freedom
	Multiple R-squared:  0.000447,	Adjusted R-squared:  -0.005879 
	F-statistic: 0.07066 on 1 and 158 DF,  p-value: 0.7907

	Call:
	lm(formula = ATP ~ NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.41733 -0.17079 -0.03874  0.22637  0.53849 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.47421    0.09258   5.122 1.81e-05 ***
	NUMPROCESSORS -0.07336    0.14445  -0.508    0.615    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2721 on 29 degrees of freedom
	Multiple R-squared:  0.008815,	Adjusted R-squared:  -0.02536 
	F-statistic: 0.2579 on 1 and 29 DF,  p-value: 0.6154

cor.test(x$NUMPROCESSORS, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = -0.346, df = 158, p-value = 0.7298
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1818995  0.1281886
	sample estimates:
		cor 
	-0.02751744

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = 0.7273, df = 29, p-value = 0.4728
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2314693  0.4660836
	sample estimates:
	     cor 
	0.133849 

cor.test(x$ATP, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = 3.3822, df = 158, p-value = 0.0009066
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.1090683 0.3989068
	sample estimates:
	      cor 
	0.2598299 

	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -1.0947, df = 29, p-value = 0.2826
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.5170552  0.1669083
	sample estimates:
	       cor 
	-0.1992137

out.fit <- lm(MAXMPL ~ ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.91075  0.05821  0.13460  0.18347  0.41654 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.60462    0.08763   6.900 1.21e-10 ***
	ATP            0.38088    0.11317   3.366  0.00096 ***
	NUMPROCESSORS -0.02669    0.09336  -0.286  0.77532    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.378 on 157 degrees of freedom
	Multiple R-squared:  0.068,	Adjusted R-squared:  0.05612 
	F-statistic: 5.727 on 2 and 157 DF,  p-value: 0.003974

	Call:
	lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	Residuals:
	      Min        1Q    Median        3Q       Max 
	-0.021808 -0.007834 -0.007466  0.018971  0.051128 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)   -0.007375   0.010315  -0.715  0.47859    
	ATP            0.014426   0.016676   0.865  0.39191    
	NUMPROCESSORS  0.029044   0.006849   4.241  0.00012 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.01504 on 42 degrees of freedom
	Multiple R-squared:  0.3083,	Adjusted R-squared:  0.2754 
	F-statistic: 9.362 on 2 and 42 DF,  p-value: 0.0004342

