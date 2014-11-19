# Overall: 33.4% (close to suboptimal)
library(aod)
library(ggplot2)
x = read.csv(file="cnfm.dat",head=TRUE,sep="\t")
x$MAXMPL[x$MAXMPL == 1100] <- 10000
# ATP normalization
# sqlserver
sqlserver <- subset(x, x$DBMS=='sqlserver')
sqlserver_r <- subset(sqlserver, sqlserver$PCTREAD!=0)
sqlserver_r <- subset(sqlserver_r, select = -PCTUPDATE)
sqlserver_r$ATP = (sqlserver_r$ATP-min(sqlserver_r$ATP))/(max(sqlserver_r$ATP)-min(sqlserver_r$ATP))
#sqlserver_r$MAXMPL = (sqlserver_r$MAXMPL-min(sqlserver_r$MAXMPL))/(max(sqlserver_r$MAXMPL)-min(sqlserver_r$MAXMPL))
sqlserver_r$MAXMPL <- 1
sqlserver <- sqlserver_r
#### gother each DBMS' samples
x = rbind(sqlserver)
#x <- x[!is.na(x$MAXMPL),]
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD/min(x$PCTREAD))/(max(x$PCTREAD)/min(x$PCTREAD))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
nrow(x)
[1] 84
x <- subset(x, x$MAXMPL < 1)
nrow(x)
0

cor.test(x$NUMPROCESSORS, x$ATP)

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -5.2759, df = 82, p-value = 1.056e-06
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.6478816 -0.3239837
	sample estimates:
	       cor 
	-0.5034117

cor.test(x$PK, x$ATP)

	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = 3.4017, df = 82, p-value = 0.001037
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.1484631 0.5263740
	sample estimates:
	      cor 
	0.3516649

med.fit <- lm(ATP ~ NUMPROCESSORS + PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.33185 -0.22863 -0.04253  0.18471  0.59255 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.27999    0.07219   3.879 0.000213 ***
	NUMPROCESSORS -0.46436    0.09420  -4.930  4.3e-06 ***
	PK             0.18551    0.06286   2.951 0.004139 ** 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2809 on 81 degrees of freedom
	Multiple R-squared:  0.3259,	Adjusted R-squared:  0.3093 
	F-statistic: 19.58 on 2 and 81 DF,  p-value: 1.157e-07

cor.test(x$NUMPROCESSORS, x$MAXMPL)

cor.test(x$PK, x$MAXMPL)

out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	       Min         1Q     Median         3Q        Max 
	-8.413e-15 -2.000e-18  1.900e-18  7.200e-18  7.788e-16 

	Coefficients:
		        Estimate Std. Error    t value Pr(>|t|)    
	(Intercept)    1.000e+00  2.746e-16  3.641e+15   <2e-16 ***
	PK            -4.244e-18  2.311e-16 -1.800e-02    0.985    
	ATP           -7.869e-16  3.882e-16 -2.027e+00    0.046 *  
	NUMPROCESSORS -1.131e-17  3.753e-16 -3.000e-02    0.976    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 9.814e-16 on 80 degrees of freedom
	Multiple R-squared:  0.5026,	Adjusted R-squared:  0.4839 
	F-statistic: 26.94 on 3 and 80 DF,  p-value: 3.829e-12

### update-only
library(aod)
library(ggplot2)
x = read.csv(file="cnfm.dat",head=TRUE,sep="\t")
x$MAXMPL[x$MAXMPL == 1100] <- 10000

# ATP normalization
# sqlserver
sqlserver <- subset(x, x$DBMS=='sqlserver')
sqlserver_w <- subset(sqlserver, sqlserver$PCTUPDATE!=0)
sqlserver_w <- subset(sqlserver_w, select = -PCTREAD)
sqlserver_w$ATP = (sqlserver_w$ATP-min(sqlserver_w$ATP))/(max(sqlserver_w$ATP)-min(sqlserver_w$ATP))
sqlserver_w$MAXMPL = (sqlserver_w$MAXMPL-min(sqlserver_w$MAXMPL))/(max(sqlserver_w$MAXMPL)-min(sqlserver_w$MAXMPL))
sqlserver <- sqlserver_w
x = rbind(sqlserver)
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTUPDATE = (x$PCTUPDATE/min(x$PCTUPDATE))/(max(x$PCTUPDATE)/min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))

nrow(x)
[1] 112
x <- subset(x, x$MAXMPL < 1)
> nrow(x)
[1] 86

> cor.test(x$NUMPROCESSORS, x$ATP)

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -7.1448, df = 110, p-value = 1.037e-10
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.6777546 -0.4214782
	sample estimates:
	       cor 
	-0.5630028

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -11.8386, df = 84, p-value < 2.2e-16
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.8587370 -0.6953531
	sample estimates:
	       cor 
	-0.7907314

> med.fit <- lm(ATP ~ NUMPROCESSORS, data = x)
> summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.2420 -0.2317 -0.1210  0.1008  0.6083 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.46205    0.04838   9.550 4.20e-16 ***
	NUMPROCESSORS -0.56281    0.07877  -7.145 1.04e-10 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2753 on 110 degrees of freedom
	Multiple R-squared:  0.317,	Adjusted R-squared:  0.3108 
	F-statistic: 51.05 on 1 and 110 DF,  p-value: 1.037e-10

	Call:
	lm(formula = ATP ~ NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.04429  0.00710  0.01016  0.01329  0.03867 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.099744   0.005661   17.62   <2e-16 ***
	NUMPROCESSORS -0.109868   0.009280  -11.84   <2e-16 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.02524 on 84 degrees of freedom
	Multiple R-squared:  0.6253,	Adjusted R-squared:  0.6208 
	F-statistic: 140.2 on 1 and 84 DF,  p-value: < 2.2e-16

> cor.test(x$NUMPROCESSORS, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = -0.7, df = 110, p-value = 0.4854
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2490707  0.1204515
	sample estimates:
		cor 
	-0.06659263

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = 11.8737, df = 84, p-value < 2.2e-16
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.6965589 0.8593497
	sample estimates:
	      cor 
	0.7916061

> cor.test(x$ATP, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = 10.5478, df = 110, p-value < 2.2e-16
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.6028836 0.7906361
	sample estimates:
	     cor 
	0.709112

	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -19.6677, df = 84, p-value < 2.2e-16
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.9381259 -0.8596284
	sample estimates:
	       cor 
	-0.9064148 

out.fit <- lm(MAXMPL ~ ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.27892 -0.10444  0.00755  0.02391  0.65047 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)   -0.24479    0.05621  -4.355 3.02e-05 ***
	ATP            1.20038    0.08191  14.655  < 2e-16 ***
	NUMPROCESSORS  0.59432    0.08188   7.258 6.10e-11 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2365 on 109 degrees of freedom
	Multiple R-squared:  0.6648,	Adjusted R-squared:  0.6587 
	F-statistic: 108.1 on 2 and 109 DF,  p-value: < 2.2e-16

	Call:
	lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	Residuals:
	      Min        1Q    Median        3Q       Max 
	-0.040658 -0.000317  0.002692  0.003474  0.013226 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.054246   0.004046  13.409  < 2e-16 ***
	ATP           -0.371489   0.035982 -10.324  < 2e-16 ***
	NUMPROCESSORS  0.013780   0.005000   2.756  0.00719 ** 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.008323 on 83 degrees of freedom
	Multiple R-squared:  0.8365,	Adjusted R-squared:  0.8326 
	F-statistic: 212.4 on 2 and 83 DF,  p-value: < 2.2e-16
