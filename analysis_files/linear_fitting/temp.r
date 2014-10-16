






out.fit <- lm(MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + PCTREAD, data = x)

out.fit <- lm(MAXMPL ~ ATP, data = x)

Call:
lm(formula = MAXMPL ~ ATP, data = x)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.65380 -0.35366  0.04629  0.34638  0.46304 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  0.65380    0.01423  45.939   <2e-16 ***
ATP         -0.11684    0.04628  -2.525   0.0117 *  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.3848 on 1002 degrees of freedom
Multiple R-squared:  0.006322,	Adjusted R-squared:  0.00533 
F-statistic: 6.375 on 1 and 1002 DF,  p-value: 0.01173





























min.fit <- lm(ATP ~ 1, data = x)
fwd.model <- step(min.fit, direction="forward", scope=( ~ NUMPROCESSORS + ACTROWPOOL + PK + PCTREAD + PCTUPDATE))
summary(fwd.model)

	Start:  AIC=-2684.5
	ATP ~ 1

		        Df Sum of Sq    RSS     AIC
	+ PK             1   2.84780 66.279 -2724.7
	+ PCTUPDATE      1   1.47154 67.656 -2704.1
	+ NUMPROCESSORS  1   1.04222 68.085 -2697.8
	+ PCTREAD        1   0.48806 68.639 -2689.6
	+ ACTROWPOOL     1   0.40593 68.721 -2688.4
	<none>                       69.127 -2684.5

	Step:  AIC=-2724.74
	ATP ~ PK

		        Df Sum of Sq    RSS     AIC
	+ PCTUPDATE      1   1.41673 64.863 -2744.4
	+ NUMPROCESSORS  1   0.94618 65.333 -2737.2
	+ PCTREAD        1   0.43766 65.842 -2729.4
	+ ACTROWPOOL     1   0.38123 65.898 -2728.5
	<none>                       66.279 -2724.7

	Step:  AIC=-2744.43
	ATP ~ PK + PCTUPDATE

		        Df Sum of Sq    RSS     AIC
	+ NUMPROCESSORS  1   0.96358 63.899 -2757.5
	+ ACTROWPOOL     1   0.37154 64.491 -2748.2
	<none>                       64.863 -2744.4
	+ PCTREAD        1   0.02889 64.834 -2742.9

	Step:  AIC=-2757.46
	ATP ~ PK + PCTUPDATE + NUMPROCESSORS

		     Df Sum of Sq    RSS     AIC
	+ ACTROWPOOL  1   0.36428 63.535 -2761.2
	<none>                    63.899 -2757.5
	+ PCTREAD     1   0.03870 63.860 -2756.1

	Step:  AIC=-2761.2
	ATP ~ PK + PCTUPDATE + NUMPROCESSORS + ACTROWPOOL

		  Df Sum of Sq    RSS     AIC
	<none>                 63.535 -2761.2
	+ PCTREAD  1  0.041197 63.494 -2759.8
> summary(fwd.model)

Call:
lm(formula = ATP ~ PK + PCTUPDATE + NUMPROCESSORS + ACTROWPOOL, 
    data = x)

Residuals:
     Min       1Q   Median       3Q      Max 
-0.30456 -0.16721 -0.09698  0.12727  0.86601 

Coefficients:
	      Estimate Std. Error t value Pr(>|t|)    
(Intercept)    0.25390    0.01908  13.308  < 2e-16 ***
PK            -0.10336    0.01594  -6.484 1.40e-10 ***
PCTUPDATE     -0.10073    0.02128  -4.733 2.54e-06 ***
NUMPROCESSORS -0.07862    0.02028  -3.878 0.000112 ***
ACTROWPOOL     0.05091    0.02127   2.393 0.016883 *  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.2522 on 999 degrees of freedom
Multiple R-squared:  0.0809,	Adjusted R-squared:  0.07722 
F-statistic: 21.98 on 4 and 999 DF,  p-value: < 2.2e-16

min.fit <- lm(ATP ~ (NUMPROCESSORS + ACTROWPOOL + PK + PCTREAD + PCTUPDATE)^5, data = x)
summary(min.fit)


med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + PK + PCTREAD + PCTREAD:PK + PCTUPDATE + PCTUPDATE:PK, data = x)
med.reduced <- step(med.fit, direction="backward")
summary(med.reduced)




library(mediation)
med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + PK + PCTREAD + PCTREAD:PK + PCTUPDATE + PCTUPDATE:PK, data = x)
summary(med.fit)










model.fit1 <- lm(ATP ~ NUMPROCESSORS + PK , data = x)
summary(model.fit1)

model.fit1 <- lm(ATP ~ NUMPROCESSORS + PK + PCTUPDATE + PCTUPDATE:PK, data = x)
summary(model.fit1)

model.fit1 <- lm(ATP ~ NUMPROCESSORS + PK + PCTUPDATE + PCTUPDATE:PK, data = x)
summary(model.fit1)
out.fit1   <- lm(MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + PCTREAD, data = x)



model.fit2 <- lm(MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE, data = x)
anova(model.fit1, model.fit2)
