# mysql
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
mysql <- subset(x, x$DBMS=='mysql')
mysql$ATP = (mysql$ATP-min(mysql$ATP))/(max(mysql$ATP)-min(mysql$ATP))
mysql$MAXMPL = (mysql$MAXMPL-min(mysql$MAXMPL))/(max(mysql$MAXMPL)-min(mysql$MAXMPL))
x = rbind(mysql) 
x$ACTROWPOOL = (x$ACTROWPOOL-min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)-min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD-min(x$PCTREAD))/(max(x$PCTREAD)-min(x$PCTREAD))
x$PCTUPDATE = (x$PCTUPDATE-min(x$PCTUPDATE))/(max(x$PCTUPDATE)-min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS-min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)-min(x$NUMPROCESSORS))

med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + PK + PCTREAD + PCTREAD:PK + PCTUPDATE + PCTUPDATE:PK, data = x)
med.reduced <- step(med.fit, direction="backward")
summary(med.reduced)

	Call:
	lm(formula = ATP ~ ACTROWPOOL + PK + PCTREAD + PCTUPDATE + PK:PCTREAD + PK:PCTUPDATE, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.27877 -0.07094 -0.00847  0.06433  0.38202 

	Coefficients:
		     Estimate Std. Error t value Pr(>|t|)    
	(Intercept)   0.47236    0.02207  21.399  < 2e-16 ***
	ACTROWPOOL    0.13456    0.02254   5.971 1.11e-08 ***
	PK           -0.48162    0.02845 -16.929  < 2e-16 ***
	PCTREAD       0.18397    0.04332   4.247 3.36e-05 ***
	PCTUPDATE    -0.15026    0.03337  -4.502 1.16e-05 ***
	PK:PCTREAD   -0.20139    0.06718  -2.998  0.00308 ** 
	PK:PCTUPDATE  0.43586    0.04879   8.933 3.20e-16 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1188 on 194 degrees of freedom
	Multiple R-squared:  0.7451,	Adjusted R-squared:  0.7372 
	F-statistic:  94.5 on 6 and 194 DF,  p-value: < 2.2e-16

med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + PK + PCTUPDATE + PK:PCTUPDATE, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + ACTROWPOOL + PK + PCTUPDATE + 
	    PK:PCTUPDATE, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.27827 -0.07607 -0.01200  0.06532  0.38981 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.52202    0.02301  22.690  < 2e-16 ***
	NUMPROCESSORS -0.02438    0.02252  -1.083     0.28    
	ACTROWPOOL     0.13748    0.02338   5.880 1.76e-08 ***
	PK            -0.52573    0.02564 -20.501  < 2e-16 ***
	PCTUPDATE     -0.20564    0.03202  -6.422 1.00e-09 ***
	PK:PCTUPDATE   0.49468    0.04677  10.577  < 2e-16 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1236 on 195 degrees of freedom
	Multiple R-squared:  0.7229,	Adjusted R-squared:  0.7158 
	F-statistic: 101.7 on 5 and 195 DF,  p-value: < 2.2e-16
