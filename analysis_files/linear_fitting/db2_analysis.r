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


med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + PK + PCTREAD + PCTREAD:PK + PCTUPDATE + PCTUPDATE:PK, data = x)
med.reduced <- step(med.fit, direction="backward")
summary(med.reduced)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTUPDATE + PK:PCTREAD + PK:PCTUPDATE, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.24716 -0.07104 -0.03192  0.02483  0.82579 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)   
	(Intercept)    0.04770    0.03357   1.421  0.15706   
	NUMPROCESSORS  0.07256    0.03192   2.273  0.02413 * 
	PK             0.12921    0.04294   3.009  0.00298 **
	PCTREAD       -0.07688    0.06032  -1.274  0.20405   
	PCTUPDATE     -0.10356    0.05418  -1.912  0.05743 . 
	PK:PCTREAD    -0.15415    0.08944  -1.723  0.08644 . 
	PK:PCTUPDATE  -0.17972    0.07664  -2.345  0.02005 * 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1797 on 190 degrees of freedom
	Multiple R-squared:  0.1818,	Adjusted R-squared:  0.156 
	F-statistic: 7.038 on 6 and 190 DF,  p-value: 8.86e-07

med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + PK + PCTUPDATE + PK:PCTUPDATE, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + PK + PCTUPDATE + 
	    PK:PCTUPDATE, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.21572 -0.07459 -0.02958  0.00993  0.82692 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)   
	(Intercept)    0.004636   0.033896   0.137   0.8914   
	NUMPROCESSORS  0.067216   0.032791   2.050   0.0417 * 
	ACTROWPOOL     0.046506   0.035277   1.318   0.1890   
	PK             0.097364   0.037000   2.631   0.0092 **
	PCTUPDATE     -0.073238   0.049929  -1.467   0.1441   
	PK:PCTUPDATE  -0.135651   0.071663  -1.893   0.0599 . 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1848 on 191 degrees of freedom
	Multiple R-squared:   0.13,	Adjusted R-squared:  0.1073 
	F-statistic:  5.71 on 5 and 191 DF,  p-value: 6.197e-05


