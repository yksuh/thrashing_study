# Overall: 33.4% (close to suboptimal)
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
x <- subset(x, x$MAXMPL < 1100)
# ATP normalization
# db2
db2 <- subset(x, x$DBMS=='db2')
db2$ATP = (db2$ATP-min(db2$ATP))/(max(db2$ATP)-min(db2$ATP))
db2$MAXMPL = (db2$MAXMPL-min(db2$MAXMPL))/(max(db2$MAXMPL)-min(db2$MAXMPL))
db2$ACTROWPOOL = (db2$ACTROWPOOL-min(db2$ACTROWPOOL))/(max(db2$ACTROWPOOL)-min(db2$ACTROWPOOL))
db2$PCTREAD = (db2$PCTREAD-min(db2$PCTREAD))/(max(db2$PCTREAD)-min(db2$PCTREAD))
db2$PCTUPDATE = (db2$PCTUPDATE-min(db2$PCTUPDATE))/(max(db2$PCTUPDATE)-min(db2$PCTUPDATE))
db2$NUMPROCESSORS = (db2$NUMPROCESSORS-min(db2$NUMPROCESSORS))/(max(db2$NUMPROCESSORS)-min(db2$NUMPROCESSORS))
# oracle
oracle <- subset(x, x$DBMS=='oracle')
oracle$ATP = (oracle$ATP-min(oracle$ATP))/(max(oracle$ATP)-min(oracle$ATP))
oracle$MAXMPL = (oracle$MAXMPL-min(oracle$MAXMPL))/(max(oracle$MAXMPL)-min(oracle$MAXMPL))
oracle$ACTROWPOOL = (oracle$ACTROWPOOL-min(oracle$ACTROWPOOL))/(max(oracle$ACTROWPOOL)-min(oracle$ACTROWPOOL))
oracle$PCTREAD = (oracle$PCTREAD-min(oracle$PCTREAD))/(max(oracle$PCTREAD)-min(oracle$PCTREAD))
oracle$PCTUPDATE = (oracle$PCTUPDATE-min(oracle$PCTUPDATE))/(max(oracle$PCTUPDATE)-min(oracle$PCTUPDATE))
oracle$NUMPROCESSORS = (oracle$NUMPROCESSORS-min(oracle$NUMPROCESSORS))/(max(oracle$NUMPROCESSORS)-min(oracle$NUMPROCESSORS))
# mysql
mysql <- subset(x, x$DBMS=='mysql')
mysql$ATP = (mysql$ATP-min(mysql$ATP))/(max(mysql$ATP)-min(mysql$ATP))
mysql$MAXMPL = (mysql$MAXMPL-min(mysql$MAXMPL))/(max(mysql$MAXMPL)-min(mysql$MAXMPL))
mysql$ACTROWPOOL = (mysql$ACTROWPOOL-min(mysql$ACTROWPOOL))/(max(mysql$ACTROWPOOL)-min(mysql$ACTROWPOOL))
mysql$PCTREAD = (mysql$PCTREAD-min(mysql$PCTREAD))/(max(mysql$PCTREAD)-min(mysql$PCTREAD))
mysql$PCTUPDATE = (mysql$PCTUPDATE-min(mysql$PCTUPDATE))/(max(mysql$PCTUPDATE)-min(mysql$PCTUPDATE))
mysql$NUMPROCESSORS = (mysql$NUMPROCESSORS-min(mysql$NUMPROCESSORS))/(max(mysql$NUMPROCESSORS)-min(mysql$NUMPROCESSORS))
# pgsql
pgsql <- subset(x, x$DBMS=='pgsql')
pgsql$ATP = (pgsql$ATP-min(pgsql$ATP))/(max(pgsql$ATP)-min(pgsql$ATP))
pgsql$MAXMPL = (pgsql$MAXMPL-min(pgsql$MAXMPL))/(max(pgsql$MAXMPL)-min(pgsql$MAXMPL))
pgsql$ACTROWPOOL = (pgsql$ACTROWPOOL-min(pgsql$ACTROWPOOL))/(max(pgsql$ACTROWPOOL)-min(pgsql$ACTROWPOOL))
pgsql$PCTREAD = (pgsql$PCTREAD-min(pgsql$PCTREAD))/(max(pgsql$PCTREAD)-min(pgsql$PCTREAD))
pgsql$PCTUPDATE = (pgsql$PCTUPDATE-min(pgsql$PCTUPDATE))/(max(pgsql$PCTUPDATE)-min(pgsql$PCTUPDATE))
pgsql$NUMPROCESSORS = (pgsql$NUMPROCESSORS-min(pgsql$NUMPROCESSORS))/(max(pgsql$NUMPROCESSORS)-min(pgsql$NUMPROCESSORS))
# sqlserver
sqlserver <- subset(x, x$DBMS=='sqlserver')
sqlserver$ACTROWPOOL = (sqlserver$ACTROWPOOL-min(sqlserver$ACTROWPOOL))/(max(sqlserver$ACTROWPOOL)-min(sqlserver$ACTROWPOOL))
sqlserver$PCTREAD = (sqlserver$PCTREAD-min(sqlserver$PCTREAD))/(max(sqlserver$PCTREAD)-min(sqlserver$PCTREAD))
sqlserver$PCTUPDATE = (sqlserver$PCTUPDATE-min(sqlserver$PCTUPDATE))/(max(sqlserver$PCTUPDATE)-min(sqlserver$PCTUPDATE))
sqlserver$NUMPROCESSORS = (sqlserver$NUMPROCESSORS-min(sqlserver$NUMPROCESSORS))/(max(sqlserver$NUMPROCESSORS)-min(sqlserver$NUMPROCESSORS))
sqlserver$ATP = (sqlserver$ATP-min(sqlserver$ATP))/(max(sqlserver$ATP)-min(sqlserver$ATP))
sqlserver$MAXMPL = (sqlserver$MAXMPL-min(sqlserver$MAXMPL))/(max(sqlserver$MAXMPL)-min(sqlserver$MAXMPL))
x = rbind(db2,mysql,oracle,pgsql,sqlserver) 
x$MAXMPL = (x$MAXMPL-min(x$MAXMPL))/(max(x$MAXMPL)-min(x$MAXMPL))



#x$ATP<-round(x$ATP, 6)
#write.table(x, "expl_normal.txt",row.names = TRUE, col.names = TRUE, sep="\t")
#library(foreign)
#write.foreign(format(x, digits=8), "expl_normal.txt", "expl_normal.sps",   package="SPSS")
 med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + PK + PCTUPDATE, data = x)
> med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + PK + PCTUPDATE + PCTUPDATE:PK, data = x)
> summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + PK + PCTUPDATE + 
	    PCTUPDATE:PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.34249 -0.14386 -0.08926  0.10551  0.87560 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.29173    0.02022  14.428  < 2e-16 ***
	NUMPROCESSORS -0.07707    0.02003  -3.848 0.000126 ***
	ACTROWPOOL     0.05102    0.02101   2.428 0.015341 *  
	PK            -0.18532    0.02238  -8.281 3.88e-16 ***
	PCTUPDATE     -0.20397    0.02904  -7.023 4.00e-12 ***
	PK:PCTUPDATE   0.21684    0.04209   5.152 3.11e-07 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2491 on 998 degrees of freedom
	Multiple R-squared:  0.1047,	Adjusted R-squared:  0.1002 
	F-statistic: 23.34 on 5 and 998 DF,  p-value: < 2.2e-16

> cor(x$NUMPROCESSORS, x$ACTROWPOOL, method="pearson")
[1] -0.006397655

This low correlation between numProcs and actRowPool 
are not bounded together, proving the independence of the two variables.

# ask for confidence interval for the model coefficients

> confint(med.fit, conf.level=0.95)
                     2.5 %      97.5 %
(Intercept)    0.252051753  0.33140598
NUMPROCESSORS -0.116363621 -0.03776909
ACTROWPOOL     0.009791852  0.09224876
PK            -0.229233869 -0.14140753
PCTUPDATE     -0.260964529 -0.14698191
PK:PCTUPDATE   0.134249339  0.29943738



> out.fit <- lm(MAXMPL ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS + PK, data = x)
> summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + 
	    NUMPROCESSORS + PK, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.7600 -0.3335  0.0322  0.3373  0.5151 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.64604    0.03308  19.528  < 2e-16 ***
	PCTREAD       -0.06920    0.04109  -1.684   0.0925 .  
	PCTUPDATE     -0.01534    0.03572  -0.429   0.6677    
	ACTROWPOOL    -0.05922    0.03214  -1.843   0.0656 .  
	ATP           -0.06614    0.04766  -1.388   0.1655    
	NUMPROCESSORS -0.03204    0.03078  -1.041   0.2981    
	PK             0.11938    0.02451   4.871 1.29e-06 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3798 on 997 degrees of freedom
	Multiple R-squared:  0.03653,	Adjusted R-squared:  0.03073 
	F-statistic:   6.3 on 6 and 997 DF,  p-value: 1.628e-06

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS", robustSE = TRUE, conf.level=.1, sims = 100)
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK", robustSE = TRUE, conf.level = .1, sims = 100)
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE", robustSE = TRUE, conf.level = .1, sims = 100)
sens.out <- medsens(med.out, effect.type = "both")

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS", robustSE = TRUE, conf.level=.1, sims = 100)
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 10% CI Lower 10% CI Upper p-value
	ACME            0.00573      0.00507      0.00616    0.08
	ADE            -0.03183     -0.03960     -0.02515    0.42
	Total Effect   -0.02610     -0.03268     -0.02124    0.48
	Prop. Mediated -0.11062     -0.12731     -0.09180    0.52

	Sample Size Used: 1004 


	Simulations: 100 


### conflicting mediation effects made by PK (positive) and NUMPROCESSORS (negative) on DBMS thrashing
### no mediation looks happening.
### If we gather data, direct effects from PK or NUMPROCESSORS are too strong, the indirect effects through ATP time seem hidden. 
### PK and NUMPROCESSORS make confounding effects, so the overall amount of variance explained so low.

> sens.out <- medsens(med.out, effect.type = "both")
> summary(sens.out)

Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.1 -0.0063      -0.0136       0.0010         0.01       0.0087
	[2,]  0.0  0.0053      -0.0017       0.0123         0.00       0.0000

	Rho at which ACME = 0: 0
	R^2_M*R^2_Y* at which ACME = 0: 0
	R^2_M~R^2_Y~ at which ACME = 0: 0 


	Mediation Sensitivity Analysis for Average Direct Effect

	Sensitivity Region

	       Rho     ADE 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	 [1,] -0.6  0.0552      -0.0188       0.1291         0.36       0.3114
	 [2,] -0.5  0.0346      -0.0344       0.1037         0.25       0.2163
	 [3,] -0.4  0.0179      -0.0480       0.0838         0.16       0.1384
	 [4,] -0.3  0.0034      -0.0605       0.0674         0.09       0.0779
	 [5,] -0.2 -0.0096      -0.0724       0.0531         0.04       0.0346
	 [6,] -0.1 -0.0218      -0.0840       0.0404         0.01       0.0087
	 [7,]  0.0 -0.0336      -0.0958       0.0286         0.00       0.0000
	 [8,]  0.1 -0.0453      -0.1080       0.0174         0.01       0.0087
	 [9,]  0.2 -0.0574      -0.1211       0.0064         0.04       0.0346

	Rho at which ADE = 0: -0.3
	R^2_M*R^2_Y* at which ADE = 0: 0.09
	R^2_M~R^2_Y~ at which ADE = 0: 0.0779 

> sens.out$r.square.y
[1] 0.03378934
> sens.out$r.square.m
[1] 0.1047084

> sens.out$r.square.m
[1] 0.09941911
> sens.out$r.square.y
[1] 0.03378934

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK", robustSE = TRUE, conf.level = .1, sims = 100)
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 10% CI Lower 10% CI Upper p-value
	ACME            0.00773      0.00624      0.00742    0.02
	ADE             0.12221      0.11620      0.12446    0.00
	Total Effect    0.12994      0.12513      0.13107    0.00
	Prop. Mediated  0.05283      0.04836      0.05997    0.02

	Sample Size Used: 1004 


	Simulations: 100 

> sens.out <- medsens(med.out, effect.type = "both")
> summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Rho at which ACME = 0: 0
	R^2_M*R^2_Y* at which ACME = 0: 0
	R^2_M~R^2_Y~ at which ACME = 0: 0 


	Mediation Sensitivity Analysis for Average Direct Effect

	Rho at which ADE = 0: 0.6
	R^2_M*R^2_Y* at which ADE = 0: 0.36
	R^2_M~R^2_Y~ at which ADE = 0: 0.3114 

> sens.out$r.square.y
[1] 0.03378934
> sens.out$r.square.m
[1] 0.1047084

############################################################################################################################
> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK", robustSE = TRUE)
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            0.00712     -0.00183      0.01673    0.11
	ADE             0.12076      0.07244      0.17041    0.00
	Total Effect    0.12787      0.07967      0.17671    0.00
	Prop. Mediated  0.05410     -0.01319      0.14533    0.11

	Sample Size Used: 1004 


	Simulations: 1000

> sens.out <- medsens(med.out, effect.type = "both")
> summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.1 -0.0145      -0.0300       0.0011         0.01       0.0087
	[2,]  0.0  0.0126      -0.0033       0.0286         0.00       0.0000

	Rho at which ACME = 0: 0
	R^2_M*R^2_Y* at which ACME = 0: 0
	R^2_M~R^2_Y~ at which ACME = 0: 0 


	Mediation Sensitivity Analysis for Average Direct Effect

	Sensitivity Region

	     Rho     ADE 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] 0.5  0.0320      -0.0228       0.0869         0.25       0.2163
	[2,] 0.6  0.0058      -0.0533       0.0649         0.36       0.3114
	[3,] 0.7 -0.0292      -0.0950       0.0367         0.49       0.4239

	Rho at which ADE = 0: 0.6
	R^2_M*R^2_Y* at which ADE = 0: 0.36
	R^2_M~R^2_Y~ at which ADE = 0: 0.3114 

> sens.out$r.square.y
[1] 0.03378934
> sens.out$r.square.m
[1] 0.1047084
############################################################################################################################
> library(mediation)
> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE", robustSE = TRUE)
> summary(med.out)

Causal Mediation Analysis 

Quasi-Bayesian Confidence Intervals

               Estimate 95% CI Lower 95% CI Upper p-value
ACME            0.00665     -0.00221      0.01609    0.13
ADE             0.01173     -0.05302      0.07503    0.75
Total Effect    0.01838     -0.04576      0.08339    0.61
Prop. Mediated  0.11813     -3.38692      2.56093    0.66

Sample Size Used: 1004 


Simulations: 1000 

y <- subset(x, x$PK == 0)
med.fit <- lm(ATP ~ NUMPROCESSORS + PCTUPDATE, data = y)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PCTUPDATE, data = y)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.3158 -0.2056 -0.1011  0.2409  0.8371 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.31606    0.02025  15.605  < 2e-16 ***
	NUMPROCESSORS -0.07346    0.03029  -2.425   0.0156 *  
	PCTUPDATE     -0.20429    0.03131  -6.525 1.62e-10 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2685 on 520 degrees of freedom
	Multiple R-squared:  0.08561,	Adjusted R-squared:  0.08209 
	F-statistic: 24.34 on 2 and 520 DF,  p-value: 7.846e-11

out.fit <- lm(MAXMPL ~ PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS + PCTUPDATE, data = y)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS + 
	    PCTUPDATE, data = y)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.70199 -0.40446 -0.00471  0.38930  0.57964 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.56637    0.04515  12.545   <2e-16 ***
	PCTREAD       -0.09485    0.05800  -1.635   0.1026    
	ACTROWPOOL    -0.04236    0.04629  -0.915   0.3606    
	ATP           -0.03914    0.06452  -0.607   0.5443    
	NUMPROCESSORS  0.02007    0.04478   0.448   0.6542    
	PCTUPDATE      0.11603    0.05247   2.211   0.0275 *  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3944 on 517 degrees of freedom
	Multiple R-squared:  0.03086,	Adjusted R-squared:  0.02148 
	F-statistic: 3.292 on 5 and 517 DF,  p-value: 0.006162


y <- subset(x, x$PK == 1)
med.fit <- lm(ATP ~ NUMPROCESSORS + PCTUPDATE, data = y)
summary(med.fit)

Call:
lm(formula = ATP ~ NUMPROCESSORS + PCTUPDATE, data = y)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.14557 -0.12085 -0.09503 -0.04984  0.90130 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept)    0.13358    0.01848   7.229 1.94e-12 ***
NUMPROCESSORS -0.08140    0.02609  -3.120  0.00192 ** 
PCTUPDATE      0.01236    0.02785   0.444  0.65737    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.2276 on 478 degrees of freedom
Multiple R-squared:  0.02049,	Adjusted R-squared:  0.01639 
F-statistic: 4.999 on 2 and 478 DF,  p-value: 0.007104

out.fit <- lm(MAXMPL ~ PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS + PCTUPDATE, data = y)
summary(out.fit)

Call:
lm(formula = MAXMPL ~ PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS + 
    PCTUPDATE, data = y)

Residuals:
    Min      1Q  Median      3Q     Max 
-0.8286 -0.2515  0.1864  0.2900  0.4875 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept)    0.84099    0.03975  21.159  < 2e-16 ***
PCTREAD       -0.03542    0.05681  -0.624  0.53323    
ACTROWPOOL    -0.08032    0.04351  -1.846  0.06549 .  
ATP           -0.01651    0.07191  -0.230  0.81849    
NUMPROCESSORS -0.08390    0.04114  -2.039  0.04196 *  
PCTUPDATE     -0.15491    0.04792  -3.233  0.00131 ** 
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.3551 on 475 degrees of freedom
Multiple R-squared:  0.0374,	Adjusted R-squared:  0.02727 
F-statistic: 3.691 on 5 and 475 DF,  p-value: 0.002751

> test.modmed(med.out, covariates.1 = list (x$PK == 1), covariates.2 = list (x$PK == 0), data = x)

library(lavaan)
thrashing_model <- '
     # mediator
      ATP ~ a1*NUMPROCESSORS+a3*PK+a4*PCTUPDATE
    # dependent variable
      MAXMPL ~ b1*ATP+c1*NUMPROCESSORS+c2*ACTROWPOOL+c4*PCTUPDATE+c5*PCTREAD
   # interactions
     '
fit <- sem(thrashing_model, estimator="DWLS", data = x)
summary(fit, fit.measures = TRUE, standardized=TRUE, rsq=T)

