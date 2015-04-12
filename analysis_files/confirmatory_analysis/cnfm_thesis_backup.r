#### confirmatory analysis thesis
library(aod)
library(ggplot2)
x = read.csv(file="cnfm.dat",head=TRUE,sep="\t")
x_r <- subset(x, x$PCTREAD!=0)
x_r <- subset(x_r, select = -PCTUPDATE)
x <- x_r
x <- subset(x, x$ATP < 120000)
x <- subset(x, x$MAXMPL < 1100)
# ATP normalization
# db2
db2 <- subset(x, x$DBMS=='db2')
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
if(max(pgsql$ATP)-min(pgsql$ATP)==0) {
    pgsql$ATP = 0
} else { 
    pgsql$ATP = (pgsql$ATP-min(pgsql$ATP))/(max(pgsql$ATP)-min(pgsql$ATP))
}
if(max(pgsql$MAXMPL)-min(pgsql$MAXMPL)==0) {
    pgsql$MAXMPL = 0
} else { 
    pgsql$MAXMPL = (pgsql$MAXMPL-min(pgsql$MAXMPL))/(max(pgsql$MAXMPL)-min(pgsql$MAXMPL))
}
nrow(pgsql)
# sqlserver
sqlserver <- subset(x, x$DBMS=='sqlserver')
sqlserver$ATP = (sqlserver$ATP-min(sqlserver$ATP))/(max(sqlserver$ATP)-min(sqlserver$ATP))
if(max(sqlserver$MAXMPL)-min(sqlserver$MAXMPL)==0) {
    sqlserver$MAXMPL = 0
} else { 
    sqlserver$MAXMPL = (sqlserver$MAXMPL-min(sqlserver$MAXMPL))/(max(sqlserver$MAXMPL)-min(sqlserver$MAXMPL))
}
nrow(sqlserver)
### all
x = rbind(db2,mysql,oracle,pgsql,sqlserver)
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD/min(x$PCTREAD))/(max(x$PCTREAD)/min(x$PCTREAD))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
x <- subset(x, x$MAXMPL < 1)
library(car)
out.fit <- lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
### ncvTest
ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 1.605772    Df = 1     p = 0.2050871

### durbinWatsonTest
durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1        0.350301      1.293917       0
 Alternative hypothesis: rho != 0

### per-DBMS
#### gother each DBMS' samples
x = rbind(db2)
x = rbind(mysql)
x = rbind(oracle)
x = rbind(pgsql)
x = rbind(sqlserver)
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD/min(x$PCTREAD))/(max(x$PCTREAD)/min(x$PCTREAD))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
x <- subset(x, x$MAXMPL < 1)
library(car)
out.fit <- lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

#### db2
> ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 0.8641854    Df = 1     p = 0.3525701

#### mysql
ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 8.949595    Df = 1     p = 0.002775311 

#### oracle
ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 2.016226    Df = 1     p = 0.1556255 

#### postgres
ncvTest(out.fit)
Error in lm.fit(x, y, offset = offset, singular.ok = singular.ok, ...) : 
  0 (non-NA) cases

#### sqlserver
ncvTest(out.fit)
Error in lm.fit(x, y, offset = offset, singular.ok = singular.ok, ...) : 
  0 (non-NA) cases


#### update
library(aod)
library(ggplot2)
x = read.csv(file="cnfm.dat",head=TRUE,sep="\t")
x_w <- subset(x, x$PCTUPDATE!=0)
x_w <- subset(x_w, select = -PCTREAD)
x <- x_w
x <- subset(x, x$ATP < 120000)
x <- subset(x, x$MAXMPL < 1100)
# ATP normalization
# db2
db2 <- subset(x, x$DBMS=='db2')
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
x = rbind(db2,mysql,oracle,pgsql,sqlserver)
### normalization for ROSE, SF, NUMPROCS
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTUPDATE = (x$PCTUPDATE/min(x$PCTUPDATE))/(max(x$PCTUPDATE)/min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
x <- subset(x, x$MAXMPL < 1)
out.fit <- lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

### ncvTest
ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 0.5052569    Df = 1     p = 0.4771994

### durbinWatsonTest
durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.4401782      1.111135       0
 Alternative hypothesis: rho != 0
