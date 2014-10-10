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

### lavaan test
library(lavaan)
thrashing_model <- '
    # mediator
      ATP ~ a1*NUMPROCESSORS+a2*ACTROWPOOL+a3*PK+a4*PCTUPDATE+a5*PCTREAD
    # dependent variable
      MAXMPL ~ b1*ATP + c2*NUMPROCESSORS + c3*ACTROWPOOL + c4*PCTUPDATE + c5*PCTREAD
    # interactions
     INT_1 := a3*a4
     INT_2 := a3*a5
     INT_3 := a1*a2
    '
fit <- sem(thrashing_model, data = x)
summary(fit, standardized=TRUE, rsq=T) 

	lavaan (0.5-17) converged normally after  24 iterations

	  Number of observations                           201

	  Estimator                                         ML
	  Minimum Function Test Statistic               24.169
	  Degrees of freedom                                 1
	  P-value (Chi-square)                           0.000

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
	    ATP      (b1)    -0.589    0.097   -6.076    0.000   -0.589   -0.355
	    NUMPROCE (c2)    -0.054    0.056   -0.971    0.332   -0.054   -0.054
	    ACTROWPO (c3)    -0.059    0.060   -0.986    0.324   -0.059   -0.057
	    PCTUPDAT (c4)     0.444    0.062    7.120    0.000    0.444    0.433
	    PCTREAD  (c5)    -0.123    0.085   -1.439    0.150   -0.123   -0.088

	Variances:
	    ATP               0.023    0.002                      0.023    0.422
	    MAXMPL            0.093    0.009                      0.093    0.628

	Defined parameters:
	    INT_1            -0.019    0.010   -1.830    0.067   -0.019   -0.065
	    INT_2            -0.035    0.014   -2.568    0.010   -0.035   -0.091
	    INT_3            -0.004    0.004   -1.047    0.295   -0.004   -0.011

	R-Square:

	    ATP               0.578
	    MAXMPL            0.372

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
	-0.27727 -0.06939 -0.01080  0.06056  0.37485 

	Coefficients:
		                 Estimate Std. Error t value Pr(>|t|)    
	(Intercept)               0.48913    0.02638  18.541  < 2e-16 ***
	NUMPROCESSORS            -0.04166    0.03606  -1.155 0.249422    
	ACTROWPOOL                0.12351    0.03253   3.797 0.000196 ***
	PK                       -0.47990    0.02846 -16.865  < 2e-16 ***
	PCTREAD                   0.18894    0.04355   4.338 2.32e-05 ***
	PCTUPDATE                -0.14994    0.03336  -4.495 1.20e-05 ***
	NUMPROCESSORS:ACTROWPOOL  0.02409    0.05851   0.412 0.681017    
	PK:PCTREAD               -0.20625    0.06724  -3.068 0.002470 ** 
	PK:PCTUPDATE              0.43365    0.04879   8.889 4.50e-16 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1188 on 192 degrees of freedom
	Multiple R-squared:  0.7478,	Adjusted R-squared:  0.7373 
	F-statistic: 71.15 on 8 and 192 DF,  p-value: < 2.2e-16

### regression on MAXMPL 
out.fit <- lm(MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + PCTREAD, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + 
	    PCTREAD, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.7811 -0.1864  0.0650  0.2440  0.5675 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.81012    0.05864  13.816  < 2e-16 ***
	ATP           -0.58942    0.09848  -5.985 1.02e-08 ***
	ACTROWPOOL    -0.05869    0.06041  -0.972    0.332    
	NUMPROCESSORS -0.05395    0.05641  -0.956    0.340    
	PCTUPDATE      0.44395    0.06331   7.013 3.74e-11 ***
	PCTREAD       -0.12293    0.08673  -1.417    0.158    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.309 on 195 degrees of freedom
	Multiple R-squared:  0.3719,	Adjusted R-squared:  0.3558 
	F-statistic: 23.09 on 5 and 195 DF,  p-value: < 2.2e-16

### mediation of NUMPROCESSORS via ATP on MAXMPL 
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            0.01718     -0.00886      0.04235    0.18
	ADE            -0.05232     -0.16074      0.05919    0.37
	Total Effect   -0.03515     -0.15065      0.07436    0.53
	Prop. Mediated -0.14886     -7.27460      4.04924    0.65

	Sample Size Used: 201 


	Simulations: 1000

### moderated mediation of NUMPROCESSORS by ACTROWPOOL through ATP  on MAXMPL
test.modmed(med.out, covariates.1 = list (x$ACTROWPOOL < 0.5), covariates.2 = list (x$x$ACTROWPOOL >= 0.5), data = x)

		Test of ACME(covariates.1) - ACME(covariates.2) = 0

	data:  estimates from med.out
	ACME(covariates.1) - ACME(covariates.2) = 1e-04, p-value = 0.996
	alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.03517737  0.03812555


		Test of ADE(covariates.1) - ADE(covariates.2) = 0

	data:  estimates from med.out
	ADE(covariates.1) - ADE(covariates.2) = 0.0032, p-value = 0.914
	alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.1554769  0.1623896


###  mediation of PCTREAD via ATP on MAXMPL 
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTREAD")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            -0.0548      -0.1038      -0.0159    0.00
	ADE             -0.1294      -0.2991       0.0335    0.12
	Total Effect    -0.1842      -0.3573      -0.0159    0.04
	Prop. Mediated   0.2910       0.0488       1.1548    0.04

	Sample Size Used: 201 


	Simulations: 1000 

### moderated mediation of NUMPROCESSORS by PK through ATP on MAXMPL
test.modmed(med.out, covariates.1 = list (x$PK == 1), covariates.2 = list (x$PK == 0), data = x)

		Test of ACME(covariates.1) - ACME(covariates.2) = 0

	data:  estimates from med.out
	ACME(covariates.1) - ACME(covariates.2) = -0.0016, p-value = 0.944
	alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.05683164  0.05569099


		Test of ADE(covariates.1) - ADE(covariates.2) = 0

	data:  estimates from med.out
	ADE(covariates.1) - ADE(covariates.2) = -0.0038, p-value = 0.992
	alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.2410669  0.2213274


###  mediation of PCTUPDATE via ATP on MAXMPL 
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.03252     -0.06482     -0.00374    0.03
	ADE             0.44391      0.32466      0.56536    0.00
	Total Effect    0.41138      0.28805      0.53547    0.00
	Prop. Mediated -0.07682     -0.18075     -0.00843    0.03

	Sample Size Used: 201 


	Simulations: 1000 


### moderated mediation of PCTUPDATE by PK through ATP on MAXMPL
test.modmed(med.out, covariates.1 = list (x$PK == 1), covariates.2 = list (x$PK == 0), data = x)

		Test of ACME(covariates.1) - ACME(covariates.2) = 0

	data:  estimates from med.out
	ACME(covariates.1) - ACME(covariates.2) = 3e-04, p-value = 0.974
	alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.04224365  0.04357764


		Test of ADE(covariates.1) - ADE(covariates.2) = 0

	data:  estimates from med.out
	ADE(covariates.1) - ADE(covariates.2) = 7e-04, p-value = 0.938
	alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.1799115  0.1668535
