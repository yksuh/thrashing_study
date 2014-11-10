# Overall: 33.4% (close to suboptimal)
library(aod)
library(ggplot2)
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
#x$MAXMPL[x$MAXMPL == 1100] <- 100000
x$MAXMPL[x$MAXMPL == 1100] <- 10000
# mysql
mysql <- subset(x, x$DBMS=='mysql')
mysql_r <- subset(mysql, mysql$PCTREAD!=0)
mysql_r <- subset(mysql_r, select = -PCTUPDATE)
mysql_r$ATP = (mysql_r$ATP-min(mysql_r$ATP))/(max(mysql_r$ATP)-min(mysql_r$ATP))
mysql_r$MAXMPL = (mysql_r$MAXMPL-min(mysql_r$MAXMPL))/(max(mysql_r$MAXMPL)-min(mysql_r$MAXMPL))
mysql <- mysql_r
x = rbind(mysql)
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD/min(x$PCTREAD))/(max(x$PCTREAD)/min(x$PCTREAD))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
nrow(x)
[1] 73

x <- subset(x, x$MAXMPL < 1)
> nrow(x)
[1] 46

cor.test(x$NUMPROCESSORS, x$ATP)
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -1.0988, df = 71, p-value = 0.2756
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.3489929  0.1038488
	sample estimates:
	       cor 
	-0.1293079

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -2.4029, df = 44, p-value = 0.02055
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.57412042 -0.05580621
	sample estimates:
	       cor 
	-0.3405866

cor.test(x$PCTREAD, x$ATP)
	Pearson's product-moment correlation

	data:  x$PCTREAD and x$ATP
	t = 1.1164, df = 71, p-value = 0.268
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1018029  0.3508074
	sample estimates:
	      cor 
	0.1313405 

	Pearson's product-moment correlation

	data:  x$PCTREAD and x$ATP
	t = -0.1381, df = 44, p-value = 0.8908
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.3092467  0.2711190
	sample estimates:
		cor 
	-0.02081751

cor.test(x$PK, x$ATP)
	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -31.0439, df = 71, p-value < 2.2e-16
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.9780000 -0.9447896
	sample estimates:
	       cor 
	-0.9650817

	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -10.9045, df = 44, p-value = 4.324e-14
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.9171728 -0.7500817
	sample estimates:
	       cor 
	-0.8543479 

cor.test(x$PCTREAD*x$PK, x$ATP)

	Pearson's product-moment correlation

	data:  x$PCTREAD * x$PK and x$ATP
	t = -3.9917, df = 71, p-value = 0.0001579
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.5991682 -0.2196873
	sample estimates:
	       cor 
	-0.4281163 

	Pearson's product-moment correlation

	data:  x$PCTREAD * x$PK and x$ATP
	t = -7.5056, df = 44, p-value = 2.09e-09
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.8538703 -0.5866119
	sample estimates:
	       cor 
	-0.7493085 

med.fit <- lm(ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK, 
	    data = x)

	Residuals:
	      Min        1Q    Median        3Q       Max 
	-0.169754 -0.021721 -0.003573  0.021747  0.242143 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.62899    0.01504  41.816  < 2e-16 ***
	NUMPROCESSORS -0.10258    0.02088  -4.913 5.93e-06 ***
	PK            -0.57542    0.01773 -32.449  < 2e-16 ***
	PCTREAD        0.15451    0.02350   6.575 8.19e-09 ***
	PK:PCTREAD    -0.12815    0.03660  -3.501 0.000823 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.06135 on 68 degrees of freedom
	Multiple R-squared:  0.9645,	Adjusted R-squared:  0.9624 
	F-statistic: 461.9 on 4 and 68 DF,  p-value: < 2.2e-16


	### thrashing samples
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK, 
	    data = x)

	Residuals:
	      Min        1Q    Median        3Q       Max 
	-0.138167 -0.022977 -0.000979  0.028756  0.219664 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.66241    0.01936  34.223  < 2e-16 ***
	NUMPROCESSORS -0.17467    0.03103  -5.629 1.46e-06 ***
	PK            -0.62797    0.07833  -8.017 6.30e-10 ***
	PCTREAD        0.16160    0.02651   6.096 3.15e-07 ***
	PK:PCTREAD    -0.03956    0.09345  -0.423    0.674    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.06901 on 41 degrees of freedom
	Multiple R-squared:  0.8923,	Adjusted R-squared:  0.8818 
	F-statistic: 84.95 on 4 and 41 DF,  p-value: < 2.2e-16

	## modified
	med.fit <- lm(ATP ~ NUMPROCESSORS + PK, data = x)
	summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.07495 -0.04536 -0.03038 -0.00402  0.34298 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.69346    0.02488  27.869  < 2e-16 ***
	NUMPROCESSORS -0.14577    0.04119  -3.539 0.000978 ***
	PK            -0.58251    0.04946 -11.779 4.79e-15 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.09392 on 43 degrees of freedom
	Multiple R-squared:  0.7908,	Adjusted R-squared:  0.7811 
	F-statistic: 81.29 on 2 and 43 DF,  p-value: 2.457e-15

cor.test(x$PK, x$MAXMPL)
	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 16.8816, df = 71, p-value < 2.2e-16
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.8369574 0.9327899
	sample estimates:
	      cor 
	0.8947372 

	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 2.0386, df = 44, p-value = 0.04753
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.00379669 0.53817299
	sample estimates:
	      cor 
	0.2937709 

cor.test(x$ATP, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -14.6948, df = 71, p-value < 2.2e-16
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.9149577 -0.7963775
	sample estimates:
	       cor 
	-0.8675009
	
	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -1.65, df = 44, p-value = 0.1061
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.49687336  0.05258891
	sample estimates:
	       cor 
	-0.2413944


cor.test(x$NUMPROCESSORS, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = -0.0393, df = 71, p-value = 0.9688
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2344762  0.2256489
	sample estimates:
		 cor 
	-0.004660359

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = 2.0491, df = 44, p-value = 0.04644
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.005309517 0.539246805
	sample estimates:
	      cor 
	0.2951526 

cor.test(x$ACTROWPOOL, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$ACTROWPOOL and x$MAXMPL
	t = -0.8441, df = 71, p-value = 0.4015
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.3223477  0.1334553
	sample estimates:
		cor 
	-0.09967233 

	Pearson's product-moment correlation

	data:  x$ACTROWPOOL and x$MAXMPL
	t = -0.0345, df = 44, p-value = 0.9726
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2950593  0.2855224
	sample estimates:
		 cor 
	-0.005207308 

cor.test(x$PCTREAD, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$PCTREAD and x$MAXMPL
	t = -1.2311, df = 71, p-value = 0.2224
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.36257296  0.08844417
	sample estimates:
	       cor 
	-0.1445647

	Pearson's product-moment correlation

	data:  x$PCTREAD and x$MAXMPL
	t = 1.2732, df = 44, p-value = 0.2096
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1076951  0.4539537
	sample estimates:
	      cor 
	0.1884961 

out.fit <- lm(MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.81222 -0.03504  0.03247  0.10388  0.27276 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)   -0.141980   0.249414  -0.569  0.57109    
	PK             1.122644   0.238106   4.715 1.27e-05 ***
	PCTREAD       -0.208478   0.072365  -2.881  0.00532 ** 
	ACTROWPOOL    -0.087311   0.088201  -0.990  0.32578    
	ATP            0.429056   0.381929   1.123  0.26528    
	NUMPROCESSORS -0.001333   0.079561  -0.017  0.98668    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2082 on 67 degrees of freedom
	Multiple R-squared:  0.8255,	Adjusted R-squared:  0.8124 
	F-statistic: 63.37 on 5 and 67 DF,  p-value: < 2.2e-16

		### modified
		out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
		summary(out.fit)

		Call:
		lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

		Residuals:
		     Min       1Q   Median       3Q      Max 
		-0.87139 -0.01908  0.02045  0.10811  0.15391 

		Coefficients:
			      Estimate Std. Error t value Pr(>|t|)    
		(Intercept)    0.15572    0.22934   0.679 0.499407    
		PK             0.75112    0.21186   3.545 0.000709 ***
		ATP           -0.18612    0.33588  -0.554 0.581274    
		NUMPROCESSORS -0.06063    0.08005  -0.757 0.451372    
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.2182 on 69 degrees of freedom
		Multiple R-squared:  0.8024,	Adjusted R-squared:  0.7938 
		F-statistic: 93.42 on 3 and 69 DF,  p-value: < 2.2e-16

	### thrashing samples
	Call:
	lm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, 
	    data = x)

	Residuals:
	      Min        1Q    Median        3Q       Max 
	-0.030851 -0.006796 -0.004175  0.008207  0.044431 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)  
	(Intercept)   -0.022389   0.021987  -1.018   0.3147  
	PK             0.038150   0.022513   1.695   0.0979 .
	PCTREAD       -0.004126   0.007306  -0.565   0.5754  
	ACTROWPOOL     0.001185   0.007562   0.157   0.8762  
	ATP            0.038697   0.032067   1.207   0.2346  
	NUMPROCESSORS  0.018183   0.008526   2.133   0.0391 *
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.01417 on 40 degrees of freedom
	Multiple R-squared:  0.1897,	Adjusted R-squared:  0.08844 
	F-statistic: 1.873 on 5 and 40 DF,  p-value: 0.1207

		### modified
		out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
		summary(out.fit)

		Call:
		lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

		Residuals:
		      Min        1Q    Median        3Q       Max 
		-0.031055 -0.006601 -0.004184  0.005932  0.044354 

		Coefficients:
			       Estimate Std. Error t value Pr(>|t|)  
		(Intercept)   -0.013784   0.016066  -0.858   0.3958  
		PK             0.029156   0.015035   1.939   0.0592 .
		ATP            0.026427   0.022552   1.172   0.2479  
		NUMPROCESSORS  0.015381   0.006922   2.222   0.0317 *
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.01389 on 42 degrees of freedom
		Multiple R-squared:  0.1827,	Adjusted R-squared:  0.1244 
		F-statistic:  3.13 on 3 and 42 DF,  p-value: 0.03553
