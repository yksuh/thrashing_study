# Overall: 33.4% (close to suboptimal)
library(aod)
library(ggplot2)
x = read.csv(file="ext_cnfm.dat",head=TRUE,sep="\t")
#x = read.csv(file="cnfm.dat",head=TRUE,sep="\t")
x_r <- subset(x, x$PCTREAD!=0)
x_r <- subset(x_r, select = -PCTUPDATE)
x <- x_r
nrow(x)
#[1] 599
x <- subset(x, x$MAXMPL < 1100)
nrow(x)
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
> nrow(x)
[1] 152
> cor.test(x$NUMPROCESSORS, x$ATP)
	##### all  samples
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -7.8398, df = 597, p-value = 2.084e-14
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.3764165 -0.2310624
	sample estimates:
	       cor 
	-0.3055182

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
	t = -2.7035, df = 597, p-value = 0.007057
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.18842603 -0.03012913
	sample estimates:
	       cor 
	-0.1099749

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
	-0.4592 -0.2614 -0.1078  0.2338  0.8132 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.49825    0.02731  18.241  < 2e-16 ***
	NUMPROCESSORS -0.31145    0.03905  -7.976 7.76e-15 ***
	PK            -0.07900    0.02581  -3.061  0.00231 ** 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3156 on 596 degrees of freedom
	Multiple R-squared:  0.1074,	Adjusted R-squared:  0.1044 
	F-statistic: 35.85 on 2 and 596 DF,  p-value: 1.993e-15

	#### only thrashing samples
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.5043 -0.2500 -0.0752  0.3129  0.8782 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.505357   0.045038  11.221  < 2e-16 ***
	NUMPROCESSORS -0.008395   0.073028  -0.115    0.909    
	PK            -0.382557   0.049812  -7.680 1.17e-12 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3205 on 171 degrees of freedom
	Multiple R-squared:  0.2565,	Adjusted R-squared:  0.2478 
	F-statistic:  29.5 on 2 and 171 DF,  p-value: 9.861e-12

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.51790 -0.23921 -0.05304  0.30346  0.48854 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.50732    0.04687  10.823  < 2e-16 ***
	NUMPROCESSORS  0.03305    0.07717   0.428    0.669    
	PK            -0.40710    0.05340  -7.623 2.68e-12 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3176 on 149 degrees of freedom
	Multiple R-squared:  0.2816,	Adjusted R-squared:  0.272 
	F-statistic:  29.2 on 2 and 149 DF,  p-value: 1.99e-11

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
	t = -2.6393, df = 172, p-value = 0.009072
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.33618901 -0.04998361
	sample estimates:
	       cor 
	-0.1972864 

	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -1.8658, df = 150, p-value = 0.06402
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.302551090  0.008807417
	sample estimates:
	       cor 
	-0.1506045

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
	t = 4.7261, df = 172, p-value = 4.74e-06
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.2003547 0.4643684
	sample estimates:
	      cor 
	0.3390194
	
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = 5.9985, df = 150, p-value = 1.429e-08
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.3017860 0.5598512
	sample estimates:
	      cor 
	0.4398541

	#### all samples
out.fit <- lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.9405 -0.1665  0.1423  0.2362  0.3995 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.57119    0.03744  15.256  < 2e-16 ***
	PK             0.13372    0.02856   4.682 3.53e-06 ***
	ATP            0.09680    0.04498   2.152   0.0318 *  
	NUMPROCESSORS  0.23467    0.04511   5.203 2.71e-07 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3465 on 595 degrees of freedom
	Multiple R-squared:  0.07181,	Adjusted R-squared:  0.06713 
	F-statistic: 15.35 on 3 and 595 DF,  p-value: 1.254e-09

			out.fit <- lm(MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, data = x)
			summary(out.fit)

			Call:
			lm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, 
			    data = x)

			Residuals:
			    Min      1Q  Median      3Q     Max 
			-0.9104 -0.1585  0.1392  0.2302  0.4541 

			Coefficients:
				      Estimate Std. Error t value Pr(>|t|)    
			(Intercept)    0.63240    0.05298  11.938  < 2e-16 ***
			PK             0.13281    0.02847   4.665 3.82e-06 ***
			PCTREAD       -0.07181    0.03198  -2.246   0.0251 *  
			ACTROWPOOL    -0.04310    0.04948  -0.871   0.3841    
			ATP            0.08736    0.04514   1.936   0.0534 .  
			NUMPROCESSORS  0.22697    0.04540   5.000 7.58e-07 ***
			---
			Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

			Residual standard error: 0.3454 on 593 degrees of freedom
			Multiple R-squared:  0.08097,	Adjusted R-squared:  0.07322 
			F-statistic: 10.45 on 5 and 593 DF,  p-value: 1.264e-09

	#### only thrashing samples
	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.6834 -0.2458 -0.1283  0.2706  0.8540 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.313868   0.064133   4.894 2.28e-06 ***
	PK            -0.007972   0.062427  -0.128    0.899    
	ATP           -0.207538   0.082640  -2.511    0.013 *  
	NUMPROCESSORS  0.380816   0.078922   4.825 3.09e-06 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3463 on 170 degrees of freedom
	Multiple R-squared:  0.155,	Adjusted R-squared:  0.1401 
	F-statistic:  10.4 on 3 and 170 DF,  p-value: 2.564e-06

	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.58344 -0.16997 -0.09756  0.24065  0.64577 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.22631    0.05553   4.076 7.46e-05 ***
	PK            -0.06285    0.05581  -1.126   0.2619    
	ATP           -0.18594    0.07261  -2.561   0.0114 *  
	NUMPROCESSORS  0.42297    0.06844   6.180 5.92e-09 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2815 on 148 degrees of freedom
	Multiple R-squared:  0.2281,	Adjusted R-squared:  0.2124 
	F-statistic: 14.57 on 3 and 148 DF,  p-value: 2.286e-08

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
x = read.csv(file="ext_cnfm.dat",head=TRUE,sep="\t")
#x = read.csv(file="cnfm.dat",head=TRUE,sep="\t")
#x$MAXMPL[x$MAXMPL == 1100] <- 10000
x_w <- subset(x, x$PCTUPDATE!=0)
x_w <- subset(x_w, select = -PCTREAD)
x <- x_w
nrow(x)
[1] 879
x <- subset(x, x$MAXMPL < 1100)
nrow(x)
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

> x <- subset(x, x$MAXMPL < 1)
> nrow(x)
[1] 311

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
	t = -3.6531, df = 309, p-value = 0.0003043
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.30772316 -0.09438802
	sample estimates:
	       cor 
	-0.2034694

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
	t = -5.1846, df = 309, p-value = 3.919e-07
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.3820916 -0.1772557
	sample estimates:
	       cor 
	-0.2828961

med.fit <- lm(ATP ~ NUMPROCESSORS, data = x)
summary(med.fit)
	#####  all samples 
	Call:
	lm(formula = ATP ~ NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.46328 -0.33978 -0.04831  0.34901  0.68995 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.48556    0.02442  19.880  < 2e-16 ***
	NUMPROCESSORS -0.17551    0.03972  -4.419 1.13e-05 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3597 on 798 degrees of freedom
	Multiple R-squared:  0.02388,	Adjusted R-squared:  0.02266 
	F-statistic: 19.52 on 1 and 798 DF,  p-value: 1.131e-0	

	#####  thrashing samples 
	Call:
	lm(formula = ATP ~ NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.44978 -0.31921 -0.05047  0.33490  0.71385 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.48302    0.03465   13.94  < 2e-16 ***
	NUMPROCESSORS -0.19687    0.05545   -3.55 0.000436 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3451 on 361 degrees of freedom
	Multiple R-squared:  0.03374,	Adjusted R-squared:  0.03106 
	F-statistic: 12.61 on 1 and 361 DF,  p-value: 0.0004356

		med.fit <- lm(ATP ~ PK + NUMPROCESSORS, data = x)
		summary(med.fit)
		
		Call:
		lm(formula = ATP ~ PK + NUMPROCESSORS, data = x)

		Residuals:
		     Min       1Q   Median       3Q      Max 
		-0.56439 -0.34556  0.08581  0.30385  0.68061 

		Coefficients:
			      Estimate Std. Error t value Pr(>|t|)    
		(Intercept)    0.66795    0.04221  15.823  < 2e-16 ***
		PK            -0.19322    0.03902  -4.952 1.21e-06 ***
		NUMPROCESSORS -0.20711    0.06210  -3.335 0.000957 ***
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.3391 on 308 degrees of freedom
		Multiple R-squared:  0.1121,	Adjusted R-squared:  0.1063 
		F-statistic: 19.44 on 2 and 308 DF,  p-value: 1.118e-08

cor.test(x$PK, x$MAXMPL)
	
	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = -2.0086, df = 309, p-value = 0.04545
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.221941106 -0.002338232
	sample estimates:
	      cor 
	-0.113526

cor.test(x$ATP, x$MAXMPL)
	#####  all samples 
	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = 1.0284, df = 798, p-value = 0.3041
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.03301654  0.10542918
	sample estimates:
	       cor 
	0.03638088

	#####  thrashing samples 
	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -0.5949, df = 309, p-value = 0.5524
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1444950  0.0776884
	sample estimates:
		cor 
	-0.03382115

cor.test(x$NUMPROCESSORS, x$MAXMPL)
	#####  all samples 
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = -3.3273, df = 798, p-value = 0.000917
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1847934 -0.0480530
	sample estimates:
	       cor 
	-0.1169775

	#####  thrashing samples 
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = -7.0636, df = 309, p-value = 1.079e-11
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.4648018 -0.2729610
	sample estimates:
	      cor 
	-0.372859

out.fit <- lm(MAXMPL ~ ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	##### all samples 
	Call:
	lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.6735 -0.5382  0.3415  0.4052  0.4958 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.67481    0.03954  17.066  < 2e-16 ***
	ATP            0.02469    0.04687   0.527  0.59853    
	NUMPROCESSORS -0.17056    0.05323  -3.204  0.00141 ** 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.4762 on 797 degrees of freedom
	Multiple R-squared:  0.01403,	Adjusted R-squared:  0.01155 
	F-statistic: 5.669 on 2 and 797 DF,  p-value: 0.003591

	### thrashing samples
	Call:
	lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.43168 -0.20316 -0.03285  0.22414  0.54189 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.46202    0.02945  15.688  < 2e-16 ***
	ATP           -0.16620    0.03607  -4.608 5.66e-06 ***
	NUMPROCESSORS -0.17220    0.03866  -4.454 1.12e-05 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2365 on 360 degrees of freedom
	Multiple R-squared:  0.08792,	Adjusted R-squared:  0.08286 
	F-statistic: 17.35 on 2 and 360 DF,  p-value: 6.391e-08

	out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
	summary(out.fit)

		Call:
		lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

		Residuals:
		     Min       1Q   Median       3Q      Max 
		-0.42487 -0.16971 -0.02993  0.18111  0.58026 

		Coefficients:
			      Estimate Std. Error t value Pr(>|t|)    
		(Intercept)    0.51978    0.03300  15.749  < 2e-16 ***
		PK            -0.09124    0.02501  -3.648 0.000303 ***
		ATP           -0.19009    0.03607  -5.270 2.35e-07 ***
		NUMPROCESSORS -0.16883    0.03803  -4.440 1.20e-05 ***
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.2325 on 359 degrees of freedom
		Multiple R-squared:  0.1205,	Adjusted R-squared:  0.1132 
		F-statistic:  16.4 on 3 and 359 DF,  p-value: 5.21e-10

	## further refine!
	Call:
	lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.53758 -0.21242 -0.04577  0.18813  0.57287 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.58801    0.03929  14.966  < 2e-16 ***
	ATP           -0.09416    0.04411  -2.135   0.0336 *  
	NUMPROCESSORS -0.37557    0.05082  -7.390 1.39e-12 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2728 on 308 degrees of freedom
	Multiple R-squared:  0.1516,	Adjusted R-squared:  0.1461 
	F-statistic: 27.51 on 2 and 308 DF,  p-value: 1.015e-11

	
	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.51673 -0.19583 -0.02345  0.21385  0.60374 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.63948    0.04544  14.074  < 2e-16 ***
	PK            -0.07178    0.03241  -2.215  0.02750 *  
	ATP           -0.12156    0.04555  -2.669  0.00802 ** 
	NUMPROCESSORS -0.37185    0.05053  -7.359 1.71e-12 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2711 on 307 degrees of freedom
	Multiple R-squared:  0.1649,	Adjusted R-squared:  0.1568 
	F-statistic: 20.21 on 3 and 307 DF,  p-value: 5.59e-12

### mediation analysis
library(mediation)
med.fit <- lm(ATP ~ NUMPROCESSORS, data = x)
out.fit <- lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	### All samples
	med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
	summary(med.out)
	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.00464     -0.02248      0.01129    0.54
	ADE            -0.17268     -0.27622     -0.06977    0.00
	Total Effect   -0.17732     -0.27703     -0.07673    0.00
	Prop. Mediated  0.02410     -0.06578      0.16055    0.54

	Sample Size Used: 800 


	Simulations: 1000 

	### thrashing samples
	med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
	summary(med.out)
	
	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME             0.0355       0.0143       0.0616    0.00
	ADE             -0.1439      -0.2227      -0.0600    0.00
	Total Effect    -0.1084      -0.1914      -0.0217    0.01
	Prop. Mediated  -0.3170      -1.5833      -0.0969    0.01

	Sample Size Used: 334 


	Simulations: 1000

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
