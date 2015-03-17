# Overall: 33.4% (close to suboptimal)
library(aod)
library(ggplot2)
x = read.csv(file="new_expl.dat",head=TRUE,sep="\t")
#x = read.csv(file="expl.dat",head=TRUE,sep="\t")
#x$MAXMPL[x$MAXMPL == 1100] <- 100000
#x$MAXMPL[x$MAXMPL == 1100] <- 10000
#x$MAXMPL[x$MAXMPL == 1100] <- 10000
x <- subset(x, x$MAXMPL < 1100)
# ATP normalization
# db2
db2 <- subset(x, x$DBMS=='db2')
db2_r <- subset(db2, db2$PCTREAD!=0)
db2_r <- subset(db2_r, select = -PCTUPDATE)
db2_r$ATP = (db2_r$ATP-min(db2_r$ATP))/(max(db2_r$ATP)-min(db2_r$ATP))
db2_r$MAXMPL = (db2_r$MAXMPL-min(db2_r$MAXMPL))/(max(db2_r$MAXMPL)-min(db2_r$MAXMPL))
db2 <- db2_r
# oracle
oracle <- subset(x, x$DBMS=='oracle')
oracle_r <- subset(oracle, oracle$PCTREAD!=0)
oracle_r <- subset(oracle_r, select = -PCTUPDATE)
oracle_r$ATP = (oracle_r$ATP-min(oracle_r$ATP))/(max(oracle_r$ATP)-min(oracle_r$ATP))
oracle_r$MAXMPL = (oracle_r$MAXMPL-min(oracle_r$MAXMPL))/(max(oracle_r$MAXMPL)-min(oracle_r$MAXMPL))
oracle <- oracle_r
# mysql
mysql <- subset(x, x$DBMS=='mysql')
mysql_r <- subset(mysql, mysql$PCTREAD!=0)
mysql_r <- subset(mysql_r, select = -PCTUPDATE)
mysql_r$ATP = (mysql_r$ATP-min(mysql_r$ATP))/(max(mysql_r$ATP)-min(mysql_r$ATP))
mysql_r$MAXMPL = (mysql_r$MAXMPL-min(mysql_r$MAXMPL))/(max(mysql_r$MAXMPL)-min(mysql_r$MAXMPL))
mysql <- mysql_r
# pgsql
pgsql <- subset(x, x$DBMS=='pgsql')
pgsql_r <- subset(pgsql, pgsql$PCTREAD!=0)
pgsql_r <- subset(pgsql_r, select = -PCTUPDATE)
pgsql_r$ATP = (pgsql_r$ATP-min(pgsql_r$ATP))/(max(pgsql_r$ATP)-min(pgsql_r$ATP))
pgsql_r$MAXMPL = (pgsql_r$MAXMPL-min(pgsql_r$MAXMPL))/(max(pgsql_r$MAXMPL)-min(pgsql_r$MAXMPL))
pgsql <- pgsql_r
# sqlserver
sqlserver <- subset(x, x$DBMS=='sqlserver')
sqlserver_r <- subset(sqlserver, sqlserver$PCTREAD!=0)
sqlserver_r <- subset(sqlserver_r, select = -PCTUPDATE)
sqlserver_r$ATP = (sqlserver_r$ATP-min(sqlserver_r$ATP))/(max(sqlserver_r$ATP)-min(sqlserver_r$ATP))
sqlserver_r$MAXMPL = (sqlserver_r$MAXMPL-min(sqlserver_r$MAXMPL))/(max(sqlserver_r$MAXMPL)-min(sqlserver_r$MAXMPL))
sqlserver <- sqlserver_r
#### gother each DBMS' samples
#x$ATP = (x$ATP-min(x$ATP))/(max(x$ATP)-min(x$ATP))
#x$MAXMPL = (x$MAXMPL-min(x$MAXMPL))/(max(x$MAXMPL)-min(x$MAXMPL))
x = rbind(db2,mysql,oracle,pgsql,sqlserver)
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
#x <- subset(x, x$PCTREAD!=0)
#x <- subset(x, select = -PCTUPDATE)
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))

nrow(x)
[1] 452

> cor.test(x$NUMPROCESSORS, x$ATP)
	#####  all samples
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -2.3845, df = 399, p-value = 0.01757
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.21397982 -0.02084718
	sample estimates:
	       cor 
	-0.1185344
	
	#####  only thrashing samples
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -1.3103, df = 196, p-value = 0.1916
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.22964570  0.04686212
	sample estimates:
	       cor 
	-0.0931883 	

> cor.test(x$PCTREAD, x$ATP)
	#####  all samples (when 10000 is given to no thrashing)
	Pearson's product-moment correlation

	data:  x$PCTREAD and x$ATP
	t = -0.6234, df = 399, p-value = 0.5334
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1287293  0.0669405
	sample estimates:
		cor 
	-0.03119324 

	#####  only thrashing samples
	Pearson's product-moment correlation

	data:  x$PCTREAD and x$ATP
	t = 0.1638, df = 196, p-value = 0.87
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1279494  0.1508961
	sample estimates:
	       cor 
	0.01170082

> cor.test(x$PK, x$ATP)
	#####  all samples
	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -7.4716, df = 399, p-value = 5.052e-13
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.4334006 -0.2613790
	sample estimates:
	       cor 
	-0.3503407 

	#####  only thrashing samples
	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -5.3771, df = 196, p-value = 2.141e-07
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.4742725 -0.2306318
	sample estimates:
	       cor 
	-0.3585427 

> cor.test(x$ACTROWPOOL, x$ATP)
	#####  only thrashing samples
	Pearson's product-moment correlation

	data:  x$ACTROWPOOL and x$ATP
	t = -0.1128, df = 196, p-value = 0.9103
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1473302  0.1315350
	sample estimates:
		cor 
	-0.00805423 

> cor.test(x$NUMPROCESSORS*x$ACTROWPOOL, x$ATP)

	#####  only thrashing samples
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS * x$ACTROWPOOL and x$ATP
	t = -1.0222, df = 196, p-value = 0.3079
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.21012972  0.06730292
	sample estimates:
		cor 
	-0.07282198 

> cor.test(x$PCTREAD*x$PK, x$ATP)
	#####  all thrashing samples
	Pearson's product-moment correlation

	data:  x$PCTREAD * x$PK and x$ATP
	t = -3.8304, df = 399, p-value = 0.0001486
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.28107220 -0.09209592
	sample estimates:
	       cor 
	-0.1883267

	#####  only thrashing samples
	Pearson's product-moment correlation

	data:  x$PCTREAD * x$PK and x$ATP
	t = -3.2558, df = 196, p-value = 0.001332
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.35475025 -0.08991213
	sample estimates:
	       cor 
	-0.2265137 

med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + PK + PCTREAD + PCTREAD:PK, data = x)
summary(med.fit)
	### all samples
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + 
	    PK + PCTREAD + PCTREAD:PK, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.4169 -0.1787 -0.1037  0.2191  0.8392 

	Coefficients:
		                  Estimate Std. Error t value Pr(>|t|)    
	(Intercept)               0.355346   0.064155   5.539 5.57e-08 ***
	NUMPROCESSORS            -0.087002   0.102126  -0.852    0.395    
	ACTROWPOOL                0.073364   0.089090   0.823    0.411    
	PK                       -0.222799   0.037779  -5.897 7.95e-09 ***
	PCTREAD                  -0.027589   0.045846  -0.602    0.548    
	NUMPROCESSORS:ACTROWPOOL -0.002961   0.150050  -0.020    0.984    
	PK:PCTREAD                0.016972   0.066745   0.254    0.799    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2939 on 394 degrees of freedom
	Multiple R-squared:  0.138,	Adjusted R-squared:  0.1249
	F-statistic: 10.52 on 6 and 394 DF,  p-value: 7.83e-11

	#### modified 1
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.38983 -0.16678 -0.09557  0.22106  0.86543 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.40162    0.03208  12.520  < 2e-16 ***
	NUMPROCESSORS -0.09029    0.04189  -2.155   0.0317 *  
	PK            -0.22177    0.03776  -5.873 9.08e-09 ***
	PCTREAD       -0.02616    0.04581  -0.571   0.5683    
	PK:PCTREAD     0.01310    0.06666   0.196   0.8443    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2939 on 396 degrees of freedom
	Multiple R-squared:  0.134,	Adjusted R-squared:  0.1252 
	F-statistic: 15.31 on 4 and 396 DF,  p-value: 1.182e-11

	#### modified 2
	> med.fit <- lm(ATP ~ NUMPROCESSORS + PK, data = x)
	> summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.3811 -0.1637 -0.1027  0.2229  0.8699 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.39273    0.02796  14.047  < 2e-16 ***
	NUMPROCESSORS -0.09107    0.04178  -2.179   0.0299 *  
	PK            -0.21713    0.02937  -7.392 8.58e-13 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2933 on 398 degrees of freedom
	Multiple R-squared:  0.1331,	Adjusted R-squared:  0.1287 
	F-statistic: 30.55 on 2 and 398 DF,  p-value: 4.543e-13

	#####  only thrashing samples
med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + PK + PCTREAD + PCTREAD:PK, data = x)
summary(med.fit)
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + 
	    PK + PCTREAD + PCTREAD:PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.50157 -0.19711 -0.03914  0.18665  0.79422 

	Coefficients:
		                 Estimate Std. Error t value Pr(>|t|)    
	(Intercept)               0.47586    0.09415   5.054 1.01e-06 ***
	NUMPROCESSORS            -0.11862    0.16603  -0.714 0.475836    
	ACTROWPOOL               -0.01059    0.13236  -0.080 0.936338    
	PK                       -0.24470    0.06391  -3.829 0.000175 ***
	PCTREAD                   0.04728    0.05863   0.806 0.421048    
	NUMPROCESSORS:ACTROWPOOL -0.01933    0.25292  -0.076 0.939145    
	PK:PCTREAD               -0.05516    0.10543  -0.523 0.601432    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.305 on 191 degrees of freedom
	Multiple R-squared:  0.1471,	Adjusted R-squared:  0.1203 
	F-statistic: 5.491 on 6 and 191 DF,  p-value: 2.881e-05

	### modified
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.49894 -0.19359 -0.04431  0.18873  0.79324 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.46835    0.04396  10.655  < 2e-16 ***
	NUMPROCESSORS -0.12843    0.06842  -1.877 0.062030 .  
	PK            -0.24476    0.06358  -3.850 0.000161 ***
	PCTREAD        0.04689    0.05830   0.804 0.422244    
	PK:PCTREAD    -0.05457    0.10474  -0.521 0.602933    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3034 on 193 degrees of freedom
	Multiple R-squared:  0.1468,	Adjusted R-squared:  0.1292 
	F-statistic: 8.305 on 4 and 193 DF,  p-value: 3.351e-06

	#### modified
	> med.fit <- lm(ATP ~ NUMPROCESSORS + PK, data = x)
	> summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.46829 -0.19492 -0.03859  0.17963  0.79590 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.48446    0.03904  12.410  < 2e-16 ***
	NUMPROCESSORS -0.12758    0.06812  -1.873   0.0626 .  
	PK            -0.26441    0.04763  -5.551  9.2e-08 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3024 on 195 degrees of freedom
	Multiple R-squared:  0.144,	Adjusted R-squared:  0.1352 
	F-statistic:  16.4 on 2 and 195 DF,  p-value: 2.622e-07

#x <- subset(x, x$MAXMPL < 1)
> cor.test(x$PK, x$MAXMPL)
	#####  all samples
	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 7.9243, df = 399, p-value = 2.309e-14
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.2809716 0.4504183
	sample estimates:
	      cor 
	0.3687545  

	#####  only thrashing samples
	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 4.2287, df = 196, p-value = 3.604e-05
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.1559954 0.4119782
	sample estimates:
	      cor 
	0.2891473  

cor.test(x$ATP, x$MAXMPL)
	#####  all samples
	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -7.2255, df = 399, p-value = 2.555e-12
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.4239652 -0.2505766
	sample estimates:
	       cor 
	-0.3401588 

	#####  only thrashing samples
	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = 0.2956, df = 196, p-value = 0.7679
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1186845  0.1600766
	sample estimates:
	       cor 
	0.02110625

cor.test(x$SRTTXNRATE, x$MAXMPL)
	Pearson's product-moment correlation

	data:  x$SRTTXNRATE and x$MAXMPL
	t = 2.0517, df = 208, p-value = 0.04145
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.00555669 0.27106282
	sample estimates:
	      cor 
	0.1408412

cor.test(x$NUMPROCESSORS, x$MAXMPL)
	#####  all samples
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = 3.6123, df = 399, p-value = 0.0003422
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.08144449 0.27115821
	sample estimates:
	      cor 
	0.1779544 

	#####  only thrashing samples
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = 1.1897, df = 196, p-value = 0.2356
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.05542261  0.22149949
	sample estimates:
	       cor 
	0.08467324

cor.test(x$ACTROWPOOL, x$MAXMPL)
	#####  all samples
	Pearson's product-moment correlation

	data:  x$ACTROWPOOL and x$MAXMPL
	t = -0.7982, df = 399, p-value = 0.4253
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.13731815  0.05823113
	sample estimates:
	       cor 
	-0.0399258
	
	##### only thrashing samples
	Pearson's product-moment correlation

	data:  x$ACTROWPOOL and x$MAXMPL
	t = -1.8057, df = 196, p-value = 0.0725
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.26267638  0.01173036
	sample estimates:
	       cor 
	-0.1279204 

> cor.test(x$PCTREAD, x$MAXMPL)
	#####  all samples
	Pearson's product-moment correlation

	data:  x$PCTREAD and x$MAXMPL
	t = -0.5309, df = 399, p-value = 0.5958
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.12417395  0.07154764
	sample estimates:
		cor 
	-0.02656777

out.fit <- lm(MAXMPL ~ SRTTXNRATE + PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	#####  all samples
	Call:
	lm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.90529 -0.30327  0.08452  0.24560  0.68272 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.53085    0.05999   8.848  < 2e-16 ***
	PK             0.27769    0.03873   7.171  3.7e-12 ***
	PCTREAD       -0.03380    0.04108  -0.823 0.411086    
	ACTROWPOOL    -0.07471    0.06514  -1.147 0.252068    
	ATP           -0.21788    0.06213  -3.507 0.000506 ***
	NUMPROCESSORS  0.17039    0.05198   3.278 0.001137 **
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3625 on 395 degrees of freedom
	Multiple R-squared:  0.221,	Adjusted R-squared:  0.2112 
	F-statistic: 22.42 on 5 and 395 DF,  p-value: < 2.2e-16

out.fit <- lm(MAXMPL ~ SRTTXNRATE, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ SRTTXNRATE, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.64015 -0.40452 -0.07119  0.30976  0.59548 

	Coefficients:
		    Estimate Std. Error t value Pr(>|t|)    
	(Intercept)  0.40452    0.02451  16.506   <2e-16 ***
	SRTTXNRATE   0.23563    0.11485   2.052   0.0415 *  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3393 on 208 degrees of freedom
	Multiple R-squared:  0.01984,	Adjusted R-squared:  0.01512 
	F-statistic: 4.209 on 1 and 208 DF,  p-value: 0.04145

	Call:
	lm(formula = MAXMPL ~ SRTTXNRATE + PK + PCTREAD + ACTROWPOOL + 
	    ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.64567 -0.27664 -0.00925  0.25088  0.69444 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.510490   0.076337   6.687 2.16e-10 ***
	SRTTXNRATE     0.380573   0.135352   2.812  0.00541 ** 
	PK             0.153210   0.054135   2.830  0.00512 ** 
	PCTREAD        0.009941   0.049488   0.201  0.84099    
	ACTROWPOOL    -0.148262   0.083986  -1.765  0.07901 .  
	ATP           -0.221192   0.081712  -2.707  0.00737 ** 
	NUMPROCESSORS  0.012237   0.072975   0.168  0.86699    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3196 on 203 degrees of freedom
	Multiple R-squared:  0.151,	Adjusted R-squared:  0.1259 
	F-statistic: 6.018 on 6 and 203 DF,  p-value: 8.197e-06

	### mediation of NUMPROCESSORS via ATP on MAXMPL 	
	
	med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
	summary(med.out)
	
	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME           0.019290     0.000664     0.042906    0.04
	ADE            0.173465     0.072097     0.280450    0.00
	Total Effect   0.192755     0.093969     0.303783    0.00
	Prop. Mediated 0.094703     0.003670     0.265453    0.04

	Sample Size Used: 401 

	sens.out <- medsens(med.out, effect.type = "both")
	summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	       Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	 [1,] -0.6 -0.1179      -0.2373       0.0015         0.36       0.2417
	 [2,] -0.5 -0.0785      -0.1681       0.0111         0.25       0.1679
	 [3,] -0.4 -0.0474      -0.1094       0.0146         0.16       0.1074
	 [4,] -0.3 -0.0229      -0.0593       0.0135         0.09       0.0604
	 [5,] -0.2 -0.0041      -0.0200       0.0118         0.04       0.0269
	 [6,] -0.1  0.0097      -0.0127       0.0321         0.01       0.0067
	 [7,]  0.0  0.0190      -0.0256       0.0635         0.00       0.0000
	 [8,]  0.1  0.0242      -0.0440       0.0924         0.01       0.0067
	 [9,]  0.2  0.0258      -0.0663       0.1178         0.04       0.0269
	[10,]  0.3  0.0243      -0.0916       0.1402         0.09       0.0604
	[11,]  0.4  0.0204      -0.1196       0.1604         0.16       0.1074
	[12,]  0.5  0.0150      -0.1495       0.1795         0.25       0.1679
	[13,]  0.6  0.0098      -0.1802       0.1999         0.36       0.2417
	[14,]  0.7  0.0079      -0.2102       0.2259         0.49       0.3290
	[15,]  0.8  0.0168      -0.2359       0.2694         0.64       0.4297
	[16,]  0.9  0.0656      -0.2473       0.3784         0.81       0.5439

	Rho at which ACME = 0: -0.2
	R^2_M*R^2_Y* at which ACME = 0: 0.04
	R^2_M~R^2_Y~ at which ACME = 0: 0.0269 


	Mediation Sensitivity Analysis for Average Direct Effect

	Sensitivity Region

	     Rho     ADE 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] 0.5  0.1070      -0.0096       0.2237         0.25       0.1679
	[2,] 0.6  0.0881      -0.0380       0.2143         0.36       0.2417
	[3,] 0.7  0.0630      -0.0782       0.2041         0.49       0.3290
	[4,] 0.8  0.0244      -0.1433       0.1921         0.64       0.4297
	[5,] 0.9 -0.0555      -0.2857       0.1748         0.81       0.5439

	Rho at which ADE = 0: 0.8
	R^2_M*R^2_Y* at which ADE = 0: 0.64
	R^2_M~R^2_Y~ at which ADE = 0: 0.4297 

	### mediation of NUMPROCESSORS via PK on MAXMPL 
	med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK")
	summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME             0.0466       0.0196       0.0756       0
	ADE              0.2783       0.1987       0.3527       0
	Total Effect     0.3249       0.2483       0.3943       0
	Prop. Mediated   0.1420       0.0617       0.2512       0

	Sample Size Used: 401 


	Simulations: 1000 

	sens.out <- medsens(med.out, effect.type = "both")
	summary(sens.out)
	
	Sensitivity Region

      	Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.2 -0.0074      -0.0338       0.0190         0.04       0.0269
	[2,] -0.1  0.0206      -0.0069       0.0481         0.01       0.0067

	Rho at which ACME = 0: -0.2
	R^2_M*R^2_Y* at which ACME = 0: 0.04
	R^2_M~R^2_Y~ at which ACME = 0: 0.0269 


	Mediation Sensitivity Analysis for Average Direct Effect

	Sensitivity Region

	     Rho     ADE 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] 0.6  0.0774      -0.0147       0.1696         0.36       0.2417
	[2,] 0.7  0.0162      -0.0861       0.1184         0.49       0.3290
	[3,] 0.8 -0.0778      -0.1982       0.0427         0.64       0.4297

	Rho at which ADE = 0: 0.7
	R^2_M*R^2_Y* at which ADE = 0: 0.49
	R^2_M~R^2_Y~ at which ADE = 0: 0.329 
	
	### moderated mediation of NUMPROCESSORS by ACTROWPOOL through ATP on MAXMPL
	test.modmed(med.out, covariates.1 = list (x$ACTROWPOOL <= 0.5), covariates.2 = list (x$ACTROWPOOL > 0.5), data = x)

		Test of ACME(covariates.1) - ACME(covariates.2) = 0

	data:  estimates from med.out
	ACME(covariates.1) - ACME(covariates.2) = -2e-04, p-value = 1
	alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.04330314  0.04359007

	test.modmed(med.out, covariates.1 = list (x$PK == 0), covariates.2 = list (x$PK == 1), data = x)

	Test of ADE(covariates.1) - ADE(covariates.2) = 0

	data:  estimates from med.out
	ADE(covariates.1) - ADE(covariates.2) = -0.0018, p-value = 0.978
	alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.1159878  0.1017726

	### modified
	out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
	summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.9183 -0.3086  0.0795  0.2314  0.7055 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.47305    0.04226  11.193  < 2e-16 ***
	PK             0.27732    0.03872   7.163 3.87e-12 ***
	ATP           -0.22121    0.06196  -3.570  0.00040 ***
	NUMPROCESSORS  0.17048    0.05196   3.281  0.00112 ** 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3625 on 397 degrees of freedom
	Multiple R-squared:  0.2171,	Adjusted R-squared:  0.2112 
	F-statistic:  36.7 on 3 and 397 DF,  p-value: < 2.2e-16

	#####  thrashing samples
	Call:
	lm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.40790 -0.17473 -0.04705  0.16753  0.58213 

	Coefficients:
		        Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.1884842  0.0548826   3.434 0.000728 ***
	PK             0.1839099  0.0373362   4.926 1.81e-06 ***
	PCTREAD       -0.0008194  0.0351120  -0.023 0.981407    
	ACTROWPOOL    -0.1018733  0.0569082  -1.790 0.075008 .  
	ATP            0.1142892  0.0520402   2.196 0.029277 *  
	NUMPROCESSORS  0.0859572  0.0502261   1.711 0.088621 .  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2195 on 192 degrees of freedom
	Multiple R-squared:  0.1325,	Adjusted R-squared:  0.1099 
	F-statistic: 5.865 on 5 and 192 DF,  p-value: 4.553e-05

		### mediation of NUMPROCESSORS via ATP on MAXMPL 
		med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
		summary(med.out)

		Causal Mediation Analysis 

		Quasi-Bayesian Confidence Intervals

			       Estimate 95% CI Lower 95% CI Upper p-value
		ACME           -0.01505     -0.04060      0.00119    0.08
		ADE             0.08478     -0.01418      0.18056    0.09
		Total Effect    0.06973     -0.02523      0.16423    0.15
		Prop. Mediated -0.16548     -2.10224      1.18040    0.22

		Sample Size Used: 198 


		Simulations: 1000

		### mediation of PK via ATP on MAXMPL 
		med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK")
		summary(med.out)

		Causal Mediation Analysis 

		Quasi-Bayesian Confidence Intervals

			       Estimate 95% CI Lower 95% CI Upper p-value
		ACME           -0.03018     -0.06333     -0.00255    0.02
		ADE             0.18419      0.11033      0.25815    0.00
		Total Effect    0.15402      0.08902      0.22265    0.00
		Prop. Mediated -0.19247     -0.49926     -0.01645    0.02

		Sample Size Used: 198 


		Simulations: 1000

		med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTREAD")
		summary(med.out)

	### modified
	out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
	summary(out.fit)
	
	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.39931 -0.20072 -0.04322  0.17341  0.54733 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.11902    0.03803   3.130  0.00202 ** 
	PK             0.18357    0.03732   4.918 1.86e-06 ***
	ATP            0.11566    0.05214   2.218  0.02770 *  
	NUMPROCESSORS  0.09540    0.05004   1.906  0.05809 .  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2202 on 194 degrees of freedom
	Multiple R-squared:  0.118,	Adjusted R-squared:  0.1044 
	F-statistic: 8.651 on 3 and 194 DF,  p-value: 2.041e-05

#### assumptions
library(car)
outlierTest(out.fit)

No Studentized residuals with Bonferonni p < 0.05
Largest |rstudent|:
    rstudent unadjusted p-value Bonferonni p
730 2.066567           0.039428           NA

# Overall: 33.4% (close to suboptimal)
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
# ATP normalization
# db2
db2 <- subset(x, x$DBMS=='db2')
db2$ATP = (db2$ATP-min(db2$ATP))/(max(db2$ATP)-min(db2$ATP))
db2$MAXMPL = (db2$MAXMPL-min(db2$MAXMPL))/(max(db2$MAXMPL)-min(db2$MAXMPL))
# oracle
oracle <- subset(x, x$DBMS=='oracle')
oracle$ATP = (oracle$ATP-min(oracle$ATP))/(max(oracle$ATP)-min(oracle$ATP))
oracle$MAXMPL = (oracle$MAXMPL-min(oracle$MAXMPL))/(max(oracle$MAXMPL)-min(oracle$MAXMPL))
# mysql
mysql <- subset(x, x$DBMS=='mysql')
mysql$ATP = (mysql$ATP-min(mysql$ATP))/(max(mysql$ATP)-min(mysql$ATP))
mysql$MAXMPL = (mysql$MAXMPL-min(mysql$MAXMPL))/(max(mysql$MAXMPL)-min(mysql$MAXMPL))
# pgsql
pgsql <- subset(x, x$DBMS=='pgsql')
pgsql$ATP = (pgsql$ATP-min(pgsql$ATP))/(max(pgsql$ATP)-min(pgsql$ATP))
pgsql$MAXMPL = (pgsql$MAXMPL-min(pgsql$MAXMPL))/(max(pgsql$MAXMPL)-min(pgsql$MAXMPL))
# sqlserver
sqlserver <- subset(x, x$DBMS=='sqlserver')
sqlserver$ATP = (sqlserver$ATP-min(sqlserver$ATP))/(max(sqlserver$ATP)-min(sqlserver$ATP))
sqlserver$MAXMPL = (sqlserver$MAXMPL-min(sqlserver$MAXMPL))/(max(sqlserver$MAXMPL)-min(sqlserver$MAXMPL))
x = rbind(db2,mysql,oracle,pgsql,sqlserver) 
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD-min(x$PCTREAD))/(max(x$PCTREAD)-min(x$PCTREAD))
x$PCTUPDATE = (x$PCTUPDATE-min(x$PCTUPDATE))/(max(x$PCTUPDATE)-min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
x <- subset(x, x$MAXMPL < 1)
out.fit <- lm(MAXMPL ~ PK + PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, data = x)
pdf("new_normal_res_qqplot.pdf")
qqnorm(out.fit$res,main="",xlim=c(0,1), ylim=c(0,1)); qqline(out.fit$res);
dev.off()
pdf("new_normal_res_hist.pdf")
h <- hist(out.fit$res,main="",xlab="Residuals",ylim=c(0,100),xlim=c(-0.6,0.6))
xfit<-seq(min(out.fit$res),max(out.fit$res),length=40) 
yfit<-dnorm(xfit,mean=mean(out.fit$res),sd=sd(out.fit$res)) 
yfit <- yfit*diff(h$mids[1:2])*length(out.fit$res) 
lines(xfit, yfit, col="blue")
dev.off()

# Evaluate homoscedasticity
# non-constant error variance test
> ncvTest(out.fit)
spreadLevelPlot(out.fit, main="Homoscedasticity Test")
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 0.1435765    Df = 1     p = 0.704751

# Evaluate Collinearity
vif(out.fit) # variance inflation factors 
sqrt(vif(out.fit)) > 2 # problem?

# Evaluate Nonlinearity
# component + residual plot 
crPlots(out.fit, main = "")

durbinWatsonTest(out.fit)
	 lag Autocorrelation D-W Statistic p-value
	   1       0.4246894      1.146497       0
	 Alternative hypothesis: rho != 0
dwtest(out.fit, alternative="two.sided")

#### thrashing or not thrashing
x = rbind(db2,mysql,oracle,pgsql,sqlserver)
#x = rbind(db2,mysql,oracle,pgsql)
x$MAXMPL[x$MAXMPL < 1] <- 0
x$MAXMPL[x$MAXMPL == 1] <- 2
x$MAXMPL[x$MAXMPL < 1] <- 1 ### thrashing
x$MAXMPL[x$MAXMPL == 2] <- 0### no thrashing
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD/min(x$PCTREAD))/(max(x$PCTREAD)/min(x$PCTREAD))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))

#out.fit <-  glm(MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, family="gaussian", data = x)
#out.fit <-  glm(MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, family=gaussian(link = "identity"), data = x)
#out.fit <-  glm(MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, family=binomial("logit"), data = x)
out.fit <-  glm(MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, family=binomial("probit"), data = x)
summary(out.fit)

	Call:
	glm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, 
	    family = binomial("probit"), data = x)

	Deviance Residuals: 
	    Min       1Q   Median       3Q      Max  
	-2.0619  -0.8712  -0.5619   0.9602   1.9737  

	Coefficients:
		      Estimate Std. Error z value Pr(>|z|)    
	(Intercept)    0.25438    0.21940   1.159  0.24628    
	PK            -0.75820    0.14040  -5.400 6.65e-08 ***
	PCTREAD        0.18353    0.15280   1.201  0.22972    
	ACTROWPOOL     0.07895    0.24189   0.326  0.74412    
	ATP            1.04929    0.23139   4.535 5.77e-06 ***
	NUMPROCESSORS -0.58779    0.19307  -3.044  0.00233 ** 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	(Dispersion parameter for binomial family taken to be 1)

	    Null deviance: 555.84  on 400  degrees of freedom
	Residual deviance: 467.48  on 395  degrees of freedom
	AIC: 479.48

	Number of Fisher Scoring iterations: 4

wald.test(b = coef(out.fit), Sigma = vcov(out.fit), Terms = 2:6)
Wald test:
----------

Chi-squared test:
X2 = 79.0, df = 5, P(> X2) = 1.3e-15

> 1-out.fit$deviance/out.fit$null.deviance
[1] 0.16

out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS, family=binomial("probit"), data = x)
summary(out.fit)
> 1-out.fit$deviance/out.fit$null.deviance
[1] 0.1518221

###########################################################################################################################

#### update-only
x = read.csv(file="new_expl.dat",head=TRUE,sep="\t")
#x$MAXMPL[x$MAXMPL == 1100] <- 10000
x <- subset(x, x$MAXMPL < 1100)
# ATP normalization
# db2
db2 <- subset(x, x$DBMS=='db2')
db2_w <- subset(db2, db2$PCTUPDATE!=0)
db2_w <- subset(db2_w, select = -PCTREAD)
db2_w$ATP = (db2_w$ATP-min(db2_w$ATP))/(max(db2_w$ATP)-min(db2_w$ATP))
db2_w$MAXMPL = (db2_w$MAXMPL-min(db2_w$MAXMPL))/(max(db2_w$MAXMPL)-min(db2_w$MAXMPL))
db2 <- db2_w
# oracle
oracle <- subset(x, x$DBMS=='oracle')
oracle_w <- subset(oracle, oracle$PCTUPDATE!=0)
oracle_w <- subset(oracle_w, select = -PCTREAD)
oracle_w$ATP = (oracle_w$ATP-min(oracle_w$ATP))/(max(oracle_w$ATP)-min(oracle_w$ATP))
oracle_w$MAXMPL = (oracle_w$MAXMPL-min(oracle_w$MAXMPL))/(max(oracle_w$MAXMPL)-min(oracle_w$MAXMPL))
oracle <- oracle_w
# mysql
mysql <- subset(x, x$DBMS=='mysql')
mysql_w <- subset(mysql, mysql$PCTUPDATE!=0)
mysql_w <- subset(mysql_w, select = -PCTREAD)
mysql_w$ATP = (mysql_w$ATP-min(mysql_w$ATP))/(max(mysql_w$ATP)-min(mysql_w$ATP))
mysql_w$MAXMPL = (mysql_w$MAXMPL-min(mysql_w$MAXMPL))/(max(mysql_w$MAXMPL)-min(mysql_w$MAXMPL))
mysql <- mysql_w
# pgsql
pgsql <- subset(x, x$DBMS=='pgsql')
pgsql_w <- subset(pgsql, pgsql$PCTUPDATE!=0)
pgsql_w <- subset(pgsql_w, select = -PCTREAD)
pgsql_w$ATP = (pgsql_w$ATP-min(pgsql_w$ATP))/(max(pgsql_w$ATP)-min(pgsql_w$ATP))
pgsql_w$MAXMPL = (pgsql_w$MAXMPL-min(pgsql_w$MAXMPL))/(max(pgsql_w$MAXMPL)-min(pgsql_w$MAXMPL))
pgsql <- pgsql_w
# sqlserver
sqlserver <- subset(x, x$DBMS=='sqlserver')
sqlserver_w <- subset(sqlserver, sqlserver$PCTUPDATE!=0)
sqlserver_w <- subset(sqlserver_w, select = -PCTREAD)
sqlserver_w$ATP = (sqlserver_w$ATP-min(sqlserver_w$ATP))/(max(sqlserver_w$ATP)-min(sqlserver_w$ATP))
sqlserver_w$MAXMPL = (sqlserver_w$MAXMPL-min(sqlserver_w$MAXMPL))/(max(sqlserver_w$MAXMPL)-min(sqlserver_w$MAXMPL))
sqlserver <- sqlserver_w
x = rbind(db2,mysql,oracle,pgsql,sqlserver)
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTUPDATE = (x$PCTUPDATE/min(x$PCTUPDATE))/(max(x$PCTUPDATE)/min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))

nrow(x)
[1] 608
#x <- subset(x, x$MAXMPL < 1)
nrow(x)
[1] 328

cor.test(x$NUMPROCESSORS, x$ATP)
	#####  all samples 
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -4.9606, df = 606, p-value = 9.14e-07
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2727714 -0.1199081
	sample estimates:
	       cor 
	-0.1975403

	#####  thrashing samples 
	Pearson's product-moment correlation

data:  x$NUMPROCESSORS and x$ATP
t = -7.443, df = 326, p-value = 8.834e-13
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.4700122 -0.2845698
sample estimates:
       cor 
-0.3811178

cor.test(x$PCTUPDATE, x$ATP)
	#####  all samples 
	Pearson's product-moment correlation

	data:  x$PCTUPDATE and x$ATP
	t = 1.1579, df = 606, p-value = 0.2473
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.03265189  0.12603053
	sample estimates:
	       cor 
	0.04698574

	#####  thrashing samples 
	Pearson's product-moment correlation

	data:  x$PCTUPDATE and x$ATP
	t = -0.1631, df = 299, p-value = 0.8706
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1223512  0.1037336
	sample estimates:
		 cor 
	-0.009429312

cor.test(x$PK, x$ATP)
	#####  all samples 
	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -0.1722, df = 606, p-value = 0.8633
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.08646303  0.07256052
	sample estimates:
		 cor 
	-0.006995482

	#####  thrashing samples 
	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = 3.1786, df = 299, p-value = 0.001635
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.06915499 0.28796046
	sample estimates:
	      cor 
	0.1807938 

cor.test(x$PCTUPDATE*x$PK, x$ATP)
	#####  all samples 
	Pearson's product-moment correlation

	data:  x$PCTUPDATE * x$PK and x$ATP
	t = 0.6502, df = 606, p-value = 0.5158
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.05322307  0.10569804
	sample estimates:
	       cor 
	0.02640431

	#####  thrashing samples 
	Pearson's product-moment correlation

	data:  x$PCTUPDATE * x$PK and x$ATP
	t = 2.3559, df = 299, p-value = 0.01913
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.0222831 0.2443189
	sample estimates:
	      cor 
	0.1349953

med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + PK + PCTUPDATE + PCTUPDATE:PK, data = x)
summary(med.fit)
	#####  all samples 
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + 
	    PK + PCTUPDATE + PCTUPDATE:PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.40831 -0.23509 -0.09757  0.20204  0.76985 

	Coefficients:
		                 Estimate Std. Error t value Pr(>|t|)    
	(Intercept)               0.25205    0.06391   3.944 8.97e-05 ***
	NUMPROCESSORS            -0.13065    0.08685  -1.504   0.1330    
	ACTROWPOOL                0.16408    0.07336   2.237   0.0257 *  
	PK                       -0.05608    0.05894  -0.952   0.3417    
	PCTUPDATE                 0.01298    0.06051   0.214   0.8303    
	NUMPROCESSORS:ACTROWPOOL -0.07830    0.12665  -0.618   0.5366    
	PK:PCTUPDATE              0.08753    0.08636   1.014   0.3112    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2971 on 601 degrees of freedom
	Multiple R-squared:  0.05761,	Adjusted R-squared:  0.0482 
	F-statistic: 6.123 on 6 and 601 DF,  p-value: 3.045e-06

	#####  thrashing samples 
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + 
	    PK + PCTUPDATE + PCTUPDATE:PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.42559 -0.22984 -0.08063  0.16767  0.84603 

	Coefficients:
		                 Estimate Std. Error t value Pr(>|t|)  
	(Intercept)               0.24461    0.09625   2.541   0.0116 *
	NUMPROCESSORS            -0.27367    0.12572  -2.177   0.0303 *
	ACTROWPOOL                0.12091    0.11003   1.099   0.2727  
	PK                        0.14223    0.08387   1.696   0.0910 .
	PCTUPDATE                 0.02931    0.08701   0.337   0.7365  
	NUMPROCESSORS:ACTROWPOOL -0.07561    0.18009  -0.420   0.6749  
	PK:PCTUPDATE             -0.02248    0.12101  -0.186   0.8527  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2957 on 292 degrees of freedom
	Multiple R-squared:  0.1568,	Adjusted R-squared:  0.1394 
	F-statistic: 9.048 on 6 and 292 DF,  p-value: 4.432e-09

med.fit <- lm(ATP ~ NUMPROCESSORS + PK + PCTUPDATE + PCTUPDATE:PK, data = x)
summary(med.fit)
	#####  all samples 
	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.3525 -0.2539 -0.1086  0.1935  0.7816 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.35480    0.04482   7.917 1.18e-14 ***
	NUMPROCESSORS -0.17882    0.03591  -4.980 8.31e-07 ***
	PK            -0.05602    0.05929  -0.945    0.345    
	PCTUPDATE      0.01227    0.06087   0.202    0.840    
	PK:PCTUPDATE   0.08613    0.08687   0.992    0.322    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2989 on 603 degrees of freedom
	Multiple R-squared:  0.04311,	Adjusted R-squared:  0.03676 
	F-statistic: 6.791 on 4 and 603 DF,  p-value: 2.379e-05

	### modified
	med.fit <- lm(ATP ~ NUMPROCESSORS + PK, data = x)
	summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.3160 -0.2605 -0.1148  0.1981  0.8186 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.362094   0.023812  15.206  < 2e-16 ***
	NUMPROCESSORS -0.177975   0.035920  -4.955 9.41e-07 ***
	PK            -0.002751   0.024262  -0.113     0.91    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.299 on 605 degrees of freedom
	Multiple R-squared:  0.03904,	Adjusted R-squared:  0.03587 
	F-statistic: 12.29 on 2 and 605 DF,  p-value: 5.861e-06

	#####  thrashing samples 
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK + PCTUPDATE + PCTUPDATE:PK, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.38504 -0.23347 -0.08478  0.15969  0.85814 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.28748    0.04505   6.382 6.74e-10 ***
	NUMPROCESSORS -0.27942    0.04401  -6.348 8.16e-10 ***
	PK             0.14174    0.05718   2.479   0.0137 *  
	PCTUPDATE      0.02171    0.06477   0.335   0.7378    
	PK:PCTUPDATE  -0.02964    0.09007  -0.329   0.7424    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2954 on 296 degrees of freedom
	Multiple R-squared:  0.1498,	Adjusted R-squared:  0.1383 
	F-statistic: 13.04 on 4 and 296 DF,  p-value: 8.558e-10

	#####  modified
	med.fit <- lm(ATP ~ NUMPROCESSORS + PK, data = x)
	summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.38545 -0.23562 -0.08673  0.15818  0.85451 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.33888    0.03401   9.965  < 2e-16 ***
	NUMPROCESSORS -0.31995    0.05002  -6.396 6.15e-10 ***
	PK             0.12656    0.03399   3.723 0.000235 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2944 on 298 degrees of freedom
	Multiple R-squared:  0.1495,	Adjusted R-squared:  0.1437 
	F-statistic: 26.18 on 2 and 298 DF,  p-value: 3.349e-11

cor.test(x$SRTTXNRATE, x$MAXMPL)
	Pearson's product-moment correlation

	data:  x$SRTTXNRATE and x$MAXMPL
	t = 1.216, df = 326, p-value = 0.2249
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.0413980  0.1742213
	sample estimates:
	       cor 
	0.06719616

cor.test(x$PK, x$MAXMPL)
	#####  all samples 
	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = -0.5866, df = 606, p-value = 0.5577
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.10314447  0.05579712
	sample estimates:
		cor 
	-0.02382423

	#####  thrashing samples
	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 1.4471, df = 299, p-value = 0.1489
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.02993859  0.19461344
	sample estimates:
	       cor 
	0.08339597 

cor.test(x$ATP, x$MAXMPL)
	#####  all samples 
	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = 2.7692, df = 606, p-value = 0.005792
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.0325583 -0.1896148
	sample estimates:
	      cor 
	-0.1117845

	#####  thrashing samples
	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -0.2807, df = 299, p-value = 0.7791
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.12904560  -0.09700021
	sample estimates:
		cor 
	-0.05623008

	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = 2.2872, df = 281, p-value = 0.02293
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.01889034 0.24788031
	sample estimates:
	      cor 
	0.1351901

cor.test(x$NUMPROCESSORS, x$MAXMPL)
	#####  all samples 
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = -2.2962, df = 606, p-value = 0.02201
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.17112501 -0.01345684
	sample estimates:
	       cor 
	-0.0928731

	#####  thrashing samples 
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = -4.0087, df = 299, p-value = 7.715e-05
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.3304558 -0.1157435
	sample estimates:
	       cor 
	-0.2258407

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = -6.6156, df = 281, p-value = 1.864e-10
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.4638454 -0.2617062
	sample estimates:
	       cor 
	-0.3671019

cor.test(x$ACTROWPOOL, x$MAXMPL)
	#####  all samples 
	Pearson's product-moment correlation

	data:  x$ACTROWPOOL and x$MAXMPL
	t = -1.3032, df = 606, p-value = 0.193
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.13182588  0.02676378
	sample estimates:
		cor 
	-0.05286437

	#####  thrashing samples 
	Pearson's product-moment correlation

	data:  x$ACTROWPOOL and x$MAXMPL
	t = -1.2567, df = 299, p-value = 0.2099
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.18402713  0.04090469
	sample estimates:
	       cor 
	-0.0724828

cor.test(x$PCTUPDATE, x$MAXMPL)
	#####  all samples 

	Pearson's product-moment correlation

	data:  x$PCTUPDATE and x$MAXMPL
	t = -0.8742, df = 606, p-value = 0.3823
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1146829  0.0441493
	sample estimates:
		cor 
	-0.03549093

	#####  thrashing samples 
	Pearson's product-moment correlation

	data:  x$PCTUPDATE and x$MAXMPL
	t = -0.1472, df = 299, p-value = 0.8831
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1214467  0.1046418
	sample estimates:
		 cor 
	-0.008511229 

out.fit <- lm(MAXMPL ~ PK + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, data = x)
summary(out.fit)
	
	#####  all samples 
	Call:
	lm(formula = MAXMPL ~ PK + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, 
	    data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.6755 -0.4669  0.3136  0.4719  0.6355 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.64669    0.07398   8.742  < 2e-16 ***
	PK            -0.02255    0.03890  -0.580  0.56226    
	PCTUPDATE     -0.06978    0.06975  -1.000  0.31752    
	ACTROWPOOL    -0.11199    0.06943  -1.613  0.10727    
	ATP            0.17009    0.06573   2.588  0.00989 ** 
	NUMPROCESSORS -0.10053    0.05878  -1.710  0.08774 .  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.4793 on 602 degrees of freedom
	Multiple R-squared:  0.02396,	Adjusted R-squared:  0.01585 
	F-statistic: 2.956 on 5 and 602 DF,  p-value: 0.01203
	
	### testing mediation
	med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
	summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.03091     -0.06144     -0.00746    0.01
	ADE            -0.10390     -0.21404      0.01418    0.07
	Total Effect   -0.13480     -0.24530     -0.01752    0.02
	Prop. Mediated  0.22209      0.03500      0.97480    0.03

	Sample Size Used: 608 


	Simulations: 1000

	sens.out <- medsens(med.out, effect.type = "both")
	summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	       Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	 [1,] -0.4 -0.1292      -0.2683       0.0098         0.16       0.1472
	 [2,] -0.3 -0.0964      -0.2082       0.0153         0.09       0.0828
	 [3,] -0.2 -0.0687      -0.1536       0.0162         0.04       0.0368
	 [4,] -0.1 -0.0444      -0.1030       0.0142         0.01       0.0092
	 [5,]  0.0 -0.0222      -0.0556       0.0111         0.00       0.0000
	 [6,]  0.1 -0.0011      -0.0176       0.0155         0.01       0.0092
	 [7,]  0.2  0.0202      -0.0108       0.0513         0.04       0.0368
	 [8,]  0.3  0.0429      -0.0143       0.1001         0.09       0.0828
	 [9,]  0.4  0.0687      -0.0170       0.1544         0.16       0.1472
	[10,]  0.5  0.1000      -0.0158       0.2158         0.25       0.2300
	[11,]  0.6  0.1409      -0.0073       0.2892         0.36       0.3311

	Rho at which ACME = 0: 0.1
	R^2_M*R^2_Y* at which ACME = 0: 0.01
	R^2_M~R^2_Y~ at which ACME = 0: 0.0092 


	Mediation Sensitivity Analysis for Average Direct Effect

	Sensitivity Region

	      Rho     ADE 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.6  0.1164      -0.0259       0.2587         0.36       0.3311
	[2,] -0.5  0.0664      -0.0653       0.1982         0.25       0.2300
	[3,] -0.4  0.0257      -0.0991       0.1504         0.16       0.1472
	[4,] -0.3 -0.0096      -0.1296       0.1105         0.09       0.0828
	[5,] -0.2 -0.0415      -0.1585       0.0755         0.04       0.0368
	[6,] -0.1 -0.0715      -0.1868       0.0438         0.01       0.0092
	[7,]  0.0 -0.1005      -0.2153       0.0142         0.00       0.0000

	Rho at which ADE = 0: -0.3
	R^2_M*R^2_Y* at which ADE = 0: 0.09
	R^2_M~R^2_Y~ at which ADE = 0: 0.0828

	med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK")
	summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		        Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.000149    -0.008896     0.008359    0.99
	ADE            -0.022472    -0.105942     0.055527    0.56
	Total Effect   -0.022621    -0.106257     0.054872    0.55
	Prop. Mediated  0.006491    -0.874544     1.054345    0.93

	Sample Size Used: 608 


	Simulations: 1000

	sens.out <- medsens(med.out, effect.type = "both")
	summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	       Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	 [1,] -0.9 -0.0386      -0.2684       0.1911         0.81       0.7450
	 [2,] -0.8 -0.0466      -0.2290       0.1358         0.64       0.5887
	 [3,] -0.7 -0.0494      -0.2043       0.1055         0.49       0.4507
	 [4,] -0.6 -0.0487      -0.1815       0.0840         0.36       0.3311
	 [5,] -0.5 -0.0456      -0.1583       0.0671         0.25       0.2300
	 [6,] -0.4 -0.0406      -0.1343       0.0531         0.16       0.1472
	 [7,] -0.3 -0.0342      -0.1093       0.0409         0.09       0.0828
	 [8,] -0.2 -0.0267      -0.0835       0.0301         0.04       0.0368
	 [9,] -0.1 -0.0184      -0.0570       0.0203         0.01       0.0092
	[10,]  0.0 -0.0095      -0.0304       0.0113         0.00       0.0000
	[11,]  0.1 -0.0005      -0.0077       0.0068         0.01       0.0092
	[12,]  0.2  0.0086      -0.0106       0.0279         0.04       0.0368
	[13,]  0.3  0.0175      -0.0203       0.0552         0.09       0.0828
	[14,]  0.4  0.0257      -0.0316       0.0831         0.16       0.1472
	[15,]  0.5  0.0331      -0.0449       0.1110         0.25       0.2300
	[16,]  0.6  0.0391      -0.0609       0.1391         0.36       0.3311
	[17,]  0.7  0.0432      -0.0816       0.1679         0.49       0.4507
	[18,]  0.8  0.0444      -0.1112       0.1999         0.64       0.5887
	[19,]  0.9  0.0409      -0.1664       0.2482         0.81       0.7450

	Rho at which ACME = 0: 0.1
	R^2_M*R^2_Y* at which ACME = 0: 0.01
	R^2_M~R^2_Y~ at which ACME = 0: 0.0092 


	Mediation Sensitivity Analysis for Average Direct Effect

	Sensitivity Region

	       Rho     ADE 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	 [1,] -0.9 -0.0171      -0.1913       0.1570         0.81       0.7450
	 [2,] -0.8 -0.0191      -0.1456       0.1074         0.64       0.5887
	 [3,] -0.7 -0.0200      -0.1263       0.0863         0.49       0.4507
	 [4,] -0.6 -0.0206      -0.1155       0.0743         0.36       0.3311
	 [5,] -0.5 -0.0210      -0.1087       0.0666         0.25       0.2300
	 [6,] -0.4 -0.0214      -0.1042       0.0614         0.16       0.1472
	 [7,] -0.3 -0.0217      -0.1013       0.0578         0.09       0.0828
	 [8,] -0.2 -0.0220      -0.0995       0.0555         0.04       0.0368
	 [9,] -0.1 -0.0223      -0.0986       0.0540         0.01       0.0092
	[10,]  0.0 -0.0226      -0.0985       0.0534         0.00       0.0000
	[11,]  0.1 -0.0228      -0.0991       0.0535         0.01       0.0092
	[12,]  0.2 -0.0231      -0.1006       0.0544         0.04       0.0368
	[13,]  0.3 -0.0234      -0.1030       0.0562         0.09       0.0828
	[14,]  0.4 -0.0237      -0.1065       0.0591         0.16       0.1472
	[15,]  0.5 -0.0241      -0.1117       0.0636         0.25       0.2300
	[16,]  0.6 -0.0245      -0.1194       0.0703         0.36       0.3311
	[17,]  0.7 -0.0251      -0.1314       0.0811         0.49       0.4507
	[18,]  0.8 -0.0260      -0.1525       0.1004         0.64       0.5887
	[19,]  0.9 -0.0280      -0.2020       0.1461         0.81       0.7450

	Rho at which ADE = 0: -0.9
	R^2_M*R^2_Y* at which ADE = 0: 0.81
	R^2_M~R^2_Y~ at which ADE = 0: 0.745

		### modified
		out.fit <- lm(MAXMPL ~ ATP + NUMPROCESSORS, data = x)
		summary(out.fit)
	
		Call:
		lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

		Residuals:
		    Min      1Q  Median      3Q     Max 
		-0.6563 -0.4660  0.3430  0.4753  0.5763 

		Coefficients:
			      Estimate Std. Error t value Pr(>|t|)    
		(Intercept)    0.52904    0.04079  12.970   <2e-16 ***
		ATP            0.15426    0.06521   2.366   0.0183 *  
		NUMPROCESSORS -0.10533    0.05877  -1.792   0.0736 .  
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.4796 on 605 degrees of freedom
		Multiple R-squared:  0.01771,	Adjusted R-squared:  0.01446 
		F-statistic: 5.454 on 2 and 605 DF,  p-value: 0.004492
	
	### thrashing samples
	Call:
	lm(formula = MAXMPL ~ SRTTXNRATE + PK + PCTUPDATE + ACTROWPOOL + 
	    ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.62019 -0.27103  0.06787  0.28197  0.57929 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.72409    0.07578   9.555  < 2e-16 ***
	SRTTXNRATE    -0.08668    0.13917  -0.623    0.534    
	PK             0.03856    0.03970   0.971    0.332    
	PCTUPDATE     -0.10502    0.06480  -1.621    0.106    
	ACTROWPOOL    -0.07999    0.07340  -1.090    0.277    
	ATP            0.05737    0.09489   0.605    0.546    
	NUMPROCESSORS -0.40026    0.06416  -6.239 1.65e-09 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3312 on 276 degrees of freedom
	Multiple R-squared:  0.1517,	Adjusted R-squared:  0.1332 
	F-statistic: 8.225 on 6 and 276 DF,  p-value: 3.355e-08

out.fit <- lm(MAXMPL ~ SRTTXNRATE + PK + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ SRTTXNRATE + PK + PCTUPDATE + ACTROWPOOL + 
	    ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.67153 -0.36319  0.08798  0.30519  0.68682 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.68853    0.07816   8.809  < 2e-16 ***
	SRTTXNRATE    -0.07395    0.14547  -0.508 0.611546    
	PK             0.05002    0.04132   1.211 0.226967    
	PCTUPDATE     -0.04295    0.06684  -0.643 0.520976    
	ACTROWPOOL    -0.12026    0.07704  -1.561 0.119507    
	ATP            0.16104    0.09570   1.683 0.093406 .  
	NUMPROCESSORS -0.22294    0.06541  -3.408 0.000737 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.371 on 321 degrees of freedom
	Multiple R-squared:  0.06986,	Adjusted R-squared:  0.05248 
	F-statistic: 4.018 on 6 and 321 DF,  p-value: 0.0006755

	Call:
	lm(formula = MAXMPL ~ PK + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, 
	    data = x)

	Residuals:
	      Min        1Q    Median        3Q       Max 
	-0.048622 -0.024299  0.008186  0.019510  0.049264 

	Coefficients:
		        Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.0490848  0.0057622   8.518 8.42e-16 ***
	PK             0.0064293  0.0030161   2.132   0.0339 *  
	PCTUPDATE      0.0000519  0.0051890   0.010   0.9920    
	ACTROWPOOL    -0.0064122  0.0053001  -1.210   0.2273    
	ATP           -0.0102690  0.0050386  -2.038   0.0424 *  
	NUMPROCESSORS -0.0212467  0.0046312  -4.588 6.63e-06 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.02553 on 295 degrees of freedom
	Multiple R-squared:  0.079,	Adjusted R-squared:  0.06339 
	F-statistic: 5.061 on 5 and 295 DF,  p-value: 0.0001819

	### modified
	out.fit <- lm(MAXMPL ~ ATP + NUMPROCESSORS, data = x)
	summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	Residuals:
	      Min        1Q    Median        3Q       Max 
	-0.044459 -0.024814  0.008915  0.020692  0.044578 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.047267   0.003280  14.413  < 2e-16 ***
	ATP           -0.008486   0.004935  -1.719   0.0866 .  
	NUMPROCESSORS -0.020138   0.004614  -4.364 1.76e-05 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.02566 on 298 degrees of freedom
	Multiple R-squared:  0.06033,	Adjusted R-squared:  0.05402 
	F-statistic: 9.566 on 2 and 298 DF,  p-value: 9.409e-05

library(car)
out.fit <- lm(MAXMPL ~ PK + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, data = x)
#out.fit <- lm(MAXMPL ~ ATP + NUMPROCESSORS, data = x)
outlierTest(out.fit)
No Studentized residuals with Bonferonni p < 0.05
Largest |rstudent|:
     rstudent unadjusted p-value Bonferonni p
409 -1.419422            0.15629           NA

#pdf("new_normal_res_qqplot.pdf")
#qqnorm(out.fit$res,main="",ylim=c(-0.8,0.6)); qqline(out.fit$res);
qqnorm(out.fit$res,main="",ylim=c(-0.8,0.6)); qqline(out.fit$res);
#dev.off()
pdf("new_normal_res_hist.pdf")
h <- hist(out.fit$res,main="",xlab="Residuals",ylim=c(0,100))
xfit<-seq(min(out.fit$res),max(out.fit$res),length=40) 
yfit<-dnorm(xfit,mean=mean(out.fit$res),sd=sd(out.fit$res)) 
yfit <- yfit*diff(h$mids[1:2])*length(out.fit$res) 
lines(xfit, yfit, col="blue")
dev.off()
plot(cooks.distance(out.fit), ylim=c(0,0.006), main="(CD shouldn't be greater than 1)", ylab="Cook's Distances (CDs)", xlab="Observeration Number")
ncvTest(out.fit)
	Non-constant Variance Score Test 
	Variance formula: ~ fitted.values 
	Chisquare = 0.6799235    Df = 1     p = 0.4096131
# Evaluate Collinearity
vif(out.fit) # variance inflation factors 
sqrt(vif(out.fit)) > 2 # problem?
> sqrt(vif(out.fit)) > 2
           PK     PCTUPDATE    ACTROWPOOL           ATP NUMPROCESSORS 
        FALSE         FALSE         FALSE         FALSE         FALSE

# Evaluate Nonlinearity
# component + residual plot 
pdf("linearity_assumption_test_result.pdf")
crPlots(out.fit, main = "",)
dev.off()

# Test for Autocorrelated Errors
durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.6570633     0.6819236       0
 Alternative hypothesis: rho != 0

#### thrashing or not thrashing
x = rbind(db2,mysql,oracle,pgsql,sqlserver)
x$MAXMPL[x$MAXMPL == 1] <- 2
x$MAXMPL[x$MAXMPL < 1] <- 1 ### thrashing
x$MAXMPL[x$MAXMPL == 2] <- 0### no thrashing
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTUPDATE = (x$PCTUPDATE/min(x$PCTUPDATE))/(max(x$PCTUPDATE)/min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))

#out.fit <-  glm(MAXMPL ~ PK + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, family="gaussian", data = x)
#out.fit <-  glm(MAXMPL ~ PK + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, family=gaussian(link = "identity"), data = x)
out.fit <-  glm(MAXMPL ~ PK + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, family=binomial("probit"), data = x)
#out.fit <-  glm(MAXMPL ~ PK + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, family=binomial("logit"), data = x)
summary(out.fit)

	Call:
	glm(formula = MAXMPL ~ PK + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, 
	    family = binomial("probit"), data = x)

	Deviance Residuals: 
	   Min      1Q  Median      3Q     Max  
	-1.449  -1.161  -0.896   1.143   1.555  

	Coefficients:
		      Estimate Std. Error z value Pr(>|z|)   
	(Intercept)   -0.32732    0.19498  -1.679  0.09320 . 
	PK             0.06753    0.10239   0.660  0.50954   
	PCTUPDATE      0.18505    0.18369   1.007  0.31373   
	ACTROWPOOL     0.28812    0.18302   1.574  0.11542   
	ATP           -0.44943    0.17380  -2.586  0.00971 **
	NUMPROCESSORS  0.23929    0.15464   1.547  0.12176   
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	(Dispersion parameter for binomial family taken to be 1)

	    Null deviance: 842.81  on 607  degrees of freedom
	Residual deviance: 828.68  on 602  degrees of freedom
	AIC: 840.68

wald.test(b = coef(out.fit), Sigma = vcov(out.fit), Terms = 2:6)
Wald test:
----------

Chi-squared test:
X2 = 13.8, df = 5, P(> X2) = 0.017

1-out.fit$deviance/out.fit$null.deviance
[1] 0.01675684 

###########################################################################################################################
