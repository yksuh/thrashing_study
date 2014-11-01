# Overall: 33.4% (close to suboptimal)
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
# ATP normalization
# db2
db2 <- subset(x, x$DBMS=='db2')
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
# mysql
mysql <- subset(x, x$DBMS=='mysql')
mysql$ATP = (mysql$ATP-min(mysql$ATP))/(max(mysql$ATP)-min(mysql$ATP))
mysql$MAXMPL = (mysql$MAXMPL-min(mysql$MAXMPL))/(max(mysql$MAXMPL)-min(mysql$MAXMPL))
mysql$MAXMPL[mysql$MAXMPL == 1] <- 5
mysql$MAXMPL[mysql$MAXMPL > 0.75 & mysql$MAXMPL <= 1] <- 4
mysql$MAXMPL[mysql$MAXMPL > 0.5 & mysql$MAXMPL <= 0.75] <- 3
mysql$MAXMPL[mysql$MAXMPL > 0.25 & mysql$MAXMPL <= 0.50] <- 2
mysql$MAXMPL[mysql$MAXMPL<=0.25] <- 1
mysql$MAXMPL = (mysql$MAXMPL-min(mysql$MAXMPL))/(max(mysql$MAXMPL)-min(mysql$MAXMPL))
mysql$ACTROWPOOL = (mysql$ACTROWPOOL-min(mysql$ACTROWPOOL))/(max(mysql$ACTROWPOOL)-min(mysql$ACTROWPOOL))
mysql$PCTREAD = (mysql$PCTREAD-min(mysql$PCTREAD))/(max(mysql$PCTREAD)-min(mysql$PCTREAD))
mysql$PCTUPDATE = (mysql$PCTUPDATE-min(mysql$PCTUPDATE))/(max(mysql$PCTUPDATE)-min(mysql$PCTUPDATE))
mysql$NUMPROCESSORS = (mysql$NUMPROCESSORS-min(mysql$NUMPROCESSORS))/(max(mysql$NUMPROCESSORS)-min(mysql$NUMPROCESSORS))
# oracle
oracle <- subset(x, x$DBMS=='oracle')
oracle$ATP = (oracle$ATP-min(oracle$ATP))/(max(oracle$ATP)-min(oracle$ATP))
oracle$MAXMPL = (oracle$MAXMPL-min(oracle$MAXMPL))/(max(oracle$MAXMPL)-min(oracle$MAXMPL))
oracle$MAXMPL[oracle$MAXMPL == 1] <- 5
oracle$MAXMPL[oracle$MAXMPL > 0.75 & oracle$MAXMPL <= 1] <- 4
oracle$MAXMPL[oracle$MAXMPL > 0.5 & oracle$MAXMPL <= 0.75] <- 3
oracle$MAXMPL[oracle$MAXMPL > 0.25 & oracle$MAXMPL <= 0.50] <- 2
oracle$MAXMPL[oracle$MAXMPL<=0.25] <- 1
oracle$MAXMPL = (oracle$MAXMPL-min(oracle$MAXMPL))/(max(oracle$MAXMPL)-min(oracle$MAXMPL))
oracle$ACTROWPOOL = (oracle$ACTROWPOOL-min(oracle$ACTROWPOOL))/(max(oracle$ACTROWPOOL)-min(oracle$ACTROWPOOL))
oracle$PCTREAD = (oracle$PCTREAD-min(oracle$PCTREAD))/(max(oracle$PCTREAD)-min(oracle$PCTREAD))
oracle$PCTUPDATE = (oracle$PCTUPDATE-min(oracle$PCTUPDATE))/(max(oracle$PCTUPDATE)-min(oracle$PCTUPDATE))
oracle$NUMPROCESSORS = (oracle$NUMPROCESSORS-min(oracle$NUMPROCESSORS))/(max(oracle$NUMPROCESSORS)-min(oracle$NUMPROCESSORS))
# pgsql
pgsql <- subset(x, x$DBMS=='pgsql')
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
# sqlserver
sqlserver <- subset(x, x$DBMS=='sqlserver')
sqlserver$ACTROWPOOL = (sqlserver$ACTROWPOOL-min(sqlserver$ACTROWPOOL))/(max(sqlserver$ACTROWPOOL)-min(sqlserver$ACTROWPOOL))
sqlserver$PCTREAD = (sqlserver$PCTREAD-min(sqlserver$PCTREAD))/(max(sqlserver$PCTREAD)-min(sqlserver$PCTREAD))
sqlserver$PCTUPDATE = (sqlserver$PCTUPDATE-min(sqlserver$PCTUPDATE))/(max(sqlserver$PCTUPDATE)-min(sqlserver$PCTUPDATE))
sqlserver$NUMPROCESSORS = (sqlserver$NUMPROCESSORS-min(sqlserver$NUMPROCESSORS))/(max(sqlserver$NUMPROCESSORS)-min(sqlserver$NUMPROCESSORS))
sqlserver$ATP = (sqlserver$ATP-min(sqlserver$ATP))/(max(sqlserver$ATP)-min(sqlserver$ATP))
sqlserver$MAXMPL = (sqlserver$MAXMPL-min(sqlserver$MAXMPL))/(max(sqlserver$MAXMPL)-min(sqlserver$MAXMPL))
sqlserver$MAXMPL[sqlserver$MAXMPL == 1] <- 5
sqlserver$MAXMPL[sqlserver$MAXMPL > 0.75 & sqlserver$MAXMPL <= 1] <- 4
sqlserver$MAXMPL[sqlserver$MAXMPL > 0.5 & sqlserver$MAXMPL <= 0.75] <- 3
sqlserver$MAXMPL[sqlserver$MAXMPL > 0.25 & sqlserver$MAXMPL <= 0.50] <- 2
sqlserver$MAXMPL[sqlserver$MAXMPL<=0.25] <- 1
sqlserver$MAXMPL = (sqlserver$MAXMPL-min(sqlserver$MAXMPL))/(max(sqlserver$MAXMPL)-min(sqlserver$MAXMPL))
x = rbind(db2,oracle,mysql,pgsql,sqlserver) 

> cor(x$NUMPROCESSORS, x$ATP)
[1] -0.1262903
> cor(x$PCTREAD, x$ATP)
[1] 0.05245677
> cor(x$PK, x$ATP)
[1] -0.2166788
> cor(x$PCTUPDATE, x$ATP)
-0.1078481
> cor(x$ACTROWPOOL, x$ATP)
[1] 0.07394266
> cor(x$ATP, x$MAXMPL)
[1] -0.1007889
>  cor(x$NUMPROCESSORS, x$MAXMPL)
[1] 0.0006660305
> cor(x$PCTREAD, x$MAXMPL)
[1] -0.05633367
>  cor(x$PCTUPDATE, x$MAXMPL)
[1] 0.008980045
> cor(x$ACTROWPOOL, x$MAXMPL)
[1] -0.05982288
> cor(x$PK, x$MAXMPL)
[1] 0.1547508

> med.fit <- lm(ATP ~ NUMPROCESSORS + PK + PCTUPDATE + PCTUPDATE:PK, data = x)
> summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK + PCTUPDATE + PCTUPDATE:PK, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.31739 -0.13452 -0.09765  0.10099  0.90127 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.31761    0.01722  18.440  < 2e-16 ***
	NUMPROCESSORS -0.07736    0.02007  -3.854 0.000124 ***
	PK            -0.18572    0.02243  -8.279 3.94e-16 ***
	PCTUPDATE     -0.20427    0.02911  -7.016 4.19e-12 ***
	PK:PCTUPDATE   0.21675    0.04219   5.137 3.35e-07 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2497 on 999 degrees of freedom
	Multiple R-squared:  0.09942,	Adjusted R-squared:  0.09581 
	F-statistic: 27.57 on 4 and 999 DF,  p-value: < 2.2e-16

### more processors are helpful to improve ATP, through which thrashing could less occur. 
> out.fit <- lm(MAXMPL ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS + PK, data = x)
> summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + 
	    NUMPROCESSORS + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.71018 -0.40781 -0.03728  0.39523  0.59891 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.59646    0.03638  16.396  < 2e-16 ***
	PCTREAD       -0.07825    0.04519  -1.732   0.0836 .  
	PCTUPDATE     -0.03446    0.03928  -0.877   0.3805    
	ACTROWPOOL    -0.05979    0.03534  -1.692   0.0909 .  
	ATP           -0.12887    0.05241  -2.459   0.0141 *  
	NUMPROCESSORS -0.01298    0.03385  -0.383   0.7015    
	PK             0.11660    0.02695   4.326 1.67e-05 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.4177 on 997 degrees of freedom
	Multiple R-squared:  0.03633,	Adjusted R-squared:  0.03053 
	F-statistic: 6.265 on 6 and 997 DF,  p-value: 1.785e-06

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS", robustSE = TRUE, conf.level=.1, sims = 100)
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK", robustSE = TRUE, conf.level = .1, sims = 100)
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE", robustSE = TRUE, conf.level = .1, sims = 100)
sens.out <- medsens(med.out, effect.type = "both")

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS", robustSE = TRUE)
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            0.00997      0.00194      0.02049    0.00
	ADE            -0.01259     -0.07980      0.05758    0.72
	Total Effect   -0.00262     -0.06753      0.06517    0.94
	Prop. Mediated -0.08902     -5.56520      5.76249    0.94

	Sample Size Used: 1004 


	Simulations: 1000

> sens.out <- medsens(med.out, effect.type = "both")
> summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.1 -0.0027      -0.0104        0.005         0.01       0.0087

	Rho at which ACME = 0: -0.1
	R^2_M*R^2_Y* at which ACME = 0: 0.01
	R^2_M~R^2_Y~ at which ACME = 0: 0.0087 


	Mediation Sensitivity Analysis for Average Direct Effect

	Sensitivity Region

	       Rho     ADE 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	 [1,] -0.5  0.0620      -0.0129       0.1369         0.25       0.2170
	 [2,] -0.4  0.0436      -0.0278       0.1150         0.16       0.1389
	 [3,] -0.3  0.0277      -0.0415       0.0969         0.09       0.0781
	 [4,] -0.2  0.0134      -0.0545       0.0812         0.04       0.0347
	 [5,] -0.1  0.0000      -0.0673       0.0672         0.01       0.0087
	 [6,]  0.0 -0.0130      -0.0802       0.0542         0.00       0.0000
	 [7,]  0.1 -0.0259      -0.0937       0.0419         0.01       0.0087
	 [8,]  0.2 -0.0391      -0.1081       0.0299         0.04       0.0347
	 [9,]  0.3 -0.0532      -0.1240       0.0177         0.09       0.0781
	[10,]  0.4 -0.0687      -0.1423       0.0049         0.16       0.1389

	Rho at which ADE = 0: -0.1
	R^2_M*R^2_Y* at which ADE = 0: 0.01
	R^2_M~R^2_Y~ at which ADE = 0: 0.0087

> sens.out$r.square.y
[1] 0.03633114
> sens.out$r.square.m
[1] 0.09941995

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK", robustSE = TRUE)
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            0.01358      0.00263      0.02603    0.01
	ADE             0.11604      0.06487      0.17147    0.00
	Total Effect    0.12962      0.07795      0.18359    0.00
	Prop. Mediated  0.10196      0.02047      0.23427    0.01

	Sample Size Used: 1004 


	Simulations: 1000 

sens.out <- medsens(med.out, effect.type = "both")
summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.1 -0.0063      -0.0238       0.0113         0.01       0.0087

	Rho at which ACME = 0: -0.1
	R^2_M*R^2_Y* at which ACME = 0: 0.01
	R^2_M~R^2_Y~ at which ACME = 0: 0.0087 


	Mediation Sensitivity Analysis for Average Direct Effect

	Sensitivity Region

	     Rho     ADE 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] 0.4  0.0434      -0.0139       0.1007         0.16       0.1389
	[2,] 0.5  0.0199      -0.0406       0.0803         0.25       0.2170
	[3,] 0.6 -0.0090      -0.0740       0.0561         0.36       0.3124
	[4,] 0.7 -0.0475      -0.1199       0.0249         0.49       0.4253

	Rho at which ADE = 0: 0.6
	R^2_M*R^2_Y* at which ADE = 0: 0.36
	R^2_M~R^2_Y~ at which ADE = 0: 0.3124 


> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE", robustSE = TRUE)
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            0.01286      0.00234      0.02466    0.02
	ADE            -0.03405     -0.11645      0.04443    0.40
	Total Effect   -0.02119     -0.10338      0.05973    0.60
	Prop. Mediated -0.20067     -3.72675      5.50030    0.60

	Sample Size Used: 1004 


	Simulations: 1000

> sens.out <- medsens(med.out, effect.type = "both")
> summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.1 -0.0068       -0.026       0.0124         0.01       0.0087

	Rho at which ACME = 0: -0.1
	R^2_M*R^2_Y* at which ACME = 0: 0.01
	R^2_M~R^2_Y~ at which ACME = 0: 0.0087 


	Mediation Sensitivity Analysis for Average Direct Effect

	Sensitivity Region

	      Rho     ADE 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.5  0.0613      -0.0222       0.1448         0.25       0.2170
	[2,] -0.4  0.0377      -0.0423       0.1178         0.16       0.1389
	[3,] -0.3  0.0174      -0.0604       0.0953         0.09       0.0781
	[4,] -0.2 -0.0009      -0.0775       0.0758         0.04       0.0347
	[5,] -0.1 -0.0180      -0.0942       0.0582         0.01       0.0087
	[6,]  0.0 -0.0345      -0.1108       0.0419         0.00       0.0000
	[7,]  0.1 -0.0509      -0.1280       0.0263         0.01       0.0087
	[8,]  0.2 -0.0677      -0.1463       0.0109         0.04       0.0347

	Rho at which ADE = 0: -0.2
	R^2_M*R^2_Y* at which ADE = 0: 0.04
	R^2_M~R^2_Y~ at which ADE = 0: 0.0347

> test.modmed(med.out, covariates.1 = list (x$PK == 1), covariates.2 = list (x$PK == 0), data = x)

		Test of ACME(covariates.1) - ACME(covariates.2) = 0

	data:  estimates from med.out
	ACME(covariates.1) - ACME(covariates.2) = -2e-04, p-value = 0.972
	alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.01570716  0.01569229


		Test of ADE(covariates.1) - ADE(covariates.2) = 0

	data:  estimates from med.out
	ADE(covariates.1) - ADE(covariates.2) = -9e-04, p-value = 0.98
	alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.1052941  0.1060070

-----
library(lavaan)
thrashing_model <- '
     # mediator
      ATP ~ a1*NUMPROCESSORS+a3*PK+a4*PCTUPDATE
    # dependent variable
     # MAXMPL ~ b1*ATP+c1*NUMPROCESSORS+c2*ACTROWPOOL+c4*PCTUPDATE+c5*PCTREAD+c3*PK
      MAXMPL ~ b1*ATP+c1*NUMPROCESSORS+c2*ACTROWPOOL+c4*PCTUPDATE+c5*PCTREAD+c3*PK
   # interactions
    # INT_1 := a3*a4
	'
#fit <- sem(thrashing_model, estimator="DWLS", data = x)
#fit <- sem(thrashing_model, data = x)
fit <- sem(thrashing_model,estimator="WLSMV", data = x)
#fit <- sem(thrashing_model,estimator="MLMVS", data = x)
#fit <- sem(thrashing_model,estimator="MLR", data = x)
summary(fit, fit.measures = TRUE, standardized=TRUE, rsq=T)

lavaan (0.5-17) converged normally after  72 iterations

  Number of observations                          1004

  Estimator                                       DWLS      Robust
  Minimum Function Test Statistic                5.273       7.165
  Degrees of freedom                                 2           2
  P-value (Chi-square)                           0.072       0.028
  Scaling correction factor                                  0.739
  Shift parameter                                            0.035
    for simple second-order correction (Mplus variant)

Model test baseline model:

  Minimum Function Test Statistic              137.822     127.754
  Degrees of freedom                                11          11
  P-value                                        0.000       0.000

User model versus baseline model:

  Comparative Fit Index (CFI)                    0.974       0.956
  Tucker-Lewis Index (TLI)                       0.858       0.757

Root Mean Square Error of Approximation:

  RMSEA                                          0.040       0.051
  90 Percent Confidence Interval          0.000  0.084       0.014  0.093
  P-value RMSEA <= 0.05                          0.568       0.410

Standardized Root Mean Square Residual:

  SRMR                                           0.012       0.012

Parameter estimates:

  Information                                 Expected
  Standard Errors                           Robust.sem

                   Estimate  Std.err  Z-value  P(>|z|)   Std.lv  Std.all
Regressions:
  ATP ~
    NUMPROCE (a1)    -0.079    0.019   -4.075    0.000   -0.079   -0.119
    PK       (a3)    -0.105    0.016   -6.628    0.000   -0.105   -0.200
    PCTUPDAT (a4)    -0.107    0.022   -4.741    0.000   -0.107   -0.152
  MAXMPL ~
    ATP      (b1)    -0.138    0.050   -2.775    0.006   -0.138   -0.085
    NUMPROCE (c1)    -0.014    0.034   -0.415    0.678   -0.014   -0.013
    ACTROWPO (c2)    -0.064    0.035   -1.821    0.069   -0.064   -0.057
    PCTUPDAT (c4)    -0.038    0.039   -0.954    0.340   -0.038   -0.033
    PCTREAD  (c5)    -0.081    0.045   -1.780    0.075   -0.081   -0.061
    PK       (c3)     0.115    0.027    4.265    0.000    0.115    0.135

Covariances:
  NUMPROCESSORS ~~
    PK                0.006    0.006    0.900    0.368    0.006    0.028
    PCTUPDATE        -0.001    0.005   -0.254    0.800   -0.001   -0.008
    ACTROWPOOL       -0.002    0.005   -0.455    0.649   -0.002   -0.014
    PCTREAD           0.003    0.004    0.778    0.437    0.003    0.025
  PK ~~
    PCTUPDATE         0.002    0.006    0.374    0.708    0.002    0.012
    ACTROWPOOL       -0.005    0.006   -0.790    0.430   -0.005   -0.025
    PCTREAD          -0.004    0.005   -0.770    0.441   -0.004   -0.025
  PCTUPDATE ~~
    ACTROWPOOL       -0.002    0.004   -0.539    0.590   -0.002   -0.017
    PCTREAD          -0.052    0.004  -14.769    0.000   -0.052   -0.429
  ACTROWPOOL ~~
    PCTREAD          -0.001    0.004   -0.205    0.838   -0.001   -0.006

Intercepts:
    ATP               0.283    0.018   15.955    0.000    0.283    1.076
    MAXMPL            0.603    0.039   15.584    0.000    0.603    1.422
    NUMPROCESSORS     0.399    0.012   32.181    0.000    0.399    1.016
    PK                0.479    0.016   30.357    0.000    0.479    0.959
    PCTUPDATE         0.377    0.012   31.929    0.000    0.377    1.009
    ACTROWPOOL        0.499    0.012   42.189    0.000    0.499    1.332
    PCTREAD           0.137    0.010   13.394    0.000    0.137    0.423

Variances:
    ATP               0.064    0.004                      0.064    0.921
    MAXMPL            0.173    0.004                      0.173    0.963
    NUMPROCESSORS     0.154    0.004                      0.154    1.000
    PK                0.250    0.001                      0.250    1.000
    PCTUPDATE         0.140    0.004                      0.140    1.000
    ACTROWPOOL        0.140    0.004                      0.140    1.000
    PCTREAD           0.104    0.008                      0.104    1.000

R-Square:

    ATP               0.079
    MAXMPL            0.037


