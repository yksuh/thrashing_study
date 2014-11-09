# Overall: 33.4% (close to suboptimal)
library(aod)
library(ggplot2)
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
#x$MAXMPL[x$MAXMPL == 1100] <- 100000
x$MAXMPL[x$MAXMPL == 1100] <- 10000
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
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD/min(x$PCTREAD))/(max(x$PCTREAD)/min(x$PCTREAD))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))

nrow(x)
[1] 401
x <- subset(x, x$MAXMPL < 1)
nrow(x)
[1] 198

> cor.test(x$NUMPROCESSORS, x$ATP)
	#####  all samples
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -2.3845, df = 399, p-value = 0.01757
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.21397982 -0.02084718
	sample estimates:
	       cor 
	-0.1185344
	
	#####  only thrashing samples
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -1.3103, df = 196, p-value = 0.1916
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.22964570  0.04686212
	sample estimates:
	       cor 
	-0.0931883 	

> cor.test(x$PCTREAD, x$ATP)
	#####  all samples (when 10000 is given to no thrashing)
	Pearson's product-moment correlation

	data:  x$PCTREAD and x$ATP
	t = -0.6234, df = 399, p-value = 0.5334
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1287293  0.0669405
	sample estimates:
		cor 
	-0.03119324 

	#####  only thrashing samples
	Pearson's product-moment correlation

	data:  x$PCTREAD and x$ATP
	t = 0.1638, df = 196, p-value = 0.87
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1279494  0.1508961
	sample estimates:
	       cor 
	0.01170082

> cor.test(x$PK, x$ATP)
	#####  all samples
	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -7.4716, df = 399, p-value = 5.052e-13
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.4334006 -0.2613790
	sample estimates:
	       cor 
	-0.3503407 

	#####  only thrashing samples
	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -5.3771, df = 196, p-value = 2.141e-07
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.4742725 -0.2306318
	sample estimates:
	       cor 
	-0.3585427 

> cor.test(x$PCTREAD*x$PK, x$ATP)
	#####  all thrashing samples
	Pearson's product-moment correlation

	data:  x$PCTREAD * x$PK and x$ATP
	t = -3.8304, df = 399, p-value = 0.0001486
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.28107220 -0.09209592
	sample estimates:
	       cor 
	-0.1883267

	#####  only thrashing samples
	Pearson's product-moment correlation

	data:  x$PCTREAD * x$PK and x$ATP
	t = -3.2558, df = 196, p-value = 0.001332
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.35475025 -0.08991213
	sample estimates:
	       cor 
	-0.2265137 

med.fit <- lm(ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK, data = x)
summary(med.fit)
	#####  all samples
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.38983 -0.16678 -0.09557  0.22106  0.86543 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.40162    0.03208  12.520  < 2e-16 ***
	NUMPROCESSORS -0.09029    0.04189  -2.155   0.0317 *  
	PK            -0.22177    0.03776  -5.873 9.08e-09 ***
	PCTREAD       -0.02616    0.04581  -0.571   0.5683    
	PK:PCTREAD     0.01310    0.06666   0.196   0.8443    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2939 on 396 degrees of freedom
	Multiple R-squared:  0.134,	Adjusted R-squared:  0.1252 
	F-statistic: 15.31 on 4 and 396 DF,  p-value: 1.182e-11

	#####  only thrashing samples
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.49894 -0.19359 -0.04431  0.18873  0.79324 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.46835    0.04396  10.655  < 2e-16 ***
	NUMPROCESSORS -0.12843    0.06842  -1.877 0.062030 .  
	PK            -0.24476    0.06358  -3.850 0.000161 ***
	PCTREAD        0.04689    0.05830   0.804 0.422244    
	PK:PCTREAD    -0.05457    0.10474  -0.521 0.602933    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3034 on 193 degrees of freedom
	Multiple R-squared:  0.1468,	Adjusted R-squared:  0.1292 
	F-statistic: 8.305 on 4 and 193 DF,  p-value: 3.351e-06

	##### Alternative
	med.fit <- lm(ATP ~ NUMPROCESSORS + PK, data = x)
	summary(med.fit)
	
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.3811 -0.1637 -0.1027  0.2229  0.8699 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.39273    0.02796  14.047  < 2e-16 ***
	NUMPROCESSORS -0.09107    0.04178  -2.179   0.0299 *  
	PK            -0.21713    0.02937  -7.392 8.58e-13 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2933 on 398 degrees of freedom
	Multiple R-squared:  0.1331,	Adjusted R-squared:  0.1287 
	F-statistic: 30.55 on 2 and 398 DF,  p-value: 4.543e-13

#x <- subset(x, x$MAXMPL < 1)
> cor.test(x$PK, x$MAXMPL)
	#####  all samples
	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 7.9243, df = 399, p-value = 2.309e-14
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.2809716 0.4504183
	sample estimates:
	      cor 
	0.3687545  

	#####  only thrashing samples
	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 4.2287, df = 196, p-value = 3.604e-05
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.1559954 0.4119782
	sample estimates:
	      cor 
	0.2891473 

cor.test(x$ATP, x$MAXMPL)
	#####  all samples
	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -7.2255, df = 399, p-value = 2.555e-12
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.4239652 -0.2505766
	sample estimates:
	       cor 
	-0.3401588 

	#####  only thrashing samples
	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = 0.2956, df = 196, p-value = 0.7679
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1186845  0.1600766
	sample estimates:
	       cor 
	0.02110625

cor.test(x$NUMPROCESSORS, x$MAXMPL)
	#####  all samples
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = 3.6123, df = 399, p-value = 0.0003422
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.08144449 0.27115821
	sample estimates:
	      cor 
	0.1779544 

	#####  only thrashing samples
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = 1.1897, df = 196, p-value = 0.2356
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.05542261  0.22149949
	sample estimates:
	       cor 
	0.08467324

cor.test(x$ACTROWPOOL, x$MAXMPL)
	#####  all samples
	Pearson's product-moment correlation

	data:  x$ACTROWPOOL and x$MAXMPL
	t = -0.7982, df = 399, p-value = 0.4253
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.13731815  0.05823113
	sample estimates:
	       cor 
	-0.0399258
	
	##### only thrashing samples
	Pearson's product-moment correlation

	data:  x$ACTROWPOOL and x$MAXMPL
	t = -1.8057, df = 196, p-value = 0.0725
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.26267638  0.01173036
	sample estimates:
	       cor 
	-0.1279204 

> cor.test(x$PCTREAD, x$MAXMPL)
	#####  all samples
	Pearson's product-moment correlation

	data:  x$PCTREAD and x$MAXMPL
	t = -0.5309, df = 399, p-value = 0.5958
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.12417395  0.07154764
	sample estimates:
		cor 
	-0.02656777

out.fit <- lm(MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	#####  all samples
	Call:
	lm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, 
	    data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.8294 -0.3684  0.1236  0.3156  0.8893 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.42055    0.07240   5.809 1.30e-08 ***
	PK             0.27681    0.04674   5.923 6.88e-09 ***
	PCTREAD       -0.05229    0.04958  -1.055  0.29220    
	ACTROWPOOL    -0.03229    0.07861  -0.411  0.68151    
	ATP           -0.34940    0.07498  -4.660 4.34e-06 ***
	NUMPROCESSORS  0.19238    0.06273   3.067  0.00231 ** 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.4375 on 395 degrees of freedom
	Multiple R-squared:  0.2079,	Adjusted R-squared:  0.1979 
	F-statistic: 20.74 on 5 and 395 DF,  p-value: < 2.2e-16

	#####  thrashing samples
	Call:
	lm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.40790 -0.17473 -0.04705  0.16753  0.58213 

	Coefficients:
		        Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.1884842  0.0548826   3.434 0.000728 ***
	PK             0.1839099  0.0373362   4.926 1.81e-06 ***
	PCTREAD       -0.0008194  0.0351120  -0.023 0.981407    
	ACTROWPOOL    -0.1018733  0.0569082  -1.790 0.075008 .  
	ATP            0.1142892  0.0520402   2.196 0.029277 *  
	NUMPROCESSORS  0.0859572  0.0502261   1.711 0.088621 .  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2195 on 192 degrees of freedom
	Multiple R-squared:  0.1325,	Adjusted R-squared:  0.1099 
	F-statistic: 5.865 on 5 and 192 DF,  p-value: 4.553e-05

	#### when MAXMPL is given as 10K
	Call:
	lm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, 
	    data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.8662 -0.3825  0.1312  0.3229  0.9120 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.40973    0.07415   5.526 5.96e-08 ***
	PK             0.27656    0.04786   5.778 1.53e-08 ***
	PCTREAD       -0.05413    0.05077  -1.066  0.28700    
	ACTROWPOOL    -0.02794    0.08051  -0.347  0.72874    
	ATP           -0.36297    0.07679  -4.727 3.18e-06 ***
	NUMPROCESSORS  0.19492    0.06424   3.034  0.00257 ** 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.448 on 395 degrees of freedom
	Multiple R-squared:  0.2051,	Adjusted R-squared:  0.195 
	F-statistic: 20.38 on 5 and 395 DF,  p-value: < 2.2e-16

#### assumptions
library(car)
outlierTest(out.fit)

No Studentized residuals with Bonferonni p < 0.05
Largest |rstudent|:
    rstudent unadjusted p-value Bonferonni p
730 2.066567           0.039428           NA

pdf("new_normal_res_qqplot.pdf")
qqnorm(out.fit$res,main="",xlim=c(0,1), ylim=c(0,1)); qqline(out.fit$res);
dev.off()
pdf("new_normal_res_hist.pdf")
h <- hist(out.fit$res,main="",xlab="Residuals",ylim=c(0,80))
xfit<-seq(min(out.fit$res),max(out.fit$res),length=40) 
yfit<-dnorm(xfit,mean=mean(out.fit$res),sd=sd(out.fit$res)) 
yfit <- yfit*diff(h$mids[1:2])*length(out.fit$res) 
lines(xfit, yfit, col="blue")
dev.off()

# Evaluate homoscedasticity
# non-constant error variance test
> ncvTest(out.fit)
spreadLevelPlot(out.fit, main="Homoscedasticity Test")
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 0.1435765    Df = 1     p = 0.704751

# Evaluate Collinearity
vif(out.fit) # variance inflation factors 
sqrt(vif(out.fit)) > 2 # problem?

# Evaluate Nonlinearity
# component + residual plot 
crPlots(out.fit, main = "")

durbinWatsonTest(out.fit)
	 lag Autocorrelation D-W Statistic p-value
	   1       0.4246894      1.146497       0
	 Alternative hypothesis: rho != 0
dwtest(out.fit, alternative="two.sided")

#### thrashing or not thrashing
x = rbind(db2,mysql,oracle,pgsql,sqlserver)
x$MAXMPL[x$MAXMPL < 1] <- 0
x$MAXMPL[x$MAXMPL == 1] <- 2
x$MAXMPL[x$MAXMPL < 1] <- 1 ### thrashing
x$MAXMPL[x$MAXMPL == 2] <- 0### no thrashing
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD/min(x$PCTREAD))/(max(x$PCTREAD)/min(x$PCTREAD))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))

#out.fit <-  glm(MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, family="gaussian", data = x)
#out.fit <-  glm(MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, family=gaussian(link = "identity"), data = x)
#out.fit <-  glm(MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, family=binomial("logit"), data = x)
out.fit <-  glm(MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, family=binomial("probit"), data = x)
summary(out.fit)

	Call:
	glm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, 
	    family = binomial("probit"), data = x)

	Deviance Residuals: 
	    Min       1Q   Median       3Q      Max  
	-2.0619  -0.8712  -0.5619   0.9602   1.9737  

	Coefficients:
		      Estimate Std. Error z value Pr(>|z|)    
	(Intercept)    0.25438    0.21940   1.159  0.24628    
	PK            -0.75820    0.14040  -5.400 6.65e-08 ***
	PCTREAD        0.18353    0.15280   1.201  0.22972    
	ACTROWPOOL     0.07895    0.24189   0.326  0.74412    
	ATP            1.04929    0.23139   4.535 5.77e-06 ***
	NUMPROCESSORS -0.58779    0.19307  -3.044  0.00233 ** 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	(Dispersion parameter for binomial family taken to be 1)

	    Null deviance: 555.84  on 400  degrees of freedom
	Residual deviance: 467.48  on 395  degrees of freedom
	AIC: 479.48

	Number of Fisher Scoring iterations: 4

wald.test(b = coef(out.fit), Sigma = vcov(out.fit), Terms = 2:6)
Wald test:
----------

Chi-squared test:
X2 = 79.0, df = 5, P(> X2) = 1.3e-15

> 1-out.fit$deviance/out.fit$null.deviance
[1] 0.16
###########################################################################################################################

#### update-only
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
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
[1] 608
x <- subset(x, x$MAXMPL < 1)
nrow(x)
[1] 301

cor.test(x$NUMPROCESSORS, x$ATP)
cor.test(x$PCTUPDATE, x$ATP)
	#####  all samples 

cor(x$NUMPROCESSORS, x$ATP)
-0.33

cor(x$PCTUPDATE, x$ATP)
-0.01

cor(x$PK, x$ATP)
0.18

cor(x$PCTUPDATE*x$PK, x$ATP)
0.13

med.fit <- lm(ATP ~ NUMPROCESSORS + PK + PCTUPDATE + PCTUPDATE:PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK + PCTUPDATE + PCTUPDATE:PK, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.38504 -0.23347 -0.08478  0.15969  0.85814 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.28748    0.04505   6.382 6.74e-10 ***
	NUMPROCESSORS -0.27942    0.04401  -6.348 8.16e-10 ***
	PK             0.14174    0.05718   2.479   0.0137 *  
	PCTUPDATE      0.02171    0.06477   0.335   0.7378    
	PK:PCTUPDATE  -0.02964    0.09007  -0.329   0.7424    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2954 on 296 degrees of freedom
	Multiple R-squared:  0.1498,	Adjusted R-squared:  0.1383 
	F-statistic: 13.04 on 4 and 296 DF,  p-value: 8.558e-10

cor(x$PK, x$MAXMPL)
[1] 0.08220043

cor(x$ATP, x$MAXMPL)
[1] -0.02

cor(x$NUMPROCESSORS, x$MAXMPL)
[1] -0.23

cor(x$ACTROWPOOL, x$MAXMPL)
[1] -0.07

cor(x$PCTUPDATE, x$MAXMPL)
[1] -0.009013733

out.fit <- lm(MAXMPL ~ PK + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.48433 -0.24118  0.08279  0.19517  0.48709 

	Coefficients:
		        Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.4476441  0.0406450  11.013  < 2e-16 ***
	PK             0.0634629  0.0299860   2.116   0.0351 *  
	PCTUPDATE      0.0001043  0.0386918   0.003   0.9979    
	ACTROWPOOL    -0.0478991  0.0395205  -1.212   0.2265    
	ATP           -0.1026376  0.0500943  -2.049   0.0414 *  
	NUMPROCESSORS -0.1867884  0.0402880  -4.636 5.33e-06 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2539 on 295 degrees of freedom
	Multiple R-squared:  0.08012,	Adjusted R-squared:  0.06453 
	F-statistic: 5.139 on 5 and 295 DF,  p-value: 0.0001549

#### thrashing or not thrashing
x = rbind(db2,mysql,oracle,pgsql,sqlserver)
x$MAXMPL[x$MAXMPL == 1] <- 2
x$MAXMPL[x$MAXMPL < 1] <- 1 ### thrashing
x$MAXMPL[x$MAXMPL == 2] <- 0### no thrashing
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTUPDATE = (x$PCTUPDATE/min(x$PCTUPDATE))/(max(x$PCTUPDATE)/min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))

#out.fit <-  glm(MAXMPL ~ PK + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, family="gaussian", data = x)
#out.fit <-  glm(MAXMPL ~ PK + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, family=gaussian(link = "identity"), data = x)
out.fit <-  glm(MAXMPL ~ PK + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, family=binomial("probit"), data = x)
#out.fit <-  glm(MAXMPL ~ PK + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, family=binomial("logit"), data = x)
summary(out.fit)

	Call:
	glm(formula = MAXMPL ~ PK + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, 
	    family = binomial("probit"), data = x)

	Deviance Residuals: 
	   Min      1Q  Median      3Q     Max  
	-1.449  -1.161  -0.896   1.143   1.555  

	Coefficients:
		      Estimate Std. Error z value Pr(>|z|)   
	(Intercept)   -0.32732    0.19498  -1.679  0.09320 . 
	PK             0.06753    0.10239   0.660  0.50954   
	PCTUPDATE      0.18505    0.18369   1.007  0.31373   
	ACTROWPOOL     0.28812    0.18302   1.574  0.11542   
	ATP           -0.44943    0.17380  -2.586  0.00971 **
	NUMPROCESSORS  0.23929    0.15464   1.547  0.12176   
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	(Dispersion parameter for binomial family taken to be 1)

	    Null deviance: 842.81  on 607  degrees of freedom
	Residual deviance: 828.68  on 602  degrees of freedom
	AIC: 840.68

	Number of Fisher Scoring iterations: 4

wald.test(b = coef(out.fit), Sigma = vcov(out.fit), Terms = 2:6)
Wald test:
----------

Chi-squared test:
X2 = 13.8, df = 5, P(> X2) = 0.017

1-out.fit$deviance/out.fit$null.deviance
[1] 0.02

###########################################################################################################################
