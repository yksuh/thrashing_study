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

>>>>> Model Change


library(lavaan)
thrashing_model <- '
     # mediator
      ATP ~ a1*NUMPROCESSORS+a2*ACTROWPOOL+a3*PK+a4*PCTUPDATE+a5*PCTREAD
    # dependent variable
      MAXMPL ~ b1*ATP + c2*NUMPROCESSORS + c3*ACTROWPOOL + c4*PCTUPDATE + c5*PCTREAD + c6*PK
    # interactions
     INT_1 := a3*a4'
fit <- sem(thrashing_model, data = x)
summary(fit, standardized=TRUE, rsq=T) 

	lavaan (0.5-17) converged normally after  27 iterations

	  Number of observations                           191

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
	    NUMPROCE (a1)    -0.040    0.034   -1.189    0.234   -0.040   -0.061
	    ACTROWPO (a2)     0.009    0.035    0.255    0.799    0.009    0.013
	    PK       (a3)    -0.148    0.027   -5.468    0.000   -0.148   -0.280
	    PCTUPDAT (a4)    -0.363    0.040   -9.062    0.000   -0.363   -0.516
	    PCTREAD  (a5)     0.167    0.044    3.828    0.000    0.167    0.218
	  MAXMPL ~
	    ATP      (b1)     0.272    0.116    2.352    0.019    0.272    0.171
	    NUMPROCE (c2)    -0.224    0.054   -4.116    0.000   -0.224   -0.212
	    ACTROWPO (c3)    -0.062    0.056   -1.097    0.272   -0.062   -0.056
	    PCTUPDAT (c4)    -0.230    0.076   -3.006    0.003   -0.230   -0.205
	    PCTREAD  (c5)    -0.163    0.072   -2.255    0.024   -0.163   -0.134
	    PK       (c6)     0.563    0.047   12.088    0.000    0.563    0.667

	Variances:
	    ATP               0.034    0.004                      0.034    0.499
	    MAXMPL            0.088    0.009                      0.088    0.501

	Defined parameters:
	    INT_1             0.054    0.011    4.741    0.000    0.054    0.144

	R-Square:

	    ATP               0.501
	    MAXMPL            0.499


out.fit <- lm(MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + PCTREAD + PK, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + 
	    PCTREAD + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.66634 -0.22952  0.03932  0.20326  0.83721 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.42892    0.06916   6.202 3.60e-09 ***
	ATP            0.27179    0.11775   2.308  0.02210 *  
	ACTROWPOOL    -0.06185    0.05742  -1.077  0.28281    
	NUMPROCESSORS -0.22381    0.05540  -4.040 7.85e-05 ***
	PCTUPDATE     -0.22990    0.07792  -2.950  0.00359 ** 
	PCTREAD       -0.16262    0.07349  -2.213  0.02814 *  
	PK             0.56311    0.04746  11.865  < 2e-16 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3022 on 184 degrees of freedom
	Multiple R-squared:  0.4985,	Adjusted R-squared:  0.4822 
	F-statistic: 30.49 on 6 and 184 DF,  p-value: < 2.2e-16

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.01019     -0.03372      0.00803    0.25
	ADE            -0.22213     -0.33232     -0.11796    0.00
	Total Effect   -0.23232     -0.34198     -0.12783    0.00
	Prop. Mediated  0.03788     -0.03617      0.15769    0.25

	Sample Size Used: 191 


	Simulations: 1000 

test.modmed(med.out, covariates.1 = list (x$ACTROWPOOL < 0.5), covariates.2 = list (x$x$ACTROWPOOL >= 0.5), data = x)

	Test of ACME(covariates.1) - ACME(covariates.2) = 0

	data:  estimates from med.out
	ACME(covariates.1) - ACME(covariates.2) = 4e-04, p-value = 0.982
	alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.03210644  0.03088594


		Test of ADE(covariates.1) - ADE(covariates.2) = 0

	data:  estimates from med.out
	ADE(covariates.1) - ADE(covariates.2) = -3e-04, p-value = 0.992
	alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.1521787  0.1525445


med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTREAD")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            0.04600      0.00772      0.09931    0.01
	ADE            -0.16435     -0.29724     -0.02531    0.01
	Total Effect   -0.11835     -0.25008      0.01890    0.09
	Prop. Mediated -0.33249     -2.74707      2.04507    0.10

	Sample Size Used: 191 


	Simulations: 1000 


test.modmed(med.out, covariates.1 = list (x$PK == 1), covariates.2 = list (x$PK == 0), data = x)

	Test of ACME(covariates.1) - ACME(covariates.2) = 0

	data:  estimates from med.out
	ACME(covariates.1) - ACME(covariates.2) = 3e-04, p-value = 0.982
	alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.06724593  0.06609272


		Test of ADE(covariates.1) - ADE(covariates.2) = 0

	data:  estimates from med.out
	ADE(covariates.1) - ADE(covariates.2) = 0.0019, p-value = 0.986
	alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.2025858  0.2112903

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            -0.0985      -0.1929      -0.0165    0.02
	ADE             -0.2279      -0.3755      -0.0601    0.01
	Total Effect    -0.3264      -0.4582      -0.1968    0.00
	Prop. Mediated   0.3001       0.0490       0.7364    0.02

	Sample Size Used: 191 


	Simulations: 1000 

test.modmed(med.out, covariates.1 = list (x$PK == 1), covariates.2 = list (x$PK == 0), data = x)

	Test of ACME(covariates.1) - ACME(covariates.2) = 0

data:  estimates from med.out
ACME(covariates.1) - ACME(covariates.2) = 0.0025, p-value = 0.982
alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
95 percent confidence interval:
 -0.1092715  0.1343181


	Test of ADE(covariates.1) - ADE(covariates.2) = 0

data:  estimates from med.out
ADE(covariates.1) - ADE(covariates.2) = -0.001, p-value = 0.998
alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
95 percent confidence interval:
 -0.2113151  0.2175743


