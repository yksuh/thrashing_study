#### exploratory analysis thesis
> library(aod)
> library(ggplot2)
> library(car)
> x = read.csv(file="cnfm.dat",head=TRUE,sep="\t")
> x_r <- subset(x, x$PCTREAD!=0)
> x_r <- subset(x_r, select = -PCTUPDATE)
> x <- x_r
> x <- subset(x, x$ATP < 120000)
> x <- subset(x, x$MAXMPL < 1100)
> x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
> x$PCTREAD = (x$PCTREAD/min(x$PCTREAD))/(max(x$PCTREAD)/min(x$PCTREAD))
> x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
### per-DBMS
## db2
> db2_r <- subset(x, x$DBMS=='db2')
> nrow(db2_r)
[1] 34
> db2_r$ATP = (db2_r$ATP-min(db2_r$ATP))/(max(db2_r$ATP)-min(db2_r$ATP))
> db2_r$MAXMPL = (db2_r$MAXMPL-min(db2_r$MAXMPL))/(max(db2_r$MAXMPL)-min(db2_r$MAXMPL))
> out.fit <- lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = db2_r)
> ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 0.3430361    Df = 1     p = 0.558082
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1      -0.0606969       2.01542   0.798
 Alternative hypothesis: rho != 0
## mysql
> mysql_r <- subset(x, x$DBMS=='mysql')
> nrow(mysql_r)
[1] 45
> mysql_r$ATP = (mysql_r$ATP-min(mysql_r$ATP))/(max(mysql_r$ATP)-min(mysql_r$ATP))
> mysql_r$MAXMPL = (mysql_r$MAXMPL-min(mysql_r$MAXMPL))/(max(mysql_r$MAXMPL)-min(mysql_r$MAXMPL))
#> mysql_r <- subset(mysql_r, mysql_r$MAXMPL < 1)
> out.fit <- lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = mysql_r)
> ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 0.2016327    Df = 1     p = 0.6534062
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.2655616      1.242953   0.008
 Alternative hypothesis: rho != 0
## oracle
> oracle_r <- subset(x, x$DBMS=='oracle')
> nrow(oracle_r)
[1] 56
> oracle_r$ATP = (oracle_r$ATP-min(oracle_r$ATP))/(max(oracle_r$ATP)-min(oracle_r$ATP))
> oracle_r$MAXMPL = (oracle_r$MAXMPL-min(oracle_r$MAXMPL))/(max(oracle_r$MAXMPL)-min(oracle_r$MAXMPL))
> out.fit <- lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = oracle_r)
> ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 0.6244767    Df = 1     p = 0.4293885 
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1      0.05203888      1.847575   0.414
 Alternative hypothesis: rho != 0
### postgres
> pgsql_r <- subset(x, x$DBMS=='pgsql')
> nrow(pgsql_r)
[1] 1
> if(max(pgsql_r$ATP)-min(pgsql_r$ATP)==0) {
+    pgsql_r$ATP = 0
+ } else { 
+    pgsql_r$ATP = (pgsql_r$ATP-min(pgsql_r$ATP))/(max(pgsql_r$ATP)-min(pgsql_r$ATP))
+ }
> if(max(pgsql_r$MAXMPL)-min(pgsql_r$MAXMPL)==0) {
+    pgsql_r$MAXMPL = 0
+ } else { 
+    pgsql_r$MAXMPL = (pgsql_r$MAXMPL-min(pgsql_r$MAXMPL))/(max(pgsql_r$MAXMPL)-min(pgsql_r$MAXMPL))
+ }
> 
> out.fit <- lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = pgsql_r)
> ncvTest(out.fit)
Error in lm.fit(x, y, offset = offset, singular.ok = singular.ok, ...) : 
  0 (non-NA) cases
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1              NA            NA      NA
 Alternative hypothesis: rho != 0
### sqlserver
> sqlserver_r <- subset(x, x$DBMS=='sqlserver')
> nrow(sqlserver_r)
[1] 12
#> sqlserver_r$MAXMPL[5] <- 300
#> sqlserver_r$MAXMPL[7] <- 500
#> sqlserver_r$MAXMPL[11] <- 800
> sqlserver_r$ATP = (sqlserver_r$ATP-min(sqlserver_r$ATP))/(max(sqlserver_r$ATP)-min(sqlserver_r$ATP))
> if(max(sqlserver_r$MAXMPL)-min(sqlserver_r$MAXMPL)==0) {
+     sqlserver_r$MAXMPL = 0
+ } else { 
+     sqlserver_r$MAXMPL = (sqlserver_r$MAXMPL-min(sqlserver_r$MAXMPL))/(max(sqlserver_r$MAXMPL)-min(sqlserver_r$MAXMPL))
+ }
> out.fit <- lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = sqlserver_r)
> ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 0.08257456    Df = 1     p = 0.7738383
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.2242306      1.506491    0.29
 Alternative hypothesis: rho != 0
#### gather all the DBMSes' samples
> x_r = rbind(db2_r,mysql_r,oracle_r,pgsql_r,sqlserver_r)
#> x_r <- subset(x_r, x_r$MAXMPL < 1)
> out.fit <- lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x_r)
### ncvTest
> ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 1.605772    Df = 1     p = 0.2050871
### durbinWatsonTest
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.2660653      1.442629       0
 Alternative hypothesis: rho != 0

### update
> x = read.csv(file="cnfm.dat",head=TRUE,sep="\t")
> x <- subset(x, x$ATP < 120000)
> x <- subset(x, x$MAXMPL < 1100)
> x_w <- subset(x, x$PCTUPDATE!=0)
> x_w <- subset(x_w, select = -PCTREAD)
> x <- x_w
> x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
> x$PCTUPDATE = (x$PCTUPDATE/min(x$PCTUPDATE))/(max(x$PCTUPDATE)/min(x$PCTUPDATE))
> x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
### per-DBMS
# db2
> db2_w <- subset(x, x$DBMS=='db2')
> nrow(db2_w)
[1] 4
> db2_w$ATP = (db2_w$ATP-min(db2_w$ATP))/(max(db2_w$ATP)-min(db2_w$ATP))
> db2_w$MAXMPL = (db2_w$MAXMPL-min(db2_w$MAXMPL))/(max(db2_w$MAXMPL)-min(db2_w$MAXMPL))
> out.fit <- lm(MAXMPL ~ ATP + NUMPROCESSORS, data = db2_w)
> ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 0.5904476    Df = 1     p = 0.4422461
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1     -0.01202913       1.83287   0.864
 Alternative hypothesis: rho != 0
# mysql
> mysql_w <- subset(x, x$DBMS=='mysql')
> nrow(mysql_w)
[1] 31
> mysql_w$ATP = (mysql_w$ATP-min(mysql_w$ATP))/(max(mysql_w$ATP)-min(mysql_r$ATP))
> mysql_w$MAXMPL = (mysql_w$MAXMPL-min(mysql_w$MAXMPL))/(max(mysql_w$MAXMPL)-min(mysql_w$MAXMPL))
> out.fit <- lm(MAXMPL ~ ATP + NUMPROCESSORS, data = mysql_w)
> ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 0.01017611    Df = 1     p = 0.9196483
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.2815578       1.36935   0.054
 Alternative hypothesis: rho != 0
# oracle
oracle_w <- subset(x, x$DBMS=='oracle')
nrow(oracle_w)
[1] 30
> oracle_w$ATP = (oracle_w$ATP-min(oracle_w$ATP))/(max(oracle_w$ATP)-min(oracle_w$ATP))
> oracle_w$MAXMPL = (oracle_w$MAXMPL-min(oracle_w$MAXMPL))/(max(oracle_w$MAXMPL)-min(oracle_w$MAXMPL))
> out.fit <- lm(MAXMPL ~ ATP + NUMPROCESSORS, data = oracle_w)
> ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 13.45413    Df = 1     p = 0.0002444679 
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1    -0.003209438      1.964668    0.63
 Alternative hypothesis: rho != 0
# pgsql
> pgsql_w <- subset(x, x$DBMS=='pgsql')
> nrow(pgsql_w)
[1] 139
> pgsql_w$ATP = (pgsql_w$ATP-min(pgsql_w$ATP))/(max(pgsql_w$ATP)-min(pgsql_w$ATP))
> pgsql_w$MAXMPL = (pgsql_w$MAXMPL-min(pgsql_w$MAXMPL))/(max(pgsql_w$MAXMPL)-min(pgsql_w$MAXMPL))
> out.fit <- lm(MAXMPL ~ ATP + NUMPROCESSORS, data = pgsql_w)
> ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 0.006076916    Df = 1     p = 0.9378642
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1      0.09892979      1.800787    0.18
 Alternative hypothesis: rho != 0
# sqlserver
> sqlserver_w <- subset(x, x$DBMS=='sqlserver')
> nrow(sqlserver_w)
[1] 129
> sqlserver_w$ATP = (sqlserver_w$ATP-min(sqlserver_w$ATP))/(max(sqlserver_w$ATP)-min(sqlserver_w$ATP))
> sqlserver_w$MAXMPL = (sqlserver_w$MAXMPL-min(sqlserver_w$MAXMPL))/(max(sqlserver_w$MAXMPL)-min(sqlserver_w$MAXMPL))
> out.fit <- lm(MAXMPL ~ ATP + NUMPROCESSORS, data = sqlserver_w)
> ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 1.853945    Df = 1     p = 0.1733253
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.6710034     0.6529241       0
 Alternative hypothesis: rho != 0
### collect all the DBMSes' samples
> x_w = rbind(db2_w,mysql_w,oracle_w,pgsql_w,sqlserver_w)
#x_w <- subset(x_w, x_w$MAXMPL < 1)
out.fit <- lm(MAXMPL ~ ATP + NUMPROCESSORS, data = x_w)
### ncvTest
> ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 0.5463642    Df = 1     p = 0.459807
### durbinWatsonTest
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.4406345      1.110252       0
 Alternative hypothesis: rho != 0
