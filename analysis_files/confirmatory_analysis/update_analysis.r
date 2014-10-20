# Overall: 33.4% (close to suboptimal)
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
x <- subset(x, x$NUMPROCESSORS>=2)
x <- subset(x, x$PK == 1)
# ATP normalization
# db2
db2 <- subset(x, x$DBMS=='db2')
db2$ATP = (db2$ATP-min(db2$ATP))/(max(db2$ATP)-min(db2$ATP))
db2$MAXMPL = (db2$MAXMPL-min(db2$MAXMPL))/(max(db2$MAXMPL)-min(db2$MAXMPL))
x = rbind(db2) 
# oracle
oracle <- subset(x, x$DBMS=='oracle')
oracle$ATP = (oracle$ATP-min(oracle$ATP))/(max(oracle$ATP)-min(oracle$ATP))
oracle$MAXMPL = (oracle$MAXMPL-min(oracle$MAXMPL))/(max(oracle$MAXMPL)-min(oracle$MAXMPL))
x = rbind(oracle) 
# mysql
mysql <- subset(x, x$DBMS=='mysql')
mysql$ATP = (mysql$ATP-min(mysql$ATP))/(max(mysql$ATP)-min(mysql$ATP))
mysql$MAXMPL = (mysql$MAXMPL-min(mysql$MAXMPL))/(max(mysql$MAXMPL)-min(mysql$MAXMPL))
x = rbind(mysql) 
# pgsql
pgsql <- subset(x, x$DBMS=='pgsql')
pgsql$ATP = (pgsql$ATP-min(pgsql$ATP))/(max(pgsql$ATP)-min(pgsql$ATP))
pgsql$MAXMPL = (pgsql$MAXMPL-min(pgsql$MAXMPL))/(max(pgsql$MAXMPL)-min(pgsql$MAXMPL))
x = rbind(pgsql) 
# sqlserver
sqlserver <- subset(x, x$DBMS=='sqlserver')
sqlserver$ATP = (sqlserver$ATP-min(sqlserver$ATP))/(max(sqlserver$ATP)-min(sqlserver$ATP))
sqlserver$MAXMPL = (sqlserver$MAXMPL-min(sqlserver$MAXMPL))/(max(sqlserver$MAXMPL)-min(sqlserver$MAXMPL))
x = rbind(sqlserver) 
x$ACTROWPOOL = (x$ACTROWPOOL-min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)-min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD-min(x$PCTREAD))/(max(x$PCTREAD)-min(x$PCTREAD))
x$PCTUPDATE = (x$PCTUPDATE-min(x$PCTUPDATE))/(max(x$PCTUPDATE)-min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS-min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)-min(x$NUMPROCESSORS))

med.fit <- lm(ATP ~ NUMPROCESSORS+PCTUPDATE, data = x)
summary(med.fit)

db2:
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PCTUPDATE, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.23606 -0.17884 -0.08253  0.04129  0.77253 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.25148    0.05828   4.315 5.55e-05 ***
	NUMPROCESSORS -0.07202    0.07689  -0.937  0.35237    
	PCTUPDATE     -0.28924    0.08730  -3.313  0.00151 ** 
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2613 on 65 degrees of freedom
	Multiple R-squared:  0.1597,	Adjusted R-squared:  0.1339 
	F-statistic: 6.179 on 2 and 65 DF,  p-value: 0.003495

oracle:
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PCTUPDATE, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.26188 -0.07778 -0.02806  0.06140  0.69946 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.07871    0.03188   2.469   0.0159 *  
	NUMPROCESSORS  0.06049    0.04031   1.501   0.1378    
	PCTUPDATE      0.20166    0.04698   4.293  5.5e-05 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1511 on 71 degrees of freedom
	Multiple R-squared:  0.2206,	Adjusted R-squared:  0.1986 
	F-statistic: 10.05 on 2 and 71 DF,  p-value: 0.0001437
mysql:
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PCTUPDATE, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.50830 -0.12293 -0.07171  0.19845  0.52968 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)   0.071692   0.067238   1.066    0.290    
	NUMPROCESSORS 0.006968   0.081034   0.086    0.932    
	PCTUPDATE     0.504774   0.091756   5.501 6.38e-07 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2835 on 67 degrees of freedom
	Multiple R-squared:  0.3127,	Adjusted R-squared:  0.2922 
	F-statistic: 15.24 on 2 and 67 DF,  p-value: 3.503e-06

pgsql:
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PCTUPDATE, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.30811 -0.18267 -0.00843  0.12296  0.67918 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.32082    0.06521   4.920 8.23e-06 ***
	NUMPROCESSORS -0.03645    0.08085  -0.451    0.654    
	PCTUPDATE     -0.40604    0.08704  -4.665 2.02e-05 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2444 on 55 degrees of freedom
	Multiple R-squared:  0.284,	Adjusted R-squared:  0.258 
	F-statistic: 10.91 on 2 and 55 DF,  p-value: 0.0001022

sqlserver:
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PCTUPDATE, data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.25056 -0.08152 -0.01788  0.08085  0.61017 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.39994    0.03904  10.243 9.06e-16 ***
	NUMPROCESSORS -0.28291    0.04863  -5.818 1.47e-07 ***
	PCTUPDATE     -0.04045    0.05323  -0.760     0.45    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1725 on 73 degrees of freedom
	Multiple R-squared:  0.3168,	Adjusted R-squared:  0.2981 
	F-statistic: 16.93 on 2 and 73 DF,  p-value: 9.132e-07	
