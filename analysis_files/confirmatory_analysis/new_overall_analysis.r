# Overall: 33.4% (close to suboptimal)
library(aod)
library(ggplot2)
x = read.csv(file="new_cnfm.dat",head=TRUE,sep="\t")
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
pgsql_r$MAXMPL <- 1
pgsql <- pgsql_r
# sqlserver
sqlserver <- subset(x, x$DBMS=='sqlserver')
sqlserver_r <- subset(sqlserver, sqlserver$PCTREAD!=0)
sqlserver_r <- subset(sqlserver_r, select = -PCTUPDATE)
sqlserver_r$ATP = (sqlserver_r$ATP-min(sqlserver_r$ATP))/(max(sqlserver_r$ATP)-min(sqlserver_r$ATP))
#sqlserver_r$MAXMPL = (sqlserver_r$MAXMPL-min(sqlserver_r$MAXMPL))/(max(sqlserver_r$MAXMPL)-min(sqlserver_r$MAXMPL))
sqlserver_r$MAXMPL <- 1
sqlserver <- sqlserver_r
#### gother each DBMS' samples
x = rbind(db2,mysql,oracle,pgsql,sqlserver)
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD/min(x$PCTREAD))/(max(x$PCTREAD)/min(x$PCTREAD))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
nrow(x)
[1] 291
x <- subset(x, x$MAXMPL < 1)
nrow(x)
[1] 44

> cor.test(x$NUMPROCESSORS, x$ATP)
	##### all  samples
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -7.4493, df = 289, p-value = 1.09e-12
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.4935587 -0.3002281
	sample estimates:
	       cor 
	-0.4013544

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = 0.7373, df = 42, p-value = 0.4651
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1902283  0.3966068
	sample estimates:
	      cor 
	0.1130357

> cor.test(x$PK, x$ATP)
	#####  all  samples
	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -0.7478, df = 289, p-value = 0.4552
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.15812935  0.07139481
	sample estimates:
		cor 
	-0.04394717

	#### only thrashing samples
	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -2.7087, df = 42, p-value = 0.009732
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.6124030 -0.1002298
	sample estimates:
	       cor 
	-0.3856351 

med.fit <- lm(ATP ~ NUMPROCESSORS + PK, data = x)
summary(med.fit)

	#### all samples
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.43223 -0.25695 -0.04391  0.13844  0.73125 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.53869    0.04564  11.802  < 2e-16 ***
	NUMPROCESSORS -0.44379    0.05891  -7.533 6.42e-13 ***
	PK            -0.05098    0.03824  -1.333    0.183    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.323 on 288 degrees of freedom
	Multiple R-squared:  0.1662,	Adjusted R-squared:  0.1604 
	F-statistic: 28.71 on 2 and 288 DF,  p-value: 4.271e-12

	#### only thrashing samples
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.2753 -0.1251 -0.0554  0.1058  0.5843 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.27065    0.06617   4.090 0.000196 ***
	NUMPROCESSORS  0.01407    0.10732   0.131 0.896311    
	PK            -0.16444    0.06417  -2.563 0.014158 *  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2055 on 41 degrees of freedom
	Multiple R-squared:  0.1491,	Adjusted R-squared:  0.1076 
	F-statistic: 3.591 on 2 and 41 DF,  p-value: 0.03654


> cor.test(x$PK, x$MAXMPL)
	#### all samples
	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 0.6281, df = 289, p-value = 0.5304
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.07839225  0.15126084
	sample estimates:
	       cor 
	0.03692177 

	#### only thrashing samples
	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 1.2193, df = 42, p-value = 0.2295
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1184889  0.4567065
	sample estimates:
	      cor 
	0.1848956 

cor.test(x$ATP, x$MAXMPL)
	#### all samples
	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = 0.9476, df = 289, p-value = 0.3441
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.05970753  0.16955197
	sample estimates:
	       cor 
	0.05565578 

	#### only thrashing samples
	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -1.5453, df = 42, p-value = 0.1298
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.49475240  0.06974286
	sample estimates:
	       cor 
	-0.2319399

cor.test(x$NUMPROCESSORS, x$MAXMPL)
	#### all samples
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = 4.4494, df = 289, p-value = 1.231e-05
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.1423616 0.3577639
	sample estimates:
	      cor 
	0.2531983

	#### only thrashing samples
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = -0.599, df = 42, p-value = 0.5524
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.3785685  0.2106030
	sample estimates:
		cor 
	-0.09203156 

	#### all samples
out.fit <- lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.92659  0.00927  0.07399  0.11657  0.28185 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.67240    0.04442  15.138  < 2e-16 ***
	PK             0.03725    0.03064   1.216  0.22515    
	ATP            0.14826    0.04708   3.149  0.00181 ** 
	NUMPROCESSORS  0.28104    0.05149   5.458 1.04e-07 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2581 on 287 degrees of freedom
	Multiple R-squared:  0.09824,	Adjusted R-squared:  0.08881 
	F-statistic: 10.42 on 3 and 287 DF,  p-value: 1.574e-06

	#### only thrashing samples
	out.fit <- lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
	summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.35066 -0.19775  0.00788  0.15996  0.58738 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)   
	(Intercept)    0.32023    0.09631   3.325   0.0019 **
	PK             0.05025    0.08478   0.593   0.5567   
	ATP           -0.21187    0.19156  -1.106   0.2753   
	NUMPROCESSORS -0.03231    0.13166  -0.245   0.8074   
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.252 on 40 degrees of freedom
	Multiple R-squared:  0.06312,	Adjusted R-squared:  -0.007141 
	F-statistic: 0.8984 on 3 and 40 DF,  p-value: 0.4505

### mediation analysis
library(mediation)
med.fit <- lm(ATP ~ NUMPROCESSORS + PK, data = x)
out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	### All samples
	med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
	summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            -0.0654      -0.1158      -0.0225       0
	ADE              0.2798       0.1772       0.3867       0
	Total Effect     0.2144       0.1190       0.3104       0
	Prop. Mediated  -0.2974      -0.7159      -0.0969       0

	Sample Size Used: 291 


	Simulations: 1000

	med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK")
	summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.00769     -0.02257      0.00397    0.17
	ADE             0.03739     -0.02564      0.09593    0.20
	Total Effect    0.02970     -0.03363      0.08763    0.32
	Prop. Mediated -0.13854     -2.63724      2.79082    0.47

	Sample Size Used: 291 


	Simulations: 1000


	Simulations: 1000 

	### thrashing samples
	med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
	summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            -0.0737      -0.1181      -0.0351    0.00
	ADE              0.1372       0.0203       0.2496    0.03
	Total Effect     0.0634      -0.0481       0.1728    0.23
	Prop. Mediated  -0.9322     -11.3179      12.4926    0.23

	Sample Size Used: 539 


	Simulations: 1000

	med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK")
	summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.01956     -0.03878     -0.00591       0
	ADE             0.13183      0.05880      0.20295       0
	Total Effect    0.11228      0.03809      0.18412       0
	Prop. Mediated -0.16933     -0.67014     -0.04660       0

	Sample Size Used: 539 


	Simulations: 1000 


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

#### thrashing or not thrashing
x = rbind(db2,mysql,oracle,pgsql,sqlserver)
#x = rbind(db2,mysql,oracle,pgsql)
x <- x[!is.na(x$MAXMPL),]
x$MAXMPL[x$MAXMPL == 1] <- 2
x$MAXMPL[x$MAXMPL < 1] <- 1 ### thrashing
x$MAXMPL[x$MAXMPL == 2] <- 0### no thrashing
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD/min(x$PCTREAD))/(max(x$PCTREAD)/min(x$PCTREAD))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))

library(aod)
library(ggplot2)
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS, family=binomial("probit"), data = x)
summary(out.fit)

wald.test(b = coef(out.fit), Sigma = vcov(out.fit), Terms = 2:4)
Wald test:
----------

Chi-squared test:
X2 = 30.0, df = 3, P(> X2) = 1.4e-06

> 1-out.fit$deviance/out.fit$null.deviance
[1] 0.1409796

### update-only
library(aod)
library(ggplot2)
x = read.csv(file="new_cnfm.dat",head=TRUE,sep="\t")
#x$MAXMPL[x$MAXMPL == 1100] <- 10000
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
[1] 568
x <- subset(x, x$MAXMPL < 1)
nrow(x)
[1] 202

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
	t = -2.7149, df = 200, p-value = 0.007209
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.31829859 -0.05182994
	sample estimates:
	      cor 
	-0.188532

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
	t = -1.7193, df = 200, p-value = 0.0871
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.25449723  0.01765884
	sample estimates:
	       cor 
	-0.1206864

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
	-0.4377 -0.2964 -0.2358  0.3435  0.7590 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.46626    0.05017   9.294  < 2e-16 ***
	NUMPROCESSORS -0.22523    0.08296  -2.715  0.00721 ** 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3569 on 200 degrees of freedom
	Multiple R-squared:  0.03554,	Adjusted R-squared:  0.03072 
	F-statistic: 7.371 on 1 and 200 DF,  p-value: 0.007209


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
	t = -0.7633, df = 200, p-value = 0.4462
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.19052679  0.08478852
	sample estimates:
		cor 
	-0.05389331

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
	t = -1.5793, df = 200, p-value = 0.1159
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2452753  0.0274900
	sample estimates:
	       cor 
	-0.1109822

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
	out.fit <- lm(MAXMPL ~ PK, data = x)
	summary(out.fit)
	
	Call:
	lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.35654 -0.22798 -0.02711  0.19299  0.44149 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.37925    0.03932   9.646   <2e-16 ***
	ATP           -0.05023    0.04631  -1.085   0.2794    
	NUMPROCESSORS -0.09716    0.05532  -1.756   0.0806 .  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2338 on 199 degrees of freedom
	Multiple R-squared:  0.01812,	Adjusted R-squared:  0.008253 
	F-statistic: 1.836 on 2 and 199 DF,  p-value: 0.1621

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

#### thrashing or not thrashing
x = rbind(db2,mysql,oracle,pgsql,sqlserver)
x$MAXMPL[x$MAXMPL == 1] <- 2
x$MAXMPL[x$MAXMPL < 1] <- 1 ### thrashing
x$MAXMPL[x$MAXMPL == 2] <- 0### no thrashing
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTUPDATE = (x$PCTUPDATE/min(x$PCTUPDATE))/(max(x$PCTUPDATE)/min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
out.fit <-  glm(MAXMPL ~ ATP + NUMPROCESSORS, family=binomial("probit"), data = x)
summary(out.fit)

wald.test(b = coef(out.fit), Sigma = vcov(out.fit), Terms = 2:3)
Wald test:
----------

Chi-squared test:
X2 = 6.0, df = 2, P(> X2) = 0.049

> 1-out.fit$deviance/out.fit$null.deviance
[1] 0.008187021
