# sample size: 148
library(aod)
library(ggplot2)
x = read.csv(file="cnfm.dat",head=TRUE,sep="\t")
#nrow(x)
#[1] 1339
#x = read.csv(file="new_cnfm.dat",head=TRUE,sep="\t")
#nrow(x)
#[1] 1592
#nrow(x)
#[1] 120
x_r <- subset(x, x$PCTREAD!=0)
x_r <- subset(x_r, select = -PCTUPDATE)
x <- x_r
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD/min(x$PCTREAD))/(max(x$PCTREAD)/min(x$PCTREAD))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
nrow(x)
#[1] 539
#[1] 641
x <- subset(x, x$ATP < 120000)
#[1] 526
#[1] 628
x <- subset(x, x$MAXMPL < 1100)
#nrow(x)
#[1] 148
#[1] 182 (34 added)
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
# nrow(x)
#[1] 148
#x <- subset(x, x$MAXMPL < 1)
#[1] 129
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
	t = -0.2919, df = 163, p-value = 0.7708
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1750279  0.1303834
	sample estimates:
	       cor 
	-0.0228555

	Pearson's product-moment correlation

data:  x$NUMPROCESSORS and x$ATP
t = 0.3772, df = 146, p-value = 0.7066
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.1308038  0.1915779
sample estimates:
       cor 
0.03119843

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
t = -7.8658, df = 146, p-value = 7.489e-13
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.6497162 -0.4213030
sample estimates:
       cor 
-0.5455624	

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

	### extended
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.55633 -0.16488 -0.04928  0.26589  0.83446 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.57158    0.04266  13.397  < 2e-16 ***
	NUMPROCESSORS -0.04089    0.06255  -0.654    0.514    
	PK            -0.39581    0.04579  -8.644 2.99e-15 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2984 on 179 degrees of freedom
	Multiple R-squared:  0.2946,	Adjusted R-squared:  0.2867 
	F-statistic: 37.37 on 2 and 179 DF,  p-value: 2.729e-14

> cor.test(x$PK, x$MAXMPL)
	#### all samples
	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 4.619, df = 537, p-value = 4.832e-06
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.1128874 0.2753890
	sample estimates:
	      cor 
	0.1954796

	#### only thrashing samples
	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 1.502, df = 146, p-value = 0.1353
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.03876179  0.27914177
	sample estimates:
	      cor 
	0.1233535

> cor.test(x$ATP, x$MAXMPL)
	#### all samples
	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = 0.7203, df = 537, p-value = 0.4717
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.05352887  0.11522103
	sample estimates:
	       cor 
	0.03106747

	#### only thrashing samples
	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -3.2048, df = 146, p-value = 0.00166
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.40112162 -0.09912601
	sample estimates:
	       cor 
	-0.2563696

cor.test(x$NUMPROCESSORS, x$MAXMPL)
	#### all samples
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = 3.4857, df = 537, p-value = 0.000531
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.06510698 0.23030764
	sample estimates:
	     cor 
	0.148745

	#### only thrashing samples
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = 3.741, df = 146, p-value = 0.0002627
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.1411518 0.4362848
	sample estimates:
	    cor 
	0.29576

#### only thrashing samples
out.fit <- lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
summary(out.fit)
	
	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.7010 -0.2157 -0.1013  0.2698  0.6548 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.39534    0.07219   5.476 1.88e-07 ***
	PK            -0.02569    0.06900  -0.372 0.710159    
	ATP           -0.27968    0.08975  -3.116 0.002213 ** 
	NUMPROCESSORS  0.33585    0.08427   3.986 0.000107 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3398 on 144 degrees of freedom
	Multiple R-squared:  0.1589,	Adjusted R-squared:  0.1414 
	F-statistic: 9.068 on 3 and 144 DF,  p-value: 1.542e-05

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

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	     Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] 0.1 -0.0055      -0.0349       0.0239         0.01       0.0082

	Rho at which ACME = 0: 0.1
	R^2_M*R^2_Y* at which ACME = 0: 0.01
	R^2_M~R^2_Y~ at which ACME = 0: 0.0082

pdf("read_sens_procs.pdf")
plot(sens.out, main = "", xlab=expression("Sensitivity Parameter (Correlation Factor of Error Terms):" ~ rho), ylab="Average Mediation Effect with 95% Confidence Intervals", xlim=c(-0.6, 0.6), ylim=c(-0.3, 0.3))
dev.off()

	med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK")
	summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME             0.1167       0.0394       0.2036     0.0
	ADE             -0.0242      -0.1549       0.1140     0.7
	Total Effect     0.0925      -0.0238       0.2123     0.1
	Prop. Mediated   1.1811      -3.9671      10.6847     0.1

	Sample Size Used: 148 


	Simulations: 1000 

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.3 -0.0248      -0.0981       0.0486         0.09       0.0531
	[2,] -0.2  0.0251      -0.0482       0.0985         0.04       0.0236
	[3,] -0.1  0.0720      -0.0033       0.1472         0.01       0.0059

	Rho at which ACME = 0: -0.3
	R^2_M*R^2_Y* at which ACME = 0: 0.09
	R^2_M~R^2_Y~ at which ACME = 0: 0.0531 

pdf("read_sens_pk.pdf")
plot(sens.out, main = "", xlab=expression("Sensitivity Parameter (Correlation Factor of Error Terms):" ~ rho), ylab="Average Mediation Effect with 95% Confidence Intervals", xlim=c(-0.6, 0.6), ylim=c(-0.6, 0.6))
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
#qqnorm(out.fit$res,main="",ylim=c(-0.8,0.6)); qqline(out.fit$res);
#dev.off()
pdf("read_normal_res.pdf")
#h <- hist(out.fit$res,main="",xlab="Residuals",ylim=c(0,50),xlim=c(-0.6,0.6))
h <- hist(out.fit$res,main="",xlab="Residuals",ylim=c(0,40),xlim=c(-1,1))
xfit<-seq(min(out.fit$res),max(out.fit$res),length=40) 
yfit<-dnorm(xfit,mean=mean(out.fit$res),sd=sd(out.fit$res)) 
yfit <- yfit*diff(h$mids[1:2])*length(out.fit$res) 
lines(xfit, yfit, col="blue")
dev.off()

pdf("read_cd.pdf")
cd = cooks.distance(out.fit)
plot(cd, ylim=c(0, 0.05), main="(CD shouldn't be greater than 1)", ylab="Cook's Distances (CDs)", xlab="Observation Number")
dev.off()

ncvTest(out.fit)
	## only thrashing samples
	Non-constant Variance Score Test 
	Variance formula: ~ fitted.values 
	Chisquare = 4.093433    Df = 1     p = 0.04305013  

	### when doing x <- subset(x, x$MAXMPL < 1)
	Non-constant Variance Score Test 
	Variance formula: ~ fitted.values 
	Chisquare = 1.605772    Df = 1     p = 0.2050871

# Evaluate Collinearity
vif(out.fit) # variance inflation factors 
           PK           ATP NUMPROCESSORS 
     1.424948      1.426265      1.00180

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
	   1       0.2660653      1.442629       0
	 Alternative hypothesis: rho != 0

#### per-DBMS for ATP time ###
18.87 (0.01)\% for DBMS X, 
27.54\% for MySQL, 
13.92 (6.96)\% for DBMS Y, 
60.97\% for PostgreSQL, and 
37.59\% for DBMS Z.


#### per-DBMS for MaxMPL #####
18.87 (0.01)\% for DBMS X, 
       #3.35
27.54\% for MySQL, 
13.92 (6.96)\% for DBMS Y, 
3.34\% for PostgreSQL, and 
31.61\% for DBMS Z.

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
# sample size: 334
library(aod)
library(ggplot2)
x = read.csv(file="cnfm.dat",head=TRUE,sep="\t")
#x = read.csv(file="new_cnfm.dat",head=TRUE,sep="\t")
#x$MAXMPL[x$MAXMPL == 1100] <- 10000
x_w <- subset(x, x$PCTUPDATE!=0)
x_w <- subset(x_w, select = -PCTREAD)
x <- x_w
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTUPDATE = (x$PCTUPDATE/min(x$PCTUPDATE))/(max(x$PCTUPDATE)/min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
nrow(x)
#[1] 800
#[1] 951
x <- subset(x, x$ATP < 120000) #### considered
#nrow(x)
#[1] 761
#[1] 912
x <- subset(x, x$MAXMPL < 1100)
#nrow(x)
#[1] 333: 43.75% thrashing
#[1] 419: 48.13% thrashing
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
x <- subset(x, x$MAXMPL < 1)
#nrow(x)
#[1] 289
#[1] 321
## H1: numProcs vs. Thrashing Pt.
> cor.test(x$NUMPROCESSORS, x$MAXMPL)
	Pearson's product-moment correlation

data:  x$NUMPROCESSORS and x$MAXMPL
t = -6.6396, df = 331, p-value = 1.57e-10
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.4608757 -0.2604885
sample estimates:
       cor 
-0.3649005

## H2: numProcs vs. Thrashing Pt.
> cor.test(x$NUMPROCESSORS, x$ATP)
## intended: with filtering out x$MAXMPL < 1
	Pearson's product-moment correlation

data:  x$NUMPROCESSORS and x$ATP
t = -2.8268, df = 331, p-value = 0.005033
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.27474501 -0.05015675
sample estimates:
       cor 
-0.1645833

## H3: numProcs vs. Thrashing Pt.
## intended: (without filtering out x$MAXMPL < 1)
> cor.test(x$ATP, x$MAXMPL)

	Pearson's product-moment correlation

data:  x$ATP and x$MAXMPL
t = -2.4503, df = 331, p-value = 0.01479
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.23754546 -0.02638012
sample estimates:
       cor 
-0.1334774


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


out.fit <- lm(MAXMPL ~ ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	### modified
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

	Residual standard error: 0.2632 on 331 degrees of freedom
	Multiple R-squared:  0.1581,	Adjusted R-squared:  0.1522 
	F-statistic: 26.86 on 2 and 331 DF,  p-value: 2.042e-1

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
	ACME             0.0617       0.0258       0.1047    0.00
	ADE             -0.2192      -0.3379      -0.0970    0.00
	Total Effect    -0.1575      -0.2756      -0.0349    0.01
	Prop. Mediated  -0.3741      -1.9040      -0.1354    0.01

	Sample Size Used: 333 


	Simulations: 1000 

	sens.out <-medsens(med.out)
	summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.3 -0.0205      -0.0424       0.0014         0.09       0.0737
	[2,] -0.2 -0.0046      -0.0216       0.0124         0.04       0.0328
	[3,] -0.1  0.0103      -0.0078       0.0285         0.01       0.0082

	Rho at which ACME = 0: -0.2
	R^2_M*R^2_Y* at which ACME = 0: 0.04
	R^2_M~R^2_Y~ at which ACME = 0: 0.0328

pdf("update_sens_procs.pdf")
plot(sens.out, main = "", xlab=expression("Sensitivity Parameter (Correlation Factor of Error Terms):" ~ rho), ylab="Average Mediation Effect with 95% Confidence Intervals", xlim=c(-0.6, 0.6), ylim=c(-0.3, 0.3))
dev.off()

### assumption testing #####
library(car)
out.fit <- lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)
outlierTest(out.fit)
No Studentized residuals with Bonferonni p < 0.05
Largest |rstudent|:
    rstudent unadjusted p-value Bonferonni p
620 2.382511           0.017851           NA
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
plot(cd, xlim=c(0, 350), ylim=c(0, 0.03), main="(CD shouldn't be greater than 1)", ylab="Cook's Distances (CDs)", xlab="Observation Number")
dev.off()

ncvTest(out.fit)

	Non-constant Variance Score Test 
	Variance formula: ~ fitted.values 
	Chisquare = 0.5052569    Df = 1     p = 0.4771994

# Evaluate Collinearity
vif(out.fit) # variance inflation factors 
          ATP NUMPROCESSORS 
     1.027842      1.027842 

sqrt(vif(out.fit)) > 2 # problem?
          ATP NUMPROCESSORS 
        FALSE         FALSE

# Evaluate Nonlinearity
# component + residual plot 
pdf("linearity_assumption_testesult.pdf")
crPlots(out.fit, main = "",)
dev.off()

# Test for Autocorrelated Errors
durbinWatsonTest(out.fit)
	 lag Autocorrelation D-W Statistic p-value
	   1       0.4401782      1.111135       0
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
