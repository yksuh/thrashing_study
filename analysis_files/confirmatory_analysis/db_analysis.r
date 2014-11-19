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
[1] 81
x <- subset(x, x$MAXMPL < 1)
> nrow(x)
[1] 25

> cor.test(x$NUMPROCESSORS, x$ATP)

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -2.4245, df = 79, p-value = 0.01761
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.45534515 -0.04754273
	sample estimates:
	       cor 
	-0.2631603

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -0.8822, df = 23, p-value = 0.3868
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.5376145  0.2307080
	sample estimates:
	       cor 
	-0.1809151

> cor.test(x$PK, x$ATP)

	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -0.5657, df = 79, p-value = 0.5732
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2780123  0.1570082
	sample estimates:
		cor 
	-0.06351875

	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -0.6858, df = 23, p-value = 0.4997
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.5082585  0.2685984
	sample estimates:
	       cor 
	-0.1415561

med.fit <- lm(ATP ~ NUMPROCESSORS + PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.24975 -0.18627 -0.08319 -0.02825  0.91680 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.31075    0.06620   4.694 1.13e-05 ***
	NUMPROCESSORS -0.22756    0.09491  -2.398   0.0189 *  
	PK            -0.03457    0.06723  -0.514   0.6086    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3013 on 78 degrees of freedom
	Multiple R-squared:  0.0724,	Adjusted R-squared:  0.04861 
	F-statistic: 3.044 on 2 and 78 DF,  p-value: 0.05335

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	      Min        1Q    Median        3Q       Max 
	-0.057670 -0.032077 -0.014526  0.009492  0.180007 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)   
	(Intercept)    0.07510    0.02324   3.232  0.00384 **
	NUMPROCESSORS -0.05327    0.05771  -0.923  0.36602   
	PK            -0.01749    0.02346  -0.746  0.46379   
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.05847 on 22 degrees of freedom
	Multiple R-squared:  0.05657,	Adjusted R-squared:  -0.0292 
	F-statistic: 0.6596 on 2 and 22 DF,  p-value: 0.527

cor.test(x$PK, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 0.7761, df = 79, p-value = 0.44
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1339098  0.2996413
	sample estimates:
	       cor 
	0.08698286

	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 0.6685, df = 23, p-value = 0.5104
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2719003  0.5056118
	sample estimates:
	      cor 
	0.1380636 

cor.test(x$ATP, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = 2.6679, df = 79, p-value = 0.009257
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.0737745 0.4759641
	sample estimates:
	      cor 
	0.2874928 

	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = 0.0988, df = 23, p-value = 0.9222
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.3776142  0.4123649
	sample estimates:
	       cor 
	0.02058871

cor.test(x$NUMPROCESSORS, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = 3.5906, df = 79, p-value = 0.000571
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.1701320 0.5480899
	sample estimates:
	      cor 
	0.3745669

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = -0.8673, df = 23, p-value = 0.3947
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.5354371  0.2336008
	sample estimates:
	      cor 
	-0.177956 

out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.84182 -0.35124  0.04841  0.34854  0.60476 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.25561    0.09407   2.717  0.00813 ** 
	PK             0.08911    0.08450   1.055  0.29491    
	ATP            0.60842    0.14207   4.283 5.27e-05 ***
	NUMPROCESSORS  0.60686    0.12339   4.918 4.84e-06 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.378 on 77 degrees of freedom
	Multiple R-squared:  0.3104,	Adjusted R-squared:  0.2835 
	F-statistic: 11.55 on 3 and 77 DF,  p-value: 2.473e-06

	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	      Min        1Q    Median        3Q       Max 
	-0.039700 -0.009515  0.000767  0.024693  0.033418 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)   
	(Intercept)    0.041838   0.011922   3.509  0.00209 **
	PK             0.005928   0.010036   0.591  0.56102   
	ATP            0.003423   0.090067   0.038  0.97004   
	NUMPROCESSORS -0.019146   0.024848  -0.771  0.44956   
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.0247 on 21 degrees of freedom
	Multiple R-squared:  0.04763,	Adjusted R-squared:  -0.08842 
	F-statistic: 0.3501 on 3 and 21 DF,  p-value: 0.7895

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
	    Min      1Q  Median      3Q     Max 
	-0.3252 -0.1701  0.1036  0.1356  0.4618 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.74978    0.02939   25.51   <2e-16 ***
	NUMPROCESSORS -0.84616    0.05101  -16.59   <2e-16 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1934 on 126 degrees of freedom
	Multiple R-squared:  0.6859,	Adjusted R-squared:  0.6834 
	F-statistic: 275.2 on 1 and 126 DF,  p-value: < 2.2e-16

cor.test(x$NUMPROCESSORS, x$MAXMPL)

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

	out.fit <- lm(MAXMPL ~ PK, data = x)
	summary(out.fit)
