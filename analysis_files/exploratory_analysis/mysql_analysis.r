# Overall: 33.4% (close to suboptimal)
library(aod)
library(ggplot2)
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
x <- subset(x, x$ATP < 120000)
x <- subset(x, x$MAXMPL < 1100)
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

	### thrashing samples
	Call:
	lm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.46462 -0.10706 -0.04066  0.14781  0.56683 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)  
	(Intercept)    -0.2052     0.3520  -0.583   0.5636  
	PK              0.4853     0.3506   1.384   0.1749  
	PCTREAD        -0.1327     0.1105  -1.201   0.2375  
	ACTROWPOOL      0.1003     0.1123   0.893   0.3777  
	ATP             0.3039     0.5105   0.595   0.5554  
	NUMPROCESSORS   0.2646     0.1239   2.135   0.0397 *
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1965 on 36 degrees of freedom
	Multiple R-squared:  0.2632,	Adjusted R-squared:  0.1609 
	F-statistic: 2.572 on 5 and 36 DF,  p-value: 0.04341

# update
x = rbind(mysql)
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTUPDATE = (x$PCTUPDATE/min(x$PCTUPDATE))/(max(x$PCTUPDATE)/min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
> nrow(x)
[1] 128
x <- subset(x, x$MAXMPL < 1)
> nrow(x)
[1] 31

cor.test(x$NUMPROCESSORS, x$ATP)

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = 0.0465, df = 126, p-value = 0.963
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1695080  0.1775473
	sample estimates:
		cor 
	0.004144464

	Pearson's product-moment correlation

data:  x$NUMPROCESSORS and x$ATP
t = 0.1009, df = 29, p-value = 0.9203
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.3378493  0.3706135
sample estimates:
       cor 
0.01873349

cor.test(x$NUMPROCESSORS, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = -0.3575, df = 126, p-value = 0.7213
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2042371  0.1424827
	sample estimates:
		cor 
	-0.03183488 

	Pearson's product-moment correlation

data:  x$NUMPROCESSORS and x$MAXMPL
t = -1.9433, df = 29, p-value = 0.06174
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.61929151  0.01694011
sample estimates:
       cor 
-0.3394375 

cor.test(x$ATP, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = 3.2248, df = 126, p-value = 0.001606
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.1077546 0.4290923
	sample estimates:
	     cor 
	0.276122

	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -0.9765, df = 29, p-value = 0.3369
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.5010761  0.1877991
	sample estimates:
	       cor 
	-0.1784135 

