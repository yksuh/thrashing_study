# Overall: 33.4% (close to suboptimal)
library(aod)
library(ggplot2)
x = read.csv(file="cnfm.dat",head=TRUE,sep="\t")
x$MAXMPL[x$MAXMPL == 1100] <- 10000
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
> nrow(x)
[1] 78
x <- subset(x, x$MAXMPL < 1)
> nrow(x)
[1] 41


> cor.test(x$NUMPROCESSORS, x$ATP)

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -2.8864, df = 76, p-value = 0.00507
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.5017530 -0.0986896
	sample estimates:
	       cor 
	-0.3143175 

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -0.9138, df = 39, p-value = 0.3664
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.4331435  0.1704563
	sample estimates:
	       cor 
	-0.1447869 

> cor.test(x$PK, x$ATP)

	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -1.2677, df = 76, p-value = 0.2088
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.35506570  0.08122656
	sample estimates:
	       cor 
	-0.1439053

	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -1.2131, df = 39, p-value = 0.2324
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.4707261  0.1242482
	sample estimates:
	       cor 
	-0.1906915 

med.fit <- lm(ATP ~ NUMPROCESSORS + PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.33281 -0.15313 -0.03838  0.06913  0.67720 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.46225    0.06111   7.564 8.03e-11 ***
	NUMPROCESSORS -0.25536    0.08227  -3.104  0.00269 ** 
	PK            -0.09752    0.05740  -1.699  0.09347 .  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2509 on 75 degrees of freedom
	Multiple R-squared:  0.1322,	Adjusted R-squared:  0.1091 
	F-statistic: 5.712 on 2 and 75 DF,  p-value: 0.004907

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.18405 -0.11916 -0.03339  0.08423  0.42344 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.27190    0.04874   5.578 2.16e-06 ***
	NUMPROCESSORS -0.08303    0.06700  -1.239    0.223    
	PK            -0.06649    0.04516  -1.472    0.149    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1404 on 38 degrees of freedom
	Multiple R-squared:  0.07379,	Adjusted R-squared:  0.02505 
	F-statistic: 1.514 on 2 and 38 DF,  p-value: 0.233

cor.test(x$PK, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 0.0047, df = 76, p-value = 0.9962
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2220164  0.2230450
	sample estimates:
		cor 
	0.000541104

	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = -0.8516, df = 39, p-value = 0.3996
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.4250986  0.1800143
	sample estimates:
	       cor 
	-0.1351192

> cor.test(x$ATP, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = 3.0968, df = 76, p-value = 0.00274
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.1212394 0.5186367
	sample estimates:
	      cor 
	0.3347391

	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -2.1377, df = 39, p-value = 0.03887
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.57428925 -0.01800129
	sample estimates:
	       cor 
	-0.3238582

out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.6722 -0.4107 -0.1593  0.4263  0.8134 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)     0.0542     0.1452   0.373 0.709994    
	PK              0.0888     0.1047   0.848 0.398960    
	ATP             0.7769     0.2066   3.760 0.000337 ***
	NUMPROCESSORS   0.3486     0.1564   2.229 0.028838 *  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.449 on 74 degrees of freedom
	Multiple R-squared:  0.1702,	Adjusted R-squared:  0.1366 
	F-statistic: 5.059 on 3 and 74 DF,  p-value: 0.003049

	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	      Min        1Q    Median        3Q       Max 
	-0.039808 -0.018693  0.002603  0.015422  0.037233 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.048339   0.010359   4.666 3.93e-05 ***
	PK            -0.007345   0.007317  -1.004    0.322    
	ATP           -0.054139   0.025563  -2.118    0.041 *  
	NUMPROCESSORS  0.011825   0.010769   1.098    0.279    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.02212 on 37 degrees of freedom
	Multiple R-squared:  0.1721,	Adjusted R-squared:  0.105 
	F-statistic: 2.564 on 3 and 37 DF,  p-value: 0.06942

### update-only
library(aod)
library(ggplot2)
x = read.csv(file="cnfm.dat",head=TRUE,sep="\t")
x$MAXMPL[x$MAXMPL == 1100] <- 10000
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
[1] 128
x <- subset(x, x$MAXMPL < 1)
nrow(x)
[1] 22

cor.test(x$NUMPROCESSORS, x$ATP)

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -1.2172, df = 126, p-value = 0.2258
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.27616531  0.06698258
	sample estimates:
	      cor 
	-0.107801 

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -8.5385, df = 20, p-value = 4.2e-08
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.9519294 -0.7409840
	sample estimates:
	       cor 
	-0.8858488 

> med.fit <- lm(ATP ~ NUMPROCESSORS, data = x)
> summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.5075 -0.2716  0.0744  0.2986  0.4159 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.60970    0.04856  12.555   <2e-16 ***
	NUMPROCESSORS -0.10258    0.08428  -1.217    0.226    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3195 on 126 degrees of freedom
	Multiple R-squared:  0.01162,	Adjusted R-squared:  0.003777 
	F-statistic: 1.481 on 1 and 126 DF,  p-value: 0.2258

	Call:
	lm(formula = ATP ~ NUMPROCESSORS, data = x)

	Residuals:
	      Min        1Q    Median        3Q       Max 
	-0.135321 -0.000147 -0.000082  0.000019  0.131344 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.25680    0.02570   9.992 3.21e-09 ***
	NUMPROCESSORS -0.25656    0.03005  -8.538 4.20e-08 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.05492 on 20 degrees of freedom
	Multiple R-squared:  0.7847,	Adjusted R-squared:  0.774 
	F-statistic: 72.91 on 1 and 20 DF,  p-value: 4.2e-08

cor.test(x$NUMPROCESSORS, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = -4.9755, df = 126, p-value = 2.086e-06
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.5407371 -0.2492263
	sample estimates:
	       cor 
	-0.4052312

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = -4.4391, df = 20, p-value = 0.0002521
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.8682164 -0.4023888
	sample estimates:
	       cor 
	-0.7044816 

cor.test(x$ATP, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = 11.5311, df = 126, p-value < 2.2e-16
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.6201327 0.7916475
	sample estimates:
	      cor 
	0.7165535

	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = 4.0828, df = 20, p-value = 0.0005797
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.3529508 0.8532828
	sample estimates:
	      cor 
	0.6742292 

out.fit <- lm(MAXMPL ~ ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.73297 -0.15639 -0.00277  0.16070  0.41856 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.55641    0.05285  10.528  < 2e-16 ***
	ATP            0.79562    0.06462  12.312  < 2e-16 ***
	NUMPROCESSORS -0.36904    0.06149  -6.002 1.97e-08 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2318 on 125 degrees of freedom
	Multiple R-squared:  0.6223,	Adjusted R-squared:  0.6162 
	F-statistic:   103 on 2 and 125 DF,  p-value: < 2.2e-16

	### modified
	> out.fit <- lm(MAXMPL ~ NUMPROCESSORS, data = x)
	> summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.98517  0.01483  0.07116  0.18383  0.40916 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    1.04150    0.05219  19.956  < 2e-16 ***
	NUMPROCESSORS -0.45066    0.09057  -4.976 2.09e-06 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3434 on 126 degrees of freedom
	Multiple R-squared:  0.1642,	Adjusted R-squared:  0.1576 
	F-statistic: 24.76 on 1 and 126 DF,  p-value: 2.086e-06

	Call:
	lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	Residuals:
	      Min        1Q    Median        3Q       Max 
	-0.037513 -0.003785 -0.003780  0.006318  0.021419 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)
	(Intercept)    0.02928    0.01725   1.697    0.106
	ATP            0.04120    0.06132   0.672    0.510
	NUMPROCESSORS -0.02550    0.01776  -1.436    0.167

	Residual standard error: 0.01506 on 19 degrees of freedom
	Multiple R-squared:  0.508,	Adjusted R-squared:  0.4562 
	F-statistic: 9.808 on 2 and 19 DF,  p-value: 0.001185

