### read-only: 188
library(aod)
library(ggplot2)
#x = read.csv(file="ext_expl.dat",head=TRUE,sep="\t")
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
x_r <- subset(x, x$PCTREAD!=0)
x_r <- subset(x_r, select = -PCTUPDATE)
x <- x_r
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD/min(x$PCTREAD))/(max(x$PCTREAD)/min(x$PCTREAD))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
#nrow(x)
#[1] 456
#[1] 396
x <- subset(x, x$ATP < 120000)
#nrow(x)
#nrow(x)
#[1] 997
x <- subset(x, x$MAXMPL < 1100)
#[1] 188
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
#### gother each DBMS' samples
x = rbind(db2,mysql,oracle,pgsql,sqlserver)
#nrow(x)
#[1] 188
x <- subset(x, x$MAXMPL < 1)
#nrow(x)
#[1] 174
> cor.test(x$NUMPROCESSORS, x$ATP)
	##### all  samples: x <- subset(x, x$ATP < 120000) included

		Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -2.6248, df = 388, p-value = 0.009014
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2283910 -0.0332179
	sample estimates:
	       cor 
	-0.1320844 

	#### only thrashing samples
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -0.8856, df = 186, p-value = 0.377
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2060001  0.0790430
	sample estimates:
		cor 
	-0.06480025 

> cor.test(x$ACTROWPOOL, x$ATP)
	
	Pearson's product-moment correlation

	data:  x$ACTROWPOOL and x$ATP
	t = 1.12, df = 388, p-value = 0.2634
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.04277324  0.15519742
	sample estimates:
	       cor 
	0.05677011

> cor.test(x$PCTREAD, x$ATP)

	Pearson's product-moment correlation

data:  x$PCTREAD and x$ATP
t = -0.579, df = 388, p-value = 0.5629
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.12830956  0.07012511
sample estimates:
	cor 
-0.0293817

	Pearson's product-moment correlation

	data:  x$PCTREAD and x$ATP
	t = 0.0416, df = 186, p-value = 0.9668
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1401177  0.1461002
	sample estimates:
		cor 
	0.003053806

> cor.test(x$PK, x$ATP)
	#####  all  samples
	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -8.1082, df = 388, p-value = 6.8e-15
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.4624673 -0.2923959
	sample estimates:
	       cor 
	-0.3806458 

	#### only thrashing samples
	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -5.2071, df = 186, p-value = 5.053e-07
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.4755242 -0.2250657
	sample estimates:
	       cor 
	-0.3566874


med.fit <- lm(ATP ~ PK:PCTREAD + PK + PCTREAD + ACTROWPOOL + NUMPROCESSORS + NUMPROCESSORS:ACTROWPOOL, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ PK:PCTREAD + PK + PCTREAD + ACTROWPOOL + NUMPROCESSORS + 
	    NUMPROCESSORS:ACTROWPOOL, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.54146 -0.21509  0.04979  0.16082  0.78462 

	Coefficients:
		                 Estimate Std. Error t value Pr(>|t|)    
	(Intercept)               0.57902    0.10750   5.386 2.41e-07 ***
	PK                       -0.29916    0.07122  -4.200 4.33e-05 ***
	PCTREAD                   0.01230    0.06527   0.188    0.851    
	ACTROWPOOL               -0.07394    0.14978  -0.494    0.622    
	NUMPROCESSORS            -0.18655    0.18554  -1.005    0.316    
	PK:PCTREAD                0.02919    0.12157   0.240    0.811    
	ACTROWPOOL:NUMPROCESSORS  0.10819    0.28347   0.382    0.703    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3204 on 167 degrees of freedom
	Multiple R-squared:   0.15,	Adjusted R-squared:  0.1194 
	F-statistic: 4.911 on 6 and 167 DF,  p-value: 0.000119

> library(car)
> durbinWatsonTest(med.fit)
 lag Autocorrelation D-W Statistic p-value
   1       0.7445287     0.4932397       0
 Alternative hypothesis: rho != 0

### without filtering out normalized thrashing point = 1
	Call:
	lm(formula = ATP ~ PK:PCTREAD + PK + PCTREAD + ACTROWPOOL + NUMPROCESSORS + 
	    NUMPROCESSORS:ACTROWPOOL, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.5136 -0.2134 -0.0012  0.1673  0.7812 

	Coefficients:
		                  Estimate Std. Error t value Pr(>|t|)    
	(Intercept)               0.486296   0.102009   4.767 3.83e-06 ***
	PK                       -0.272541   0.068194  -3.997 9.34e-05 ***
	PCTREAD                   0.019834   0.064091   0.309    0.757    
	ACTROWPOOL                0.022754   0.143867   0.158    0.875    
	NUMPROCESSORS            -0.067998   0.177441  -0.383    0.702    
	PK:PCTREAD               -0.007637   0.116602  -0.065    0.948    
	ACTROWPOOL:NUMPROCESSORS -0.050501   0.271066  -0.186    0.852    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3231 on 181 degrees of freedom
	Multiple R-squared:  0.1362,	Adjusted R-squared:  0.1076 
	F-statistic: 4.757 on 6 and 181 DF,  p-value: 0.0001585

> cor.test(x$PK, x$MAXMPL)
	#### all samples
	Pearson's product-moment correlation

data:  x$PK and x$MAXMPL
t = 8.6669, df = 388, p-value < 2.2e-16
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 0.3160736 0.4827318
sample estimates:
      cor 
0.4027353 

	#### only thrashing samples
	Pearson's product-moment correlation

data:  x$PK and x$MAXMPL
t = 4.3004, df = 186, p-value = 2.749e-05
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 0.1647033 0.4255223
sample estimates:
      cor 
0.3007252

> cor.test(x$ATP, x$MAXMPL)
	#### all samples
	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -8.1596, df = 388, p-value = 4.734e-15
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.4643597 -0.2945983
	sample estimates:
	       cor 
	-0.3827048 

	#### only thrashing samples
	
> cor.test(x$PCTREAD, x$MAXMPL)
	Pearson's product-moment correlation

data:  x$PCTREAD and x$MAXMPL
t = 0.4452, df = 186, p-value = 0.6567
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.1110048  0.1749173
sample estimates:
       cor 
0.03262371

cor.test(x$NUMPROCESSORS, x$MAXMPL)
	#### all samples
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = 2.5904, df = 388, p-value = 0.009947
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.03149136 0.22675217
	sample estimates:
	      cor 
	0.1303858 

> cor.test(x$ACTROWPOOL, x$MAXMPL)
	Pearson's product-moment correlation

data:  x$ACTROWPOOL and x$MAXMPL
t = -1.8674, df = 186, p-value = 0.06341
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.273462770  0.007596024
sample estimates:
       cor 
-0.1356617

out.fit <- lm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

Call:
lm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, 
    data = x)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.54022 -0.24221 -0.02016  0.23209  0.58479 

Coefficients:
	      Estimate Std. Error t value Pr(>|t|)    
(Intercept)    0.32029    0.07919   4.045 7.97e-05 ***
PK             0.24987    0.05367   4.656 6.53e-06 ***
PCTREAD        0.02265    0.05008   0.452   0.6516    
ACTROWPOOL    -0.16748    0.08072  -2.075   0.0395 *  
ATP            0.12564    0.07040   1.785   0.0761 .  
NUMPROCESSORS  0.03008    0.07034   0.428   0.6695    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.2916 on 168 degrees of freedom
Multiple R-squared:  0.1383,	Adjusted R-squared:  0.1127 
F-statistic: 5.393 on 5 and 168 DF,  p-value: 0.000126

	### all samples
	> summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, 
	    data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.9080 -0.2902  0.1030  0.2006  0.6792 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.59109    0.05849  10.106  < 2e-16 ***
	PK             0.25938    0.03768   6.883 2.34e-11 ***
	PCTREAD       -0.01772    0.04025  -0.440   0.6600    
	ACTROWPOOL    -0.05835    0.06380  -0.915   0.3610    
	ATP           -0.27612    0.06100  -4.527 7.97e-06 ***
	NUMPROCESSORS  0.10762    0.05047   2.132   0.0336 *  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3516 on 390 degrees of freedom
	Multiple R-squared:  0.2232,	Adjusted R-squared:  0.2132 
	F-statistic: 22.41 on 5 and 390 DF,  p-value: < 2.2e-16

## sens. analysis
#med.fit <- lm(ATP ~ PK:PCTREAD + PK + PCTREAD + ACTROWPOOL + NUMPROCESSORS + NUMPROCESSORS:ACTROWPOOL, data = x)
#out.fit <- lm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, data = x)
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
summary(med.out)

Causal Mediation Analysis 

Quasi-Bayesian Confidence Intervals

	       Estimate 95% CI Lower 95% CI Upper p-value
ACME            0.02905      0.00632      0.05465       0
ADE             0.12354      0.03126      0.21488       0
Total Effect    0.15260      0.06459      0.24115       0
Prop. Mediated  0.18564      0.03934      0.48834       0

Sample Size Used: 396 


Simulations: 100

sens.out <-medsens(med.out)
summary(sens.out)

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


pdf("read_sens_procs.pdf")
plot(sens.out, main = "", xlab=expression("Sensitivity Parameter (Correlation Factor of Error Terms):" ~ rho), ylab="Average Mediation Effect with 95% Confidence Intervals", xlim=c(-0.6, 0.6), ylim=c(-0.3, 0.3))
dev.off()

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK", sims=1000)
summary(med.out)
sens.out <- medsens(med.out)

Causal Mediation Analysis 

Quasi-Bayesian Confidence Intervals

	       Estimate 95% CI Lower 95% CI Upper p-value
ACME             0.0710       0.0391       0.1071       0
ADE              0.2653       0.1848       0.3459       0
Total Effect     0.3363       0.2564       0.4150       0
Prop. Mediated   0.2106       0.1148       0.3285       0

Sample Size Used: 396 


Simulations: 1000

Mediation Sensitivity Analysis for Average Causal Mediation Effect

Sensitivity Region

      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
[1,] -0.3 -0.0191      -0.0489       0.0107         0.09       0.0607
[2,] -0.2  0.0136      -0.0161       0.0433         0.04       0.0270

Rho at which ACME = 0: -0.2
R^2_M*R^2_Y* at which ACME = 0: 0.04
R^2_M~R^2_Y~ at which ACME = 0: 0.027


pdf("read_sens_pk.pdf")
plot(sens.out, main = "", xlab=expression("Sensitivity Parameter (Correlation Factor of Error Terms):" ~ rho), ylab="Average Mediation Effect with 95% Confidence Intervals", xlim=c(-0.6, 0.6), ylim=c(-0.3, 0.3))
dev.off()
#main = "Sensitiviy Analysis with Respect to \n Error Correlation between the Mediator (ATP time) and Outcome Models (Thrashing Point)", 

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTREAD")
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

### mediation analysis
	### All samples
	med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
	summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            -0.0731      -0.1164      -0.0357       0
	ADE              0.2288       0.1088       0.3416       0
	Total Effect     0.1557       0.0387       0.2734       0
	Prop. Mediated  -0.4672      -2.2310      -0.1824       0

	Sample Size Used: 539 


	Simulations: 1000

	med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK")
	summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.01966     -0.03680     -0.00562       0
	ADE             0.18059      0.10812      0.24707       0
	Total Effect    0.16094      0.09091      0.22839       0
	Prop. Mediated -0.11942     -0.31358     -0.03067       0

	Sample Size Used: 539 


	Simulations: 1000

	### thrashing samples
	med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
	summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            0.03788     -0.00804      0.09185    0.11
	ADE             0.15094      0.04905      0.25511    0.00
	Total Effect    0.18882      0.08253      0.30328    0.00
	Prop. Mediated  0.19346     -0.05123      0.53041    0.11

	Sample Size Used: 148 


	Simulations: 1000 

	med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK")
	summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            0.14507      0.08590      0.21045    0.00
	ADE            -0.06445     -0.16478      0.03074    0.17
	Total Effect    0.08062      0.00147      0.15603    0.04
	Prop. Mediated  1.74345      0.65599     15.26999    0.04

	Sample Size Used: 148 


	Simulations: 1000

	med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTREAD")
	summary(med.out)

> library(lavaan)
> model <- '
+    # regressions
+      ATP ~ PK*PCTREAD + PK + PCTREAD + ACTROWPOOL + NUMPROCESSORS + NUMPROCESSORS*ACTROWPOOL
+      MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS
+ '
> fit <- sem(model,
+            data=x)
> summary(fit)

lavaan (0.5-17) converged normally after  20 iterations

  Number of observations                           188

  Estimator                                         ML
  Minimum Function Test Statistic                0.000
  Degrees of freedom                                 0
  Minimum Function Value               0.0000000000000

Parameter estimates:

  Information                                 Expected
  Standard Errors                             Standard

                   Estimate  Std.err  Z-value  P(>|z|)
Regressions:
  ATP ~
    PCTREA   (PK)     0.018    0.053    0.340    0.734
    PK               -0.275    0.051   -5.355    0.000
    ACTROW (NUMP)     0.001    0.084    0.016    0.987
    NUMPRO           -0.098    0.073   -1.350    0.177
  MAXMPL ~
    PK                0.232    0.056    4.148    0.000
    PCTREA            0.018    0.053    0.338    0.735
    ATP               0.016    0.074    0.211    0.833
    ACTROW           -0.172    0.086   -2.008    0.045
    NUMPRO            0.009    0.074    0.127    0.899

Variances:
    ATP               0.101    0.010
    MAXMPL            0.104    0.011

### assumption testing #####
library(car)
out.fit <- lm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, data = x)
#out.fit <- lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
#outlierTest(out.fit)
#pdf("new_normales_qqplot.pdf")
qqnorm(out.fit$res,main="",ylim=c(-0.8,0.6)); qqline(out.fit$res);
pdf("read_normal_res.pdf")
h <- hist(out.fit$res,main="",xlab="Residuals",ylim=c(0,60),xlim=c(-1,1))
xfit<-seq(min(out.fit$res),max(out.fit$res),length=40) 
yfit<-dnorm(xfit,mean=mean(out.fit$res),sd=sd(out.fit$res)) 
yfit <- yfit*diff(h$mids[1:2])*length(out.fit$res) 
lines(xfit, yfit, col="blue")
dev.off()

pdf("read_cd.pdf")
cd = cooks.distance(out.fit)
plot(cd, xlim=c(0, 200), ylim=c(0, 0.04), main="(CD shouldn't be greater than 1)", ylab="Cook's Distances (CDs)", xlab="Observation Number")
dev.off()

# Evaluate Collinearity
> sqrt(vif(out.fit)) > 2
           PK       PCTREAD    ACTROWPOOL           ATP NUMPROCESSORS 
        FALSE         FALSE         FALSE         FALSE         FALSE

# Evaluate Nonlinearity
# component + residual plot 
pdf("linearity_assumption_testesult.pdf")
crPlots(out.fit, main = "",)
dev.off()

# Test for Autocorrelated Errors
durbinWatsonTest(out.fit)
	 lag Autocorrelation D-W Statistic p-value
	   1       0.2091418      1.561056   0.006
	 Alternative hypothesis: rho != 0

#### per-DBMS #####
18.87 (0.01)\% for DBMS X, 
27.54\% for MySQL, 
13.92 (6.96)\% for DBMS Y, 
3.34\% for PostgreSQL, and 
48.71\% for DBMS Z.

#### thrashing or not thrashing
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
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
#396
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS + PCTREAD + ACTROWPOOL, family=binomial("probit"), data = x)
summary(out.fit)

	Call:
	glm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS + PCTREAD + ACTROWPOOL, 
	    family = binomial("probit"), data = x)

	Deviance Residuals: 
	    Min       1Q   Median       3Q      Max  
	-2.0800  -0.8573  -0.5805   0.9597   1.9385  

	Coefficients:
		      Estimate Std. Error z value Pr(>|z|)    
	(Intercept)    0.19564    0.22027   0.888   0.3744    
	PK            -0.74569    0.14073  -5.299 1.17e-07 ***
	ATP            1.12018    0.23277   4.812 1.49e-06 ***
	NUMPROCESSORS -0.48107    0.19314  -2.491   0.0127 *  
	PCTREAD        0.12640    0.15384   0.822   0.4113    
	ACTROWPOOL     0.01485    0.24409   0.061   0.9515    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	(Dispersion parameter for binomial family taken to be 1)

	    Null deviance: 547.96  on 395  degrees of freedom
	Residual deviance: 462.20  on 390  degrees of freedom
	AIC: 474.2

	Number of Fisher Scoring iterations: 4

wald.test(b = coef(out.fit), Sigma = vcov(out.fit), Terms = 2:6)
Wald test:
----------

Chi-squared test:
X2 = 77.1, df = 5, P(> X2) = 3.4e-15

> 1-out.fit$deviance/out.fit$null.deviance
[1] 0.1565035

#### per-DBMS logistic #####
db2 <- subset(x, x$DBMS=='db2')
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS + PCTREAD + ACTROWPOOL,  data = db2)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.1141671
mysql <- subset(x, x$DBMS=='mysql')
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS + PCTREAD + ACTROWPOOL, data = mysql)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.8173146
pgsql <- subset(x, x$DBMS=='pgsql')
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS + PCTREAD + ACTROWPOOL, data = pgsql)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.3978489
oracle <- subset(x, x$DBMS=='oracle')
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS + PCTREAD + ACTROWPOOL, data = oracle)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.1041428
sqlserver <- subset(x, x$DBMS=='sqlserver')
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS + PCTREAD + ACTROWPOOL, data = sqlserver)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.6227892

### update-only: 199
library(aod)
library(ggplot2)
#x = read.csv(file="ext_expl.dat",head=TRUE,sep="\t")
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
x <- subset(x, x$ATP < 120000)
x_w <- subset(x, x$PCTUPDATE!=0)
x_w <- subset(x_w, select = -PCTREAD)
x <- x_w
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTUPDATE = (x$PCTUPDATE/min(x$PCTUPDATE))/(max(x$PCTUPDATE)/min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
nrow(x)
#[1] 686
# [1] 607
x <- subset(x, x$MAXMPL < 1100)
#x$MAXMPL[x$MAXMPL == 1100] <- 10000
#nrow(x)
#[1] 328
#[1] 299
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
#x <- subset(x, x$MAXMPL < 1 & x$MAXMPL > 0)
x <- subset(x, x$MAXMPL < 1)
#nrow(x)
#[1] 328
#[1] 260

cor.test(x$NUMPROCESSORS, x$ATP)
	#####  all samples 
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -4.9089, df = 605, p-value = 1.18e-06
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2710744 -0.1179715
	sample estimates:
	       cor 
	-0.1957153
	
	#####  thrashing samples 
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -6.1616, df = 297, p-value = 2.34e-09
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.4335366 -0.2320949
	sample estimates:
	       cor 
	-0.3366621

cor.test(x$PCTUPDATE, x$ATP)
	Pearson's product-moment correlation

data:  x$PCTUPDATE and x$ATP
t = -0.1649, df = 297, p-value = 0.8691
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.1228678  0.1039723
sample estimates:
         cor 
-0.009570916

cor.test(x$PK, x$ATP)
	#####  all samples 
	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -0.2085, df = 605, p-value = 0.8349
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.08799708  0.07115388
	sample estimates:
		 cor 
	-0.008475272 

	#####  thrashing samples
	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = 3.0517, df = 297, p-value = 0.002481
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.06216438 0.28221381
	sample estimates:
	      cor 
	0.1743652

#####  thrashing samples 
med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + PK + PCTUPDATE + PCTUPDATE:PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + 
	    PK + PCTUPDATE + PCTUPDATE:PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.44572 -0.23773 -0.06927  0.17636  0.81572 

	Coefficients:
		                   Estimate Std. Error t value Pr(>|t|)  
	(Intercept)               0.2608179  0.1079845   2.415   0.0164 *
	NUMPROCESSORS            -0.2845868  0.1484092  -1.918   0.0563 .
	ACTROWPOOL                0.1071328  0.1235238   0.867   0.3866  
	PK                        0.1278712  0.0945363   1.353   0.1774  
	PCTUPDATE                 0.0342841  0.0979067   0.350   0.7265  
	NUMPROCESSORS:ACTROWPOOL -0.0457667  0.2105161  -0.217   0.8281  
	PK:PCTUPDATE             -0.0001347  0.1378434  -0.001   0.9992  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3123 on 253 degrees of freedom
	Multiple R-squared:  0.1306,	Adjusted R-squared:  0.1099 
	F-statistic: 6.332 on 6 and 253 DF,  p-value: 3.196e-06

cor.test(x$PK, x$MAXMPL)
	#####  thrashing samples 
	Pearson's product-moment correlation

data:  x$PK and x$MAXMPL
t = 1.3001, df = 297, p-value = 0.1946
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.03853075  0.18706245
sample estimates:
       cor 
0.07522836

cor.test(x$ATP, x$MAXMPL)
	#####  all samples 
	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = 4.1441, df = 684, p-value = 3.84e-05
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.08261228 0.22867686
	sample estimates:
	      cor 
	0.1565001

	#####  thrashing samples 
	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = 0.4922, df = 258, p-value = 0.623
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.09136592  0.15171654
	sample estimates:
	       cor 
	0.03062817

	#### modified
	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -2.6127, df = 297, p-value = 0.5405
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.14836295  -0.07821498
	sample estimates:
		cor 
	-0.11328896

cor.test(x$NUMPROCESSORS, x$MAXMPL)
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = -4.5481, df = 684, p-value = 6.402e-06
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.24306870 -0.09772814
	sample estimates:
	       cor 
	-0.1713304

	#####  thrashing samples 
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = -6.5744, df = 258, p-value = 2.694e-10
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.4784073 -0.2695684
	sample estimates:
	       cor 
	-0.3787997

> cor.test(x$PCTUPDATE, x$MAXMPL)
	Pearson's product-moment correlation

data:  x$PCTUPDATE and x$MAXMPL
t = -0.2518, df = 297, p-value = 0.8014
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.12782858  0.09898426
sample estimates:
       cor 
-0.0146101

cor.test(x$ACTROWPOOL, x$MAXMPL)
	Pearson's product-moment correlation

data:  x$ACTROWPOOL and x$MAXMPL
t = -1.2802, df = 297, p-value = 0.2015
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.18595077  0.03968073
sample estimates:
        cor 
-0.07408304 


	### thrashing samples
out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS + PCTUPDATE + ACTROWPOOL, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS + PCTUPDATE + 
	    ACTROWPOOL, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.6219 -0.2520  0.1127  0.2814  0.7071 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.73033    0.07957   9.178  < 2e-16 ***
	PK             0.06562    0.04166   1.575   0.1165    
	ATP           -0.11129    0.06575  -1.693   0.0917 .  
	NUMPROCESSORS -0.44805    0.06511  -6.881 4.61e-11 ***
	PCTUPDATE     -0.06207    0.07207  -0.861   0.3900    
	ACTROWPOOL    -0.06147    0.07252  -0.848   0.3974    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3267 on 254 degrees of freedom
	Multiple R-squared:  0.1642,	Adjusted R-squared:  0.1478 
	F-statistic: 9.982 on 5 and 254 DF,  p-value: 9.837e-09

library(lavaan)
model <- '
    # regressions
      ATP ~ PK*PCTUPDATE + PK + PCTUPDATE + ACTROWPOOL + NUMPROCESSORS + NUMPROCESSORS*ACTROWPOOL
      MAXMPL ~ PK + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS
 '
fit <- sem(model,
            data=x)
summary(fit)


library(lavaan)
model <- '
    # regressions
      ATP ~ PK*PCTUPDATE + PK + PCTUPDATE + ACTROWPOOL + NUMPROCESSORS + NUMPROCESSORS*ACTROWPOOL
      MAXMPL ~ PK + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS
 '
fit <- sem(model,
            data=x)
summary(fit)
lavaan (0.5-17) converged normally after  22 iterations

  Number of observations                           260

  Estimator                                         ML
  Minimum Function Test Statistic                0.000
  Degrees of freedom                                 0

Parameter estimates:

  Information                                 Expected
  Standard Errors                             Standard

                   Estimate  Std.err  Z-value  P(>|z|)
Regressions:
  ATP ~
    PCTUPD   (PK)     0.034    0.068    0.503    0.615
    PK                0.128    0.038    3.326    0.001
    ACTROW (NUMP)     0.085    0.068    1.245    0.213
    NUMPRO           -0.314    0.058   -5.394    0.000
  MAXMPL ~
    PK                0.066    0.041    1.594    0.111
    PCTUPD           -0.062    0.071   -0.871    0.384
    ACTROW           -0.061    0.072   -0.858    0.391
    ATP              -0.111    0.065   -1.713    0.087
    NUMPRO           -0.448    0.064   -6.962    0.000

Variances:
    ATP               0.095    0.008
    MAXMPL            0.104    0.009

### mediation analysis
library(mediation)
med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + PK + PCTUPDATE + PCTUPDATE:PK, data = x)
out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS + PCTUPDATE + ACTROWPOOL, data = x)
summary(out.fit)

	### thrashing samples
	med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS", sims=100)
	summary(med.out)
	
	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            0.04072      0.00369      0.08325    0.04
	ADE            -0.45962     -0.59140     -0.33967    0.00
	Total Effect   -0.41890     -0.55133     -0.30253    0.00
	Prop. Mediated -0.10173     -0.23249     -0.00871    0.04

	Sample Size Used: 260 


	Simulations: 100

	sens.out <- medsens(med.out)
	summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.2 -0.0304      -0.0721       0.0112         0.04       0.0294
	[2,] -0.1  0.0037      -0.0365       0.0439         0.01       0.0074
	[3,]  0.0  0.0369      -0.0055       0.0792         0.00       0.0000

	Rho at which ACME = 0: -0.1
	R^2_M*R^2_Y* at which ACME = 0: 0.01
	R^2_M~R^2_Y~ at which ACME = 0: 0.0074

pdf("update_sens_procs.pdf")
plot(sens.out, main = "", xlab=expression("Sensitivity Parameter (Correlation Factor of Error Terms):" ~ rho), ylab="Average Mediation Effect with 95% Confidence Intervals", xlim=c(-0.6, 0.6), ylim=c(-0.3, 0.3))
dev.off()
#main = "Sensitiviy Analysis with Respect to \n Error Correlation between the Mediator (ATP time) and Outcome Models (Thrashing Point)", 

	med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK")
	summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.01471     -0.04001      0.00109    0.09
	ADE             0.06808     -0.01194      0.14839    0.09
	Total Effect    0.05337     -0.02824      0.13223    0.18
	Prop. Mediated -0.20640     -2.54565      2.00415    0.24

	Sample Size Used: 260 


	Simulations: 1000

	sens.out <- medsens(med.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.2  0.0123      -0.0055       0.0301         0.04       0.0294
	[2,] -0.1 -0.0015      -0.0178       0.0148         0.01       0.0074
	[3,]  0.0 -0.0149      -0.0334       0.0036         0.00       0.0000

	Rho at which ACME = 0: -0.1
	R^2_M*R^2_Y* at which ACME = 0: 0.01
	R^2_M~R^2_Y~ at which ACME = 0: 0.0074

pdf("update_sens_pk.pdf")
plot(sens.out, main = "", xlab=expression("Sensitivity Parameter (Correlation Factor of Error Terms):" ~ rho), ylab="Average Mediation Effect with 95% Confidence Intervals", xlim=c(-0.6, 0.6), ylim=c(-0.3, 0.3))
dev.off()

	med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE")
	summary(med.out)

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

### assumption testing #####
library(car)
outlierTest(out.fit)
#dev.off()
pdf("update_normal_res.pdf")
h <- hist(out.fit$res,main="",xlab="Residuals",ylim=c(0,50),xlim=c(-1,1))
xfit<-seq(min(out.fit$res),max(out.fit$res),length=40) 
yfit<-dnorm(xfit,mean=mean(out.fit$res),sd=sd(out.fit$res)) 
yfit <- yfit*diff(h$mids[1:2])*length(out.fit$res) 
lines(xfit, yfit, col="blue")
dev.off()

pdf("update_cd.pdf")
cd = cooks.distance(out.fit)
plot(cd, xlim=c(0, 300), ylim=c(0, 0.02), main="(CD shouldn't be greater than 1)", ylab="Cook's Distances (CDs)", xlab="Observeration Number")
dev.off()

> ncvTest(out.fit)
### without doing x <- subset(x, x$MAXMPL < 1)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 0.170502    Df = 1     p = 0.6796661

# Evaluate Collinearity
vif(out.fit) # variance inflation factors 
          ATP NUMPROCESSORS 
     1.039537      1.03953 

> sqrt(vif(out.fit)) > 2
           PK           ATP NUMPROCESSORS     PCTUPDATE    ACTROWPOOL 
        FALSE         FALSE         FALSE         FALSE         FALSE 

# Evaluate Nonlinearity
# component + residual plot 
pdf("linearity_assumption_testesult.pdf")
crPlots(out.fit, main = "",)
dev.off()

# Test for Autocorrelated Errors
durbinWatsonTest(out.fit)
	 lag Autocorrelation D-W Statistic p-value
	   1       0.5453204     0.9006176       0
	 Alternative hypothesis: rho != 0

#### per-DBMS #####
17.13 (0.0048)\% for DBMS X, 
27.54 % for MySQL, 
31.38 % for DBMS Y, 
20.93 % for PostgreSQL, and 
14.87 % for DBMS Z.

#### thrashing or not thrashing
library(aod)
library(ggplot2)
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
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
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS + PCTUPDATE + ACTROWPOOL, data=x)
summary(out.fit)

	Call:
	glm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS + PCTUPDATE + ACTROWPOOL, data = x)

	Deviance Residuals: 
	    Min       1Q   Median       3Q      Max  
	-0.6455  -0.4885  -0.3378   0.4836   0.7034  

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.37424    0.07673   4.878 1.38e-06 ***
	PK             0.02366    0.04036   0.586   0.5579    
	ATP           -0.17132    0.06817  -2.513   0.0122 *  
	NUMPROCESSORS  0.09595    0.06105   1.572   0.1166    
	PCTUPDATE      0.06717    0.07243   0.927   0.3541    
	ACTROWPOOL     0.10828    0.07200   1.504   0.1331    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	(Dispersion parameter for gaussian family taken to be 0.2469617)

	    Null deviance: 151.72  on 606  degrees of freedom
	Residual deviance: 148.42  on 601  degrees of freedom
	AIC: 881.66

	Number of Fisher Scoring iterations: 2

wald.test(b = coef(out.fit), Sigma = vcov(out.fit), Terms = 2:6)
Wald test:
----------

Chi-squared test:
X2 = 13.3, df = 5, P(> X2) = 0.02

> 1-out.fit$deviance/out.fit$null.deviance
[1] 0.02170278

###################
db2 <- subset(x, x$DBMS=='db2')
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS + PCTUPDATE + ACTROWPOOL, data = db2)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.04808188
mysql <- subset(x, x$DBMS=='mysql')
mysql$NUMPROCESSORS = (mysql$NUMPROCESSORS/min(mysql$NUMPROCESSORS))/(max(mysql$NUMPROCESSORS)/min(mysql$NUMPROCESSORS))
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS + PCTUPDATE + ACTROWPOOL, data = mysql)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.3819565
pgsql <- subset(x, x$DBMS=='pgsql')
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS + PCTUPDATE + ACTROWPOOL, data = pgsql)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.4612748
oracle <- subset(x, x$DBMS=='oracle')
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS + PCTUPDATE + ACTROWPOOL, data = oracle)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.6534092
sqlserver <- subset(x, x$DBMS=='sqlserver')
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS + PCTUPDATE + ACTROWPOOL, data = sqlserver)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.352153
