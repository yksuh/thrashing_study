# Overall: 33.4% (close to suboptimal)
library(aod)
library(ggplot2)
x = read.csv(file="total.dat",head=TRUE,sep="\t")
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
[1] 811
x <- subset(x, x$MAXMPL < 1)
nrow(x)
[1] 299

cor(x$NUMPROCESSORS, x$ATP)
0.09

cor(x$PCTREAD, x$ATP)
-0.09

cor(x$PK, x$ATP)
-0.48

cor(x$PCTREAD*x$PK, x$ATP)
-0.32

med.fit <- lm(ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.33275 -0.16341 -0.01285  0.14907  0.57005 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.315545   0.024970  12.637  < 2e-16 ***
	NUMPROCESSORS  0.035168   0.037227   0.945    0.346    
	PK            -0.246449   0.035244  -6.993 1.82e-11 ***
	PCTREAD       -0.031792   0.033299  -0.955    0.340    
	PK:PCTREAD     0.007134   0.056909   0.125    0.900    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.21 on 294 degrees of freedom
	Multiple R-squared:  0.2402,	Adjusted R-squared:  0.2298 
	F-statistic: 23.23 on 4 and 294 DF,  p-value: < 2.2e-16

cor(x$PK, x$MAXMPL)
[1] 0.27

cor(x$ATP, x$MAXMPL)
[1] -0.40

cor(x$NUMPROCESSORS, x$MAXMPL)
[1] 0.08

cor(x$ACTROWPOOL, x$MAXMPL)
[1] -0.07

cor(x$PCTREAD, x$MAXMPL)
[1] 0.08

out.fit <- lm(MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.47136 -0.15171 -0.00931  0.16239  0.56621 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.32508    0.04224   7.695 2.17e-13 ***
	PK             0.05677    0.03070   1.849   0.0654 .  
	PCTREAD        0.01536    0.02785   0.551   0.5818    
	ACTROWPOOL    -0.04516    0.04576  -0.987   0.3245    
	ATP           -0.34924    0.06007  -5.814 1.59e-08 ***
	NUMPROCESSORS  0.08876    0.03840   2.311   0.0215 *  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.216 on 293 degrees of freedom
	Multiple R-squared:  0.1869,	Adjusted R-squared:  0.173 
	F-statistic: 13.47 on 5 and 293 DF,  p-value: 7.829e-12

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
	-1.5697  -0.9402  -0.6167   1.1247   2.0975  

	Coefficients:
		      Estimate Std. Error z value Pr(>|z|)    
	(Intercept)    0.31311    0.15439   2.028   0.0425 *  
	PK            -0.82177    0.09673  -8.496  < 2e-16 ***
	PCTREAD        0.22961    0.10629   2.160   0.0308 *  
	ACTROWPOOL     0.10400    0.16766   0.620   0.5351    
	ATP           -0.40928    0.16492  -2.482   0.0131 *  
	NUMPROCESSORS -0.65070    0.13950  -4.665 3.09e-06 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	(Dispersion parameter for binomial family taken to be 1)

	    Null deviance: 1067.7  on 810  degrees of freedom
	Residual deviance:  972.3  on 805  degrees of freedom
	AIC: 984.3

	Number of Fisher Scoring iterations: 4

wald.test(b = coef(out.fit), Sigma = vcov(out.fit), Terms = 2:6)
Wald test:
----------

Chi-squared test:
X2 = 90.3, df = 5, P(> X2) = 0.0

> 1-out.fit$deviance/out.fit$null.deviance
[1] 0.09

### update-only
library(aod)
library(ggplot2)
x = read.csv(file="total.dat",head=TRUE,sep="\t")
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
[1] 1232
x <- subset(x, x$MAXMPL < 1)
nrow(x)
[1] 539

cor(x$NUMPROCESSORS, x$ATP)
-0.15

cor(x$PCTUPDATE, x$ATP)
0.005

cor(x$PK, x$ATP)
-0.02

cor(x$PCTUPDATE*x$PK, x$ATP)
-0.04

med.fit <- lm(ATP ~ NUMPROCESSORS + PK + PCTUPDATE + PCTUPDATE:PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK + PCTUPDATE + PCTUPDATE:PK, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.30111 -0.20345 -0.14636  0.05058  0.83888 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.24051    0.05522   4.355 1.59e-05 ***
	NUMPROCESSORS -0.13808    0.04071  -3.392 0.000745 ***
	PK             0.06957    0.06908   1.007 0.314341    
	PCTUPDATE      0.07826    0.07294   1.073 0.283784    
	PK:PCTUPDATE  -0.12814    0.09944  -1.289 0.198106    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3222 on 534 degrees of freedom
	Multiple R-squared:  0.02535,	Adjusted R-squared:  0.01805 
	F-statistic: 3.472 on 4 and 534 DF,  p-value: 0.008185

cor(x$PK, x$MAXMPL)
[1] -0.03

cor(x$ATP, x$MAXMPL)
[1] -0.097

cor(x$NUMPROCESSORS, x$MAXMPL)
[1] -0.15

cor(x$ACTROWPOOL, x$MAXMPL)
[1] -0.11

cor(x$PCTUPDATE, x$MAXMPL)
[1] 0.007

out.fit <- lm(MAXMPL ~ PK + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.44464 -0.22723 -0.00216  0.21396  0.44281 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.47887    0.04179  11.458  < 2e-16 ***
	PK            -0.01156    0.02126  -0.544 0.586789    
	PCTUPDATE      0.00540    0.03784   0.143 0.886575    
	ACTROWPOOL    -0.09301    0.03850  -2.416 0.016018 *  
	ATP           -0.08650    0.03313  -2.611 0.009272 ** 
	NUMPROCESSORS -0.11979    0.03138  -3.818 0.000151 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2459 on 533 degrees of freedom
	Multiple R-squared:  0.047,	Adjusted R-squared:  0.03806 
	F-statistic: 5.257 on 5 and 533 DF,  p-value: 0.0001007

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
	-1.6070  -1.0390  -0.6653   1.0552   1.9727  

	Coefficients:
		      Estimate Std. Error z value Pr(>|z|)    
	(Intercept)   -0.27904    0.14469  -1.929 0.053784 .  
	PK             0.01515    0.07517   0.202 0.840234    
	PCTUPDATE      0.24351    0.13332   1.826 0.067775 .  
	ACTROWPOOL     0.46363    0.13368   3.468 0.000524 ***
	ATP           -1.24889    0.11494 -10.866  < 2e-16 ***
	NUMPROCESSORS  0.16999    0.11173   1.521 0.128152    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	(Dispersion parameter for binomial family taken to be 1)

	    Null deviance: 1688.6  on 1231  degrees of freedom
	Residual deviance: 1540.8  on 1226  degrees of freedom
	AIC: 1552.8

	Number of Fisher Scoring iterations: 4

wald.test(b = coef(out.fit), Sigma = vcov(out.fit), Terms = 2:6)
Wald test:
----------

Chi-squared test:
X2 = 137.1, df = 5, P(> X2) = 0.0

1-out.fit$deviance/out.fit$null.deviance
[1] 0.08754144

####################################################
