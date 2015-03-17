# Overall: 33.4% (close to suboptimal)
library(aod)
library(ggplot2)
x = read.csv(file="cnfm.dat",head=TRUE,sep="\t")
#x$MAXMPL[x$MAXMPL == 1100] <- 10000
# ATP normalization
# db2
db2 <- subset(x, x$DBMS=='db2')
db2_r <- subset(db2, db2$PCTREAD!=0)
db2_r <- subset(db2_r, select = -PCTUPDATE)
db2_r$ATP = (db2_r$ATP-min(db2_r$ATP))/(max(db2_r$ATP)-min(db2_r$ATP))
db2_r$MAXMPL = (db2_r$MAXMPL-min(db2_r$MAXMPL))/(max(db2_r$MAXMPL)-min(db2_r$MAXMPL))
db2 <- db2_r
# oracle
oracle <- subset(x, x$DBMS=='oracle')
oracle_r <- subset(oracle, oracle$PCTREAD!=0)
oracle_r <- subset(oracle_r, select = -PCTUPDATE)
oracle_r$ATP = (oracle_r$ATP-min(oracle_r$ATP))/(max(oracle_r$ATP)-min(oracle_r$ATP))
oracle_r$MAXMPL = (oracle_r$MAXMPL-min(oracle_r$MAXMPL))/(max(oracle_r$MAXMPL)-min(oracle_r$MAXMPL))
oracle <- oracle_r
# mysql
mysql <- subset(x, x$DBMS=='mysql')
mysql_r <- subset(mysql, mysql$PCTREAD!=0)
mysql_r <- subset(mysql_r, select = -PCTUPDATE)
mysql_r$ATP = (mysql_r$ATP-min(mysql_r$ATP))/(max(mysql_r$ATP)-min(mysql_r$ATP))
mysql_r$MAXMPL = (mysql_r$MAXMPL-min(mysql_r$MAXMPL))/(max(mysql_r$MAXMPL)-min(mysql_r$MAXMPL))
mysql <- mysql_r
# pgsql
pgsql <- subset(x, x$DBMS=='pgsql')
pgsql_r <- subset(pgsql, pgsql$PCTREAD!=0)
pgsql_r <- subset(pgsql_r, select = -PCTUPDATE)
pgsql_r$ATP = (pgsql_r$ATP-min(pgsql_r$ATP))/(max(pgsql_r$ATP)-min(pgsql_r$ATP))
pgsql_r$MAXMPL = (pgsql_r$MAXMPL-min(pgsql_r$MAXMPL))/(max(pgsql_r$MAXMPL)-min(pgsql_r$MAXMPL))
pgsql <- pgsql_r
# sqlserver
sqlserver <- subset(x, x$DBMS=='sqlserver')
sqlserver_r <- subset(sqlserver, sqlserver$PCTREAD!=0)
sqlserver_r <- subset(sqlserver_r, select = -PCTUPDATE)
sqlserver_r$ATP = (sqlserver_r$ATP-min(sqlserver_r$ATP))/(max(sqlserver_r$ATP)-min(sqlserver_r$ATP))
sqlserver_r$MAXMPL = (sqlserver_r$MAXMPL-min(sqlserver_r$MAXMPL))/(max(sqlserver_r$MAXMPL)-min(sqlserver_r$MAXMPL))
sqlserver <- sqlserver_r
#### gother each DBMS' samples
x = rbind(db2,mysql,oracle,pgsql,sqlserver)
#x <- x[!is.na(x$MAXMPL),]
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD/min(x$PCTREAD))/(max(x$PCTREAD)/min(x$PCTREAD))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
nrow(x)
[1] 539
x <- subset(x, x$MAXMPL < 1)
> nrow(x)
[1] 148

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
	t = -1.2425, df = 146, p-value = 0.216
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.25935551  0.06004267
	sample estimates:
	       cor 
	-0.1022921

> cor.test(x$PK, x$ATP)
	#####  all  samples
	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -2.8926, df = 537, p-value = 0.003976
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.20616283 -0.03982434
	sample estimates:
	       cor 
	-0.1238636

	#### only thrashing samples
	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -8.6593, df = 146, p-value = 8.085e-15
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.6799489 -0.4648548
	sample estimates:
	       cor 
	-0.5825096

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
	med.fit <- lm(ATP ~ NUMPROCESSORS + PK, data = x)
	summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.36920 -0.09539 -0.00229  0.14871  0.49630 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.38990    0.02834  13.755  < 2e-16 ***
	NUMPROCESSORS -0.06440    0.04396  -1.465    0.145    
	PK            -0.26201    0.03018  -8.683 7.34e-15 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1774 on 145 degrees of freedom
	Multiple R-squared:  0.349,	Adjusted R-squared:   0.34 
	F-statistic: 38.86 on 2 and 145 DF,  p-value: 3.068e-14
	
	med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + PK + PCTREAD + PCTREAD:PK, data = x)
	summary(med.fit)

		Call:
		lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + 
		    PK + PCTREAD + PCTREAD:PK, data = x)

		Call:
		lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + 
		    PK + PCTREAD + PCTREAD:PK, data = x)

		Residuals:
		     Min       1Q   Median       3Q      Max 
		-0.42830 -0.10017  0.00194  0.12365  0.50267 

		Coefficients:
				         Estimate Std. Error t value Pr(>|t|)    
		(Intercept)               0.34747    0.06437   5.398 2.78e-07 ***
		NUMPROCESSORS            -0.02578    0.10363  -0.249  0.80388    
		ACTROWPOOL                0.14350    0.09393   1.528  0.12882    
		PK                       -0.29487    0.03966  -7.435 9.27e-12 ***
		PCTREAD                  -0.12776    0.03964  -3.223  0.00158 ** 
		NUMPROCESSORS:ACTROWPOOL -0.05462    0.15672  -0.349  0.72795    
		PK:PCTREAD                0.08964    0.06348   1.412  0.16016    
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.1701 on 141 degrees of freedom
		Multiple R-squared:  0.418,	Adjusted R-squared:  0.3933 
		F-statistic: 16.88 on 6 and 141 DF,  p-value: 1.255e-14

> cor.test(x$PK, x$MAXMPL)
	#### all samples
	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 4.2421, df = 537, p-value = 2.608e-05
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.0970890 0.2605617
	sample estimates:
	      cor 
	0.1800684 

	#### only thrashing samples
	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 1.9917, df = 146, p-value = 0.04827
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.001333675 0.315701911
	sample estimates:
	      cor 
	0.1626425

> cor.test(x$ATP, x$MAXMPL)
	#### all samples
	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = 2.0988, df = 537, p-value = 0.0363
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.0057878 0.1733350
	sample estimates:
	       cor 
	0.09019959 

	#### only thrashing samples
	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -5.8995, df = 146, p-value = 2.437e-08
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.5604164 -0.2985325
	sample estimates:
	       cor 
	-0.4387437

cor.test(x$NUMPROCESSORS, x$MAXMPL)
	#### all samples
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = 2.5458, df = 537, p-value = 0.01118
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.02497562 0.19188733
	sample estimates:
	      cor 
	0.1092012 

	#### only thrashing samples
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = 3.0963, df = 146, p-value = 0.00235
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.09051191 0.39380256
	sample estimates:
	      cor 
	0.2482307

	#### all samples
out.fit <- lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
summary(out.fit)
	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.8652 -0.5113  0.1440  0.3118  0.5014 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.44711    0.05122   8.729  < 2e-16 ***
	PK             0.17966    0.03654   4.917 1.17e-06 ***
	ATP            0.21791    0.05704   3.820 0.000149 ***
	NUMPROCESSORS  0.22920    0.05937   3.860 0.000127 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.4193 on 535 degrees of freedom
	Multiple R-squared:  0.07115,	Adjusted R-squared:  0.06594 
	F-statistic: 13.66 on 3 and 535 DF,  p-value: 1.344e-08

			out.fit <- lm(MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, data = x)
			summary(out.fit)
			Call:
			lm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, 
			    data = x)

			Residuals:
			    Min      1Q  Median      3Q     Max 
			-0.8827 -0.4892  0.1721  0.2987  0.5426 

			Coefficients:
				      Estimate Std. Error t value Pr(>|t|)    
			(Intercept)    0.47027    0.06589   7.137 3.13e-12 ***
			PK             0.17996    0.03651   4.929 1.11e-06 ***
			PCTREAD       -0.06934    0.04152  -1.670 0.095498 .  
			ACTROWPOOL     0.00606    0.06450   0.094 0.925183    
			ATP            0.20722    0.05748   3.605 0.000341 ***
			NUMPROCESSORS  0.22968    0.05934   3.871 0.000122 ***
			---
			Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

			Residual standard error: 0.419 on 533 degrees of freedom
			Multiple R-squared:  0.076,	Adjusted R-squared:  0.06733 
			F-statistic: 8.768 on 5 and 533 DF,  p-value: 5.248e-08

	#### only thrashing samples
	out.fit <- lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
	summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.49105 -0.12868 -0.05987  0.19251  0.45980 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.39086    0.05308   7.363 1.27e-11 ***
	PK            -0.06416    0.04589  -1.398  0.16422    
	ATP           -0.56046    0.10244  -5.471 1.93e-07 ***
	NUMPROCESSORS  0.14888    0.05462   2.726  0.00722 ** 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2188 on 144 degrees of freedom
	Multiple R-squared:  0.2445,	Adjusted R-squared:  0.2288 
	F-statistic: 15.54 on 3 and 144 DF,  p-value: 8.273e-09

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
x = rbind(db2,mysql,oracle,pgsql,sqlserver)
#x <- x[!is.na(x$MAXMPL),]
x$MAXMPL[x$MAXMPL == 1] <- 2
x$MAXMPL[x$MAXMPL < 1] <- 1 ### thrashing
x$MAXMPL[x$MAXMPL == 2] <- 0### no thrashing
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD/min(x$PCTREAD))/(max(x$PCTREAD)/min(x$PCTREAD))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))

library(aod)
library(ggplot2)
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
#out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS + PCTREAD + ACTROWPOOL, family=binomial("probit"), data = x)
summary(out.fit)

wald.test(b = coef(out.fit), Sigma = vcov(out.fit), Terms = 2:4)
Wald test:
----------

Chi-squared test:
X2 = 40.5, df = 3, P(> X2) = 8.2e-09

> 1-out.fit$deviance/out.fit$null.deviance
[1] 0.07044512

#### per-DBMS logistic #####
x = rbind(db2)
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.2120741
x = rbind(mysql)
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.6009419
x = rbind(oracle)
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.1647835
x = rbind(pgsql)
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.06081725
x = rbind(sqlserver)
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.3333082

### update-only
library(aod)
library(ggplot2)
x = read.csv(file="cnfm.dat",head=TRUE,sep="\t")
x$MAXMPL[x$MAXMPL == 1100] <- 10000
# ATP normalization
# db2
db2 <- subset(x, x$DBMS=='db2')
db2_w <- subset(db2, db2$PCTUPDATE!=0)
db2_w <- subset(db2_w, select = -PCTREAD)
db2_w$ATP = (db2_w$ATP-min(db2_w$ATP))/(max(db2_w$ATP)-min(db2_w$ATP))
db2_w$MAXMPL = (db2_w$MAXMPL-min(db2_w$MAXMPL))/(max(db2_w$MAXMPL)-min(db2_w$MAXMPL))
db2 <- db2_w
# oracle
oracle <- subset(x, x$DBMS=='oracle')
oracle_w <- subset(oracle, oracle$PCTUPDATE!=0)
oracle_w <- subset(oracle_w, select = -PCTREAD)
oracle_w$ATP = (oracle_w$ATP-min(oracle_w$ATP))/(max(oracle_w$ATP)-min(oracle_w$ATP))
oracle_w$MAXMPL = (oracle_w$MAXMPL-min(oracle_w$MAXMPL))/(max(oracle_w$MAXMPL)-min(oracle_w$MAXMPL))
oracle <- oracle_w
# mysql
mysql <- subset(x, x$DBMS=='mysql')
mysql_w <- subset(mysql, mysql$PCTUPDATE!=0)
mysql_w <- subset(mysql_w, select = -PCTREAD)
mysql_w$ATP = (mysql_w$ATP-min(mysql_w$ATP))/(max(mysql_w$ATP)-min(mysql_w$ATP))
mysql_w$MAXMPL = (mysql_w$MAXMPL-min(mysql_w$MAXMPL))/(max(mysql_w$MAXMPL)-min(mysql_w$MAXMPL))
mysql <- mysql_w
# pgsql
pgsql <- subset(x, x$DBMS=='pgsql')
pgsql_w <- subset(pgsql, pgsql$PCTUPDATE!=0)
pgsql_w <- subset(pgsql_w, select = -PCTREAD)
pgsql_w$ATP = (pgsql_w$ATP-min(pgsql_w$ATP))/(max(pgsql_w$ATP)-min(pgsql_w$ATP))
pgsql_w$MAXMPL = (pgsql_w$MAXMPL-min(pgsql_w$MAXMPL))/(max(pgsql_w$MAXMPL)-min(pgsql_w$MAXMPL))
pgsql <- pgsql_w
# sqlserver
sqlserver <- subset(x, x$DBMS=='sqlserver')
sqlserver_w <- subset(sqlserver, sqlserver$PCTUPDATE!=0)
sqlserver_w <- subset(sqlserver_w, select = -PCTREAD)
sqlserver_w$ATP = (sqlserver_w$ATP-min(sqlserver_w$ATP))/(max(sqlserver_w$ATP)-min(sqlserver_w$ATP))
sqlserver_w$MAXMPL = (sqlserver_w$MAXMPL-min(sqlserver_w$MAXMPL))/(max(sqlserver_w$MAXMPL)-min(sqlserver_w$MAXMPL))
sqlserver <- sqlserver_w
x = rbind(db2,mysql,oracle,pgsql,sqlserver)
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTUPDATE = (x$PCTUPDATE/min(x$PCTUPDATE))/(max(x$PCTUPDATE)/min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))

nrow(x)
[1] 800
x <- subset(x, x$MAXMPL < 1)
nrow(x)
[1] 334

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
	t = -3.623, df = 332, p-value = 0.0003367
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.29613904 -0.08958263
	sample estimates:
	       cor 
	-0.1950223

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
	t = -3.302, df = 332, p-value = 0.001065
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.28026675 -0.07238599
	sample estimates:
	       cor 
	-0.1783154

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
	    Min      1Q  Median      3Q     Max 
	-0.4461 -0.3215 -0.1280  0.3467  0.7198 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.50196    0.03981  12.608  < 2e-16 ***
	NUMPROCESSORS -0.22179    0.06122  -3.623 0.000337 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3542 on 332 degrees of freedom
	Multiple R-squared:  0.03803,	Adjusted R-squared:  0.03514 
	F-statistic: 13.13 on 1 and 332 DF,  p-value: 0.0003367

		med.fit <- lm(ATP ~ PK + NUMPROCESSORS, data = x)
		summary(med.fit)
		Call:
		lm(formula = ATP ~ PK + NUMPROCESSORS, data = x)

		Residuals:
		    Min      1Q  Median      3Q     Max 
		-0.4580 -0.3358 -0.1182  0.3510  0.7163 

		Coefficients:
			      Estimate Std. Error t value Pr(>|t|)    
		(Intercept)    0.56362    0.04388  12.845  < 2e-16 ***
		PK            -0.12168    0.03856  -3.155 0.001750 ** 
		NUMPROCESSORS -0.21104    0.06050  -3.488 0.000552 ***
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.3495 on 331 degrees of freedom
		Multiple R-squared:  0.06613,	Adjusted R-squared:  0.06048 
		F-statistic: 11.72 on 2 and 331 DF,  p-value: 1.21e-05

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
	t = -3.7311, df = 332, p-value = 0.0002242
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.30143284 -0.09534567
	sample estimates:
	       cor 
	-0.2006076

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
	t = -2.652, df = 332, p-value = 0.008386
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.24751781 -0.03729086
	sample estimates:
	      cor 
	-0.144029

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
	      Min        1Q    Median        3Q       Max 
	-0.039537 -0.020929 -0.005472  0.016778  0.053876 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.044274   0.003222  13.740  < 2e-16 ***
	ATP           -0.016112   0.003653  -4.411 1.39e-05 ***
	NUMPROCESSORS -0.014675   0.004154  -3.533  0.00047 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.02357 on 331 degrees of freedom
	Multiple R-squared:  0.07511,	Adjusted R-squared:  0.06953 
	F-statistic: 13.44 on 2 and 331 DF,  p-value: 2.441e-06

	out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
	summary(out.fit)

		Call:
		lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

		Residuals:
		      Min        1Q    Median        3Q       Max 
		-0.041878 -0.017387 -0.003352  0.017425  0.058191 

		Coefficients:
			       Estimate Std. Error t value Pr(>|t|)    
		(Intercept)    0.050065   0.003561  14.061  < 2e-16 ***
		PK            -0.009233   0.002594  -3.559 0.000427 ***
		ATP           -0.018328   0.003644  -5.030 8.06e-07 ***
		NUMPROCESSORS -0.014351   0.004084  -3.514 0.000503 ***
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.02317 on 330 degrees of freedom
		Multiple R-squared:  0.1093,	Adjusted R-squared:  0.1012 
		F-statistic:  13.5 on 3 and 330 DF,  p-value: 2.499e-08

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
x = rbind(db2,mysql,oracle,pgsql,sqlserver)
x$MAXMPL[x$MAXMPL == 1] <- 2
x$MAXMPL[x$MAXMPL < 1] <- 1 ### thrashing
x$MAXMPL[x$MAXMPL == 2] <- 0### no thrashing
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTUPDATE = (x$PCTUPDATE/min(x$PCTUPDATE))/(max(x$PCTUPDATE)/min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
out.fit <-  glm(MAXMPL ~ ATP + NUMPROCESSORS, data = x)
summary(out.fit)

wald.test(b = coef(out.fit), Sigma = vcov(out.fit), Terms = 2:3)
Wald test:
----------

Chi-squared test:
X2 = 10.9, df = 2, P(> X2) = 0.0042

> 1-out.fit$deviance/out.fit$null.deviance
[1] 0.01354031

###################
x = rbind(db2)
x$MAXMPL[x$MAXMPL == 1] <- 2
x$MAXMPL[x$MAXMPL < 1] <- 1 ### thrashing
x$MAXMPL[x$MAXMPL == 2] <- 0### no thrashing
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
out.fit <-  glm(MAXMPL ~ ATP + NUMPROCESSORS, data = x)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.1514176
x = rbind(mysql)
x$MAXMPL[x$MAXMPL == 1] <- 2
x$MAXMPL[x$MAXMPL < 1] <- 1 ### thrashing
x$MAXMPL[x$MAXMPL == 2] <- 0### no thrashing
out.fit <-  glm(MAXMPL ~ ATP + NUMPROCESSORS, data = x)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.06971828
x = rbind(pgsql)
x$MAXMPL[x$MAXMPL == 1] <- 2
x$MAXMPL[x$MAXMPL < 1] <- 1 ### thrashing
x$MAXMPL[x$MAXMPL == 2] <- 0### no thrashing
out.fit <-  glm(MAXMPL ~ ATP + NUMPROCESSORS, data = x)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.07866522
x = rbind(oracle)
x$MAXMPL[x$MAXMPL == 1] <- 2
x$MAXMPL[x$MAXMPL < 1] <- 1 ### thrashing
x$MAXMPL[x$MAXMPL == 2] <- 0### no thrashing
out.fit <-  glm(MAXMPL ~ ATP + NUMPROCESSORS, data = x)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.4548632
x = rbind(sqlserver)
x$MAXMPL[x$MAXMPL == 1] <- 2
x$MAXMPL[x$MAXMPL < 1] <- 1 ### thrashing
x$MAXMPL[x$MAXMPL == 2] <- 0### no thrashing
out.fit <-  glm(MAXMPL ~ ATP + NUMPROCESSORS, data = x)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.657579
