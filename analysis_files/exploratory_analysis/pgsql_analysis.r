# Overall: 33.4% (close to suboptimal)
library(aod)
library(ggplot2)
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
#x$MAXMPL[x$MAXMPL == 1100] <- 100000
x$MAXMPL[x$MAXMPL == 1100] <- 10000
# pgsql
pgsql <- subset(x, x$DBMS=='pgsql')
pgsql_r <- subset(pgsql, pgsql$PCTREAD!=0)
pgsql_r <- subset(pgsql_r, select = -PCTUPDATE)
pgsql_r$ATP = (pgsql_r$ATP-min(pgsql_r$ATP))/(max(pgsql_r$ATP)-min(pgsql_r$ATP))
pgsql_r$MAXMPL = (pgsql_r$MAXMPL-min(pgsql_r$MAXMPL))/(max(pgsql_r$MAXMPL)-min(pgsql_r$MAXMPL))
pgsql <- pgsql_r
#### gother each DBMS' samples
x = rbind(pgsql)
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD/min(x$PCTREAD))/(max(x$PCTREAD)/min(x$PCTREAD))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))

> nrow(x)
[1] 80
x <- subset(x, x$MAXMPL < 1)
> nrow(x)
[1] 40

cor.test(x$NUMPROCESSORS, x$ATP)

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -1.7557, df = 78, p-value = 0.08307
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.39765930  0.02584602
	sample estimates:
	       cor 
	-0.1949781

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -3.0644, df = 38, p-value = 0.004
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.6645043 -0.1551416
	sample estimates:
	       cor 
	-0.4451382 


cor.test(x$PCTREAD, x$ATP)

	Pearson's product-moment correlation

	data:  x$PCTREAD and x$ATP
	t = 0.6242, df = 78, p-value = 0.5343
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1515686  0.2857862
	sample estimates:
	       cor 
	0.07049592 

	Pearson's product-moment correlation

	data:  x$PCTREAD and x$ATP
	t = 0.1865, df = 38, p-value = 0.853
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2839416  0.3385625
	sample estimates:
	      cor 
	0.0302427 

cor.test(x$PK, x$ATP)

	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -6.9642, df = 78, p-value = 9.215e-10
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.7384456 -0.4623806
	sample estimates:
	      cor 
	-0.619192 

	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -6.6895, df = 38, p-value = 6.491e-08
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.8517667 -0.5498189
	sample estimates:
	       cor 
	-0.7353774 

cor.test(x$PCTREAD*x$PK, x$ATP)

	Pearson's product-moment correlation

	data:  x$PCTREAD * x$PK and x$ATP
	t = -1.4789, df = 78, p-value = 0.1432
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.37138883  0.05662344
	sample estimates:
	       cor 
	-0.1651481 

	Pearson's product-moment correlation

	data:  x$PCTREAD * x$PK and x$ATP
	t = -2.8224, df = 38, p-value = 0.007543
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.6442562 -0.1203972
	sample estimates:
	       cor 
	-0.4162935

med.fit <- lm(ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.30867 -0.16398 -0.02276  0.16471  0.56750 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.60662    0.04893  12.399  < 2e-16 ***
	NUMPROCESSORS -0.10792    0.06507  -1.658   0.1014    
	PK            -0.42228    0.06093  -6.931 1.25e-09 ***
	PCTREAD       -0.04124    0.06749  -0.611   0.5430    
	PK:PCTREAD     0.23691    0.10305   2.299   0.0243 *  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2045 on 75 degrees of freedom
	Multiple R-squared:  0.4524,	Adjusted R-squared:  0.4232 
	F-statistic: 15.49 on 4 and 75 DF,  p-value: 2.798e-09

	#### modified
	med.fit <- lm(ATP ~ NUMPROCESSORS + PK, data = x)
	summary(med.fit)
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.26870 -0.18770 -0.02657  0.18174  0.51704 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.59204    0.04429  13.369  < 2e-16 ***
	NUMPROCESSORS -0.10818    0.06701  -1.614    0.111    
	PK            -0.32983    0.04801  -6.870 1.46e-09 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2106 on 77 degrees of freedom
	Multiple R-squared:  0.4036,	Adjusted R-squared:  0.3881 
	F-statistic: 26.05 on 2 and 77 DF,  p-value: 2.283e-09

	### thrashing samples
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK, 
	    data = x)

	Residuals:
	      Min        1Q    Median        3Q       Max 
	-0.242422 -0.078291  0.000132  0.110569  0.177485 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.79096    0.04741  16.683  < 2e-16 ***
	NUMPROCESSORS -0.43470    0.06306  -6.894 5.24e-08 ***
	PK            -0.57359    0.06703  -8.557 4.24e-10 ***
	PCTREAD       -0.05734    0.04385  -1.308    0.199    
	PK:PCTREAD     0.07765    0.11339   0.685    0.498    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1171 on 35 degrees of freedom
	Multiple R-squared:  0.8057,	Adjusted R-squared:  0.7835 
	F-statistic: 36.29 on 4 and 35 DF,  p-value: 5.315e-12

	#### modified
	med.fit <- lm(ATP ~ NUMPROCESSORS + PK, data = x)
	summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	      Min        1Q    Median        3Q       Max 
	-0.221681 -0.082304 -0.006019  0.092218  0.192903 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.75916    0.04056  18.716  < 2e-16 ***
	NUMPROCESSORS -0.42405    0.06231  -6.805 5.16e-08 ***
	PK            -0.53991    0.05184 -10.415 1.50e-12 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1167 on 37 degrees of freedom
	Multiple R-squared:  0.796,	Adjusted R-squared:  0.785 
	F-statistic: 72.21 on 2 and 37 DF,  p-value: 1.684e-13

cor.test(x$PK, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 5.6763, df = 78, p-value = 2.253e-07
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.3642267 0.6796524
	sample estimates:
	      cor 
	0.5406752

	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 3.0327, df = 38, p-value = 0.004352
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.1506454 0.6619255
	sample estimates:
	      cor 
	0.4414391

cor.test(x$ATP, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -1.4226, df = 78, p-value = 0.1588
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.36595608  0.06288832
	sample estimates:
	       cor 
	-0.1590259

	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -2.1776, df = 38, p-value = 0.03572
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.58399210 -0.02406284
	sample estimates:
	       cor 
	-0.3330755 

cor.test(x$NUMPROCESSORS, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = -1.3456, df = 78, p-value = 0.1823
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.3584719  0.0714638
	sample estimates:
	       cor 
	-0.1506181

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = 1.3401, df = 38, p-value = 0.1882
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1061011  0.4914196
	sample estimates:
	      cor 
	0.2124293

cor.test(x$ACTROWPOOL, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$ACTROWPOOL and x$MAXMPL
	t = -0.2228, df = 78, p-value = 0.8243
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2435839  0.1955840
	sample estimates:
		cor 
	-0.02521655 

	Pearson's product-moment correlation

	data:  x$ACTROWPOOL and x$MAXMPL
	t = -0.7494, df = 38, p-value = 0.4582
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.4165337  0.1982799
	sample estimates:
	       cor 
	-0.1206836 

cor.test(x$PCTREAD, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$PCTREAD and x$MAXMPL
	t = -1.2654, df = 78, p-value = 0.2095
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.35062072  0.08039209
	sample estimates:
	     cor 
	-0.14183 

	Pearson's product-moment correlation

	data:  x$PCTREAD and x$MAXMPL
	t = -1.0073, df = 38, p-value = 0.3202
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.4501624  0.1581886
	sample estimates:
	       cor 
	-0.1612675 

out.fit <- lm(MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.78475 -0.26554 -0.01205  0.25292  0.78623 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.22908    0.18012   1.272   0.2074    
	PK             0.73193    0.11435   6.401 1.26e-08 ***
	PCTREAD       -0.20903    0.09875  -2.117   0.0376 *  
	ACTROWPOOL    -0.06385    0.15714  -0.406   0.6857    
	ATP            0.51438    0.21424   2.401   0.0189 *  
	NUMPROCESSORS -0.21568    0.12705  -1.698   0.0938 .  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3923 on 74 degrees of freedom
	Multiple R-squared:  0.405,	Adjusted R-squared:  0.3649 
	F-statistic: 10.08 on 5 and 74 DF,  p-value: 2.199e-07

		### modified
		out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
		summary(out.fit)
		Call:
		lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

		Residuals:
		     Min       1Q   Median       3Q      Max 
		-0.72299 -0.25869 -0.03447  0.21619  0.83960 

		Coefficients:
			      Estimate Std. Error t value Pr(>|t|)    
		(Intercept)     0.1528     0.1529   0.999   0.3208    
		PK              0.7036     0.1155   6.091 4.27e-08 ***
		ATP             0.4526     0.2159   2.096   0.0394 *  
		NUMPROCESSORS  -0.2267     0.1291  -1.756   0.0831 .  
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.399 on 76 degrees of freedom
		Multiple R-squared:  0.3681,	Adjusted R-squared:  0.3431 
		F-statistic: 14.76 on 3 and 76 DF,  p-value: 1.159e-07

	### thrashing samples
	Call:
	lm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, 
	    data = x)

	Residuals:
	      Min        1Q    Median        3Q       Max 
	-0.031621 -0.010799 -0.005503  0.013499  0.056577 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)   
	(Intercept)   -0.025443   0.028451  -0.894  0.37745   
	PK             0.057317   0.019152   2.993  0.00512 **
	PCTREAD       -0.002936   0.007399  -0.397  0.69399   
	ACTROWPOOL    -0.005935   0.012493  -0.475  0.63779   
	ATP            0.049709   0.030772   1.615  0.11547   
	NUMPROCESSORS  0.039809   0.017708   2.248  0.03117 * 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.02104 on 34 degrees of freedom
	Multiple R-squared:  0.3309,	Adjusted R-squared:  0.2325 
	F-statistic: 3.363 on 5 and 34 DF,  p-value: 0.01417

		### modified
		out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
		summary(out.fit)

		Call:
		lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

		Residuals:
		      Min        1Q    Median        3Q       Max 
		-0.032584 -0.009275 -0.006267  0.015377  0.056731 

		Coefficients:
			      Estimate Std. Error t value Pr(>|t|)   
		(Intercept)   -0.03498    0.02311  -1.514  0.13885   
		PK             0.06018    0.01810   3.324  0.00205 **
		ATP            0.05473    0.02895   1.890  0.06678 . 
		NUMPROCESSORS  0.04309    0.01647   2.617  0.01289 * 
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.02055 on 36 degrees of freedom
		Multiple R-squared:  0.3237,	Adjusted R-squared:  0.2673 
		F-statistic: 5.743 on 3 and 36 DF,  p-value: 0.002565

# update
x = rbind(pgsql)
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTUPDATE = (x$PCTUPDATE/min(x$PCTUPDATE))/(max(x$PCTUPDATE)/min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
> nrow(x)
[1] 111
x <- subset(x, x$MAXMPL < 1)
nrow(x)
[1] 76

cor.test(x$NUMPROCESSORS, x$ATP)

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -0.2143, df = 109, p-value = 0.8307
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2061243  0.1665100
	sample estimates:
	       cor 
	-0.0205198

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = 0.0947, df = 74, p-value = 0.9248
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2149768  0.2358824
	sample estimates:
	      cor 
	0.0110125 

cor.test(x$NUMPROCESSORS, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = -4.116, df = 109, p-value = 7.518e-05
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.5177641 -0.1936098
	sample estimates:
	      cor 
	-0.366767

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = 1.046, df = 74, p-value = 0.299
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1076841  0.3369870
	sample estimates:
	      cor 
	0.1207018

cor.test(x$ATP, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -0.3186, df = 109, p-value = 0.7506
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2156691  0.1567819
	sample estimates:
		cor 
	-0.03050238

	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -1.5226, df = 74, p-value = 0.1321
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.38463295  0.05325671
	sample estimates:
	       cor 
	-0.1742916 

