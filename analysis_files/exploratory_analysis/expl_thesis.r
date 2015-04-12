#### exploratory analysis thesis
> library(aod)
> library(ggplot2)
#### exploratory analysis thesis
library(car)
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
x_r <- subset(x, x$PCTREAD!=0)
x_r <- subset(x_r, select = -PCTUPDATE)
x <- x_r
x <- subset(x, x$ATP < 120000)
x <- subset(x, x$MAXMPL < 1100)
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD/min(x$PCTREAD))/(max(x$PCTREAD)/min(x$PCTREAD))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
### per-DBMS
## db2
db2_r <- subset(x, x$DBMS=='db2')
nrow(db2_r)
[1] 34
db2_r$ATP = (db2_r$ATP-min(db2_r$ATP))/(max(db2_r$ATP)-min(db2_r$ATP))
db2_r$MAXMPL = (db2_r$MAXMPL-min(db2_r$MAXMPL))/(max(db2_r$MAXMPL)-min(db2_r$MAXMPL))
#db2_r <- subset(db2_r, db2_r$MAXMPL < 1)
#[1] 30
out.fit <- lm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, data = db2_r)
ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 1.246557    Df = 1     p = 0.2642112
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1        0.141302      1.642439   0.172
 Alternative hypothesis: rho != 0
## mysql
mysql_r <- subset(x, x$DBMS=='mysql')
nrow(mysql_r)
[1] 42
mysql_r$ATP = (mysql_r$ATP-min(mysql_r$ATP))/(max(mysql_r$ATP)-min(mysql_r$ATP))
mysql_r$MAXMPL = (mysql_r$MAXMPL-min(mysql_r$MAXMPL))/(max(mysql_r$MAXMPL)-min(mysql_r$MAXMPL))
#mysql_r <- subset(mysql_r, mysql_r$MAXMPL < 1)
out.fit <- lm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, data = mysql_r)
ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 21.621    Df = 1     p = 3.321942e-06
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1      0.07745788       1.59418   0.074
 Alternative hypothesis: rho != 0
## oracle
oracle_r <- subset(x, x$DBMS=='oracle')
oracle_r$ATP = (oracle_r$ATP-min(oracle_r$ATP))/(max(oracle_r$ATP)-min(oracle_r$ATP))
oracle_r$MAXMPL = (oracle_r$MAXMPL-min(oracle_r$MAXMPL))/(max(oracle_r$MAXMPL)-min(oracle_r$MAXMPL))
#oracle_r <- subset(oracle_r, oracle_r$MAXMPL < 1)
nrow(oracle_r)
[1] 34
out.fit <- lm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, data = oracle_r)
> ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 0.7180687    Df = 1     p = 0.396778
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1      0.01300011      1.919807   0.396
 Alternative hypothesis: rho != 0
### postgres
pgsql_r <- subset(x, x$DBMS=='pgsql')
nrow(pgsql_r)
[1] 40
if(max(pgsql_r$ATP)-min(pgsql_r$ATP)==0) {
     pgsql_r$ATP = 0
} else { 
    pgsql_r$ATP = (pgsql_r$ATP-min(pgsql_r$ATP))/(max(pgsql_r$ATP)-min(pgsql_r$ATP))
}
if(max(pgsql_r$MAXMPL)-min(pgsql_r$MAXMPL)==0) {
    pgsql_r$MAXMPL = 0
} else { 
    pgsql_r$MAXMPL = (pgsql_r$MAXMPL-min(pgsql_r$MAXMPL))/(max(pgsql_r$MAXMPL)-min(pgsql_r$MAXMPL))
}
out.fit <- lm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, data = pgsql_r)
ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 0.9275016    Df = 1     p = 0.335513
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1        0.621946     0.7558477       0
 Alternative hypothesis: rho != 0
### sqlserver
sqlserver_r <- subset(x, x$DBMS=='sqlserver')
nrow(sqlserver_r)
[1] 38
sqlserver_r$ATP = (sqlserver_r$ATP-min(sqlserver_r$ATP))/(max(sqlserver_r$ATP)-min(sqlserver_r$ATP))
if(max(sqlserver_r$MAXMPL)-min(sqlserver$MAXMPL)==0) {
    sqlserver_r$MAXMPL = 0
} else { 
    sqlserver_r$MAXMPL = (sqlserver_r$MAXMPL-min(sqlserver_r$MAXMPL))/(max(sqlserver_r$MAXMPL)-min(sqlserver_r$MAXMPL))
}
out.fit <- lm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, data = sqlserver_r)
ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 1.405425    Df = 1     p = 0.2358173
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1       -0.195273      2.277055   0.704
 Alternative hypothesis: rho != 0

#### gather all the DBMSes' samples
> x_r = rbind(db2_r,mysql_r,oracle_r,pgsql_r,sqlserver_r)
> nrow(x_r)
[1] 188
# x_r <- subset(x_r, x_r$MAXMPL < 1)
> out.fit <- lm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, data = x_r)
### ncvTest
> ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 0.364131    Df = 1     p = 0.5462209
### durbinWatsonTest
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.5664259     0.8624828       0
 Alternative hypothesis: rho != 0
### collect all the DBMSes' samples
x_r = rbind(db2_r,mysql_r,oracle_r,pgsql_r,sqlserver_r)
> nrow(x_r)
[1] 188
#x_r <- subset(x_r, x_r$MAXMPL < 1)
out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS + PCTREAD + ACTROWPOOL, data = x_r)
### ncvTest
ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 0.1600875    Df = 1     p = 0.689076
### durbinWatsonTest
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.5589201     0.8715399       0
 Alternative hypothesis: rho != 0

### update
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
x <- subset(x, x$ATP < 120000)
x <- subset(x, x$MAXMPL < 1100)
x_w <- subset(x, x$PCTUPDATE!=0)
x_w <- subset(x_w, select = -PCTREAD)
x <- x_w
> nrow(x)
[1] 299
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTUPDATE = (x$PCTUPDATE/min(x$PCTUPDATE))/(max(x$PCTUPDATE)/min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
### per-DBMS
# db2
db2_w <- subset(x, x$DBMS=='db2')
> nrow(db2_w)
[1] 14
db2_w$ATP = (db2_w$ATP-min(db2_w$ATP))/(max(db2_w$ATP)-min(db2_w$ATP))
db2_w$MAXMPL = (db2_w$MAXMPL-min(db2_w$MAXMPL))/(max(db2_w$MAXMPL)-min(db2_w$MAXMPL))
out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS + PCTUPDATE + ACTROWPOOL, data = db2_w)
ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 3.540265    Df = 1     p = 0.0598959
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1      -0.6246547      3.208573    0.07
 Alternative hypothesis: rho != 0
# mysql
mysql_w <- subset(x, x$DBMS=='mysql')
nrow(mysql_w)
[1] 31
mysql_w$ATP = (mysql_w$ATP-min(mysql_w$ATP))/(max(mysql_w$ATP)-min(mysql_r$ATP))
mysql_w$MAXMPL = (mysql_w$MAXMPL-min(mysql_w$MAXMPL))/(max(mysql_w$MAXMPL)-min(mysql_w$MAXMPL))
out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS + PCTUPDATE + ACTROWPOOL, data = mysql_w)
ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 0.005998108    Df = 1     p = 0.9382676
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.2699188      1.387189   0.058
 Alternative hypothesis: rho != 0
# oracle
oracle_w <- subset(x, x$DBMS=='oracle')
nrow(oracle_w)
[1] 65
oracle_w$ATP = (oracle_w$ATP-min(oracle_w$ATP))/(max(oracle_w$ATP)-min(oracle_w$ATP))
oracle_w$MAXMPL = (oracle_w$MAXMPL-min(oracle_w$MAXMPL))/(max(oracle_w$MAXMPL)-min(oracle_w$MAXMPL))
out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS + PCTUPDATE + ACTROWPOOL, data = oracle_w)
> ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 32.61249    Df = 1     p = 1.124893e-08
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1     -0.03717381      2.018206   0.836
 Alternative hypothesis: rho != 0
# pgsql
pgsql_w <- subset(x, x$DBMS=='pgsql')
nrow(pgsql_w)
[1] 75
pgsql_w$ATP = (pgsql_w$ATP-min(pgsql_w$ATP))/(max(pgsql_w$ATP)-min(pgsql_w$ATP))
pgsql_w$MAXMPL = (pgsql_w$MAXMPL-min(pgsql_w$MAXMPL))/(max(pgsql_w$MAXMPL)-min(pgsql_w$MAXMPL))
out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS + PCTUPDATE + ACTROWPOOL, data = pgsql_w)
> ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 2.172759    Df = 1     p = 0.140474
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1      0.02668038      1.935677   0.574
 Alternative hypothesis: rho != 0
# sqlserver
sqlserver_w <- subset(x, x$DBMS=='sqlserver')
> nrow(sqlserver_w)
[1] 114
sqlserver_w$ATP = (sqlserver_w$ATP-min(sqlserver_w$ATP))/(max(sqlserver_w$ATP)-min(sqlserver_w$ATP))
sqlserver_w$MAXMPL = (sqlserver_w$MAXMPL-min(sqlserver_w$MAXMPL))/(max(sqlserver_w$MAXMPL)-min(sqlserver_w$MAXMPL))
out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS + PCTUPDATE + ACTROWPOOL, data = sqlserver_w)
> ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 24.41144    Df = 1     p = 7.780545e-07
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.2457297      1.508347   0.008
 Alternative hypothesis: rho != 0
### collect all the DBMSes' samples
x_w = rbind(db2_w,mysql_w,oracle_w,pgsql_w,sqlserver_w)
> nrow(x_w)
[1] 299
#x_w <- subset(x_w, x_w$MAXMPL < 1)
out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS + PCTUPDATE + ACTROWPOOL, data = x_w)
### ncvTest
ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 0.1600875    Df = 1     p = 0.689076
### durbinWatsonTest
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.5628106     0.8637937       0
 Alternative hypothesis: rho != 0
