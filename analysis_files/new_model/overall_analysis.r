# Overall
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
# ATP normalization
# db2
db2 <- subset(x, x$DBMS=='db2')
db2$ATP = (db2$ATP-min(db2$ATP))/(max(db2$ATP)-min(db2$ATP))
db2$MAXMPL = (db2$MAXMPL-min(db2$MAXMPL))/(max(db2$MAXMPL)-min(db2$MAXMPL))
# oracle
oracle <- subset(x, x$DBMS=='oracle')
oracle$ATP = (oracle$ATP-min(oracle$ATP))/(max(oracle$ATP)-min(oracle$ATP))
oracle$MAXMPL = (oracle$MAXMPL-min(oracle$MAXMPL))/(max(oracle$MAXMPL)-min(oracle$MAXMPL))
# mysql
mysql <- subset(x, x$DBMS=='mysql')
mysql$ATP = (mysql$ATP-min(mysql$ATP))/(max(mysql$ATP)-min(pgsql$ATP))
mysql$MAXMPL = (mysql$MAXMPL-min(mysql$MAXMPL))/(max(mysql$MAXMPL)-min(mysql$MAXMPL))
# pgsql
pgsql <- subset(x, x$DBMS=='pgsql')
pgsql$ATP = (pgsql$ATP-min(pgsql$ATP))/(max(pgsql$ATP)-min(pgsql$ATP))
pgsql$MAXMPL = (pgsql$MAXMPL-min(pgsql$MAXMPL))/(max(pgsql$MAXMPL)-min(pgsql$MAXMPL))
# sqlserver
sqlserver <- subset(x, x$DBMS=='sqlserver')
sqlserver$ATP = (sqlserver$ATP-min(sqlserver$ATP))/(max(sqlserver$ATP)-min(sqlserver$ATP))
sqlserver$MAXMPL = (sqlserver$MAXMPL-min(sqlserver$MAXMPL))/(max(sqlserver$MAXMPL)-min(sqlserver$MAXMPL))
# combine all
x = rbind(db2,oracle,mysql,pgsql,sqlserver) 
x$ACTROWPOOL = (x$ACTROWPOOL-min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)-min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD-min(x$PCTREAD))/(max(x$PCTREAD)-min(x$PCTREAD))
x$PCTUPDATE = (x$PCTUPDATE-min(x$PCTUPDATE))/(max(x$PCTUPDATE)-min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS-min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)-min(x$NUMPROCESSORS))

library(lavaan)
thrashing_model <- '
     # mediator
      ATP ~ a1*NUMPROCESSORS+a2*ACTROWPOOL+a3*PK+a4*PCTUPDATE+a5*PCTREAD
    # dependent variable
      MAXMPL ~ b1*ATP + c2*NUMPROCESSORS + c3*ACTROWPOOL + c4*PCTUPDATE + c5*PCTREAD + c6*PK
    # interactions
     INT_1 := a3*a4
     '
fit <- sem(thrashing_model, data = x)
summary(fit, standardized=TRUE, rsq=T) 

lavaan (0.5-17) converged normally after  24 iterations

  Number of observations                          1004

  Estimator                                         ML
  Minimum Function Test Statistic                0.000
  Degrees of freedom                                 0
  Minimum Function Value               0.0000000000000

Parameter estimates:

  Information                                 Expected
  Standard Errors                             Standard

                   Estimate  Std.err  Z-value  P(>|z|)   Std.lv  Std.all
Regressions:
  ATP ~
    NUMPROCE (a1)    -0.079    0.020   -3.909    0.000   -0.079   -0.118
    ACTROWPO (a2)     0.051    0.021    2.408    0.016    0.051    0.073
    PK       (a3)    -0.103    0.016   -6.486    0.000   -0.103   -0.196
    PCTUPDAT (a4)    -0.093    0.023   -3.948    0.000   -0.093   -0.132
    PCTREAD  (a5)     0.022    0.027    0.807    0.420    0.022    0.027
  MAXMPL ~
    ATP      (b1)    -0.066    0.048   -1.393    0.164   -0.066   -0.045
    NUMPROCE (c2)    -0.032    0.031   -1.045    0.296   -0.032   -0.033
    ACTROWPO (c3)    -0.059    0.032   -1.849    0.064   -0.059   -0.057
    PCTUPDAT (c4)    -0.015    0.036   -0.431    0.666   -0.015   -0.015
    PCTREAD  (c5)    -0.069    0.041   -1.690    0.091   -0.069   -0.058
    PK       (c6)     0.119    0.024    4.888    0.000    0.119    0.155

Variances:
    ATP               0.063    0.003                      0.063    0.919
    MAXMPL            0.143    0.006                      0.143    0.963

Defined parameters:
    INT_1             0.010    0.003    3.379    0.001    0.010    0.026

R-Square:

    ATP               0.081
    MAXMPL            0.037

library(mediation)
med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + PK + PCTREAD + PCTUPDATE + PCTUPDATE:PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + PK + PCTREAD + 
	    PCTUPDATE + PCTUPDATE:PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.35680 -0.14296 -0.08979  0.10479  0.88057 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.28614    0.02159  13.251  < 2e-16 ***
	NUMPROCESSORS -0.07747    0.02004  -3.867 0.000118 ***
	ACTROWPOOL     0.05117    0.02101   2.435 0.015063 *  
	PK            -0.18488    0.02239  -8.258 4.66e-16 ***
	PCTREAD        0.01974    0.02694   0.733 0.463931    
	PCTUPDATE     -0.19646    0.03080  -6.379 2.72e-10 ***
	PK:PCTUPDATE   0.21631    0.04210   5.138 3.34e-07 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2491 on 997 degrees of freedom
	Multiple R-squared:  0.1052,	Adjusted R-squared:  0.09981 
	F-statistic: 19.53 on 6 and 997 DF,  p-value: < 2.2e-16

out.fit <- lm(MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + PCTREAD + PK, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + 
	    PCTREAD + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.76003 -0.33345  0.03219  0.33729  0.51504 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.64604    0.03308  19.528  < 2e-16 ***
	ATP           -0.06617    0.04767  -1.388   0.1654    
	ACTROWPOOL    -0.05922    0.03214  -1.843   0.0657 .  
	NUMPROCESSORS -0.03204    0.03078  -1.041   0.2981    
	PCTUPDATE     -0.01534    0.03572  -0.430   0.6676    
	PCTREAD       -0.06920    0.04109  -1.684   0.0925 .  
	PK             0.11938    0.02451   4.871 1.29e-06 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3798 on 997 degrees of freedom
	Multiple R-squared:  0.03653,	Adjusted R-squared:  0.03073 
	F-statistic:   6.3 on 6 and 997 DF,  p-value: 1.627e-06

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            0.00615     -0.00316      0.01549    0.17
	ADE            -0.01521     -0.09007      0.05136    0.66
	Total Effect   -0.00906     -0.08374      0.05787    0.82
	Prop. Mediated -0.06001     -3.33712      3.48987    0.86

	Sample Size Used: 1004 


	Simulations: 1000

test.modmed(med.out, covariates.1 = list (x$PK == 1), covariates.2 = list (x$PK == 0), data = x)

		Test of ACME(covariates.1) - ACME(covariates.2) = 0

	data:  estimates from med.out
	ACME(covariates.1) - ACME(covariates.2) = 2e-04, p-value = 0.954
	alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.01370137  0.01348423


		Test of ADE(covariates.1) - ADE(covariates.2) = 0

	data:  estimates from med.out
	ADE(covariates.1) - ADE(covariates.2) = -0.0014, p-value = 0.98
	alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.10187884  0.09690727

