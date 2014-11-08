
> cor(x$NUMPROCESSORS, x$ATP)
[1] -0.1262903
> cor(x$PCTREAD, x$ATP)
[1] 0.05245677
> cor(x$PK, x$ATP)
[1] -0.2166788
> cor(x$PCTUPDATE, x$ATP)
-0.1078481
> cor(x$ACTROWPOOL, x$ATP)
[1] 0.07394266
> cor(x$ATP, x$MAXMPL)
[1] -0.1007889
>  cor(x$NUMPROCESSORS, x$MAXMPL)
[1] 0.0006660305
> cor(x$PCTREAD, x$MAXMPL)
[1] -0.05633367
>  cor(x$PCTUPDATE, x$MAXMPL)
[1] 0.008980045
> cor(x$ACTROWPOOL, x$MAXMPL)
[1] -0.05982288
> cor(x$PK, x$MAXMPL)
[1] 0.1547508

----

> cor(x$NUMPROCESSORS, x$ATP)
[1] -0.122788
> cor(x$PCTREAD, x$ATP)
[1] 0.08402555
> cor(x$PCTUPDATE, x$ATP)
[1] -0.145902
> cor(x$PK, x$ATP)
[1] -0.2029692
> cor(x$ACTROWPOOL, x$ATP)
[1] 0.07663052

> cor(x$ATP, x$MAXMPL)
[1] -0.07951011
> cor(x$NUMPROCESSORS, x$MAXMPL)
[1] -0.02375046
> cor(x$PCTREAD, x$MAXMPL)
[1] -0.059297
> cor(x$PCTUPDATE, x$MAXMPL)
[1] 0.01913866
> cor(x$ACTROWPOOL, x$MAXMPL)
[1] -0.0620389
> cor(x$PK, x$MAXMPL)
[1] 0.1646099

> cor(y$PCTUPDATE, y$MAXMPL)
[1] 0.1510572

> y <- subset(x, x$PK == 0)
> cor(y$PCTUPDATE, y$MAXMPL)
[1] 0.1510572
> y <- subset(x, x$PK == 1)
> cor(y$PCTUPDATE, y$MAXMPL)
[1] -0.1450092
> y <- subset(x, x$PK == 0)
> cor(y$PCTUPDATE, y$ATP)
[1] -0.274344
> y <- subset(x, x$PK == 1)
> cor(y$PCTUPDATE, y$ATP)
[1] 0.02332855

library(nnet)
med.fit <- multinom(ATP ~ NUMPROCESSORS + PK + PCTUPDATE + PCTUPDATE:PK, data = ml)

x$ATP <- relevel(x$ATP, data = x)
med.fit <- multinom(ATP ~ NUMPROCESSORS + PK + PCTUPDATE + PCTUPDATE:PK, data = x)
med.fit <- glm(ATP ~ NUMPROCESSORS + PK + PCTUPDATE + PCTUPDATE:PK, family=quasibinomial, data = x)
summary(med.fit)
	Call:
	glm(formula = ATP ~ NUMPROCESSORS + PK + PCTUPDATE + PCTUPDATE:PK, 
	    family = quasibinomial, data = x)

	Deviance Residuals: 
	    Min       1Q   Median       3Q      Max  
	-0.9158  -0.5110  -0.4163   0.2672   2.1622  

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    -0.6463     0.1141  -5.665 1.92e-08 ***
	NUMPROCESSORS  -0.6423     0.1687  -3.808 0.000149 ***
	PK             -1.3143     0.1819  -7.226 9.88e-13 ***
	PCTUPDATE      -1.3770     0.2301  -5.984 3.02e-09 ***
	PK:PCTUPDATE    1.5182     0.3618   4.196 2.96e-05 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	(Dispersion parameter for quasibinomial family taken to be 0.4932165)

	    Null deviance: 484.33  on 1003  degrees of freedom
	Residual deviance: 435.27  on  999  degrees of freedom
	AIC: NA

	Number of Fisher Scoring iterations: 5

> 1-med.fit$deviance/med.fit$null.deviance
[1] 0.1012974

out.fit <- glm(MAXMPL ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS + PK, family=quasibinomial, data = x)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance

	Call:
	glm(formula = MAXMPL ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + 
	    NUMPROCESSORS + PK, family = quasibinomial, data = x)

	Deviance Residuals: 
	     Min        1Q    Median        3Q       Max  
	-1.67301  -0.69287   0.06541   0.89993   1.21469  

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)     0.6155     0.1457   4.224 2.62e-05 ***
	PCTREAD        -0.2972     0.1781  -1.669   0.0954 .  
	PCTUPDATE      -0.0686     0.1581  -0.434   0.6645    
	ACTROWPOOL     -0.2617     0.1420  -1.844   0.0655 .  
	ATP            -0.2840     0.2064  -1.376   0.1692    
	NUMPROCESSORS  -0.1411     0.1355  -1.042   0.2978    
	PK              0.5243     0.1086   4.828 1.60e-06 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	(Dispersion parameter for quasibinomial family taken to be 0.6359494)

	    Null deviance: 830.85  on 1003  degrees of freedom
	Residual deviance: 807.17  on  997  degrees of freedom
	AIC: NA

	Number of Fisher Scoring iterations: 3

	> 1-out.fit$deviance/out.fit$null.deviance
	[1] 0.02850203


# Overall: 33.4% (close to suboptimal)
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
x <- subset(x, x$NUMPROCESSORS>=2)
x <- subset(x, x$PK == 1)
# ATP normalization
# db2
db2 <- subset(x, x$DBMS=='db2')
db2$ATP = (db2$ATP-min(db2$ATP))/(max(db2$ATP)-min(db2$ATP))
db2$MAXMPL = (db2$MAXMPL-min(db2$MAXMPL))/(max(db2$MAXMPL)-min(db2$MAXMPL))
x = rbind(db2) 
# oracle
oracle <- subset(x, x$DBMS=='oracle')
oracle$ATP = (oracle$ATP-min(oracle$ATP))/(max(oracle$ATP)-min(oracle$ATP))
oracle$MAXMPL = (oracle$MAXMPL-min(oracle$MAXMPL))/(max(oracle$MAXMPL)-min(oracle$MAXMPL))
x = rbind(oracle) 
# mysql
mysql <- subset(x, x$DBMS=='mysql')
mysql$ATP = (mysql$ATP-min(mysql$ATP))/(max(mysql$ATP)-min(mysql$ATP))
mysql$MAXMPL = (mysql$MAXMPL-min(mysql$MAXMPL))/(max(mysql$MAXMPL)-min(mysql$MAXMPL))
x = rbind(mysql) 
# pgsql
pgsql <- subset(x, x$DBMS=='pgsql')
pgsql$ATP = (pgsql$ATP-min(pgsql$ATP))/(max(pgsql$ATP)-min(pgsql$ATP))
pgsql$MAXMPL = (pgsql$MAXMPL-min(pgsql$MAXMPL))/(max(pgsql$MAXMPL)-min(pgsql$MAXMPL))
x = rbind(pgsql) 
# sqlserver
sqlserver <- subset(x, x$DBMS=='sqlserver')
sqlserver$ATP = (sqlserver$ATP-min(sqlserver$ATP))/(max(sqlserver$ATP)-min(sqlserver$ATP))
sqlserver$MAXMPL = (sqlserver$MAXMPL-min(sqlserver$MAXMPL))/(max(sqlserver$MAXMPL)-min(sqlserver$MAXMPL))
x = rbind(sqlserver) 
####
x$ACTROWPOOL = (x$ACTROWPOOL-min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)-min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD-min(x$PCTREAD))/(max(x$PCTREAD)-min(x$PCTREAD))
x$PCTUPDATE = (x$PCTUPDATE-min(x$PCTUPDATE))/(max(x$PCTUPDATE)-min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS-min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)-min(x$NUMPROCESSORS))

med.fit <- lm(ATP ~ NUMPROCESSORS+PCTUPDATE, data = x)
summary(med.fit)

db2:
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PCTUPDATE, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.23606 -0.17884 -0.08253  0.04129  0.77253 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.25148    0.05828   4.315 5.55e-05 ***
	NUMPROCESSORS -0.07202    0.07689  -0.937  0.35237    
	PCTUPDATE     -0.28924    0.08730  -3.313  0.00151 ** 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2613 on 65 degrees of freedom
	Multiple R-squared:  0.1597,	Adjusted R-squared:  0.1339 
	F-statistic: 6.179 on 2 and 65 DF,  p-value: 0.003495

oracle:
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PCTUPDATE, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.26188 -0.07778 -0.02806  0.06140  0.69946 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.07871    0.03188   2.469   0.0159 *  
	NUMPROCESSORS  0.06049    0.04031   1.501   0.1378    
	PCTUPDATE      0.20166    0.04698   4.293  5.5e-05 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1511 on 71 degrees of freedom
	Multiple R-squared:  0.2206,	Adjusted R-squared:  0.1986 
	F-statistic: 10.05 on 2 and 71 DF,  p-value: 0.0001437
mysql:
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PCTUPDATE, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.50830 -0.12293 -0.07171  0.19845  0.52968 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)   0.071692   0.067238   1.066    0.290    
	NUMPROCESSORS 0.006968   0.081034   0.086    0.932    
	PCTUPDATE     0.504774   0.091756   5.501 6.38e-07 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2835 on 67 degrees of freedom
	Multiple R-squared:  0.3127,	Adjusted R-squared:  0.2922 
	F-statistic: 15.24 on 2 and 67 DF,  p-value: 3.503e-06
pgsql:
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PCTUPDATE, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.30811 -0.18267 -0.00843  0.12296  0.67918 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.32082    0.06521   4.920 8.23e-06 ***
	NUMPROCESSORS -0.03645    0.08085  -0.451    0.654    
	PCTUPDATE     -0.40604    0.08704  -4.665 2.02e-05 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2444 on 55 degrees of freedom
	Multiple R-squared:  0.284,	Adjusted R-squared:  0.258 
	F-statistic: 10.91 on 2 and 55 DF,  p-value: 0.0001022
sqlserver:
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PCTUPDATE, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.25056 -0.08152 -0.01788  0.08085  0.61017 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.39994    0.03904  10.243 9.06e-16 ***
	NUMPROCESSORS -0.28291    0.04863  -5.818 1.47e-07 ***
	PCTUPDATE     -0.04045    0.05323  -0.760     0.45    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1725 on 73 degrees of freedom
	Multiple R-squared:  0.3168,	Adjusted R-squared:  0.2981 
	F-statistic: 16.93 on 2 and 73 DF,  p-value: 9.132e-07
