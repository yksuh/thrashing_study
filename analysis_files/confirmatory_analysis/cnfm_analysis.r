# Overall: 33.4% (close to suboptimal)
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

	# Stepwise Regression
	library(MASS)	
	med.fit <- lm(ATP ~ PK:PCTREAD + PK + PCTREAD + ACTROWPOOL + NUMPROCESSORS + NUMPROCESSORS:ACTROWPOOL, data = x)
	summary(med.fit)
	step <- stepAIC(med.fit, direction="both")
	Start:  AIC=-345.08
	ATP ~ PK:PCTREAD + PK + PCTREAD + ACTROWPOOL + NUMPROCESSORS + 
	    NUMPROCESSORS:ACTROWPOOL

		                   Df Sum of Sq    RSS     AIC
	- ACTROWPOOL:NUMPROCESSORS  1   0.00227 13.081 -347.05
	<none>                                  13.079 -345.08
	- PK:PCTREAD                1   0.24710 13.326 -344.31

	Step:  AIC=-347.05
	ATP ~ PK + PCTREAD + ACTROWPOOL + NUMPROCESSORS + PK:PCTREAD

		                   Df Sum of Sq    RSS     AIC
	- NUMPROCESSORS             1   0.04001 13.121 -348.60
	<none>                                  13.081 -347.05
	- PK:PCTREAD                1   0.24691 13.328 -346.29
	- ACTROWPOOL                1   0.33962 13.421 -345.26
	+ ACTROWPOOL:NUMPROCESSORS  1   0.00227 13.079 -345.08

	Step:  AIC=-348.6
	ATP ~ PK + PCTREAD + ACTROWPOOL + PK:PCTREAD

		        Df Sum of Sq    RSS     AIC
	<none>                       13.121 -348.60
	- PK:PCTREAD     1   0.23797 13.359 -347.94
	+ NUMPROCESSORS  1   0.04001 13.081 -347.05
	- ACTROWPOOL     1   0.34100 13.462 -346.80

	med.fit <- lm(ATP ~ PK + PCTREAD + ACTROWPOOL + PK:PCTREAD, data = x)
	summary(med.fit)

	Call:
	lm(formula = ATP ~ PK + PCTREAD + ACTROWPOOL + PK:PCTREAD, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.69537 -0.20303 -0.04153  0.26864  0.86835 

	Coefficients:
		    Estimate Std. Error t value Pr(>|t|)    
	(Intercept)  0.52449    0.06825   7.685 2.23e-12 ***
	PK          -0.48699    0.07043  -6.914 1.44e-10 ***
	PCTREAD     -0.21750    0.07038  -3.090   0.0024 ** 
	ACTROWPOOL   0.17305    0.08977   1.928   0.0559 .  
	PK:PCTREAD   0.18186    0.11293   1.610   0.1095    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3029 on 143 degrees of freedom
	Multiple R-squared:  0.3581,	Adjusted R-squared:  0.3402 
	F-statistic: 19.95 on 4 and 143 DF,  p-value: 4.553e-13


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

		Call:
		lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

		Residuals:
		     Min       1Q   Median       3Q      Max 
		-0.68005 -0.28921 -0.03892  0.29397  0.74176 

		Coefficients:
			      Estimate Std. Error t value Pr(>|t|)    
		(Intercept)    0.44604    0.06904   6.461 9.65e-10 ***
		PK            -0.05318    0.06234  -0.853   0.3948    
		ATP           -0.19313    0.08547  -2.260   0.0251 *  
		NUMPROCESSORS  0.23401    0.07161   3.268   0.0013 ** 
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.3412 on 178 degrees of freedom
		Multiple R-squared:  0.08538,	Adjusted R-squared:  0.06996 
		F-statistic: 5.538 on 3 and 178 DF,  p-value: 0.001172

		# Stepwise Regression
		library(MASS)	
		out.fit <- lm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, data = x)
		step <- stepAIC(out.fit, direction="both")
		
		MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS

                Df Sum of Sq    RSS     AIC
		- PCTREAD        1   0.06132 20.628 -386.28
		- PK             1   0.06573 20.633 -386.24
		- ACTROWPOOL     1   0.09552 20.663 -385.97
		<none>                       20.567 -384.82
		- ATP            1   0.54428 21.111 -382.06
		- NUMPROCESSORS  1   1.20728 21.774 -376.44

		Step:  AIC=-386.28
		MAXMPL ~ PK + ACTROWPOOL + ATP + NUMPROCESSORS

				Df Sum of Sq    RSS     AIC
		- PK             1   0.06304 20.691 -387.72
		- ACTROWPOOL     1   0.09848 20.727 -387.41
		<none>                       20.628 -386.28
		+ PCTREAD        1   0.06132 20.567 -384.82
		- ATP            1   0.49075 21.119 -384.00
		- NUMPROCESSORS  1   1.21901 21.847 -377.83

		Step:  AIC=-387.72
		MAXMPL ~ ACTROWPOOL + ATP + NUMPROCESSORS

				Df Sum of Sq    RSS     AIC
		- ACTROWPOOL     1   0.12017 20.812 -388.67
		<none>                       20.691 -387.72
		+ PK             1   0.06304 20.628 -386.28
		+ PCTREAD        1   0.05863 20.633 -386.24
		- ATP            1   0.45405 21.145 -385.77
		- NUMPROCESSORS  1   1.26202 21.953 -378.95

		Step:  AIC=-388.67
		MAXMPL ~ ATP + NUMPROCESSORS

				Df Sum of Sq    RSS     AIC
		<none>                       20.812 -388.67
		+ ACTROWPOOL     1   0.12017 20.691 -387.72
		+ PK             1   0.08473 20.727 -387.41
		+ PCTREAD        1   0.06142 20.750 -387.20
		- ATP            1   0.53285 21.344 -386.07
		- NUMPROCESSORS  1   1.29701 22.109 -379.66

		out.fit <- lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)
		summary(out.fit)
		Call:
		lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

		Residuals:
		     Min       1Q   Median       3Q      Max 
		-0.64641 -0.29782 -0.03419  0.28926  0.70873 

		Coefficients:
			      Estimate Std. Error t value Pr(>|t|)    
		(Intercept)    0.40803    0.05270   7.743 6.92e-13 ***
		ATP           -0.15357    0.07173  -2.141  0.03364 *  
		NUMPROCESSORS  0.23838    0.07137   3.340  0.00102 ** 
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.341 on 179 degrees of freedom
		Multiple R-squared:  0.08164,	Adjusted R-squared:  0.07138 
		F-statistic: 7.956 on 2 and 179 DF,  p-value: 0.0004895

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
	Chisquare = 4.093433    Df = 1     p = 0.04305013  

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
library(aod)
library(ggplot2)
x = read.csv(file="cnfm.dat",head=TRUE,sep="\t")
#x = read.csv(file="new_cnfm.dat",head=TRUE,sep="\t")
#x$MAXMPL[x$MAXMPL == 1100] <- 10000
x_w <- subset(x, x$PCTUPDATE!=0)
x_w <- subset(x_w, select = -PCTREAD)
x <- x_w
nrow(x)
#[1] 800
#[1] 951
x <- subset(x, x$ATP < 120000)
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

		#####  extended samples 
		Call:
		lm(formula = ATP ~ NUMPROCESSORS, data = x)

		Residuals:
		     Min       1Q   Median       3Q      Max 
		-0.51434 -0.32895  0.01123  0.31521  0.66940 

		Coefficients:
			      Estimate Std. Error t value Pr(>|t|)    
		(Intercept)    0.54139    0.03559  15.210  < 2e-16 ***
		NUMPROCESSORS -0.21079    0.05390  -3.911  0.00011 ***
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.3463 on 364 degrees of freedom
		Multiple R-squared:  0.04033,	Adjusted R-squared:  0.03769 
		F-statistic:  15.3 on 1 and 364 DF,  p-value: 0.0001096


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
	
		## stepwise regression
		library(MASS)	
		med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + PK + PCTUPDATE + PCTUPDATE:PK, data = x)
		step <- stepAIC(med.fit, direction="both")
		summary(med.fit)

			Call:
			lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + 
			    PK + PCTUPDATE + PCTUPDATE:PK, data = x)

			Residuals:
			     Min       1Q   Median       3Q      Max 
			-0.56173 -0.31129  0.01893  0.30109  0.66188 

			Coefficients:
						 Estimate Std. Error t value Pr(>|t|)    
			(Intercept)               0.36511    0.10990   3.322 0.000984 ***
			NUMPROCESSORS            -0.09764    0.12531  -0.779 0.436396    
			ACTROWPOOL                0.20291    0.11397   1.780 0.075857 .  
			PK                       -0.15167    0.08852  -1.713 0.087488 .  
			PCTUPDATE                 0.21093    0.09790   2.154 0.031866 *  
			NUMPROCESSORS:ACTROWPOOL -0.13863    0.16707  -0.830 0.407208    
			PK:PCTUPDATE             -0.04801    0.12777  -0.376 0.707309    
			---
			Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

			Residual standard error: 0.3302 on 359 degrees of freedom
			Multiple R-squared:  0.1395,	Adjusted R-squared:  0.1251 
			F-statistic: 9.702 on 6 and 359 DF,  p-value: 6.588e-10

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

		### extended set
		out.fit <- lm(MAXMPL ~ ATP + NUMPROCESSORS, data = x)
		summary(out.fit)

		Call:
		lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

		Residuals:
		     Min       1Q   Median       3Q      Max 
		-0.50948 -0.24795 -0.02297  0.23071  0.64276 

		Coefficients:
			      Estimate Std. Error t value Pr(>|t|)    
		(Intercept)    0.54264    0.03644  14.892  < 2e-16 ***
		ATP           -0.12294    0.04195  -2.930   0.0036 ** 
		NUMPROCESSORS -0.26459    0.04404  -6.008 4.56e-09 ***
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.2772 on 363 degrees of freedom
		Multiple R-squared:  0.09746,	Adjusted R-squared:  0.09248 
		F-statistic:  19.6 on 2 and 363 DF,  p-value: 8.271e-09

		# Stepwise Regression
		library(MASS)	
		out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS + PCTUPDATE + ACTROWPOOL, data = x)
		step <- stepAIC(out.fit, direction="both")
		Start:  AIC=-937.51
		MAXMPL ~ PK + ATP + NUMPROCESSORS + PCTUPDATE + ACTROWPOOL

				Df Sum of Sq    RSS     AIC
		- PCTUPDATE      1   0.01957 27.359 -939.25
		- ACTROWPOOL     1   0.10965 27.449 -938.05
		<none>                       27.340 -937.51
		- PK             1   0.40195 27.742 -934.17
		- ATP            1   0.78519 28.125 -929.15
		- NUMPROCESSORS  1   2.86256 30.202 -903.07

		Step:  AIC=-939.25
		MAXMPL ~ PK + ATP + NUMPROCESSORS + ACTROWPOOL

				Df Sum of Sq    RSS     AIC
		- ACTROWPOOL     1   0.10594 27.465 -939.84
		<none>                       27.359 -939.25
		+ PCTUPDATE      1   0.01957 27.340 -937.51
		- PK             1   0.40074 27.760 -935.93
		- ATP            1   0.84248 28.202 -930.15
		- NUMPROCESSORS  1   2.85196 30.211 -904.96

		Step:  AIC=-939.84
		MAXMPL ~ PK + ATP + NUMPROCESSORS

				Df Sum of Sq    RSS     AIC
		<none>                       27.465 -939.84
		+ ACTROWPOOL     1   0.10594 27.359 -939.25
		+ PCTUPDATE      1   0.01586 27.449 -938.05
		- PK             1   0.42991 27.895 -936.15
		- ATP            1   0.91580 28.381 -929.83
		- NUMPROCESSORS  1   2.84556 30.311 -905.75
	
		Call:
		lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

		Residuals:
		     Min       1Q   Median       3Q      Max 
		-0.49205 -0.22265 -0.01566  0.22434  0.67738 

		Coefficients:
			      Estimate Std. Error t value Pr(>|t|)    
		(Intercept)    0.59762    0.04294  13.916  < 2e-16 ***
		PK            -0.07195    0.03022  -2.380 0.017811 *  
		ATP           -0.15020    0.04323  -3.474 0.000574 ***
		NUMPROCESSORS -0.26813    0.04378  -6.124 2.38e-09 ***
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.2754 on 362 degrees of freedom
		Multiple R-squared:  0.1114,	Adjusted R-squared:  0.104 
		F-statistic: 15.12 on 3 and 362 DF,  p-value: 2.715e-09

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
	[1,] -0.2 -0.0050      -0.0400       0.0300         0.04       0.0346
	[2,] -0.1  0.0287      -0.0077       0.0651         0.01       0.0087

	Rho at which ACME = 0: -0.2
	R^2_M*R^2_Y* at which ACME = 0: 0.04
	R^2_M~R^2_Y~ at which ACME = 0: 0.0346

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
