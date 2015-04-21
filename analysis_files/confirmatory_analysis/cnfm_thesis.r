#### confirmatory evaluation output
## H1: numProcs vs. Thrashing Pt.
> cor.test(all_r$NUMPROCS, all_r$ATPT)

	Pearson's product-moment correlation

data:  all_r$NUMPROCS and all_r$THRASHING_PT
t = 3.741, df = 146, p-value = 0.0002627
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 0.1411518 0.4362848
sample estimates:
    cor 
0.29576 

## H2: numProcs vs. ATPT
> cor.test(all_r$NUMPROCS, all_r$ATPT)
	##### all  samples
	Pearson's product-moment correlation

data:  all_r$NUMPROCS and all_r$ATPT
t = -7.6998, df = 146, p-value = 6.595e-14
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.3894070 -0.2371818
sample estimates:
       cor 
-0.3153213

## H3: ATPT vs. Thrashing Pt.
> cor.test(all_r$ATPT, all_r$THRASHING_PT)

	Pearson's product-moment correlation

data:  all_r$ATPT and all_r$THRASHING_PT
t = -3.2048, df = 146, p-value = 0.00166
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.40112162 -0.09912601
sample estimates:
       cor 
-0.2563696

## H4: PK vs. Thrashing Pt.
> cor.test(all_r$PK, all_r$THRASHING_PT)
	Pearson's product-moment correlation

data:  all_r$PK and all_r$THRASHING_PT
t = 4.619, df = 146, p-value = 4.832e-06
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 0.1128874 0.2753890
sample estimates:
      cor 
0.1954796

## H5: PK vs. ATPT
> cor.test(all_r$PK, all_r$ATPT)
	Pearson's product-moment correlation

data:  all_r$PK and all_r$ATPT
t = -7.8658, df = 146, p-value = 7.489e-13
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.6497162 -0.4213030
sample estimates:
       cor 
-0.5455624

## regression analyses
### regression on Thrashing Pt.
> out.fit <- lm(formula = THRASHING_PT ~ PK + ATPT + NUMPROCS, 
data = all_r)
> summary(out.fit)
	
Call:
lm(formula = THRASHING_PT ~ PK + ATPT + NUMPROCS, data = all_r)

Residuals:
    Min      1Q  Median      3Q     Max 
-0.7010 -0.2157 -0.1013  0.2698  0.6548 

Coefficients:
	      Estimate Std. Error t value Pr(>|t|)    
(Intercept)    0.39534    0.07219   5.476 1.88e-07 ***
PK             0.02569    0.06900   0.372 0.710159    
ATPT          -0.27968    0.08975  -3.116 0.002213 ** 
NUMPROCS       0.33585    0.08427   3.986 0.000107 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.3398 on 144 degrees of freedom
Multiple R-squared:  0.1589,	Adjusted R-squared:  0.1414 
F-statistic: 9.068 on 3 and 144 DF,  p-value: 1.542e-05

### regression on ATPT
> med.fit <- lm(ATPT ~ NUMPROCS + PK, data = all_r)
> summary(med.fit)

Call:
lm(formula = ATPT ~ NUMPROCS + PK, data = all_r)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.55398 -0.22739 -0.05854  0.30701  0.87981 

Coefficients:
	      Estimate Std. Error t value Pr(>|t|)    
(Intercept)    0.53014    0.05023  10.553  < 2e-16 ***
NUMPROCS      -0.03928    0.07790  -0.504    0.615    
PK            -0.41977    0.05348  -7.849 8.47e-13 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.3144 on 145 degrees of freedom
Multiple R-squared:  0.2989,	Adjusted R-squared:  0.2892 
F-statistic:  30.9 on 2 and 145 DF,  p-value: 6.614e-12

#### mediation analyses
> library(mediation) ## include the mediation library
### testing mediation through ATPT by numProcs 
> med.out <- mediate(med.fit, out.fit, mediator = "ATPT", treat = "NUMPROCS")
> summary(med.out)

Causal Mediation Analysis 

Quasi-Bayesian Confidence Intervals

	       Estimate 95% CI Lower 95% CI Upper p-value
ACME            -0.0401      -0.0739      -0.0104    0.01
ADE              0.2044       0.1147       0.2907    0.00
Total Effect     0.1643       0.0812       0.2484    0.00
Prop. Mediated  -0.2402      -0.6569      -0.0604    0.01

Sample Size Used: 148 


Simulations: 1000

> sens.out <-medsens(med.out)
> summary(sens.out)

Mediation Sensitivity Analysis for Average Causal Mediation Effect

Sensitivity Region

     Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
[1,] 0.1 -0.0055      -0.0349       0.0239         0.01       0.0082

Rho at which ACME = 0: 0.1
R^2_M*R^2_Y* at which ACME = 0: 0.01
R^2_M~R^2_Y~ at which ACME = 0: 0.0082

### testing mediation through ATPT by PK 
> med.out <- mediate(med.fit, out.fit, mediator = "ATPT", treat = "PK")
> summary(med.out)

Causal Mediation Analysis 

Quasi-Bayesian Confidence Intervals

	       Estimate 95% CI Lower 95% CI Upper p-value
ACME             0.1167       0.0394       0.2036     0.0
ADE             -0.0242      -0.1549       0.1140     0.7
Total Effect     0.0925      -0.0238       0.2123     0.1
Prop. Mediated   1.1811      -3.9671      10.6847     0.1

Sample Size Used: 148 


Simulations: 1000 

> sens.out <-medsens(med.out)
> summary(sens.out)

Mediation Sensitivity Analysis for Average Causal Mediation Effect

Sensitivity Region

      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
[1,] -0.3 -0.0248      -0.0981       0.0486         0.09       0.0531
[2,] -0.2  0.0251      -0.0482       0.0985         0.04       0.0236
[3,] -0.1  0.0720      -0.0033       0.1472         0.01       0.0059

Rho at which ACME = 0: -0.3
R^2_M*R^2_Y* at which ACME = 0: 0.09
R^2_M~R^2_Y~ at which ACME = 0: 0.0531 

### testing assumptions
### 1), 2), and 3): no commands
### 4) No correlation of residuals
> durbinWatsonTest(med.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.7061902     0.5864416       0
 Alternative hypothesis: rho != 0
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.2660653      1.442629       0
 Alternative hypothesis: rho != 0
### 5) Homoscedasticity
> ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 1.605772    Df = 1     p = 0.2050871
### 6) No multicolinearity
> sqrt(vif(out.fit)) > 2
        PK         ATPT      NUMPROCS 
     FALSE        FALSE         FALSE
### 7) No significant outliers: cooks distance
> cd = cooks.distance(out.fit)
> plot(cd, ylim=c(0, 0.05), 
main="(CD shouldn't be greater than 1)", 
ylab="Cook's Distances (CDs)", xlab="Observation Number")
### see Figure 10.1 (a)
### 8) normality of residuals
> h <- hist(out.fit$res,main="",xlab="Residuals",ylim=c(0,40),
xlim=c(-1,1))
> xfit<-seq(min(out.fit$res),max(out.fit$res),length=40) 
> yfit<-dnorm(xfit,mean=mean(out.fit$res),sd=sd(out.fit$res)) 
> yfit <- yfit*diff(h$mids[1:2])*length(out.fit$res) 
> lines(xfit, yfit, col="blue")
### see Figure 10.1 (c)

##############################
### update ###################
##############################
### all_u: thrashing samples captured in the update group
## H1: numProcs vs. Thrashing Pt.
> cor.test(all_u$NUMPROCS, all_u$THRASHING_PT)
	Pearson's product-moment correlation

data:  all_u$NUMPROCS and all_u$THRASHING_PT
t = -6.6396, df = 331, p-value = 1.57e-10
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.4608757 -0.2604885
sample estimates:
       cor 
-0.3649005

## H2: numProcs vs. ATPT
> cor.test(all_u$NUMPROCS, all_u$ATPT)
	Pearson's product-moment correlation

data:  all_u$NUMPROCS and all_u$ATPT
t = -2.8268, df = 331, p-value = 0.005033
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.27474501 -0.05015675
sample estimates:
       cor 
-0.1645833

## H3: ATPT vs. Thrashing Pt.
> cor.test(all_u$ATPT, all_u$THRASHING_PT)

	Pearson's product-moment correlation

data:  all_u$ATPT and all_u$THRASHING_PT
t = -2.4503, df = 331, p-value = 0.01479
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.23754546 -0.02638012
sample estimates:
       cor 
-0.1334774

### regression analyses
### regression on Thrashing Pt.
> out.fit <- lm(THRASHING_PT ~ ATPT + NUMPROCS, 
data = all_u)
> summary(out.fit)

Call:
lm(formula = THRASHING_PT ~ ATPT + NUMPROCS, data = all_u)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.51309 -0.22895 -0.05133  0.18175  0.61878 

Coefficients:
	      Estimate Std. Error t value Pr(>|t|)    
(Intercept)    0.59802    0.04014  14.897  < 2e-16 ***
ATPT          -0.12790    0.04391  -2.913  0.00386 ** 
NUMPROCS      -0.36867    0.05183  -7.113 9.11e-12 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.2632 on 331 degrees of freedom
Multiple R-squared:  0.1581,	Adjusted R-squared:  0.1522 
F-statistic: 26.86 on 2 and 331 DF,  p-value: 2.042e-1
	
### regression on ATPT
> med.fit <- lm(ATPT ~ NUMPROCS, data = all_u)
> summary(med.fit)

Call:
lm(formula = ATPT ~ NUMPROCS, data = all_u)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.53745 -0.32605 -0.01386  0.32881  0.71923 

Coefficients:
	      Estimate Std. Error t value Pr(>|t|)    
(Intercept)    0.62342    0.03973  15.690  < 2e-16 ***
NUMPROCS      -0.34264    0.06109  -5.609  4.3e-08 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.3535 on 332 degrees of freedom
Multiple R-squared:  0.08655,	Adjusted R-squared:  0.0838 
F-statistic: 31.46 on 1 and 332 DF,  p-value: 4.299e-08

### mediation analyses
## testing the mediation through ATPT by NUMPROCS
> med.out <- mediate(med.fit, out.fit, mediator = "ATPT", 
treat = "NUMPROCS")
> summary(med.out)

Causal Mediation Analysis 

Quasi-Bayesian Confidence Intervals

	       Estimate 95% CI Lower 95% CI Upper p-value
ACME             0.0617       0.0258       0.1047    0.00
ADE             -0.2192      -0.3379      -0.0970    0.00
Total Effect    -0.1575      -0.2756      -0.0349    0.01
Prop. Mediated  -0.3741      -1.9040      -0.1354    0.01

Sample Size Used: 333 


Simulations: 1000 

> sens.out <-medsens(med.out)
> summary(sens.out)

Mediation Sensitivity Analysis for Average Causal Mediation Effect

Sensitivity Region

      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
[1,] -0.3 -0.0205      -0.0424       0.0014         0.09       0.0737
[2,] -0.2 -0.0046      -0.0216       0.0124         0.04       0.0328
[3,] -0.1  0.0103      -0.0078       0.0285         0.01       0.0082

Rho at which ACME = 0: -0.2
R^2_M*R^2_Y* at which ACME = 0: 0.04
R^2_M~R^2_Y~ at which ACME = 0: 0.0328

### testing assumptions
### 1), 2), and 3): no commands
### 4) No correlation of residuals
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.4401782      1.111135       0
 Alternative hypothesis: rho != 00
> durbinWatsonTest(med.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.8300255     0.3310545       0
 Alternative hypothesis: rho != 0
### 5) Homoscedasticity
> ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 0.5052569    Df = 1     p = 0.4771994
### 6) No multicolinearity
> sqrt(vif(out.fit)) > 2
         ATPT	NUMPROCS 
        FALSE      FALSE 
### 7) No significant outliers: cooks distance
> cd = cooks.distance(out.fit)
> plot(cd, ylim=c(0, 0.03), 
main="(CD shouldn't be greater than 1)", 
ylab="Cook's Distances (CDs)", xlab="Observation Number")
### see Figure 10.1 (b)
### 8) normality of residuals
> h <- hist(out.fit$res,main="",xlab="Residuals",ylim=c(0,50),
xlim=c(-1,1))
> xfit<-seq(min(out.fit$res),max(out.fit$res),length=40) 
> yfit<-dnorm(xfit,mean=mean(out.fit$res),sd=sd(out.fit$res)) 
> yfit <- yfit*diff(h$mids[1:2])*length(out.fit$res) 
> lines(xfit, yfit, col="blue")
### see Figure 10.1 (d)

###################################################
### per-DBMS durbinWatson Test
###################################################
## db2
> db2_r <- subset(x, x$DBMS=='db2')
> nrow(db2_r)
[1] 34
> db2_r$ATP = (db2_r$ATP-min(db2_r$ATP))/(max(db2_r$ATP)-min(db2_r$ATP))
> db2_r$THRASHING_PT = (db2_r$THRASHING_PT-min(db2_r$THRASHING_PT))/(max(db2_r$THRASHING_PT)-min(db2_r$THRASHING_PT))
> out.fit <- lm(formula = THRASHING_PT ~ PK + ATP + NUMPROCS, data = db2_r)
> ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 0.3430361    Df = 1     p = 0.558082
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1      -0.0606969       2.01542   0.798
 Alternative hypothesis: rho != 0
> durbinWatsonTest(med.fit)
 lag Autocorrelation D-W Statistic p-value
   1      -0.1611907      2.305051   0.508
 Alternative hypothesis: rho != 0
## mysql
> mysql_r <- subset(x, x$DBMS=='mysql')
> nrow(mysql_r)
[1] 45
> mysql_r$ATP = (mysql_r$ATP-min(mysql_r$ATP))/(max(mysql_r$ATP)-min(mysql_r$ATP))
> mysql_r$THRASHING_PT = (mysql_r$THRASHING_PT-min(mysql_r$THRASHING_PT))/(max(mysql_r$THRASHING_PT)-min(mysql_r$THRASHING_PT))
#> mysql_r <- subset(mysql_r, mysql_r$THRASHING_PT < 1)
> out.fit <- lm(formula = THRASHING_PT ~ PK + ATP + NUMPROCS, data = mysql_r)
> ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 0.2016327    Df = 1     p = 0.6534062
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.2655616      1.242953   0.008
 Alternative hypothesis: rho != 0
> durbinWatsonTest(med.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.1847046      1.309282   0.012
 Alternative hypothesis: rho != 0
## oracle
> oracle_r <- subset(x, x$DBMS=='oracle')
> nrow(oracle_r)
[1] 56
> oracle_r$ATP = (oracle_r$ATP-min(oracle_r$ATP))/(max(oracle_r$ATP)-min(oracle_r$ATP))
> oracle_r$THRASHING_PT = (oracle_r$THRASHING_PT-min(oracle_r$THRASHING_PT))/(max(oracle_r$THRASHING_PT)-min(oracle_r$THRASHING_PT))
> out.fit <- lm(formula = THRASHING_PT ~ PK + ATP + NUMPROCS, data = oracle_r)
> ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 0.6244767    Df = 1     p = 0.4293885 
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1      0.05203888      1.847575   0.414
 Alternative hypothesis: rho != 0
> durbinWatsonTest(med.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.2062434      1.560045   0.068
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
> if(max(pgsql_r$THRASHING_PT)-min(pgsql_r$THRASHING_PT)==0) {
+    pgsql_r$THRASHING_PT = 0
+ } else { 
+    pgsql_r$THRASHING_PT = (pgsql_r$THRASHING_PT-min(pgsql_r$THRASHING_PT))/(max(pgsql_r$THRASHING_PT)-min(pgsql_r$THRASHING_PT))
+ }
> 
> out.fit <- lm(formula = THRASHING_PT ~ PK + ATP + NUMPROCS, data = pgsql_r)
> ncvTest(out.fit)
Error in lm.fit(x, y, offset = offset, singular.ok = singular.ok, ...) : 
  0 (non-NA) cases
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1              NA            NA      NA
 Alternative hypothesis: rho != 0
> durbinWatsonTest(med.fit)
 lag Autocorrelation D-W Statistic p-value
   1              NA            NA      NA
 Alternative hypothesis: rho != 0
### sqlserver
> sqlserver_r <- subset(x, x$DBMS=='sqlserver')
> nrow(sqlserver_r)
[1] 12
#> sqlserver_r$THRASHING_PT[5] <- 300
#> sqlserver_r$THRASHING_PT[7] <- 500
#> sqlserver_r$THRASHING_PT[11] <- 800
> sqlserver_r$ATP = (sqlserver_r$ATP-min(sqlserver_r$ATP))/(max(sqlserver_r$ATP)-min(sqlserver_r$ATP))
> if(max(sqlserver_r$THRASHING_PT)-min(sqlserver_r$THRASHING_PT)==0) {
+     sqlserver_r$THRASHING_PT = 0
+ } else { 
+     sqlserver_r$THRASHING_PT = (sqlserver_r$THRASHING_PT-min(sqlserver_r$THRASHING_PT))/(max(sqlserver_r$THRASHING_PT)-min(sqlserver_r$THRASHING_PT))
+ }
> out.fit <- lm(formula = THRASHING_PT ~ PK + ATP + NUMPROCS, data = sqlserver_r)
> ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 0.08257456    Df = 1     p = 0.7738383
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.2242306      1.506491    0.29
 Alternative hypothesis: rho != 0
> durbinWatsonTest(med.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.0932338      1.689739   0.542
 Alternative hypothesis: rho != 0

#### gather all the DBMSes' samples
> x_r = rbind(db2_r,mysql_r,oracle_r,pgsql_r,sqlserver_r)
#> x_r <- subset(x_r, x_r$THRASHING_PT < 1)
> out.fit <- lm(formula = THRASHING_PT ~ PK + ATP + NUMPROCS, data = x_r)
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

############################################
########## update ##########################
### per-DBMS
# db2
> db2_w <- subset(x, x$DBMS=='db2')
> nrow(db2_w)
[1] 4
> db2_w$ATP = (db2_w$ATP-min(db2_w$ATP))/(max(db2_w$ATP)-min(db2_w$ATP))
> db2_w$THRASHING_PT = (db2_w$THRASHING_PT-min(db2_w$THRASHING_PT))/(max(db2_w$THRASHING_PT)-min(db2_w$THRASHING_PT))
> out.fit <- lm(THRASHING_PT ~ ATP + NUMPROCS, data = db2_w)
> ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 0.5904476    Df = 1     p = 0.4422461
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1     -0.01202913       1.83287   0.864
 Alternative hypothesis: rho != 0
> durbinWatsonTest(med.fit)
 lag Autocorrelation D-W Statistic p-value
   1      -0.2606981      1.985312      NA
 Alternative hypothesis: rho != 0
# mysql
> mysql_w <- subset(x, x$DBMS=='mysql')
> nrow(mysql_w)
[1] 31
> mysql_w$ATP = (mysql_w$ATP-min(mysql_w$ATP))/(max(mysql_w$ATP)-min(mysql_r$ATP))
> mysql_w$THRASHING_PT = (mysql_w$THRASHING_PT-min(mysql_w$THRASHING_PT))/(max(mysql_w$THRASHING_PT)-min(mysql_w$THRASHING_PT))
> out.fit <- lm(THRASHING_PT ~ ATP + NUMPROCS, data = mysql_w)
> ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 0.01017611    Df = 1     p = 0.9196483
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.2815578       1.36935   0.054
 Alternative hypothesis: rho != 0
> durbinWatsonTest(med.fit)
 lag Autocorrelation D-W Statistic p-value
   1      0.04458135      1.840426   0.526
 Alternative hypothesis: rho != 0
# oracle
oracle_w <- subset(x, x$DBMS=='oracle')
nrow(oracle_w)
[1] 30
> oracle_w$ATP = (oracle_w$ATP-min(oracle_w$ATP))/(max(oracle_w$ATP)-min(oracle_w$ATP))
> oracle_w$THRASHING_PT = (oracle_w$THRASHING_PT-min(oracle_w$THRASHING_PT))/(max(oracle_w$THRASHING_PT)-min(oracle_w$THRASHING_PT))
> out.fit <- lm(THRASHING_PT ~ ATP + NUMPROCS, data = oracle_w)
> ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 13.45413    Df = 1     p = 0.0002444679 
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1    -0.003209438      1.964668    0.63
 Alternative hypothesis: rho != 0
> durbinWatsonTest(med.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.7383233      0.448061       0
 Alternative hypothesis: rho != 0
# pgsql
> pgsql_w <- subset(x, x$DBMS=='pgsql')
> nrow(pgsql_w)
[1] 139
> pgsql_w$ATP = (pgsql_w$ATP-min(pgsql_w$ATP))/(max(pgsql_w$ATP)-min(pgsql_w$ATP))
> pgsql_w$THRASHING_PT = (pgsql_w$THRASHING_PT-min(pgsql_w$THRASHING_PT))/(max(pgsql_w$THRASHING_PT)-min(pgsql_w$THRASHING_PT))
> out.fit <- lm(THRASHING_PT ~ ATP + NUMPROCS, data = pgsql_w)
> ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 0.006076916    Df = 1     p = 0.9378642
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1      0.09892979      1.800787    0.18
 Alternative hypothesis: rho != 0
> durbinWatsonTest(med.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.8137164     0.3574743       0
 Alternative hypothesis: rho != 0
# sqlserver
> sqlserver_w <- subset(x, x$DBMS=='sqlserver')
> nrow(sqlserver_w)
[1] 129
> sqlserver_w$ATP = (sqlserver_w$ATP-min(sqlserver_w$ATP))/(max(sqlserver_w$ATP)-min(sqlserver_w$ATP))
> sqlserver_w$THRASHING_PT = (sqlserver_w$THRASHING_PT-min(sqlserver_w$THRASHING_PT))/(max(sqlserver_w$THRASHING_PT)-min(sqlserver_w$THRASHING_PT))
> out.fit <- lm(THRASHING_PT ~ ATP + NUMPROCS, data = sqlserver_w)
> ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 1.853945    Df = 1     p = 0.1733253
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.6710034     0.6529241       0
 Alternative hypothesis: rho != 0
> durbinWatsonTest(med.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.9107786     0.1719391       0
 Alternative hypothesis: rho != 0

### collect all the DBMSes' samples
> x_w = rbind(db2_w,mysql_w,oracle_w,pgsql_w,sqlserver_w)
#x_w <- subset(x_w, x_w$THRASHING_PT < 1)
out.fit <- lm(THRASHING_PT ~ ATP + NUMPROCS, data = x_w)
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
