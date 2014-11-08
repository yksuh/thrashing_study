# Overall: 33.4% (close to suboptimal)
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
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
x = rbind(db2,mysql,oracle,pgsql,sqlserver)]
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD/min(x$PCTREAD))/(max(x$PCTREAD)/min(x$PCTREAD))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
> nrow(x)
[1] 401
x <- subset(x, x$MAXMPL < 1)
> nrow(x)
[1] 198

#x$MAXMPL <- round(x$MAXMPL, 1)
#x$ATP <- round(x$ATP, 5)

cor(x$PK, x$MAXMPL)
[1] 0.2891473

cor(x$ATP, x$MAXMPL)
[1] 0.02110625

cor(x$NUMPROCESSORS, x$MAXMPL)
[1] 0.08

cor(x$ACTROWPOOL, x$MAXMPL)
[1] -0.13

cor(x$PCTREAD, x$MAXMPL)
[1] 0.02

med.fit <- lm(ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK, data = x)
summary(med.fit)

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

out.fit <- lm(MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

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






pdf("scaled_var_rel_on_thrashing.pdf")
par(mfrow=c(3,2), oma=c(0, 0, 2, 0))
plot(y$NUMPROCESSORS, y$MAXMPL, main='# of Processors vs. Max MPL (c.e.: -0.09)', xlim=c(0, 1), ylim=c(0, 1), xlab='Number of Processors', ylab='Max MPL')
plot(y$ACTROWPOOL, y$MAXMPL, main='Active Row Pool vs. Max MPL (c.e.: -0.09)', xlim=c(0, 1), ylim=c(0, 1), xlab='Active Row Pool', ylab='Max MPL')
plot(y$PCTREAD, y$MAXMPL, main='PRS vs. Max MPL (c.e.:  -0.08)', xlim=c(0, 1), ylim=c(0, 1), xlab='Percentage of Rows from SELECT (PRS)', ylab='Max MPL')
plot(y$PCTUPDATE, y$MAXMPL, main='PRU vs. Max MPL (c.e.: -0.12)', xlim=c(0, 1), ylim=c(0, 1), xlab='Percentage of Rows from UPDATE (PRU)', ylab='Max MPL')
plot(y$ATP, y$MAXMPL, main='ATP time vs. Max MPL (c.e.: -0.03)', xlim=c(0, 1), ylim=c(0, 1), xlab='Average Transaction Processing Time (ATP time)', ylab='Max MPL')
plot(y$PK, y$MAXMPL, main='Presence of PK vs. Max MPL (c.e.: 0.17)', xlim=c(0, 1), ylim=c(0, 1), xlab='Presence of Primary Key (PK)', ylab='Max MPL')
title(adj=0.5, main = "Variables' Relationship (on per-DBMS scaled thrashing data)", outer=TRUE)
#text(0.25, 0.5, "Variables' Relationship (on feature-scaled data)")
dev.off()

> cor(x$NUMPROCESSORS, x$MAXMPL)
[1] -0.01111773
cor(x$ACTROWPOOL, x$MAXMPL)
[1] -0.06973536
cor(x$PCTREAD, x$MAXMPL)
[1] -0.04172635
cor(x$PCTUPDATE, x$MAXMPL)
[1] 0.02382193
cor(x$ATP, x$MAXMPL)
[1] -0.1066993
cor(x$PK, x$MAXMPL)


pdf("scaled_var_rel.pdf")
par(mfrow=c(3,2), oma=c(0, 0, 2, 0))
plot(x$NUMPROCESSORS, x$MAXMPL, main='# of Processors vs. Max MPL (c.e.: -0.011)', xlim=c(0, 1), ylim=c(0, 1), xlab='Number of Processors', ylab='Max MPL')
plot(x$ACTROWPOOL, x$MAXMPL, main='Active Row Pool vs. Max MPL (c.e.: -0.070)', xlim=c(0, 1), ylim=c(0, 1), xlab='Active Row Pool', ylab='Max MPL')
plot(x$PCTREAD, x$MAXMPL, main='PRS vs. Max MPL (c.e.:  -0.042)', xlim=c(0, 1), ylim=c(0, 1), xlab='Percentage of Rows from SELECT (PRS)', ylab='Max MPL')
plot(x$PCTUPDATE, x$MAXMPL, main='PRU vs. Max MPL (c.e.: -0.024)', xlim=c(0, 1), ylim=c(0, 1), xlab='Percentage of Rows from UPDATE (PRU)', ylab='Max MPL')
plot(x$ATP, x$MAXMPL, main='ATP time vs. Max MPL (c.e.: -0.107)', xlim=c(0, 1), ylim=c(0, 1), xlab='Average Transaction Processing Time (ATP time)', ylab='Max MPL')
plot(x$PK, x$MAXMPL, main='Presence of PK vs. Max MPL (c.e.: 0.168)', xlim=c(0, 1), ylim=c(0, 1), xlab='Presence of Primary Key (PK)', ylab='Max MPL')
title(adj=0.5, main = "Variables' Relationship (on per-DBMS scaled data)", outer=TRUE)
#text(0.25, 0.5, "Variables' Relationship (on feature-scaled data)")
dev.off()

med.fit <- lm(ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK + PCTUPDATE + PCTUPDATE:PK, data = y)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK + 
	    PCTUPDATE + PCTUPDATE:PK, data = y)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.48515 -0.16271 -0.06826  0.12484  0.83495 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.37848    0.02765  13.687  < 2e-16 ***
	NUMPROCESSORS -0.16914    0.03138  -5.390 1.09e-07 ***
	PK            -0.18988    0.04303  -4.413 1.25e-05 ***
	PCTREAD        0.10692    0.04855   2.202   0.0281 *  
	PCTUPDATE     -0.28457    0.04548  -6.256 8.57e-10 ***
	PK:PCTREAD    -0.16975    0.08317  -2.041   0.0418 *  
	PK:PCTUPDATE   0.32571    0.07173   4.541 7.05e-06 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2644 on 492 degrees of freedom
	Multiple R-squared:  0.1981,	Adjusted R-squared:  0.1883 
	F-statistic: 20.25 on 6 and 492 DF,  p-value: < 2.2e-16

out.fit <- lm(MAXMPL ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS + PK, data = y)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + 
	    NUMPROCESSORS + PK, data = y)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.44724 -0.22347  0.02838  0.21450  0.48959 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.31039    0.03032  10.236  < 2e-16 ***
	PCTREAD       -0.02235    0.03632  -0.615 0.538531    
	PCTUPDATE      0.06942    0.03295   2.107 0.035651 *  
	ACTROWPOOL    -0.06744    0.02946  -2.290 0.022463 *  
	ATP            0.05863    0.03985   1.471 0.141935    
	NUMPROCESSORS -0.06590    0.02947  -2.236 0.025776 *  
	PK             0.08403    0.02264   3.712 0.000229 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2432 on 492 degrees of freedom
	Multiple R-squared:  0.06322,	Adjusted R-squared:  0.05179 
	F-statistic: 5.534 on 6 and 492 DF,  p-value: 1.455e-05

> out.fit <- lm(MAXMPL ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, data = y)
> summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + 
	    NUMPROCESSORS, data = y)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.40654 -0.23931  0.02935  0.22483  0.45639 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.34345    0.02936  11.698   <2e-16 ***
	PCTREAD       -0.02251    0.03679  -0.612   0.5408    
	PCTUPDATE      0.08349    0.03316   2.518   0.0121 *  
	ACTROWPOOL    -0.06437    0.02982  -2.158   0.0314 *  
	ATP            0.03726    0.03994   0.933   0.3514    
	NUMPROCESSORS -0.06800    0.02984  -2.279   0.0231 *  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2463 on 493 degrees of freedom
	Multiple R-squared:  0.03699,	Adjusted R-squared:  0.02722 
	F-statistic: 3.787 on 5 and 493 DF,  p-value: 0.002245


pdf("scaled_max_mpl_hist.pdf")
z <- subset(x, x$MAXMPL < 1)
hist(z$MAXMPL, sub = "(# of thrashing/non-thrashing batchsets = 510/499 (total: 1,009))", main="Histogram of Max. MPL (only on thrashing batchsets)", xlab='Max MPL', ylim=c(0, 200))
dev.off()

> out.fit <- lm(MAXMPL ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS + PK, data = x)
> summary(out.fit)

Call:
lm(formula = MAXMPL ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + 
    NUMPROCESSORS + PK, data = x)

Residuals:
    Min      1Q  Median      3Q     Max 
-0.7857 -0.2971  0.2122  0.3312  0.5137 

Coefficients:
               Estimate Std. Error t value Pr(>|t|)    
(Intercept)    0.672554   0.032765  20.527  < 2e-16 ***
PCTREAD       -0.042700   0.040113  -1.065   0.2874    
PCTUPDATE     -0.004099   0.035408  -0.116   0.9079    
ACTROWPOOL    -0.064492   0.031762  -2.030   0.0426 *  
ATP           -0.104101   0.047195  -2.206   0.0276 *  
NUMPROCESSORS -0.022923   0.030481  -0.752   0.4522    
PK             0.117070   0.024246   4.828 1.59e-06 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.3765 on 1002 degrees of freedom
Multiple R-squared:  0.03932,	Adjusted R-squared:  0.03356 
F-statistic: 6.834 on 6 and 1002 DF,  p-value: 4.032e-07

> med.fit <- lm(ATP ~ NUMPROCESSORS + PK +  PCTUPDATE + PCTUPDATE:PK, data = x)
> summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK + PCTUPDATE + PCTUPDATE:PK, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.31716 -0.13375 -0.09566  0.09832  0.90350 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.31738    0.01719  18.468  < 2e-16 ***
	NUMPROCESSORS -0.07677    0.02002  -3.835 0.000133 ***
	PK            -0.18798    0.02226  -8.445  < 2e-16 ***
	PCTUPDATE     -0.20428    0.02905  -7.031 3.79e-12 ***
	PK:PCTUPDATE   0.21977    0.04199   5.234 2.02e-07 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2492 on 1004 degrees of freedom
	Multiple R-squared:  0.1002,	Adjusted R-squared:  0.09658 
	F-statistic: 27.94 on 4 and 1004 DF,  p-value: < 2.2e-16

> med.fit <- lm(ATP ~ NUMPROCESSORS + NUMPROCESSORS*ACTROWPOOL + ACTROWPOOL + PK + PCTREAD + PCTUPDATE + PCTUPDATE:PK + PCTREAD*PK, data = x)
> summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + NUMPROCESSORS * ACTROWPOOL + 
	    ACTROWPOOL + PK + PCTREAD + PCTUPDATE + PCTUPDATE:PK + PCTREAD * 
	    PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.36746 -0.14299 -0.08787  0.10262  0.87702 

	Coefficients:
		                 Estimate Std. Error t value Pr(>|t|)    
	(Intercept)               0.28059    0.02492  11.258  < 2e-16 ***
	NUMPROCESSORS            -0.07145    0.03327  -2.148   0.0320 *  
	ACTROWPOOL                0.05447    0.02987   1.823   0.0685 .  
	PK                       -0.17676    0.02682  -6.591 7.07e-11 ***
	PCTREAD                   0.03266    0.03656   0.893   0.3719    
	PCTUPDATE                -0.19152    0.03217  -5.954 3.62e-09 ***
	NUMPROCESSORS:ACTROWPOOL -0.01080    0.05343  -0.202   0.8399    
	PK:PCTUPDATE              0.20545    0.04649   4.420 1.10e-05 ***
	PK:PCTREAD               -0.03840    0.05309  -0.723   0.4696    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2488 on 1000 degrees of freedom
	Multiple R-squared:  0.1061,	Adjusted R-squared:  0.09899 
	F-statistic: 14.84 on 8 and 1000 DF,  p-value: < 2.2e-16








par(mfrow=c(2,2), oma=c(0, 0, 2, 0))
y1 <- subset(x, x$NUMPROCESSORS == 0 & x$MAXMPL < 1)
y2 <- subset(x, x$NUMPROCESSORS == 0.1428571 & x$MAXMPL < 1)
y4 <- subset(x, x$NUMPROCESSORS == 0.4285714 & x$MAXMPL < 1)
y8 <- subset(x, x$NUMPROCESSORS == 1.0000000 & x$MAXMPL < 1)
hist(y1$MAXMPL, sub = "# of Processors = 1", main="Histogram of Max. MPL",  xlab='Max MPL')
hist(y2$MAXMPL, sub = "# of Processors = 2", main="Histogram of Max. MPL",  xlab='Max MPL')
hist(y4$MAXMPL, sub = "# of Processors = 4", main="Histogram of Max. MPL",  xlab='Max MPL')
hist(y8$MAXMPL, sub = "# of Processors = 8", main="Histogram of Max. MPL",  xlab='Max MPL')


dev.off()

plot(h, main='# of Processors vs. Max MPL', xlim=c(0, 8), ylim=c(0, 1004), xlab='Number of Processors', ylab='Max MPL')
xfit<-seq(min(x$NUMPROCESSORS),max(x$NUMPROCESSORS),length=40) 
yfit<-dnorm(xfit,mean=mean(out.fit$res),sd=sd(out.fit$res)) 
yfit <- yfit*diff(h$mids[1:2])*length(out.fit$res) 
lines(xfit, yfit, col="blue")

plot(x$NUMPROCESSORS, x$MAXMPL, main='# of Processors vs. Max MPL', xlim=c(0, 1), ylim=c(0, 1), xlab='Number of Processors', ylab='Max MPL')
plot(x$ACTROWPOOL, x$MAXMPL, main='Active Row Pool vs. Max MPL', xlim=c(0, 1), ylim=c(0, 1), xlab='Active Row Pool', ylab='Max MPL')
plot(x$PCTREAD, x$MAXMPL, main='Percentage of Rows from SELECT vs. Max MPL', xlim=c(0, 1), ylim=c(0, 1), xlab='Percentage of Rows from SELECT', ylab='Max MPL')
plot(x$PCTUPDATE, x$MAXMPL, main='Percentage of Rows from UPDATE vs. Max MPL', xlim=c(0, 1), ylim=c(0, 1), xlab='Percentage of Rows from UPDATE', ylab='Max MPL')
plot(x$ATP, x$MAXMPL, main='ATP time vs. Max MPL', xlim=c(0, 1), ylim=c(0, 1), xlab='Average Transaction Processing Time (ATP time)', ylab='Max MPL')
plot(x$PK, x$MAXMPL, main='Presence of Primary Key vs. Max MPL', xlim=c(0, 1), ylim=c(0, 1), xlab='Presence of Primary Key', ylab='Max MPL')
title(adj=0.5, main = "Variables' Relationship (on per-DBMS scaled data)", outer=TRUE)
#text(0.25, 0.5, "Variables' Relationship (on feature-scaled data)")
dev.off()

x$ATP[x$ATP >= 0 & x$ATP <= 0.2] <- 0
x$ATP[x$ATP > 0.2 & x$ATP <= 0.4] <- 0.25
x$ATP[x$ATP > 0.4 & x$ATP <= 0.6] <- 0.5
x$ATP[x$ATP > 0.6 & x$ATP <= 0.8] <- 0.75
x$ATP[x$ATP > 0.8 & x$ATP <= 1] <- 1

pdf("scaled_var_rel.pdf")
par(mfrow=c(3,2), oma=c(0, 0, 2, 0))
plot(x$NUMPROCESSORS, x$MAXMPL, main='# of Processors vs. Max MPL', xlim=c(0, 1), ylim=c(0, 1), xlab='Number of Processors', ylab='Max MPL')
plot(x$ACTROWPOOL, x$MAXMPL, main='Active Row Pool vs. Max MPL', xlim=c(0, 1), ylim=c(0, 1), xlab='Active Row Pool', ylab='Max MPL')
plot(x$PCTREAD, x$MAXMPL, main='Percentage of Rows from SELECT vs. Max MPL', xlim=c(0, 1), ylim=c(0, 1), xlab='Percentage of Rows from SELECT', ylab='Max MPL')
plot(x$PCTUPDATE, x$MAXMPL, main='Percentage of Rows from UPDATE vs. Max MPL', xlim=c(0, 1), ylim=c(0, 1), xlab='Percentage of Rows from UPDATE', ylab='Max MPL')
plot(x$ATP, x$MAXMPL, main='ATP time vs. Max MPL', xlim=c(0, 1), ylim=c(0, 1), xlab='Average Transaction Processing Time (ATP time)', ylab='Max MPL')
plot(x$PK, x$MAXMPL, main='Presence of Primary Key vs. Max MPL', xlim=c(0, 1), ylim=c(0, 1), xlab='Presence of Primary Key', ylab='Max MPL')
title(adj=0.5, main = "Variables' Relationship (on feature-scaled data)", outer=TRUE)
#text(0.25, 0.5, "Variables' Relationship (on feature-scaled data)")
dev.off()

library("MASS")
## fit ordered logit model and store results 'out.fit'
out.fit <- polr(as.factor(MAXMPL) ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS + PK, data = x, Hess=TRUE)

out.fit <- polr(as.factor(MAXMPL) ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS + PK, data = x, method="logistic")

	Call:
	polr(formula = as.factor(MAXMPL) ~ PCTREAD + PCTUPDATE + ACTROWPOOL + 
	    ATP + NUMPROCESSORS + PK, data = x, method = "logistic")

	Coefficients:
		        Value Std. Error t value
	PCTREAD       -0.3268     0.1959 -1.6681
	PCTUPDATE     -0.1199     0.1723 -0.6961
	ACTROWPOOL    -0.2749     0.1565 -1.7571
	ATP           -0.3603     0.2163 -1.6653
	NUMPROCESSORS -0.1508     0.1517 -0.9942
	PK             0.5394     0.1192  4.5246

	Intercepts:
		Value    Std. Error t value 
	0|0.1    -2.1738   0.1794   -12.1177
	0.1|0.2  -1.4865   0.1690    -8.7982
	0.2|0.3  -1.3062   0.1674    -7.8011
	0.3|0.4  -1.0475   0.1657    -6.3217
	0.4|0.5  -0.8655   0.1648    -5.2516
	0.5|0.6  -0.4874   0.1634    -2.9834
	0.6|0.7  -0.1402   0.1629    -0.8609
	0.7|1     0.0682   0.1630     0.4187

	Residual Deviance: 3494.315 
	AIC: 3522.315

## view a summary of the model
summary(out.fit)

	Call:
	polr(formula = as.factor(MAXMPL) ~ PCTREAD + PCTUPDATE + ACTROWPOOL + 
	    ATP + NUMPROCESSORS + PK, data = x, Hess = TRUE)

	Coefficients:
		        Value Std. Error t value
	PCTREAD       -0.3268     0.1959 -1.6681
	PCTUPDATE     -0.1199     0.1723 -0.6961
	ACTROWPOOL    -0.2749     0.1565 -1.7571
	ATP           -0.3603     0.2163 -1.6653
	NUMPROCESSORS -0.1508     0.1517 -0.9942
	PK             0.5394     0.1192  4.5246

	Intercepts:
		Value    Std. Error t value 
	0|0.1    -2.1738   0.1794   -12.1176
	0.1|0.2  -1.4865   0.1690    -8.7982
	0.2|0.3  -1.3062   0.1674    -7.8011
	0.3|0.4  -1.0475   0.1657    -6.3217
	0.4|0.5  -0.8655   0.1648    -5.2516
	0.5|0.6  -0.4874   0.1634    -2.9834
	0.6|0.7  -0.1402   0.1629    -0.8609
	0.7|1     0.0682   0.1630     0.4187

	Residual Deviance: 3494.315 
	AIC: 3522.315 

(ctable <- coef(summary(out.fit)))

                    Value Std. Error     t value
	PCTREAD       -0.32675444  0.1958879  -1.6680686
	PCTUPDATE     -0.11992301  0.1722731  -0.6961217
	ACTROWPOOL    -0.27494666  0.1564775  -1.7571003
	ATP           -0.36026995  0.2163378  -1.6653118
	NUMPROCESSORS -0.15083595  0.1517210  -0.9941666
	PK             0.53942615  0.1192201   4.5246246
	0|0.1         -2.17381268  0.1793923 -12.1176483
	0.1|0.2       -1.48653397  0.1689583  -8.7982302
	0.2|0.3       -1.30622695  0.1674408  -7.8011268
	0.3|0.4       -1.04752753  0.1657045  -6.3216588
	0.4|0.5       -0.86554935  0.1648158  -5.2516174
	0.5|0.6       -0.48742697  0.1633819  -2.9833588
	0.6|0.7       -0.14023584  0.1628996  -0.8608729
	0.7|1          0.06823999  0.1629880   0.4186812

## calculate and store p values
p <- pnorm(abs(ctable[, "t value"]), lower.tail = FALSE) * 2
## combined table
(ctable <- cbind(ctable, "p value" = p))

		            Value Std. Error     t value      p value
	PCTREAD       -0.32675444  0.1958879  -1.6680686 9.530210e-02
	PCTUPDATE     -0.11992301  0.1722731  -0.6961217 4.863526e-01
	ACTROWPOOL    -0.27494666  0.1564775  -1.7571003 7.890072e-02
	ATP           -0.36026995  0.2163378  -1.6653118 9.585056e-02
	NUMPROCESSORS -0.15083595  0.1517210  -0.9941666 3.201417e-01
	PK             0.53942615  0.1192201   4.5246246 6.050280e-06
	0|0.1         -2.17381268  0.1793923 -12.1176483 8.516800e-34
	0.1|0.2       -1.48653397  0.1689583  -8.7982302 1.389906e-18
	0.2|0.3       -1.30622695  0.1674408  -7.8011268 6.135684e-15
	0.3|0.4       -1.04752753  0.1657045  -6.3216588 2.587702e-10
	0.4|0.5       -0.86554935  0.1648158  -5.2516174 1.507694e-07
	0.5|0.6       -0.48742697  0.1633819  -2.9833588 2.851035e-03
	0.6|0.7       -0.14023584  0.1628996  -0.8608729 3.893080e-01
	0.7|1          0.06823999  0.1629880   0.4186812 6.754492e-01

(ci <- confint(out.fit)) # default method gives profiled CIs
Waiting for profiling to be done...
		           2.5 %     97.5 %
	PCTREAD       -0.7095110 0.05909261
	PCTUPDATE     -0.4577334 0.21784590
	ACTROWPOOL    -0.5820796 0.03153569
	ATP           -0.7830705 0.06569454
	NUMPROCESSORS -0.4480325 0.14696184
	PK             0.3062431 0.77371726

confint.default(out.fit)

		         2.5 %     97.5 %
	PCTREAD       -0.7106877 0.05717876
	PCTUPDATE     -0.4575720 0.21772596
	ACTROWPOOL    -0.5816369 0.03174360
	ATP           -0.7842843 0.06374441
	NUMPROCESSORS -0.4482036 0.14653174
	PK             0.3057591 0.77309323

exp(coef(out.fit))

      PCTREAD     PCTUPDATE    ACTROWPOOL           ATP NUMPROCESSORS 
    0.7212608     0.8869887     0.7596126     0.6974880     0.8599888 
           PK 
    1.7150224 

## OR and CI
exp(cbind(OR = coef(out.fit), ci))

		             OR     2.5 %   97.5 %
	PCTREAD       0.7212608 0.4918847 1.060873
	PCTUPDATE     0.8869887 0.6327161 1.243395
	ACTROWPOOL    0.7596126 0.5587352 1.032038
	ATP           0.6974880 0.4570006 1.067900
	NUMPROCESSORS 0.8599888 0.6388839 1.158310
	PK            1.7150224 1.3583125 2.167810


sf <- function(y) {
   c('Early' = qlogis(mean(y >= 0.3)),
     'Middle' = qlogis(mean(y >= 0.6)),
     'Late' = qlogis(mean(y >= 1.0)))
}

> (s <- with(x, summary(as.numeric(MAXMPL) ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS + PK, fun=sf)))
as.numeric(MAXMPL)    N=1004

+-------------+-------------------+----+---------+----------+-----------+
|             |                   |N   |Early    |Middle    |Late       |
+-------------+-------------------+----+---------+----------+-----------+
|PCTREAD      |0                  | 608|1.2443241|0.53899650|-0.13837828|
|             |0.01               | 136|1.0986123|0.23638878|-0.08829261|
|             |0.1                | 138|1.3682759|0.29191041|-0.05798726|
|             |1                  | 122|0.8317333|0.00000000|-0.33085424|
+-------------+-------------------+----+---------+----------+-----------+
|PCTUPDATE    |0                  | 396|1.0986123|0.18232156|-0.15180601|
|             |0.25               | 153|1.3700338|0.66387680|-0.17034537|
|             |0.5                | 153|1.2153366|0.60613580| 0.09156719|
|             |0.75               | 152|1.1700713|0.59598343|-0.21130909|
|             |1                  | 150|1.2272297|0.29546421|-0.26826399|
+-------------+-------------------+----+---------+----------+-----------+
|ACTROWPOOL   |0                  | 255|1.4873905|0.55499684| 0.02353050|
|             |0.333333333333333  | 248|1.2092222|0.40882646|-0.16164135|
|             |0.666666666666667  | 249|1.1255681|0.39877612|-0.25029454|
|             |1                  | 252|0.9555114|0.22314355|-0.19105524|
+-------------+-------------------+----+---------+----------+-----------+
|ATP          |[0.000000,0.000545)| 251|1.3664917|0.61641339| 0.19986587|
|             |[0.000545,0.003245)| 251|1.4679724|0.79658277|-0.07174390|
|             |[0.003245,0.325739)| 251|0.7413493|0.16772276|-0.47907693|
|             |[0.325739,1.000000]| 251|1.2476479|0.03984591|-0.23211222|
+-------------+-------------------+----+---------+----------+-----------+
|NUMPROCESSORS|0                  | 270|1.5830047|0.48326482| 0.05927661|
|             |0.142857142857143  | 232|0.7191227|0.15548490|-0.38395890|
|             |0.428571428571429  | 235|1.3083328|0.51309577|-0.19637331|
|             |1                  | 267|1.1749853|0.41796527|-0.09745534|
+-------------+-------------------+----+---------+----------+-----------+
|PK           |No                 | 523|0.8463875|0.10334235|-0.37528013|
|             |Yes                | 481|1.6422277|0.73396918| 0.10404386|
+-------------+-------------------+----+---------+----------+-----------+
|Overall      |                   |1004|1.1855055|0.39551478|-0.14367293|
+-------------+-------------------+----+---------+----------+-----------+

out.fit <- glm(I(as.numeric(MAXMPL) >= 0.9) ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS + PK, family="binomial", data = x)
summary(out.fit)

#The first line of code estimates the effect of pared on choosing "no-thrashing" applying versus "somewhat likely" or "very likely". 
out.fit <- glm(I(as.numeric(MAXMPL) < 1) ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS + PK, family="binomial", data = x)
summary(out.fit)

Call:
glm(formula = I(as.numeric(MAXMPL) < 1) ~ PCTREAD + PCTUPDATE + 
    ACTROWPOOL + ATP + NUMPROCESSORS + PK, family = "binomial", 
    data = x)

Deviance Residuals: 
    Min       1Q   Median       3Q      Max  
-1.5547  -1.1851   0.9032   1.0998   1.3541  

Coefficients:
               Estimate Std. Error z value Pr(>|z|)   
(Intercept)   -0.003859   0.176175  -0.022  0.98252   
PCTREAD        0.272739   0.221408   1.232  0.21801   
PCTUPDATE      0.239292   0.190931   1.253  0.21010   
ACTROWPOOL     0.189092   0.171663   1.102  0.27067   
ATP            0.632325   0.259222   2.439  0.01471 * 
NUMPROCESSORS  0.068097   0.164369   0.414  0.67866   
PK            -0.414963   0.130515  -3.179  0.00148 **

> 1-out.fit$deviance/out.fit$null.deviance
[1] 0.01715306

out.fit <- glm(I(as.numeric(MAXMPL) >= 1) ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS + PK, family="binomial", data = x)
summary(out.fit)

	Call:
	glm(formula = I(as.numeric(MAXMPL) >= 1) ~ PCTREAD + PCTUPDATE + 
	    ACTROWPOOL + ATP + NUMPROCESSORS + PK, family = "binomial", 
	    data = x)

	Deviance Residuals: 
	    Min       1Q   Median       3Q      Max  
	-1.3541  -1.0998  -0.9032   1.1851   1.5547  

	Coefficients:
		       Estimate Std. Error z value Pr(>|z|)   
	(Intercept)    0.003859   0.176175   0.022  0.98252   
	PCTREAD       -0.272739   0.221408  -1.232  0.21801   
	PCTUPDATE     -0.239292   0.190931  -1.253  0.21010   
	ACTROWPOOL    -0.189092   0.171663  -1.102  0.27067   
	ATP           -0.632325   0.259222  -2.439  0.01471 * 
	NUMPROCESSORS -0.068097   0.164369  -0.414  0.67866   
	PK             0.414963   0.130515   3.179  0.00148 **
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	(Dispersion parameter for binomial family taken to be 1)

	    Null deviance: 1386.7  on 1003  degrees of freedom
	Residual deviance: 1362.9  on  997  degrees of freedom
	AIC: 1376.9

	Number of Fisher Scoring iterations: 4

> 1-out.fit$deviance/out.fit$null.deviance
[1] 0.01715306

