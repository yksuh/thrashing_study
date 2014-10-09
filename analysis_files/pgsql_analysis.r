# pgsql
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
# ATP normalization
pgsql <- subset(x, x$DBMS=='pgsql')
pgsql$ATP = (pgsql$ATP-min(pgsql$ATP))/(max(pgsql$ATP)-min(pgsql$ATP))
pgsql$MAXMPL = (pgsql$MAXMPL-min(pgsql$MAXMPL))/(max(pgsql$MAXMPL)-min(pgsql$MAXMPL))
x = rbind(pgsql) 
x$ACTROWPOOL = (x$ACTROWPOOL-min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)-min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD-min(x$PCTREAD))/(max(x$PCTREAD)-min(x$PCTREAD))
x$PCTUPDATE = (x$PCTUPDATE-min(x$PCTUPDATE))/(max(x$PCTUPDATE)-min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS-min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)-min(x$NUMPROCESSORS))

>>> lavann

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

	lavaan (0.5-17) converged normally after  28 iterations

	  Number of observations                           191

	  Estimator                                         ML
	  Minimum Function Test Statistic              108.523
	  Degrees of freedom                                 1
	  P-value (Chi-square)                           0.000

	Parameter estimates:

	  Information                                 Expected
	  Standard Errors                             Standard

		           Estimate  Std.err  Z-value  P(>|z|)   Std.lv  Std.all
	Regressions:
	  ATP ~
	    NUMPROCE (a1)    -0.040    0.034   -1.189    0.234   -0.040   -0.061
	    ACTROWPO (a2)     0.009    0.035    0.255    0.799    0.009    0.013
	    PK       (a3)    -0.148    0.027   -5.468    0.000   -0.148   -0.280
	    PCTUPDAT (a4)    -0.363    0.040   -9.062    0.000   -0.363   -0.516
	    PCTREAD  (a5)     0.167    0.044    3.828    0.000    0.167    0.218
	  MAXMPL ~
	    ATP      (b1)    -0.242    0.143   -1.696    0.090   -0.242   -0.152
	    NUMPROCE (c2)    -0.216    0.072   -2.993    0.003   -0.216   -0.205
	    ACTROWPO (c3)    -0.071    0.075   -0.944    0.345   -0.071   -0.064
	    PCTUPDAT (c4)    -0.396    0.100   -3.966    0.000   -0.396   -0.354
	    PCTREAD  (c5)    -0.069    0.095   -0.726    0.468   -0.069   -0.057

	Variances:
	    ATP               0.034    0.004                      0.034    0.499
	    MAXMPL            0.155    0.016                      0.155    0.885

	Defined parameters:
	    INT_1             0.054    0.011    4.741    0.000    0.054    0.144
	    INT_2            -0.025    0.008   -3.121    0.002   -0.025   -0.061
	    INT_3            -0.000    0.001   -0.249    0.804   -0.000   -0.001

	R-Square:

	    ATP               0.501
	    MAXMPL            0.115

library(mediation)
med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + ACTROWPOOL:NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK + PCTUPDATE + PCTUPDATE:PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + ACTROWPOOL:NUMPROCESSORS + 
	    PK + PCTREAD + PCTREAD:PK + PCTUPDATE + PCTUPDATE:PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.30809 -0.10373 -0.00736  0.08902  0.61227 

	Coefficients:
		                 Estimate Std. Error t value Pr(>|t|)    
	(Intercept)               0.41460    0.03904  10.620  < 2e-16 ***
	NUMPROCESSORS            -0.02477    0.05291  -0.468   0.6403    
	ACTROWPOOL                0.02666    0.04823   0.553   0.5811    
	PK                       -0.32598    0.04364  -7.470 3.24e-12 ***
	PCTREAD                   0.11466    0.05470   2.096   0.0375 *  
	PCTUPDATE                -0.54807    0.04978 -11.009  < 2e-16 ***
	NUMPROCESSORS:ACTROWPOOL -0.02601    0.08417  -0.309   0.7576    
	PK:PCTREAD                0.12778    0.08266   1.546   0.1239    
	PK:PCTUPDATE              0.43403    0.07627   5.691 4.98e-08 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1748 on 182 degrees of freedom
	Multiple R-squared:  0.5792,	Adjusted R-squared:  0.5607 
	F-statistic: 31.31 on 8 and 182 DF,  p-value: < 2.2e-16

out.fit <- lm(MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + PCTREAD, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + 
	    PCTREAD, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.66359 -0.35782 -0.02281  0.38028  0.65717 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.864487   0.099724   8.669 2.18e-15 ***
	ATP           -0.242207   0.145066  -1.670 0.096683 .  
	ACTROWPOOL    -0.094199   0.101427  -0.929 0.354238    
	NUMPROCESSORS -0.030890   0.010485  -2.946 0.003633 ** 
	PCTUPDATE     -0.003964   0.001016  -3.903 0.000133 ***
	PCTREAD       -0.069149   0.096805  -0.714 0.475932    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.4004 on 185 degrees of freedom
	Multiple R-squared:  0.1149,	Adjusted R-squared:  0.09096 
	F-statistic: 4.802 on 5 and 185 DF,  p-value: 0.0003755

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            0.00909     -0.00744      0.03544    0.28
	ADE            -0.21386     -0.34758     -0.07742    0.00
	Total Effect   -0.20476     -0.34047     -0.06124    0.00
	Prop. Mediated -0.03577     -0.23277      0.03550    0.28

	Sample Size Used: 191 


	Simulations: 1000

#med.high_conte <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS", covariates = list (x$ACTROWPOOL < 0.5), data = x)
#summary(med.high_conte)
#med.low_conte <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS", covariates = list (x$ACTROWPOOL >= 0.5))
#summary(med.low_conte)
>>> ATP time on NUMPROC by ACTROWPOOL

test.modmed(med.out, covariates.1 = list (x$ACTROWPOOL < 0.5), covariates.2 = list (x$x$ACTROWPOOL >= 0.5), data = x)

		Test of ACME(covariates.1) - ACME(covariates.2) = 0

	data:  estimates from med.out
	ACME(covariates.1) - ACME(covariates.2) = -4e-04, p-value = 0.95
	alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.03130626  0.03076538


		Test of ADE(covariates.1) - ADE(covariates.2) = 0

	data:  estimates from med.out
	ADE(covariates.1) - ADE(covariates.2) = -8e-04, p-value = 0.98
	alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.2024059  0.1956885

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTREAD")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            -0.0420      -0.1017       0.0100    0.12
	ADE             -0.0669      -0.2618       0.1241    0.50
	Total Effect    -0.1089      -0.2886       0.0760    0.28
	Prop. Mediated   0.2815      -5.4669       4.7680    0.36

	Sample Size Used: 191 


	Simulations: 1000 

test.modmed(med.out, covariates.1 = list (x$PK == 0), covariates.2 = list (x$PK == 1), data = x)

		Test of ACME(covariates.1) - ACME(covariates.2) = 0

	data:  estimates from med.out
	ACME(covariates.1) - ACME(covariates.2) = 5e-04, p-value = 0.99
	alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.07461091  0.07635841


		Test of ADE(covariates.1) - ADE(covariates.2) = 0

	data:  estimates from med.out
	ADE(covariates.1) - ADE(covariates.2) = -0.002, p-value = 0.996
	alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.2545523  0.2728217

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME             0.0848      -0.0156       0.1931    0.09
	ADE             -0.3979      -0.6042      -0.2033    0.00
	Total Effect    -0.3131      -0.4703      -0.1331    0.00
	Prop. Mediated  -0.2713      -0.9130       0.0500    0.09

	Sample Size Used: 191 


	Simulations: 1000

test.modmed(med.out, covariates.1 = list (x$PK == 0), covariates.2 = list (x$PK == 1), data = x)

	Test of ACME(covariates.1) - ACME(covariates.2) = 0

	data:  estimates from med.out
	ACME(covariates.1) - ACME(covariates.2) = 0.0012, p-value = 0.97
	alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.1468874  0.1429388


		Test of ADE(covariates.1) - ADE(covariates.2) = 0

	data:  estimates from med.out
	ADE(covariates.1) - ADE(covariates.2) = -0.0026, p-value = 0.984
	alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.2773473  0.2729800
