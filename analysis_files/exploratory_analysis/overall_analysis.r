# Overall: 33.4% (close to suboptimal)
library(aod)
library(ggplot2)
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
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
x = rbind(db2,mysql,oracle,pgsql,sqlserver)
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD/min(x$PCTREAD))/(max(x$PCTREAD)/min(x$PCTREAD))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
nrow(x)
[1] 401
x <- subset(x, x$MAXMPL < 1)
nrow(x)
[1] 198

cor(x$NUMPROCESSORS, x$ATP)
-0.09

cor(x$PCTREAD, x$ATP)
0.01

cor(x$PK, x$ATP)
-0.36

cor(x$PCTREAD*x$PK, x$ATP)
-0.23

med.fit <- lm(ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK, data = x)
summary(med.fit)

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

	##### Alternative
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

cor(x$PK, x$MAXMPL)
[1] 0.2891473

cor(x$ATP, x$MAXMPL)
[1] 0.02110625

cor(x$NUMPROCESSORS, x$MAXMPL)
[1] 0.08

cor(x$ACTROWPOOL, x$MAXMPL)
[1] -0.13

cor(x$PCTREAD, x$MAXMPL)
[1] 0.02

out.fit <- lm(MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

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

	#### alternative by mixed
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

#### thrashing or not thrashing
x = rbind(db2,mysql,oracle,pgsql,sqlserver)
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
###########################################################################################################################

x = read.csv(file="expl.dat",head=TRUE,sep="\t")
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
x <- subset(x, x$MAXMPL < 1)
nrow(x)
[1] 301

cor(x$NUMPROCESSORS, x$ATP)
-0.33

cor(x$PCTUPDATE, x$ATP)
-0.01

cor(x$PK, x$ATP)
0.18

cor(x$PCTUPDATE*x$PK, x$ATP)
0.13

med.fit <- lm(ATP ~ NUMPROCESSORS + PK + PCTUPDATE + PCTUPDATE:PK, data = x)
summary(med.fit)

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

cor(x$PK, x$MAXMPL)
[1] 0.08220043

cor(x$ATP, x$MAXMPL)
[1] -0.02

cor(x$NUMPROCESSORS, x$MAXMPL)
[1] -0.23

cor(x$ACTROWPOOL, x$MAXMPL)
[1] -0.07

cor(x$PCTUPDATE, x$MAXMPL)
[1] -0.009013733

out.fit <- lm(MAXMPL ~ PK + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.48433 -0.24118  0.08279  0.19517  0.48709 

	Coefficients:
		        Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.4476441  0.0406450  11.013  < 2e-16 ***
	PK             0.0634629  0.0299860   2.116   0.0351 *  
	PCTUPDATE      0.0001043  0.0386918   0.003   0.9979    
	ACTROWPOOL    -0.0478991  0.0395205  -1.212   0.2265    
	ATP           -0.1026376  0.0500943  -2.049   0.0414 *  
	NUMPROCESSORS -0.1867884  0.0402880  -4.636 5.33e-06 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2539 on 295 degrees of freedom
	Multiple R-squared:  0.08012,	Adjusted R-squared:  0.06453 
	F-statistic: 5.139 on 5 and 295 DF,  p-value: 0.0001549

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

	Number of Fisher Scoring iterations: 4

wald.test(b = coef(out.fit), Sigma = vcov(out.fit), Terms = 2:6)
Wald test:
----------

Chi-squared test:
X2 = 13.8, df = 5, P(> X2) = 0.017

1-out.fit$deviance/out.fit$null.deviance
[1] 0.02

###########################################################################################################################
