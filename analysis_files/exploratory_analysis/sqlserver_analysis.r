# Overall: 33.4% (close to suboptimal)
library(aod)
library(ggplot2)
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
x$MAXMPL[x$MAXMPL == 1100] <- 10000
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
> nrow(x)
[1] 88

x <- subset(x, x$MAXMPL < 1)
nrow(x)
[1] 38

cor.test(x$NUMPROCESSORS, x$ATP)

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -7.5747, df = 86, p-value = 3.804e-11
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.7435262 -0.4877802
	sample estimates:
	       cor 
	-0.6325954 

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -4.2541, df = 36, p-value = 0.0001427
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.7579277 -0.3173867
	sample estimates:
	       cor 
	-0.5783852

cor.test(x$PCTREAD, x$ATP)

	Pearson's product-moment correlation

	data:  x$PCTREAD and x$ATP
	t = 0.4193, df = 86, p-value = 0.676
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1658416  0.2522257
	sample estimates:
	       cor 
	0.04516962 

	Pearson's product-moment correlation

	data:  x$PCTREAD and x$ATP
	t = 1.242, df = 36, p-value = 0.2223
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1250902  0.4905922
	sample estimates:
	      cor 
	0.2026989 

cor.test(x$PK, x$ATP)

	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = 0.5515, df = 86, p-value = 0.5827
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1519674  0.2655054
	sample estimates:
	       cor 
	0.05936428 

	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = 1.1162, df = 36, p-value = 0.2717
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1452876  0.4748128
	sample estimates:
	      cor 
	0.1828903 

cor.test(x$PCTREAD*x$PK, x$ATP)

	Pearson's product-moment correlation

	data:  x$PCTREAD * x$PK and x$ATP
	t = 0.7299, df = 86, p-value = 0.4674
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.133167  0.283251
	sample estimates:
	       cor 
	0.07846363 

	Pearson's product-moment correlation

	data:  x$PCTREAD * x$PK and x$ATP
	t = 2.1094, df = 36, p-value = 0.04193
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.01339851 0.58890503
	sample estimates:
	      cor 
	0.3316613 

med.fit <- lm(ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.38009 -0.22652  0.03508  0.17922  0.52503 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.50489    0.06607   7.642 3.34e-11 ***
	NUMPROCESSORS -0.66247    0.08664  -7.646 3.28e-11 ***
	PK             0.04283    0.07603   0.563    0.575    
	PCTREAD        0.01422    0.08981   0.158    0.875    
	PK:PCTREAD     0.08637    0.13484   0.641    0.524    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2781 on 83 degrees of freedom
	Multiple R-squared:  0.4173,	Adjusted R-squared:  0.3892 
	F-statistic: 14.86 on 4 and 83 DF,  p-value: 3.375e-09

		### modified
		med.fit <- lm(ATP ~ NUMPROCESSORS + PK, data = x)
		summary(med.fit)

		Call:
		lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

		Residuals:
		     Min       1Q   Median       3Q      Max 
		-0.41171 -0.25002  0.08094  0.17229  0.51191 

		Coefficients:
			      Estimate Std. Error t value Pr(>|t|)    
		(Intercept)    0.50842    0.05675   8.959 6.54e-14 ***
		NUMPROCESSORS -0.65879    0.08607  -7.654 2.79e-11 ***
		PK             0.07101    0.05932   1.197    0.235    
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.2765 on 85 degrees of freedom
		Multiple R-squared:  0.4101,	Adjusted R-squared:  0.3962 
		F-statistic: 29.55 on 2 and 85 DF,  p-value: 1.809e-10

	### thrashing samples
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.44061 -0.29919  0.04708  0.23794  0.70013 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.68573    0.11172   6.138 6.43e-07 ***
	NUMPROCESSORS -1.55186    0.37135  -4.179 0.000202 ***
	PK             0.14345    0.13410   1.070 0.292512    
	PCTREAD        0.05728    0.15601   0.367 0.715856    
	PK:PCTREAD     0.18445    0.25318   0.729 0.471446    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3242 on 33 degrees of freedom
	Multiple R-squared:  0.4207,	Adjusted R-squared:  0.3505 
	F-statistic: 5.993 on 4 and 33 DF,  p-value: 0.0009711

		### modified
		med.fit <- lm(ATP ~ NUMPROCESSORS + PK, data = x)
		summary(med.fit)

		Call:
		lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

		Residuals:
		     Min       1Q   Median       3Q      Max 
		-0.50360 -0.30867  0.07961  0.21427  0.72867 

		Coefficients:
			      Estimate Std. Error t value Pr(>|t|)    
		(Intercept)    0.72290    0.09509   7.602 6.49e-09 ***
		NUMPROCESSORS -1.64489    0.36146  -4.551 6.18e-05 ***
		PK             0.19495    0.10643   1.832   0.0755 .  
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.3223 on 35 degrees of freedom
		Multiple R-squared:  0.3927,	Adjusted R-squared:  0.358 
		F-statistic: 11.32 on 2 and 35 DF,  p-value: 0.0001618

cor.test(x$PK, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 0.5657, df = 86, p-value = 0.573
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1504700  0.2669293
	sample estimates:
	       cor 
	0.06089123 

	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 0.62, df = 36, p-value = 0.5392
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2242646  0.4090307
	sample estimates:
	     cor 
	0.102788

cor.test(x$ATP, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -7.5987, df = 86, p-value = 3.405e-11
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.7444202 -0.4893045
	sample estimates:
	       cor 
	-0.6337948

	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = 15.9297, df = 36, p-value < 2.2e-16
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.8791465 0.9663913
	sample estimates:
	      cor 
	0.9358192

cor.test(x$NUMPROCESSORS, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = 10.317, df = 86, p-value < 2.2e-16
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.6328460 0.8246965
	sample estimates:
	     cor 
	0.743713 

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = -2.894, df = 36, p-value = 0.006422
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.6621591 -0.1332627
	sample estimates:
	       cor 
	-0.4344381 

cor.test(x$ACTROWPOOL, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$ACTROWPOOL and x$MAXMPL
	t = 0.377, df = 86, p-value = 0.7071
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1702715  0.2479522
	sample estimates:
	       cor 
	0.04061933 

	Pearson's product-moment correlation

	data:  x$ACTROWPOOL and x$MAXMPL
	t = -0.1084, df = 36, p-value = 0.9143
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.3358019  0.3033776
	sample estimates:
		cor 
	-0.01805696

cor.test(x$PCTREAD, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$PCTREAD and x$MAXMPL
	t = 0.5544, df = 86, p-value = 0.5808
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1516628  0.2657952
	sample estimates:
	       cor 
	0.05967496 

	Pearson's product-moment correlation

	data:  x$PCTREAD and x$MAXMPL
	t = 0.9341, df = 36, p-value = 0.3565
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1744252  0.4513239
	sample estimates:
	      cor 
	0.1538361

out.fit <- lm(MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-1.04898 -0.09558 -0.03215  0.28397  0.79327 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.21038    0.11943   1.762  0.08187 .  
	PK             0.04286    0.06747   0.635  0.52705    
	PCTREAD        0.06463    0.07530   0.858  0.39318    
	ACTROWPOOL     0.05514    0.11887   0.464  0.64398    
	ATP           -0.38377    0.12271  -3.127  0.00244 ** 
	NUMPROCESSORS  0.77885    0.12641   6.161 2.56e-08 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3115 on 82 degrees of freedom
	Multiple R-squared:  0.6039,	Adjusted R-squared:  0.5797 
	F-statistic:    25 on 5 and 82 DF,  p-value: 3.214e-15

		### modified
		out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
		summary(out.fit)

		Call:
		lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

		Residuals:
		     Min       1Q   Median       3Q      Max 
		-1.05892 -0.08923 -0.04090  0.30303  0.79376 

		Coefficients:
			      Estimate Std. Error t value Pr(>|t|)    
		(Intercept)    0.26417    0.08857   2.983  0.00374 ** 
		PK             0.03994    0.06695   0.597  0.55239    
		ATP           -0.37693    0.12141  -3.105  0.00260 ** 
		NUMPROCESSORS  0.78572    0.12521   6.275 1.46e-08 ***
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.3095 on 84 degrees of freedom
		Multiple R-squared:  0.5993,	Adjusted R-squared:  0.585 
		F-statistic: 41.87 on 3 and 84 DF,  p-value: < 2.2e-16

	### thrashing samples
	Call:
	lm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, 
	    data = x)

	Residuals:
	       Min         1Q     Median         3Q        Max 
	-0.0154698 -0.0054487  0.0007042  0.0031920  0.0196186 

	Coefficients:
		        Estimate Std. Error t value Pr(>|t|)    
	(Intercept)   -0.0007432  0.0050003  -0.149  0.88278    
	PK            -0.0058855  0.0028753  -2.047  0.04896 *  
	PCTREAD       -0.0026069  0.0031894  -0.817  0.41977    
	ACTROWPOOL     0.0017075  0.0049225   0.347  0.73095    
	ATP            0.0674563  0.0044013  15.327 2.71e-16 ***
	NUMPROCESSORS  0.0330180  0.0117094   2.820  0.00818 ** 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.008263 on 32 degrees of freedom
	Multiple R-squared:  0.9066,	Adjusted R-squared:  0.892 
	F-statistic: 62.12 on 5 and 32 DF,  p-value: 1.573e-15

		### modified
		out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
		summary(out.fit)

		Call:
		lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

		Residuals:
		       Min         1Q     Median         3Q        Max 
		-0.0144497 -0.0060193 -0.0001581  0.0028704  0.0209208 

		Coefficients:
				Estimate Std. Error t value Pr(>|t|)    
		(Intercept)   -0.0003941  0.0038988  -0.101  0.92008    
		PK            -0.0056292  0.0028055  -2.007  0.05281 .  
		ATP            0.0668184  0.0042564  15.698  < 2e-16 ***
		NUMPROCESSORS  0.0332778  0.0114833   2.898  0.00653 ** 
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.008117 on 34 degrees of freedom
		Multiple R-squared:  0.9042,	Adjusted R-squared:  0.8958 
		F-statistic:   107 on 3 and 34 DF,  p-value: < 2.2e-16

# update
x = rbind(sqlserver)
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTUPDATE = (x$PCTUPDATE/min(x$PCTUPDATE))/(max(x$PCTUPDATE)/min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
> nrow(x)
[1] 128
x <- subset(x, x$MAXMPL < 1)
nrow(x)
[1] 114

cor.test(x$NUMPROCESSORS, x$ATP)
	Pearson's product-moment correlation

data:  x$NUMPROCESSORS and x$ATP
t = -8.2603, df = 126, p-value = 1.703e-13
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.6947710 -0.4672225
sample estimates:
       cor 
-0.5926986

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -7.7248, df = 112, p-value = 5.152e-12
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.6978194 -0.4549896
	sample estimates:
	       cor 
	-0.5895696

cor.test(x$NUMPROCESSORS, x$MAXMPL)
		Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = 7.8611, df = 126, p-value = 1.467e-12
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.4443421 0.6795283
	sample estimates:
	      cor 
	0.5736409

		Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = 5.5261, df = 112, p-value = 2.158e-07
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.3049022 0.5960374
	sample estimates:
	      cor 
	0.4628616

cor.test(x$ATP, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -2.3952, df = 126, p-value = 0.01808
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.36885989 -0.03647759
	sample estimates:
	       cor 
	-0.2086871

		Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -1.3697, df = 112, p-value = 0.1735
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.30506953  0.05690166
	sample estimates:
	       cor 
	-0.1283564

