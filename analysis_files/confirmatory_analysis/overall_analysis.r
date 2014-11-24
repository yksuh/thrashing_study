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
#sqlserver_r$MAXMPL = (sqlserver_r$MAXMPL-min(sqlserver_r$MAXMPL))/(max(sqlserver_r$MAXMPL)-min(sqlserver_r$MAXMPL))
sqlserver_r$MAXMPL <- 1
sqlserver <- sqlserver_r
#### gother each DBMS' samples
x = rbind(db2,mysql,oracle,pgsql,sqlserver)
#x <- x[!is.na(x$MAXMPL),]
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD/min(x$PCTREAD))/(max(x$PCTREAD)/min(x$PCTREAD))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
nrow(x)
[1] 539
x <- subset(x, x$MAXMPL < 1)
nrow(x)
[1] 101

> cor.test(x$NUMPROCESSORS, x$ATP)
	##### all  samples
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -7.6998, df = 537, p-value = 6.595e-14
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.3894070 -0.2371818
	sample estimates:
	       cor 
	-0.3153213

	#### only thrashing samples
	#Pearson's product-moment correlation

	#data:  x$NUMPROCESSORS and x$ATP
	#t = 0.0611, df = 134, p-value = 0.9514
	#alternative hypothesis: true correlation is not equal to 0
	#95 percent confidence interval:
	# -0.1631981  0.1734586
	#sample estimates:
	#	cor 
	#0.005279871

> cor.test(x$PK, x$ATP)
	#####  all  samples
	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -2.8926, df = 537, p-value = 0.003976
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.20616283 -0.03982434
	sample estimates:
	       cor 
	-0.1238636

	#### only thrashing samples
	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -7.6641, df = 134, p-value = 3.248e-12
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.6591314 -0.4230289
	sample estimates:
	       cor 
	-0.5520504

med.fit <- lm(ATP ~ NUMPROCESSORS + PK, data = x)
summary(med.fit)
	#### all samples
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.4653 -0.2800 -0.1065  0.2249  0.7920 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.54367    0.03087  17.610  < 2e-16 ***
	NUMPROCESSORS -0.33564    0.04256  -7.886 1.76e-14 ***
	PK            -0.09126    0.02739  -3.332  0.00092 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3175 on 536 degrees of freedom
	Multiple R-squared:  0.1177,	Adjusted R-squared:  0.1144 
	F-statistic: 35.75 on 2 and 536 DF,  p-value: 2.655e-15

	#### only thrashing samples
	med.fit <- lm(ATP ~ NUMPROCESSORS + PK, data = x)
	summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.33977 -0.10162 -0.03821  0.16583  0.50634 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.35025    0.03279  10.680  < 2e-16 ***
	NUMPROCESSORS -0.02351    0.04758  -0.494    0.622    
	PK            -0.24262    0.03168  -7.658 3.46e-12 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1808 on 133 degrees of freedom
	Multiple R-squared:  0.306,	Adjusted R-squared:  0.2956 
	F-statistic: 29.33 on 2 and 133 DF,  p-value: 2.812e-11

> cor.test(x$PK, x$MAXMPL)
	#### all samples
	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 3.06, df = 537, p-value = 0.002324
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.04697483 0.21301212
	sample estimates:
	      cor 
	0.1309114

	#### only thrashing samples
	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 1.2329, df = 134, p-value = 0.2198
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.06355475  0.26944042
	sample estimates:
	      cor 
	0.1059112

cor.test(x$ATP, x$MAXMPL)
	#### all samples
	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = 2.8526, df = 537, p-value = 0.004504
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.03811297 0.20452113
	sample estimates:
	      cor 
	0.1221756

	#### only thrashing samples
	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -4.9004, df = 134, p-value = 2.715e-06
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.5237991 -0.2370632
	sample estimates:
	       cor 
	-0.3898393

cor.test(x$NUMPROCESSORS, x$MAXMPL)
	#### all samples
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = 0.9968, df = 537, p-value = 0.3193
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.0416309  0.1269711
	sample estimates:
	       cor 
	0.0429760

	#### only thrashing samples
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = 1.5228, df = 134, p-value = 0.1302
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.03875423  0.29234383
	sample estimates:
	      cor 
	0.1304295

out.fit <- lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
summary(out.fit)
	#### all samples
	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.8218 -0.5123  0.1874  0.2845  0.4159 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.54578    0.05038  10.833  < 2e-16 ***
	PK             0.13148    0.03594   3.659 0.000279 ***
	ATP            0.21733    0.05610   3.874 0.000120 ***
	NUMPROCESSORS  0.13536    0.05840   2.318 0.020828 *  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.4124 on 535 degrees of freedom
	Multiple R-squared:  0.04617,	Adjusted R-squared:  0.04082 
	F-statistic: 8.632 on 3 and 535 DF,  p-value: 1.329e-05

	#### only thrashing samples
	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	      Min        1Q    Median        3Q       Max 
	-0.048454 -0.015391 -0.004775  0.017906  0.044073 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.042708   0.005527   7.727 2.47e-12 ***
	PK            -0.007191   0.004703  -1.529    0.129    
	ATP           -0.053440   0.010723  -4.984 1.92e-06 ***
	NUMPROCESSORS  0.009119   0.005889   1.549    0.124    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.02236 on 132 degrees of freedom
	Multiple R-squared:  0.184,	Adjusted R-squared:  0.1654 
	F-statistic:  9.92 on 3 and 132 DF,  p-value: 6.067e-06
	

#### thrashing or not thrashing
x = rbind(db2,mysql,oracle,pgsql,sqlserver)
x <- x[!is.na(x$MAXMPL),]
x$MAXMPL[x$MAXMPL == 1] <- 2
x$MAXMPL[x$MAXMPL < 1] <- 1 ### thrashing
x$MAXMPL[x$MAXMPL == 2] <- 0### no thrashing
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD/min(x$PCTREAD))/(max(x$PCTREAD)/min(x$PCTREAD))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
#out.fit <-  glm(MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, family="gaussian", data = x)
#out.fit <-  glm(MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, family=gaussian(link = "identity"), data = x)
#out.fit <-  glm(MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, family=binomial("logit"), data = x)
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS, family=binomial("probit"), data = x)
summary(out.fit)

	Call:
	glm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, family = binomial("probit"), 
	    data = x)

	Deviance Residuals: 
	    Min       1Q   Median       3Q      Max  
	-1.1165  -0.8234  -0.6568   1.2133   1.9657  

	Coefficients:
		      Estimate Std. Error z value Pr(>|z|)    
	(Intercept)    0.03282    0.16389   0.200 0.841264    
	PK            -0.47019    0.12295  -3.824 0.000131 ***
	ATP           -0.84706    0.20148  -4.204 2.62e-05 ***
	NUMPROCESSORS -0.42538    0.19434  -2.189 0.028610 *  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	(Dispersion parameter for binomial family taken to be 1)

	    Null deviance: 608.93  on 538  degrees of freedom
	Residual deviance: 581.27  on 535  degrees of freedom
	AIC: 589.27

	Number of Fisher Scoring iterations: 5

library(aod)
library(ggplot2)

wald.test(b = coef(out.fit), Sigma = vcov(out.fit), Terms = 2:6)
Wald test:
----------

Chi-squared test:
X2 = 26.0, df = 5, P(> X2) = 9.1e-05

1-out.fit$deviance/out.fit$null.deviance
[1] 0.04661541

### modified
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS, family=binomial("probit"), data = x)
summary(out.fit)

wald.test(b = coef(out.fit), Sigma = vcov(out.fit), Terms = 2:4)
Wald test:
----------

Chi-squared test:
X2 = 27.6, df = 3, P(> X2) = 4.3e-06

1-out.fit$deviance/out.fit$null.deviance
0.04542867

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
[1] 800
x <- subset(x, x$MAXMPL < 1)
nrow(x)
[1] 334

cor.test(x$NUMPROCESSORS, x$ATP)
	#####  all samples 
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -4.4186, df = 798, p-value = 1.131e-05
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.22147849 -0.08614531
	sample estimates:
	       cor 
	-0.1545367
	
	#####  thrashing samples 
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -3.623, df = 332, p-value = 0.0003367
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.29613904 -0.08958263
	sample estimates:
	       cor 
	-0.1950223

cor.test(x$PK, x$ATP)
	#####  all samples 
	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -5.9804, df = 798, p-value = 3.357e-09
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2725157 -0.1398067
	sample estimates:
	       cor 
	-0.2071138

	#####  thrashing samples
	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -3.302, df = 332, p-value = 0.001065
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.28026675 -0.07238599
	sample estimates:
	       cor 
	-0.1783154

med.fit <- lm(ATP ~ NUMPROCESSORS, data = x)
summary(med.fit)
	#####  all samples 
	Call:
	lm(formula = ATP ~ NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.46328 -0.33978 -0.04831  0.34901  0.68995 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.48556    0.02442  19.880  < 2e-16 ***
	NUMPROCESSORS -0.17551    0.03972  -4.419 1.13e-05 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3597 on 798 degrees of freedom
	Multiple R-squared:  0.02388,	Adjusted R-squared:  0.02266 
	F-statistic: 19.52 on 1 and 798 DF,  p-value: 1.131e-0	

	#####  thrashing samples 
	Call:
	lm(formula = ATP ~ NUMPROCESSORS, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.4461 -0.3215 -0.1280  0.3467  0.7198 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.50196    0.03981  12.608  < 2e-16 ***
	NUMPROCESSORS -0.22179    0.06122  -3.623 0.000337 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3542 on 332 degrees of freedom
	Multiple R-squared:  0.03803,	Adjusted R-squared:  0.03514 
	F-statistic: 13.13 on 1 and 332 DF,  p-value: 0.0003367


cor.test(x$ATP, x$MAXMPL)
	#####  all samples 
	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = 1.0284, df = 798, p-value = 0.3041
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.03301654  0.10542918
	sample estimates:
	       cor 
	0.03638088

	#####  thrashing samples 
	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -3.7311, df = 332, p-value = 0.0002242
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.30143284 -0.09534567
	sample estimates:
	       cor 
	-0.2006076

cor.test(x$NUMPROCESSORS, x$MAXMPL)
	#####  all samples 
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = -3.3273, df = 798, p-value = 0.000917
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1847934 -0.0480530
	sample estimates:
	       cor 
	-0.1169775

	#####  thrashing samples 
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = -2.652, df = 332, p-value = 0.008386
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.24751781 -0.03729086
	sample estimates:
	      cor 
	-0.144029

out.fit <- lm(MAXMPL ~ ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	##### all samples 
	Call:
	lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.6735 -0.5382  0.3415  0.4052  0.4958 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.67481    0.03954  17.066  < 2e-16 ***
	ATP            0.02469    0.04687   0.527  0.59853    
	NUMPROCESSORS -0.17056    0.05323  -3.204  0.00141 ** 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.4762 on 797 degrees of freedom
	Multiple R-squared:  0.01403,	Adjusted R-squared:  0.01155 
	F-statistic: 5.669 on 2 and 797 DF,  p-value: 0.003591


	### thrashing samples
	Call:
	lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	Residuals:
	      Min        1Q    Median        3Q       Max 
	-0.039537 -0.020929 -0.005472  0.016778  0.053876 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.044274   0.003222  13.740  < 2e-16 ***
	ATP           -0.016112   0.003653  -4.411 1.39e-05 ***
	NUMPROCESSORS -0.014675   0.004154  -3.533  0.00047 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.02357 on 331 degrees of freedom
	Multiple R-squared:  0.07511,	Adjusted R-squared:  0.06953 
	F-statistic: 13.44 on 2 and 331 DF,  p-value: 2.441e-06

library(car)
out.fit <- lm(MAXMPL ~ PK + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, data = x)
#out.fit <- lm(MAXMPL ~ ATP + NUMPROCESSORS, data = x)
outlierTest(out.fit)
#pdf("new_normal_res_qqplot.pdf")
qqnorm(out.fit$res,main="",ylim=c(-0.8,0.6)); qqline(out.fit$res);
#dev.off()
#pdf("new_normal_res_hist.pdf")
h <- hist(out.fit$res,main="",xlab="Residuals",ylim=c(0,200))
xfit<-seq(min(out.fit$res),max(out.fit$res),length=40) 
yfit<-dnorm(xfit,mean=mean(out.fit$res),sd=sd(out.fit$res)) 
yfit <- yfit*diff(h$mids[1:2])*length(out.fit$res) 
lines(xfit, yfit, col="blue")
#dev.off()
cd = cooks.distance(out.fit)
plot(cd, main="(CD shouldn't be greater than 1)", ylab="Cook's Distances (CDs)", xlab="Observeration Number")
ncvTest(out.fit)
	Non-constant Variance Score Test 
	Variance formula: ~ fitted.values 
	Chisquare = 1.833295    Df = 1     p = 0.1757389
# Evaluate Collinearity
vif(out.fit) # variance inflation factors 
sqrt(vif(out.fit)) > 2 # problem?

# Evaluate Nonlinearity
# component + residual plot 
pdf("linearity_assumption_test_result.pdf")
crPlots(out.fit, main = "",)
dev.off()

# Test for Autocorrelated Errors
durbinWatsonTest(out.fit)
 
lag Autocorrelation D-W Statistic p-value
   1       0.7448362     0.5092197       0
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
	    Min       1Q   Median       3Q      Max  
	-1.4404  -0.9621  -0.7881   1.2278   1.8134  

	Coefficients:
		      Estimate Std. Error z value Pr(>|z|)    
	(Intercept)    -0.5876     0.2189  -2.684  0.00728 ** 
	PK              0.1021     0.1074   0.950  0.34190    
	PCTUPDATE       0.2295     0.1858   1.235  0.21677    
	ACTROWPOOL      0.4421     0.1871   2.363  0.01811 *  
	ATP            -0.6239     0.1585  -3.935 8.32e-05 ***
	NUMPROCESSORS   0.2115     0.1637   1.292  0.19620    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	(Dispersion parameter for binomial family taken to be 1)

	    Null deviance: 829.61  on 623  degrees of freedom
	Residual deviance: 797.54  on 618  degrees of freedom
	AIC: 809.54

	Number of Fisher Scoring iterations: 4

wald.test(b = coef(out.fit), Sigma = vcov(out.fit), Terms = 2:6)
Wald test:
----------

Chi-squared test:
X2 = 31.2, df = 5, P(> X2) = 8.7e-06

1-out.fit$deviance/out.fit$null.deviance
[1] 0.03864955
