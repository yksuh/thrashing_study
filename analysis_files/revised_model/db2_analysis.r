# db2
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
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
      MAXMPL ~ b1*ATP + c2*NUMPROCESSORS + c3*ACTROWPOOL + c4*PCTUPDATE + c5*PCTREAD + c6*PK
    # interactions
     INT_1 := a3*a4
     INT_3 := a1*a2'
fit <- sem(thrashing_model, data = x)
summary(fit, standardized=TRUE, rsq=T) 

	lavaan (0.5-17) converged normally after  25 iterations

	  Number of observations                           197

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
	    NUMPROCE (a1)     0.070    0.032    2.193    0.028    0.070    0.143
	    ACTROWPO (a2)     0.044    0.034    1.278    0.201    0.044    0.083
	    PK       (a3)     0.044    0.026    1.705    0.088    0.044    0.112
	    PCTUPDAT (a4)    -0.193    0.038   -5.061    0.000   -0.193   -0.364
	    PCTREAD  (a5)    -0.149    0.044   -3.375    0.001   -0.149   -0.242
	  MAXMPL ~
	    ATP      (b1)     0.211    0.107    1.980    0.048    0.211    0.136
	    NUMPROCE (c2)     0.194    0.048    4.040    0.000    0.194    0.258
	    ACTROWPO (c3)    -0.130    0.051   -2.525    0.012   -0.130   -0.160
	    PCTUPDAT (c4)     0.230    0.061    3.798    0.000    0.230    0.280
	    PCTREAD  (c5)    -0.076    0.068   -1.116    0.265   -0.076   -0.080
	    PK       (c6)     0.064    0.039    1.650    0.099    0.064    0.105

	Variances:
	    ATP               0.032    0.003                      0.032    0.838
	    MAXMPL            0.072    0.007                      0.072    0.782

	Defined parameters:
	    INT_1            -0.008    0.005   -1.645    0.100   -0.008   -0.041
	    INT_3             0.003    0.003    1.107    0.268    0.003    0.012

	R-Square:

	    ATP               0.162
	    MAXMPL            0.218


library(mediation)
med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + PK + PCTREAD + PCTUPDATE + PCTUPDATE:PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + 
	    PK + PCTREAD + PCTUPDATE + PCTUPDATE:PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.25541 -0.08356 -0.03340  0.03048  0.79176 

	Coefficients:
		                 Estimate Std. Error t value Pr(>|t|)   
	(Intercept)               0.05277    0.03966   1.331  0.18487   
	NUMPROCESSORS             0.05799    0.05355   1.083  0.28018   
	ACTROWPOOL                0.03278    0.04938   0.664  0.50757   
	PK                        0.08875    0.03631   2.445  0.01542 * 
	PCTREAD                  -0.14516    0.04483  -3.238  0.00142 **
	PCTUPDATE                -0.13091    0.05202  -2.517  0.01268 * 
	NUMPROCESSORS:ACTROWPOOL  0.02456    0.08613   0.285  0.77582   
	PK:PCTUPDATE             -0.12445    0.07022  -1.772  0.07795 . 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1808 on 189 degrees of freedom
	Multiple R-squared:  0.1761,	Adjusted R-squared:  0.1456 
	F-statistic: 5.772 on 7 and 189 DF,  p-value: 4.509e-06

out.fit <- lm(MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + PCTREAD + PK, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + 
	    PCTREAD + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.84778 -0.15428  0.06585  0.19442  0.49463 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.68322    0.05056  13.514  < 2e-16 ***
	ATP            0.21142    0.10874   1.944 0.053348 .  
	ACTROWPOOL    -0.12960    0.05227  -2.479 0.014030 *  
	NUMPROCESSORS  0.19427    0.04896   3.968 0.000103 ***
	PCTUPDATE      0.23047    0.06180   3.729 0.000253 ***
	PCTREAD       -0.07604    0.06941  -1.096 0.274681    
	PK             0.06358    0.03925   1.620 0.106894    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2726 on 190 degrees of freedom
	Multiple R-squared:  0.2178,	Adjusted R-squared:  0.1931 
	F-statistic: 8.817 on 6 and 190 DF,  p-value: 1.747e-08

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		        Estimate 95% CI Lower 95% CI Upper p-value
	ACME            0.015179    -0.000781     0.040339    0.08
	ADE             0.192678     0.096233     0.291490    0.00
	Total Effect    0.207857     0.114119     0.301586    0.00
	Prop. Mediated  0.066781    -0.004312     0.222802    0.08

	Sample Size Used: 197 


	Simulations: 1000

test.modmed(med.out, covariates.1 = list (x$ACTROWPOOL < 0.5), covariates.2 = list (x$x$ACTROWPOOL >= 0.5), data = x)

		Test of ACME(covariates.1) - ACME(covariates.2) = 0

	data:  estimates from med.out
	ACME(covariates.1) - ACME(covariates.2) = 4e-04, p-value = 0.974
	alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.02841169  0.03181880


		Test of ADE(covariates.1) - ADE(covariates.2) = 0

	data:  estimates from med.out
	ADE(covariates.1) - ADE(covariates.2) = -0.0033, p-value = 0.986
	alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.1461225  0.1302809

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.04046     -0.08942      0.00261    0.07
	ADE             0.23194      0.10808      0.35617    0.00
	Total Effect    0.19148      0.07770      0.30363    0.00
	Prop. Mediated -0.20344     -0.71760      0.01231    0.07

	Sample Size Used: 197 


	Simulations: 1000 

test.modmed(med.out, covariates.1 = list (x$PK == 1), covariates.2 = list (x$PK == 0), data = x)

		Test of ACME(covariates.1) - ACME(covariates.2) = 0

	data:  estimates from med.out
	ACME(covariates.1) - ACME(covariates.2) = 9e-04, p-value = 0.954
	alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.06202893  0.05972620


		Test of ADE(covariates.1) - ADE(covariates.2) = 0

	data:  estimates from med.out
	ADE(covariates.1) - ADE(covariates.2) = -0.0038, p-value = 0.978
	alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.1720626  0.1645096

