# sqlserver
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
sqlserver <- subset(x, x$DBMS=='sqlserver')
sqlserver$ATP = (sqlserver$ATP-min(sqlserver$ATP))/(max(sqlserver$ATP)-min(sqlserver$ATP))
sqlserver$MAXMPL = (sqlserver$MAXMPL-min(sqlserver$MAXMPL))/(max(sqlserver$MAXMPL)-min(sqlserver$MAXMPL))
x = rbind(sqlserver) 
x$ACTROWPOOL = (x$ACTROWPOOL-min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)-min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD-min(x$PCTREAD))/(max(x$PCTREAD)-min(x$PCTREAD))
x$PCTUPDATE = (x$PCTUPDATE-min(x$PCTUPDATE))/(max(x$PCTUPDATE)-min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS-min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)-min(x$NUMPROCESSORS))

med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + PK + PCTREAD + PCTREAD:PK + PCTUPDATE + PCTUPDATE:PK, data = x)
med.reduced <- step(med.fit, direction="backward")
summary(med.reduced)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PCTUPDATE, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.36579 -0.23755  0.00516  0.14656  0.60560 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.30381    0.03127   9.715   <2e-16 ***
	NUMPROCESSORS -0.44914    0.04588  -9.790   <2e-16 ***
	PCTUPDATE      0.12758    0.04734   2.695   0.0076 ** 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2608 on 213 degrees of freedom
	Multiple R-squared:  0.329,	Adjusted R-squared:  0.3227 
	F-statistic: 52.21 on 2 and 213 DF,  p-value: < 2.2e-16

med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + PK + PCTUPDATE + PK:PCTUPDATE, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + PK + PCTUPDATE + 
	    PK:PCTUPDATE, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.36985 -0.21871  0.00455  0.12651  0.61037 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.284894   0.045554   6.254 2.21e-09 ***
	NUMPROCESSORS -0.450381   0.046170  -9.755  < 2e-16 ***
	ACTROWPOOL     0.004101   0.047891   0.086   0.9318    
	PK             0.037492   0.050341   0.745   0.4572    
	PCTUPDATE      0.147673   0.066171   2.232   0.0267 *  
	PK:PCTUPDATE  -0.043900   0.095353  -0.460   0.6457    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2623 on 210 degrees of freedom
	Multiple R-squared:  0.3308,	Adjusted R-squared:  0.3148 
	F-statistic: 20.76 on 5 and 210 DF,  p-value: < 2.2e-16
