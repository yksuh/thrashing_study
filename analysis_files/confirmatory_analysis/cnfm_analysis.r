# Overall: 33.4% (close to suboptimal)
library(aod)
library(ggplot2)
x = read.csv(file="cnfm.dat",head=TRUE,sep="\t")
#x = read.csv(file="new_cnfm.dat",head=TRUE,sep="\t")
x_r <- subset(x, x$PCTREAD!=0)
x_r <- subset(x_r, select = -PCTUPDATE)
x <- x_r
nrow(x)
#[1] 539
#[1] 577
x <- subset(x, x$ATP < 120000)
#[1] 526
x <- subset(x, x$MAXMPL < 1100)
#nrow(x)
#[1] 148
#[1] 165 (17 added)
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
# nrow(x)
#[1] 148
#[1] 165
#x <- subset(x, x$MAXMPL < 1)
#[1] 129
#[1] 144
> cor.test(x$NUMPROCESSORS, x$ATP)
	##### all  samples
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -7.7878, df = 575, p-value = 3.196e-14
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.3809128 -0.2331446
	sample estimates:
	       cor 
	-0.3088916

	#### only thrashing samples
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -0.2919, df = 163, p-value = 0.7708
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1750279  0.1303834
	sample estimates:
	       cor 
	-0.0228555

> cor.test(x$PK, x$ATP)
	#####  all  samples
	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -2.7015, df = 575, p-value = 0.007107
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.19182326 -0.03060521
	sample estimates:
	       cor 
	-0.1119508

	#### only thrashing samples
	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -8.2911, df = 163, p-value = 3.966e-14
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.6438489 -0.4274249
	sample estimates:
	       cor 
	-0.5446415	

med.fit <- lm(ATP ~ NUMPROCESSORS + PK, data = x)
summary(med.fit)

	#### all samples
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.4901 -0.2804 -0.0914  0.2233  0.7878 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.52998    0.02910  18.210  < 2e-16 ***
	NUMPROCESSORS -0.31780    0.03961  -8.024 5.81e-15 ***
	PK            -0.08599    0.02617  -3.286  0.00108 ** 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3137 on 574 degrees of freedom
	Multiple R-squared:  0.1121,	Adjusted R-squared:  0.109 
	F-statistic: 36.24 on 2 and 574 DF,  p-value: 1.508e-15

	#### only thrashing samples
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.57586 -0.22414 -0.04841  0.29734  0.87392 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.55680    0.05325  10.456  < 2e-16 ***
	NUMPROCESSORS  0.04464    0.08440   0.529    0.598    
	PK            -0.44188    0.05934  -7.446 1.33e-11 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3192 on 126 degrees of freedom
	Multiple R-squared:  0.3057,	Adjusted R-squared:  0.2947 
	F-statistic: 27.74 on 2 and 126 DF,  p-value: 1.038e-10

		### extended set
		Call:
		lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

		Residuals:
		     Min       1Q   Median       3Q      Max 
		-0.58674 -0.15144 -0.04582  0.26084  0.83475 

		Coefficients:
			      Estimate Std. Error t value Pr(>|t|)    
		(Intercept)    0.60529    0.04573  13.237  < 2e-16 ***
		NUMPROCESSORS -0.05410    0.07037  -0.769    0.443    
		PK            -0.42652    0.05154  -8.275 8.76e-14 ***
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.2915 on 141 degrees of freedom
		Multiple R-squared:  0.328,	Adjusted R-squared:  0.3184 
		F-statistic: 34.41 on 2 and 141 DF,  p-value: 6.768e-13

> cor.test(x$PK, x$MAXMPL)
	#### all samples
	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 4.5697, df = 575, p-value = 5.982e-06
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.1072132 0.2647796
	sample estimates:
	      cor 
	0.1872002 

	#### only thrashing samples
	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 1.0584, df = 163, p-value = 0.2915
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.07106626  0.23246373
	sample estimates:
	       cor 
	0.08261433

> cor.test(x$ATP, x$MAXMPL)
	#### all samples
	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = 0.5676, df = 575, p-value = 0.5705
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.05807406  0.10508575
	sample estimates:
	       cor 
	0.02366342

	#### only thrashing samples
	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -2.3798, df = 163, p-value = 0.01848
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.32687864 -0.03134058
	sample estimates:
	       cor 
	-0.183246

cor.test(x$NUMPROCESSORS, x$MAXMPL)
	#### all samples
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = 3.8929, df = 575, p-value = 0.0001106
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.07966572 0.23875132
	sample estimates:
	     cor 
	0.160249

	#### only thrashing samples
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = 4.0556, df = 163, p-value = 7.733e-05
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.1572427 0.4353969
	sample estimates:
	      cor 
	0.3027529

	#### all samples
out.fit <- lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.8851 -0.1530  0.1204  0.2238  0.3949 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.57870    0.03798  15.236  < 2e-16 ***
	PK             0.14260    0.02744   5.196 2.83e-07 ***
	ATP            0.11288    0.04337   2.603  0.00948 ** 
	NUMPROCESSORS  0.21089    0.04340   4.859 1.52e-06 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.326 on 573 degrees of freedom
	Multiple R-squared:  0.07517,	Adjusted R-squared:  0.07033 
	F-statistic: 15.53 on 3 and 573 DF,  p-value: 1.011e-09

			out.fit <- lm(MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, data = x)
			summary(out.fit)

			Call:
			lm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, 
			    data = x)

			Residuals:
			    Min      1Q  Median      3Q     Max 
			-0.8931 -0.1376  0.1216  0.2246  0.4438 

			Coefficients:
				      Estimate Std. Error t value Pr(>|t|)    
			(Intercept)    0.63028    0.04975  12.669  < 2e-16 ***
			PK             0.14288    0.02741   5.213 2.60e-07 ***
			PCTREAD       -0.04850    0.03115  -1.557   0.1201    
			ACTROWPOOL    -0.05200    0.04735  -1.098   0.2726    
			ATP            0.10865    0.04363   2.490   0.0131 *  
			NUMPROCESSORS  0.21112    0.04334   4.872 1.44e-06 ***
			---
			Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

			Residual standard error: 0.3255 on 571 degrees of freedom
			Multiple R-squared:  0.08103,	Adjusted R-squared:  0.07299 
			F-statistic: 10.07 on 5 and 571 DF,  p-value: 2.974e-09

	#### only thrashing samples
	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.57415 -0.19994 -0.09816  0.28344  0.60993 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.27559    0.06680   4.125 6.70e-05 ***
	PK            -0.06380    0.06536  -0.976   0.3309    
	ATP           -0.17305    0.08177  -2.116   0.0363 *  
	NUMPROCESSORS  0.36515    0.07756   4.708 6.53e-06 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.293 on 125 degrees of freedom
	Multiple R-squared:  0.172,	Adjusted R-squared:  0.1521 
	F-statistic: 8.653 on 3 and 125 DF,  p-value: 2.913e-05

		### extended set
		Call:
		lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

		Residuals:
		    Min      1Q  Median      3Q     Max 
		-0.6210 -0.2271 -0.0564  0.2595  0.6202 

		Coefficients:
			      Estimate Std. Error t value Pr(>|t|)    
		(Intercept)    0.27288    0.06501   4.198 4.77e-05 ***
		PK            -0.06038    0.05964  -1.012    0.313    
		ATP           -0.08696    0.07995  -1.088    0.279    
		NUMPROCESSORS  0.34810    0.06694   5.200 6.93e-07 ***
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.2767 on 140 degrees of freedom
		Multiple R-squared:  0.1737,	Adjusted R-squared:  0.156 
		F-statistic:  9.81 on 3 and 140 DF,  p-value: 6.465e-06

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
x = read.csv(file="cnfm.dat",head=TRUE,sep="\t")
#x = read.csv(file="extcnfm.dat",head=TRUE,sep="\t")
#x = read.csv(file="new_cnfm.dat",head=TRUE,sep="\t")
#x$MAXMPL[x$MAXMPL == 1100] <- 10000
x_w <- subset(x, x$PCTUPDATE!=0)
x_w <- subset(x_w, select = -PCTREAD)
x <- x_w
nrow(x)
#[1] 800
#[1] 860
x <- subset(x, x$ATP < 120000)
#nrow(x)
#[1] 761
x <- subset(x, x$MAXMPL < 1100)
#nrow(x)
#[1] 334
#[1] 333
#[1] 369: 35 added
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
x <- subset(x, x$MAXMPL < 1)
#nrow(x)
#[1] 290
#[1] 321
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
		-0.53284 -0.36932  0.04707  0.31019  0.69231 

		Coefficients:
			      Estimate Std. Error t value Pr(>|t|)    
		(Intercept)    0.69610    0.04351  15.998  < 2e-16 ***
		PK            -0.14351    0.03827  -3.750 0.000209 ***
		NUMPROCESSORS -0.32654    0.06001  -5.442 1.03e-07 ***
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.3465 on 330 degrees of freedom
		Multiple R-squared:  0.1225,	Adjusted R-squared:  0.1171 
		F-statistic: 23.02 on 2 and 330 DF,  p-value: 4.361e-10
	
	## extended
	Call:
	lm(formula = ATP ~ NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.54942 -0.31938 -0.07154  0.33320  0.71462 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.60159    0.03623  16.603  < 2e-16 ***
	NUMPROCESSORS -0.31621    0.05545  -5.703 2.43e-08 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3515 on 367 degrees of freedom
	Multiple R-squared:  0.0814,	Adjusted R-squared:  0.0789 
	F-statistic: 32.52 on 1 and 367 DF,  p-value: 2.428e-08

		Call:
		lm(formula = ATP ~ PK + NUMPROCESSORS, data = x)

		Residuals:
		     Min       1Q   Median       3Q      Max 
		-0.53651 -0.36989 -0.01976  0.30752  0.70747 

		Coefficients:
			      Estimate Std. Error t value Pr(>|t|)    
		(Intercept)    0.69424    0.04063  17.085  < 2e-16 ***
		PK            -0.16511    0.03593  -4.596 5.95e-06 ***
		NUMPROCESSORS -0.31545    0.05399  -5.843 1.13e-08 ***
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.3423 on 366 degrees of freedom
		Multiple R-squared:  0.1315,	Adjusted R-squared:  0.1268 
		F-statistic: 27.71 on 2 and 366 DF,  p-value: 6.213e-12

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
	-0.51309 -0.22895 -0.05133  0.18175  0.61878 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.59802    0.04014  14.897  < 2e-16 ***
	ATP           -0.12790    0.04391  -2.913  0.00386 ** 
	NUMPROCESSORS -0.36867    0.05183  -7.113 9.11e-12 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2632 on 286 degrees of freedom
	Multiple R-squared:  0.1581,	Adjusted R-squared:  0.1522 
	F-statistic: 26.86 on 2 and 286 DF,  p-value: 2.042e-11

		## extended set
		Call:
		lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

		Residuals:
		     Min       1Q   Median       3Q      Max 
		-0.58591 -0.30342 -0.05403  0.29877  0.73826 

		Coefficients:
			      Estimate Std. Error t value Pr(>|t|)    
		(Intercept)    0.61910    0.04691  13.198  < 2e-16 ***
		ATP           -0.15511    0.05107  -3.037  0.00256 ** 
		NUMPROCESSORS -0.23444    0.05660  -4.142 4.27e-05 ***
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.3439 on 366 degrees of freedom
		Multiple R-squared:  0.05404,	Adjusted R-squared:  0.04887 
		F-statistic: 10.45 on 2 and 366 DF,  p-value: 3.847e-05

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
