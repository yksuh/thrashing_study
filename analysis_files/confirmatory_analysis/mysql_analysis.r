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
83
x <- subset(x, x$MAXMPL < 1)
nrow(x)
34

cor.test(x$NUMPROCESSORS, x$ATP)

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -0.349, df = 81, p-value = 0.728
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2523337  0.1784272
	sample estimates:
		cor 
	-0.03875356 

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -2.9225, df = 32, p-value = 0.006325
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.6900488 -0.1430218
	sample estimates:
	       cor 
	-0.4589885

cor.test(x$PK, x$ATP)

	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -6.1069, df = 81, p-value = 3.349e-08
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.6932222 -0.3934464
	sample estimates:
	       cor 
	-0.5614867

	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -20.8357, df = 32, p-value < 2.2e-16
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.9825676 -0.9306024
	sample estimates:
	       cor 
	-0.9650644

med.fit <- lm(ATP ~ NUMPROCESSORS + PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.23567 -0.18687 -0.11831  0.08918  0.71027 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.63676    0.06630   9.605 5.72e-15 ***
	NUMPROCESSORS -0.05672    0.09352  -0.607    0.546    
	PK            -0.39316    0.06447  -6.099 3.59e-08 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2935 on 80 degrees of freedom
	Multiple R-squared:  0.3184,	Adjusted R-squared:  0.3014 
	F-statistic: 18.69 on 2 and 80 DF,  p-value: 2.194e-07

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	      Min        1Q    Median        3Q       Max 
	-0.063902 -0.010881 -0.000718  0.015829  0.024436 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.559571   0.005750   97.32  < 2e-16 ***
	NUMPROCESSORS -0.101275   0.008678  -11.67 7.08e-13 ***
	PK            -0.469944   0.010805  -43.49  < 2e-16 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.01972 on 31 degrees of freedom
	Multiple R-squared:  0.9873,	Adjusted R-squared:  0.9865 
	F-statistic:  1202 on 2 and 31 DF,  p-value: < 2.2e-16

cor.test(x$NUMPROCESSORS, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = -1.0203, df = 81, p-value = 0.3106
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.3205457  0.1056108
	sample estimates:
	       cor 
	-0.1126444

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = 4.1914, df = 32, p-value = 0.0002039
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.3219933 0.7770611
	sample estimates:
	      cor 
	0.5953347

cor.test(x$PK, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 7.658, df = 81, p-value = 3.532e-11
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.5026011 0.7578061
	sample estimates:
	      cor 
	0.6480393

	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 0.8118, df = 32, p-value = 0.4229
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2060142  0.4582031
	sample estimates:
	      cor 
	0.1420475

cor.test(x$ATP, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -0.86, df = 81, p-value = 0.3923
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.3045635  0.1230919
	sample estimates:
		cor 
	-0.09512292

	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -2.0288, df = 32, p-value = 0.05087
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.6065171610  0.0006466442
	sample estimates:
	       cor 
	-0.3375929

out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.7633 -0.2667 -0.1118  0.1848  0.5927 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)   -0.001303   0.113367  -0.011    0.991    
	PK             0.840546   0.090929   9.244 3.25e-14 ***
	ATP            0.539499   0.130291   4.141 8.61e-05 ***
	NUMPROCESSORS -0.100626   0.109231  -0.921    0.360    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.342 on 79 degrees of freedom
	Multiple R-squared:  0.5305,	Adjusted R-squared:  0.5126 
	F-statistic: 29.75 on 3 and 79 DF,  p-value: 5.654e-13

	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	       Min         1Q     Median         3Q        Max 
	-0.0127273 -0.0044067 -0.0006259  0.0029112  0.0256281 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.231891   0.043084   5.382 7.91e-06 ***
	PK            -0.195948   0.036419  -5.380 7.96e-06 ***
	ATP           -0.417019   0.076869  -5.425 7.01e-06 ***
	NUMPROCESSORS -0.021632   0.008625  -2.508   0.0178 *  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.008439 on 30 degrees of freedom
	Multiple R-squared:  0.6741,	Adjusted R-squared:  0.6415 
	F-statistic: 20.69 on 3 and 30 DF,  p-value: 1.852e-07

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
[1] 128
x <- subset(x, x$MAXMPL < 1)
> nrow(x)
[1] 20

> cor.test(x$NUMPROCESSORS, x$ATP)

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -0.3151, df = 126, p-value = 0.7532
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2006160  0.1461799
	sample estimates:
		cor 
	-0.02806242 

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -0.5445, df = 18, p-value = 0.5928
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.5394322  0.3340390
	sample estimates:
	      cor 
	-0.127299

> med.fit <- lm(ATP ~ NUMPROCESSORS, data = x)
> summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.55799 -0.17667  0.02009  0.16904  0.44201 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.57924    0.03885  14.911   <2e-16 ***
	NUMPROCESSORS -0.02124    0.06742  -0.315    0.753    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2556 on 126 degrees of freedom
	Multiple R-squared:  0.0007875,	Adjusted R-squared:  -0.007143 
	F-statistic: 0.0993 on 1 and 126 DF,  p-value: 0.7532

	Call:
	lm(formula = ATP ~ NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.37871 -0.14493 -0.04408  0.16888  0.35197 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.46652    0.07353   6.345  5.6e-06 ***
	NUMPROCESSORS -0.06998    0.12851  -0.545    0.593    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2161 on 18 degrees of freedom
	Multiple R-squared:  0.01621,	Adjusted R-squared:  -0.03845 
	F-statistic: 0.2965 on 1 and 18 DF,  p-value: 0.5928

cor.test(x$NUMPROCESSORS, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = 0.5407, df = 126, p-value = 0.5897
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1264717  0.2198100
	sample estimates:
	       cor 
	0.04811476

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = -0.007, df = 18, p-value = 0.9945
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.4438421  0.4411975
	sample estimates:
		 cor 
	-0.001644297 

cor.test(x$ATP, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = 2.5667, df = 126, p-value = 0.01144
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.05136593 0.38167619
	sample estimates:
	      cor 
	0.2229095 

	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -1.2129, df = 18, p-value = 0.2409
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.6395889  0.1908744
	sample estimates:
	      cor 
	-0.274863 

out.fit <- lm(MAXMPL ~ ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.93240  0.07092  0.11889  0.14749  0.31995 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.63781    0.08926   7.145 6.56e-11 ***
	ATP            0.31728    0.12312   2.577   0.0111 *  
	NUMPROCESSORS  0.05823    0.09321   0.625   0.5333    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3532 on 125 degrees of freedom
	Multiple R-squared:  0.05265,	Adjusted R-squared:  0.03749 
	F-statistic: 3.473 on 2 and 125 DF,  p-value: 0.03404


	Call:
	lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	Residuals:
	      Min        1Q    Median        3Q       Max 
	-0.019183 -0.016534 -0.009314 -0.000523  0.056854 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)  
	(Intercept)    0.028786   0.016285   1.768   0.0951 .
	ATP           -0.034536   0.029018  -1.190   0.2503  
	NUMPROCESSORS -0.002528   0.015951  -0.159   0.8759  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.0266 on 17 degrees of freedom
	Multiple R-squared:  0.07691,	Adjusted R-squared:  -0.03168 
	F-statistic: 0.7082 on 2 and 17 DF,  p-value: 0.5065

