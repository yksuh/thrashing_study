## db2
> nrow(db2_r) ### sample size
[1] 34
> out.fit <- lm(formula = THRASHING_PT ~ PK + READ_SF + ROSE + ATPT + NUMPROCS, data = db2_r)
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1      -0.0606969       2.01542   0.792
 Alternative hypothesis: rho != 0
## mysql
> nrow(mysql_r)
[1] 45
> out.fit <- lm(formula = THRASHING_PT ~ PK + READ_SF + ROSE + ATPT + NUMPROCS, data = mysql_r)
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.2655616      1.242953   0.008
 Alternative hypothesis: rho != 0
## oracle
> nrow(oracle_r)
[1] 56
> out.fit <- lm(formula = THRASHING_PT ~ PK + READ_SF + ROSE + ATPT + NUMPROCS, data = oracle_r)
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1      0.05203888      1.847575   0.414
 Alternative hypothesis: rho != 0
## postgres
> nrow(pgsql_r)
[1] 1
> out.fit <- lm(formula = THRASHING_PT ~ PK + READ_SF + ROSE + ATPT + NUMPROCS, data = pgsql_r)
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1              NA            NA      NA
 Alternative hypothesis: rho != 0
## sqlserver
> nrow(sqlserver_r)
[1] 12
> out.fit <- lm(formula = THRASHING_PT ~ PK + READ_SF + ROSE + ATPT + NUMPROCS, data = sqlserver_r)
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1       -0.195273      2.277055   0.704
 Alternative hypothesis: rho != 0

### all the DBMSes
> x_r = rbind(db2_r,mysql_r,oracle_r,pgsql_r,sqlserver_r)
> nrow(x_r)
[1] 148
> out.fit <- lm(formula = THRASHING_PT ~ PK + READ_SF + ROSE + ATPT + NUMPROCS, data = x_r)
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.2660653      1.442629       0
 Alternative hypothesis: rho != 0

### update
# db2
> nrow(db2_w)
[1] 4
> out.fit <- lm(THRASHING_PT ~ PK + ATPT + NUMPROCS + UPDATE_SF + ROSE, data = db2_w)
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1     -0.01202913       1.83287   0.864
 Alternative hypothesis: rho != 0
# mysql
> nrow(mysql_w)
[1] 31
> out.fit <- lm(THRASHING_PT ~ PK + ATPT + NUMPROCS + UPDATE_SF + ROSE, data = mysql_w)
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.2815578       1.36935   0.054
 Alternative hypothesis: rho != 0
# oracle
> nrow(oracle_w)
[1] 30
> out.fit <- lm(THRASHING_PT ~ PK + ATPT + NUMPROCS + UPDATE_SF + ROSE, data = oracle_w)
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1    -0.003209438      1.964668    0.63
 Alternative hypothesis: rho != 0
# pgsql
> nrow(pgsql_w)
[1] 139
> out.fit <- lm(THRASHING_PT ~ PK + ATPT + NUMPROCS + UPDATE_SF + ROSE, data = pgsql_w)
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1      0.02668038      1.935677   0.574
 Alternative hypothesis: rho != 0
# sqlserver
> out.fit <- lm(MAXMPL ~ PK + ATPT + NUMPROCS + UPDATE_SF + ROSE, data = sqlserver_w)
> nrow(sqlserver_w)
[1] 129
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.6710034     0.6529241       0
 Alternative hypothesis: rho != 0
### collect all the DBMSes' samples
> x_w = rbind(db2_w,mysql_w,oracle_w,pgsql_w,sqlserver_w)
> nrow(x_w)
[1] 333
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.4406345      1.110252       0
 Alternative hypothesis: rho != 0

