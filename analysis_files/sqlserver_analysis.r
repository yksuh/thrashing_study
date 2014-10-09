# sqlserver
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
# ATP normalization
sqlserver <- subset(x, x$DBMS=='sqlserver')
sqlserver$ATP = (sqlserver$ATP-min(sqlserver$ATP))/(max(sqlserver$ATP)-min(sqlserver$ATP))
sqlserver$MAXMPL = (sqlserver$MAXMPL-min(sqlserver$MAXMPL))/(max(sqlserver$MAXMPL)-min(sqlserver$MAXMPL))
x = rbind(sqlserver) 
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

	lavaan (0.5-17) converged normally after  24 iterations

	  Number of observations                           216

	  Estimator                                         ML
	  Minimum Function Test Statistic                1.590
	  Degrees of freedom                                 1
	  P-value (Chi-square)                           0.207

	Parameter estimates:

	  Information                                 Expected
	  Standard Errors                             Standard

		           Estimate  Std.err  Z-value  P(>|z|)   Std.lv  Std.all
	Regressions:
	  ATP ~
	    NUMPROCE (a1)    -0.450    0.046   -9.874    0.000   -0.450   -0.550
	    ACTROWPO (a2)     0.004    0.047    0.087    0.931    0.004    0.005
	    PK       (a3)     0.021    0.035    0.595    0.552    0.021    0.033
	    PCTUPDAT (a4)     0.123    0.052    2.365    0.018    0.123    0.146
	    PCTREAD  (a5)    -0.009    0.059   -0.162    0.872   -0.009   -0.010
	  MAXMPL ~
	    ATP      (b1)     0.159    0.064    2.485    0.013    0.159    0.177
	    NUMPROCE (c2)     0.413    0.052    8.023    0.000    0.413    0.563
	    ACTROWPO (c3)     0.007    0.044    0.160    0.873    0.007    0.009
	    PCTUPDAT (c4)    -0.135    0.049   -2.729    0.006   -0.135   -0.178
	    PCTREAD  (c5)     0.009    0.055    0.169    0.866    0.009    0.011

	Variances:
	    ATP               0.067    0.006                      0.067    0.670
	    MAXMPL            0.059    0.006                      0.059    0.734

	Defined parameters:
	    INT_1             0.003    0.004    0.579    0.562    0.003    0.005
	    INT_2            -0.000    0.001   -0.157    0.875   -0.000   -0.000
	    INT_3            -0.002    0.021   -0.087    0.931   -0.002   -0.003

	R-Square:

	    ATP               0.330
	    MAXMPL            0.266


library(mediation)
med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + ACTROWPOOL:NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK + PCTUPDATE + PCTUPDATE:PK, data = x)
summary(med.fit)


	Call:
	lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + ACTROWPOOL:NUMPROCESSORS + 
	    PK + PCTREAD + PCTREAD:PK + PCTUPDATE + PCTUPDATE:PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.36819 -0.20752  0.00249  0.12115  0.60492 

	Coefficients:
		                  Estimate Std. Error t value Pr(>|t|)    
	(Intercept)               0.292307   0.057652   5.070 8.80e-07 ***
	NUMPROCESSORS            -0.445340   0.077746  -5.728 3.54e-08 ***
	ACTROWPOOL                0.008437   0.069534   0.121   0.9035    
	PK                        0.022847   0.061012   0.374   0.7084    
	PCTREAD                  -0.031196   0.080410  -0.388   0.6984    
	PCTUPDATE                 0.135081   0.074101   1.823   0.0698 .  
	NUMPROCESSORS:ACTROWPOOL -0.010783   0.124603  -0.087   0.9311    
	PK:PCTREAD                0.050973   0.120769   0.422   0.6734    
	PK:PCTUPDATE             -0.024373   0.106144  -0.230   0.8186    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2641 on 207 degrees of freedom
	Multiple R-squared:  0.3314,	Adjusted R-squared:  0.3056 
	F-statistic: 12.83 on 8 and 207 DF,  p-value: 6.024e-15

out.fit <- lm(MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + PCTREAD, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + 
	    PCTREAD, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.58133 -0.06817  0.03057  0.12497  0.50293 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.453688   0.044878  10.109  < 2e-16 ***
	ATP            0.158808   0.064814   2.450  0.01510 *  
	ACTROWPOOL     0.007127   0.045039   0.158  0.87443    
	NUMPROCESSORS  0.413357   0.052253   7.911 1.44e-13 ***
	PCTUPDATE     -0.135084   0.050193  -2.691  0.00769 ** 
	PCTREAD        0.009334   0.055987   0.167  0.86776    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2467 on 210 degrees of freedom
	Multiple R-squared:  0.2664,	Adjusted R-squared:  0.2489 
	F-statistic: 15.25 on 5 and 210 DF,  p-value: 8.809e-13

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            -0.0719      -0.1363      -0.0158    0.01
	ADE              0.4139       0.3150       0.5218    0.00
	Total Effect     0.3420       0.2553       0.4334    0.00
	Prop. Mediated  -0.2078      -0.4328      -0.0431    0.01

	Sample Size Used: 216 


	Simulations: 1000

test.modmed(med.out, covariates.1 = list (x$ACTROWPOOL < 0.5), covariates.2 = list (x$x$ACTROWPOOL >= 0.5), data = x)

		Test of ACME(covariates.1) - ACME(covariates.2) = 0

	data:  estimates from med.out
	ACME(covariates.1) - ACME(covariates.2) = 0.0014, p-value = 0.994
	alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.08428004  0.08691389


		Test of ADE(covariates.1) - ADE(covariates.2) = 0

	data:  estimates from med.out
	ADE(covariates.1) - ADE(covariates.2) = -0.0057, p-value = 0.928
	alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.1418415  0.1322959

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTREAD")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		        Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.000683    -0.022400     0.019983    0.95
	ADE             0.011334    -0.101215     0.120106    0.84
	Total Effect    0.010651    -0.102995     0.121622    0.87
	Prop. Mediated  0.013246    -1.768316     2.262679    0.92

	Sample Size Used: 216 


	Simulations: 1000 

test.modmed(med.out, covariates.1 = list (x$PK == 0), covariates.2 = list (x$PK == 1), data = x)

		Test of ACME(covariates.1) - ACME(covariates.2) = 0

	data:  estimates from med.out
	ACME(covariates.1) - ACME(covariates.2) = 6e-04, p-value = 0.968
	alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.02938371  0.03127298


		Test of ADE(covariates.1) - ADE(covariates.2) = 0

	data:  estimates from med.out
	ADE(covariates.1) - ADE(covariates.2) = 0.003, p-value = 0.976
	alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.1522998  0.1675606

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		        Estimate 95% CI Lower 95% CI Upper p-value
	ACME            0.019665     0.000871     0.050768    0.03
	ADE            -0.136880    -0.228284    -0.034705    0.01
	Total Effect   -0.117215    -0.210731    -0.012486    0.03
	Prop. Mediated -0.143603    -1.106859     0.008744    0.06

	Sample Size Used: 216 


	Simulations: 1000

test.modmed(med.out, covariates.1 = list (x$PK == 0), covariates.2 = list (x$PK == 1), data = x)

		Test of ACME(covariates.1) - ACME(covariates.2) = 0

	data:  estimates from med.out
	ACME(covariates.1) - ACME(covariates.2) = -9e-04, p-value = 0.954
	alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.03269436  0.03172484


		Test of ADE(covariates.1) - ADE(covariates.2) = 0

	data:  estimates from med.out
	ADE(covariates.1) - ADE(covariates.2) = -0.0012, p-value = 0.966
	alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.1298532  0.1245120
