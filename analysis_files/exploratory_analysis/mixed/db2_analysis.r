# db2
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
db2 <- subset(x, x$DBMS=='db2')
db2$ATP = (db2$ATP-min(db2$ATP))/(max(db2$ATP)-min(db2$ATP))
db2$MAXMPL = (db2$MAXMPL-min(db2$MAXMPL))/(max(db2$MAXMPL)-min(db2$MAXMPL))
db2$ACTROWPOOL = (db2$ACTROWPOOL-min(db2$ACTROWPOOL))/(max(db2$ACTROWPOOL)-min(db2$ACTROWPOOL))
db2$PCTREAD = (db2$PCTREAD-min(db2$PCTREAD))/(max(db2$PCTREAD)-min(db2$PCTREAD))
db2$PCTUPDATE = (db2$PCTUPDATE-min(db2$PCTUPDATE))/(max(db2$PCTUPDATE)-min(db2$PCTUPDATE))
db2$NUMPROCESSORS = (db2$NUMPROCESSORS-min(db2$NUMPROCESSORS))/(max(db2$NUMPROCESSORS)-min(db2$NUMPROCESSORS))
x = rbind(db2) 
x <- subset(x, x$MAXMPL < 1)
cor(x$ATP, x$MAXMPL)
0.1034878
cor(x$NUMPROCESSORS, x$MAXMPL)
0.4668889
cor(x$ACTROWPOOL, x$MAXMPL)
-0.2373241
cor(x$PCTREAD, x$MAXMPL)
-0.200271
cor(x$PCTUPDATE, x$MAXMPL)
0.3099735

re <- subset(x, x$PCTREAD!=0)
re <- subset(re, select = -PCTUPDATE)
cor(re$PK, re$MAXMPL)

cor(re$NUMPROCESSORS, re$MAXMPL)
0.5975473
cor(re$ATP, re$MAXMPL)
0.1923382
cor(re$ACTROWPOOL, re$MAXMPL)
-0.1811142
cor(re$PCTREAD, re$MAXMPL)
-0.09485728

cor(re$NUMPROCESSORS, re$ATP)
cor(re$ACTROWPOOL, re$ATP)
cor(re$PK, re$ATP)
cor(re$PCTREAD, re$ATP)


up <- subset(x, x$PCTUPDATE!=0)
up <- subset(up, select = -PCTREAD)
cor(up$NUMPROCESSORS, up$MAXMPL)

cor(up$ACTROWPOOL, up$MAXMPL)

cor(up$ATP, up$MAXMPL)

cor(up$PCTUPDATE, up$MAXMPL)

cor(up$NUMPROCESSORS, up$ATP)

cor(up$PK, up$ATP)

cor(up$ACTROWPOOL, up$ATP)

cor(up$PCTUPDATE, up$ATP)


# MLP
x <- subset(x, x$MAXMPL < 1)
med.fit <- lm(ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK + PCTUPDATE + PCTUPDATE:PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK + 
	    PCTUPDATE + PCTUPDATE:PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.08772 -0.02081 -0.00632  0.01023  0.35570 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.007245   0.018715   0.387 0.700439    
	NUMPROCESSORS  0.098869   0.026094   3.789 0.000438 ***
	PK             0.005545   0.025685   0.216 0.830025    
	PCTREAD       -0.031432   0.034745  -0.905 0.370366    
	PCTUPDATE     -0.018877   0.036843  -0.512 0.610850    
	PK:PCTREAD    -0.014315   0.046473  -0.308 0.759447    
	PK:PCTUPDATE  -0.086756   0.072997  -1.188 0.240742    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.06401 on 46 degrees of freedom
	Multiple R-squared:  0.2825,	Adjusted R-squared:  0.1889 
	F-statistic: 3.019 on 6 and 46 DF,  p-value: 0.01426

out.fit <- lm(MAXMPL ~ PK + PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + PCTREAD + PCTUPDATE + ACTROWPOOL + 
	    ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.34136 -0.15281  0.00922  0.11340  0.44184 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.29436    0.06252   4.708 2.32e-05 ***
	PK             0.02658    0.05249   0.506  0.61505    
	PCTREAD       -0.07998    0.06747  -1.185  0.24196    
	PCTUPDATE      0.23913    0.09122   2.621  0.01183 *  
	ACTROWPOOL    -0.13200    0.07335  -1.800  0.07849 .  
	ATP           -0.43867    0.41730  -1.051  0.29866    
	NUMPROCESSORS  0.34739    0.08267   4.202  0.00012 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1837 on 46 degrees of freedom
	Multiple R-squared:  0.4222,	Adjusted R-squared:  0.3469 
	F-statistic: 5.603 on 6 and 46 DF,  p-value: 0.0001986

#### thrashing or not thrashing
x = rbind(db2) 
x$MAXMPL[x$MAXMPL < 1] <- 0
out.fit <-  glm(MAXMPL ~ PK + PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, family="binomial", data = x)
summary(out.fit)

	Call:
	glm(formula = MAXMPL ~ PK + PCTREAD + PCTUPDATE + ACTROWPOOL + 
	    ATP + NUMPROCESSORS, family = "binomial", data = x)

	Deviance Residuals: 
	    Min       1Q   Median       3Q      Max  
	-2.6836  -0.9303   0.4488   0.7724   1.4653  

	Coefficients:
		      Estimate Std. Error z value Pr(>|z|)    
	(Intercept)     0.1543     0.4313   0.358   0.7206    
	PK              0.1815     0.3570   0.509   0.6111    
	PCTREAD        -0.1592     0.5053  -0.315   0.7527    
	PCTUPDATE       2.8213     0.7018   4.020 5.81e-05 ***
	ACTROWPOOL     -0.7849     0.4754  -1.651   0.0987 .  
	ATP             2.4995     1.3779   1.814   0.0697 .  
	NUMPROCESSORS   0.9388     0.4760   1.972   0.0486 *  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	(Dispersion parameter for binomial family taken to be 1)

	    Null deviance: 232.51  on 201  degrees of freedom
	Residual deviance: 194.11  on 195  degrees of freedom
	AIC: 208.11

	Number of Fisher Scoring iterations: 5

>1-out.fit$deviance/out.fit$null.deviance
[1] 0.1651489

> confint(out.fit)
Waiting for profiling to be done...
                    2.5 %    97.5 %
(Intercept)   -0.69068157 1.0101689
PK            -0.51748052 0.8874028
PCTREAD       -1.15648981 0.8359234
PCTUPDATE      1.52394519 4.2946253
ACTROWPOOL    -1.73489274 0.1371943
ATP            0.27599676 6.2211911
NUMPROCESSORS  0.03094033 1.9087744



















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

