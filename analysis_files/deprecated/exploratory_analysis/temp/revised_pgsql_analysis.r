# pgsql
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
# pgsql
pgsql <- subset(x, x$DBMS=='pgsql')
pgsql$ATP = (pgsql$ATP-min(pgsql$ATP))/(max(pgsql$ATP)-min(pgsql$ATP))
pgsql$MAXMPL = (pgsql$MAXMPL-min(pgsql$MAXMPL))/(max(pgsql$MAXMPL)-min(pgsql$MAXMPL))
pgsql$MAXMPL[pgsql$MAXMPL == 1] <- 5
pgsql$MAXMPL[pgsql$MAXMPL > 0.75 & pgsql$MAXMPL <= 1] <- 4
pgsql$MAXMPL[pgsql$MAXMPL > 0.5 & pgsql$MAXMPL <= 0.75] <- 3
pgsql$MAXMPL[pgsql$MAXMPL > 0.25 & pgsql$MAXMPL <= 0.50] <- 2
pgsql$MAXMPL[pgsql$MAXMPL<=0.25] <- 1
pgsql$MAXMPL = (pgsql$MAXMPL-min(pgsql$MAXMPL))/(max(pgsql$MAXMPL)-min(pgsql$MAXMPL))
pgsql$ACTROWPOOL = (pgsql$ACTROWPOOL-min(pgsql$ACTROWPOOL))/(max(pgsql$ACTROWPOOL)-min(pgsql$ACTROWPOOL))
pgsql$PCTREAD = (pgsql$PCTREAD-min(pgsql$PCTREAD))/(max(pgsql$PCTREAD)-min(pgsql$PCTREAD))
pgsql$PCTUPDATE = (pgsql$PCTUPDATE-min(pgsql$PCTUPDATE))/(max(pgsql$PCTUPDATE)-min(pgsql$PCTUPDATE))
pgsql$NUMPROCESSORS = (pgsql$NUMPROCESSORS-min(pgsql$NUMPROCESSORS))/(max(pgsql$NUMPROCESSORS)-min(pgsql$NUMPROCESSORS))
x = rbind(pgsql) 

med.fit <- lm(ATP ~ NUMPROCESSORS + PCTUPDATE  + PK + PK:PCTUPDATE, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PCTUPDATE + PK + PK:PCTUPDATE, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.31115 -0.12407 -0.01243  0.10325  0.58091 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.46035    0.02756  16.705  < 2e-16 ***
	NUMPROCESSORS -0.03388    0.03326  -1.019     0.31    
	PCTUPDATE     -0.59306    0.04685 -12.660  < 2e-16 ***
	PK            -0.28410    0.03712  -7.653 1.03e-12 ***
	PCTUPDATE:PK   0.37563    0.07117   5.278 3.62e-07 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1821 on 186 degrees of freedom
	Multiple R-squared:  0.533,	Adjusted R-squared:  0.523 
	F-statistic: 53.08 on 4 and 186 DF,  p-value: < 2.2e-16

out.fit <- lm(MAXMPL ~ NUMPROCESSORS + ATP + PCTREAD + PCTUPDATE + ACTROWPOOL + PK, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ NUMPROCESSORS + ATP + PCTREAD + PCTUPDATE + 
	    ACTROWPOOL + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.79914 -0.25667  0.03834  0.23803  0.90771 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.38273    0.07420   5.158 6.42e-07 ***
	NUMPROCESSORS -0.26162    0.05944  -4.402 1.82e-05 ***
	ATP            0.27891    0.12632   2.208  0.02848 *  
	PCTREAD       -0.14729    0.07884  -1.868  0.06332 .  
	PCTUPDATE     -0.23882    0.08360  -2.857  0.00477 ** 
	ACTROWPOOL    -0.07406    0.06160  -1.202  0.23080    
	PK             0.58492    0.05092  11.488  < 2e-16 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3242 on 184 degrees of freedom
	Multiple R-squared:  0.4888,	Adjusted R-squared:  0.4721 
	F-statistic: 29.32 on 6 and 184 DF,  p-value: < 2.2e-16

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS", robustSE = TRUE)
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.00919     -0.03572      0.00799    0.34
	ADE            -0.26029     -0.36403     -0.15403    0.00
	Total Effect   -0.26948     -0.37660     -0.16288    0.00
	Prop. Mediated  0.02693     -0.03494      0.12993    0.34

	Sample Size Used: 191 


	Simulations: 1000 

sens.out <- medsens(med.out, effect.type = "both")
summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	       Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	 [1,] -0.9 -0.1337      -0.3524       0.0851         0.81       0.1934
	 [2,] -0.8 -0.0879      -0.2316       0.0559         0.64       0.1528
	 [3,] -0.7 -0.0658      -0.1739       0.0423         0.49       0.1170
	 [4,] -0.6 -0.0516      -0.1372       0.0339         0.36       0.0859
	 [5,] -0.5 -0.0413      -0.1105       0.0279         0.25       0.0597
	 [6,] -0.4 -0.0331      -0.0893       0.0232         0.16       0.0382
	 [7,] -0.3 -0.0262      -0.0716       0.0192         0.09       0.0215
	 [8,] -0.2 -0.0202      -0.0559       0.0156         0.04       0.0095
	 [9,] -0.1 -0.0147      -0.0417       0.0123         0.01       0.0024
	[10,]  0.0 -0.0095      -0.0284       0.0095         0.00       0.0000
	[11,]  0.1 -0.0043      -0.0166       0.0080         0.01       0.0024
	[12,]  0.2  0.0010      -0.0091       0.0111         0.04       0.0095
	[13,]  0.3  0.0067      -0.0086       0.0219         0.09       0.0215
	[14,]  0.4  0.0130      -0.0115       0.0376         0.16       0.0382
	[15,]  0.5  0.0206      -0.0159       0.0570         0.25       0.0597
	[16,]  0.6  0.0301      -0.0216       0.0818         0.36       0.0859
	[17,]  0.7  0.0432      -0.0295       0.1159         0.49       0.1170
	[18,]  0.8  0.0639      -0.0421       0.1700         0.64       0.1528
	[19,]  0.9  0.1081      -0.0695       0.2856         0.81       0.1934

	Rho at which ACME = 0: 0.2
	R^2_M*R^2_Y* at which ACME = 0: 0.04
	R^2_M~R^2_Y~ at which ACME = 0: 0.0095 


	Mediation Sensitivity Analysis for Average Direct Effect

	Sensitivity Region

	      Rho     ADE 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.9 -0.1372      -0.3547       0.0802         0.81       0.1934

	Rho at which ADE = 0: -0.9
	R^2_M*R^2_Y* at which ADE = 0: 0.81
	R^2_M~R^2_Y~ at which ADE = 0: 0.1934

> sens.out$r.square.y
[1] 0.488753
> sens.out$r.square.m
[1] 0.5330371


med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK", robustSE = TRUE)
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.04147     -0.09342      0.00556    0.09
	ADE             0.58456      0.48545      0.68573    0.00
	Total Effect    0.54309      0.44379      0.63478    0.00
	Prop. Mediated -0.07374     -0.18075      0.00993    0.09

	Sample Size Used: 191 


	Simulations: 1000 

sens.out <- medsens(med.out, effect.type = "both")
summary(sens.out)
	
	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	     Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] 0.0 -0.0792      -0.1651       0.0066         0.00       0.0000
	[2,] 0.1 -0.0362      -0.1200       0.0476         0.01       0.0024
	[3,] 0.2  0.0085      -0.0750       0.0920         0.04       0.0095
	[4,] 0.3  0.0555      -0.0296       0.1406         0.09       0.0215

	Rho at which ACME = 0: 0.2
	R^2_M*R^2_Y* at which ACME = 0: 0.04
	R^2_M~R^2_Y~ at which ACME = 0: 0.0095 


	Mediation Sensitivity Analysis for Average Direct Effect

	Sensitivity Region

	     Rho    ADE 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] 0.9 0.0997      -0.0971       0.2966         0.81       0.1934

	Rho at which ADE = 0: 0.9
	R^2_M*R^2_Y* at which ADE = 0: 0.81
	R^2_M~R^2_Y~ at which ADE = 0: 0.1934 

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE", robustSE = TRUE)
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            -0.1186      -0.2690       0.0162    0.09
	ADE             -0.2407      -0.3987      -0.0780    0.00
	Total Effect    -0.3593      -0.5164      -0.2068    0.00
	Prop. Mediated   0.3284      -0.0462       0.7180    0.09

	Sample Size Used: 191 


	Simulations: 1000 

> sens.out <- medsens(med.out, effect.type = "both")
> summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	     Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] 0.0 -0.1654      -0.3385       0.0077         0.00       0.0000
	[2,] 0.1 -0.0754      -0.2487       0.0979         0.01       0.0024
	[3,] 0.2  0.0177      -0.1563       0.1918         0.04       0.0095
	[4,] 0.3  0.1163      -0.0590       0.2916         0.09       0.0215

	Rho at which ACME = 0: 0.2
	R^2_M*R^2_Y* at which ACME = 0: 0.04
	R^2_M~R^2_Y~ at which ACME = 0: 0.0095 


	Mediation Sensitivity Analysis for Average Direct Effect

	Sensitivity Region

	      Rho     ADE 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.5  0.1594      -0.0108       0.3296         0.25       0.0597
	[2,] -0.4  0.0604      -0.1041       0.2249         0.16       0.0382
	[3,] -0.3 -0.0244      -0.1849       0.1361         0.09       0.0215
	[4,] -0.2 -0.1003      -0.2581       0.0575         0.04       0.0095

	Rho at which ADE = 0: -0.3
	R^2_M*R^2_Y* at which ADE = 0: 0.09
	R^2_M~R^2_Y~ at which ADE = 0: 0.0215 
