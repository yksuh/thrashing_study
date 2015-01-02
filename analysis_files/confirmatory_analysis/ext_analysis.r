# Overall: 33.4% (close to suboptimal)
library(aod)
library(ggplot2)
x = read.csv(file="extcnfm.dat",head=TRUE,sep="\t")
#> nrow(x)
#[1] 253
x_r <- subset(x, x$PCTREAD!=0)
x_r <- subset(x_r, select = -PCTUPDATE)
x <- x_r
nrow(x)
#[1] 102
x <- subset(x, x$ATP < 120000)
#[1] 526
x <- subset(x, x$MAXMPL < 1100)
#nrow(x)
#[1] 34
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
	t = 0.3345, df = 32, p-value = 0.7402
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2848175  0.3894256
	sample estimates:
	       cor 
	0.05903415

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
	t = -3.2303, df = 32, p-value = 0.00286
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.7142766 -0.1895027
	sample estimates:
	       cor 
	-0.4958902	

# Stepwise Regression
library(MASS)	
out.fit <- lm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, data = x)
step <- stepAIC(out.fit, direction="both")

med.fit <- lm(ATP ~ NUMPROCESSORS + PK, data = x)
summary(med.fit)

	#### only thrashing samples
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.52910 -0.18727 -0.04391  0.21324  0.81172 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.59163    0.11334   5.220 1.14e-05 ***
	NUMPROCESSORS -0.06253    0.13754  -0.455  0.65256    
	PK            -0.39553    0.12361  -3.200  0.00317 ** 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3385 on 31 degrees of freedom
	Multiple R-squared:  0.2509,	Adjusted R-squared:  0.2026 
	F-statistic: 5.192 on 2 and 31 DF,  p-value: 0.01136

> cor.test(x$PK, x$MAXMPL)
	#### only thrashing samples
	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = -2.6237, df = 32, p-value = 0.01322
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.66439186 -0.09629627
	sample estimates:
	       cor 
	-0.4207603

> cor.test(x$ATP, x$MAXMPL)
	#### only thrashing samples
	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = 1.5408, df = 32, p-value = 0.1332
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.08270605  0.55192435
	sample estimates:
	    cor 
	0.26281

cor.test(x$NUMPROCESSORS, x$MAXMPL)
	#### only thrashing samples
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = 1.3901, df = 32, p-value = 0.1741
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1082718  0.5337267
	sample estimates:
	      cor 
	0.2386311

out.fit <- lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
summary(out.fit)
	
	#### only thrashing samples
	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.6257 -0.2953 -0.1915  0.3032  0.7886 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)  
	(Intercept)    0.48158    0.18823   2.558   0.0158 *
	PK            -0.30246    0.17273  -1.751   0.0902 .
	ATP            0.09813    0.21760   0.451   0.6553  
	NUMPROCESSORS  0.14408    0.16719   0.862   0.3957  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.4101 on 30 degrees of freedom
	Multiple R-squared:  0.2007,	Adjusted R-squared:  0.1208 
	F-statistic: 2.511 on 3 and 30 DF,  p-value: 0.07753

#### per-DBMS #####

#### thrashing or not thrashing
x = read.csv(file="extcnfm.dat",head=TRUE,sep="\t")
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
#102
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS, family=binomial("probit"), data = x)
summary(out.fit)

	Call:
	glm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, family = binomial("probit"), 
	    data = x)

	Deviance Residuals: 
	    Min       1Q   Median       3Q      Max  
	-1.3456  -0.8896  -0.6458   1.2535   1.9139  

	Coefficients:
		      Estimate Std. Error z value Pr(>|z|)  
	(Intercept)    -0.1143     0.3654  -0.313   0.7545  
	PK             -0.5308     0.2698  -1.967   0.0492 *
	ATP             0.4028     0.3561   1.131   0.2581  
	NUMPROCESSORS  -0.3487     0.3329  -1.047   0.2950  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	(Dispersion parameter for binomial family taken to be 1)

	    Null deviance: 129.85  on 101  degrees of freedom
	Residual deviance: 121.46  on  98  degrees of freedom
	AIC: 129.46

	Number of Fisher Scoring iterations: 4

wald.test(b = coef(out.fit), Sigma = vcov(out.fit), Terms = 2:4)
Wald test:
----------

Chi-squared test:
X2 = 8.0, df = 3, P(> X2) = 0.045

> 1-out.fit$deviance/out.fit$null.deviance
[1] 0.06463106

#### per-DBMS logistic #####
db2 <- subset(x, x$DBMS=='db2')
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS,  data = db2)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.04953847
mysql <- subset(x, x$DBMS=='mysql')
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = mysql)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.6653202
pgsql <- subset(x, x$DBMS=='pgsql')
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = pgsql)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.7421785
oracle <- subset(x, x$DBMS=='oracle')
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = oracle)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.07885832
sqlserver <- subset(x, x$DBMS=='sqlserver')
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = sqlserver)
1-out.fit$deviance/out.fit$null.deviance
[1] 1

### update-only
library(aod)
library(ggplot2)
x = read.csv(file="extcnfm.dat",head=TRUE,sep="\t")
#x = read.csv(file="extcnfm.dat",head=TRUE,sep="\t")
#x = read.csv(file="new_cnfm.dat",head=TRUE,sep="\t")
#x$MAXMPL[x$MAXMPL == 1100] <- 10000
x_w <- subset(x, x$PCTUPDATE!=0)
x_w <- subset(x_w, select = -PCTREAD)
x <- x_w
nrow(x)
#[1] 151
x <- subset(x, x$ATP < 120000)
x <- subset(x, x$MAXMPL < 1100)
#nrow(x)
[1] 86
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
#75
cor.test(x$NUMPROCESSORS, x$ATP)

	#####  thrashing samples 
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -2.7021, df = 73, p-value = 0.008562
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.49464994 -0.08005832
	sample estimates:
	       cor 
	-0.3015411


med.fit <- lm(ATP ~ NUMPROCESSORS, data = x)
summary(med.fit)

	#####  thrashing samples 
	Call:
	lm(formula = ATP ~ NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.64410 -0.36978  0.05434  0.33335  0.58830 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.67810    0.07759   8.740 5.74e-13 ***
	NUMPROCESSORS -0.26640    0.09859  -2.702  0.00856 ** 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3638 on 73 degrees of freedom
	Multiple R-squared:  0.09093,	Adjusted R-squared:  0.07847 
	F-statistic: 7.302 on 1 and 73 DF,  p-value: 0.008562

		## if revised model is tried
		med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + PK + PCTUPDATE + PCTUPDATE:PK, data = x)
		summary(med.fit)
		
		Call:
		lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + 
		    PK + PCTUPDATE + PCTUPDATE:PK, data = x)

		Residuals:
		     Min       1Q   Median       3Q      Max 
		-0.61625 -0.21207  0.00361  0.22046  0.67640 

		Coefficients:
				          Estimate Std. Error t value Pr(>|t|)  
		(Intercept)               0.271124   0.218018   1.244    0.218  
		NUMPROCESSORS            -0.009819   0.195381  -0.050    0.960  
		ACTROWPOOL                0.349295   0.192518   1.814    0.074 .
		PK                       -0.303097   0.190266  -1.593    0.116  
		PCTUPDATE                 0.320995   0.208481   1.540    0.128  
		NUMPROCESSORS:ACTROWPOOL -0.372086   0.243621  -1.527    0.131  
		PK:PCTUPDATE              0.383472   0.276507   1.387    0.170  
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.3274 on 68 degrees of freedom
		Multiple R-squared:  0.3143,	Adjusted R-squared:  0.2537 
		F-statistic: 5.194 on 6 and 68 DF,  p-value: 0.0001894
	
cor.test(x$PK, x$MAXMPL)
	#####  thrashing samples 
	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 0.1356, df = 73, p-value = 0.8925
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2118546  0.2419606
	sample estimates:
	      cor 
	0.0158703

cor.test(x$ATP, x$MAXMPL)
	#####  thrashing samples 
	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -2.4636, df = 73, p-value = 0.01611
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.47419749 -0.05345274
	sample estimates:
	       cor 
	-0.2770534

cor.test(x$NUMPROCESSORS, x$MAXMPL)
	#####  thrashing samples 
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = -0.5673, df = 73, p-value = 0.5723
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2888663  0.1631674
	sample estimates:
		cor 
	-0.06624777

out.fit <- lm(MAXMPL ~ ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	### thrashing samples
	Call:
	lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.51537 -0.19100 -0.07176  0.19062  0.57826 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.53023    0.08961   5.917 1.02e-07 ***
	ATP           -0.26350    0.09449  -2.789  0.00677 ** 
	NUMPROCESSORS -0.11740    0.08348  -1.406  0.16394    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2937 on 72 degrees of freedom
	Multiple R-squared:  0.1014,	Adjusted R-squared:  0.07648 
	F-statistic: 4.064 on 2 and 72 DF,  p-value: 0.02127

#### per-DBMS #####

#### thrashing or not thrashing
library(aod)
library(ggplot2)
x = read.csv(file="extcnfm.dat",head=TRUE,sep="\t")
x$MAXMPL[x$MAXMPL < 1100] <- 1 ### thrashing
x$MAXMPL[x$MAXMPL == 1100] <- 0
x_w <- subset(x, x$PCTUPDATE!=0)
x_w <- subset(x_w, select = -PCTREAD)
x <- x_w
nrow(x)
#[1] 151
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
	-0.6998  -0.5407   0.3046   0.4281   0.5732  

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.55782    0.08821   6.324 2.85e-09 ***
	ATP           -0.14880    0.09970  -1.493    0.138    
	NUMPROCESSORS  0.14196    0.09283   1.529    0.128    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	(Dispersion parameter for gaussian family taken to be 0.2411939)

	    Null deviance: 37.020  on 150  degrees of freedom
	Residual deviance: 35.697  on 148  degrees of freedom
	AIC: 218.74

	Number of Fisher Scoring iterations: 2

wald.test(b = coef(out.fit), Sigma = vcov(out.fit), Terms = 2:3)
Wald test:
----------

Chi-squared test:
X2 = 5.5, df = 2, P(> X2) = 0.064

> 1-out.fit$deviance/out.fit$null.deviance
[1] 0.03574207

###################
db2 <- subset(x, x$DBMS=='db2')
out.fit <-  glm(MAXMPL ~ ATP + NUMPROCESSORS, data = db2)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.05887471
mysql <- subset(x, x$DBMS=='mysql')
mysql$NUMPROCESSORS = (mysql$NUMPROCESSORS/min(mysql$NUMPROCESSORS))/(max(mysql$NUMPROCESSORS)/min(mysql$NUMPROCESSORS))
out.fit <-  glm(MAXMPL ~ ATP + NUMPROCESSORS, data = mysql)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.7917485
pgsql <- subset(x, x$DBMS=='pgsql')
out.fit <-  glm(MAXMPL ~ ATP + NUMPROCESSORS, data = pgsql)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.06781754
oracle <- subset(x, x$DBMS=='oracle')
out.fit <-  glm(MAXMPL ~ ATP + NUMPROCESSORS, data = oracle)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.1841188
sqlserver <- subset(x, x$DBMS=='sqlserver')
out.fit <-  glm(MAXMPL ~ ATP + NUMPROCESSORS, data = sqlserver)
1-out.fit$deviance/out.fit$null.deviance
[1] -Inf
