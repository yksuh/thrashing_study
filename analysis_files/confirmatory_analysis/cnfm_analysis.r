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
#x <- subset(x, x$MAXMPL < 1)
#[1] 129
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

#### only thrashing samples
out.fit <- lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
summary(out.fit)
	
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
x = read.csv(file="cnfm.dat",head=TRUE,sep="\t")
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
#539
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS, family=binomial("probit"), data = x)
summary(out.fit)

	Call:
	glm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, family = binomial("probit"), 
	    data = x)

	Deviance Residuals: 
	    Min       1Q   Median       3Q      Max  
	-1.2646  -0.8628  -0.5858   1.1875   2.0417  

	Coefficients:
		      Estimate Std. Error z value Pr(>|z|)    
	(Intercept)     0.2986     0.1630   1.832 0.066939 .  
	PK             -0.6005     0.1222  -4.913 8.97e-07 ***
	ATP            -0.8006     0.1959  -4.086 4.39e-05 ***
	NUMPROCESSORS  -0.7023     0.1946  -3.609 0.000307 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	(Dispersion parameter for binomial family taken to be 1)

	    Null deviance: 633.61  on 538  degrees of freedom
	Residual deviance: 593.38  on 535  degrees of freedom
	AIC: 601.38

	Number of Fisher Scoring iterations: 5

wald.test(b = coef(out.fit), Sigma = vcov(out.fit), Terms = 2:4)
Wald test:
----------

Chi-squared test:
X2 = 39.1, df = 3, P(> X2) = 1.6e-08

> 1-out.fit$deviance/out.fit$null.deviance
[1] 0.06349984

#### per-DBMS logistic #####
db2 <- subset(x, x$DBMS=='db2')
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS,  data = db2)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.2127393
mysql <- subset(x, x$DBMS=='mysql')
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = mysql)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.6035987
pgsql <- subset(x, x$DBMS=='pgsql')
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = pgsql)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.06081725
oracle <- subset(x, x$DBMS=='oracle')
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS + PCTREAD + ACTROWPOOL, data = oracle)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.2025069
sqlserver <- subset(x, x$DBMS=='sqlserver')
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS + PCTREAD + ACTROWPOOL, data = sqlserver)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.3333092

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
#[1] 289
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


med.fit <- lm(ATP ~ NUMPROCESSORS, data = x)
summary(med.fit)

	#####  thrashing samples 
	med.fit <- lm(ATP ~ NUMPROCESSORS, data = x)
	summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.53545 -0.32909  0.01048  0.32841  0.71550 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.62338    0.03971  15.698  < 2e-16 ***
	NUMPROCESSORS -0.33887    0.06109  -5.547 5.94e-08 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3533 on 331 degrees of freedom
	Multiple R-squared:  0.08506,	Adjusted R-squared:  0.0823 
	F-statistic: 30.77 on 1 and 331 DF,  p-value: 5.943e-08

		## if revised model is tried
		med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + PK + PCTUPDATE + PCTUPDATE:PK, data = x)
		summary(med.fit)
		
		Call:
		lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + 
		    PK + PCTUPDATE + PCTUPDATE:PK, data = x)

		Residuals:
		     Min       1Q   Median       3Q      Max 
		-0.53692 -0.33165  0.06402  0.30170  0.66404 

		Coefficients:
				         Estimate Std. Error t value Pr(>|t|)    
		(Intercept)               0.58955    0.12462   4.731 3.33e-06 ***
		NUMPROCESSORS            -0.42891    0.15627  -2.745  0.00639 ** 
		ACTROWPOOL                0.05307    0.14215   0.373  0.70915    
		PK                       -0.12546    0.09655  -1.299  0.19471    
		PCTUPDATE                 0.11044    0.10385   1.064  0.28834    
		NUMPROCESSORS:ACTROWPOOL  0.16541    0.21847   0.757  0.44952    
		PK:PCTUPDATE             -0.03153    0.13865  -0.227  0.82026    
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.345 on 326 degrees of freedom
		Multiple R-squared:  0.1405,	Adjusted R-squared:  0.1246 
		F-statistic: 8.878 on 6 and 326 DF,  p-value: 5.553e-09
	
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

		## original set
		out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS + PCTUPDATE + ACTROWPOOL, data = x)
		summary(out.fit)
		Call:
		lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS + PCTUPDATE + 
		    ACTROWPOOL, data = x)

		Residuals:
		     Min       1Q   Median       3Q      Max 
		-0.50789 -0.18395 -0.03447  0.18949  0.68924 

		Coefficients:
			      Estimate Std. Error t value Pr(>|t|)    
		(Intercept)    0.72863    0.06735  10.818  < 2e-16 ***
		PK            -0.06498    0.03207  -2.026   0.0437 *  
		ATP           -0.13530    0.04535  -2.984   0.0031 ** 
		NUMPROCESSORS -0.36526    0.05143  -7.102 9.96e-12 ***
		PCTUPDATE     -0.03383    0.05667  -0.597   0.5510    
		ACTROWPOOL    -0.10708    0.05665  -1.890   0.0597 .  
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.2607 on 283 degrees of freedom
		Multiple R-squared:  0.1825,	Adjusted R-squared:  0.1681 
		F-statistic: 12.64 on 5 and 283 DF,  p-value: 4.312e-11

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
out.fit <-  glm(MAXMPL ~ ATP + NUMPROCESSORS, data=x)
summary(out.fit)

	Call:
	glm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	Deviance Residuals: 
	    Min       1Q   Median       3Q      Max  
	-0.5108  -0.4190  -0.3528   0.5513   0.6654  

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.34083    0.04075   8.365 2.69e-16 ***
	ATP           -0.03198    0.04830  -0.662  0.50811    
	NUMPROCESSORS  0.17000    0.05485   3.099  0.00201 ** 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	(Dispersion parameter for gaussian family taken to be 0.2408038)

	    Null deviance: 194.56  on 799  degrees of freedom
	Residual deviance: 191.92  on 797  degrees of freedom
	AIC: 1136.3

	Number of Fisher Scoring iterations: 2

wald.test(b = coef(out.fit), Sigma = vcov(out.fit), Terms = 2:3)
Wald test:
----------

Chi-squared test:
X2 = 10.9, df = 2, P(> X2) = 0.0042

> 1-out.fit$deviance/out.fit$null.deviance
[1] 0.01354031

###################
db2 <- subset(x, x$DBMS=='db2')
out.fit <-  glm(MAXMPL ~ ATP + NUMPROCESSORS, data = db2)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.1514176
mysql <- subset(x, x$DBMS=='mysql')
mysql$NUMPROCESSORS = (mysql$NUMPROCESSORS/min(mysql$NUMPROCESSORS))/(max(mysql$NUMPROCESSORS)/min(mysql$NUMPROCESSORS))
out.fit <-  glm(MAXMPL ~ ATP + NUMPROCESSORS, data = mysql)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.06971828
pgsql <- subset(x, x$DBMS=='pgsql')
out.fit <-  glm(MAXMPL ~ ATP + NUMPROCESSORS, data = pgsql)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.07866522
oracle <- subset(x, x$DBMS=='oracle')
out.fit <-  glm(MAXMPL ~ ATP + NUMPROCESSORS, data = oracle)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.4548632
sqlserver <- subset(x, x$DBMS=='sqlserver')
out.fit <-  glm(MAXMPL ~ ATP + NUMPROCESSORS, data = sqlserver)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.657579
