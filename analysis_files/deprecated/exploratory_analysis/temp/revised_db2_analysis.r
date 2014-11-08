# db2
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
db2 <- subset(x, x$DBMS=='db2')
db2$ATP = (db2$ATP-min(db2$ATP))/(max(db2$ATP)-min(db2$ATP))
db2$MAXMPL = (db2$MAXMPL-min(db2$MAXMPL))/(max(db2$MAXMPL)-min(db2$MAXMPL))
db2$MAXMPL[db2$MAXMPL == 1] <- 5
db2$MAXMPL[db2$MAXMPL > 0.75 & db2$MAXMPL <= 1] <- 4
db2$MAXMPL[db2$MAXMPL > 0.5 & db2$MAXMPL <= 0.75] <- 3
db2$MAXMPL[db2$MAXMPL > 0.25 & db2$MAXMPL <= 0.50] <- 2
db2$MAXMPL[db2$MAXMPL<=0.25] <- 1
db2$MAXMPL = (db2$MAXMPL-min(db2$MAXMPL))/(max(db2$MAXMPL)-min(db2$MAXMPL))
db2$ACTROWPOOL = (db2$ACTROWPOOL-min(db2$ACTROWPOOL))/(max(db2$ACTROWPOOL)-min(db2$ACTROWPOOL))
db2$PCTREAD = (db2$PCTREAD-min(db2$PCTREAD))/(max(db2$PCTREAD)-min(db2$PCTREAD))
db2$PCTUPDATE = (db2$PCTUPDATE-min(db2$PCTUPDATE))/(max(db2$PCTUPDATE)-min(db2$PCTUPDATE))
db2$NUMPROCESSORS = (db2$NUMPROCESSORS-min(db2$NUMPROCESSORS))/(max(db2$NUMPROCESSORS)-min(db2$NUMPROCESSORS))
x = rbind(db2) 

med.fit <- lm(ATP ~ NUMPROCESSORS + PCTUPDATE  + PK + PK:PCTUPDATE, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PCTUPDATE + PK + PK:PCTUPDATE, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.19260 -0.07600 -0.02929  0.01015  0.85072 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)   
	(Intercept)    0.02714    0.02934   0.925  0.35613   
	NUMPROCESSORS  0.06741    0.03285   2.052  0.04153 * 
	PCTUPDATE     -0.07288    0.05002  -1.457  0.14677   
	PK             0.09805    0.03707   2.645  0.00884 **
	PCTUPDATE:PK  -0.13698    0.07179  -1.908  0.05789 . 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1852 on 192 degrees of freedom
	Multiple R-squared:  0.1221,	Adjusted R-squared:  0.1038 
	F-statistic: 6.678 on 4 and 192 DF,  p-value: 4.72e-05

> out.fit <- lm(MAXMPL ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS + PK, data = x)
> summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + 
	    NUMPROCESSORS + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.83236 -0.21519  0.09257  0.23596  0.58071 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.60051    0.06083   9.872  < 2e-16 ***
	PCTREAD       -0.07467    0.08353  -0.894 0.372437    
	PCTUPDATE      0.28492    0.07436   3.832 0.000173 ***
	ACTROWPOOL    -0.13766    0.06289  -2.189 0.029834 *  
	ATP            0.26136    0.13085   1.997 0.047202 *  
	NUMPROCESSORS  0.21748    0.05892   3.691 0.000292 ***
	PK             0.08445    0.04723   1.788 0.075337 .  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.328 on 190 degrees of freedom
	Multiple R-squared:  0.2076,	Adjusted R-squared:  0.1825 
	F-statistic: 8.295 on 6 and 190 DF,  p-value: 5.473e-08

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS", robustSE = TRUE)
summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		        Estimate 95% CI Lower 95% CI Upper p-value
	ACME            0.017366    -0.000158     0.039893    0.05
	ADE             0.218959     0.110367     0.335988    0.00
	Total Effect    0.236325     0.123425     0.358915    0.00
	Prop. Mediated  0.071252    -0.000635     0.179186    0.05

	Sample Size Used: 197 


	Simulations: 1000 

> sens.out <- medsens(med.out, effect.type = "both")
> summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	       Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	 [1,] -0.9  0.2574      -0.0074       0.5222         0.81       0.5635
	 [2,] -0.8  0.1726      -0.0048       0.3499         0.64       0.4452
	 [3,] -0.7  0.1316      -0.0036       0.2668         0.49       0.3409
	 [4,] -0.6  0.1049      -0.0030       0.2127         0.36       0.2504
	 [5,] -0.5  0.0848      -0.0025       0.1722         0.25       0.1739
	 [6,] -0.4  0.0685      -0.0023       0.1392         0.16       0.1113
	 [7,] -0.3  0.0543      -0.0021       0.1107         0.09       0.0626
	 [8,] -0.2  0.0414      -0.0021       0.0849         0.04       0.0278
	 [9,] -0.1  0.0293      -0.0023       0.0610         0.01       0.0070
	[10,]  0.0  0.0176      -0.0030       0.0382         0.00       0.0000
	[11,]  0.1  0.0059      -0.0059       0.0177         0.01       0.0070
	[12,]  0.2 -0.0062      -0.0182       0.0058         0.04       0.0278
	[13,]  0.3 -0.0191      -0.0411       0.0030         0.09       0.0626
	[14,]  0.4 -0.0333      -0.0689       0.0023         0.16       0.1113
	[15,]  0.5 -0.0497      -0.1016       0.0022         0.25       0.1739
	[16,]  0.6 -0.0698      -0.1420       0.0024         0.36       0.2504
	[17,]  0.7 -0.0966      -0.1961       0.0029         0.49       0.3409
	[18,]  0.8 -0.1376      -0.2792       0.0039         0.64       0.4452
	[19,]  0.9 -0.2225      -0.4514       0.0064         0.81       0.5635

	Rho at which ACME = 0: 0.1
	R^2_M*R^2_Y* at which ACME = 0: 0.01
	R^2_M~R^2_Y~ at which ACME = 0: 0.007 


	Mediation Sensitivity Analysis for Average Direct Effect

	Sensitivity Region

	      Rho     ADE 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.9 -0.0219      -0.2985       0.2547         0.81       0.5635
	[2,] -0.8  0.0631      -0.1357       0.2619         0.64       0.4452
	[3,] -0.7  0.1041      -0.0606       0.2688         0.49       0.3409
	[4,] -0.6  0.1308      -0.0140       0.2757         0.36       0.2504

	Rho at which ADE = 0: -0.9
	R^2_M*R^2_Y* at which ADE = 0: 0.81
	R^2_M~R^2_Y~ at which ADE = 0: 0.5635 

>  sens.out$r.square.y
[1] 0.2075686
>  sens.out$r.square.m
[1] 0.1221305

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK", robustSE = TRUE)
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		        Estimate 95% CI Lower 95% CI Upper p-value
	ACME            0.012904    -0.000449     0.031037    0.06
	ADE             0.084463    -0.010870     0.177546    0.08
	Total Effect    0.097366     0.000303     0.189370    0.05
	Prop. Mediated  0.116643    -0.103320     0.724327    0.11

	Sample Size Used: 197 


	Simulations: 1000 

> sens.out <- medsens(med.out, effect.type = "both")
> summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	       Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	 [1,] -0.9  0.2228      -0.0266       0.4721         0.81       0.5635
	 [2,] -0.8  0.1708      -0.0195       0.3611         0.64       0.4452
	 [3,] -0.7  0.1446      -0.0140       0.3032         0.49       0.3409
	 [4,] -0.6  0.1251      -0.0097       0.2600         0.36       0.2504
	 [5,] -0.5  0.1080      -0.0066       0.2225         0.25       0.1739
	 [6,] -0.4  0.0916      -0.0044       0.1875         0.16       0.1113
	 [7,] -0.3  0.0753      -0.0031       0.1537         0.09       0.0626
	 [8,] -0.2  0.0590      -0.0026       0.1205         0.04       0.0278
	 [9,] -0.1  0.0424      -0.0028       0.0876         0.01       0.0070
	[10,]  0.0  0.0256      -0.0040       0.0553         0.00       0.0000
	[11,]  0.1  0.0085      -0.0084       0.0255         0.01       0.0070
	[12,]  0.2 -0.0089      -0.0259       0.0082         0.04       0.0278
	[13,]  0.3 -0.0266      -0.0572       0.0041         0.09       0.0626
	[14,]  0.4 -0.0448      -0.0929       0.0034         0.16       0.1113
	[15,]  0.5 -0.0637      -0.1315       0.0040         0.25       0.1739
	[16,]  0.6 -0.0840      -0.1738       0.0057         0.36       0.2504
	[17,]  0.7 -0.1072      -0.2229       0.0085         0.49       0.3409
	[18,]  0.8 -0.1377      -0.2877       0.0124         0.64       0.4452
	[19,]  0.9 -0.1946      -0.4069       0.0178         0.81       0.5635

	Rho at which ACME = 0: 0.1
	R^2_M*R^2_Y* at which ACME = 0: 0.01
	R^2_M~R^2_Y~ at which ACME = 0: 0.007 


	Mediation Sensitivity Analysis for Average Direct Effect

	Sensitivity Region

	       Rho     ADE 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	 [1,] -0.9 -0.0899      -0.2979       0.1182         0.81       0.5635
	 [2,] -0.8 -0.0279      -0.1792       0.1233         0.64       0.4452
	 [3,] -0.7  0.0020      -0.1253       0.1292         0.49       0.3409
	 [4,] -0.6  0.0214      -0.0923       0.1352         0.36       0.2504
	 [5,] -0.5  0.0360      -0.0693       0.1412         0.25       0.1739
	 [6,] -0.4  0.0478      -0.0517       0.1474         0.16       0.1113
	 [7,] -0.3  0.0581      -0.0377       0.1538         0.09       0.0626
	 [8,] -0.2  0.0673      -0.0259       0.1606         0.04       0.0278
	 [9,] -0.1  0.0760      -0.0157       0.1678         0.01       0.0070
	[10,]  0.0  0.0845      -0.0067       0.1756         0.00       0.0000

	Rho at which ADE = 0: -0.7
	R^2_M*R^2_Y* at which ADE = 0: 0.49
	R^2_M~R^2_Y~ at which ADE = 0: 0.3409

> med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE", robustSE = TRUE)
> summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            -0.0371      -0.0717      -0.0123       0
	ADE              0.2841       0.1291       0.4474       0
	Total Effect     0.2470       0.1067       0.4040       0
	Prop. Mediated  -0.1473      -0.3999      -0.0527       0

	Sample Size Used: 197 


	Simulations: 1000 

> sens.out <- medsens(med.out, effect.type = "both")
> summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	     Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] 0.0 -0.0190      -0.0399       0.0018         0.00       0.0000
	[2,] 0.1 -0.0064      -0.0189       0.0061         0.01       0.0070
	[3,] 0.2  0.0069      -0.0061       0.0200         0.04       0.0278
	[4,] 0.3  0.0222      -0.0008       0.0453         0.09       0.0626

	Rho at which ACME = 0: 0.1
	R^2_M*R^2_Y* at which ACME = 0: 0.01
	R^2_M~R^2_Y~ at which ACME = 0: 0.007 


	Mediation Sensitivity Analysis for Average Direct Effect

	Sensitivity Region

	     Rho     ADE 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] 0.5  0.1449      -0.0157       0.3055         0.25       0.1739
	[2,] 0.6  0.1030      -0.0665       0.2724         0.36       0.2504
	[3,] 0.7  0.0470      -0.1372       0.2312         0.49       0.3409
	[4,] 0.8 -0.0389      -0.2507       0.1729         0.64       0.4452
	[5,] 0.9 -0.2169      -0.4975       0.0637         0.81       0.5635

	Rho at which ADE = 0: 0.8
	R^2_M*R^2_Y* at which ADE = 0: 0.64
	R^2_M~R^2_Y~ at which ADE = 0: 0.4452
