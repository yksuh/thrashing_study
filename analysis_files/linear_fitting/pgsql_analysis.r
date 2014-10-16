# pgsql
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
pgsql <- subset(x, x$DBMS=='pgsql')
pgsql$ATP = (pgsql$ATP-min(pgsql$ATP))/(max(pgsql$ATP)-min(pgsql$ATP))
pgsql$MAXMPL = (pgsql$MAXMPL-min(pgsql$MAXMPL))/(max(pgsql$MAXMPL)-min(pgsql$MAXMPL))
x = rbind(pgsql) 
x$ACTROWPOOL = (x$ACTROWPOOL-min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)-min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD-min(x$PCTREAD))/(max(x$PCTREAD)-min(x$PCTREAD))
x$PCTUPDATE = (x$PCTUPDATE-min(x$PCTUPDATE))/(max(x$PCTUPDATE)-min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS-min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)-min(x$NUMPROCESSORS))


med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + PK + PCTREAD + PCTREAD:PK + PCTUPDATE + PCTUPDATE:PK, data = x)
med.reduced <- step(med.fit, direction="backward")
summary(med.reduced)

	Call:
	lm(formula = ATP ~ PK + PCTREAD + PCTUPDATE + PK:PCTREAD + PK:PCTUPDATE, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.31216 -0.09860 -0.00210  0.09174  0.63446 

	Coefficients:
		     Estimate Std. Error t value Pr(>|t|)    
	(Intercept)   0.41306    0.02812  14.687  < 2e-16 ***
	PK           -0.32690    0.04344  -7.525 2.23e-12 ***
	PCTREAD       0.11459    0.05448   2.103   0.0368 *  
	PCTUPDATE    -0.54786    0.04961 -11.044  < 2e-16 ***
	PK:PCTREAD    0.12458    0.08223   1.515   0.1315    
	PK:PCTUPDATE  0.43290    0.07590   5.704 4.58e-08 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1742 on 185 degrees of freedom
	Multiple R-squared:  0.5752,	Adjusted R-squared:  0.5637 
	F-statistic:  50.1 on 5 and 185 DF,  p-value: < 2.2e-16

med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + PK + PCTUPDATE + PK:PCTUPDATE, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + PK + PCTUPDATE + 
	    PK:PCTUPDATE, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.31663 -0.12358 -0.01232  0.10523  0.57906 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.45457    0.03267  13.912  < 2e-16 ***
	NUMPROCESSORS -0.03396    0.03334  -1.019    0.310    
	ACTROWPOOL     0.01147    0.03469   0.331    0.741    
	PK            -0.28411    0.03721  -7.635 1.17e-12 ***
	PCTUPDATE     -0.59302    0.04696 -12.629  < 2e-16 ***
	PK:PCTUPDATE   0.37617    0.07136   5.271 3.75e-07 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1826 on 185 degrees of freedom
	Multiple R-squared:  0.5333,	Adjusted R-squared:  0.5207 
	F-statistic: 42.28 on 5 and 185 DF,  p-value: < 2.2e-16
