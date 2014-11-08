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
      ATP ~ a1*NUMPROCESSORS+a3*PK+a4*PCTUPDATE
    # dependent variable
      MAXMPL ~ b1*ATP+c1*NUMPROCESSORS+c2*ACTROWPOOL+c3*PK+c4*PCTUPDATE+c5*PCTREAD
   # interactions
       INT_1 := a3*a4
     '
fit <- sem(thrashing_model, estimator="DWLS", data = x)
summary(fit, fit.measures = TRUE, standardized=TRUE, rsq=T)

lavaan (0.5-17) converged normally after  71 iterations

  Number of observations                           216

  Estimator                                       DWLS
  Minimum Function Test Statistic                0.018
  Degrees of freedom                                 2
  P-value (Chi-square)                           0.991

Model test baseline model:

  Minimum Function Test Statistic              191.741
  Degrees of freedom                                11
  P-value                                        0.000

User model versus baseline model:

  Comparative Fit Index (CFI)                    1.000
  Tucker-Lewis Index (TLI)                       1.060

Root Mean Square Error of Approximation:

  RMSEA                                          0.000
  90 Percent Confidence Interval          0.000  0.000
  P-value RMSEA <= 0.05                          0.995

Standardized Root Mean Square Residual:

  SRMR                                           0.002

Parameter estimates:

  Information                                 Expected
  Standard Errors                             Standard

                   Estimate  Std.err  Z-value  P(>|z|)   Std.lv  Std.all
Regressions:
  ATP ~
    NUMPROCE (a1)    -0.450    0.056   -8.021    0.000   -0.450   -0.551
    PK       (a3)     0.021    0.050    0.429    0.668    0.021    0.034
    PCTUPDAT (a4)     0.130    0.057    2.268    0.023    0.130    0.155
  MAXMPL ~
    ATP      (b1)     0.164    0.099    1.661    0.097    0.164    0.182
    NUMPROCE (c1)     0.417    0.085    4.905    0.000    0.417    0.569
    ACTROWPO (c2)     0.009    0.057    0.150    0.881    0.009    0.011
    PK       (c3)    -0.042    0.046   -0.917    0.359   -0.042   -0.074
    PCTUPDAT (c4)    -0.138    0.082   -1.683    0.092   -0.138   -0.182
    PCTREAD  (c5)     0.003    0.097    0.027    0.979    0.003    0.003

Covariances:
  NUMPROCESSORS ~~
    PK                0.005    0.013    0.368    0.713    0.005    0.025
    PCTUPDATE        -0.003    0.010   -0.329    0.742   -0.003   -0.022
    ACTROWPOOL       -0.000    0.009   -0.033    0.973   -0.000   -0.002
    PCTREAD           0.004    0.007    0.589    0.556    0.004    0.034
  PK ~~
    PCTUPDATE         0.007    0.013    0.537    0.591    0.007    0.036
    ACTROWPOOL        0.000    0.013    0.002    0.999    0.000    0.000
    PCTREAD          -0.008    0.011   -0.675    0.500   -0.008   -0.046
  PCTUPDATE ~~
    ACTROWPOOL        0.000    0.009    0.008    0.993    0.000    0.001
    PCTREAD          -0.054    0.008   -7.161    0.000   -0.054   -0.430
  ACTROWPOOL ~~
    PCTREAD          -0.000    0.008   -0.000    1.000   -0.000   -0.000

Variances:
    ATP               0.067    0.014                      0.067    0.668
    MAXMPL            0.059    0.010                      0.059    0.728
    NUMPROCESSORS     0.150    0.009                      0.150    1.000
    PK                0.251    0.001                      0.251    1.000
    PCTUPDATE         0.141    0.008                      0.141    1.000
    ACTROWPOOL        0.140    0.008                      0.140    1.000
    PCTREAD           0.111    0.016                      0.111    1.000

Defined parameters:
    INT_1             0.003    0.006    0.428    0.668    0.003    0.005

R-Square:

    ATP               0.332
    MAXMPL            0.272

library(lavaan)
thrashing_model <- '
     # mediator
      ATP ~ a1*NUMPROCESSORS+a4*PCTUPDATE
    # dependent variable
      MAXMPL ~ b1*ATP+c1*NUMPROCESSORS+c4*PCTUPDATE
   # interactions
      # INT_1 := a3*a4
     '
#fit <- sem(thrashing_model, estimator="DWLS", data = x)
fit <- sem(thrashing_model, data = x)
summary(fit, fit.measures = TRUE, standardized=TRUE, rsq=T)



library(lavaan)
thrashing_model <- '
     # mediator
      ATP ~ a1*NUMPROCESSORS+a4*PCTUPDATE
    # dependent variable
      MAXMPL ~ b1*ATP + c2*NUMPROCESSORS + c4*PCTUPDATE
    # interactions'
#fit <- sem(thrashing_model, data = x)
#summary(fit, standardized=TRUE, rsq=T) 
fit <- sem(thrashing_model, estimator="DWLS", data = x)
summary(fit, fit.measures = TRUE, standardized=TRUE, rsq=T)


lavaan (0.5-17) converged normally after  20 iterations

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
    NUMPROCE (a1)    -0.449    0.046   -9.859    0.000   -0.449   -0.550
    PCTUPDAT (a4)     0.128    0.047    2.714    0.007    0.128    0.151
  MAXMPL ~
    ATP      (b1)     0.159    0.064    2.484    0.013    0.159    0.177
    NUMPROCE (c2)     0.413    0.052    8.025    0.000    0.413    0.563
    PCTUPDAT (c4)    -0.139    0.045   -3.087    0.002   -0.139   -0.183

Variances:
    ATP               0.067    0.006                      0.067    0.671
    MAXMPL            0.059    0.006                      0.059    0.734

R-Square:

    ATP               0.329
    MAXMPL            0.266





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
