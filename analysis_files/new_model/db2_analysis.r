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
    '
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

	R-Square:

	    ATP               0.162
	    MAXMPL            0.218

library(mediation)
med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + PK + PCTREAD + PCTUPDATE + PCTUPDATE:PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + PK + PCTREAD + 
	    PCTUPDATE + PCTUPDATE:PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.24804 -0.08502 -0.03373  0.02683  0.79208 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)   
	(Intercept)    0.04788    0.03566   1.343  0.18101   
	NUMPROCESSORS  0.07022    0.03201   2.193  0.02950 * 
	ACTROWPOOL     0.04285    0.03445   1.244  0.21505   
	PK             0.08855    0.03621   2.445  0.01538 * 
	PCTREAD       -0.14518    0.04472  -3.247  0.00138 **
	PCTUPDATE     -0.13111    0.05188  -2.527  0.01232 * 
	PK:PCTUPDATE  -0.12399    0.07003  -1.771  0.07824 . 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1804 on 190 degrees of freedom
	Multiple R-squared:  0.1758,	Adjusted R-squared:  0.1497 
	F-statistic: 6.753 on 6 and 190 DF,  p-value: 1.679e-06

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
	ACME            0.01532     -0.00102      0.03853    0.07
	ADE             0.19534      0.09814      0.28608    0.00
	Total Effect    0.21065      0.11679      0.30446    0.00
	Prop. Mediated  0.06695     -0.00524      0.21660    0.07

	Sample Size Used: 197 


	Simulations: 1000

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE")
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.04145     -0.08816     -0.00212    0.04
	ADE             0.22671      0.10530      0.34445    0.00
	Total Effect    0.18525      0.06773      0.30099    0.00
	Prop. Mediated -0.21530     -0.78324     -0.00969    0.04

	Sample Size Used: 197 


	Simulations: 1000

test.modmed(med.out, covariates.1 = list (x$PK == 1), covariates.2 = list (x$PK == 0), data = x)

		Test of ACME(covariates.1) - ACME(covariates.2) = 0

	data:  estimates from med.out
	ACME(covariates.1) - ACME(covariates.2) = -6e-04, p-value = 0.986
	alternative hypothesis: true ACME(covariates.1) - ACME(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.06423405  0.06692570


		Test of ADE(covariates.1) - ADE(covariates.2) = 0

	data:  estimates from med.out
	ADE(covariates.1) - ADE(covariates.2) = 0.004, p-value = 0.996
	alternative hypothesis: true ADE(covariates.1) - ADE(covariates.2) is not equal to 0
	95 percent confidence interval:
	 -0.1555005  0.1923729

