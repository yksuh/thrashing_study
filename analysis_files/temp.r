> y = read.csv(file="expl.dat",head=TRUE,sep="\t")
> thrashing <- subset(y, y$MAXMPL < 1100)
> nrow(thrashing)
[1] 538
> nrow(y)
[1] 1004
> thrashing <- subset(y, y$MAXMPL < 500)
> nrow(thrashing)
[1] 283

== ATP 

>>> ACTROWPOOL, NUMPROCESSORS on ATP
med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + ACTROWPOOL:NUMPROCESSORS, data = x)
summary(med.fit)

Call:
lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + ACTROWPOOL:NUMPROCESSORS, 
    data = x)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.11428 -0.06306 -0.04167 -0.02280  0.93030 

Coefficients:
                         Estimate Std. Error t value Pr(>|t|)
(Intercept)               0.02639    0.02483   1.063    0.289
NUMPROCESSORS             0.02688    0.04581   0.587    0.558
ACTROWPOOL                0.03110    0.03970   0.783    0.434
NUMPROCESSORS:ACTROWPOOL  0.03192    0.07351   0.434    0.665

Residual standard error: 0.1511 on 195 degrees of freedom
Multiple R-squared:  0.02403,	Adjusted R-squared:  0.009012 
F-statistic:   1.6 on 3 and 195 DF,  p-value: 0.1907

----
out.fit <- lm(MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS, data = x)
summary(out.fit)

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
summary(med.out)

Causal Mediation Analysis 

Quasi-Bayesian Confidence Intervals

               Estimate 95% CI Lower 95% CI Upper p-value
ACME           -0.00621     -0.02985      0.01159     0.5
ADE            -0.48017     -0.62839     -0.33292     0.0
Total Effect   -0.48638     -0.63272     -0.33638     0.0
Prop. Mediated  0.00885     -0.02410      0.06174     0.5

Sample Size Used: 199 


Simulations: 1000 

>>> PK, PCTREAD

med.fit <- lm(ATP ~ PK + PCTREAD + PK:PCTREAD, data = x)
summary(med.fit)

Call:
lm(formula = ATP ~ PK + PCTREAD + PK:PCTREAD, data = x)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.26872 -0.06922 -0.00479  0.00555  0.90574 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  0.07489    0.01445   5.181 5.49e-07 ***
PK          -0.06771    0.02023  -3.348 0.000978 ***
PCTREAD      0.25117    0.03932   6.388 1.20e-09 ***
PK:PCTREAD  -0.25234    0.05468  -4.615 7.13e-06 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.1306 on 195 degrees of freedom
Multiple R-squared:  0.2718,	Adjusted R-squared:  0.2606 
F-statistic: 24.26 on 3 and 195 DF,  p-value: 2.188e-13





>>> PK, PCTUPDATE

med.fit <- lm(ATP ~ PK + PCTUPDATE + PK:PCTUPDATE, data = x)
summary(med.fit)

Call:
lm(formula = ATP ~ PK + PCTUPDATE + PK:PCTUPDATE, data = x)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.20412 -0.00823 -0.00321  0.00721  0.76821 

Coefficients:
               Estimate Std. Error t value Pr(>|t|)    
(Intercept)   0.2317927  0.0176559  13.128   <2e-16 ***
PK           -0.2258263  0.0244602  -9.232   <2e-16 ***
PCTUPDATE    -0.0029867  0.0003195  -9.349   <2e-16 ***
PK:PCTUPDATE  0.0030136  0.0004487   6.716    2e-10 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.1193 on 195 degrees of freedom
Multiple R-squared:  0.392,	Adjusted R-squared:  0.3826 
F-statistic:  41.9 on 3 and 195 DF,  p-value: < 2.2e-16

>>> ACTROWPOOL, MAXMPL

med.fit <- lm(MAXMPL ~ ACTROWPOOL, data = x)
summary(med.fit)

Call:
lm(formula = MAXMPL ~ ACTROWPOOL, data = x)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.55396 -0.45396 -0.04132  0.45025  0.45868 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  0.53711    0.07644   7.027 3.37e-11 ***
ACTROWPOOL   0.01686    0.11092   0.152    0.879    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.4346 on 197 degrees of freedom
Multiple R-squared:  0.0001172,	Adjusted R-squared:  -0.004958 
F-statistic: 0.02309 on 1 and 197 DF,  p-value: 0.8794

>>> ATP, MAXMPL

med.fit <- lm(MAXMPL ~ ATP, data = x)
summary(med.fit)

Call:
lm(formula = MAXMPL ~ ATP, data = x)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.56383 -0.46212  0.03604  0.43678  0.63952 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  0.56396    0.03284   17.17   <2e-16 ***
ATP         -0.27947    0.20246   -1.38    0.169    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.4326 on 197 degrees of freedom
Multiple R-squared:  0.009579,	Adjusted R-squared:  0.004552 
F-statistic: 1.905 on 1 and 197 DF,  p-value: 0.169

>>> NUMPROCESSORS, MAXMPL

med.fit <- lm(MAXMPL ~ NUMPROCESSORS, data = x)
summary(med.fit)

Call:
lm(formula = MAXMPL ~ NUMPROCESSORS, data = x)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.72668 -0.31844 -0.02668  0.34274  0.75921 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept)    0.79609    0.04575  17.403  < 2e-16 ***
NUMPROCESSORS -0.06941    0.01017  -6.823 1.07e-10 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.3909 on 197 degrees of freedom
Multiple R-squared:  0.1912,	Adjusted R-squared:  0.187 
F-statistic: 46.56 on 1 and 197 DF,  p-value: 1.07e-10

>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

>> NUMPROCESSORS indirect effect moderated by ACTROWPOOL on MPL Capability

med.fit <- lm(ATP ~ NUMPROCESSORS+ACTROWPOOL+NUMPROCESSORS:ACTROWPOOL, data = x)
summary(med.fit)


>> PCTREAD indirect effect moderated by PK on MPL Capability
 
 med.fit <- lm(ATP ~ PK+PK:PCTREAD, data = x)
 out.fit <- lm(MAXMPL ~ ATP + PCTREAD, data = x)
 med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTREAD")
 test.modmed(med.out, covariates.1 = list (x$PK == 1), covariates.2 = list (x$PK == 0), data = x)

	Test of ACME(covariates.1) - ACME(covariates.2) = 0

data:  estimates from med.out
ACME(covariates.1) - ACME(covariates.2) = -1e-04, p-value = 0.996
alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
95 percent confidence interval:
 -0.02493842  0.02501824


	Test of ADE(covariates.1) - ADE(covariates.2) = 0

data:  estimates from med.out
ADE(covariates.1) - ADE(covariates.2) = 1e-04, p-value = 0.97
alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
95 percent confidence interval:
 -0.2613786  0.2480701

>> PCTUPDATE indirect effect moderated by PK on MPL Capability

 med.fit <- lm(ATP ~ PK+PK:PCTUPDATE, data = x)
 out.fit <- lm(MAXMPL ~ ATP + PCTUPDATE, data = x)
 med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE")
 test.modmed(med.out, covariates.1 = list (x$PK == 1), covariates.2 = list (x$PK == 0), data = x)

	Test of ACME(covariates.1) - ACME(covariates.2) = 0

data:  estimates from med.out
ACME(covariates.1) - ACME(covariates.2) = -3e-04, p-value = 0.994
alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
95 percent confidence interval:
 -0.03378959  0.03045150


	Test of ADE(covariates.1) - ADE(covariates.2) = 0

data:  estimates from med.out
ADE(covariates.1) - ADE(covariates.2) = 3e-04, p-value = 0.992
alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
95 percent confidence interval:
 -0.2300186  0.2347182







med.fit <- lm(ATP ~ NUMPROCESSORS+ACTROWPOOL+NUMPROCESSORS:ACTROWPOOL+PK+PCTUPDATE+PK:PCTUPDATE+PCTREAD+PK:PCTREAD, data = x)
summary(med.fit)
out.fit <- lm(MAXMPL ~ ATP + PK + PCTREAD + PCTUPDATE + ACTROWPOOL + NUMPROCESSORS, data = x)
summary(out.fit)
#http://thestatsgeek.com/2014/02/08/r-squared-in-logistic-regression/
1-out.fit$deviance/out.fit$null.deviance
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
summary(med.out)






out.fit <- glm(MAXMPL ~ ATP + PK + PK*PCTUPDATE, data = x)

med.pk <- mediate(med.fit, out.fit, treat = "PCTUPDATE", mediator = "ATP", data = x)




> med.fit <- lm(MAXMPL ~ ACTROWPOOL, data = x)
> summary(med.fit)

Call:
lm(formula = MAXMPL ~ ACTROWPOOL, data = x)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.55396 -0.45396 -0.04132  0.45025  0.45868 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  0.53711    0.07644   7.027 3.37e-11 ***
ACTROWPOOL   0.01686    0.11092   0.152    0.879    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.4346 on 197 degrees of freedom
Multiple R-squared:  0.0001172,	Adjusted R-squared:  -0.004958 
F-statistic: 0.02309 on 1 and 197 DF,  p-value: 0.879


> med.fit <- lm(MAXMPL ~ NUMPROCESSORS, data = x)
> summary(med.fit)

Call:
lm(formula = MAXMPL ~ NUMPROCESSORS, data = x)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.72668 -0.31844 -0.02668  0.34274  0.75921 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept)    0.79609    0.04575  17.403  < 2e-16 ***
NUMPROCESSORS -0.06941    0.01017  -6.823 1.07e-10 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.3909 on 197 degrees of freedom
Multiple R-squared:  0.1912,	Adjusted R-squared:  0.187 
F-statistic: 46.56 on 1 and 197 DF,  p-value: 1.07e-10

> med.fit <- lm(MAXMPL ~ PK, data = x)
> summary(med.fit)

Call:
lm(formula = MAXMPL ~ PK, data = x)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.56275 -0.46275 -0.03196  0.43725  0.46804 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  0.53196    0.04410   12.06   <2e-16 ***
PK           0.03079    0.06160    0.50    0.618    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.4344 on 197 degrees of freedom
Multiple R-squared:  0.001266,	Adjusted R-squared:  -0.003804 
F-statistic: 0.2498 on 1 and 197 DF,  p-value: 0.6178

> med.fit <- lm(MAXMPL ~ PCTREAD, data = x)
> summary(med.fit)

Call:
lm(formula = MAXMPL ~ PCTREAD, data = x)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.61664 -0.44013 -0.03568  0.46391  0.46432 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  0.53568    0.03359  15.947   <2e-16 ***
PCTREAD      0.08096    0.09079   0.892    0.374    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.4338 on 197 degrees of freedom
Multiple R-squared:  0.00402,	Adjusted R-squared:  -0.001036 
F-statistic: 0.7951 on 1 and 197 DF,  p-value: 0.3736

> med.fit <- lm(MAXMPL ~ PCTUPDATE, data = x)
> summary(med.fit)

Call:
lm(formula = MAXMPL ~ PCTUPDATE, data = x)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.63405 -0.41455  0.02082  0.39339  0.58545 

Coefficients:
             Estimate Std. Error t value Pr(>|t|)    
(Intercept)  0.634052   0.043694  14.511  < 2e-16 ***
PCTUPDATE   -0.002195   0.000802  -2.737  0.00677 ** 
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.4266 on 197 degrees of freedom
Multiple R-squared:  0.03663,	Adjusted R-squared:  0.03174 
F-statistic: 7.491 on 1 and 197 DF,  p-value: 0.0067

> med.fit <- lm(MAXMPL ~ ATP, data = x)
> summary(med.fit)

Call:
lm(formula = MAXMPL ~ ATP, data = x)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.56383 -0.46212  0.03604  0.43678  0.63952 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  0.56396    0.03284   17.17   <2e-16 ***
ATP         -0.27947    0.20246   -1.38    0.169    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.4326 on 197 degrees of freedom
Multiple R-squared:  0.009579,	Adjusted R-squared:  0.004552 
F-statistic: 1.905 on 1 and 197 DF,  p-value: 0.169


> med.fit <- lm(ATP ~ NUMPROCESSORS+ACTROWPOOL+NUMPROCESSORS:ACTROWPOOL, data = x)
> summary(med.fit)

Call:
lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL, 
    data = x)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.11428 -0.06306 -0.04167 -0.02280  0.93030 

Coefficients:
                         Estimate Std. Error t value Pr(>|t|)
(Intercept)              0.013707   0.043436   0.316    0.753
NUMPROCESSORS            0.002320   0.009575   0.242    0.809
ACTROWPOOL               0.035381   0.063351   0.558    0.577
NUMPROCESSORS:ACTROWPOOL 0.006081   0.014002   0.434    0.665

Residual standard error: 0.1511 on 195 degrees of freedom
Multiple R-squared:  0.02403,	Adjusted R-squared:  0.009012 
F-statistic:   1.6 on 3 and 195 DF,  p-value: 0.1907

> out.fit <- glm(MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS, data = x)
> summary(out.fit)

Call:
glm(formula = MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS, data = x)

Deviance Residuals: 
    Min       1Q   Median       3Q      Max  
-0.7267  -0.2828  -0.0296   0.3263   0.8457  

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept)    0.78554    0.07806  10.064  < 2e-16 ***
ATP           -0.14894    0.18574  -0.802    0.424    
ACTROWPOOL     0.02526    0.10066   0.251    0.802    
NUMPROCESSORS -0.06850    0.01027  -6.670 2.58e-10 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

(Dispersion parameter for gaussian family taken to be 0.1538421)

    Null deviance: 37.216  on 198  degrees of freedom
Residual deviance: 29.999  on 195  degrees of freedom
AIC: 198.2

Number of Fisher Scoring iterations: 2

> #http://thestatsgeek.com/2014/02/08/r-squared-in-logistic-regression/
> 1-out.fit$deviance/out.fit$null.deviance
[1] 0.1939266

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
> summary(med.out)

Causal Mediation Analysis 

Quasi-Bayesian Confidence Intervals

                Estimate 95% CI Lower 95% CI Upper p-value
ACME           -0.000861    -0.004212     0.001815    0.52
ADE            -0.068436    -0.087879    -0.048169    0.00
Total Effect   -0.069297    -0.088816    -0.048666    0.00
Prop. Mediated  0.008858    -0.027194     0.063065    0.52

Sample Size Used: 199 


Simulations: 1000 

