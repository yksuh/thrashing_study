# oracle
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
oracle <- subset(x, x$DBMS=='oracle')
oracle$ATP = (oracle$ATP-min(oracle$ATP))/(max(oracle$ATP)-min(oracle$ATP))
oracle$MAXMPL = (oracle$MAXMPL-min(oracle$MAXMPL))/(max(oracle$MAXMPL)-min(oracle$MAXMPL))
x = rbind(oracle) 
x$ACTROWPOOL = (x$ACTROWPOOL-min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)-min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD-min(x$PCTREAD))/(max(x$PCTREAD)-min(x$PCTREAD))
x$PCTUPDATE = (x$PCTUPDATE-min(x$PCTUPDATE))/(max(x$PCTUPDATE)-min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS-min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)-min(x$NUMPROCESSORS))


med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + PK + PCTREAD + PCTREAD:PK + PCTUPDATE + PCTUPDATE:PK, data = x)
med.reduced <- step(med.fit, direction="backward")
summary(med.reduced)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + PK + PCTREAD + PCTUPDATE + PK:PCTREAD + PK:PCTUPDATE, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.22683 -0.04484 -0.00062  0.02689  0.78723 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.15834    0.02454   6.453 8.82e-10 ***
	NUMPROCESSORS  0.05662    0.02097   2.700  0.00757 ** 
	ACTROWPOOL     0.03641    0.02197   1.658  0.09905 .  
	PK            -0.19266    0.02898  -6.647 3.04e-10 ***
	PCTREAD        0.11661    0.03898   2.992  0.00314 ** 
	PCTUPDATE     -0.25474    0.03471  -7.339 5.99e-12 ***
	PK:PCTREAD    -0.11634    0.05411  -2.150  0.03279 *  
	PK:PCTUPDATE   0.25825    0.04863   5.311 3.02e-07 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1147 on 191 degrees of freedom
	Multiple R-squared:  0.4494,	Adjusted R-squared:  0.4292 
	F-statistic: 22.27 on 7 and 191 DF,  p-value: < 2.2e-16

med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + PK + PCTUPDATE + PK:PCTUPDATE, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + PK + PCTUPDATE + 
	    PK:PCTUPDATE, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.20945 -0.04999 -0.00221  0.02715  0.75185 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.19339    0.02194   8.813  7.1e-16 ***
	NUMPROCESSORS  0.05970    0.02132   2.800  0.00563 ** 
	ACTROWPOOL     0.03694    0.02236   1.652  0.10007    
	PK            -0.22909    0.02399  -9.551  < 2e-16 ***
	PCTUPDATE     -0.30279    0.03132  -9.668  < 2e-16 ***
	PK:PCTUPDATE   0.30622    0.04396   6.966  5.0e-11 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1168 on 193 degrees of freedom
	Multiple R-squared:  0.4236,	Adjusted R-squared:  0.4086 
	F-statistic: 28.36 on 5 and 193 DF,  p-value: < 2.2e-16
