## db2
> nrow(db2_r) ### sample size
[1] 34
> out.fit <- lm(formula = THRASHING_PT ~ PK + READ_SF + ROSE + ATPT + NUMPROCS, data = db2_r)
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1        0.141302      1.642439   0.172
 Alternative hypothesis: rho != 0
## mysql
> nrow(mysql_r)
[1] 42
> out.fit <- lm(formula = THRASHING_PT ~ PK + READ_SF + ROSE + ATPT + NUMPROCS, data = mysql_r)
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1      0.07745788       1.59418   0.074
 Alternative hypothesis: rho != 0
## oracle
> nrow(oracle_r)
[1] 34
> out.fit <- lm(formula = THRASHING_PT ~ PK + READ_SF + ROSE + ATPT + NUMPROCS, data = oracle_r)
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1      0.01300011      1.919807   0.396
 Alternative hypothesis: rho != 0
## postgres
> nrow(pgsql_r)
[1] 40
> out.fit <- lm(formula = THRASHING_PT ~ PK + READ_SF + ROSE + ATPT + NUMPROCS, data = pgsql_r)
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1        0.621946     0.7558477       0
 Alternative hypothesis: rho != 0
## sqlserver
> nrow(sqlserver_r)
[1] 38
> out.fit <- lm(formula = THRASHING_PT ~ PK + READ_SF + ROSE + ATPT + NUMPROCS, data = sqlserver_r)
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1       -0.195273      2.277055   0.704
 Alternative hypothesis: rho != 0

### all the DBMSes
> x_r = rbind(db2_r,mysql_r,oracle_r,pgsql_r,sqlserver_r)
> nrow(x_r)
[1] 188
#> x_r <- subset(x_r, x_r$MAXMPL < 1)
> out.fit <- lm(formula = THRASHING_PT ~ PK + READ_SF + ROSE + ATPT + NUMPROCS, data = x_r)
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.5589201     0.8715399       0
 Alternative hypothesis: rho != 0

### update
# db2
> nrow(db2_w)
[1] 14
> out.fit <- lm(THRASHING_PT ~ PK + ATPT + NUMPROCS + UPDATE_SF + ROSE, data = db2_w)
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1      -0.6246547      3.208573    0.07
 Alternative hypothesis: rho != 0
# mysql
> nrow(mysql_w)
[1] 31
> out.fit <- lm(THRASHING_PT ~ PK + ATPT + NUMPROCS + UPDATE_SF + ROSE, data = mysql_w)
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.2699188      1.387189   0.058
 Alternative hypothesis: rho != 0
# oracle
> nrow(oracle_w)
[1] 65
> out.fit <- lm(THRASHING_PT ~ PK + ATPT + NUMPROCS + UPDATE_SF + ROSE, data = oracle_w)
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1     -0.03717381      2.018206    0.836
 Alternative hypothesis: rho != 0
# pgsql
> nrow(pgsql_w)
[1] 75
> out.fit <- lm(THRASHING_PT ~ PK + ATPT + NUMPROCS + UPDATE_SF + ROSE, data = pgsql_w)
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1      0.02668038      1.935677   0.574
 Alternative hypothesis: rho != 0
# sqlserver
> out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS + PCTUPDATE + ACTROWPOOL, data = sqlserver_w)
> nrow(sqlserver_w)
[1] 114
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.2457297      1.508347   0.008
 Alternative hypothesis: rho != 0
### collect all the DBMSes' samples
> x_w = rbind(db2_w,mysql_w,oracle_w,pgsql_w,sqlserver_w)
> nrow(x_w)
[1] 299
> x_w <- subset(x_w, x_w$MAXMPL < 1)
> out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS + PCTUPDATE + ACTROWPOOL, data = x_w)
> ncvTest(out.fit)
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.5452982     0.9006598       0
 Alternative hypothesis: rho != 0

