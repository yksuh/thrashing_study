# Overall: 33.4% (close to suboptimal)
library(aod)
library(ggplot2)
x = read.csv(file="revised_cnfm.dat",head=TRUE,sep="\t")
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
#sqlserver_r$MAXMPL <- 1
sqlserver <- sqlserver_r
#### gother each DBMS' samples
x = rbind(db2,mysql,oracle,pgsql,sqlserver)
#x = rbind(db2,mysql,oracle,pgsql)
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD/min(x$PCTREAD))/(max(x$PCTREAD)/min(x$PCTREAD))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
nrow(x)
[1] 539
x <- subset(x, x$MAXMPL < 1)
> nrow(x)
[1] 150

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
	t = -0.8434, df = 148, p-value = 0.4004
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.22690552  0.09212368
	sample estimates:
	       cor 
	-0.0691589

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
	t = -7.4051, df = 148, p-value = 9.19e-12
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.6278886 -0.3923823
	sample estimates:
	       cor 
	-0.5199476

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
	-0.35282 -0.11545  0.01524  0.15311  0.48003 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.36678    0.02898  12.657  < 2e-16 ***
	NUMPROCESSORS -0.04439    0.04477  -0.991    0.323    
	PK            -0.22764    0.03074  -7.406 9.39e-12 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1814 on 147 degrees of freedom
	Multiple R-squared:  0.2752,	Adjusted R-squared:  0.2653 
	F-statistic: 27.91 on 2 and 147 DF,  p-value: 5.326e-11
		
> cor.test(x$PK, x$MAXMPL)
	#### all samples
	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 3.06, df = 537, p-value = 0.002324
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.04697483 0.21301212
	sample estimates:
	      cor 
	0.1309114

	#### only thrashing samples
	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 3.6672, df = 148, p-value = 0.0003413
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.1345769 0.4290310
	sample estimates:
	      cor 
	0.2886138

cor.test(x$ATP, x$MAXMPL)
	#### all samples
	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = 2.8526, df = 537, p-value = 0.004504
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.03811297 0.20452113
	sample estimates:
	      cor 
	0.1221756

	#### only thrashing samples
	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -6.4809, df = 148, p-value = 1.274e-09
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.5862604 -0.3351678
	sample estimates:
	       cor 
	-0.4701741 

cor.test(x$NUMPROCESSORS, x$MAXMPL)
	#### all samples
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = 0.9968, df = 537, p-value = 0.3193
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.0416309  0.1269711
	sample estimates:
	       cor 
	0.0429760

	#### only thrashing samples
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = 2.7549, df = 148, p-value = 0.006608
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.06282196 0.36809264
	sample estimates:
	      cor 
	0.2208599

	#### all samples
out.fit <- lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.8218 -0.5123  0.1874  0.2845  0.4159 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.54578    0.05038  10.833  < 2e-16 ***
	PK             0.13148    0.03594   3.659 0.000279 ***
	ATP            0.21733    0.05610   3.874 0.000120 ***
	NUMPROCESSORS  0.13536    0.05840   2.318 0.020828 *  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.4124 on 535 degrees of freedom
	Multiple R-squared:  0.04617,	Adjusted R-squared:  0.04082 
	F-statistic: 8.632 on 3 and 535 DF,  p-value: 1.329e-05

	#### only thrashing samples
out.fit <- lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.50568 -0.10339 -0.03047  0.19286  0.43917 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.33057    0.04988   6.627 6.18e-10 ***
	PK             0.03609    0.04289   0.842  0.40143    
	ATP           -0.49387    0.09822  -5.028 1.43e-06 ***
	NUMPROCESSORS  0.14370    0.05349   2.686  0.00806 ** 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.216 on 146 degrees of freedom
	Multiple R-squared:  0.2603,	Adjusted R-squared:  0.2451 
	F-statistic: 17.13 on 3 and 146 DF,  p-value: 1.391e-09

### mediation analysis
library(mediation)
out.fit <- lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
med.fit <- lm(ATP ~ NUMPROCESSORS + PK, data = x)

	### All samples
	med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
	summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            -0.0732      -0.1161      -0.0360    0.00
	ADE              0.1337       0.0207       0.2491    0.02
	Total Effect     0.0605      -0.0449       0.1716    0.27
	Prop. Mediated  -0.9179     -13.0938      11.9227    0.27

	Sample Size Used: 539 


	Simulations: 1000

	med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK")
	summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.01953     -0.03810     -0.00593       0
	ADE             0.13104      0.05830      0.20125       0
	Total Effect    0.11152      0.03998      0.18048       0
	Prop. Mediated -0.16683     -0.62948     -0.04378       0

	Sample Size Used: 539 


	Simulations: 1000 

	### thrashing samples
	med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
	summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME             0.0221      -0.0184       0.0614    0.29
	ADE              0.1424       0.0386       0.2458    0.01
	Total Effect     0.1645       0.0573       0.2752    0.00
	Prop. Mediated   0.1263      -0.2048       0.4560    0.29

	Sample Size Used: 150 


	Simulations: 1000

	med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK")
	summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME             0.1143       0.0648       0.1705    0.00
	ADE              0.0342      -0.0468       0.1190    0.41
	Total Effect     0.1485       0.0753       0.2270    0.00
	Prop. Mediated   0.7686       0.3866       1.5676    0.00

	Sample Size Used: 150 


	Simulations: 1000 

### assumption testing #####
library(car)
out.fit <- lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
outlierTest(out.fit)
#pdf("new_normales_qqplot.pdf")
qqnorm(out.fit$res,main="",ylim=c(-0.8,0.6)); qqline(out.fit$res);
#dev.off()
pdf("read_normal_res.pdf")
h <- hist(out.fit$res,main="",xlab="Residuals",ylim=c(0,35),xlim=c(-0.06,0.06))
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
	Chisquare = 2.859574    Df = 1     p = 0.09083153

# Evaluate Collinearity
vif(out.fit) # variance inflation factors 
           PK           ATP NUMPROCESSORS 
     1.448892      1.440991      1.007356 

sqrt(vif(out.fit)) > 2 # problem?
           PK           ATP NUMPROCESSORS 
     1.203699      1.200413      1.003671

# Evaluate Nonlinearity
# component + residual plot 
pdf("linearity_assumption_testesult.pdf")
crPlots(out.fit, main = "",)
dev.off()

# Test for Autocorrelated Errors
durbinWatsonTest(out.fit)
	 lag Autocorrelation D-W Statistic p-value
	   1       0.1900665       1.59948   0.012
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
X2 = 27.7, df = 3, P(> X2) = 4.1e-06

> 1-out.fit$deviance/out.fit$null.deviance
[1] 0.04930364

#### per-DBMS logistic #####
x = rbind(db2)
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.1409115
x = rbind(mysql)
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.5069013
x = rbind(oracle)
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.09636701
x = rbind(pgsql)
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.0414784
x = rbind(sqlserver)
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.3333084

### update-only
library(aod)
library(ggplot2)
x = read.csv(file="revised_cnfm.dat",head=TRUE,sep="\t")
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
[1] 335

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
	t = -3.0799, df = 333, p-value = 0.002243
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2687849 -0.0603462
	sample estimates:
	       cor 
	-0.1664241 

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
	t = -2.8239, df = 333, p-value = 0.005029
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.25589127 -0.04653917
	sample estimates:
	       cor 
	-0.1529306

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
	-0.4499 -0.3392 -0.1895  0.3707  0.6968 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.50007    0.04159   12.02  < 2e-16 ***
	NUMPROCESSORS -0.19685    0.06392   -3.08  0.00224 ** 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.37 on 333 degrees of freedom
	Multiple R-squared:  0.0277,	Adjusted R-squared:  0.02478 
	F-statistic: 9.486 on 1 and 333 DF,  p-value: 0.002243

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
	t = -2.6388, df = 333, p-value = 0.00871
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2464931 -0.0365254
	sample estimates:
	       cor 
	-0.1431193

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
	t = -1.8417, df = 333, p-value = 0.06641
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.205357269  0.006814555
	sample estimates:
	       cor 
	-0.1004128

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
	-0.038392 -0.023364 -0.001861  0.022683  0.047400 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.041418   0.003196  12.959  < 2e-16 ***
	ATP           -0.010580   0.003517  -3.009  0.00282 ** 
	NUMPROCESSORS -0.009727   0.004160  -2.339  0.01995 *  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.02374 on 332 degrees of freedom
	Multiple R-squared:  0.03636,	Adjusted R-squared:  0.03055 
	F-statistic: 6.263 on 2 and 332 DF,  p-value: 0.002139

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
	ACME            0.00355      0.00142      0.00634    0.00
	ADE            -0.01474     -0.02270     -0.00627    0.00
	Total Effect   -0.01119     -0.01914     -0.00285    0.01
	Prop. Mediated -0.30386     -1.17028     -0.09231    0.01

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
	Chisquare = 2.859574    Df = 1     p = 0.6292605

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
X2 = 10.8, df = 2, P(> X2) = 0.0045

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
