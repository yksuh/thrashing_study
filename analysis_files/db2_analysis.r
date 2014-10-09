# db2
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
# ATP normalization
db2 <- subset(x, x$DBMS=='db2')
db2$ATP = (db2$ATP-min(db2$ATP))/(max(db2$ATP)-min(db2$ATP))
db2$MAXMPL = (db2$MAXMPL-min(db2$MAXMPL))/(max(db2$MAXMPL)-min(db2$MAXMPL))
x = rbind(db2) 
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

	lavaan (0.5-17) converged normally after  25 iterations

	  Number of observations                           197

	  Estimator                                         ML
	  Minimum Function Test Statistic                2.702
	  Degrees of freedom                                 1
	  P-value (Chi-square)                           0.100

	Parameter estimates:

	  Information                                 Expected
	  Standard Errors                             Standard

		           Estimate  Std.err  Z-value  P(>|z|)   Std.lv  Std.all
	Regressions:
	  ATP ~
	    NUMPROCE (a1)     0.070    0.032    2.193    0.028    0.070    0.143
	    ACTROWPO (a2)     0.044    0.034    1.278    0.201    0.044    0.083
	    PK       (a3)     0.044    0.026    1.705    0.088    0.044    0.112
	    PCTUPDAT (a4)    -0.193    0.038   -5.061    0.000   -0.193   -0.364
	    PCTREAD  (a5)    -0.149    0.044   -3.375    0.001   -0.149   -0.242
	  MAXMPL ~
	    ATP      (b1)     0.233    0.107    2.180    0.029    0.233    0.150
	    NUMPROCE (c2)     0.196    0.048    4.039    0.000    0.196    0.260
	    ACTROWPO (c3)    -0.130    0.052   -2.519    0.012   -0.130   -0.161
	    PCTUPDAT (c4)     0.229    0.061    3.752    0.000    0.229    0.279
	    PCTREAD  (c5)    -0.079    0.069   -1.149    0.251   -0.079   -0.083

	Variances:
	    ATP               0.032    0.003                      0.032    0.838
	    MAXMPL            0.073    0.007                      0.073    0.793

	Defined parameters:
	    INT_1            -0.008    0.005   -1.645    0.100   -0.008   -0.041
	    INT_2            -0.006    0.004   -1.557    0.120   -0.006   -0.027
	    INT_3             0.003    0.003    1.107    0.268    0.003    0.012

	R-Square:

	    ATP               0.162
	    MAXMPL            0.207


library(mediation)
med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + ACTROWPOOL:NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK + PCTUPDATE + PCTUPDATE:PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + ACTROWPOOL:NUMPROCESSORS + 
	    PK + PCTREAD + PCTREAD:PK + PCTUPDATE + PCTUPDATE:PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.27443 -0.07393 -0.02672  0.02506  0.79739 

	Coefficients:
		                 Estimate Std. Error t value Pr(>|t|)   
	(Intercept)               0.03304    0.04117   0.802   0.4233   
	NUMPROCESSORS             0.05941    0.05330   1.115   0.2664   
	ACTROWPOOL                0.03028    0.04917   0.616   0.5387   
	PK                        0.12807    0.04302   2.977   0.0033 **
	PCTREAD                  -0.07663    0.06040  -1.269   0.2061   
	PCTUPDATE                -0.10358    0.05425  -1.909   0.0578 . 
	NUMPROCESSORS:ACTROWPOOL  0.02592    0.08572   0.302   0.7627   
	PK:PCTREAD               -0.15082    0.08962  -1.683   0.0940 . 
	PK:PCTUPDATE             -0.17800    0.07678  -2.318   0.0215 * 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1799 on 188 degrees of freedom
	Multiple R-squared:  0.1884,	Adjusted R-squared:  0.1538 
	F-statistic: 5.453 on 8 and 188 DF,  p-value: 3.423e-06

out.fit <- lm(MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + PCTREAD, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + 
	    PCTREAD, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.81283 -0.17604  0.07398  0.20103  0.46736 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.71367    0.04713  15.143  < 2e-16 ***
	ATP            0.23266    0.10841   2.146 0.033118 *  
	ACTROWPOOL    -0.13019    0.05249  -2.480 0.013990 *  
	NUMPROCESSORS  0.19554    0.04917   3.977 9.89e-05 ***
	PCTUPDATE      0.22923    0.06205   3.694 0.000288 ***
	PCTREAD       -0.07882    0.06969  -1.131 0.259464    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2737 on 191 degrees of freedom
	Multiple R-squared:  0.207,	Adjusted R-squared:  0.1862 
	F-statistic:  9.97 on 5 and 191 DF,  p-value: 1.721e-08

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		        Estimate 95% CI Lower 95% CI Upper p-value
	ACME            0.016828    -0.000156     0.041840    0.05
	ADE             0.196814     0.106531     0.299208    0.00
	Total Effect    0.213641     0.125127     0.313340    0.00
	Prop. Mediated  0.072445    -0.000951     0.210348    0.05

	Sample Size Used: 197 


	Simulations: 1000

test.modmed(med.out, covariates.1 = list (x$ACTROWPOOL < 0.5), covariates.2 = list (x$x$ACTROWPOOL >= 0.5), data = x)

		Test of ACME(covariates.1) - ACME(covariates.2) = 0

	data:  estimates from med.out
	ACME(covariates.1) - ACME(covariates.2) = 3e-04, p-value = 0.998
	alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.03199544  0.03478310


		Test of ADE(covariates.1) - ADE(covariates.2) = 0

	data:  estimates from med.out
	ADE(covariates.1) - ADE(covariates.2) = 0.001, p-value = 0.982
	alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.1342096  0.1413502


med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTREAD")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		        Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.034446    -0.076212    -0.000695    0.04
	ADE            -0.078175    -0.212483     0.058680    0.27
	Total Effect   -0.112622    -0.242520     0.017555    0.12
	Prop. Mediated  0.275322    -2.492374     2.425045    0.15

	Sample Size Used: 197 


	Simulations: 1000

test.modmed(med.out, covariates.1 = list (x$PK == 1), covariates.2 = list (x$PK == 0), data = x)

		Test of ACME(covariates.1) - ACME(covariates.2) = 0

	data:  estimates from med.out
	ACME(covariates.1) - ACME(covariates.2) = 0, p-value = 0.976
	alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.05132141  0.05382137


		Test of ADE(covariates.1) - ADE(covariates.2) = 0

	data:  estimates from med.out
	ADE(covariates.1) - ADE(covariates.2) = 0.0014, p-value = 0.984
	alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.1837483  0.1901459

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		        Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.044026    -0.097494    -0.000968    0.04
	ADE             0.228871     0.100085     0.349656    0.00
	Total Effect    0.184846     0.056865     0.299669    0.00
	Prop. Mediated -0.229985    -0.955026    -0.004889    0.04

	Sample Size Used: 197 


	Simulations: 1000

test.modmed(med.out, covariates.1 = list (x$PK == 1), covariates.2 = list (x$PK == 0), data = x)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.04370     -0.09498     -0.00137    0.05
	ADE             0.23007      0.11263      0.35012    0.00
	Total Effect    0.18638      0.07404      0.30540    0.00
	Prop. Mediated -0.22222     -0.81062     -0.00431    0.05

	Sample Size Used: 197 


	Simulations: 1000
