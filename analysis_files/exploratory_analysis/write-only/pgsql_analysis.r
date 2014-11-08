# pgsql
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
pgsql <- subset(x, x$DBMS=='pgsql')
pgsql_w <- subset(pgsql, pgsql$PCTUPDATE!=0)
pgsql_w <- subset(pgsql_w, select = -PCTREAD)
pgsql_w$ATP = (pgsql_w$ATP-min(pgsql_w$ATP))/(max(pgsql_w$ATP)-min(pgsql_w$ATP))
pgsql_w$MAXMPL = (pgsql_w$MAXMPL-min(pgsql_w$MAXMPL))/(max(pgsql_w$MAXMPL)-min(pgsql_w$MAXMPL))
pgsql <- pgsql_w
pgsql$ACTROWPOOL = (pgsql$ACTROWPOOL-min(pgsql$ACTROWPOOL))/(max(pgsql$ACTROWPOOL)-min(pgsql$ACTROWPOOL))
pgsql$PCTUPDATE = (pgsql$PCTUPDATE-min(pgsql$PCTUPDATE))/(max(pgsql$PCTUPDATE)-min(pgsql$PCTUPDATE))
pgsql$NUMPROCESSORS = (pgsql$NUMPROCESSORS-min(pgsql$NUMPROCESSORS))/(max(pgsql$NUMPROCESSORS)-min(pgsql$NUMPROCESSORS))
x = rbind(pgsql) 
> nrow(x)
[1] 111
x <- subset(x, x$MAXMPL < 1)
> nrow(x)
[1] 76
cor(x$PK, x$MAXMPL)
0.37
cor(x$ATP, x$MAXMPL)
-0.17
cor(x$NUMPROCESSORS, x$MAXMPL)
0.12
cor(x$ACTROWPOOL, x$MAXMPL)
-0.08
cor(x$PCTUPDATE, x$MAXMPL)
-0.11

# MLP
med.fit <- lm(ATP ~ NUMPROCESSORS + PK + PCTUPDATE + PCTUPDATE:PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK + PCTUPDATE + PCTUPDATE:PK, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.13180 -0.02517 -0.01309  0.01114  0.86404 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)  
	(Intercept)    0.041868   0.029118   1.438   0.1549  
	NUMPROCESSORS -0.020659   0.034572  -0.598   0.5520  
	PK            -0.020235   0.052798  -0.383   0.7027  
	PCTUPDATE     -0.005446   0.040621  -0.134   0.8937  
	PK:PCTUPDATE   0.140428   0.075623   1.857   0.0675 .
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.113 on 71 degrees of freedom
	Multiple R-squared:  0.1032,	Adjusted R-squared:  0.05268 
	F-statistic: 2.043 on 4 and 71 DF,  p-value: 0.09759

out.fit <- lm(MAXMPL ~ PK + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.33542 -0.11333 -0.04191  0.10890  0.45621 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.22584    0.04979   4.536 2.32e-05 ***
	PK             0.19717    0.05106   3.861 0.000249 ***
	PCTUPDATE     -0.05832    0.05402  -1.080 0.284004    
	ACTROWPOOL    -0.04241    0.05248  -0.808 0.421695    
	ATP           -0.40979    0.18146  -2.258 0.027046 *  
	NUMPROCESSORS -0.02944    0.05421  -0.543 0.588884    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1768 on 70 degrees of freedom
	Multiple R-squared:  0.2232,	Adjusted R-squared:  0.1677 
	F-statistic: 4.023 on 5 and 70 DF,  p-value: 0.002886

#### thrashing or not thrashing
x = rbind(pgsql)
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
	-3.6867  -0.5011   0.2391   0.5521   1.7886  

	Coefficients:
		      Estimate Std. Error z value Pr(>|z|)    
	(Intercept)    -0.3515     0.5487  -0.641 0.521802    
	PK             -2.0630     0.3566  -5.785 7.27e-09 ***
	PCTUPDATE       0.3689     0.4363   0.845 0.397863    
	ACTROWPOOL      0.5203     0.4206   1.237 0.216035    
	ATP            15.3889     7.8735   1.955 0.050639 .  
	NUMPROCESSORS   2.9225     0.7652   3.819 0.000134 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	(Dispersion parameter for binomial family taken to be 1)

	    Null deviance: 138.37  on 110  degrees of freedom
	Residual deviance:  72.56  on 105  degrees of freedom
	AIC: 84.56

	Number of Fisher Scoring iterations: 8

1 - pchisq(deviance(out.fit), df.residual(out.fit))
0.9933394

>1-out.fit$deviance/out.fit$null.deviance
0.4756106

library("MASS")
library(QuantPsyc)
lm.beta(out.fit)

           PK     PCTUPDATE    ACTROWPOOL           ATP NUMPROCESSORS 
   -2.2127231     0.2968932     0.4334056     3.2012926     2.4641674

------

x = rbind(pgsql) 
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

pdf("pgsql_scaled_var_rel.pdf")
par(mfrow=c(3,2), oma=c(0, 0, 2, 0))
plot(x$NUMPROCESSORS, x$MAXMPL, main='# of Processors vs. Max MPL (c.e.: 0.23)', xlim=c(0, 1), ylim=c(0, 1), xlab='Number of Processors', ylab='Max MPL')
plot(x$ACTROWPOOL, x$MAXMPL, main='Active Row Pool vs. Max MPL (c.e.: -0.13)', xlim=c(0, 1), ylim=c(0, 1), xlab='Active Row Pool', ylab='Max MPL')
plot(x$PCTREAD, x$MAXMPL, main='PRS vs. Max MPL (c.e.:  -0.25)', xlim=c(0, 1), ylim=c(0, 1), xlab='Percentage of Rows from SELECT (PRS)', ylab='Max MPL')
plot(x$PCTUPDATE, x$MAXMPL, main='PRU vs. Max MPL (c.e.: 0.35)', xlim=c(0, 1), ylim=c(0, 1), xlab='Percentage of Rows from UPDATE (PRU)', ylab='Max MPL')
plot(x$ATP, x$MAXMPL, main='ATP time vs. Max MPL (c.e.: 0.10)', xlim=c(0, 1), ylim=c(0, 1), xlab='Average Transaction Processing Time (ATP time)', ylab='Max MPL')
plot(x$PK, x$MAXMPL, main='Presence of PK vs. Max MPL (c.e.: 0.05)', xlim=c(0, 1), ylim=c(0, 1), xlab='Presence of Primary Key (PK)', ylab='Max MPL')
title(adj=0.5, main = "pgsql - Variables' Relationship (on per-DBMS scaled data)", outer=TRUE)
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
pdf("pgsql_scaled_var_rel_on_thrashing.pdf")
par(mfrow=c(3,2), oma=c(0, 0, 2, 0))
plot(y$NUMPROCESSORS, y$MAXMPL, main='# of Processors vs. Max MPL (c.e.: 0.47)', xlim=c(0, 1), ylim=c(0, 1), xlab='Number of Processors', ylab='Max MPL')
plot(y$ACTROWPOOL, y$MAXMPL, main='Active Row Pool vs. Max MPL (c.e.: -0.24)', xlim=c(0, 1), ylim=c(0, 1), xlab='Active Row Pool', ylab='Max MPL')
plot(y$PCTREAD, y$MAXMPL, main='PRS vs. Max MPL (c.e.:  -0.20)', xlim=c(0, 1), ylim=c(0, 1), xlab='Percentage of Rows from SELECT (PRS)', ylab='Max MPL')
plot(y$PCTUPDATE, y$MAXMPL, main='PRU vs. Max MPL (c.e.: 0.31)', xlim=c(0, 1), ylim=c(0, 1), xlab='Percentage of Rows from UPDATE (PRU)', ylab='Max MPL')
plot(y$ATP, y$MAXMPL, main='ATP time vs. Max MPL (c.e.: 0.10)', xlim=c(0, 1), ylim=c(0, 1), xlab='Average Transaction Processing Time (ATP time)', ylab='Max MPL')
plot(y$PK, y$MAXMPL, main='Presence of PK vs. Max MPL (c.e.: 0.08)', xlim=c(0, 1), ylim=c(0, 1), xlab='Presence of Primary Key (PK)', ylab='Max MPL')
title(adj=0.5, main = "pgsql - Variables' Relationship (on per-DBMS scaled thrashing data)", outer=TRUE)
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







pgsql <- subset(x, x$DBMS=='pgsql')
pgsql$ATP = (pgsql$ATP-min(pgsql$ATP))/(max(pgsql$ATP)-min(pgsql$ATP))
pgsql$ATP[pgsql$ATP > 0.8 & pgsql$ATP <= 1] <- 5
pgsql$ATP[pgsql$ATP > 0.6 & pgsql$ATP <= 0.8] <- 4
pgsql$ATP[pgsql$ATP > 0.4 & pgsql$ATP <= 0.6] <- 3
pgsql$ATP[pgsql$ATP > 0.2 & pgsql$ATP <= 0.4] <- 2
pgsql$ATP[pgsql$ATP <= 0.2 ] <- 1
pgsql$ATP = (pgsql$ATP-min(pgsql$ATP))/(max(pgsql$ATP)-min(pgsql$ATP))
pgsql$MAXMPL = (pgsql$MAXMPL-min(pgsql$MAXMPL))/(max(pgsql$MAXMPL)-min(pgsql$MAXMPL))
pgsql$MAXMPL[pgsql$MAXMPL == 1] <- 5
pgsql$MAXMPL[pgsql$MAXMPL > 0.75 & pgsql$MAXMPL <= 1] <- 4
pgsql$MAXMPL[pgsql$MAXMPL > 0.5 & pgsql$MAXMPL <= 0.75] <- 3
pgsql$MAXMPL[pgsql$MAXMPL > 0.25 & pgsql$MAXMPL <= 0.50] <- 2
pgsql$MAXMPL[pgsql$MAXMPL<=0.25] <- 1
pgsql$MAXMPL = (pgsql$MAXMPL-min(pgsql$MAXMPL))/(max(pgsql$MAXMPL)-min(pgsql$MAXMPL))
pgsql$ACTROWPOOL = (pgsql$ACTROWPOOL-min(pgsql$ACTROWPOOL))/(max(pgsql$ACTROWPOOL)-min(pgsql$ACTROWPOOL))
pgsql$PCTREAD = (pgsql$PCTREAD-min(pgsql$PCTREAD))/(max(pgsql$PCTREAD)-min(pgsql$PCTREAD))
pgsql$PCTUPDATE = (pgsql$PCTUPDATE-min(pgsql$PCTUPDATE))/(max(pgsql$PCTUPDATE)-min(pgsql$PCTUPDATE))
pgsql$NUMPROCESSORS = (pgsql$NUMPROCESSORS-min(pgsql$NUMPROCESSORS))/(max(pgsql$NUMPROCESSORS)-min(pgsql$NUMPROCESSORS))
x = rbind(pgsql) 

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

