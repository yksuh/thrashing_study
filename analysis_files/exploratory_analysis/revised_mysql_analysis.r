# mysql
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
mysql <- subset(x, x$DBMS=='mysql')
mysql$ATP = (mysql$ATP-min(mysql$ATP))/(max(mysql$ATP)-min(mysql$ATP))
mysql$MAXMPL = (mysql$MAXMPL-min(mysql$MAXMPL))/(max(mysql$MAXMPL)-min(mysql$MAXMPL))
mysql$MAXMPL[mysql$MAXMPL == 1] <- 5
mysql$MAXMPL[mysql$MAXMPL > 0.75 & mysql$MAXMPL <= 1] <- 4
mysql$MAXMPL[mysql$MAXMPL > 0.5 & mysql$MAXMPL <= 0.75] <- 3
mysql$MAXMPL[mysql$MAXMPL > 0.25 & mysql$MAXMPL <= 0.50] <- 2
mysql$MAXMPL[mysql$MAXMPL<=0.25] <- 1
mysql$MAXMPL = (mysql$MAXMPL-min(mysql$MAXMPL))/(max(mysql$MAXMPL)-min(mysql$MAXMPL))
mysql$ACTROWPOOL = (mysql$ACTROWPOOL-min(mysql$ACTROWPOOL))/(max(mysql$ACTROWPOOL)-min(mysql$ACTROWPOOL))
mysql$PCTREAD = (mysql$PCTREAD-min(mysql$PCTREAD))/(max(mysql$PCTREAD)-min(mysql$PCTREAD))
mysql$PCTUPDATE = (mysql$PCTUPDATE-min(mysql$PCTUPDATE))/(max(mysql$PCTUPDATE)-min(mysql$PCTUPDATE))
mysql$NUMPROCESSORS = (mysql$NUMPROCESSORS-min(mysql$NUMPROCESSORS))/(max(mysql$NUMPROCESSORS)-min(mysql$NUMPROCESSORS))
x = rbind(mysql) 

med.fit <- lm(ATP ~ NUMPROCESSORS + PCTUPDATE  + PK + PK:PCTUPDATE, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PCTUPDATE + PK + PK:PCTUPDATE, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.30220 -0.06118 -0.02234  0.04448  0.44176 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.59472    0.02100  28.322  < 2e-16 ***
	NUMPROCESSORS -0.02976    0.02435  -1.222    0.223    
	PCTUPDATE     -0.20811    0.03465  -6.006  9.1e-09 ***
	PK            -0.53123    0.02774 -19.153  < 2e-16 ***
	PCTUPDATE:PK   0.50201    0.05060   9.921  < 2e-16 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1338 on 196 degrees of freedom
	Multiple R-squared:  0.6738,	Adjusted R-squared:  0.6671 
	F-statistic: 101.2 on 4 and 196 DF,  p-value: < 2.2e-16

out.fit <- lm(MAXMPL ~ NUMPROCESSORS + ATP + PCTREAD + PCTUPDATE + ACTROWPOOL + PK, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ NUMPROCESSORS + ATP + PCTREAD + PCTUPDATE + 
	    ACTROWPOOL + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.87802 -0.21913  0.04967  0.27366  0.59644 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    1.08157    0.08568  12.624  < 2e-16 ***
	NUMPROCESSORS -0.04787    0.05904  -0.811    0.419    
	ATP           -1.18616    0.15168  -7.820 3.29e-13 ***
	PCTREAD       -0.11357    0.09133  -1.244    0.215    
	PCTUPDATE      0.49546    0.06672   7.425 3.47e-12 ***
	ACTROWPOOL     0.01977    0.06495   0.304    0.761    
	PK            -0.34663    0.06740  -5.143 6.60e-07 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.323 on 194 degrees of freedom
	Multiple R-squared:  0.4241,	Adjusted R-squared:  0.4063 
	F-statistic: 23.81 on 6 and 194 DF,  p-value: < 2.2e-16

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS", robustSE = TRUE)
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME             0.0354      -0.0210       0.0975    0.21
	ADE             -0.0487      -0.1726       0.0753    0.43
	Total Effect    -0.0133      -0.1464       0.1139    0.85
	Prop. Mediated  -0.0174      -8.5040       7.9828    0.98

	Sample Size Used: 201 


	Simulations: 1000 

> sens.out <- medsens(med.out, effect.type = "both")
> summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	       Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	 [1,] -0.9 -0.0911      -0.2460       0.0639         0.81       0.1522
	 [2,] -0.8 -0.0422      -0.1120       0.0276         0.64       0.1202
	 [3,] -0.7 -0.0188      -0.0508       0.0133         0.49       0.0921
	 [4,] -0.6 -0.0041      -0.0174       0.0092         0.36       0.0676
	 [5,] -0.5  0.0063      -0.0084       0.0210         0.25       0.0470
	 [6,] -0.4  0.0142      -0.0100       0.0384         0.16       0.0301
	 [7,] -0.3  0.0206      -0.0126       0.0538         0.09       0.0169
	 [8,] -0.2  0.0260      -0.0152       0.0672         0.04       0.0075
	 [9,] -0.1  0.0308      -0.0177       0.0794         0.01       0.0019
	[10,]  0.0  0.0353      -0.0202       0.0908         0.00       0.0000
	[11,]  0.1  0.0396      -0.0226       0.1018         0.01       0.0019
	[12,]  0.2  0.0440      -0.0250       0.1130         0.04       0.0075
	[13,]  0.3  0.0486      -0.0275       0.1248         0.09       0.0169
	[14,]  0.4  0.0539      -0.0302       0.1379         0.16       0.0301
	[15,]  0.5  0.0602      -0.0332       0.1536         0.25       0.0470
	[16,]  0.6  0.0684      -0.0371       0.1738         0.36       0.0676
	[17,]  0.7  0.0801      -0.0427       0.2028         0.49       0.0921
	[18,]  0.8  0.0994      -0.0531       0.2519         0.64       0.1202
	[19,]  0.9  0.1425      -0.0804       0.3654         0.81       0.1522

	Rho at which ACME = 0: -0.6
	R^2_M*R^2_Y* at which ACME = 0: 0.36
	R^2_M~R^2_Y~ at which ACME = 0: 0.0676 


	Mediation Sensitivity Analysis for Average Direct Effect

	Sensitivity Region

	       Rho     ADE 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	 [1,] -0.9  0.0824      -0.1739       0.3387         0.81       0.1522
	 [2,] -0.8  0.0344      -0.1519       0.2207         0.64       0.1202
	 [3,] -0.7  0.0109      -0.1457       0.1675         0.49       0.0921
	 [4,] -0.6 -0.0042      -0.1444       0.1361         0.36       0.0676
	 [5,] -0.5 -0.0151      -0.1455       0.1152         0.25       0.0470
	 [6,] -0.4 -0.0238      -0.1478       0.1003         0.16       0.0301
	 [7,] -0.3 -0.0309      -0.1509       0.0891         0.09       0.0169
	 [8,] -0.2 -0.0371      -0.1546       0.0804         0.04       0.0075
	 [9,] -0.1 -0.0427      -0.1588       0.0734         0.01       0.0019
	[10,]  0.0 -0.0479      -0.1634       0.0677         0.00       0.0000
	[11,]  0.1 -0.0529      -0.1686       0.0628         0.01       0.0019
	[12,]  0.2 -0.0580      -0.1746       0.0586         0.04       0.0075
	[13,]  0.3 -0.0634      -0.1817       0.0550         0.09       0.0169
	[14,]  0.4 -0.0693      -0.1904       0.0518         0.16       0.0301
	[15,]  0.5 -0.0762      -0.2016       0.0492         0.25       0.0470
	[16,]  0.6 -0.0850      -0.2171       0.0471         0.36       0.0676
	[17,]  0.7 -0.0972      -0.2408       0.0464         0.49       0.0921
	[18,]  0.8 -0.1168      -0.2827       0.0490         0.64       0.1202
	[19,]  0.9 -0.1598      -0.3844       0.0648         0.81       0.1522

	Rho at which ADE = 0: -0.6
	R^2_M*R^2_Y* at which ADE = 0: 0.36
	R^2_M~R^2_Y~ at which ADE = 0: 0.0676 


> sens.out$r.square.y
[1] 0.4241372
> sens.out$r.square.m
[1] 0.6737662

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK", robustSE = TRUE)
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME             0.3965       0.2721       0.5237    0.00
	ADE             -0.3481      -0.5028      -0.2044    0.00
	Total Effect     0.0484      -0.0538       0.1589    0.37
	Prop. Mediated   5.4575     -72.5371      72.8177    0.37

	Sample Size Used: 201 


	Simulations: 1000

sens.out <- medsens(med.out, effect.type = "both")
summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.6 -0.0590      -0.2271       0.1091         0.36       0.0676
	[2,] -0.5  0.0957      -0.0742       0.2656         0.25       0.0470

	Rho at which ACME = 0: -0.6
	R^2_M*R^2_Y* at which ACME = 0: 0.36
	R^2_M~R^2_Y~ at which ACME = 0: 0.0676 


	Mediation Sensitivity Analysis for Average Direct Effect

	Sensitivity Region

	      Rho     ADE 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.6  0.0900      -0.0532       0.2333         0.36       0.0676
	[2,] -0.5 -0.0217      -0.1583       0.1149         0.25       0.0470
	[3,] -0.4 -0.1086      -0.2423       0.0250         0.16       0.0301

	Rho at which ADE = 0: -0.5
	R^2_M*R^2_Y* at which ADE = 0: 0.25
	R^2_M~R^2_Y~ at which ADE = 0: 0.047 


> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE", robustSE = TRUE)
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            -0.0345      -0.0984       0.0294    0.31
	ADE              0.4968       0.3579       0.6296    0.00
	Total Effect     0.4623       0.3071       0.6051    0.00
	Prop. Mediated  -0.0713      -0.2860       0.0547    0.31

	Sample Size Used: 201 


	Simulations: 1000 

> sens.out <- medsens(med.out, effect.type = "both")
> summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.9  0.0282      -0.1391       0.1954         0.81       0.1522
	[2,] -0.8 -0.0452      -0.1175       0.0270         0.64       0.1202
	[3,] -0.6 -0.0140      -0.0544       0.0264         0.36       0.0676
	[4,] -0.5  0.0272      -0.0218       0.0762         0.25       0.0470

	Rho at which ACME = 0: -0.6
	R^2_M*R^2_Y* at which ACME = 0: 0.36
	R^2_M~R^2_Y~ at which ACME = 0: 0.0676 


	Mediation Sensitivity Analysis for Average Direct Effect

	Rho at which ADE = 0: -0.9
	R^2_M*R^2_Y* at which ADE = 0: 0.81
	R^2_M~R^2_Y~ at which ADE = 0: 0.1522 
