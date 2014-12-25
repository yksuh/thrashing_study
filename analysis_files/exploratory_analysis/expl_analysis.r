# Overall: 33.4% (close to suboptimal)
library(aod)
library(ggplot2)
#x = read.csv(file="ext_expl.dat",head=TRUE,sep="\t")
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
x_r <- subset(x, x$PCTREAD!=0)
x_r <- subset(x_r, select = -PCTUPDATE)
x <- x_r
#nrow(x)
#[1] 456
#[1] 396
#x <- subset(x, x$ATP < 120000)
#nrow(x)
#nrow(x)
#[1] 997
#x <- subset(x, x$MAXMPL < 1100)
#[1] 188
# ATP normalization
# db2
db2 <- subset(x, x$DBMS=='db2')
db2$ATP = (db2$ATP-min(db2$ATP))/(max(db2$ATP)-min(db2$ATP))
db2$MAXMPL = (db2$MAXMPL-min(db2$MAXMPL))/(max(db2$MAXMPL)-min(db2$MAXMPL))
nrow(db2)
# oracle
oracle <- subset(x, x$DBMS=='oracle')
oracle$ATP = (oracle$ATP-min(oracle$ATP))/(max(oracle$ATP)-min(oracle$ATP))
oracle$MAXMPL = (oracle$MAXMPL-min(oracle$MAXMPL))/(max(oracle$MAXMPL)-min(oracle$MAXMPL))
nrow(oracle)
# mysql
mysql <- subset(x, x$DBMS=='mysql')
mysql$ATP = (mysql$ATP-min(mysql$ATP))/(max(mysql$ATP)-min(mysql$ATP))
mysql$MAXMPL = (mysql$MAXMPL-min(mysql$MAXMPL))/(max(mysql$MAXMPL)-min(mysql$MAXMPL))
nrow(mysql)
# pgsql
pgsql <- subset(x, x$DBMS=='pgsql')
if(max(pgsql$ATP)-min(pgsql$ATP)==0) {
    pgsql$ATP = 0
} else { 
    pgsql$ATP = (pgsql$ATP-min(pgsql$ATP))/(max(pgsql$ATP)-min(pgsql$ATP))
}
if(max(pgsql$MAXMPL)-min(pgsql$MAXMPL)==0) {
    pgsql$MAXMPL = 0
} else { 
    pgsql$MAXMPL = (pgsql$MAXMPL-min(pgsql$MAXMPL))/(max(pgsql$MAXMPL)-min(pgsql$MAXMPL))
}
nrow(pgsql)
# sqlserver
sqlserver <- subset(x, x$DBMS=='sqlserver')
sqlserver$ATP = (sqlserver$ATP-min(sqlserver$ATP))/(max(sqlserver$ATP)-min(sqlserver$ATP))
if(max(sqlserver$MAXMPL)-min(sqlserver$MAXMPL)==0) {
    sqlserver$MAXMPL = 0
} else { 
    sqlserver$MAXMPL = (sqlserver$MAXMPL-min(sqlserver$MAXMPL))/(max(sqlserver$MAXMPL)-min(sqlserver$MAXMPL))
}
nrow(sqlserver)
#### gother each DBMS' samples
x = rbind(db2,mysql,oracle,pgsql,sqlserver)
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD/min(x$PCTREAD))/(max(x$PCTREAD)/min(x$PCTREAD))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
#nrow(x)
#[1] 188
x <- subset(x, x$MAXMPL < 1)
#nrow(x)
#[1] 174
> cor.test(x$NUMPROCESSORS, x$ATP)
	##### all  samples
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -2.2437, df = 394, p-value = 0.02541
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2085585 -0.0139287
	sample estimates:
	       cor 
	-0.1123208 

	#### only thrashing samples
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -0.8856, df = 186, p-value = 0.377
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2060001  0.0790430
	sample estimates:
		cor 
	-0.06480025 

> cor.test(x$ACTROWPOOL, x$ATP)
	Pearson's product-moment correlation

	data:  x$ACTROWPOOL and x$ATP
	t = 1.5295, df = 394, p-value = 0.1269
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.02188418  0.17405617
	sample estimates:
	       cor 
	0.07682773 

	Pearson's product-moment correlation

	data:  x$ACTROWPOOL and x$ATP
	t = 0.0945, df = 186, p-value = 0.9248
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1363192  0.1498879
	sample estimates:
		cor 
	0.006926192 

> cor.test(x$PCTREAD, x$ATP)

	Pearson's product-moment correlation

	data:  x$PCTREAD and x$ATP
	t = -1.001, df = 394, p-value = 0.3175
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.14817421  0.04842317
	sample estimates:
		cor 
	-0.05036339

	Pearson's product-moment correlation

	data:  x$PCTREAD and x$ATP
	t = 0.0416, df = 186, p-value = 0.9668
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1401177  0.1461002
	sample estimates:
		cor 
	0.003053806

> cor.test(x$PK, x$ATP)
	#####  all  samples
	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -7.2769, df = 394, p-value = 1.864e-12
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.4282236 -0.2542817
	sample estimates:
	       cor 
	-0.3442027

	#### only thrashing samples
	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -5.2071, df = 186, p-value = 5.053e-07
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.4755242 -0.2250657
	sample estimates:
	       cor 
	-0.3566874


med.fit <- lm(ATP ~ NUMPROCESSORS + PK, data = x)
summary(med.fit)

	#### all samples
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.49401 -0.20799 -0.00427  0.16565  0.77953 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.50650    0.04235  11.959  < 2e-16 ***
	NUMPROCESSORS -0.09697    0.07292  -1.330    0.185    
	PK            -0.27391    0.05168  -5.301 3.26e-07 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3198 on 185 degrees of freedom
	Multiple R-squared:  0.1355,	Adjusted R-squared:  0.1261 
	F-statistic:  14.5 on 2 and 185 DF,  p-value: 1.416e-06

		### original model
		med.fit <- lm(formula = ATP ~ PK:PCTREAD + PK + PCTREAD + ACTROWPOOL + NUMPROCESSORS + NUMPROCESSORS:ACTROWPOOL, data = x)
		summary(med.fit)
			
		Call:
		lm(formula = ATP ~ PK:PCTREAD + PK + PCTREAD + ACTROWPOOL + NUMPROCESSORS + 
		    NUMPROCESSORS:ACTROWPOOL, data = x)

		Residuals:
		    Min      1Q  Median      3Q     Max 
		-0.5136 -0.2134 -0.0012  0.1673  0.7812 

		Coefficients:
				          Estimate Std. Error t value Pr(>|t|)    
		(Intercept)               0.486296   0.102009   4.767 3.83e-06 ***
		PK                       -0.272541   0.068194  -3.997 9.34e-05 ***
		PCTREAD                   0.019834   0.064091   0.309    0.757    
		ACTROWPOOL                0.022754   0.143867   0.158    0.875    
		NUMPROCESSORS            -0.067998   0.177441  -0.383    0.702    
		PK:PCTREAD               -0.007637   0.116602  -0.065    0.948    
		ACTROWPOOL:NUMPROCESSORS -0.050501   0.271066  -0.186    0.852    
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.3231 on 181 degrees of freedom
		Multiple R-squared:  0.1362,	Adjusted R-squared:  0.1076 
		F-statistic: 4.757 on 6 and 181 DF,  p-value: 0.0001585
		

	#### only thrashing samples
	med.fit <- lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)
	summary(med.fit)
	
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.52009 -0.21736  0.05116  0.16370  0.76693 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.53511    0.04369  12.248  < 2e-16 ***
	NUMPROCESSORS -0.11716    0.07534  -1.555    0.122    
	PK            -0.28739    0.05394  -5.328  3.1e-07 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.317 on 171 degrees of freedom
	Multiple R-squared:  0.1479,	Adjusted R-squared:  0.1379 
	F-statistic: 14.84 on 2 and 171 DF,  p-value: 1.142e-06

		# original model
		med.fit <- lm(formula = ATP ~ PK:PCTREAD + PK + PCTREAD + ACTROWPOOL + NUMPROCESSORS + NUMPROCESSORS:ACTROWPOOL, data = x)
		summary(med.fit)

		Residuals:
		     Min       1Q   Median       3Q      Max 
		-0.54146 -0.21509  0.04979  0.16082  0.78462 

		Coefficients:
				         Estimate Std. Error t value Pr(>|t|)    
		(Intercept)               0.57902    0.10750   5.386 2.41e-07 ***
		PK                       -0.29916    0.07122  -4.200 4.33e-05 ***
		PCTREAD                   0.01230    0.06527   0.188    0.851    
		ACTROWPOOL               -0.07394    0.14978  -0.494    0.622    
		NUMPROCESSORS            -0.18655    0.18554  -1.005    0.316    
		PK:PCTREAD                0.02919    0.12157   0.240    0.811    
		ACTROWPOOL:NUMPROCESSORS  0.10819    0.28347   0.382    0.703    
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.3204 on 167 degrees of freedom
		Multiple R-squared:   0.15,	Adjusted R-squared:  0.1194 
		F-statistic: 4.911 on 6 and 167 DF,  p-value: 0.000119

	### further refined
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.52009 -0.21736  0.05116  0.16370  0.76693 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.53511    0.04369  12.248  < 2e-16 ***
	NUMPROCESSORS -0.11716    0.07534  -1.555    0.122    
	PK            -0.28739    0.05394  -5.328  3.1e-07 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.317 on 171 degrees of freedom
	Multiple R-squared:  0.1479,	Adjusted R-squared:  0.1379 
	F-statistic: 14.84 on 2 and 171 DF,  p-value: 1.142e-06

> cor.test(x$PK, x$MAXMPL)
	#### all samples
	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 8.299, df = 454, p-value = 1.332e-15
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.2804535 0.4400949
	sample estimates:
	      cor 
	0.3629344

	#### only thrashing samples
	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 4.3004, df = 186, p-value = 2.749e-05
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.1647033 0.4255223
	sample estimates:
	      cor 
	0.3007252

> cor.test(x$ATP, x$MAXMPL)
	#### all samples
	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -6.1145, df = 454, p-value = 2.09e-09
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.3585801 -0.1887892
	sample estimates:
	      cor 
	-0.275835 

	#### only thrashing samples
	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -1.3081, df = 186, p-value = 0.1924
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.23537336  0.04829081
	sample estimates:
		cor 
	-0.09547928 

cor.test(x$NUMPROCESSORS, x$MAXMPL)
	#### all samples
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = 1.9898, df = 454, p-value = 0.04721
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.001165636 0.183246481
	sample estimates:
	      cor 
	0.0929834 

	#### only thrashing samples
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = 0.0041, df = 186, p-value = 0.9968
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1428183  0.1434021
	sample estimates:
		 cor 
	0.0002980229

	#### all samples
out.fit <- lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.8818 -0.2953  0.1155  0.2014  0.6504 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.58068    0.03632  15.989  < 2e-16 ***
	PK             0.24294    0.03422   7.100 4.88e-12 ***
	ATP           -0.23873    0.05610  -4.255 2.54e-05 ***
	NUMPROCESSORS  0.06096    0.04782   1.275    0.203    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3536 on 452 degrees of freedom
	Multiple R-squared:  0.1714,	Adjusted R-squared:  0.1659 
	F-statistic: 31.17 on 3 and 452 DF,  p-value: < 2.2e-16

			### original model
			out.fit <- lm(MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, data = x)
			summary(out.fit)

			Call:
			lm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, 
			    data = x)

			Residuals:
			    Min      1Q  Median      3Q     Max 
			-0.8641 -0.3248  0.1090  0.2450  0.7937 

			Coefficients:
				      Estimate Std. Error t value Pr(>|t|)    
			(Intercept)    0.51417    0.06456   7.964 1.84e-14 ***
			PK             0.26586    0.04159   6.392 4.68e-10 ***
			PCTREAD       -0.02626    0.04442  -0.591   0.5548    
			ACTROWPOOL    -0.03333    0.07043  -0.473   0.6363    
			ATP           -0.33201    0.06733  -4.931 1.21e-06 ***
			NUMPROCESSORS  0.13085    0.05571   2.349   0.0193 *  
			---
			Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

			Residual standard error: 0.3881 on 390 degrees of freedom
			Multiple R-squared:  0.2197,	Adjusted R-squared:  0.2097 
			F-statistic: 21.96 on 5 and 390 DF,  p-value: < 2.2e-16

			## sens. analysis
			med.fit <- lm(ATP ~ NUMPROCESSORS + PK, data = x)
			out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
			med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS",sims=100)
			summary(med.out)

			Causal Mediation Analysis 

			Quasi-Bayesian Confidence Intervals

				       Estimate 95% CI Lower 95% CI Upper p-value
			ACME            0.02905      0.00632      0.05465       0
			ADE             0.12354      0.03126      0.21488       0
			Total Effect    0.15260      0.06459      0.24115       0
			Prop. Mediated  0.18564      0.03934      0.48834       0

			Sample Size Used: 396 


			Simulations: 100

			sens.out <-medsens(med.out)
			summary(sens.out)

			Mediation Sensitivity Analysis for Average Causal Mediation Effect

			Sensitivity Region

			      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
			[1,] -0.4 -0.0211      -0.0440       0.0019         0.16       0.1090
			[2,] -0.3 -0.0072      -0.0204       0.0059         0.09       0.0613
			[3,] -0.2  0.0053      -0.0070       0.0176         0.04       0.0273
			[4,] -0.1  0.0171      -0.0026       0.0368         0.01       0.0068
			[5,]  0.0  0.0285      -0.0008       0.0578         0.00       0.0000

			Rho at which ACME = 0: -0.2
			R^2_M*R^2_Y* at which ACME = 0: 0.04
			R^2_M~R^2_Y~ at which ACME = 0: 0.0273


pdf("read_sens_procs.pdf")
plot(sens.out, main = "", xlab=expression("Sensitivity Parameter (Correlation Factor of Error Terms):" ~ rho), ylab="Average Mediation Effect with 95% Confidence Intervals", xlim=c(-0.6, 0.6), ylim=c(-0.3, 0.3))
dev.off()

			med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK", sims=1000)
			summary(med.out)
			sens.out <- medsens(med.out)

			Causal Mediation Analysis 

			Quasi-Bayesian Confidence Intervals

				       Estimate 95% CI Lower 95% CI Upper p-value
			ACME             0.0710       0.0391       0.1071       0
			ADE              0.2653       0.1848       0.3459       0
			Total Effect     0.3363       0.2564       0.4150       0
			Prop. Mediated   0.2106       0.1148       0.3285       0

			Sample Size Used: 396 


			Simulations: 1000

			Mediation Sensitivity Analysis for Average Causal Mediation Effect

			Sensitivity Region

			      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
			[1,] -0.3 -0.0191      -0.0489       0.0107         0.09       0.0607
			[2,] -0.2  0.0136      -0.0161       0.0433         0.04       0.0270

			Rho at which ACME = 0: -0.2
			R^2_M*R^2_Y* at which ACME = 0: 0.04
			R^2_M~R^2_Y~ at which ACME = 0: 0.027


pdf("read_sens_pk.pdf")
plot(sens.out, main = "", xlab=expression("Sensitivity Parameter (Correlation Factor of Error Terms):" ~ rho), ylab="Average Mediation Effect with 95% Confidence Intervals", xlim=c(-0.6, 0.6), ylim=c(-0.3, 0.3))
dev.off()
#main = "Sensitiviy Analysis with Respect to \n Error Correlation between the Mediator (ATP time) and Outcome Models (Thrashing Point)", 

	#### only thrashing samples
	out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
	summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.51421 -0.29222  0.00309  0.26079  0.62067 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.21185    0.05547   3.819 0.000187 ***
	PK             0.25405    0.05397   4.707 5.18e-06 ***
	ATP            0.12997    0.07086   1.834 0.068373 .  
	NUMPROCESSORS  0.04720    0.07030   0.671 0.502863    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2937 on 170 degrees of freedom
	Multiple R-squared:  0.1154,	Adjusted R-squared:  0.09979 
	F-statistic: 7.392 on 3 and 170 DF,  p-value: 0.0001101

		# original model
		out.fit <- lm(MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, data = x)
		summary(out.fit)
		## removed outlier
		Call:
		lm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, 
		    data = x)

		Residuals:
		     Min       1Q   Median       3Q      Max 
		-0.54022 -0.24221 -0.02016  0.23209  0.58479 

		Coefficients:
			      Estimate Std. Error t value Pr(>|t|)    
		(Intercept)    0.32029    0.07919   4.045 7.97e-05 ***
		PK             0.24987    0.05367   4.656 6.53e-06 ***
		PCTREAD        0.02265    0.05008   0.452   0.6516    
		ACTROWPOOL    -0.16748    0.08072  -2.075   0.0395 *  
		ATP            0.12564    0.07040   1.785   0.0761 .  
		NUMPROCESSORS  0.03008    0.07034   0.428   0.6695    
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.2916 on 168 degrees of freedom
		Multiple R-squared:  0.1383,	Adjusted R-squared:  0.1127 
		F-statistic: 5.393 on 5 and 168 DF,  p-value: 0.000126

### mediation analysis
library(mediation)
med.fit <- lm(ATP ~ NUMPROCESSORS + PK, data = x)
out.fit <- lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

med.fit <- lm(ATP ~ NUMPROCESSORS + PK, data = db2)
out.fit <- lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = db2)


	### All samples
	med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
	summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            -0.0731      -0.1164      -0.0357       0
	ADE              0.2288       0.1088       0.3416       0
	Total Effect     0.1557       0.0387       0.2734       0
	Prop. Mediated  -0.4672      -2.2310      -0.1824       0

	Sample Size Used: 539 


	Simulations: 1000

	med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK")
	summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.01966     -0.03680     -0.00562       0
	ADE             0.18059      0.10812      0.24707       0
	Total Effect    0.16094      0.09091      0.22839       0
	Prop. Mediated -0.11942     -0.31358     -0.03067       0

	Sample Size Used: 539 


	Simulations: 1000

	### thrashing samples
	med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
	summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            0.03788     -0.00804      0.09185    0.11
	ADE             0.15094      0.04905      0.25511    0.00
	Total Effect    0.18882      0.08253      0.30328    0.00
	Prop. Mediated  0.19346     -0.05123      0.53041    0.11

	Sample Size Used: 148 


	Simulations: 1000 

	med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK")
	summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            0.14507      0.08590      0.21045    0.00
	ADE            -0.06445     -0.16478      0.03074    0.17
	Total Effect    0.08062      0.00147      0.15603    0.04
	Prop. Mediated  1.74345      0.65599     15.26999    0.04

	Sample Size Used: 148 


	Simulations: 1000

### assumption testing #####
library(car)
out.fit <- lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
outlierTest(out.fit)
#pdf("new_normales_qqplot.pdf")
qqnorm(out.fit$res,main="",ylim=c(-0.8,0.6)); qqline(out.fit$res);
#dev.off()
#pdf("read_normal_res.pdf")
pdf("new_read_normal_res.pdf")
#h <- hist(out.fit$res,main="",xlab="Residuals",ylim=c(0,50),xlim=c(-0.6,0.6))
h <- hist(out.fit$res,main="",xlab="Residuals",ylim=c(0,50),xlim=c(-0.6,0.6))
xfit<-seq(min(out.fit$res),max(out.fit$res),length=40) 
yfit<-dnorm(xfit,mean=mean(out.fit$res),sd=sd(out.fit$res)) 
yfit <- yfit*diff(h$mids[1:2])*length(out.fit$res) 
lines(xfit, yfit, col="blue")
dev.off()

pdf("read_cd.pdf")
cd = cooks.distance(out.fit)
plot(cd, ylim=c(0, 0.08), main="(CD shouldn't be greater than 1)", ylab="Cook's Distances (CDs)", xlab="Observeration Number")
dev.off()

ncvTest(out.fit)

	Non-constant Variance Score Test 
	Variance formula: ~ fitted.values 
	Chisquare = 2.859574    Df = 1     p = 0.008315594 

# Evaluate Collinearity
vif(out.fit) # variance inflation factors 
           PK           ATP NUMPROCESSORS 
     1.519995      1.535991      1.014853

> sqrt(vif(out.fit)) > 2
           PK           ATP NUMPROCESSORS 
        FALSE         FALSE         FALSE

# Evaluate Nonlinearity
# component + residual plot 
pdf("linearity_assumption_testesult.pdf")
crPlots(out.fit, main = "",)
dev.off()

# Test for Autocorrelated Errors
durbinWatsonTest(out.fit)
	 lag Autocorrelation D-W Statistic p-value
	   1       0.2091418      1.561056   0.006
	 Alternative hypothesis: rho != 0

#### per-DBMS #####
18.87 (0.01)\% for DBMS X, 
27.54\% for MySQL, 
13.92 (6.96)\% for DBMS Y, 
3.34\% for PostgreSQL, and 
48.71\% for DBMS Z.

#### thrashing or not thrashing
x = read.csv(file="ext_cnfm.dat",head=TRUE,sep="\t")
x$MAXMPL[x$MAXMPL < 1100] <- 1
x$MAXMPL[x$MAXMPL == 1100] <- 0 ### thrashing
x_r <- subset(x, x$PCTREAD!=0)
x_r <- subset(x_r, select = -PCTUPDATE)
x <- x_r
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD/min(x$PCTREAD))/(max(x$PCTREAD)/min(x$PCTREAD))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
nrow(x)
599
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
#out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS + PCTREAD + ACTROWPOOL, family=binomial("probit"), data = x)
summary(out.fit)

Call:
glm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

Deviance Residuals: 
    Min       1Q   Median       3Q      Max  
-0.4580  -0.3069  -0.2304   0.5676   0.8697  

Coefficients:
                Estimate Std. Error t value Pr(>|t|)    
(Intercept)    4.830e-01  4.591e-02  10.520  < 2e-16 ***
PK            -1.510e-01  3.669e-02  -4.116  4.4e-05 ***
ATP           -4.682e-07  5.121e-07  -0.914 0.360912    
NUMPROCESSORS -2.000e-01  5.707e-02  -3.505 0.000491 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

(Dispersion parameter for gaussian family taken to be 0.1982194)

    Null deviance: 123.46  on 598  degrees of freedom
Residual deviance: 117.94  on 595  degrees of freedom
AIC: 736.47

Number of Fisher Scoring iterations: 2

wald.test(b = coef(out.fit), Sigma = vcov(out.fit), Terms = 2:4)
Wald test:
----------

Chi-squared test:
X2 = 27.8, df = 3, P(> X2) = 4e-06

> 1-out.fit$deviance/out.fit$null.deviance
[1] 0.0446734

#### per-DBMS logistic #####
db2 <- subset(x, x$DBMS=='db2')
db2$ATP = (db2$ATP-min(db2$ATP))/(max(db2$ATP)-min(db2$ATP))
db2$NUMPROCESSORS = (db2$NUMPROCESSORS/min(db2$NUMPROCESSORS))/(max(db2$NUMPROCESSORS)/min(db2$NUMPROCESSORS))
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS,  data = db2)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.1443036
mysql <- subset(x, x$DBMS=='mysql')
mysql$ATP = (mysql$ATP-min(mysql$ATP))/(max(mysql$ATP)-min(mysql$ATP))
mysql$NUMPROCESSORS = (mysql$NUMPROCESSORS/min(mysql$NUMPROCESSORS))/(max(mysql$NUMPROCESSORS)/min(mysql$NUMPROCESSORS))
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = mysql)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.593266
pgsql <- subset(x, x$DBMS=='pgsql')
pgsql$ATP = (pgsql$ATP-min(pgsql$ATP))/(max(pgsql$ATP)-min(pgsql$ATP))
pgsql$NUMPROCESSORS = (pgsql$NUMPROCESSORS/min(pgsql$NUMPROCESSORS))/(max(pgsql$NUMPROCESSORS)/min(pgsql$NUMPROCESSORS))
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = pgsql)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.05590754
oracle <- subset(x, x$DBMS=='oracle')
oracle$ATP = (oracle$ATP-min(oracle$ATP))/(max(oracle$ATP)-min(oracle$ATP))
oracle$NUMPROCESSORS = (oracle$NUMPROCESSORS/min(oracle$NUMPROCESSORS))/(max(oracle$NUMPROCESSORS)/min(oracle$NUMPROCESSORS))
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = oracle)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.1346947
sqlserver <- subset(x, x$DBMS=='sqlserver')
sqlserver$ATP = (sqlserver$ATP-min(sqlserver$ATP))/(max(sqlserver$ATP)-min(sqlserver$ATP))
sqlserver$NUMPROCESSORS = (sqlserver$NUMPROCESSORS/min(sqlserver$NUMPROCESSORS))/(max(sqlserver$NUMPROCESSORS)/min(sqlserver$NUMPROCESSORS))
out.fit <-  glm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = sqlserver)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.4065833

### update-only
library(aod)
library(ggplot2)
#x = read.csv(file="ext_expl.dat",head=TRUE,sep="\t")
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
#x$MAXMPL[x$MAXMPL == 1100] <- 10000
x_w <- subset(x, x$PCTUPDATE!=0)
x_w <- subset(x_w, select = -PCTREAD)
x <- x_w
nrow(x)
#[1] 686
# [1] 607
x <- subset(x, x$MAXMPL < 1100)
#x$MAXMPL[x$MAXMPL == 1100] <- 10000
#nrow(x)
#[1] 328
#[1] 299
# ATP normalization
# db2
db2 <- subset(x, x$DBMS=='db2')
db2$ATP = (db2$ATP-min(db2$ATP))/(max(db2$ATP)-min(db2$ATP))
db2$MAXMPL = (db2$MAXMPL-min(db2$MAXMPL))/(max(db2$MAXMPL)-min(db2$MAXMPL))
nrow(db2)
# oracle
oracle <- subset(x, x$DBMS=='oracle')
oracle$ATP = (oracle$ATP-min(oracle$ATP))/(max(oracle$ATP)-min(oracle$ATP))
oracle$MAXMPL = (oracle$MAXMPL-min(oracle$MAXMPL))/(max(oracle$MAXMPL)-min(oracle$MAXMPL))
nrow(oracle)
# mysql
mysql <- subset(x, x$DBMS=='mysql')
mysql$ATP = (mysql$ATP-min(mysql$ATP))/(max(mysql$ATP)-min(mysql$ATP))
mysql$MAXMPL = (mysql$MAXMPL-min(mysql$MAXMPL))/(max(mysql$MAXMPL)-min(mysql$MAXMPL))
nrow(mysql)
# pgsql
pgsql <- subset(x, x$DBMS=='pgsql')
pgsql$ATP = (pgsql$ATP-min(pgsql$ATP))/(max(pgsql$ATP)-min(pgsql$ATP))
pgsql$MAXMPL = (pgsql$MAXMPL-min(pgsql$MAXMPL))/(max(pgsql$MAXMPL)-min(pgsql$MAXMPL))
nrow(pgsql)
# sqlserver
sqlserver <- subset(x, x$DBMS=='sqlserver')
sqlserver$ATP = (sqlserver$ATP-min(sqlserver$ATP))/(max(sqlserver$ATP)-min(sqlserver$ATP))
sqlserver$MAXMPL = (sqlserver$MAXMPL-min(sqlserver$MAXMPL))/(max(sqlserver$MAXMPL)-min(sqlserver$MAXMPL))
nrow(sqlserver)
x = rbind(db2,mysql,oracle,pgsql,sqlserver)
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTUPDATE = (x$PCTUPDATE/min(x$PCTUPDATE))/(max(x$PCTUPDATE)/min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
#x <- subset(x, x$MAXMPL < 1 & x$MAXMPL > 0)
x <- subset(x, x$MAXMPL < 1)
#nrow(x)
#[1] 328
#[1] 260

cor.test(x$NUMPROCESSORS, x$ATP)
	#####  all samples 
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -4.8643, df = 684, p-value = 1.427e-06
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2542308 -0.1094981
	sample estimates:
	      cor 
	-0.182855
	
	#####  thrashing samples 
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -6.0538, df = 297, p-value = 4.263e-09
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.4287348 -0.2265069
	sample estimates:
	       cor 
	-0.3314221

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -4.9089, df = 605, p-value = 1.18e-06
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2710744 -0.1179715
	sample estimates:
	       cor 
	-0.1957153


cor.test(x$PK, x$ATP)
	#####  all samples 
	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -2.7129, df = 684, p-value = 0.006837
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.17666822 -0.02854183
	sample estimates:
	      cor 
	-0.103177

	#####  thrashing samples
	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -0.2085, df = 605, p-value = 0.8349
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.08799708  0.07115388
	sample estimates:
		 cor 
	-0.008475272

	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = 2.657, df = 258, p-value = 0.008375
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.04238837 0.27930875
	sample estimates:
	      cor 
	0.1632005

med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + PK + PCTUPDATE + PCTUPDATE:PK, data = x)
summary(med.fit)

	#####  thrashing samples 
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + 
	    PK + PCTUPDATE + PCTUPDATE:PK, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.44572 -0.23773 -0.06927  0.17636  0.81572 

	Coefficients:
		                   Estimate Std. Error t value Pr(>|t|)  
	(Intercept)               0.2608179  0.1079845   2.415   0.0164 *
	NUMPROCESSORS            -0.2845868  0.1484092  -1.918   0.0563 .
	ACTROWPOOL                0.1071328  0.1235238   0.867   0.3866  
	PK                        0.1278712  0.0945363   1.353   0.1774  
	PCTUPDATE                 0.0342841  0.0979067   0.350   0.7265  
	NUMPROCESSORS:ACTROWPOOL -0.0457667  0.2105161  -0.217   0.8281  
	PK:PCTUPDATE             -0.0001347  0.1378434  -0.001   0.9992  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3123 on 253 degrees of freedom
	Multiple R-squared:  0.1306,	Adjusted R-squared:  0.1099 
	F-statistic: 6.332 on 6 and 253 DF,  p-value: 3.196e-06

	
		##### cand1
		med.fit <- lm(ATP ~ NUMPROCESSORS, data = x)
		summary(med.fit)
	
		Call:
		lm(formula = ATP ~ NUMPROCESSORS, data = x)

		Residuals:
		    Min      1Q  Median      3Q     Max 
		-0.3354 -0.2563 -0.1009  0.2019  0.8917 

		Coefficients:
			      Estimate Std. Error t value Pr(>|t|)    
		(Intercept)    0.40509    0.03455   11.72  < 2e-16 ***
		NUMPROCESSORS -0.29674    0.05959   -4.98 1.17e-06 ***
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.3168 on 258 degrees of freedom
		Multiple R-squared:  0.08768,	Adjusted R-squared:  0.08415 
		F-statistic:  24.8 on 1 and 258 DF,  p-value: 1.167e-06

		##### cand2
		med.fit <- lm(ATP ~ PK + NUMPROCESSORS, data = x)
		summary(med.fit)
	
		Call:
		lm(formula = ATP ~ PK + NUMPROCESSORS, data = x)

		Residuals:
		     Min       1Q   Median       3Q      Max 
		-0.40073 -0.25158 -0.07991  0.16244  0.83547 

		Coefficients:
			      Estimate Std. Error t value Pr(>|t|)    
		(Intercept)    0.35200    0.03756   9.371  < 2e-16 ***
		PK             0.12746    0.03876   3.288  0.00115 ** 
		NUMPROCESSORS -0.31493    0.05875  -5.360 1.85e-07 ***
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.311 on 257 degrees of freedom
		Multiple R-squared:  0.1245,	Adjusted R-squared:  0.1177 
		F-statistic: 18.28 on 2 and 257 DF,  p-value: 3.792e-08

cor.test(x$PK, x$MAXMPL)
	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 0.0777, df = 684, p-value = 0.9381
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.07189983  0.07781016
	sample estimates:
		cor 
	0.002971818

	#####  thrashing samples 
	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 0.1598, df = 605, p-value = 0.8731
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.07312043  0.08603522
	sample estimates:
		cor 
	0.006498548

	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 0.6258, df = 258, p-value = 0.532
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.08311914  0.15982493
	sample estimates:
	       cor 
	0.03892816

cor.test(x$ATP, x$MAXMPL)
	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = 4.1441, df = 684, p-value = 3.84e-05
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.08261228 0.22867686
	sample estimates:
	      cor 
	0.1565001

	#####  thrashing samples 
	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = 2.1728, df = 605, p-value = 0.03018
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.008473861 0.166411498
	sample estimates:
	       cor 
	0.08799568 

	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = 0.4922, df = 258, p-value = 0.623
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.09136592  0.15171654
	sample estimates:
	       cor 
	0.03062817

cor.test(x$NUMPROCESSORS, x$MAXMPL)
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = -4.5481, df = 684, p-value = 6.402e-06
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.24306870 -0.09772814
	sample estimates:
	       cor 
	-0.1713304

	#####  thrashing samples 
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = -3.839, df = 605, p-value = 0.0001366
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.23095592 -0.07555514
	sample estimates:
	       cor 
	-0.1542091

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = -6.5744, df = 258, p-value = 2.694e-10
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.4784073 -0.2695684
	sample estimates:
	       cor 
	-0.3787997

	### thrashing samples
out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS + PCTUPDATE + ACTROWPOOL, data = x)
summary(out.fit)
	
	Call:
	lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

	Residuals:
	    Min      1Q  Median      3Q     Max 
	-0.6086 -0.2494  0.1132  0.2957  0.6967 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.65323    0.04565  14.310  < 2e-16 ***
	PK             0.06810    0.04152   1.640   0.1022    
	ATP           -0.11710    0.06545  -1.789   0.0748 .  
	NUMPROCESSORS -0.45020    0.06500  -6.926 3.48e-11 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3263 on 256 degrees of freedom
	Multiple R-squared:  0.1596,	Adjusted R-squared:  0.1498 
	F-statistic: 16.21 on 3 and 256 DF,  p-value: 1.125e-09

		## candidate 1
		

		## candidate 2
		out.fit <- lm(MAXMPL ~ ATP + NUMPROCESSORS, data = x)
		summary(out.fit)

		Call:
		lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

		Residuals:
		    Min      1Q  Median      3Q     Max 
		-0.6155 -0.2298  0.1392  0.2930  0.7087 

		Coefficients:
			      Estimate Std. Error t value Pr(>|t|)    
		(Intercept)    0.67286    0.04420  15.224  < 2e-16 ***
		ATP           -0.09553    0.06432  -1.485    0.139    
		NUMPROCESSORS -0.43408    0.06446  -6.734 1.07e-10 ***
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.3274 on 257 degrees of freedom
		Multiple R-squared:  0.1508,	Adjusted R-squared:  0.1442 
		F-statistic: 22.81 on 2 and 257 DF,  p-value: 7.574e-10

### mediation analysis
library(mediation)
med.fit <- lm(ATP ~ NUMPROCESSORS + PK, data = x)
out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	### thrashing samples
	med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS", sims=100)
	summary(med.out)
	
	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME            0.04072      0.00369      0.08325    0.04
	ADE            -0.45962     -0.59140     -0.33967    0.00
	Total Effect   -0.41890     -0.55133     -0.30253    0.00
	Prop. Mediated -0.10173     -0.23249     -0.00871    0.04

	Sample Size Used: 260 


	Simulations: 100

	sens.out <- medsens(med.out)
	summary(sens.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.2 -0.0304      -0.0721       0.0112         0.04       0.0294
	[2,] -0.1  0.0037      -0.0365       0.0439         0.01       0.0074
	[3,]  0.0  0.0369      -0.0055       0.0792         0.00       0.0000

	Rho at which ACME = 0: -0.1
	R^2_M*R^2_Y* at which ACME = 0: 0.01
R^2_M~R^2_Y~ at which ACME = 0: 0.0074

pdf("update_sens_procs.pdf")
plot(sens.out, main = "", xlab=expression("Sensitivity Parameter (Correlation Factor of Error Terms):" ~ rho), ylab="Average Mediation Effect with 95% Confidence Intervals", xlim=c(-0.6, 0.6), ylim=c(-0.3, 0.3))
dev.off()
#main = "Sensitiviy Analysis with Respect to \n Error Correlation between the Mediator (ATP time) and Outcome Models (Thrashing Point)", 

	med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK")
	summary(med.out)

	Causal Mediation Analysis 

	Quasi-Bayesian Confidence Intervals

		       Estimate 95% CI Lower 95% CI Upper p-value
	ACME           -0.01471     -0.04001      0.00109    0.09
	ADE             0.06808     -0.01194      0.14839    0.09
	Total Effect    0.05337     -0.02824      0.13223    0.18
	Prop. Mediated -0.20640     -2.54565      2.00415    0.24

	Sample Size Used: 260 


	Simulations: 1000

	sens.out <- medsens(med.out)

	Mediation Sensitivity Analysis for Average Causal Mediation Effect

	Sensitivity Region

	      Rho    ACME 95% CI Lower 95% CI Upper R^2_M*R^2_Y* R^2_M~R^2_Y~
	[1,] -0.2  0.0123      -0.0055       0.0301         0.04       0.0294
	[2,] -0.1 -0.0015      -0.0178       0.0148         0.01       0.0074
	[3,]  0.0 -0.0149      -0.0334       0.0036         0.00       0.0000

	Rho at which ACME = 0: -0.1
	R^2_M*R^2_Y* at which ACME = 0: 0.01
	R^2_M~R^2_Y~ at which ACME = 0: 0.0074

pdf("update_sens_pk.pdf")
plot(sens.out, main = "", xlab=expression("Sensitivity Parameter (Correlation Factor of Error Terms):" ~ rho), ylab="Average Mediation Effect with 95% Confidence Intervals", xlim=c(-0.6, 0.6), ylim=c(-0.3, 0.3))
dev.off()

### assumption testing #####
library(car)
out.fit <- lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)
outlierTest(out.fit)
#dev.off()
pdf("update_non_normal_res.pdf")
#h <- hist(out.fit$res,main="",xlab="Residuals",ylim=c(0,35),xlim=c(-0.06,0.06))
h <- hist(out.fit$res,main="",xlab="Residuals",ylim=c(0,70),xlim=c(-0.06,0.06))
xfit<-seq(min(out.fit$res),max(out.fit$res),length=40) 
yfit<-dnorm(xfit,mean=mean(out.fit$res),sd=sd(out.fit$res)) 
yfit <- yfit*diff(h$mids[1:2])*length(out.fit$res) 
lines(xfit, yfit, col="blue")
dev.off()

pdf("update_cd.pdf")
cd = cooks.distance(out.fit)
plot(cd, xlim=c(0, 350), ylim=c(0, 0.03), main="(CD shouldn't be greater than 1)", ylab="Cook's Distances (CDs)", xlab="Observeration Number")
dev.off()

ncvTest(out.fit)

	Non-constant Variance Score Test 
	Variance formula: ~ fitted.values 
	Chisquare = 0.2330649    Df = 1     p = 0.6292605

# Evaluate Collinearity
vif(out.fit) # variance inflation factors 
          ATP NUMPROCESSORS 
     1.039537      1.03953 

sqrt(vif(out.fit)) > 2 # problem?
          ATP NUMPROCESSORS 
     1.019577      1.01957

# Evaluate Nonlinearity
# component + residual plot 
pdf("linearity_assumption_testesult.pdf")
crPlots(out.fit, main = "",)
dev.off()

# Test for Autocorrelated Errors
durbinWatsonTest(out.fit)
	 lag Autocorrelation D-W Statistic p-value
	   1       0.1900665       0.9446755   0.012
	 Alternative hypothesis: rho != 0

#### per-DBMS #####
17.13 (0.0048)\% for DBMS X, 
27.54 % for MySQL, 
31.38 % for DBMS Y, 
20.93 % for PostgreSQL, and 
14.87 % for DBMS Z.

#### thrashing or not thrashing
library(aod)
library(ggplot2)
x = read.csv(file="cnfm.dat",head=TRUE,sep="\t")
x$MAXMPL[x$MAXMPL < 1100] <- 1 ### thrashing
x$MAXMPL[x$MAXMPL == 1100] <- 0
x_w <- subset(x, x$PCTUPDATE!=0)
x_w <- subset(x_w, select = -PCTREAD)
x <- x_w
nrow(x)
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTUPDATE = (x$PCTUPDATE/min(x$PCTUPDATE))/(max(x$PCTUPDATE)/min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
out.fit <-  glm(MAXMPL ~ ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	glm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

	Deviance Residuals: 
	    Min       1Q   Median       3Q      Max  
	-0.5157  -0.4158  -0.3506   0.5538   0.7222  

	Coefficients:
		        Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    3.555e-01  4.012e-02   8.862   <2e-16 ***
	ATP           -4.932e-07  3.652e-07  -1.351   0.1772    
	NUMPROCESSORS  1.602e-01  5.534e-02   2.895   0.0039 ** 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	(Dispersion parameter for gaussian family taken to be 0.2403861)

	    Null deviance: 194.56  on 799  degrees of freedom
	Residual deviance: 191.59  on 797  degrees of freedom
	AIC: 1134.9

	Number of Fisher Scoring iterations: 2

wald.test(b = coef(out.fit), Sigma = vcov(out.fit), Terms = 2:3)
Wald test:
----------

Chi-squared test:
X2 = 12.3, df = 2, P(> X2) = 0.0021

> 1-out.fit$deviance/out.fit$null.deviance
[1] 0.0152516

###################
db2 <- subset(x, x$DBMS=='db2')
db2$ATP = (db2$ATP-min(db2$ATP))/(max(db2$ATP)-min(db2$ATP))
db2$NUMPROCESSORS = (db2$NUMPROCESSORS/min(db2$NUMPROCESSORS))/(max(db2$NUMPROCESSORS)/min(db2$NUMPROCESSORS))
out.fit <-  glm(MAXMPL ~ ATP + NUMPROCESSORS, data = db2)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.1514176
mysql <- subset(x, x$DBMS=='mysql')
mysql$ATP = (mysql$ATP-min(mysql$ATP))/(max(mysql$ATP)-min(mysql$ATP))
mysql$NUMPROCESSORS = (mysql$NUMPROCESSORS/min(mysql$NUMPROCESSORS))/(max(mysql$NUMPROCESSORS)/min(mysql$NUMPROCESSORS))
out.fit <-  glm(MAXMPL ~ ATP + NUMPROCESSORS, data = mysql)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.06971828
pgsql <- subset(x, x$DBMS=='pgsql')
pgsql$ATP = (pgsql$ATP-min(pgsql$ATP))/(max(pgsql$ATP)-min(pgsql$ATP))
pgsql$NUMPROCESSORS = (pgsql$NUMPROCESSORS/min(pgsql$NUMPROCESSORS))/(max(pgsql$NUMPROCESSORS)/min(pgsql$NUMPROCESSORS))
out.fit <-  glm(MAXMPL ~ ATP + NUMPROCESSORS, data = pgsql)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.07866522
oracle <- subset(x, x$DBMS=='oracle')
oracle$ATP = (oracle$ATP-min(oracle$ATP))/(max(oracle$ATP)-min(oracle$ATP))
oracle$NUMPROCESSORS = (oracle$NUMPROCESSORS/min(oracle$NUMPROCESSORS))/(max(oracle$NUMPROCESSORS)/min(oracle$NUMPROCESSORS))
out.fit <-  glm(MAXMPL ~ ATP + NUMPROCESSORS, data = oracle)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.4548632
sqlserver <- subset(x, x$DBMS=='sqlserver')
sqlserver$ATP = (sqlserver$ATP-min(sqlserver$ATP))/(max(sqlserver$ATP)-min(sqlserver$ATP))
sqlserver$NUMPROCESSORS = (sqlserver$NUMPROCESSORS/min(sqlserver$NUMPROCESSORS))/(max(sqlserver$NUMPROCESSORS)/min(sqlserver$NUMPROCESSORS))
out.fit <-  glm(MAXMPL ~ ATP + NUMPROCESSORS, data = sqlserver)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
[1] 0.657579
