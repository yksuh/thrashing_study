# Overall: 33.4% (close to suboptimal)
library(aod)
library(ggplot2)
x = read.csv(file="cnfm.dat",head=TRUE,sep="\t")
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
[1] 410
x <- subset(x, x$MAXMPL < 1)
nrow(x)
[1] 101

cor(x$NUMPROCESSORS, x$ATP)
0.01

cor(x$PCTREAD, x$ATP)
-0.32

cor(x$PK, x$ATP)
-0.48

cor(x$PCTREAD*x$PK, x$ATP)
-0.37

med.fit <- lm(ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.36310 -0.10358 -0.01467  0.14420  0.51751 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.39741    0.03692  10.765  < 2e-16 ***
	NUMPROCESSORS -0.01231    0.05038  -0.244  0.80756    
	PK            -0.23832    0.04952  -4.813 5.54e-06 ***
	PCTREAD       -0.16370    0.04921  -3.326  0.00125 ** 
	PK:PCTREAD     0.09826    0.07767   1.265  0.20893    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1747 on 96 degrees of freedom
	Multiple R-squared:   0.32,	Adjusted R-squared:  0.2916 
	F-statistic: 11.29 on 4 and 96 DF,  p-value: 1.496e-0

cor(x$PK, x$MAXMPL)
[1] 0.19

cor(x$ATP, x$MAXMPL)
[1] -0.53

cor(x$NUMPROCESSORS, x$MAXMPL)
[1] 0.10

cor(x$ACTROWPOOL, x$MAXMPL)
[1] 0.03

cor(x$PCTREAD, x$MAXMPL)
[1] 0.16

out.fit <- lm(MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.45397 -0.11783  0.00519  0.12364  0.42313 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.398099   0.076218   5.223 1.04e-06 ***
	PK            -0.039496   0.050131  -0.788    0.433    
	PCTREAD       -0.008156   0.048542  -0.168    0.867    
	ACTROWPOOL     0.087130   0.079159   1.101    0.274    
	ATP           -0.694167   0.123641  -5.614 1.95e-07 ***
	NUMPROCESSORS  0.066627   0.061046   1.091    0.278    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2115 on 95 degrees of freedom
	Multiple R-squared:  0.3037,	Adjusted R-squared:  0.267 
	F-statistic: 8.287 on 5 and 95 DF,  p-value: 1.569e-06

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
out.fit <-  glm(MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, family=binomial("probit"), data = x)
summary(out.fit)

	Call:
	glm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, 
	    family = binomial("probit"), data = x)

	Deviance Residuals: 
	    Min       1Q   Median       3Q      Max  
	-1.9406  -0.8281  -0.4891   0.9802   2.0908  

	Coefficients:
		      Estimate Std. Error z value Pr(>|z|)    
	(Intercept)     0.7363     0.2763   2.665 0.007701 ** 
	PK             -0.9466     0.1778  -5.324 1.02e-07 ***
	PCTREAD         0.3480     0.1811   1.921 0.054688 .  
	ACTROWPOOL      0.2416     0.2871   0.842 0.400050    
	ATP            -1.8401     0.2878  -6.393 1.63e-10 ***
	NUMPROCESSORS  -0.8453     0.2329  -3.629 0.000284 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	(Dispersion parameter for binomial family taken to be 1)

	    Null deviance: 403.56  on 325  degrees of freedom
	Residual deviance: 333.74  on 320  degrees of freedom
	AIC: 345.74

	Number of Fisher Scoring iterations: 6

wald.test(b = coef(out.fit), Sigma = vcov(out.fit), Terms = 2:6)
Wald test:
----------

Chi-squared test:
X2 = 56.4, df = 5, P(> X2) = 6.8e-11

> 1-out.fit$deviance/out.fit$null.deviance
[1] 0.1730

### update-only
library(aod)
library(ggplot2)
x = read.csv(file="cnfm.dat",head=TRUE,sep="\t")
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
[1] 624
x <- subset(x, x$MAXMPL < 1)
nrow(x)
[1] 238

cor(x$NUMPROCESSORS, x$ATP)
-0.22

cor(x$PCTUPDATE, x$ATP)
0.06

cor(x$PK, x$ATP)
-0.22

cor(x$PCTUPDATE*x$PK, x$ATP)
-0.18

med.fit <- lm(ATP ~ NUMPROCESSORS + PK + PCTUPDATE + PCTUPDATE:PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK + PCTUPDATE + PCTUPDATE:PK, 
	    data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.5136 -0.3217 -0.1439  0.3538  0.6216 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.53312    0.10016   5.323  2.4e-07 ***
	NUMPROCESSORS -0.24359    0.06910  -3.525 0.000509 ***
	PK            -0.11123    0.12130  -0.917 0.360076    
	PCTUPDATE      0.12896    0.13083   0.986 0.325314    
	PK:PCTUPDATE  -0.09417    0.17387  -0.542 0.588609    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3656 on 233 degrees of freedom
	Multiple R-squared:  0.102,	Adjusted R-squared:  0.08657 
	F-statistic: 6.615 on 4 and 233 DF,  p-value: 4.651e-05

cor(x$PK, x$MAXMPL)
[1] -0.176

cor(x$ATP, x$MAXMPL)
[1] -0.19

cor(x$NUMPROCESSORS, x$MAXMPL)
[1] -0.0197

cor(x$ACTROWPOOL, x$MAXMPL)
[1] -0.16

cor(x$PCTUPDATE, x$MAXMPL)
[1] 0.049

out.fit <- lm(MAXMPL ~ PK + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.43838 -0.17432 -0.02565  0.18911  0.55984 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.51054    0.06151   8.299 8.62e-15 ***
	PK            -0.10446    0.03001  -3.481 0.000597 ***
	PCTUPDATE      0.04344    0.05258   0.826 0.409564    
	ACTROWPOOL    -0.11456    0.05292  -2.165 0.031436 *  
	ATP           -0.15412    0.03997  -3.856 0.000149 ***
	NUMPROCESSORS -0.05459    0.04317  -1.265 0.207217    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2226 on 232 degrees of freedom
	Multiple R-squared:  0.1131,	Adjusted R-squared:  0.09402 
	F-statistic: 5.919 on 5 and 232 DF,  p-value: 3.586e-05

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
