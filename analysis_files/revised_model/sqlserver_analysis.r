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

library(lavaan)
thrashing_model <- '
     # mediator
      ATP ~ a1*NUMPROCESSORS+a2*ACTROWPOOL+a3*PK+a4*PCTUPDATE+a5*PCTREAD
    # dependent variable
      MAXMPL ~ b1*ATP + c2*NUMPROCESSORS + c3*ACTROWPOOL + c4*PCTUPDATE + c5*PCTREAD + c6*PK
    # interactions
     INT_1 := a3*a4
     INT_2 := a3*a5
     INT_3 := a1*a2'
fit <- sem(thrashing_model, data = x)
summary(fit, standardized=TRUE, rsq=T) 

	lavaan (0.5-17) converged normally after  26 iterations

	  Number of observations                           216

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
	    NUMPROCE (a1)    -0.450    0.046   -9.874    0.000   -0.450   -0.550
	    ACTROWPO (a2)     0.004    0.047    0.087    0.931    0.004    0.005
	    PK       (a3)     0.021    0.035    0.595    0.552    0.021    0.033
	    PCTUPDAT (a4)     0.123    0.052    2.365    0.018    0.123    0.146
	    PCTREAD  (a5)    -0.009    0.059   -0.162    0.872   -0.009   -0.010
	  MAXMPL ~
	    ATP      (b1)     0.162    0.064    2.543    0.011    0.162    0.180
	    NUMPROCE (c2)     0.416    0.051    8.101    0.000    0.416    0.567
	    ACTROWPO (c3)     0.007    0.044    0.161    0.872    0.007    0.009
	    PCTUPDAT (c4)    -0.134    0.049   -2.723    0.006   -0.134   -0.177
	    PCTREAD  (c5)     0.007    0.055    0.128    0.898    0.007    0.008
	    PK       (c6)    -0.042    0.033   -1.263    0.206   -0.042   -0.074

	Variances:
	    ATP               0.067    0.006                      0.067    0.670
	    MAXMPL            0.059    0.006                      0.059    0.728

	Defined parameters:
	    INT_1             0.003    0.004    0.579    0.562    0.003    0.005
	    INT_3            -0.002    0.021   -0.087    0.931   -0.002   -0.003

	R-Square:

	    ATP               0.330
	    MAXMPL            0.272


library(mediation)
med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + PK + PCTREAD + PCTUPDATE + PCTUPDATE:PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + 
	    PK + PCTREAD + PCTUPDATE + PCTUPDATE:PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.37035 -0.21420  0.00249  0.12541  0.60739 

	Coefficients:
		                  Estimate Std. Error t value Pr(>|t|)    
	(Intercept)               0.285269   0.055078   5.179 5.25e-07 ***
	NUMPROCESSORS            -0.444837   0.077583  -5.734 3.43e-08 ***
	ACTROWPOOL                0.008437   0.069396   0.122   0.9034    
	PK                        0.037150   0.050635   0.734   0.4640    
	PCTREAD                  -0.008600   0.059876  -0.144   0.8859    
	PCTUPDATE                 0.144202   0.070740   2.038   0.0428 *  
	NUMPROCESSORS:ACTROWPOOL -0.010783   0.124356  -0.087   0.9310    
	PK:PCTUPDATE             -0.043444   0.095857  -0.453   0.6509    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2635 on 208 degrees of freedom
	Multiple R-squared:  0.3309,	Adjusted R-squared:  0.3084 
	F-statistic: 14.69 on 7 and 208 DF,  p-value: 1.631e-15

out.fit <- lm(MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + PCTREAD + PK, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + 
	    PCTREAD + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.55858 -0.06339  0.02285  0.12832  0.52556 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.472138   0.047215  10.000  < 2e-16 ***
	ATP            0.162063   0.064783   2.502  0.01313 *  
	ACTROWPOOL     0.007113   0.044980   0.158  0.87450    
	NUMPROCESSORS  0.416244   0.052237   7.968 1.03e-13 ***
	PCTUPDATE     -0.134294   0.050132  -2.679  0.00798 ** 
	PCTREAD        0.007046   0.055944   0.126  0.89990    
	PK            -0.041793   0.033629  -1.243  0.21534    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2464 on 209 degrees of freedom
	Multiple R-squared:  0.2718,	Adjusted R-squared:  0.2509 
	F-statistic:    13 on 6 and 209 DF,  p-value: 1.767e-12

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            -0.0743      -0.1335      -0.0192       0
	ADE              0.4147       0.3211       0.5135       0
	Total Effect     0.3404       0.2544       0.4234       0
	Prop. Mediated  -0.2139      -0.4351      -0.0525       0

	Sample Size Used: 216 


	Simulations: 1000 

test.modmed(med.out, covariates.1 = list (x$ACTROWPOOL < 0.5), covariates.2 = list (x$x$ACTROWPOOL >= 0.5), data = x)

		Test of ACME(covariates.1) - ACME(covariates.2) = 0

	data:  estimates from med.out
	ACME(covariates.1) - ACME(covariates.2) = -0.0028, p-value = 0.96
	alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.08919379  0.08421607


		Test of ADE(covariates.1) - ADE(covariates.2) = 0

	data:  estimates from med.out
	ADE(covariates.1) - ADE(covariates.2) = -0.0012, p-value = 0.996
	alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.1476635  0.1519097

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		        Estimate 95% CI Lower 95% CI Upper p-value
	ACME            0.020334     0.001019     0.046855    0.03
	ADE            -0.138492    -0.237721    -0.041309    0.00
	Total Effect   -0.118158    -0.220085    -0.019400    0.01
	Prop. Mediated -0.159505    -1.096525    -0.000694    0.05

	Sample Size Used: 216 


	Simulations: 1000

test.modmed(med.out, covariates.1 = list (x$PK == 1), covariates.2 = list (x$PK == 0), data = x)

		Test of ACME(covariates.1) - ACME(covariates.2) = 0

	data:  estimates from med.out
	ACME(covariates.1) - ACME(covariates.2) = 1e-04, p-value = 0.998
	alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.03295338  0.03537693


		Test of ADE(covariates.1) - ADE(covariates.2) = 0

	data:  estimates from med.out
	ADE(covariates.1) - ADE(covariates.2) = 0.0022, p-value = 0.994
	alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.1353178  0.1470011
