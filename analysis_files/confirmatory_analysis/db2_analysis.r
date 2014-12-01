# Overall: 33.4% (close to suboptimal)
library(aod)
library(ggplot2)
x = read.csv(file="cnfm.dat",head=TRUE,sep="\t")
x$MAXMPL[x$MAXMPL == 1100] <- 10000
# ATP normalization
# db2
db2 <- subset(x, x$DBMS=='db2')
db2_r <- subset(db2, db2$PCTREAD!=0)
db2_r <- subset(db2_r, select = -PCTUPDATE)
db2_r$ATP = (db2_r$ATP-min(db2_r$ATP))/(max(db2_r$ATP)-min(db2_r$ATP))
db2_r$MAXMPL = (db2_r$MAXMPL-min(db2_r$MAXMPL))/(max(db2_r$MAXMPL)-min(db2_r$MAXMPL))
db2 <- db2_r
x = rbind(db2)
#x <- x[!is.na(x$MAXMPL),]
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD/min(x$PCTREAD))/(max(x$PCTREAD)/min(x$PCTREAD))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
> nrow(x)
[1] 105
x <- subset(x, x$MAXMPL < 1)
> nrow(x)
[1] 34

> cor.test(x$NUMPROCESSORS, x$ATP)

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -1.87, df = 103, p-value = 0.06432
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.36035763  0.01083344
	sample estimates:
	       cor 
	-0.1812081

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = 0.6464, df = 32, p-value = 0.5226
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2336096  0.4349907
	sample estimates:
	      cor 
	0.1135244

> cor.test(x$PK, x$ATP)

	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -0.2854, df = 103, p-value = 0.7759
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2185944  0.1644444
	sample estimates:
		cor 
	-0.02810676

	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -1.2465, df = 32, p-value = 0.2216
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.5158238  0.1326213
	sample estimates:
	       cor 
	-0.2151955

med.fit <- lm(ATP ~ NUMPROCESSORS + PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.26017 -0.19297 -0.12664 -0.03072  0.87336 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.30043    0.06736   4.460 2.11e-05 ***
	NUMPROCESSORS -0.17380    0.09351  -1.859    0.066 .  
	PK            -0.01669    0.06202  -0.269    0.788    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.317 on 102 degrees of freedom
	Multiple R-squared:  0.03352,	Adjusted R-squared:  0.01457 
	F-statistic: 1.769 on 2 and 102 DF,  p-value: 0.1757

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.11439 -0.05065 -0.02789  0.01636  0.66815 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)
	(Intercept)    0.07136    0.04812   1.483    0.148
	NUMPROCESSORS  0.06413    0.09087   0.706    0.486
	PK            -0.05964    0.04712  -1.266    0.215

	Residual standard error: 0.1373 on 31 degrees of freedom
	Multiple R-squared:  0.06139,	Adjusted R-squared:  0.0008308 
	F-statistic: 1.014 on 2 and 31 DF,  p-value: 0.3746

cor.test(x$PK, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 0.4652, df = 103, p-value = 0.6428
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1471722  0.2353842
	sample estimates:
	       cor 
	0.04578456

	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = -0.1346, df = 32, p-value = 0.8938
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.3590664  0.3169260
	sample estimates:
	       cor 
	-0.0237893

cor.test(x$ATP, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = 3.035, df = 103, p-value = 0.003046
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.1003557 0.4532837
	sample estimates:
	    cor 
	0.28651

	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = 0.3537, df = 32, p-value = 0.7259
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2817145  0.3922838
	sample estimates:
	       cor 
	0.06239532

cor.test(x$NUMPROCESSORS, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = 3.1795, df = 103, p-value = 0.001949
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.1138171 0.4640364
	sample estimates:
	      cor 
	0.2989606

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = -0.4133, df = 32, p-value = 0.6821
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.4011473  0.2720018
	sample estimates:
		cor 
	-0.07286622 

out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-1.0134 -0.3859  0.1517  0.3030  0.5854 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.30061    0.09449   3.181 0.001947 ** 
	PK             0.04676    0.07962   0.587 0.558340    
	ATP            0.50015    0.12706   3.936 0.000152 ***
	NUMPROCESSORS  0.49244    0.12201   4.036 0.000106 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.4068 on 101 degrees of freedom
	Multiple R-squared:  0.2121,	Adjusted R-squared:  0.1887 
	F-statistic: 9.062 on 3 and 101 DF,  p-value: 2.28e-05

	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	      Min        1Q    Median        3Q       Max 
	-0.042128 -0.025677 -0.001356  0.026566  0.034557 

	Coefficients:
		        Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.0421276  0.0095967   4.390  0.00013 ***
	PK            -0.0002599  0.0093125  -0.028  0.97792    
	ATP            0.0130038  0.0346128   0.376  0.70979    
	NUMPROCESSORS -0.0077687  0.0176530  -0.440  0.66304    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.02645 on 30 degrees of freedom
	Multiple R-squared:  0.01039,	Adjusted R-squared:  -0.08857 
	F-statistic: 0.105 on 3 and 30 DF,  p-value: 0.9565
##### logistic by per-DBMS ####
x = rbind(db2)
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
X2 = 27.2, df = 3, P(> X2) = 5.4e-06

> 1-out.fit$deviance/out.fit$null.deviance
[1] 0.2120741

### update-only
library(aod)
library(ggplot2)
x = read.csv(file="cnfm.dat",head=TRUE,sep="\t")
x$MAXMPL[x$MAXMPL == 1100] <- 10000
# ATP normalization
# db2
db2 <- subset(x, x$DBMS=='db2')
db2_w <- subset(db2, db2$PCTUPDATE!=0)
db2_w <- subset(db2_w, select = -PCTREAD)
db2_w$ATP = (db2_w$ATP-min(db2_w$ATP))/(max(db2_w$ATP)-min(db2_w$ATP))
db2_w$MAXMPL = (db2_w$MAXMPL-min(db2_w$MAXMPL))/(max(db2_w$MAXMPL)-min(db2_w$MAXMPL))
db2 <- db2_w
x = rbind(db2)
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTUPDATE = (x$PCTUPDATE/min(x$PCTUPDATE))/(max(x$PCTUPDATE)/min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))

nrow(x)
[1] 128
x <- subset(x, x$MAXMPL < 1)
nrow(x)
[1] 2

cor.test(x$NUMPROCESSORS, x$ATP)

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = 1.7663, df = 158, p-value = 0.07928
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.01636036  0.28809032
	sample estimates:
	      cor 
	0.1391516
	
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -16.5882, df = 126, p-value < 2.2e-16
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.8758556 -0.7645508
	sample estimates:
	       cor 
	-0.8282014

med.fit <- lm(ATP ~ NUMPROCESSORS, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.03917 -0.02881 -0.01822 -0.00230  0.97119 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)  
	(Intercept)   -0.002582   0.014571  -0.177   0.8596  
	NUMPROCESSORS  0.041854   0.023696   1.766   0.0793 .
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.09596 on 158 degrees of freedom
	Multiple R-squared:  0.01936,	Adjusted R-squared:  0.01316 
	F-statistic:  3.12 on 1 and 158 DF,  p-value: 0.07928

	Call:
	lm(formula = ATP ~ NUMPROCESSORS, data = x)

	Residuals:
	      33       81       95      192      213 
	 0.07123 -0.31154  0.64405 -0.14245 -0.26129 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)
	(Intercept)    -0.2842     0.6353  -0.447    0.685
	NUMPROCESSORS   0.8535     1.0046   0.850    0.458

	Residual standard error: 0.4493 on 3 degrees of freedom
	Multiple R-squared:  0.1939,	Adjusted R-squared:  -0.07473 
	F-statistic: 0.7218 on 1 and 3 DF,  p-value: 0.458

cor.test(x$NUMPROCESSORS, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = -1.315, df = 3, p-value = 0.28
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.9696504  0.5950147
	sample estimates:
	       cor 
	-0.6046914

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = 0.393, df = 126, p-value = 0.695
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1393860  0.2072628
	sample estimates:
	       cor 
	0.03499083

cor.test(x$ATP, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -1.6393, df = 3, p-value = 0.1997
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.9770894  0.4951930
	sample estimates:
	       cor 
	-0.6873877

	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -0.7047, df = 126, p-value = 0.4823
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2336426  0.1120970
	sample estimates:
		cor 
	-0.06265224 


out.fit <- lm(MAXMPL ~ ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	Residuals:
	       33        81        95       192       213 
	-0.001453 -0.031284 -0.001584  0.002905  0.031415 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)
	(Intercept)    0.08665    0.04594   1.886    0.200
	ATP           -0.04165    0.04042  -1.030    0.411
	NUMPROCESSORS -0.05789    0.07834  -0.739    0.537

	Residual standard error: 0.03145 on 2 degrees of freedom
	Multiple R-squared:  0.5856,	Adjusted R-squared:  0.1713 
	F-statistic: 1.413 on 2 and 2 DF,  p-value: 0.4144

	Call:
	lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.99547  0.00632  0.01402  0.02378  0.03232 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    1.00738    0.04699  21.439   <2e-16 ***
	ATP           -0.03863    0.05736  -0.673    0.502    
	NUMPROCESSORS -0.01980    0.05860  -0.338    0.736    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1245 on 125 degrees of freedom
	Multiple R-squared:  0.004834,	Adjusted R-squared:  -0.01109 
	F-statistic: 0.3036 on 2 and 125 DF,  p-value: 0.7387

