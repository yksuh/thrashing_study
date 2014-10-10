# mysql
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
# ATP normalization
mysql <- subset(x, x$DBMS=='mysql')
mysql$ATP = (mysql$ATP-min(mysql$ATP))/(max(mysql$ATP)-min(pgsql$ATP))
mysql$MAXMPL = (mysql$MAXMPL-min(mysql$MAXMPL))/(max(mysql$MAXMPL)-min(mysql$MAXMPL))
x = rbind(mysql) 
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
     INT_3 := a1*a2'
fit <- sem(thrashing_model, data = x)
summary(fit, standardized=TRUE, rsq=T) 

	lavaan (0.5-17) converged normally after  28 iterations

	  Number of observations                           201

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
	    NUMPROCE (a1)    -0.029    0.027   -1.061    0.289   -0.029   -0.049
	    ACTROWPO (a2)     0.145    0.028    5.114    0.000    0.145    0.235
	    PK       (a3)    -0.326    0.021  -15.347    0.000   -0.326   -0.705
	    PCTUPDAT (a4)     0.057    0.031    1.854    0.064    0.057    0.092
	    PCTREAD  (a5)     0.108    0.042    2.597    0.009    0.108    0.129
	  MAXMPL ~
	    ATP      (b1)    -1.091    0.135   -8.101    0.000   -1.091   -0.657
	    NUMPROCE (c2)    -0.067    0.052   -1.275    0.202   -0.067   -0.067
	    ACTROWPO (c3)     0.009    0.058    0.163    0.871    0.009    0.009
	    PCTUPDAT (c4)     0.482    0.059    8.143    0.000    0.482    0.470
	    PCTREAD  (c5)    -0.074    0.081   -0.909    0.364   -0.074   -0.053
	    PK       (c6)    -0.303    0.060   -5.068    0.000   -0.303   -0.394

	Variances:
	    ATP               0.023    0.002                      0.023    0.422
	    MAXMPL            0.082    0.008                      0.082    0.557

	Defined parameters:
	    INT_1            -0.019    0.010   -1.830    0.067   -0.019   -0.065
	    INT_3            -0.004    0.004   -1.047    0.295   -0.004   -0.011

	R-Square:

	    ATP               0.578
	    MAXMPL            0.443


library(mediation)
med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + PK + PCTREAD + PCTUPDATE + PCTUPDATE:PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + 
	    PK + PCTREAD + PCTUPDATE + PCTUPDATE:PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.28465 -0.07289 -0.01322  0.06094  0.38899 

	Coefficients:
		                 Estimate Std. Error t value Pr(>|t|)    
	(Intercept)               0.50360    0.02652  18.992  < 2e-16 ***
	NUMPROCESSORS            -0.03681    0.03680  -1.000 0.318513    
	ACTROWPOOL                0.13033    0.03315   3.932 0.000118 ***
	PK                       -0.52348    0.02519 -20.783  < 2e-16 ***
	PCTREAD                   0.10255    0.03394   3.021 0.002857 ** 
	PCTUPDATE                -0.17542    0.03300  -5.315 2.92e-07 ***
	NUMPROCESSORS:ACTROWPOOL  0.02068    0.05976   0.346 0.729717    
	PK:PCTUPDATE              0.49175    0.04593  10.706  < 2e-16 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1213 on 193 degrees of freedom
	Multiple R-squared:  0.7354,	Adjusted R-squared:  0.7258 
	F-statistic: 76.63 on 7 and 193 DF,  p-value: < 2.2e-16

out.fit <- lm(MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + PCTREAD + PK, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + 
	    PCTREAD + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.68894 -0.15883  0.02775  0.23346  0.66716 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    1.079203   0.077367  13.949  < 2e-16 ***
	ATP           -1.090504   0.137018  -7.959 1.42e-13 ***
	ACTROWPOOL     0.009391   0.058650   0.160    0.873    
	NUMPROCESSORS -0.066801   0.053318  -1.253    0.212    
	PCTUPDATE      0.482025   0.060253   8.000 1.11e-13 ***
	PCTREAD       -0.073627   0.082473  -0.893    0.373    
	PK            -0.303037   0.060867  -4.979 1.41e-06 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2917 on 194 degrees of freedom
	Multiple R-squared:  0.443,	Adjusted R-squared:  0.4258 
	F-statistic: 25.72 on 6 and 194 DF,  p-value: < 2.2e-16

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME             0.0299      -0.0178       0.0843    0.22
	ADE             -0.0678      -0.1719       0.0427    0.24
	Total Effect    -0.0379      -0.1615       0.0813    0.56
	Prop. Mediated  -0.1880      -6.5605       6.9166    0.74

	Sample Size Used: 201 


	Simulations: 1000

test.modmed(med.out, covariates.1 = list (x$ACTROWPOOL < 0.5), covariates.2 = list (x$x$ACTROWPOOL >= 0.5), data = x)

		Test of ACME(covariates.1) - ACME(covariates.2) = 0

	data:  estimates from med.out
	ACME(covariates.1) - ACME(covariates.2) = 2e-04, p-value = 0.982
	alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.06940312  0.06666225


		Test of ADE(covariates.1) - ADE(covariates.2) = 0

	data:  estimates from med.out
	ADE(covariates.1) - ADE(covariates.2) = 0.0014, p-value = 0.928
	alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.1410742  0.1400013

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            -0.0618      -0.1174      -0.0060    0.02
	ADE              0.4813       0.3538       0.5995    0.00
	Total Effect     0.4194       0.2886       0.5461    0.00
	Prop. Mediated  -0.1445      -0.3390      -0.0139    0.02

	Sample Size Used: 201 


	Simulations: 1000

test.modmed(med.out, covariates.1 = list (x$PK == 1), covariates.2 = list (x$PK == 0), data = x)

		Test of ACME(covariates.1) - ACME(covariates.2) = 0

	data:  estimates from med.out
	ACME(covariates.1) - ACME(covariates.2) = 0.001, p-value = 0.958
	alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.08081274  0.07502867


		Test of ADE(covariates.1) - ADE(covariates.2) = 0

	data:  estimates from med.out
	ADE(covariates.1) - ADE(covariates.2) = 0.002, p-value = 0.992
	alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.1724564  0.1771872
