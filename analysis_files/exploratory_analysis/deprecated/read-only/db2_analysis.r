# db2
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
db2 <- subset(x, x$DBMS=='db2')
db2_r <- subset(db2, db2$PCTREAD!=0)
db2_r <- subset(db2_r, select = -PCTUPDATE)
db2_r$ATP = (db2_r$ATP-min(db2_r$ATP))/(max(db2_r$ATP)-min(db2_r$ATP))
db2_r$MAXMPL = (db2_r$MAXMPL-min(db2_r$MAXMPL))/(max(db2_r$MAXMPL)-min(db2_r$MAXMPL))
db2 <- db2_r
db2$ACTROWPOOL = (db2$ACTROWPOOL-min(db2$ACTROWPOOL))/(max(db2$ACTROWPOOL)-min(db2$ACTROWPOOL))
db2$PCTREAD = (db2$PCTREAD/min(db2$PCTREAD))/(max(db2$PCTREAD)/min(db2$PCTREAD))
db2$NUMPROCESSORS = (db2$NUMPROCESSORS/min(db2$NUMPROCESSORS))/(max(db2$NUMPROCESSORS)/min(db2$NUMPROCESSORS))
x = rbind(db2) 
> nrow(x)
[1] 85
x <- subset(x, x$MAXMPL < 1)
> nrow(x)
[1] 39
cor(x$PK, x$MAXMPL)
0.10
cor(x$ATP, x$MAXMPL)
0.19
cor(x$NUMPROCESSORS, x$MAXMPL)
0.47
cor(x$ACTROWPOOL, x$MAXMPL)
-0.24
cor(x$PCTREAD, x$MAXMPL)
-0.20

cor(x$NUMPROCESSORS, x$ATP)
0.45
cor(x$PK, x$ATP)
0.01
cor(x$PCTREAD, x$ATP)
0.12

# MLP
med.fit <- lm(ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.09128 -0.01993 -0.00768  0.00579  0.36431 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.003078   0.015237   0.202 0.840783    
	NUMPROCESSORS  0.094369   0.025697   3.672 0.000604 ***
	PK            -0.005912   0.022014  -0.269 0.789402    
	PCTREAD       -0.025103   0.033195  -0.756 0.453209    
	PK:PCTREAD    -0.001726   0.044124  -0.039 0.968958    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.06482 on 48 degrees of freedom
	Multiple R-squared:  0.2324,	Adjusted R-squared:  0.1684 
	F-statistic: 3.632 on 4 and 48 DF,  p-value: 0.01153

out.fit <- lm(MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.32747 -0.15825 -0.00542  0.14096  0.39851 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.35218    0.06205   5.676  8.3e-07 ***
	PK             0.00989    0.05526   0.179 0.858730    
	PCTREAD       -0.14280    0.06690  -2.135 0.038042 *  
	ACTROWPOOL    -0.11920    0.07762  -1.536 0.131356    
	ATP           -0.64334    0.43479  -1.480 0.145638    
	NUMPROCESSORS  0.35407    0.08764   4.040 0.000196 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1949 on 47 degrees of freedom
	Multiple R-squared:  0.3359,	Adjusted R-squared:  0.2653 
	F-statistic: 4.755 on 5 and 47 DF,  p-value: 0.001348

#### thrashing or not thrashing (not working)
x = rbind(db2) 
x$MAXMPL[x$MAXMPL == 1] <- 2
x$MAXMPL[x$MAXMPL < 1] <- 1
x$MAXMPL[x$MAXMPL == 2] <- 0
out.fit <-  glm(MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, family=binomial("probit"), data = x)
summary(out.fit)

	Call:
	glm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, 
	    family = binomial("probit"), data = x)

	Deviance Residuals: 
	    Min       1Q   Median       3Q      Max  
	-1.4645  -0.7797  -0.6096   0.9573   2.3171  

	Coefficients:
		      Estimate Std. Error z value Pr(>|z|)   
	(Intercept)   -0.69128    0.21533  -3.210  0.00133 **
	PK            -0.08184    0.19885  -0.412  0.68065   
	PCTREAD        0.79242    0.26963   2.939  0.00329 **
	ACTROWPOOL     0.39005    0.26431   1.476  0.14002   
	ATP           -0.57470    0.64406  -0.892  0.37223   
	NUMPROCESSORS -0.59183    0.26115  -2.266  0.02344 * 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	(Dispersion parameter for binomial family taken to be 1)

	    Null deviance: 232.51  on 201  degrees of freedom
	Residual deviance: 214.52  on 196  degrees of freedom
	AIC: 226.52

	Number of Fisher Scoring iterations: 5

1 - pchisq(deviance(out.fit), df.residual(out.fit))
0.1733746

1-out.fit$deviance/out.fit$null.deviance
[1] 0.08

library("MASS")
library(QuantPsyc)
lm.beta(out.fit)

           PK       PCTREAD    ACTROWPOOL           ATP NUMPROCESSORS 
  -0.09301651    0.61387839    0.33167816   -0.25189963   -0.53572587


##########################################################################

x = rbind(db2) 
y = x

cor(y$NUMPROCESSORS, y$MAXMPL)
0.23

cor(y$ACTROWPOOL, y$MAXMPL)
-0.13

cor(y$PCTREAD, y$MAXMPL)
-0.25

cor(y$PCTUPDATE, y$MAXMPL)
0.35

cor(y$ATP, y$MAXMPL)
0.10

cor(y$PK, y$MAXMPL)
0.05

pdf("db2_scaled_var_rel.pdf")
par(mfrow=c(3,2), oma=c(0, 0, 2, 0))
plot(x$NUMPROCESSORS, x$MAXMPL, main='# of Processors vs. Max MPL (c.e.: 0.23)', xlim=c(0, 1), ylim=c(0, 1), xlab='Number of Processors', ylab='Max MPL')
plot(x$ACTROWPOOL, x$MAXMPL, main='Active Row Pool vs. Max MPL (c.e.: -0.13)', xlim=c(0, 1), ylim=c(0, 1), xlab='Active Row Pool', ylab='Max MPL')
plot(x$PCTREAD, x$MAXMPL, main='PRS vs. Max MPL (c.e.:  -0.25)', xlim=c(0, 1), ylim=c(0, 1), xlab='Percentage of Rows from SELECT (PRS)', ylab='Max MPL')
plot(x$PCTUPDATE, x$MAXMPL, main='PRU vs. Max MPL (c.e.: 0.35)', xlim=c(0, 1), ylim=c(0, 1), xlab='Percentage of Rows from UPDATE (PRU)', ylab='Max MPL')
plot(x$ATP, x$MAXMPL, main='ATP time vs. Max MPL (c.e.: 0.10)', xlim=c(0, 1), ylim=c(0, 1), xlab='Average Transaction Processing Time (ATP time)', ylab='Max MPL')
plot(x$PK, x$MAXMPL, main='Presence of PK vs. Max MPL (c.e.: 0.05)', xlim=c(0, 1), ylim=c(0, 1), xlab='Presence of Primary Key (PK)', ylab='Max MPL')
title(adj=0.5, main = "DB2 - Variables' Relationship (on per-DBMS scaled data)", outer=TRUE)
#text(0.25, 0.5, "Variables' Relationship (on feature-scaled data)")
dev.off()


cor(y$NUMPROCESSORS, y$MAXMPL)
0.4668889

cor(y$ACTROWPOOL, y$MAXMPL)
-0.2373241

cor(y$PCTREAD, y$MAXMPL)
-0.200271

cor(y$PCTUPDATE, y$MAXMPL)
0.3099735

cor(y$ATP, y$MAXMPL)
0.1034878

cor(y$PK, y$MAXMPL)
0.07670827

y <- subset(x, x$MAXMPL < 1)
pdf("db2_scaled_var_rel_on_thrashing.pdf")
par(mfrow=c(3,2), oma=c(0, 0, 2, 0))
plot(y$NUMPROCESSORS, y$MAXMPL, main='# of Processors vs. Max MPL (c.e.: 0.47)', xlim=c(0, 1), ylim=c(0, 1), xlab='Number of Processors', ylab='Max MPL')
plot(y$ACTROWPOOL, y$MAXMPL, main='Active Row Pool vs. Max MPL (c.e.: -0.24)', xlim=c(0, 1), ylim=c(0, 1), xlab='Active Row Pool', ylab='Max MPL')
plot(y$PCTREAD, y$MAXMPL, main='PRS vs. Max MPL (c.e.:  -0.20)', xlim=c(0, 1), ylim=c(0, 1), xlab='Percentage of Rows from SELECT (PRS)', ylab='Max MPL')
plot(y$PCTUPDATE, y$MAXMPL, main='PRU vs. Max MPL (c.e.: 0.31)', xlim=c(0, 1), ylim=c(0, 1), xlab='Percentage of Rows from UPDATE (PRU)', ylab='Max MPL')
plot(y$ATP, y$MAXMPL, main='ATP time vs. Max MPL (c.e.: 0.10)', xlim=c(0, 1), ylim=c(0, 1), xlab='Average Transaction Processing Time (ATP time)', ylab='Max MPL')
plot(y$PK, y$MAXMPL, main='Presence of PK vs. Max MPL (c.e.: 0.08)', xlim=c(0, 1), ylim=c(0, 1), xlab='Presence of Primary Key (PK)', ylab='Max MPL')
title(adj=0.5, main = "DB2 - Variables' Relationship (on per-DBMS scaled thrashing data)", outer=TRUE)
#text(0.25, 0.5, "Variables' Relationship (on feature-scaled data)")
dev.off()




> nrow(x)
[1] 60

med.fit <- lm(ATP ~ NUMPROCESSORS + PCTUPDATE  + PK + PK:PCTUPDATE, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PCTUPDATE + PK + PK:PCTUPDATE, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.18183 -0.07765 -0.03586  0.01105  0.85824 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)  
	(Intercept)    0.02607    0.02914   0.895   0.3721  
	NUMPROCESSORS  0.07014    0.03254   2.155   0.0324 *
	PCTUPDATE     -0.07290    0.04971  -1.467   0.1441  
	PK             0.08563    0.03600   2.379   0.0183 *
	PCTUPDATE:PK  -0.12023    0.07056  -1.704   0.0900 .
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.184 on 197 degrees of freedom
	Multiple R-squared:  0.1119,	Adjusted R-squared:  0.09388 
	F-statistic: 6.206 on 4 and 197 DF,  p-value: 0.0001007

out.fit <- lm(MAXMPL ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS + PK, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + 
	    NUMPROCESSORS + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.80373 -0.13983  0.06516  0.19615  0.46891 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.70208    0.05143  13.650  < 2e-16 ***
	PCTREAD       -0.07450    0.06634  -1.123  0.26279    
	PCTUPDATE      0.29404    0.06335   4.641 6.34e-06 ***
	ACTROWPOOL    -0.11908    0.05281  -2.255  0.02525 *  
	ATP            0.25096    0.11151   2.251  0.02553 *  
	NUMPROCESSORS  0.15785    0.05003   3.155  0.00186 ** 
	PK             0.02900    0.03973   0.730  0.46619    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2796 on 195 degrees of freedom
	Multiple R-squared:  0.2235,	Adjusted R-squared:  0.1996 
	F-statistic: 9.353 on 6 and 195 DF,  p-value: 5.126e-09

-----







db2 <- subset(x, x$DBMS=='db2')
db2$ATP = (db2$ATP-min(db2$ATP))/(max(db2$ATP)-min(db2$ATP))
db2$ATP[db2$ATP > 0.8 & db2$ATP <= 1] <- 5
db2$ATP[db2$ATP > 0.6 & db2$ATP <= 0.8] <- 4
db2$ATP[db2$ATP > 0.4 & db2$ATP <= 0.6] <- 3
db2$ATP[db2$ATP > 0.2 & db2$ATP <= 0.4] <- 2
db2$ATP[db2$ATP <= 0.2 ] <- 1
db2$ATP = (db2$ATP-min(db2$ATP))/(max(db2$ATP)-min(db2$ATP))
db2$MAXMPL = (db2$MAXMPL-min(db2$MAXMPL))/(max(db2$MAXMPL)-min(db2$MAXMPL))
db2$MAXMPL[db2$MAXMPL == 1] <- 5
db2$MAXMPL[db2$MAXMPL > 0.75 & db2$MAXMPL <= 1] <- 4
db2$MAXMPL[db2$MAXMPL > 0.5 & db2$MAXMPL <= 0.75] <- 3
db2$MAXMPL[db2$MAXMPL > 0.25 & db2$MAXMPL <= 0.50] <- 2
db2$MAXMPL[db2$MAXMPL<=0.25] <- 1
db2$MAXMPL = (db2$MAXMPL-min(db2$MAXMPL))/(max(db2$MAXMPL)-min(db2$MAXMPL))
db2$ACTROWPOOL = (db2$ACTROWPOOL-min(db2$ACTROWPOOL))/(max(db2$ACTROWPOOL)-min(db2$ACTROWPOOL))
db2$PCTREAD = (db2$PCTREAD-min(db2$PCTREAD))/(max(db2$PCTREAD)-min(db2$PCTREAD))
db2$PCTUPDATE = (db2$PCTUPDATE-min(db2$PCTUPDATE))/(max(db2$PCTUPDATE)-min(db2$PCTUPDATE))
db2$NUMPROCESSORS = (db2$NUMPROCESSORS-min(db2$NUMPROCESSORS))/(max(db2$NUMPROCESSORS)-min(db2$NUMPROCESSORS))
x = rbind(db2) 

med.fit <- lm(ATP ~ NUMPROCESSORS + PCTUPDATE  + PK + PK:PCTUPDATE, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PCTUPDATE + PK + PK:PCTUPDATE, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.20044 -0.08515 -0.03053  0.01021  0.90143 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)  
	(Intercept)    0.02778    0.03230   0.860   0.3908  
	NUMPROCESSORS  0.07079    0.03617   1.957   0.0518 .
	PCTUPDATE     -0.07599    0.05508  -1.380   0.1693  
	PK             0.10187    0.04081   2.496   0.0134 *
	PCTUPDATE:PK  -0.14249    0.07905  -1.803   0.0730 .
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2039 on 192 degrees of freedom
	Multiple R-squared:  0.1108,	Adjusted R-squared:  0.0923 
	F-statistic: 5.983 on 4 and 192 DF,  p-value: 0.0001475

------

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PCTUPDATE + PK + PK:PCTUPDATE, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.19260 -0.07600 -0.02929  0.01015  0.85072 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)   
	(Intercept)    0.02714    0.02934   0.925  0.35613   
	NUMPROCESSORS  0.06741    0.03285   2.052  0.04153 * 
	PCTUPDATE     -0.07288    0.05002  -1.457  0.14677   
	PK             0.09805    0.03707   2.645  0.00884 **
	PCTUPDATE:PK  -0.13698    0.07179  -1.908  0.05789 . 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1852 on 192 degrees of freedom
	Multiple R-squared:  0.1221,	Adjusted R-squared:  0.1038 
	F-statistic: 6.678 on 4 and 192 DF,  p-value: 4.72e-05

> out.fit <- lm(MAXMPL ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS + PK, data = x)
> summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + 
	    NUMPROCESSORS + PK, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-1.0793 -0.4192  0.1326  0.3231  0.6882 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.47792    0.07891   6.057 7.29e-09 ***
	PCTREAD       -0.05038    0.10832  -0.465 0.642387    
	PCTUPDATE      0.37048    0.09602   3.858 0.000156 ***
	ACTROWPOOL    -0.14672    0.08152  -1.800 0.073497 .  
	ATP            0.34054    0.15411   2.210 0.028318 *  
	NUMPROCESSORS  0.21712    0.07637   2.843 0.004956 ** 
	PK             0.11158    0.06122   1.823 0.069945 .  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.4256 on 190 degrees of freedom
	Multiple R-squared:  0.1753,	Adjusted R-squared:  0.1492 
	F-statistic: 6.731 on 6 and 190 DF,  p-value: 1.764e-06

-----

Call:
lm(formula = MAXMPL ~ NUMPROCESSORS + ATP + PCTREAD + PCTUPDATE + 
    ACTROWPOOL + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.84778 -0.15428  0.06585  0.19442  0.49463 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.68322    0.05056  13.514  < 2e-16 ***
	NUMPROCESSORS  0.19427    0.04896   3.968 0.000103 ***
	ATP            0.21142    0.10874   1.944 0.053348 .  
	PCTREAD       -0.07604    0.06941  -1.096 0.274681    
	PCTUPDATE      0.23047    0.06180   3.729 0.000253 ***
	ACTROWPOOL    -0.12960    0.05227  -2.479 0.014030 *  
	PK             0.06358    0.03925   1.620 0.106894    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2726 on 190 degrees of freedom
	Multiple R-squared:  0.2178,	Adjusted R-squared:  0.1931 
	F-statistic: 8.817 on 6 and 190 DF,  p-value: 1.747e-08

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS", robustSE = TRUE, conf.level=.1, sims = 100)
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 10% CI Lower 10% CI Upper p-value
	ACME             0.0142       0.0120       0.0143    0.06
	ADE              0.1950       0.1893       0.2020    0.00
	Total Effect     0.2092       0.2034       0.2150    0.00
	Prop. Mediated   0.0627       0.0579       0.0683    0.06

	Sample Size Used: 197 


	Simulations: 1000 

----

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 10% CI Lower 10% CI Upper p-value
	ACME             0.0174       0.0127       0.0166    0.04
	ADE              0.2121       0.2092       0.2236    0.00
	Total Effect     0.2295       0.2306       0.2360    0.00
	Prop. Mediated   0.0670       0.0642       0.0727    0.04

	Sample Size Used: 197 


	Simulations: 100 

sens.out <- medsens(med.out, effect.type = "both")
summary(sens.out)

Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Rho at which ACME = 0: 0.2
	R^2_M*R^2_Y* at which ACME = 0: 0.04
	R^2_M~R^2_Y~ at which ACME = 0: 0.0281 


	Mediation Sensitivity Analysis for Average Direct Effect

	Sensitivity Region

	      Rho     ADE 10% CI Lower 10% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.9 -0.0111      -0.0276       0.0054         0.81       0.5691

	Rho at which ADE = 0: -0.9
	R^2_M*R^2_Y* at which ADE = 0: 0.81
	R^2_M~R^2_Y~ at which ADE = 0: 0.5691 

----

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Rho at which ACME = 0: 0.1
	R^2_M*R^2_Y* at which ACME = 0: 0.01
	R^2_M~R^2_Y~ at which ACME = 0: 0.0069 


	Mediation Sensitivity Analysis for Average Direct Effect

	Sensitivity Region

	      Rho     ADE 10% CI Lower 10% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.9 -0.0046      -0.0193       0.0101         0.81       0.5562

	Rho at which ADE = 0: -0.9
	R^2_M*R^2_Y* at which ADE = 0: 0.81
	R^2_M~R^2_Y~ at which ADE = 0: 0.5562 

sens.out$r.square.y
sens.out$r.square.m

> sens.out$r.square.y
[1] 0.2097827
> sens.out$r.square.m
[1] 0.1108249

---

> sens.out$r.square.y
[1] 0.2177873
> sens.out$r.square.m
[1] 0.1221305

