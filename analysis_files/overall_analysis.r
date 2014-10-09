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
      MAXMPL ~ b1*ATP + c2*NUMPROCESSORS + c3*ACTROWPOOL + c4*PCTUPDATE + c5*PCTREAD
    # interactions
     INT_1 := a3*a4
     INT_2 := a3*a5
     INT_3 := a1*a2'
fit <- sem(thrashing_model, data = x)
summary(fit, standardized=TRUE, rsq=T) 

	  Number of observations                          1004

	  Estimator                                         ML
	  Minimum Function Test Statistic               23.609
	  Degrees of freedom                                 1
	  P-value (Chi-square)                           0.000

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
	    ATP      (b1)    -0.113    0.047   -2.394    0.017   -0.113   -0.077
	    NUMPROCE (c2)    -0.031    0.031   -1.013    0.311   -0.031   -0.032
	    ACTROWPO (c3)    -0.059    0.032   -1.809    0.070   -0.059   -0.057
	    PCTUPDAT (c4)    -0.019    0.036   -0.525    0.599   -0.019   -0.018
	    PCTREAD  (c5)    -0.072    0.041   -1.735    0.083   -0.072   -0.060

	Variances:
	    ATP               0.063    0.003                      0.063    0.919
	    MAXMPL            0.147    0.007                      0.147    0.986

	Defined parameters:
	    INT_1             0.010    0.003    3.379    0.001    0.010    0.026
	    INT_2            -0.002    0.003   -0.803    0.422   -0.002   -0.005
	    INT_3            -0.004    0.002   -2.056    0.040   -0.004   -0.009

	R-Square:

	    ATP               0.081
	    MAXMPL            0.014

library(mediation)
med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + ACTROWPOOL:NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK + PCTUPDATE + PCTUPDATE:PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + ACTROWPOOL:NUMPROCESSORS + 
	    PK + PCTREAD + PCTREAD:PK + PCTUPDATE + PCTUPDATE:PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.36797 -0.14421 -0.08894  0.10674  0.87696 

	Coefficients:
		                 Estimate Std. Error t value Pr(>|t|)    
	(Intercept)               0.28048    0.02500  11.220  < 2e-16 ***
	NUMPROCESSORS            -0.07219    0.03336  -2.164   0.0307 *  
	ACTROWPOOL                0.05507    0.03002   1.835   0.0668 .  
	PK                       -0.17708    0.02687  -6.590 7.14e-11 ***
	PCTREAD                   0.03268    0.03663   0.892   0.3726    
	PCTUPDATE                -0.19150    0.03223  -5.942 3.89e-09 ***
	NUMPROCESSORS:ACTROWPOOL -0.01059    0.05357  -0.198   0.8433    
	PK:PCTREAD               -0.02846    0.05413  -0.526   0.5992    
	PK:PCTUPDATE              0.20591    0.04658   4.421 1.09e-05 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2493 on 995 degrees of freedom
	Multiple R-squared:  0.1055,	Adjusted R-squared:  0.09828 
	F-statistic: 14.67 on 8 and 995 DF,  p-value: < 2.2e-16

out.fit <- lm(MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + PCTREAD, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + 
	    PCTREAD, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.70646 -0.34468  0.04046  0.35016  0.50577 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.71188    0.03054  23.313   <2e-16 ***
	ATP           -0.11272    0.04723  -2.387   0.0172 *  
	ACTROWPOOL    -0.05862    0.03250  -1.804   0.0716 .  
	NUMPROCESSORS -0.03145    0.03113  -1.010   0.3126    
	PCTUPDATE     -0.01892    0.03612  -0.524   0.6005    
	PCTREAD       -0.07188    0.04155  -1.730   0.0840 .  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3841 on 998 degrees of freedom
	Multiple R-squared:  0.01361,	Adjusted R-squared:  0.008664 
	F-statistic: 2.753 on 5 and 998 DF,  p-value: 0.01769

#med.high_conte <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS", covariates = list (x$ACTROWPOOL < 0.5), data = x)
#summary(med.high_conte)
#med.low_conte <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS", covariates = list (x$ACTROWPOOL >= 0.5))
#summary(med.low_conte)
test.modmed(med.out, covariates.1 = list (x$ACTROWPOOL < 0.5), covariates.2 = list (x$x$ACTROWPOOL >= 0.5), data = x)

		Test of ACME(covariates.1) - ACME(covariates.2) = 0

	data:  estimates from med.out
	ACME(covariates.1) - ACME(covariates.2) = -2e-04, p-value = 0.976
	alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.01170350  0.01093868


		Test of ADE(covariates.1) - ADE(covariates.2) = 0

	data:  estimates from med.out
	ADE(covariates.1) - ADE(covariates.2) = 0.002, p-value = 0.99
	alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.0780183  0.0878735

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTREAD")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.00216     -0.00985      0.00419    0.48
	ADE            -0.07113     -0.14841      0.01136    0.10
	Total Effect   -0.07329     -0.15080      0.00930    0.09
	Prop. Mediated  0.02348     -0.20486      0.26175    0.55

	Sample Size Used: 1004 


	Simulations: 1000 

test.modmed(med.out, covariates.1 = list (x$PK == 1), covariates.2 = list (x$PK == 0), data = x)

		Test of ACME(covariates.1) - ACME(covariates.2) = 0

	data:  estimates from med.out
	ACME(covariates.1) - ACME(covariates.2) = 1e-04, p-value = 0.986
	alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.009356355  0.009745168


		Test of ADE(covariates.1) - ADE(covariates.2) = 0

	data:  estimates from med.out
	ADE(covariates.1) - ADE(covariates.2) = -0.0012, p-value = 0.994
	alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.1173037  0.1124526

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            0.01024      0.00192      0.02161    0.01
	ADE            -0.01932     -0.08692      0.05465    0.58
	Total Effect   -0.00908     -0.07933      0.06316    0.80
	Prop. Mediated -0.14100     -4.30469      3.31166    0.80

	Sample Size Used: 1004 


	Simulations: 1000 

test.modmed(med.out, covariates.1 = list (x$PK == 1), covariates.2 = list (x$PK == 0), data = x)

		Test of ACME(covariates.1) - ACME(covariates.2) = 0

	data:  estimates from med.out
	ACME(covariates.1) - ACME(covariates.2) = -3e-04, p-value = 0.958
	alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.01342584  0.01450563


		Test of ADE(covariates.1) - ADE(covariates.2) = 0

	data:  estimates from med.out
	ADE(covariates.1) - ADE(covariates.2) = 0.002, p-value = 0.99
	alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.09913852  0.09940461

