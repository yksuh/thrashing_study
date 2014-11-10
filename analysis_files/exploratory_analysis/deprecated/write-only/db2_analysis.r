# db2
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
db2 <- subset(x, x$DBMS=='db2')
db2_w <- subset(db2, db2$PCTUPDATE!=0)
db2_w <- subset(db2_w, select = -PCTREAD)
db2_w$ATP = (db2_w$ATP-min(db2_w$ATP))/(max(db2_w$ATP)-min(db2_w$ATP))
db2_w$MAXMPL = (db2_w$MAXMPL-min(db2_w$MAXMPL))/(max(db2_w$MAXMPL)-min(db2_w$MAXMPL))
db2 <- db2_w
db2$ACTROWPOOL = (db2$ACTROWPOOL-min(db2$ACTROWPOOL))/(max(db2$ACTROWPOOL)-min(db2$ACTROWPOOL))
db2$PCTUPDATE = (db2$PCTUPDATE-min(db2$PCTUPDATE))/(max(db2$PCTUPDATE)-min(db2$PCTUPDATE))
db2$NUMPROCESSORS = (db2$NUMPROCESSORS-min(db2$NUMPROCESSORS))/(max(db2$NUMPROCESSORS)-min(db2$NUMPROCESSORS))
x = rbind(db2) 
x <- subset(x, x$MAXMPL < 1)
> nrow(x)
[1] 14
cor(x$PK, x$MAXMPL)
0.09
cor(x$ATP, x$MAXMPL)
-0.39
cor(x$NUMPROCESSORS, x$MAXMPL)
0.38
cor(x$ACTROWPOOL, x$MAXMPL)
-0.49
cor(x$PCTUPDATE, x$MAXMPL)
0.17

# MLP
med.fit <- lm(ATP ~ NUMPROCESSORS + PK + PCTUPDATE + PCTUPDATE:PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK + PCTUPDATE + PCTUPDATE:PK, 
	    data = x)

	Residuals:
	      Min        1Q    Median        3Q       Max 
	-0.245106 -0.139110  0.000358  0.102017  0.280270 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)  
	(Intercept)    0.43597    0.15008   2.905   0.0175 *
	NUMPROCESSORS -0.97004    0.45421  -2.136   0.0615 .
	PK            -0.09275    0.17409  -0.533   0.6071  
	PCTUPDATE      0.01224    0.19958   0.061   0.9524  
	PK:PCTUPDATE   0.71018    0.45447   1.563   0.1526  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.198 on 9 degrees of freedom
	Multiple R-squared:  0.4482,	Adjusted R-squared:  0.203 
	F-statistic: 1.828 on 4 and 9 DF,  p-value: 0.2078

med.fit <- lm(ATP ~ ACTROWPOOL, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ ACTROWPOOL, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.25446 -0.13815 -0.05225  0.08819  0.33523 

	Coefficients:
		    Estimate Std. Error t value Pr(>|t|)  
	(Intercept)  0.09965    0.09603   1.038   0.3199  
	ACTROWPOOL   0.31792    0.14154   2.246   0.0443 *
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1937 on 12 degrees of freedom
	Multiple R-squared:  0.296,	Adjusted R-squared:  0.2373 
	F-statistic: 5.045 on 1 and 12 DF,  p-value: 0.04431

out.fit <- lm(MAXMPL ~ PK + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.31306 -0.09855  0.02577  0.09984  0.25995 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)   
	(Intercept)    0.58691    0.16682   3.518  0.00787 **
	PK            -0.08492    0.17298  -0.491  0.63667   
	PCTUPDATE      0.04105    0.18874   0.217  0.83327   
	ACTROWPOOL    -0.24763    0.18136  -1.365  0.20929   
	ATP           -0.07963    0.35324  -0.225  0.82730   
	NUMPROCESSORS  0.28436    0.33725   0.843  0.42363   
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2023 on 8 degrees of freedom
	Multiple R-squared:  0.3932,	Adjusted R-squared:  0.01392 
	F-statistic: 1.037 on 5 and 8 DF,  p-value: 0.4577

#### thrashing or not thrashing
x = rbind(db2) 
x$MAXMPL[x$MAXMPL == 1] <- 2
x$MAXMPL[x$MAXMPL < 1] <- 1
x$MAXMPL[x$MAXMPL == 2] <- 0
out.fit <-  glm(MAXMPL ~ PK + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, family=binomial("probit"), data = x)
summary(out.fit)

	Call:
	glm(formula = MAXMPL ~ PK + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, 
	    family = binomial("probit"), data = x)

	Deviance Residuals: 
	    Min       1Q   Median       3Q      Max  
	-0.7655  -0.5982  -0.4682  -0.2005   2.6721  

	Coefficients:
		      Estimate Std. Error z value Pr(>|z|)  
	(Intercept)   -0.84538    0.43907  -1.925   0.0542 .
	PK             0.01157    0.32888   0.035   0.9719  
	PCTUPDATE     -0.03469    0.42845  -0.081   0.9355  
	ACTROWPOOL     0.43364    0.43607   0.994   0.3200  
	ATP           -0.62109    0.94689  -0.656   0.5119  
	NUMPROCESSORS -1.21917    0.57469  -2.121   0.0339 *
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	(Dispersion parameter for binomial family taken to be 1)

	    Null deviance: 85.701  on 116  degrees of freedom
	Residual deviance: 78.961  on 111  degrees of freedom
	AIC: 90.961

	Number of Fisher Scoring iterations: 7

1 - pchisq(deviance(out.fit), df.residual(out.fit))
0.9907408

1-out.fit$deviance/out.fit$null.deviance
0.07864528

library("MASS")
library(QuantPsyc)
lm.beta(out.fit)

           PK     PCTUPDATE    ACTROWPOOL           ATP NUMPROCESSORS 
   0.01779926   -0.03937313    0.50291347   -0.34375345   -1.48319383

------

out.fit <-  glm(MAXMPL ~ PK + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, family=binomial("probit"), data = x)
summary(out.fit)

	Call:
	glm(formula = MAXMPL ~ NUMPROCESSORS, family = binomial("probit"), 
	    data = x)

	Deviance Residuals: 
	    Min       1Q   Median       3Q      Max  
	-2.6664   0.2408   0.4529   0.5912   0.6680  

	Coefficients:
		      Estimate Std. Error z value Pr(>|z|)    
	(Intercept)     0.8417     0.2013   4.181  2.9e-05 ***
	NUMPROCESSORS   1.0603     0.4892   2.168   0.0302 *  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	(Dispersion parameter for binomial family taken to be 1)

	    Null deviance: 85.701  on 116  degrees of freedom
	Residual deviance: 80.098  on 115  degrees of freedom
	AIC: 84.098

	Number of Fisher Scoring iterations: 6

> 1-out.fit$deviance/out.fit$null.deviance
[1] 0.06537489

-----

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

