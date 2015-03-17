# Overall: 33.4% (close to suboptimal)
library(aod)
library(ggplot2)
#x = read.csv(file="ext_cnfm.dat",head=TRUE,sep="\t")
x = read.csv(file="cnfm.dat",head=TRUE,sep="\t")
x_r <- subset(x, x$PCTREAD!=0)
x_r <- subset(x_r, select = -PCTUPDATE)
x <- x_r
nrow(x)
#[1] 599
[1] 539
#x <- subset(x, x$MAXMPL < 1100)
#nrow(x)
#[1] 174
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
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD/min(x$PCTREAD))/(max(x$PCTREAD)/min(x$PCTREAD))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
x <- subset(x, x$MAXMPL < 1)
#x <- subset(x, x$MAXMPL > 0)
nrow(x)
> cor.test(x$NUMPROCESSORS, x$ATP)
	##### all  samples
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -7.6998, df = 537, p-value = 6.595e-14
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.3894070 -0.2371818
	sample estimates:
	       cor 
	-0.3153213

	#### only thrashing samples
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -2.9731, df = 172, p-value = 0.003371
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.35808176 -0.07477954
	sample estimates:
	       cor 
	-0.2210898 

> cor.test(x$PK, x$ATP)
	#####  all  samples
	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -2.8926, df = 537, p-value = 0.003976
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.20616283 -0.03982433
	sample estimates:
	       cor 
	-0.1238636 

	#### only thrashing samples
	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -7.2182, df = 172, p-value = 1.62e-11
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.5887149 -0.3591700
	sample estimates:
	       cor 
	-0.4821754

med.fit <- lm(ATP ~ NUMPROCESSORS + PK, data = x)
summary(med.fit)

	#### all samples
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.4653 -0.2800 -0.1065  0.2249  0.7920 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.54367    0.03087  17.610  < 2e-16 ***
	NUMPROCESSORS -0.33564    0.04256  -7.886 1.76e-14 ***
	PK            -0.09126    0.02739  -3.332  0.00092 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3175 on 536 degrees of freedom
	Multiple R-squared:  0.1177,	Adjusted R-squared:  0.1144 
	F-statistic: 35.75 on 2 and 536 DF,  p-value: 2.655e-15

	#### only thrashing samples
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.55398 -0.22739 -0.05854  0.30701  0.87981 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.53014    0.05023  10.553  < 2e-16 ***
	NUMPROCESSORS  0.03928    0.07790   0.504    0.615    
	PK            -0.41977    0.05348  -7.849 8.47e-13 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3144 on 145 degrees of freedom
	Multiple R-squared:  0.2989,	Adjusted R-squared:  0.2892 
	F-statistic:  30.9 on 2 and 145 DF,  p-value: 6.614e-12

> cor.test(x$PK, x$MAXMPL)
	#### all samples
	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 4.2294, df = 597, p-value = 2.711e-05
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.09170472 0.24729505
	sample estimates:
	      cor 
	0.1705629

	#### only thrashing samples
	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 1.6159, df = 172, p-value = 0.108
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.02697483  0.26621253
	sample estimates:
	      cor 
	0.1222857

> cor.test(x$ATP, x$MAXMPL)
	#### all samples
	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = 0.083, df = 597, p-value = 0.9339
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.07673408  0.08348650
	sample estimates:
		cor 
	0.003398018

	#### only thrashing samples
	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -6.4993, df = 172, p-value = 8.402e-10
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.5560691 -0.3161468
	sample estimates:
	       cor 
	-0.4440324

cor.test(x$NUMPROCESSORS, x$MAXMPL)
	#### all samples
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = 4.5642, df = 597, p-value = 6.091e-06
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.1050571 0.2599107
	sample estimates:
	      cor 
	0.1836229

	#### only thrashing samples
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = 4.1763, df = 172, p-value = 4.702e-05
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.1619658 0.4326637
	sample estimates:
	      cor 
	0.3034244

	#### all samples
out.fit <- lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.93445 -0.08725  0.11796  0.21873  0.38219 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.57947    0.04019  14.417  < 2e-16 ***
	PK             0.14811    0.02867   5.166 3.38e-07 ***
	ATP            0.12048    0.04476   2.692  0.00733 ** 
	NUMPROCESSORS  0.20571    0.04659   4.415 1.22e-05 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.329 on 535 degrees of freedom
	Multiple R-squared:  0.07502,	Adjusted R-squared:  0.06983 
	F-statistic: 14.46 on 3 and 535 DF,  p-value: 4.511e-09

			out.fit <- lm(MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, data = x)
			summary(out.fit)

			Call:
			lm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, 
			    data = x)

			Residuals:
			     Min       1Q   Median       3Q      Max 
			-0.90972 -0.09568  0.11540  0.22866  0.41670 

			Coefficients:
				      Estimate Std. Error t value Pr(>|t|)    
			(Intercept)    0.60460    0.05173  11.688  < 2e-16 ***
			PK             0.14838    0.02867   5.176 3.21e-07 ***
			PCTREAD       -0.04777    0.03260  -1.466   0.1434    
			ACTROWPOOL    -0.01127    0.05064  -0.223   0.8240    
			ATP            0.11410    0.04513   2.529   0.0117 *  
			NUMPROCESSORS  0.20626    0.04659   4.427 1.16e-05 ***
			---
			Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

			Residual standard error: 0.329 on 533 degrees of freedom
			Multiple R-squared:  0.07882,	Adjusted R-squared:  0.07018 
			F-statistic: 9.121 on 5 and 533 DF,  p-value: 2.448e-08

	#### only thrashing samples
	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.44614 -0.12569 -0.07426  0.16481  0.75426 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.33961    0.04729   7.181 2.06e-11 ***
	PK            -0.04274    0.03960  -1.079  0.28196    
	ATP           -0.46324    0.08325  -5.564 1.01e-07 ***
	NUMPROCESSORS  0.15366    0.05215   2.946  0.00367 ** 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2204 on 170 degrees of freedom
	Multiple R-squared:  0.2466,	Adjusted R-squared:  0.2333 
	F-statistic: 18.55 on 3 and 170 DF,  p-value: 1.857e-10

### mediation analysis
library(mediation)
med.fit <- lm(ATP ~ NUMPROCESSORS + PK, data = x)
out.fit <- lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	### All samples
	med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
	summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            -0.0401      -0.0739      -0.0104    0.01
	ADE              0.2044       0.1147       0.2907    0.00
	Total Effect     0.1643       0.0812       0.2484    0.00
	Prop. Mediated  -0.2402      -0.6569      -0.0604    0.01

	Sample Size Used: 539 


	Simulations: 1000

	sens.out <-medsens(med.out)
	summary(sens.out)

pdf("read_sens_procs.pdf")
plot(sens.out, main = "", xlab=expression("Sensitivity Parameter (Correlation Factor of Error Terms):" ~ rho), ylab="Average Mediation Effect with 95% Confidence Intervals", xlim=c(-0.6, 0.6), ylim=c(-0.3, 0.3))
dev.off()


	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	     Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] 0.1 -0.0055      -0.0349       0.0239         0.01       0.0082

	Rho at which ACME = 0: 0.1
	R^2_M*R^2_Y* at which ACME = 0: 0.01
	R^2_M~R^2_Y~ at which ACME = 0: 0.0082

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

pdf("update_read_sens_pk.pdf")
plot(sens.out, main = "", xlab=expression("Sensitivity Parameter (Correlation Factor of Error Terms):" ~ rho), ylab="Average Mediation Effect with 95% Confidence Intervals", xlim=c(-0.6, 0.6), ylim=c(-0.3, 0.3))
dev.off()

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

### assumption testing #####
library(car)
out.fit <- lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
outlierTest(out.fit)
#pdf("new_normales_qqplot.pdf")
qqnorm(out.fit$res,main="",ylim=c(-0.8,0.6)); qqline(out.fit$res);
#dev.off()
#pdf("read_normal_res.pdf")
pdf("new_read_normal_res.pdf")
#h <- hist(out.fit$res,main="",xlab="Residuals",ylim=c(0,50),xlim=c(-0.6,0.6))
h <- hist(out.fit$res,main="",xlab="Residuals",ylim=c(0,50),xlim=c(-0.6,0.6))
xfit<-seq(min(out.fit$res),max(out.fit$res),length=40) 
yfit<-dnorm(xfit,mean=mean(out.fit$res),sd=sd(out.fit$res)) 
yfit <- yfit*diff(h$mids[1:2])*length(out.fit$res) 
lines(xfit, yfit, col="blue")
dev.off()

pdf("read_cd.pdf")
cd = cooks.distance(out.fit)
plot(cd, ylim=c(0, 0.08), main="(CD shouldn't be greater than 1)", ylab="Cook's Distances (CDs)", xlab="Observeration Number")
dev.off()

ncvTest(out.fit)

	Non-constant Variance Score Test 
	Variance formula: ~ fitted.values 
	Chisquare = 2.859574    Df = 1     p = 0.008315594 

# Evaluate Collinearity
vif(out.fit) # variance inflation factors 
           PK           ATP NUMPROCESSORS 
     1.519995      1.535991      1.014853

> sqrt(vif(out.fit)) > 2
           PK           ATP NUMPROCESSORS 
        FALSE         FALSE         FALSE

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
x = read.csv(file="ext_cnfm.dat",head=TRUE,sep="\t")
x$MAXMPL[x$MAXMPL < 1100] <- 1
x$MAXMPL[x$MAXMPL == 1100] <- 0 ### thrashing
x_r <- subset(x, x$PCTREAD!=0)
x_r <- subset(x_r, select = -PCTUPDATE)
x <- x_r
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD/min(x$PCTREAD))/(max(x$PCTREAD)/min(x$PCTREAD))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
nrow(x)
599
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
#out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS + PCTREAD + ACTROWPOOL, family=binomial("probit"), data = x)
summary(out.fit)

Call:
glm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

Deviance Residuals: 
    Min       1Q   Median       3Q      Max  
-0.4580  -0.3069  -0.2304   0.5676   0.8697  

Coefficients:
                Estimate Std. Error t value Pr(>|t|)    
(Intercept)    4.830e-01  4.591e-02  10.520  < 2e-16 ***
PK            -1.510e-01  3.669e-02  -4.116  4.4e-05 ***
ATP           -4.682e-07  5.121e-07  -0.914 0.360912    
NUMPROCESSORS -2.000e-01  5.707e-02  -3.505 0.000491 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

(Dispersion parameter for gaussian family taken to be 0.1982194)

    Null deviance: 123.46  on 598  degrees of freedom
Residual deviance: 117.94  on 595  degrees of freedom
AIC: 736.47

Number of Fisher Scoring iterations: 2

wald.test(b = coef(out.fit), Sigma = vcov(out.fit), Terms = 2:4)
Wald test:
----------

Chi-squared test:
X2 = 27.8, df = 3, P(> X2) = 4e-06

> 1-out.fit$deviance/out.fit$null.deviance
[1] 0.0446734

#### per-DBMS logistic #####
db2 <- subset(x, x$DBMS=='db2')
db2$ATP = (db2$ATP-min(db2$ATP))/(max(db2$ATP)-min(db2$ATP))
db2$NUMPROCESSORS = (db2$NUMPROCESSORS/min(db2$NUMPROCESSORS))/(max(db2$NUMPROCESSORS)/min(db2$NUMPROCESSORS))
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS,  data = db2)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.1443036
mysql <- subset(x, x$DBMS=='mysql')
mysql$ATP = (mysql$ATP-min(mysql$ATP))/(max(mysql$ATP)-min(mysql$ATP))
mysql$NUMPROCESSORS = (mysql$NUMPROCESSORS/min(mysql$NUMPROCESSORS))/(max(mysql$NUMPROCESSORS)/min(mysql$NUMPROCESSORS))
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = mysql)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.593266
pgsql <- subset(x, x$DBMS=='pgsql')
pgsql$ATP = (pgsql$ATP-min(pgsql$ATP))/(max(pgsql$ATP)-min(pgsql$ATP))
pgsql$NUMPROCESSORS = (pgsql$NUMPROCESSORS/min(pgsql$NUMPROCESSORS))/(max(pgsql$NUMPROCESSORS)/min(pgsql$NUMPROCESSORS))
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = pgsql)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.05590754
oracle <- subset(x, x$DBMS=='oracle')
oracle$ATP = (oracle$ATP-min(oracle$ATP))/(max(oracle$ATP)-min(oracle$ATP))
oracle$NUMPROCESSORS = (oracle$NUMPROCESSORS/min(oracle$NUMPROCESSORS))/(max(oracle$NUMPROCESSORS)/min(oracle$NUMPROCESSORS))
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = oracle)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.1346947
sqlserver <- subset(x, x$DBMS=='sqlserver')
sqlserver$ATP = (sqlserver$ATP-min(sqlserver$ATP))/(max(sqlserver$ATP)-min(sqlserver$ATP))
sqlserver$NUMPROCESSORS = (sqlserver$NUMPROCESSORS/min(sqlserver$NUMPROCESSORS))/(max(sqlserver$NUMPROCESSORS)/min(sqlserver$NUMPROCESSORS))
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = sqlserver)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.4065833

### update-only
library(aod)
library(ggplot2)
#x = read.csv(file="ext_cnfm.dat",head=TRUE,sep="\t")
x = read.csv(file="cnfm.dat",head=TRUE,sep="\t")
#x$MAXMPL[x$MAXMPL == 1100] <- 10000
x_w <- subset(x, x$PCTUPDATE!=0)
x_w <- subset(x_w, select = -PCTREAD)
x <- x_w
nrow(x)
#[1] 879
#[1] 800
x <- subset(x, x$MAXMPL < 1100)
#nrow(x)
#[1] 334
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
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTUPDATE = (x$PCTUPDATE/min(x$PCTUPDATE))/(max(x$PCTUPDATE)/min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
#x <- subset(x, x$MAXMPL < 1)
#nrow(x)
#[1] 363

cor.test(x$NUMPROCESSORS, x$ATP)
	#####  all samples 
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -4.4186, df = 798, p-value = 1.131e-05
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.22147849 -0.08614531
	sample estimates:
	       cor 
	-0.1545367
	
	#####  thrashing samples 
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -5.6087, df = 332, p-value = 4.299e-08
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	-0.3892193 -0.1929706
	sample estimates:
	cor 
	-0.2941928

cor.test(x$PK, x$ATP)
	#####  all samples 
	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -5.9804, df = 798, p-value = 3.357e-09
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2725157 -0.1398067
	sample estimates:
	       cor 
	-0.2071138

	#####  thrashing samples
	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -3.6988, df = 332, p-value = 0.0002534
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.29985564 -0.09362722
	sample estimates:
	       cor 
	-0.1989429 

med.fit <- lm(ATP ~ NUMPROCESSORS, data = x)
summary(med.fit)
	#####  thrashing samples 
	Call:
	lm(formula = ATP ~ NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.53745 -0.32605 -0.01386  0.32881  0.71923 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.62342    0.03973  15.690  < 2e-16 ***
	NUMPROCESSORS -0.34264    0.06109  -5.609  4.3e-08 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3535 on 332 degrees of freedom
	Multiple R-squared:  0.08655,	Adjusted R-squared:  0.0838 
	F-statistic: 31.46 on 1 and 332 DF,  p-value: 4.299e-08

		med.fit <- lm(ATP ~ PK + NUMPROCESSORS, data = x)
		summary(med.fit)
		
		Call:
		lm(formula = ATP ~ PK + NUMPROCESSORS, data = x)

		Residuals:
		     Min       1Q   Median       3Q      Max 
		-0.52692 -0.36134  0.03229  0.31237  0.69157 

		Coefficients:
			      Estimate Std. Error t value Pr(>|t|)    
		(Intercept)    0.69224    0.04362  15.868  < 2e-16 ***
		PK            -0.13582    0.03834  -3.543 0.000453 ***
		NUMPROCESSORS -0.33065    0.06015  -5.497 7.73e-08 ***
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.3475 on 331 degrees of freedom
		Multiple R-squared:  0.1199,	Adjusted R-squared:  0.1146 
		F-statistic: 22.55 on 2 and 331 DF,  p-value: 6.582e-10

cor.test(x$PK, x$MAXMPL)
	#####  thrashing samples 
	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = -2.8036, df = 361, p-value = 0.005327
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.24522393 -0.04369858
	sample estimates:
	       cor 
	-0.1459753

cor.test(x$ATP, x$MAXMPL)
	#####  thrashing samples 
	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -3.7583, df = 361, p-value = 0.0001994
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.29116504 -0.09297114
	sample estimates:
	       cor 
	-0.1940474

cor.test(x$NUMPROCESSORS, x$MAXMPL)
	#####  thrashing samples 
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = -3.5718, df = 361, p-value = 0.0004026
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.28231564 -0.08340393
	sample estimates:
	       cor 
	-0.1847511

out.fit <- lm(MAXMPL ~ ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	### thrashing samples
	Call:
	lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.51345 -0.22493 -0.05196  0.18227  0.61979 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.59891    0.03999  14.975  < 2e-16 ***
	ATP           -0.12918    0.04356  -2.966  0.00328 ** 
	NUMPROCESSORS -0.36976    0.05171  -7.151 7.17e-12 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2628 on 287 degrees of freedom
	Multiple R-squared:  0.1595,	Adjusted R-squared:  0.1537 
	F-statistic: 27.24 on 2 and 287 DF,  p-value: 1.473e-11

### mediation analysis
library(mediation)
med.fit <- lm(ATP ~ NUMPROCESSORS, data = x)
out.fit <- lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	### thrashing samples
	med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
	summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME             0.0664       0.0264       0.1120    0.00
	ADE             -0.2290      -0.3480      -0.1102    0.00
	Total Effect    -0.1625      -0.2796      -0.0409    0.01
	Prop. Mediated  -0.4042      -1.8881      -0.1222    0.01

	Sample Size Used: 334 


	Simulations: 1000 

pdf("update_sens_procs.pdf")
plot(sens.out, main = "", xlab=expression("Sensitivity Parameter (Correlation Factor of Error Terms):" ~ rho), ylab="Average Mediation Effect with 95% Confidence Intervals", xlim=c(-0.6, 0.6), ylim=c(-0.3, 0.3))
dev.off()

### assumption testing #####
library(car)
out.fit <- lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)
outlierTest(out.fit)
#dev.off()
pdf("update_non_normal_res.pdf")
#h <- hist(out.fit$res,main="",xlab="Residuals",ylim=c(0,35),xlim=c(-0.06,0.06))
h <- hist(out.fit$res,main="",xlab="Residuals",ylim=c(0,70),xlim=c(-0.06,0.06))
xfit<-seq(min(out.fit$res),max(out.fit$res),length=40) 
yfit<-dnorm(xfit,mean=mean(out.fit$res),sd=sd(out.fit$res)) 
yfit <- yfit*diff(h$mids[1:2])*length(out.fit$res) 
lines(xfit, yfit, col="blue")
dev.off()

pdf("update_cd.pdf")
cd = cooks.distance(out.fit)
plot(cd, xlim=c(0, 350), ylim=c(0, 0.03), main="(CD shouldn't be greater than 1)", ylab="Cook's Distances (CDs)", xlab="Observeration Number")
dev.off()

ncvTest(out.fit)

	Non-constant Variance Score Test 
	Variance formula: ~ fitted.values 
	Chisquare = 0.2330649    Df = 1     p = 0.6292605

# Evaluate Collinearity
vif(out.fit) # variance inflation factors 
          ATP NUMPROCESSORS 
     1.039537      1.03953 

sqrt(vif(out.fit)) > 2 # problem?
          ATP NUMPROCESSORS 
     1.019577      1.01957

# Evaluate Nonlinearity
# component + residual plot 
pdf("linearity_assumption_testesult.pdf")
crPlots(out.fit, main = "",)
dev.off()

# Test for Autocorrelated Errors
durbinWatsonTest(out.fit)
	 lag Autocorrelation D-W Statistic p-value
	   1       0.1900665       0.9446755   0.012
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
x = read.csv(file="cnfm.dat",head=TRUE,sep="\t")
x$MAXMPL[x$MAXMPL < 1100] <- 1 ### thrashing
x$MAXMPL[x$MAXMPL == 1100] <- 0
x_w <- subset(x, x$PCTUPDATE!=0)
x_w <- subset(x_w, select = -PCTREAD)
x <- x_w
nrow(x)
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTUPDATE = (x$PCTUPDATE/min(x$PCTUPDATE))/(max(x$PCTUPDATE)/min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
out.fit <-  glm(MAXMPL ~ ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	glm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	Deviance Residuals: 
	    Min       1Q   Median       3Q      Max  
	-0.5157  -0.4158  -0.3506   0.5538   0.7222  

	Coefficients:
		        Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    3.555e-01  4.012e-02   8.862   <2e-16 ***
	ATP           -4.932e-07  3.652e-07  -1.351   0.1772    
	NUMPROCESSORS  1.602e-01  5.534e-02   2.895   0.0039 ** 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	(Dispersion parameter for gaussian family taken to be 0.2403861)

	    Null deviance: 194.56  on 799  degrees of freedom
	Residual deviance: 191.59  on 797  degrees of freedom
	AIC: 1134.9

	Number of Fisher Scoring iterations: 2

wald.test(b = coef(out.fit), Sigma = vcov(out.fit), Terms = 2:3)
Wald test:
----------

Chi-squared test:
X2 = 12.3, df = 2, P(> X2) = 0.0021

> 1-out.fit$deviance/out.fit$null.deviance
[1] 0.0152516

###################
db2 <- subset(x, x$DBMS=='db2')
db2$ATP = (db2$ATP-min(db2$ATP))/(max(db2$ATP)-min(db2$ATP))
db2$NUMPROCESSORS = (db2$NUMPROCESSORS/min(db2$NUMPROCESSORS))/(max(db2$NUMPROCESSORS)/min(db2$NUMPROCESSORS))
out.fit <-  glm(MAXMPL ~ ATP + NUMPROCESSORS, data = db2)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.1514176
mysql <- subset(x, x$DBMS=='mysql')
mysql$ATP = (mysql$ATP-min(mysql$ATP))/(max(mysql$ATP)-min(mysql$ATP))
mysql$NUMPROCESSORS = (mysql$NUMPROCESSORS/min(mysql$NUMPROCESSORS))/(max(mysql$NUMPROCESSORS)/min(mysql$NUMPROCESSORS))
out.fit <-  glm(MAXMPL ~ ATP + NUMPROCESSORS, data = mysql)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.06971828
pgsql <- subset(x, x$DBMS=='pgsql')
pgsql$ATP = (pgsql$ATP-min(pgsql$ATP))/(max(pgsql$ATP)-min(pgsql$ATP))
pgsql$NUMPROCESSORS = (pgsql$NUMPROCESSORS/min(pgsql$NUMPROCESSORS))/(max(pgsql$NUMPROCESSORS)/min(pgsql$NUMPROCESSORS))
out.fit <-  glm(MAXMPL ~ ATP + NUMPROCESSORS, data = pgsql)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.07866522
oracle <- subset(x, x$DBMS=='oracle')
oracle$ATP = (oracle$ATP-min(oracle$ATP))/(max(oracle$ATP)-min(oracle$ATP))
oracle$NUMPROCESSORS = (oracle$NUMPROCESSORS/min(oracle$NUMPROCESSORS))/(max(oracle$NUMPROCESSORS)/min(oracle$NUMPROCESSORS))
out.fit <-  glm(MAXMPL ~ ATP + NUMPROCESSORS, data = oracle)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.4548632
sqlserver <- subset(x, x$DBMS=='sqlserver')
sqlserver$ATP = (sqlserver$ATP-min(sqlserver$ATP))/(max(sqlserver$ATP)-min(sqlserver$ATP))
sqlserver$NUMPROCESSORS = (sqlserver$NUMPROCESSORS/min(sqlserver$NUMPROCESSORS))/(max(sqlserver$NUMPROCESSORS)/min(sqlserver$NUMPROCESSORS))
out.fit <-  glm(MAXMPL ~ ATP + NUMPROCESSORS, data = sqlserver)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.657579
