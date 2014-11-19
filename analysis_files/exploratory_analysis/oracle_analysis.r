# Overall: 33.4% (close to suboptimal)
library(aod)
library(ggplot2)
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
#x$MAXMPL[x$MAXMPL == 1100] <- 100000
x$MAXMPL[x$MAXMPL == 1100] <- 10000
# oracle
oracle <- subset(x, x$DBMS=='oracle')
oracle_r <- subset(oracle, oracle$PCTREAD!=0)
oracle_r <- subset(oracle_r, select = -PCTUPDATE)
oracle_r$ATP = (oracle_r$ATP-min(oracle_r$ATP))/(max(oracle_r$ATP)-min(oracle_r$ATP))
oracle_r$MAXMPL = (oracle_r$MAXMPL-min(oracle_r$MAXMPL))/(max(oracle_r$MAXMPL)-min(oracle_r$MAXMPL))
oracle <- oracle_r
x = rbind(oracle)
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD/min(x$PCTREAD))/(max(x$PCTREAD)/min(x$PCTREAD))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
> nrow(x)
[1] 75

x <- subset(x, x$MAXMPL < 1)
> nrow(x)
[1] 35

cor.test(x$NUMPROCESSORS, x$ATP)

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = 1.8825, df = 73, p-value = 0.06376
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.01240278  0.42154098
	sample estimates:
	      cor 
	0.2151647

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = 2.0336, df = 33, p-value = 0.05009
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.0005300382 0.6002142097
	sample estimates:
	      cor 
	0.3337176 

cor.test(x$PCTREAD, x$ATP)

	Pearson's product-moment correlation

	data:  x$PCTREAD and x$ATP
	t = 0.2205, df = 73, p-value = 0.8261
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2023451  0.2512919
	sample estimates:
	       cor 
	0.02580165 

	Pearson's product-moment correlation

	data:  x$PCTREAD and x$ATP
	t = 0.0029, df = 33, p-value = 0.9977
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.3327956  0.3336974
	sample estimates:
		cor 
	0.000507219

cor.test(x$PK, x$ATP)

	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -7.2566, df = 73, p-value = 3.473e-10
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.7623094 -0.4927892
	sample estimates:
	       cor 
	-0.6473487

	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -3.9205, df = 33, p-value = 0.0004214
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.7551053 -0.2837687
	sample estimates:
	       cor 
	-0.5637082 

cor.test(x$PCTREAD*x$PK, x$ATP)

	Pearson's product-moment correlation

	data:  x$PCTREAD * x$PK and x$ATP
	t = -3.0265, df = 73, p-value = 0.003416
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.5213483 -0.1157011
	sample estimates:
	      cor 
	-0.333895

	Pearson's product-moment correlation

	data:  x$PCTREAD * x$PK and x$ATP
	t = -2.0434, df = 33, p-value = 0.04906
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.601237179 -0.002130605
	sample estimates:
	       cor 
	-0.3351392

med.fit <- lm(ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.23740 -0.09375 -0.00886  0.06367  0.68495 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.221700   0.040946   5.414 8.17e-07 ***
	NUMPROCESSORS  0.167109   0.053289   3.136   0.0025 ** 
	PK            -0.292843   0.050286  -5.824 1.60e-07 ***
	PCTREAD        0.009795   0.059924   0.163   0.8706    
	PK:PCTREAD    -0.010113   0.083149  -0.122   0.9035    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1635 on 70 degrees of freedom
	Multiple R-squared:  0.4918,	Adjusted R-squared:  0.4628 
	F-statistic: 16.94 on 4 and 70 DF,  p-value: 9.361e-10

	### thrashing samples
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.26709 -0.07913 -0.01125  0.02393  0.67582 

	Coefficients:
		        Estimate Std. Error t value Pr(>|t|)  
	(Intercept)    0.1990338  0.0766021   2.598   0.0144 *
	NUMPROCESSORS  0.2188824  0.1246439   1.756   0.0893 .
	PK            -0.2774642  0.1011975  -2.742   0.0102 *
	PCTREAD        0.0157000  0.0976530   0.161   0.8734  
	PK:PCTREAD     0.0004067  0.1617431   0.003   0.9980  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2117 on 30 degrees of freedom
	Multiple R-squared:  0.3828,	Adjusted R-squared:  0.3005 
	F-statistic: 4.652 on 4 and 30 DF,  p-value: 0.004843

	### modified
	med.fit <- lm(ATP ~ NUMPROCESSORS + PK, data = x)
	summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.27171 -0.08420 -0.00430  0.01784  0.68551 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.20489    0.06654   3.079 0.004239 ** 
	NUMPROCESSORS  0.21921    0.12026   1.823 0.077680 .  
	PK            -0.27638    0.07384  -3.743 0.000717 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2051 on 32 degrees of freedom
	Multiple R-squared:  0.3819,	Adjusted R-squared:  0.3433 
	F-statistic: 9.888 on 2 and 32 DF,  p-value: 0.0004534

cor.test(x$PK, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 3.042, df = 73, p-value = 0.003264
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.1173847 0.5225900
	sample estimates:
	      cor 
	0.3354105

	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 1.1012, df = 33, p-value = 0.2788
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1546837  0.4907262
	sample estimates:
	      cor 
	0.1882676 

cor.test(x$ATP, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -2.0045, df = 73, p-value = 0.04873
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.432926044 -0.001524101
	sample estimates:
	       cor 
	-0.2284069

	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -1.524, df = 33, p-value = 0.137
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.54325124  0.08399693
	sample estimates:
	       cor 
	-0.2564275 

cor.test(x$NUMPROCESSORS, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = 0.9399, df = 73, p-value = 0.3503
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.120602  0.328170
	sample estimates:
	     cor 
	0.109353 

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = 1.065, df = 33, p-value = 0.2946
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1607279  0.4860062
	sample estimates:
	     cor 
	0.182282 

cor.test(x$ACTROWPOOL, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$ACTROWPOOL and x$MAXMPL
	t = 0.0726, df = 73, p-value = 0.9423
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2188882  0.2350044
	sample estimates:
		cor 
	0.008495729 

	Pearson's product-moment correlation

	data:  x$ACTROWPOOL and x$MAXMPL
	t = -2.0431, df = 33, p-value = 0.0491
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.60120131 -0.00207443
	sample estimates:
	       cor 
	-0.3350893 

cor.test(x$PCTREAD, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$PCTREAD and x$MAXMPL
	t = -0.0843, df = 73, p-value = 0.9331
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2362954  0.2175864
	sample estimates:
		cor 
	-0.00986248 

	Pearson's product-moment correlation

	data:  x$PCTREAD and x$MAXMPL
	t = 0.4573, df = 33, p-value = 0.6505
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2607959  0.4019644
	sample estimates:
	       cor 
	0.07934656 

out.fit <- lm(MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, 
	    data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.6957 -0.3906  0.2078  0.3469  0.6521 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)  
	(Intercept)    0.34263    0.17419   1.967   0.0532 .
	PK             0.27002    0.15224   1.774   0.0805 .
	PCTREAD       -0.01578    0.12032  -0.131   0.8960  
	ACTROWPOOL     0.05186    0.20527   0.253   0.8013  
	ATP           -0.16543    0.35717  -0.463   0.6447  
	NUMPROCESSORS  0.14120    0.16536   0.854   0.3961  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.4731 on 69 degrees of freedom
	Multiple R-squared:  0.1224,	Adjusted R-squared:  0.05885 
	F-statistic: 1.925 on 5 and 69 DF,  p-value: 0.1012

		#### modified
		out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
		summary(out.fit)
	
		Call:
		lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

		Residuals:
		    Min      1Q  Median      3Q     Max 
		-0.7063 -0.3740  0.2230  0.3437  0.6531 

		Coefficients:
			      Estimate Std. Error t value Pr(>|t|)   
		(Intercept)     0.3653     0.1252   2.916  0.00474 **
		PK              0.2760     0.1482   1.862  0.06672 . 
		ATP            -0.1436     0.3412  -0.421  0.67519   
		NUMPROCESSORS   0.1359     0.1621   0.838  0.40457   
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.4667 on 71 degrees of freedom
		Multiple R-squared:  0.1214,	Adjusted R-squared:  0.0843 
		F-statistic: 3.271 on 3 and 71 DF,  p-value: 0.02609

	#### thrashing samples
	Call:
	lm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, 
	    data = x)

	Residuals:
	      Min        1Q    Median        3Q       Max 
	-0.030652 -0.014984 -0.006102  0.015756  0.046814 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)   
	(Intercept)    0.035808   0.012446   2.877  0.00746 **
	PK             0.003128   0.009688   0.323  0.74909   
	PCTREAD        0.004439   0.008193   0.542  0.59210   
	ACTROWPOOL    -0.018656   0.014146  -1.319  0.19753   
	ATP           -0.021961   0.020251  -1.084  0.28711   
	NUMPROCESSORS  0.017344   0.014451   1.200  0.23977   
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.02228 on 29 degrees of freedom
	Multiple R-squared:  0.2015,	Adjusted R-squared:  0.06386 
	F-statistic: 1.464 on 5 and 29 DF,  p-value: 0.2319

		#### modified
		out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
		summary(out.fit)

		Call:
		lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

		Residuals:
		      Min        1Q    Median        3Q       Max 
		-0.033284 -0.014650 -0.003122  0.017089  0.042244 

		Coefficients:
			       Estimate Std. Error t value Pr(>|t|)   
		(Intercept)    0.025418   0.008224   3.091   0.0042 **
		PK             0.002212   0.009612   0.230   0.8195   
		ATP           -0.030050   0.019190  -1.566   0.1275   
		NUMPROCESSORS  0.023310   0.013715   1.700   0.0992 . 
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.02226 on 31 degrees of freedom
		Multiple R-squared:  0.148,	Adjusted R-squared:  0.06549 
		F-statistic: 1.794 on 3 and 31 DF,  p-value: 0.1688

# oracle
x = rbind(oracle)
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTUPDATE = (x$PCTUPDATE/min(x$PCTUPDATE))/(max(x$PCTUPDATE)/min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
x <- subset(x, x$MAXMPL < 1)
nrow(x)

cor.test(x$NUMPROCESSORS, x$ATP)

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -0.2276, df = 122, p-value = 0.8203
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1962056  0.1562826
	sample estimates:
	       cor 
	-0.0206017 

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -5.5139, df = 64, p-value = 6.738e-07
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.7117675 -0.3772871
	sample estimates:
	       cor 
	-0.567498

cor.test(x$NUMPROCESSORS, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = -8.9964, df = 122, p-value = 3.729e-15
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.7269004 -0.5122432
	sample estimates:
	       cor 
	-0.631522

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = -7.2478, df = 64, p-value = 6.826e-10
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.7857529 -0.5126871
	sample estimates:
	       cor 
	-0.6714069

cor.test(x$ATP, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -5.8152, df = 122, p-value = 4.969e-08
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.5934347 -0.3154572
	sample estimates:
	       cor 
	-0.4658623

	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = 0.8319, df = 64, p-value = 0.4086
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1421611  0.3370263
	sample estimates:
	      cor 
	0.1034305
