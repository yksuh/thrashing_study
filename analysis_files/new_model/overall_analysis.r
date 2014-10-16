# Overall: 33.4% (close to suboptimal)
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

#x$ATP = (x$ATP-min(x$ATP))/(max(x$ATP)-min(x$ATP))
#x$MAXMPL = (x$MAXMPL-min(x$MAXMPL))/(max(x$MAXMPL)-min(x$MAXMPL))
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
     INT_2 := a3*a5
     INT_3 := a1*a2
     '
fit <- sem(thrashing_model, data = x)
summary(fit, fit.measures = TRUE, standardized=TRUE, rsq=T) 


	lavaan (0.5-17) converged normally after  24 iterations

	  Number of observations                          1004

	  Estimator                                         ML
	  Minimum Function Test Statistic                0.000
	  Degrees of freedom                                 0
	  Minimum Function Value               0.0000000000000

	Model test baseline model:

	  Minimum Function Test Statistic              122.711
	  Degrees of freedom                                11
	  P-value                                        0.000

	User model versus baseline model:

	  Comparative Fit Index (CFI)                    1.000
	  Tucker-Lewis Index (TLI)                       1.000

	Loglikelihood and Information Criteria:

	  Loglikelihood user model (H0)              -2764.068
	  Loglikelihood unrestricted model (H1)      -2764.068

	  Number of free parameters                         13
	  Akaike (AIC)                                5554.136
	  Bayesian (BIC)                              5617.989
	  Sample-size adjusted Bayesian (BIC)         5576.700

	Root Mean Square Error of Approximation:

	  RMSEA                                          0.000
	  90 Percent Confidence Interval          0.000  0.000
	  P-value RMSEA <= 0.05                          1.000

	Standardized Root Mean Square Residual:

	  SRMR                                           0.000

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
	    INT_2            -0.002    0.003   -0.803    0.422   -0.002   -0.005
	    INT_3            -0.004    0.002   -2.056    0.040   -0.004   -0.009

	R-Square:

	    ATP               0.081
	    MAXMPL            0.037

### mediation test
### regression on ATP 
library(mediation)
med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + PK + PCTREAD + PCTREAD:PK + PCTUPDATE + PCTUPDATE:PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + 
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

### regression on MAXMPL 
out.fit <- lm(MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + PCTREAD, data = x)
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

### mediation of NUMPROCESSORS via ATP on MAXMPL 
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            0.00883      0.00163      0.01826    0.02
	ADE            -0.03315     -0.09216      0.02719    0.29
	Total Effect   -0.02433     -0.08088      0.03616    0.45
	Prop. Mediated -0.18252     -2.82544      3.61944    0.45

	Sample Size Used: 1004 


	Simulations: 1000

### moderated mediation of NUMPROCESSORS by ACTROWPOOL through ATP  on MAXMPL
test.modmed(med.out, covariates.1 = list (x$ACTROWPOOL < 0.5), covariates.2 = list (x$x$ACTROWPOOL >= 0.5), data = x)

		Test of ACME(covariates.1) - ACME(covariates.2) = 0

	data:  estimates from med.out
	ACME(covariates.1) - ACME(covariates.2) = 3e-04, p-value = 0.95
	alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.01192181  0.01354090


		Test of ADE(covariates.1) - ADE(covariates.2) = 0

	data:  estimates from med.out
	ADE(covariates.1) - ADE(covariates.2) = 0, p-value = 0.982
	alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.09100723  0.07977063


###  mediation of PCTREAD via ATP on MAXMPL 
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTREAD")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		        Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.001885    -0.009544     0.005406    0.53
	ADE            -0.075390    -0.153740     0.000901    0.05
	Total Effect   -0.077274    -0.154676    -0.000321    0.05
	Prop. Mediated  0.020290    -0.123393     0.275152    0.53

	Sample Size Used: 1004 


	Simulations: 1000 

### moderated mediation of NUMPROCESSORS by PK through ATP on MAXMPL
test.modmed(med.out, covariates.1 = list (x$PK == 1), covariates.2 = list (x$PK == 0), data = x)

		Test of ACME(covariates.1) - ACME(covariates.2) = 0

	data:  estimates from med.out
	ACME(covariates.1) - ACME(covariates.2) = -1e-04, p-value = 0.998
	alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.009423882  0.009709655


		Test of ADE(covariates.1) - ADE(covariates.2) = 0

	data:  estimates from med.out
	ADE(covariates.1) - ADE(covariates.2) = -0.002, p-value = 0.994
	alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.1192453  0.1126675

###  mediation of PCTUPDATE via ATP on MAXMPL 
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            0.01084      0.00157      0.02237    0.03
	ADE            -0.02091     -0.09160      0.04839    0.59
	Total Effect   -0.01008     -0.08113      0.05822    0.78
	Prop. Mediated -0.15515     -5.14795      4.28575    0.78

	Sample Size Used: 1004 


	Simulations: 1000

### moderated mediation of PCTUPDATE by PK through ATP on MAXMPL
test.modmed(med.out, covariates.1 = list (x$PK == 1), covariates.2 = list (x$PK == 0), data = x)

		Test of ACME(covariates.1) - ACME(covariates.2) = 0

	data:  estimates from med.out
	ACME(covariates.1) - ACME(covariates.2) = 1e-04, p-value = 0.986
	alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.01370362  0.01402441


		Test of ADE(covariates.1) - ADE(covariates.2) = 0

	data:  estimates from med.out
	ADE(covariates.1) - ADE(covariates.2) = 2e-04, p-value = 0.982
	alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.09855082  0.10051998


## non primary key
y <- subset(x, x$PK == 0) # non-pk
library(lavaan)
thrashing_model <- '
     # mediator
      ATP ~ a1*NUMPROCESSORS+a2*ACTROWPOOL+a4*PCTUPDATE+a5*PCTREAD
    # dependent variable
      MAXMPL ~ b1*ATP + c2*NUMPROCESSORS + c3*ACTROWPOOL + c4*PCTUPDATE + c5*PCTREAD
    # interactions
     INT_3 := a1*a2
     '
fit <- sem(thrashing_model, data = y)
summary(fit, fit.measures = TRUE, standardized=TRUE, rsq=T)

### mediation test
### regression on ATP 
library(mediation)
med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + PCTREAD + PCTUPDATE, data = y)
summary(med.fit)


### regression on MAXMPL 
out.fit <- lm(MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + PCTREAD, data = y)
summary(out.fit)

y <- subset(x, x$PK == 1) # pk
#nrow(y)
library(lavaan)
thrashing_model <- '
     # mediator
      ATP ~ a1*NUMPROCESSORS+a2*ACTROWPOOL+a4*PCTUPDATE+a5*PCTREAD
    # dependent variable
      MAXMPL ~ b1*ATP + c2*NUMPROCESSORS + c3*ACTROWPOOL + c4*PCTUPDATE + c5*PCTREAD
    # interactions
     INT_3 := a1*a2
     '
fit <- sem(thrashing_model, data = y)
summary(fit, fit.measures = TRUE, standardized=TRUE, rsq=T)

### mediation test
### regression on ATP 
library(mediation)
med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + PCTREAD + PCTUPDATE, data = y)
summary(med.fit)


### regression on MAXMPL 
out.fit <- lm(MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + PCTREAD, data = y)
summary(out.fit)
