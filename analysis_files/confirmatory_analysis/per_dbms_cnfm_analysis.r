# Overall: 33.4% (close to suboptimal)
library(aod)
library(ggplot2)
y = read.csv(file="cnfm.dat",head=TRUE,sep="\t")
y_r <- subset(y, y$PCTREAD!=0)
y_r <- subset(y_r, select = -PCTUPDATE)
y <- y_r
nrow(y)
y <- subset(y, y$ATP < 120000)
#y <- subset(y, y$MAXMPL < 1100)
# db2
db2 <- subset(y, y$DBMS=='db2')
db2$ATP = (db2$ATP-min(db2$ATP))/(max(db2$ATP)-min(db2$ATP))
db2$MAXMPL = (db2$MAXMPL-min(db2$MAXMPL))/(max(db2$MAXMPL)-min(db2$MAXMPL))
nrow(db2)
# oracle
oracle <- subset(y, y$DBMS=='oracle')
oracle$ATP = (oracle$ATP-min(oracle$ATP))/(max(oracle$ATP)-min(oracle$ATP))
oracle$MAXMPL = (oracle$MAXMPL-min(oracle$MAXMPL))/(max(oracle$MAXMPL)-min(oracle$MAXMPL))
nrow(oracle)
# mysql
mysql <- subset(y, y$DBMS=='mysql')
mysql$ATP = (mysql$ATP-min(mysql$ATP))/(max(mysql$ATP)-min(mysql$ATP))
mysql$MAXMPL = (mysql$MAXMPL-min(mysql$MAXMPL))/(max(mysql$MAXMPL)-min(mysql$MAXMPL))
nrow(mysql)
# pgsql
pgsql <- subset(y, y$DBMS=='pgsql')
pgsql$ATP = (pgsql$ATP-min(pgsql$ATP))/(max(pgsql$ATP)-min(pgsql$ATP))
if(max(pgsql$MAXMPL)-min(pgsql$MAXMPL)==0) {
    pgsql$MAXMPL = 0
} else { 
    pgsql$MAXMPL = (pgsql$MAXMPL-min(pgsql$MAXMPL))/(max(pgsql$MAXMPL)-min(pgsql$MAXMPL))
}
nrow(pgsql)
# sqlserver
sqlserver <- subset(y, y$DBMS=='sqlserver')
sqlserver$ATP = (sqlserver$ATP-min(sqlserver$ATP))/(max(sqlserver$ATP)-min(sqlserver$ATP))
if(max(sqlserver$MAXMPL)-min(sqlserver$MAXMPL)==0) {
    sqlserver$MAXMPL = 0
} else { 
    sqlserver$MAXMPL = (sqlserver$MAXMPL-min(sqlserver$MAXMPL))/(max(sqlserver$MAXMPL)-min(sqlserver$MAXMPL))
}
nrow(sqlserver)
#### gother each DBMS' samples
x = rbind(db2)
x = rbind(mysql)
x = rbind(oracle)
x = rbind(pgsql)
x = rbind(sqlserver)
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD/min(x$PCTREAD))/(max(x$PCTREAD)/min(x$PCTREAD))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))

med.fit <- lm(ATP ~ NUMPROCESSORS + PK, data = x)
summary(med.fit)

out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
summary(out.fit)
	
### ATP time ####
DBMS X
=> 13%
MySQL
=> 43%
DBMS Y
=> 17%
PostgreSQL
=> N/A
DBMS Z
=> 38%

### MaxMPL ####
DBMS X
=> 14%
MySQL
=> 28%
DBMS Y
=> 7%
PostgreSQL
=> N/A
DBMS Z
=> 18%

#### per-DBMS for ATP time ###
for DBMS X, 
	med.fit <- lm(ATP ~ PCTREAD + NUMPROCESSORS + PK, data = x)
	summary(med.fit)

	Call:
	lm(formula = ATP ~ PCTREAD + NUMPROCESSORS + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.28429 -0.19611 -0.03788  0.03777  0.77544 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.30461    0.06826   4.463 2.29e-05 ***
	PCTREAD       -0.25456    0.06370  -3.996  0.00013 ***
	NUMPROCESSORS -0.01292    0.01071  -1.206  0.23094    
	PK             0.02030    0.05702   0.356  0.72268    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2779 on 92 degrees of freedom
	Multiple R-squared:  0.1543,	Adjusted R-squared:  0.1267 
	F-statistic: 5.594 on 3 and 92 DF,  p-value: 0.001437

for MySQL =>
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.21398 -0.13991 -0.08745 -0.05724  0.82688 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.71605    0.06288  11.388  < 2e-16 ***
	NUMPROCESSORS -0.11857    0.08504  -1.394    0.166    
	PK            -0.48631    0.05597  -8.689 9.01e-14 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2795 on 97 degrees of freedom
	Multiple R-squared:  0.4407,	Adjusted R-squared:  0.4292 
	F-statistic: 38.22 on 2 and 97 DF,  p-value: 5.752e-13

for DBMS Y =>
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.33304 -0.14029 -0.06953  0.11846  0.74812 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.48367    0.07088   6.824 8.66e-09 ***
	NUMPROCESSORS -0.23421    0.09340  -2.508  0.01525 *  
	PK            -0.17324    0.05968  -2.903  0.00538 ** 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2184 on 53 degrees of freedom
	Multiple R-squared:  0.2003,	Adjusted R-squared:  0.1701 
	F-statistic: 6.638 on 2 and 53 DF,  p-value: 0.002676

for PostgreSQL =>
	N/A

for DBMS Z =>
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.34119 -0.20854 -0.01934  0.15858  0.56843 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.41151    0.04849   8.487 7.62e-14 ***
	NUMPROCESSORS -0.58252    0.06994  -8.329 1.76e-13 ***
	PK             0.09287    0.04478   2.074   0.0403 *  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2453 on 117 degrees of freedom
	Multiple R-squared:  0.3864,	Adjusted R-squared:  0.3759 
	F-statistic: 36.84 on 2 and 117 DF,  p-value: 3.904e-13

#### per-DBMS for MaxMPL #####
for DBMS X, 
	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.83214 -0.11895  0.08794  0.19252  0.36289 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.56632    0.06848   8.270  5.6e-13 ***
	PK             0.02607    0.05770   0.452  0.65231    
	ATP            0.31940    0.09208   3.469  0.00077 ***
	NUMPROCESSORS  0.29851    0.08842   3.376  0.00104 ** 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2948 on 101 degrees of freedom
	Multiple R-squared:  0.1652,	Adjusted R-squared:  0.1404 
	F-statistic: 6.664 on 3 and 101 DF,  p-value: 0.0003761

for MySQL, 
	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.3548 -0.1804 -0.1258  0.3759  0.8632 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)
	(Intercept)     1.3698     1.3869   0.988    0.329
	PK             -1.3131     1.1898  -1.104    0.276
	ATP            -1.3669     1.3949  -0.980    0.333
	NUMPROCESSORS   0.3201     0.2625   1.220    0.230

	Residual standard error: 0.2941 on 41 degrees of freedom
	Multiple R-squared:  0.3283,	Adjusted R-squared:  0.2791 
	F-statistic:  6.68 on 3 and 41 DF,  p-value: 0.000893

for DBMS Y, 
	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.5925 -0.2436  0.0581  0.2373  0.5657 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.68450    0.14108   4.852 1.15e-05 ***
	PK            -0.16009    0.09331  -1.716   0.0922 .  
	ATP           -0.36686    0.19948  -1.839   0.0716 .  
	NUMPROCESSORS  0.11021    0.14345   0.768   0.4458    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3172 on 52 degrees of freedom
	Multiple R-squared:  0.1203,	Adjusted R-squared:  0.06957 
	F-statistic: 2.371 on 3 and 52 DF,  p-value: 0.08104

for PostgreSQL
	N/A

for DBMS Z
	Call:
	lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.72439 -0.06192  0.04398  0.15222  0.37136 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.78096    0.06639  11.763  < 2e-16 ***
	ATP           -0.18745    0.10077  -1.860  0.06537 .  
	NUMPROCESSORS  0.28105    0.09732   2.888  0.00462 ** 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2722 on 117 degrees of freedom
	Multiple R-squared:  0.1972,	Adjusted R-squared:  0.1835 
	F-statistic: 14.37 on 2 and 117 DF,  p-value: 2.63e-06

#### thrashing or not thrashing
x = read.csv(file="cnfm.dat",head=TRUE,sep="\t")
x$MAXMPL[x$MAXMPL < 1100] <- 1
x$MAXMPL[x$MAXMPL == 1100] <- 0 ### thrashing
x_r <- subset(x, x$PCTREAD!=0)
x_r <- subset(x_r, select = -PCTUPDATE)
x <- x_r
db2 <- subset(x, x$DBMS=='db2')
db2$ATP = (db2$ATP-min(db2$ATP))/(max(db2$ATP)-min(db2$ATP))
# oracle
oracle <- subset(x, x$DBMS=='oracle')
oracle$ATP = (oracle$ATP-min(oracle$ATP))/(max(oracle$ATP)-min(oracle$ATP))
# mysql
mysql <- subset(x, x$DBMS=='mysql')
mysql$ATP = (mysql$ATP-min(mysql$ATP))/(max(mysql$ATP)-min(mysql$ATP))
# pgsql
pgsql <- subset(x, x$DBMS=='pgsql')
if(max(pgsql$ATP)-min(pgsql$ATP)==0) {
    pgsql$ATP = 0
} else { 
    pgsql$ATP = (pgsql$ATP-min(pgsql$ATP))/(max(pgsql$ATP)-min(pgsql$ATP))
}
# sqlserver
sqlserver <- subset(x, x$DBMS=='sqlserver')
sqlserver$ATP = (sqlserver$ATP-min(sqlserver$ATP))/(max(sqlserver$ATP)-min(sqlserver$ATP))
#### gother each DBMS' samples
x = rbind(db2,mysql,oracle,pgsql,sqlserver)
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD/min(x$PCTREAD))/(max(x$PCTREAD)/min(x$PCTREAD))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
nrow(x)

#### per-DBMS logistic #####
db2 <- subset(x, x$DBMS=='db2')
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS,  data = db2)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.2127393
mysql <- subset(x, x$DBMS=='mysql')
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = mysql)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.6035987
pgsql <- subset(x, x$DBMS=='pgsql')
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = pgsql)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.06081725
oracle <- subset(x, x$DBMS=='oracle')
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS + PCTREAD + ACTROWPOOL, data = oracle)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.2025069
sqlserver <- subset(x, x$DBMS=='sqlserver')
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS + PCTREAD + ACTROWPOOL, data = sqlserver)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.3333092

### update-only
library(aod)
library(ggplot2)
x = read.csv(file="raw_cnfm.dat",head=TRUE,sep="\t")
#x = read.csv(file="new_cnfm.dat",head=TRUE,sep="\t")
#x$MAXMPL[x$MAXMPL == 1100] <- 10000
x_w <- subset(x, x$PCTUPDATE!=0)
x_w <- subset(x_w, select = -PCTREAD)
x <- x_w
nrow(x)
#[1] 800
#[1] 951
x <- subset(x, x$ATP < 120000)
#nrow(x)
#[1] 761
#[1] 912
x <- subset(x, x$MAXMPL < 1100)
#nrow(x)
#[1] 333: 43.75% thrashing
#[1] 419: 48.13% thrashing
# ATP normalization
# db2
db2 <- subset(x, x$DBMS=='db2')
#nrow(db2)
#db2 <- subset(db2, db2$MAXMPL < 1100)
db2$ATP = (db2$ATP-min(db2$ATP))/(max(db2$ATP)-min(db2$ATP))
db2$MAXMPL = (db2$MAXMPL-min(db2$MAXMPL))/(max(db2$MAXMPL)-min(db2$MAXMPL))
nrow(db2)
# oracle
oracle <- subset(x, x$DBMS=='oracle')
oracle$ATP = (oracle$ATP-min(oracle$ATP))/(max(oracle$ATP)-min(oracle$ATP))
oracle$MAXMPL = (oracle$MAXMPL-min(oracle$MAXMPL))/(max(oracle$MAXMPL)-min(oracle$MAXMPL))
nrow(oracle)
# mysql
mysql <- subset(x, x$DBMS=='mysql')
mysql$ATP = (mysql$ATP-min(mysql$ATP))/(max(mysql$ATP)-min(mysql$ATP))
mysql$MAXMPL = (mysql$MAXMPL-min(mysql$MAXMPL))/(max(mysql$MAXMPL)-min(mysql$MAXMPL))
nrow(mysql)
# pgsql
pgsql <- subset(x, x$DBMS=='pgsql')
pgsql$ATP = (pgsql$ATP-min(pgsql$ATP))/(max(pgsql$ATP)-min(pgsql$ATP))
pgsql$MAXMPL = (pgsql$MAXMPL-min(pgsql$MAXMPL))/(max(pgsql$MAXMPL)-min(pgsql$MAXMPL))
nrow(pgsql)
# sqlserver
sqlserver <- subset(x, x$DBMS=='sqlserver')
sqlserver$ATP = (sqlserver$ATP-min(sqlserver$ATP))/(max(sqlserver$ATP)-min(sqlserver$ATP))
sqlserver$MAXMPL = (sqlserver$MAXMPL-min(sqlserver$MAXMPL))/(max(sqlserver$MAXMPL)-min(sqlserver$MAXMPL))
nrow(sqlserver)
x = rbind(db2)
x = rbind(mysql)
x = rbind(oracle)
x = rbind(pgsql)
x = rbind(sqlserver)
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTUPDATE = (x$PCTUPDATE/min(x$PCTUPDATE))/(max(x$PCTUPDATE)/min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
#x <- subset(x, x$MAXMPL < 1)

med.fit <- lm(ATP ~ NUMPROCESSORS, data = x)
summary(med.fit)

out.fit <- lm(MAXMPL ~ ATP + NUMPROCESSORS, data = x)
summary(out.fit)

### ATP time ####
DBMS X: () 4 / 
=> 3%
MySQL
=> 25%
DBMS Y
=> 30%
PostgreSQL
=> 2%
DBMS Z
=> 42%

### MaxMPL ####
DBMS X
=> 17%
MySQL
=> 3%
DBMS Y
=> 31%
PostgreSQL
=> 21%
DBMS Z
=> 15%

### ATP time ####
DBMS X =>
	med.fit <- lm(ATP ~ PK + NUMPROCESSORS, data = x)
	summary(med.fit)
	
	Call:
	lm(formula = ATP ~ PK + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.05242 -0.03148 -0.01555  0.00563  0.95793 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)  
	(Intercept)   -0.015840   0.016320  -0.971   0.3333  
	PK             0.026515   0.015073   1.759   0.0805 .
	NUMPROCESSORS  0.005232   0.002943   1.778   0.0773 .
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.09533 on 157 degrees of freedom
	Multiple R-squared:  0.03832,	Adjusted R-squared:  0.02607 
	F-statistic: 3.128 on 2 and 157 DF,  p-value: 0.04656

MySQL =>
	Call:
	lm(formula = ATP ~ PK + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.43666 -0.12069  0.02920  0.03438  0.56770 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.72047    0.03918  18.388  < 2e-16 ***
	PK            -0.27073    0.03619  -7.481 4.92e-12 ***
	NUMPROCESSORS -0.01744    0.05652  -0.309    0.758    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2289 on 157 degrees of freedom
	Multiple R-squared:  0.2631,	Adjusted R-squared:  0.2537 
	F-statistic: 28.03 on 2 and 157 DF,  p-value: 3.895e-11

DBMS Y=>
	Call:
	lm(formula = ATP ~ NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.18619 -0.05740 -0.05732  0.02310  0.26439 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.29902    0.05433   5.504    7e-06 ***
	NUMPROCESSORS -0.24152    0.06557  -3.683 0.000975 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1199 on 28 degrees of freedom
	Multiple R-squared:  0.3264,	Adjusted R-squared:  0.3023 
	F-statistic: 13.57 on 1 and 28 DF,  p-value: 0.0009752

PostgreSQL=>
	Call:
	lm(formula = ATP ~ NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.71624 -0.04652  0.03532  0.14426  0.34402 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.77650    0.03973  19.543   <2e-16 ***
	NUMPROCESSORS -0.12053    0.06272  -1.922   0.0567 .  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2388 on 137 degrees of freedom
	Multiple R-squared:  0.02624,	Adjusted R-squared:  0.01914 
	F-statistic: 3.692 on 1 and 137 DF,  p-value: 0.05674

DBMS Z=>
	Call:
	lm(formula = ATP ~ NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.18654 -0.14086 -0.02644  0.10997  0.58886 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.48557    0.03809  12.749   <2e-16 ***
	NUMPROCESSORS -0.59537    0.06107  -9.749   <2e-16 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1996 on 127 degrees of freedom
	Multiple R-squared:  0.428,	Adjusted R-squared:  0.4235 
	F-statistic: 95.04 on 1 and 127 DF,  p-value: < 2.2e-16

### MaxMPL ####
DBMS X=>
	Call:
	lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	Residuals:
	      33       81       95      192      213 
	-0.01438 -0.30971 -0.01568  0.02876  0.31101 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)
	(Intercept)     0.8578     0.4548   1.886    0.200
	ATP            -0.4123     0.4002  -1.030    0.411
	NUMPROCESSORS  -0.5731     0.7755  -0.739    0.537

	Residual standard error: 0.3114 on 2 degrees of freedom
	Multiple R-squared:  0.5856,	Adjusted R-squared:  0.1713 
	F-statistic: 1.413 on 2 and 2 DF,  p-value: 0.4144

MySQL=>
	Call:
	lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.90815  0.06228  0.11206  0.15262  0.31548 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)   0.6842283  0.0789853   8.663  5.3e-15 ***
	ATP           0.2755356  0.1020058   2.701  0.00767 ** 
	NUMPROCESSORS 0.0003853  0.0841513   0.005  0.99635    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3407 on 157 degrees of freedom
	Multiple R-squared:  0.04443,	Adjusted R-squared:  0.03225 
	F-statistic:  3.65 on 2 and 157 DF,  p-value: 0.02823

DBMS Y=>
	Call:
	lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.36698 -0.04109 -0.04091  0.05908  0.34882 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)   
	(Intercept)     0.3333     0.1135   2.936  0.00672 **
	ATP             0.2742     0.2737   1.002  0.32539   
	NUMPROCESSORS  -0.2924     0.1157  -2.527  0.01767 * 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1736 on 27 degrees of freedom
	Multiple R-squared:  0.3611,	Adjusted R-squared:  0.3138 
	F-statistic: 7.631 on 2 and 27 DF,  p-value: 0.002361

PostgreSQL=>
	Call:
	lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.35458 -0.13682 -0.03796  0.07512  0.57700 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.28940    0.05824   4.969 1.99e-06 ***
	ATP            0.12323    0.06435   1.915   0.0576 .  
	NUMPROCESSORS -0.26406    0.04787  -5.516 1.69e-07 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1799 on 136 degrees of freedom
	Multiple R-squared:  0.2207,	Adjusted R-squared:  0.2093 
	F-statistic: 19.26 on 2 and 136 DF,  p-value: 4.308e-08

DBMS Z=>
	Call:
	lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.66443 -0.12765 -0.02007  0.22316  0.35766 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.22101    0.08072   2.738 0.007073 ** 
	ATP            0.45225    0.12455   3.631 0.000409 ***
	NUMPROCESSORS  0.55573    0.11334   4.903 2.85e-06 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2801 on 126 degrees of freedom
	Multiple R-squared:  0.162,	Adjusted R-squared:  0.1487 
	F-statistic: 12.18 on 2 and 126 DF,  p-value: 1.462e-05

#### per-DBMS #####
17.13 (0.0048)\% for DBMS X, 
27.54 % for MySQL, 
31.38 % for DBMS Y, 
20.93 % for PostgreSQL, and 
14.87 % for DBMS Z.

#### thrashing or not thrashing
library(aod)
library(ggplot2)
x = read.csv(file="cnfm.dat",head=TRUE,sep="\t")
x$MAXMPL[x$MAXMPL < 1100] <- 1 ### thrashing
x$MAXMPL[x$MAXMPL == 1100] <- 0
x_w <- subset(x, x$PCTUPDATE!=0)
x_w <- subset(x_w, select = -PCTREAD)
x <- x_w
nrow(x)
db2 <- subset(x, x$DBMS=='db2')
db2$ATP = (db2$ATP-min(db2$ATP))/(max(db2$ATP)-min(db2$ATP))
# oracle
oracle <- subset(x, x$DBMS=='oracle')
oracle$ATP = (oracle$ATP-min(oracle$ATP))/(max(oracle$ATP)-min(oracle$ATP))
# mysql
mysql <- subset(x, x$DBMS=='mysql')
mysql$ATP = (mysql$ATP-min(mysql$ATP))/(max(mysql$ATP)-min(mysql$ATP))
# pgsql
pgsql <- subset(x, x$DBMS=='pgsql')
if(max(pgsql$ATP)-min(pgsql$ATP)==0) {
    pgsql$ATP = 0
} else { 
    pgsql$ATP = (pgsql$ATP-min(pgsql$ATP))/(max(pgsql$ATP)-min(pgsql$ATP))
}
# sqlserver
sqlserver <- subset(x, x$DBMS=='sqlserver')
sqlserver$ATP = (sqlserver$ATP-min(sqlserver$ATP))/(max(sqlserver$ATP)-min(sqlserver$ATP))
#### gother each DBMS' samples
x = rbind(db2,mysql,oracle,pgsql,sqlserver)
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTUPDATE = (x$PCTUPDATE/min(x$PCTUPDATE))/(max(x$PCTUPDATE)/min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
out.fit <-  glm(MAXMPL ~ ATP + NUMPROCESSORS, data=x)
summary(out.fit)


###################
db2 <- subset(x, x$DBMS=='db2')
out.fit <-  glm(MAXMPL ~ ATP + NUMPROCESSORS, data = db2)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.1514176
mysql <- subset(x, x$DBMS=='mysql')
mysql$NUMPROCESSORS = (mysql$NUMPROCESSORS/min(mysql$NUMPROCESSORS))/(max(mysql$NUMPROCESSORS)/min(mysql$NUMPROCESSORS))
out.fit <-  glm(MAXMPL ~ ATP + NUMPROCESSORS, data = mysql)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.06971828
pgsql <- subset(x, x$DBMS=='pgsql')
out.fit <-  glm(MAXMPL ~ ATP + NUMPROCESSORS, data = pgsql)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.07866522
oracle <- subset(x, x$DBMS=='oracle')
out.fit <-  glm(MAXMPL ~ ATP + NUMPROCESSORS, data = oracle)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.4548632
sqlserver <- subset(x, x$DBMS=='sqlserver')
out.fit <-  glm(MAXMPL ~ ATP + NUMPROCESSORS, data = sqlserver)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.657579
