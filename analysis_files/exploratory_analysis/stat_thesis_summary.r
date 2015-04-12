> library(ggplot2) ## for generating graphs
> library(car) ## for testing assumptions
> library(mediation) ## for testing mediation
Loading required package: MASS
Loading required package: Matrix
Loading required package: lpSolve
Loading required package: sandwich
Loading required package: mvtnorm
mediation: Causal Mediation Analysis
Version: 4.4.2
# expl.dat: collected data for exploratory experiments
# column headers: 
# DBMS|EXPNAME|RUNID|BATCHSETID|PK|NUMPROCS|ROSE|READ_SF|UPDATE_SF|ATPT|THRASHING_PT
> expl = read.csv(file="expl.dat",head=TRUE,sep="\t")
### select only thrashing BSIs from retained BSIs
> expl <- subset(expl, expl$THRASHING_PT < 1100)
#### normalize the values of ROSE, READ_SF, and NUMPROCS
> expl$ROSE = (expl$ROSE/min(expl$ROSE))/(max(expl$ROSE)/min(expl$ROSE))
> expl$NUMPROCS = (expl$NUMPROCS/min(expl$NUMPROCS))/(max(expl$NUMPROCS)/min(expl$NUMPROCS))
> expl$READ_SF = (expl$READ_SF/min(expl$READ_SF))/(max(expl$READ_SF)/min(expl$READ_SF))
> expl$UPDATE_SF = (expl$UPDATE_SF/min(expl$UPDATE_SF))/(max(expl$UPDATE_SF)/min(expl$UPDATE_SF))
### conduct the analysis on the read batchset group (read group)
### select only read group from the data
> expl_r <- subset(expl, expl$READ_SF!=0)
> expl_r <- subset(expl_r, select = -UPDATE_SF)
### select only update group from the data
> expl_w <- subset(expl, expl$UPDATE_SF!=0)
> expl_w <- subset(expl_w, select = -READ_SF)
# normalize the per-DBMS values of ATPT and ThrashingPt
# dbms_x_r
> dbms_x_r <- subset(expl_r, expl_r$DBMS=='dbms_x')
> dbms_x_r$ATPT = (dbms_x_r$ATPT-min(dbms_x_r$ATPT))/(max(dbms_x_r$ATPT)-min(dbms_x_r$ATPT))
> dbms_x_r$THRASHING_PT = (dbms_x_r$THRASHING_PT-min(dbms_x_r$THRASHING_PT))/(max(dbms_x_r$THRASHING_PT)-min(dbms_x_r$THRASHING_PT))
# dbms_y_r
> dbms_y_r <- subset(expl_r, expl_r$DBMS=='dbms_y')
> dbms_y_r$ATPT = (dbms_y_r$ATPT-min(dbms_y_r$ATPT))/(max(dbms_y_r$ATPT)-min(dbms_y_r$ATPT))
> dbms_y_r$THRASHING_PT = (dbms_y_r$THRASHING_PT-min(dbms_y_r$THRASHING_PT))/(max(dbms_y_r$THRASHING_PT)-min(dbms_y_r$THRASHING_PT))
# mysql_r
> mysql_r <- subset(expl_r, expl_r$DBMS=='mysql')
> mysql_r$ATPT = (mysql_r$ATPT-min(mysql_r$ATPT))/(max(mysql_r$ATPT)-min(mysql_r$ATPT))
> mysql_r$THRASHING_PT = (mysql_r$THRASHING_PT-min(mysql_r$THRASHING_PT))/(max(mysql_r$THRASHING_PT)-min(mysql_r$THRASHING_PT))
# pgsql_r
> pgsql_r <- subset(expl_r, expl_r$DBMS=='pgsql_r')
> pgsql_r$ATPT = (pgsql_r$ATPT-min(pgsql_r$ATPT))/(max(pgsql_r$ATPT)-min(pgsql_r$ATPT))
> pgsql_r$THRASHING_PT = (pgsql_r$THRASHING_PT-min(pgsql_r$THRASHING_PT))/(max(pgsql_r$THRASHING_PT)-min(pgsql_r$THRASHING_PT))
# dbms_z_r
> dbms_z_r <- subset(expl_r, expl_r$DBMS=='dbms_z_r')
> dbms_z_r$ATPT = (dbms_z_r$ATPT-min(dbms_z_r$ATPT))/(max(dbms_z_r$ATPT)-min(dbms_z_r$ATPT))
> dbms_z_r$THRASHING_PT = (dbms_z_r$THRASHING_PT-min(dbms_z_r$THRASHING_PT))/(max(dbms_z_r$THRASHING_PT)-min(dbms_z_r$THRASHING_PT))

#### collect all the DBMSes' thrashing samples
> all_r = rbind(dbms_z_r,mysql,dbms_z_r,pgsql,dbms_z_r)

### correlational analyses
### H1: NUMPROCS and Thrashing Pt.
> cor.test(all_r$NUMPROCS, all_r$THRASHING_PT)
	Pearson's product-moment correlation

data:  all_r$NUMPROCS and all_r$THRASHING_PT
t = 2.5904, df = 186, p-value = 0.009947
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 0.03149136 0.22675217
sample estimates:
      cor 
0.1303858 
### H2: NUMPROCS and ATPT 
> cor.test(all_r$NUMPROCS, all_r$ATPT)

	Pearson's product-moment correlation

data:  all_r$NUMPROCS and all_r$ATPT
t = -2.6248, df = 186, p-value = 0.009014
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.2283910 -0.0332179
sample estimates:
       cor 
-0.1320844

### H3: ATPT and Thrashing Pt.
> cor.test(all_r$ATPT, all_r$THRASHING_PT)
	Pearson's product-moment correlation

data:  all_r$ATPT and all_r$THRASHING_PT
t = -8.1596, df = 186, p-value = 4.734e-15
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.4643597 -0.2945983
sample estimates:
       cor 
-0.3827048 

### H4: READ_SF and Thrashing Pt.
> cor.test(all_r$READ_SF, all_r$THRASHING_PT)
	Pearson's product-moment correlation

data:  all_r$READ_SF and all_r$THRASHING_PT
t = 0.4452, df = 186, p-value = 0.6567
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.1110048  0.1749173
sample estimates:
       cor 
0.03262371 

### H5: READ_SF and ATPT 
> cor.test(all_r$READ_SF, all_r$ATPT)
	Pearson's product-moment correlation

data:  all_r$READ_SF and all_r$ATPT
t = -0.579, df = 186, p-value = 0.5629
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.12830956  0.07012511
sample estimates:
	cor 
-0.0293817

### H6: ROSE and Thrashing Pt. 
	Pearson's product-moment correlation

data:  all_r$ROSE and all_r$THRASHING_PT
t = -1.8674, df = 186, p-value = 0.06341
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.273462770  0.007596024
sample estimates:
       cor 
-0.1356617

### H8: PK and Thrashing Pt.
> cor.test(all_r$PK, all_r$THRASHING_PT)

	Pearson's product-moment correlation

data:  all_r$PK and all_r$THRASHING_PT
t = 8.6669, df = 186, p-value < 2.2e-16
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 0.3160736 0.4827318
sample estimates:
      cor 
0.4027353

### H9: PK and ATPT
> cor.test(all_r$PK, all_r$ATPT) 
	Pearson's product-moment correlation

data:  all_r$PK and all_r$ATPT
t = -5.2071, df = 186, p-value = 5.053e-07
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.4755242 -0.2250657
sample estimates:
       cor 
-0.3566874 

### regression analysis
### regression on Thrashing Pt.
> out.fit <- lm(formula = THRASING_PT ~ PK + READ_SF + ROSE + ATPT + NUMPROCS, data = all_r)
> summary(out.fit)

Call:
lm(formula = THRASING_PT ~ PK + READ_SF + ROSE + ATPT + NUMPROCS, 
    data = all_r)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.54022 -0.24221 -0.02016  0.23209  0.58479 

Coefficients:
	      Estimate Std. Error t value Pr(>|t|)    
(Intercept)    0.32029    0.07919   4.045 7.97e-05 ***
PK             0.24987    0.05367   4.656 6.53e-06 ***
READ_SF        0.02265    0.05008   0.452   0.6516    
ROSE          -0.16748    0.08072  -2.075   0.0395 *  
ATPT           0.12564    0.07040   1.785   0.0761 .  
NUMPROCS       0.03008    0.07034   0.428   0.6695    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.3277 on 182 degrees of freedom
Multiple R-squared:  0.1383,	Adjusted R-squared:  0.1127 
F-statistic: 5.393 on 5 and 182 DF,  p-value: 0.000126

### regression on ATPT
> med.fit <- lm(ATPT ~ PK:READ_SF + PK + READ_SF + ROSE + NUMPROCS + NUMPROCS:ROSE, data = all_r)
> summary(med.fit)

Call:
lm(formula = ATPT ~ PK:READ_SF + PK + READ_SF + ROSE + NUMPROCS + 
    NUMPROCS:ROSE, data = all_r)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.54146 -0.21509  0.04979  0.16082  0.78462 

Coefficients:
	        Estimate Std. Error t value Pr(>|t|)    
(Intercept)     0.57902    0.10750   5.386 2.41e-07 ***
PK              -0.29916   0.07122  -4.200 4.33e-05 ***
READ_SF         0.01230    0.06527   0.188    0.851    
ROSE            -0.07394   0.14978  -0.494    0.622    
NUMPROCS        -0.18655   0.18554  -1.005    0.316    
PK:READ_SF      0.02919    0.12157   0.240    0.811    
ROSE:NUMPROCS 	0.10819    0.28347   0.382    0.703    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.3231 on 181 degrees of freedom
Multiple R-squared:   0.15,	Adjusted R-squared:  0.1194 
F-statistic: 4.911 on 6 and 181 DF,  p-value: 0.000119

### assumption testing
### 1), 2), and 3): no commands
### 4) No correlation of residuals
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.5589201     0.8715399       0
 Alternative hypothesis: rho != 0
### 5) Homoscedasticity
> ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 0.3423284    Df = 1     p = 0.5584883 
### 6) No multicolinearity
> sqrt(vif(out.fit)) > 2
           PK       READ_SF    ROSE           ATPT NUMPROCS 
        FALSE         FALSE         FALSE         FALSE         FALSE
### 7) No significant outliers: cooks distance
> cd = cooks.distance(out.fit)
> plot(cd, xlim=c(0, 200), ylim=c(0, 0.04), main="(CD shouldn't be greater than 1)", ylab="Cook's Distances (CDs)", xlab="Observeration Number")
### see Figure 8.1 (a)
### 8) normality of residuals
> h <- hist(out.fit$res,main="",xlab="Residuals",ylim=c(0,60),xlim=c(-1,1))
> xfit<-seq(min(out.fit$res),max(out.fit$res),length=40) 
> yfit<-dnorm(xfit,mean=mean(out.fit$res),sd=sd(out.fit$res)) 
> yfit <- yfit*diff(h$mids[1:2])*length(out.fit$res) 
> lines(xfit, yfit, col="blue")
### see Figure 8.2 (a)

## causal mediation analyses
## testing the mediation through ATPT by NUMPROCS
> med.out <- mediate(med.fit, out.fit, mediator = "ATPT", treat = "NUMPROCS")
> summary(med.out)

Causal Mediation Analysis 

Quasi-Bayesian Confidence Intervals

	       Estimate 95% CI Lower 95% CI Upper p-value
ACME            0.02905      0.00632      0.05465       0
ADE             0.12354      0.03126      0.21488       0
Total Effect    0.15260      0.06459      0.24115       0
Prop. Mediated  0.18564      0.03934      0.48834       0

Sample Size Used: 188 


Simulations: 1000

## mediation sensitivity analysis on NUMPROCS
> sens.out <-medsens(med.out)
> summary(sens.out)

Mediation Sensitivity Analysis for Average Causal Mediation Effect

Sensitivity Region

      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
[1,] -0.4 -0.0211      -0.0440       0.0019         0.16       0.1090
[2,] -0.3 -0.0072      -0.0204       0.0059         0.09       0.0613
[3,] -0.2  0.0053      -0.0070       0.0176         0.04       0.0273
[4,] -0.1  0.0171      -0.0026       0.0368         0.01       0.0068
[5,]  0.0  0.0285      -0.0008       0.0578         0.00       0.0000

Rho at which ACME = 0: -0.2
R^2_M*R^2_Y* at which ACME = 0: 0.04
R^2_M~R^2_Y~ at which ACME = 0: 0.0273

## testing the mediation through ATPT by PK
> med.out <- mediate(med.fit, out.fit, mediator = "ATPT", treat = "PK")
> summary(med.out)

Causal Mediation Analysis 

Quasi-Bayesian Confidence Intervals

               Estimate 95% CI Lower 95% CI Upper p-value
ACME             0.0593       0.0318       0.0899       0
ADE              0.2596       0.1807       0.3349       0
Total Effect     0.3189       0.2449       0.3935       0
Prop. Mediated   0.1857       0.0959       0.2971       0

Sample Size Used: 188 


Simulations: 1000

## mediation sensitivity analysis on PK
> sens.out <-medsens(med.out)
> summary(sens.out)

Mediation Sensitivity Analysis for Average Causal Mediation Effect

Sensitivity Region

      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
[1,] -0.3 -0.0191      -0.0489       0.0107         0.09       0.0607
[2,] -0.2  0.0136      -0.0161       0.0433         0.04       0.0270

Rho at which ACME = 0: -0.2
R^2_M*R^2_Y* at which ACME = 0: 0.04
R^2_M~R^2_Y~ at which ACME = 0: 0.027
