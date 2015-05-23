#### exploratory evaluation output
### all_r: thrashing samples captured in the read group
## H1: numProcs vs. Thrashing Pt.
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

### H2: numProcs vs. ATPT
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

### H3: ATPT vs. Thrashing Pt.
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

### H4: read SF vs. Thrashing Pt.
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

### H5: read SF vs. ATPT 
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

### H6: ROSE vs. Thrashing Pt. 
	Pearson's product-moment correlation

data:  all_r$ROSE and all_r$THRASHING_PT
t = -1.8674, df = 186, p-value = 0.06341
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.273462770  0.007596024
sample estimates:
       cor 
-0.1356617

### H8: PK vs. Thrashing Pt.
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

### H9: PK vs. ATPT
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
### regression on Thrashing Pt in the full path model.
> out.fit <- lm(formula = THRASHING_PT ~ PK + READ_SF + ROSE + ATPT 
+ NUMPROCS, data = all_r)
> summary(out.fit)

Call:
lm(formula = THRASHING_PT ~ PK + READ_SF + ROSE + ATPT + NUMPROCS, 
    data = all_r)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.54022 -0.24221 -0.02016  0.23209  0.58479 

Coefficients:
	      Estimate Std. Error t value Pr(>|t|)    
(Intercept)    0.32029    0.07919   4.045 7.97e-05 ***
PK             0.24987    0.05367   4.656 6.53e-06 ***
READ_SF        0.02265    0.05008   0.452   0.6516    
ROSE           0.12564    0.07040   1.785   0.0761 .
ATPT          -0.16748    0.08072  -2.075   0.0395 *   
NUMPROCS       0.10762    0.05047   2.132   0.0336 *    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.3277 on 182 degrees of freedom
Multiple R-squared:  0.1383, Adjusted R-squared:  0.1127 
F-statistic: 4.525 on 5 and 182 DF,  p-value: 0.0006524

### regression on Thrashing Pt in the reduced path model.
> out.fit <- lm(formula = THRASING_PT ~ PK + ATPT + NUMPROCS, 
data = all_r)
> summary(out.fit)

Call:
lm(formula = THRASING_PT ~ PK + ATPT + NUMPROCS, data = all_r)

Residuals:
    Min      1Q  Median      3Q     Max 
-0.5727 -0.2337 -0.0296  0.2287  0.6288 

Coefficients:
	      Estimate Std. Error t value Pr(>|t|)    
(Intercept)    0.39621    0.06799   5.827 2.76e-08 ***
PK             0.21472    0.04984   4.308 2.78e-05 ***
ATPT          -0.16999    0.08102  -2.098   0.0374 *  
NUMPROCS       0.12997    0.07086   1.834 0.048373 .    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.2928 on 182 degrees of freedom
Multiple R-squared:  0.1207,	Adjusted R-squared:  0.1051 
F-statistic: 7.776 on 3 and 182 DF,  p-value: 6.765e-05

### regression on ATPT in the full path model
> med.fit <- lm(ATPT ~ PK:READ_SF + PK + READ_SF + ROSE + NUMPROCS + 
NUMPROCS:ROSE, data = all_r)
> summary(med.fit)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.54146 -0.21509  0.04979  0.16082  0.78462 

Coefficients:
		Estimate Std. Error t value Pr(>|t|)    
(Intercept)     0.57902    0.10750   5.386  2.41e-07 ***
PK             -0.29916    0.07122  -4.200  4.33e-05 ***
READ_SF         0.01230    0.06527   0.188     0.851    
ROSE           -0.07394    0.14978  -0.494     0.622    
NUMPROCS       -0.18655    0.08554  -2.005     0.031 *    
PK:READ_SF      0.02919    0.12157   0.240     0.811    
ROSE:NUMPROCS   0.10819    0.28347   0.382     0.703    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.3231 on 181 degrees of freedom
Multiple R-squared:   0.15, Adjusted R-squared:  0.1194 
F-statistic: 4.757 on 6 and 181 DF,  p-value: 0.0001585
	
### regression on ATPT in the reduced path model	
> med.fit <- lm(ATPT ~ PK + NUMPROCS, data = all_r)
> summary(med.fit)

Call:
lm(formula = ATPT ~ PK + NUMPROCS, data = all_r)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.52009 -0.21736  0.05116  0.16370  0.76693 

Coefficients:
	      Estimate Std. Error t value Pr(>|t|)    
(Intercept)    0.53511    0.04369  12.248  < 2e-16 ***
PK     	  -0.28739    0.05394  -5.328  3.1e-07 ***
NUMPROCS  -0.11716    0.07534  -1.555    0.012 *   
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.317 on 181 degrees of freedom
Multiple R-squared:  0.1479,	Adjusted R-squared:  0.1379 
F-statistic: 14.84 on 2 and 181 DF,  p-value: 1.142e-06

## causal mediation analyses
> library(mediation) ### include mediation library
## testing the mediation through ATPT by numProcs
> med.out <- mediate(med.fit, out.fit, mediator = "ATPT", 
treat = "NUMPROCS")
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

## testing the mediation through ATPT by read SF
> med.out <- mediate(med.fit, out.fit, mediator = "ATPT", treat = "READ_SF")
> summary(med.out)

Causal Mediation Analysis 

Quasi-Bayesian Confidence Intervals

                Estimate 95% CI Lower 95% CI Upper p-value
ACME            0.000314    -0.008533     0.010285    0.96
ADE             0.015300    -0.096499     0.132477    0.76
Total Effect    0.015615    -0.095567     0.134702    0.77
Prop. Mediated  0.000418    -0.625022     0.667832    0.98

Sample Size Used: 188 

Simulations: 1000

> sens.out <-medsens(med.out)
> summary(sens.out)

Mediation Sensitivity Analysis for Average Causal Mediation Effect

Sensitivity Region

       Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
 [1,] -0.9  0.0310      -0.1962       0.2581         0.81       0.6223
 [2,] -0.8  0.0194      -0.1328       0.1717         0.64       0.4917
 [3,] -0.7  0.0145      -0.1010       0.1300         0.49       0.3765
 [4,] -0.6  0.0115      -0.0794       0.1023         0.36       0.2766
 [5,] -0.5  0.0093      -0.0624       0.0809         0.25       0.1921
 [6,] -0.4  0.0074      -0.0480       0.0629         0.16       0.1229
 [7,] -0.3  0.0057      -0.0352       0.0467         0.09       0.0691
 [8,] -0.2  0.0040      -0.0235       0.0316         0.04       0.0307
 [9,] -0.1  0.0022      -0.0126       0.0170         0.01       0.0077
[10,]  0.0  0.0003      -0.0032       0.0038         0.00       0.0000
[11,]  0.1 -0.0018      -0.0129       0.0093         0.01       0.0077
[12,]  0.2 -0.0041      -0.0279       0.0196         0.04       0.0307
[13,]  0.3 -0.0068      -0.0440       0.0304         0.09       0.0691
[14,]  0.4 -0.0098      -0.0615       0.0419         0.16       0.1229
[15,]  0.5 -0.0133      -0.0812       0.0547         0.25       0.1921
[16,]  0.6 -0.0175      -0.1047       0.0696         0.36       0.2766
[17,]  0.7 -0.0230      -0.1348       0.0889         0.49       0.3765
[18,]  0.8 -0.0307      -0.1794       0.1179         0.64       0.4917
[19,]  0.9 -0.0454      -0.2690       0.1782         0.81       0.6223

Rho at which ACME = 0: 0
R^2_M*R^2_Y* at which ACME = 0: 0
R^2_M~R^2_Y~ at which ACME = 0: 0 

### assumption testing
> library(car) ### library for testing assumptions
> library(ggplot2) ### library for rendering graphs
### 1), 2), and 3): no commands
### 4) No correlation of residuals
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.5589201     0.8715399       0
 Alternative hypothesis: rho != 0
> library(car)
> durbinWatsonTest(med.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.7445287     0.4932397       0
 Alternative hypothesis: rho != 0
### 5) Homoscedasticity
> ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 0.3423284    Df = 1     p = 0.5584883 
### 6) No multicolinearity
> sqrt(vif(out.fit)) > 2
    PK       READ_SF  ROSE     ATPT     NUMPROCS
    FALSE    FALSE    FALSE    FALSE    FALSE
### 7) No significant outliers: cooks distance
> cd = cooks.distance(out.fit)
> plot(cd, xlim=c(0, 200), ylim=c(0, 0.04), 
main="(CD shouldn't be greater than 1)", 
xlab="Observation Number",
ylab="Cook's Distances (CDs)") 
### see Figure 8.1 (a)
### 8) normality of residuals
> h <- hist(out.fit$res,main="",xlab="Residuals",xlim=c(-1,1),
ylim=c(0,60))
> xfit<-seq(min(out.fit$res),max(out.fit$res),length=40) 
> yfit<-dnorm(xfit,mean=mean(out.fit$res),sd=sd(out.fit$res)) 
> yfit <- yfit*diff(h$mids[1:2])*length(out.fit$res) 
> lines(xfit, yfit, col="blue")
### see Figure 8.1 (c)

##############################
### update ###################
##############################
### all_u: thrashing samples captured in the update group
### H1: numProcs vs. Thrashing Pt.
> cor.test(all_u$NUMPROCS, all_u$THRASHING_PT)
	Pearson's product-moment correlation

data:  all_u$NUMPROCS and all_u$THRASHING_PT
t = -6.5744, df = 297, p-value = 2.694e-10
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.4784073 -0.2695684
sample estimates:
       cor 
-0.378799

### H2: numProcs vs. ATPT 
> cor.test(all_u$NUMPROCS, all_u$ATPT)

	Pearson's product-moment correlation

data:  all_u$NUMPROCS and all_u$ATPT
t = -6.1616, df = 297, p-value = 2.34e-09
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.4335366 -0.2320949
sample estimates:
       cor 
-0.3366621

### H3: ATPT vs. Thrashing Pt.
> cor.test(all_u$ATPT, all_u$THRASHING_PT)
	Pearson's product-moment correlation

data:  all_u$ATPT and all_u$THRASHING_PT
t = -2.6127, df = 297, p-value = 0.0405
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.14836295  -0.07821498
sample estimates:
        cor 
-0.11328896

### H4: update SF vs. Thrashing Pt.
> cor.test(all_u$UPDATE_SF, all_u$THRASHING_PT)
	Pearson's product-moment correlation

data:  all_u$UPDATE_SF and all_u$THRASHING_PT
t = -0.2518, df = 297, p-value = 0.8014
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.12782858  0.09898426
sample estimates:
       cor 
-0.0146101

### H5: update SF vs. ATPT 
> cor.test(all_u$UPDATE_SF, all_u$ATPT)
	Pearson's product-moment correlation

data:  all_u$UPDATE_SF and all_u$ATPT
t = -0.1649, df = 297, p-value = 0.8691
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.1228678  0.1039723
sample estimates:
         cor 
-0.009570916

### H6: ROSE vs. Thrashing Pt. 
>cor.test(all_u$ROSE, all_u$ATPT)
	Pearson's product-moment correlation

data:  all_u$ROSE and all_u$ATPT
t = -1.2802, df = 297, p-value = 0.2015
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.18595077  0.03968073
sample estimates:
        cor 
-0.07408304

### H8: PK vs. Thrashing Pt.
> cor.test(all_u$PK, all_u$THRASHING_PT)

	Pearson's product-moment correlation

data:  all_u$PK and all_u$THRASHING_PT
t = 1.3001, df = 297, p-value = 0.1946
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.03853075  0.18706245
sample estimates:
       cor 
0.07522836

### H9: PK vs. ATPT
> cor.test(all_u$PK, all_u$ATPT) 
	Pearson's product-moment correlation

data:  all_u$PK and all_u$ATPT
t = 2.657, df = 297, p-value = 0.18375
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 0.04238837 0.27930875
sample estimates:
      cor 
0.1632005

### regression analyses
### regression on Thrashing Pt. in the full path model
> out.fit <- lm(THRASHING_PT ~ PK + ATPT + NUMPROCS + UPDATE_SF + ROSE, 
data = all_u)
> summary(out.fit)

Call:
lm(formula = THRASHING_PT ~ PK + ATPT + NUMPROCS + UPDATE_SF + 
    ROSE, data = all_u)

Residuals:
    Min      1Q  Median      3Q     Max 
-0.6219 -0.2520  0.1127  0.2814  0.7071 

Coefficients:
	      Estimate Std. Error t value Pr(>|t|)    
(Intercept)    0.73033    0.07957   9.178  < 2e-16 ***
PK             0.06562    0.04166   1.575   0.1165    
ATPT          -0.11129    0.06575  -1.693   0.0417 .  
NUMPROCS      -0.44805    0.06511  -6.881 4.61e-11 ***
UPDATE_SF     -0.06207    0.07207  -0.861   0.3900    
ROSE          -0.06147    0.07252  -0.848   0.3974    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.368 on 293 degrees of freedom
Multiple R-squared:  0.1642,	Adjusted R-squared:  0.1478 
F-statistic: 4.964 on 5 and 293 DF,  p-value: 0.0002224

### regression on Thrashing Pt. in the reduced path model
> out.fit <- lm(THRASHING_PT ~ ATPT + NUMPROCS, data = all_u)
> summary(out.fit)

Call:
lm(formula = THRASHING_PT ~ ATPT + NUMPROCS, data = all_u)

Residuals:
    Min      1Q  Median      3Q     Max 
-0.6155 -0.2298  0.1392  0.2930  0.7087 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept)    0.67286    0.04420  15.224  < 2e-16 ***
ATPT          -0.09553    0.06432  -1.485   0.0439 *   
NUMPROCS      -0.43408    0.06446  -6.734 1.07e-10 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.3274 on 293 degrees of freedom
Multiple R-squared:  0.1508,	Adjusted R-squared:  0.1442 
F-statistic: 22.81 on 2 and 293 DF,  p-value: 7.574e-10

### regression on ATPT in the full path model
> med.fit <- lm(ATPT ~ NUMPROCS + ROSE + NUMPROCS:ROSE + PK + UPDATE_SF 
+ UPDATE_SF:PK, data = all_u)
> summary(med.fit)

Call:
lm(formula = ATPT ~ NUMPROCS + ROSE + NUMPROCS:ROSE + 
    PK + UPDATE_SF + UPDATE_SF:PK, data = all_u)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.44572 -0.23773 -0.06927  0.17636  0.81572 

Coefficients:
		Estimate Std. Error t value Pr(>|t|)  
(Intercept)    0.2608179  0.1079845   2.415   0.0164 *
NUMPROCS      -0.2845868  0.1484092  -1.918   0.0463 .
ROSE           0.1071328  0.1235238   0.867   0.3866  
PK             0.1278712  0.0945363   1.353   0.1774  
UPDATE_SF      0.0342841  0.0979067   0.350   0.7265  
NUMPROCS:ROSE -0.0457667  0.2105161  -0.217   0.8281  
PK:UPDATE_SF  -0.0001347  0.1378434  -0.001   0.9992  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.3008 on 292 degrees of freedom
Multiple R-squared:  0.1306,	Adjusted R-squared:  0.1099 
F-statistic: 9.255 on 6 and 292 DF,  p-value: 2.727e-09

### regression on ATPT in the reduced path model
> med.fit <- lm(ATPT ~ NUMPROCS, data = all_u)
> summary(med.fit)

Call:
lm(formula = ATPT ~ NUMPROCS, data = all_u)

Residuals:
    Min      1Q  Median      3Q     Max 
-0.3354 -0.2563 -0.1009  0.2019  0.8917 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept)    0.40509    0.03455   11.72  < 2e-16 ***
NUMPROCS      -0.29674    0.05959   -4.98 1.17e-06 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.3168 on 293 degrees of freedom
Multiple R-squared:  0.08768,	Adjusted R-squared:  0.08415 
F-statistic:  24.8 on 1 and 293 DF,  p-value: 1.167e-06

#### mediation analyses
## testing the mediation through ATPT by numProcs
> med.out <- mediate(med.fit, out.fit, mediator = "ATPT", 
treat = "NUMPROCS")
> summary(med.out)
	
Causal Mediation Analysis 

Quasi-Bayesian Confidence Intervals

	       Estimate 95% CI Lower 95% CI Upper p-value
ACME            0.04072      0.00369      0.08325    0.04
ADE            -0.45962     -0.59140     -0.33967    0.00
Total Effect   -0.41890     -0.55133     -0.30253    0.00
Prop. Mediated -0.10173     -0.23249     -0.00871    0.04

Sample Size Used: 299 

Simulations: 1000

> sens.out <- medsens(med.out)
> summary(sens.out)

Mediation Sensitivity Analysis for Average Causal Mediation Effect

Sensitivity Region

      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
[1,] -0.2 -0.0304      -0.0721       0.0112         0.04       0.0294
[2,] -0.1  0.0037      -0.0365       0.0439         0.01       0.0074
[3,]  0.0  0.0369      -0.0055       0.0792         0.00       0.0000

Rho at which ACME = 0: -0.1
R^2_M*R^2_Y* at which ACME = 0: 0.01
R^2_M~R^2_Y~ at which ACME = 0: 0.0074

## testing the mediation through ATPT by PK
> med.out <- mediate(med.fit, out.fit, mediator = "ATPT", treat = "PK")
> summary(med.out)

Causal Mediation Analysis 

Quasi-Bayesian Confidence Intervals

	       Estimate 95% CI Lower 95% CI Upper p-value
ACME           -0.01471     -0.04001      0.00109    0.09
ADE             0.06808     -0.01194      0.14839    0.09
Total Effect    0.05337     -0.02824      0.13223    0.18
Prop. Mediated -0.20640     -2.54565      2.00415    0.24

Sample Size Used: 299 

Simulations: 1000

> sens.out <- medsens(med.out)
> summary(sens.out)

Mediation Sensitivity Analysis for Average Causal Mediation Effect

Sensitivity Region

	Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
[1,] -0.2  0.0123      -0.0055       0.0301         0.04       0.0294
[2,] -0.1 -0.0015      -0.0178       0.0148         0.01       0.0074
[3,]  0.0 -0.0149      -0.0334       0.0036         0.00       0.0000

Rho at which ACME = 0: -0.1
R^2_M*R^2_Y* at which ACME = 0: 0.01
R^2_M~R^2_Y~ at which ACME = 0: 0.0074

## testing the mediation through ATPT by update SF
> med.out <- mediate(med.fit, out.fit, mediator = "ATPT", 
treat = "UPDATE_SF")
> summary(med.out)

Causal Mediation Analysis 

Quasi-Bayesian Confidence Intervals

	       Estimate 95% CI Lower 95% CI Upper p-value
ACME           -0.00378     -0.02494      0.01291    0.65
ADE            -0.06124     -0.20848      0.07853    0.41
Total Effect   -0.06502     -0.21510      0.07200    0.38
Prop. Mediated  0.02111     -0.93935      1.25419    0.74

Sample Size Used: 299 

Simulations: 1000			
	
> sens.out <- medsens(med.out)
> summary(sens.out)
	
Mediation Sensitivity Analysis for Average Causal Mediation Effect

Sensitivity Region

       Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
 [1,] -0.9  0.0557      -0.2429       0.3543         0.81       0.5886
 [2,] -0.8  0.0329      -0.1674       0.2333         0.64       0.4651
 [3,] -0.7  0.0232      -0.1273       0.1737         0.49       0.3561
 [4,] -0.6  0.0173      -0.0983       0.1330         0.36       0.2616
 [5,] -0.5  0.0131      -0.0744       0.1006         0.25       0.1817
 [6,] -0.4  0.0096      -0.0534       0.0726         0.16       0.1163
 [7,] -0.3  0.0064      -0.0342       0.0469         0.09       0.0654
 [8,] -0.2  0.0032      -0.0165       0.0228         0.04       0.0291
 [9,] -0.1 -0.0002      -0.0045       0.0041         0.01       0.0073
[10,]  0.0 -0.0038      -0.0254       0.0177         0.00       0.0000
[11,]  0.1 -0.0078      -0.0490       0.0334         0.01       0.0073
[12,]  0.2 -0.0123      -0.0735       0.0490         0.04       0.0291
[13,]  0.3 -0.0174      -0.0992       0.0645         0.09       0.0654
[14,]  0.4 -0.0232      -0.1267       0.0803         0.16       0.1163
[15,]  0.5 -0.0301      -0.1572       0.0971         0.25       0.1817
[16,]  0.6 -0.0384      -0.1924       0.1157         0.36       0.2616
[17,]  0.7 -0.0491      -0.2365       0.1383         0.49       0.3561
[18,]  0.8 -0.0645      -0.2998       0.1709         0.64       0.4651
[19,]  0.9 -0.0936      -0.4250       0.2378         0.81       0.5886

Rho at which ACME = 0: -0.1
R^2_M*R^2_Y* at which ACME = 0: 0.01
R^2_M~R^2_Y~ at which ACME = 0: 0.0073

### 1), 2), and 3): no commands
### 4) No correlation of residuals
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.5453204     0.9006176       0
 Alternative hypothesis: rho != 0
> durbinWatsonTest(med.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.7378241     0.5215879       0
 Alternative hypothesis: rho != 0
### 5) Homoscedasticity
> ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 0.170502    Df = 1     p = 0.6796661
### 6) No multicolinearity
> sqrt(vif(out.fit)) > 2
       PK  READ_SF     ROSE     ATPT    NUMPROCS
    FALSE    FALSE    FALSE    FALSE	      FALSE
### 7) No significant outliers: cooks distance
> cd = cooks.distance(out.fit)
> plot(cd, xlim=c(0, 300), ylim=c(0, 0.02), 
main="(CD shouldn't be greater than 1)", 
xlab="Observation Number",
ylab="Cook's Distances (CDs)") 
### see Figure 8.1 (c)
### 8) normality of residuals
> h <- hist(out.fit$res,main="",xlab="Residuals",xlim=c(-1,1),
ylim=c(0,50))
> xfit<-seq(min(out.fit$res),max(out.fit$res),length=40) 
> yfit<-dnorm(xfit,mean=mean(out.fit$res),sd=sd(out.fit$res)) 
> yfit <- yfit*diff(h$mids[1:2])*length(out.fit$res) 
> lines(xfit, yfit, col="blue")
### see Figure 8.1 (d)

###########################################################
##### data preparation #########
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
> expl_u <- subset(expl, expl$UPDATE_SF!=0)
> expl_u <- subset(expl_u, select = -READ_SF)
# normalize the per-DBMS values of ATPT and ThrashingPt in the read group
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
> pgsql_r <- subset(expl_r, expl_r$DBMS=='pgsql')
> pgsql_r$ATPT = (pgsql_r$ATPT-min(pgsql_r$ATPT))/(max(pgsql_r$ATPT)-min(pgsql_r$ATPT))
> pgsql_r$THRASHING_PT = (pgsql_r$THRASHING_PT-min(pgsql_r$THRASHING_PT))/(max(pgsql_r$THRASHING_PT)-min(pgsql_r$THRASHING_PT))
# dbms_z_r
> dbms_z_r <- subset(expl_r, expl_r$DBMS=='dbms_z_r')
> dbms_z_r$ATPT = (dbms_z_r$ATPT-min(dbms_z_r$ATPT))/(max(dbms_z_r$ATPT)-min(dbms_z_r$ATPT))
> dbms_z_r$THRASHING_PT = (dbms_z_r$THRASHING_PT-min(dbms_z_r$THRASHING_PT))/(max(dbms_z_r$THRASHING_PT)-min(dbms_z_r$THRASHING_PT))
#### collect all the DBMSes' thrashing samples in the read group
> all_r = rbind(dbms_z_r,mysql,dbms_z_r,pgsql,dbms_z_r)

# normalize the per-DBMS values of ATPT and ThrashingPt in the update group
# dbms_x_u
> dbms_x_u <- subset(expl_u, expl_u$DBMS=='dbms_x')
> dbms_x_u$ATPT = (dbms_x_u$ATPT-min(dbms_x_u$ATPT))/(max(dbms_x_u$ATPT)-min(dbms_x_u$ATPT))
> dbms_x_u$THRASHING_PT = (dbms_x_u$THRASHING_PT-min(dbms_x_u$THRASHING_PT))/(max(dbms_x_u$THRASHING_PT)-min(dbms_x_u$THRASHING_PT))
# dbms_y_u
> dbms_y_u <- subset(expl_u, expl_u$DBMS=='dbms_y')
> dbms_y_u$ATPT = (dbms_y_u$ATPT-min(dbms_y_u$ATPT))/(max(dbms_y_u$ATPT)-min(dbms_y_u$ATPT))
> dbms_y_u$THRASHING_PT = (dbms_y_u$THRASHING_PT-min(dbms_y_u$THRASHING_PT))/(max(dbms_y_u$THRASHING_PT)-min(dbms_y_u$THRASHING_PT))
# mysql_u
> mysql_u <- subset(expl_u, expl_u$DBMS=='mysql')
> mysql_u$ATPT = (mysql_u$ATPT-min(mysql_u$ATPT))/(max(mysql_u$ATPT)-min(mysql_u$ATPT))
> mysql_u$THRASHING_PT = (mysql_u$THRASHING_PT-min(mysql_u$THRASHING_PT))/(max(mysql_u$THRASHING_PT)-min(mysql_u$THRASHING_PT))
# pgsql_u
> pgsql_u <- subset(expl_u, expl_u$DBMS=='pgsql')
> pgsql_u$ATPT = (pgsql_u$ATPT-min(pgsql_u$ATPT))/(max(pgsql_u$ATPT)-min(pgsql_u$ATPT))
> pgsql_u$THRASHING_PT = (pgsql_u$THRASHING_PT-min(pgsql_u$THRASHING_PT))/(max(pgsql_u$THRASHING_PT)-min(pgsql_u$THRASHING_PT))
# dbms_z_u
> dbms_z_u <- subset(expl_u, expl_u$DBMS=='dbms_z_u')
> dbms_z_u$ATPT = (dbms_z_u$ATPT-min(dbms_z_u$ATPT))/(max(dbms_z_u$ATPT)-min(dbms_z_u$ATPT))
> dbms_z_u$THRASHING_PT = (dbms_z_u$THRASHING_PT-min(dbms_z_u$THRASHING_PT))/(max(dbms_z_u$THRASHING_PT)-min(dbms_z_u$THRASHING_PT))
#### collect all the DBMSes' thrashing samples in the update group
> all_u = rbind(dbms_z_u,mysql,dbms_z_u,pgsql,dbms_z_u)

#######################################
### per-DBMS
#######################################
## db2
db2_r <- subset(x, x$DBMS=='db2')
nrow(db2_r)
[1] 34
db2_r$ATP = (db2_r$ATP-min(db2_r$ATP))/(max(db2_r$ATP)-min(db2_r$ATP))
db2_r$MAXMPL = (db2_r$MAXMPL-min(db2_r$MAXMPL))/(max(db2_r$MAXMPL)-min(db2_r$MAXMPL))
#db2_r <- subset(db2_r, db2_r$MAXMPL < 1)
#[1] 30
out.fit <- lm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCS, data = db2_r)
ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 1.246557    Df = 1     p = 0.2642112
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1        0.141302      1.642439   0.172
 Alternative hypothesis: rho != 0
> durbinWatsonTest(med.fit)
 lag Autocorrelation D-W Statistic p-value
   1      -0.1755529      2.341651   0.582
 Alternative hypothesis: rho != 0
## mysql
mysql_r <- subset(x, x$DBMS=='mysql')
nrow(mysql_r)
[1] 42
mysql_r$ATP = (mysql_r$ATP-min(mysql_r$ATP))/(max(mysql_r$ATP)-min(mysql_r$ATP))
mysql_r$MAXMPL = (mysql_r$MAXMPL-min(mysql_r$MAXMPL))/(max(mysql_r$MAXMPL)-min(mysql_r$MAXMPL))
#mysql_r <- subset(mysql_r, mysql_r$MAXMPL < 1)
out.fit <- lm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCS, data = mysql_r)
ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 21.621    Df = 1     p = 3.321942e-06
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1      0.07745788       1.59418   0.108
 Alternative hypothesis: rho != 0
> durbinWatsonTest(med.fit)
 lag Autocorrelation D-W Statistic p-value
   1        0.131178      1.658913   0.124
 Alternative hypothesis: rho != 0
## oracle
oracle_r <- subset(x, x$DBMS=='oracle')
oracle_r$ATP = (oracle_r$ATP-min(oracle_r$ATP))/(max(oracle_r$ATP)-min(oracle_r$ATP))
oracle_r$MAXMPL = (oracle_r$MAXMPL-min(oracle_r$MAXMPL))/(max(oracle_r$MAXMPL)-min(oracle_r$MAXMPL))
#oracle_r <- subset(oracle_r, oracle_r$MAXMPL < 1)
nrow(oracle_r)
[1] 34
out.fit <- lm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCS, data = oracle_r)
> ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 0.7180687    Df = 1     p = 0.396778
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1      0.01300011      1.919807   0.396
 Alternative hypothesis: rho != 0
> durbinWatsonTest(med.fit)
 lag Autocorrelation D-W Statistic p-value
   1      0.04894103      1.816266   0.226
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
out.fit <- lm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCS, data = pgsql_r)
ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 0.9275016    Df = 1     p = 0.335513
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1        0.621946     0.7558477       0
 Alternative hypothesis: rho != 0
> durbinWatsonTest(med.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.5114203     0.9723888       0
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
out.fit <- lm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCS, data = sqlserver_r)
ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 1.405425    Df = 1     p = 0.2358173
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1       -0.195273      2.277055   0.704
 Alternative hypothesis: rho != 0
> durbinWatsonTest(med.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.4386725      1.066298       0
 Alternative hypothesis: rho != 0
#### gather all the DBMSes' samples
> x_r = rbind(db2_r,mysql_r,oracle_r,pgsql_r,sqlserver_r)
> nrow(x_r)
[1] 188
# x_r <- subset(x_r, x_r$MAXMPL < 1)
> out.fit <- lm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCS, data = x_r)
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
out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCS + PCTREAD + ACTROWPOOL, data = x_r)
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

##############################################################################
### update
##############################################################################
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
x$NUMPROCS = (x$NUMPROCS/min(x$NUMPROCS))/(max(x$NUMPROCS)/min(x$NUMPROCS))
### per-DBMS
# db2
db2_w <- subset(x, x$DBMS=='db2')
> nrow(db2_w)
[1] 14
db2_w$ATP = (db2_w$ATP-min(db2_w$ATP))/(max(db2_w$ATP)-min(db2_w$ATP))
db2_w$MAXMPL = (db2_w$MAXMPL-min(db2_w$MAXMPL))/(max(db2_w$MAXMPL)-min(db2_w$MAXMPL))
out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCS + PCTUPDATE + ACTROWPOOL, data = db2_w)
ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 3.540265    Df = 1     p = 0.0598959
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1      -0.6246547      3.208573    0.07
 Alternative hypothesis: rho != 0
> durbinWatsonTest(med.fit)
 lag Autocorrelation D-W Statistic p-value
   1     -0.07784213      1.729697    0.26
 Alternative hypothesis: rho != 0
# mysql
mysql_w <- subset(x, x$DBMS=='mysql')
nrow(mysql_w)
[1] 31
mysql_w$ATP = (mysql_w$ATP-min(mysql_w$ATP))/(max(mysql_w$ATP)-min(mysql_r$ATP))
mysql_w$MAXMPL = (mysql_w$MAXMPL-min(mysql_w$MAXMPL))/(max(mysql_w$MAXMPL)-min(mysql_w$MAXMPL))
out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCS + PCTUPDATE + ACTROWPOOL, data = mysql_w)
ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 0.005998108    Df = 1     p = 0.9382676
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.2699188      1.387189   0.058
 Alternative hypothesis: rho != 0
> durbinWatsonTest(med.fit)
 lag Autocorrelation D-W Statistic p-value
   1      -0.2250541      2.372172   0.432
 Alternative hypothesis: rho != 0
# oracle
oracle_w <- subset(x, x$DBMS=='oracle')
nrow(oracle_w)
[1] 65
oracle_w$ATP = (oracle_w$ATP-min(oracle_w$ATP))/(max(oracle_w$ATP)-min(oracle_w$ATP))
oracle_w$MAXMPL = (oracle_w$MAXMPL-min(oracle_w$MAXMPL))/(max(oracle_w$MAXMPL)-min(oracle_w$MAXMPL))
out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCS + PCTUPDATE + ACTROWPOOL, data = oracle_w)
> ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 32.61249    Df = 1     p = 1.124893e-08
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1     -0.03717381      2.018206   0.836
 Alternative hypothesis: rho != 0
> durbinWatsonTest(med.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.1097483       1.76787   0.186
 Alternative hypothesis: rho != 0
# pgsql
pgsql_w <- subset(x, x$DBMS=='pgsql')
nrow(pgsql_w)
[1] 75
pgsql_w$ATP = (pgsql_w$ATP-min(pgsql_w$ATP))/(max(pgsql_w$ATP)-min(pgsql_w$ATP))
pgsql_w$MAXMPL = (pgsql_w$MAXMPL-min(pgsql_w$MAXMPL))/(max(pgsql_w$MAXMPL)-min(pgsql_w$MAXMPL))
out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCS + PCTUPDATE + ACTROWPOOL, data = pgsql_w)
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
out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCS + PCTUPDATE + ACTROWPOOL, data = sqlserver_w)
> ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 24.41144    Df = 1     p = 7.780545e-07
> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.2457297      1.508347   0.008
 Alternative hypothesis: rho != 0
> durbinWatsonTest(med.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.9203297     0.1401191       0
 Alternative hypothesis: rho != 0

### collect all the DBMSes' samples
x_w = rbind(db2_w,mysql_w,oracle_w,pgsql_w,sqlserver_w)
> nrow(x_w)
[1] 299
#x_w <- subset(x_w, x_w$MAXMPL < 1)
out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCS + PCTUPDATE + ACTROWPOOL, data = x_w)
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
