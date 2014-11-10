# Overall: 33.4% (close to suboptimal)
library(aod)
library(ggplot2)
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
x$MAXMPL[x$MAXMPL == 1100] <- 10000
# ATP normalization
# db2
db2 <- subset(x, x$DBMS=='db2')
db2_r <- subset(db2, db2$PCTREAD!=0)
db2_r <- subset(db2_r, select = -PCTUPDATE)
db2_r$ATP = (db2_r$ATP-min(db2_r$ATP))/(max(db2_r$ATP)-min(db2_r$ATP))
db2_r$MAXMPL = (db2_r$MAXMPL-min(db2_r$MAXMPL))/(max(db2_r$MAXMPL)-min(db2_r$MAXMPL))
db2 <- db2_r
x = rbind(db2)
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD/min(x$PCTREAD))/(max(x$PCTREAD)/min(x$PCTREAD))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
> nrow(x)
[1] 85

x <- subset(x, x$MAXMPL < 1)
[1] 39

cor.test(x$NUMPROCESSORS, x$ATP)

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = 2.1242, df = 83, p-value = 0.03663
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.01465556 0.41987498
	sample estimates:
	      cor 
	0.2270704

	### thrashing samples
	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = 3.2233, df = 37, p-value = 0.002646
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.1791896 0.6828671
	sample estimates:
	      cor 
	0.4682339

cor.test(x$PCTREAD, x$ATP)

	Pearson's product-moment correlation

	data:  x$PCTREAD and x$ATP
	t = -3.231, df = 83, p-value = 0.001769
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.5109764 -0.1304196
	sample estimates:
	      cor 
	-0.334253 

	Pearson's product-moment correlation

	data:  x$PCTREAD and x$ATP
	t = -1.3402, df = 37, p-value = 0.1884
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.4969434  0.1076634
	sample estimates:
	       cor 
	-0.2151626 

cor.test(x$PK, x$ATP)

	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = 1.6332, df = 83, p-value = 0.1062
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.03810182  0.37545940
	sample estimates:
	      cor 
	0.1764552

	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = 0.0288, df = 37, p-value = 0.9772
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.3112426  0.3197787
	sample estimates:
		cor 
	0.004739889

cor.test(x$PCTREAD*x$PK, x$ATP)

	Pearson's product-moment correlation

	data:  x$PCTREAD * x$PK and x$ATP
	t = -1.9598, df = 83, p-value = 0.05337
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.405268777  0.002946476
	sample estimates:
	       cor 
	-0.2103097

	Pearson's product-moment correlation

	data:  x$PCTREAD * x$PK and x$ATP
	t = -0.8735, df = 37, p-value = 0.388
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.4380190  0.1815108
	sample estimates:
	      cor 
	-0.142147

med.fit <- lm(ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.36670 -0.16190 -0.05855  0.06231  0.74316 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)  
	(Intercept)    0.02478    0.06589   0.376   0.7079  
	NUMPROCESSORS  0.18125    0.07954   2.279   0.0254 *
	PK             0.16361    0.07306   2.240   0.0279 *
	PCTREAD       -0.11346    0.09292  -1.221   0.2257  
	PK:PCTREAD    -0.18073    0.12650  -1.429   0.1570  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.2584 on 80 degrees of freedom
	Multiple R-squared:  0.2122,	Adjusted R-squared:  0.1728 
	F-statistic: 5.388 on 4 and 80 DF,  p-value: 0.0006808

		### modified
		med.fit <- lm(ATP ~ NUMPROCESSORS + PK, data = x)
		summary(med.fit)

		Call:
		lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

		Residuals:
		     Min       1Q   Median       3Q      Max 
		-0.26218 -0.12912 -0.08812 -0.00518  0.84719 

		Coefficients:
			      Estimate Std. Error t value Pr(>|t|)  
		(Intercept)   -0.01715    0.05953  -0.288   0.7740  
		NUMPROCESSORS  0.18059    0.08481   2.129   0.0362 *
		PK             0.09874    0.05998   1.646   0.1036  
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.2755 on 82 degrees of freedom
		Multiple R-squared:  0.0819,	Adjusted R-squared:  0.05951 
		F-statistic: 3.657 on 2 and 82 DF,  p-value: 0.03009

	### thrashing samples
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.09035 -0.04239 -0.00728  0.01799  0.35294 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)   
	(Intercept)   -0.006578   0.024860  -0.265  0.79290   
	NUMPROCESSORS  0.115463   0.036072   3.201  0.00297 **
	PK             0.005101   0.031777   0.161  0.87341   
	PCTREAD       -0.032841   0.040661  -0.808  0.42489   
	PK:PCTREAD    -0.013972   0.055060  -0.254  0.80121   
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.074 on 34 degrees of freedom
	Multiple R-squared:  0.2693,	Adjusted R-squared:  0.1833 
	F-statistic: 3.132 on 4 and 34 DF,  p-value: 0.02694

		### modified
		Call:
		lm(formula = ATP ~ NUMPROCESSORS + PK, data = x)

		Residuals:
		     Min       1Q   Median       3Q      Max 
		-0.08973 -0.03253  0.00221  0.00912  0.36230 

		Coefficients:
			       Estimate Std. Error t value Pr(>|t|)   
		(Intercept)   -0.016429   0.021586  -0.761   0.4516   
		NUMPROCESSORS  0.115630   0.036180   3.196   0.0029 **
		PK            -0.006879   0.023908  -0.288   0.7752   
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.07425 on 36 degrees of freedom
		Multiple R-squared:  0.221,	Adjusted R-squared:  0.1778 
		F-statistic: 5.108 on 2 and 36 DF,  p-value: 0.01115

cor.test(x$PK, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 0.9309, df = 83, p-value = 0.3546
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1139438  0.3080982
	sample estimates:
	      cor 
	0.1016487 

	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 0.6104, df = 37, p-value = 0.5454
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2226918  0.4026727
	sample estimates:
	       cor 
	0.09984038


cor.test(x$ATP, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = 2.9439, df = 83, p-value = 0.004203
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.1009718 0.4885855
	sample estimates:
	      cor 
	0.3074791

	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = 1.1922, df = 37, p-value = 0.2408
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1311370  0.4787989
	sample estimates:
	      cor 
	0.1923382

cor.test(x$NUMPROCESSORS, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = 1.5851, df = 83, p-value = 0.1167
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.04329263  0.37098423
	sample estimates:
	     cor 
	0.171413

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = 4.533, df = 37, p-value = 5.908e-05
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.3475574 0.7682258
	sample estimates:
	      cor 
	0.5975473

cor.test(x$ACTROWPOOL, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$ACTROWPOOL and x$MAXMPL
	t = -1.2361, df = 83, p-value = 0.2199
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.33788782  0.08099959
	sample estimates:
	       cor 
	-0.1344454

	Pearson's product-moment correlation

	data:  x$ACTROWPOOL and x$MAXMPL
	t = -1.1202, df = 37, p-value = 0.2698
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.4697856  0.1425487
	sample estimates:
	       cor 
	-0.1811142

cor.test(x$PCTREAD, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$PCTREAD and x$MAXMPL
	t = -0.2305, df = 83, p-value = 0.8183
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2371346  0.1888534
	sample estimates:
		cor 
	-0.02528856 

	Pearson's product-moment correlation

	data:  x$PCTREAD and x$MAXMPL
	t = -0.5796, df = 37, p-value = 0.5657
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.3984491  0.2274677
	sample estimates:
		cor 
	-0.09485728 

out.fit <- lm(MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.75654 -0.41747  0.05666  0.42601  0.72706 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.56091    0.15524   3.613  0.00053 ***
	PK             0.04864    0.10295   0.472  0.63794    
	PCTREAD        0.09116    0.12093   0.754  0.45319    
	ACTROWPOOL    -0.32246    0.18338  -1.758  0.08256 .  
	ATP            0.56963    0.20075   2.838  0.00578 ** 
	NUMPROCESSORS  0.13388    0.14744   0.908  0.36663    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.4646 on 79 degrees of freedom
	Multiple R-squared:  0.1466,	Adjusted R-squared:  0.09255 
	F-statistic: 2.713 on 5 and 79 DF,  p-value: 0.0258

		### modified
		out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
		summary(out.fit)

		Call:
		lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

		Residuals:
		     Min       1Q   Median       3Q      Max 
		-0.72337 -0.43190  0.00867  0.47602  0.58332 

		Coefficients:
			      Estimate Std. Error t value Pr(>|t|)    
		(Intercept)    0.39786    0.10138   3.925 0.000181 ***
		PK             0.05087    0.10377   0.490 0.625314    
		ATP            0.46953    0.18797   2.498 0.014520 *  
		NUMPROCESSORS  0.14964    0.14830   1.009 0.315987    
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.469 on 81 degrees of freedom
		Multiple R-squared:  0.1081,	Adjusted R-squared:  0.07504 
		F-statistic: 3.271 on 3 and 81 DF,  p-value: 0.02532

	#### thrashing samples
	Call:
	lm(formula = MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, 
	    data = x)

	Residuals:
	      Min        1Q    Median        3Q       Max 
	-0.029244 -0.013517  0.002210  0.008427  0.041826 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.020136   0.008766   2.297 0.028091 *  
	PK             0.002979   0.005562   0.536 0.595888    
	PCTREAD       -0.006374   0.006465  -0.986 0.331317    
	ACTROWPOOL    -0.010760   0.010724  -1.003 0.323018    
	ATP           -0.040631   0.039257  -1.035 0.308194    
	NUMPROCESSORS  0.040017   0.009400   4.257 0.000161 ***
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.0169 on 33 degrees of freedom
	Multiple R-squared:  0.4057,	Adjusted R-squared:  0.3156 
	F-statistic: 4.505 on 5 and 33 DF,  p-value: 0.003068

		### modified
		out.fit <- lm(MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)
		summary(out.fit)

		Call:
		lm(formula = MAXMPL ~ PK + ATP + NUMPROCESSORS, data = x)

		Residuals:
		      Min        1Q    Median        3Q       Max 
		-0.030282 -0.016163 -0.001006  0.009695  0.043618 

		Coefficients:
			       Estimate Std. Error t value Pr(>|t|)    
		(Intercept)    0.011245   0.004958   2.268 0.029614 *  
		PK             0.001443   0.005454   0.265 0.792859    
		ATP           -0.027462   0.037979  -0.723 0.474429    
		NUMPROCESSORS  0.039409   0.009341   4.219 0.000165 ***
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.01692 on 35 degrees of freedom
		Multiple R-squared:  0.3681,	Adjusted R-squared:  0.314 
		F-statistic: 6.797 on 3 and 35 DF,  p-value: 0.0009911


######## update-only
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
x$MAXMPL[x$MAXMPL == 1100] <- 10000
# ATP normalization
# db2
db2 <- subset(x, x$DBMS=='db2')
db2_w <- subset(db2, db2$PCTUPDATE!=0)
db2_w <- subset(db2_w, select = -PCTREAD)
db2_w$ATP = (db2_w$ATP-min(db2_w$ATP))/(max(db2_w$ATP)-min(db2_w$ATP))
db2_w$MAXMPL = (db2_w$MAXMPL-min(db2_w$MAXMPL))/(max(db2_w$MAXMPL)-min(db2_w$MAXMPL))
db2 <- db2_w
x = rbind(db2)
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTUPDATE = (x$PCTUPDATE/min(x$PCTUPDATE))/(max(x$PCTUPDATE)/min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
nrow(x)
[1] 117
x <- subset(x, x$MAXMPL < 1)
nrow(x)
[1] 14

cor.test(x$NUMPROCESSORS, x$ATP)

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -3.5592, df = 115, p-value = 0.0005419
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.4696748 -0.1415610
	sample estimates:
	       cor 
	-0.3149991 

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$ATP
	t = -1.7456, df = 12, p-value = 0.1064
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.7915853  0.1058417
	sample estimates:
	       cor 
	-0.4500092 

cor.test(x$PCTUPDATE, x$ATP)

	Pearson's product-moment correlation

	data:  x$PCTUPDATE and x$ATP
	t = 0.1858, df = 115, p-value = 0.853
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1647312  0.1982295
	sample estimates:
	       cor 
	0.01731975

	Pearson's product-moment correlation

	data:  x$PCTUPDATE and x$ATP
	t = 0.8016, df = 12, p-value = 0.4384
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.3466041  0.6752461
	sample estimates:
	      cor 
	0.2254327 


cor.test(x$PK, x$ATP)
	
	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = 2.452, df = 115, p-value = 0.01571
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.04311284 0.38870571
	sample estimates:
	      cor 
	0.2229013 

	Pearson's product-moment correlation

	data:  x$PK and x$ATP
	t = -1.5521, df = 12, p-value = 0.1466
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.7719832  0.1554154
	sample estimates:
	       cor 
	-0.4088805 

cor.test(x$PCTUPDATE*x$PK, x$ATP)

	Pearson's product-moment correlation

	data:  x$PCTUPDATE * x$PK and x$ATP
	t = 2.1494, df = 115, p-value = 0.0337
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.0155466 0.3650350
	sample estimates:
	      cor 
	0.1965249

	Pearson's product-moment correlation

	data:  x$PCTUPDATE * x$PK and x$ATP
	t = -1.1058, df = 12, p-value = 0.2905
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.7187190  0.2700451
	sample estimates:
	      cor 
	-0.304107 

med.fit <- lm(ATP ~ NUMPROCESSORS + PK + PCTUPDATE + PCTUPDATE:PK, data = x)
summary(med.fit)

	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK + PCTUPDATE + PCTUPDATE:PK, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.26476 -0.09361 -0.01719  0.09379  0.66156 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.29114    0.05629   5.172 1.02e-06 ***
	NUMPROCESSORS -0.16886    0.04525  -3.732   0.0003 ***
	PK             0.07479    0.07585   0.986   0.3263    
	PCTUPDATE      0.01388    0.07777   0.178   0.8587    
	PK:PCTUPDATE   0.01558    0.11318   0.138   0.8908    
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.1688 on 112 degrees of freedom
	Multiple R-squared:  0.1551,	Adjusted R-squared:  0.1249 
	F-statistic:  5.14 on 4 and 112 DF,  p-value: 0.0007713
	
		#### modified
		med.fit <- lm(ATP ~ NUMPROCESSORS, data = x)
		summary(med.fit)

		Call:
		lm(formula = ATP ~ NUMPROCESSORS, data = x)

		Residuals:
		     Min       1Q   Median       3Q      Max 
		-0.25489 -0.12871  0.01573  0.07138  0.70416 

		Coefficients:
			      Estimate Std. Error t value Pr(>|t|)    
		(Intercept)    0.33678    0.02732  12.326  < 2e-16 ***
		NUMPROCESSORS -0.16378    0.04602  -3.559 0.000542 ***
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.172 on 115 degrees of freedom
		Multiple R-squared:  0.09922,	Adjusted R-squared:  0.09139 
		F-statistic: 12.67 on 1 and 115 DF,  p-value: 0.0005419

	#### thrashing samples
	Call:
	lm(formula = ATP ~ NUMPROCESSORS + PK + PCTUPDATE + PCTUPDATE:PK, 
	    data = x)

	Residuals:
	      Min        1Q    Median        3Q       Max 
	-0.245106 -0.139110  0.000358  0.102017  0.280270 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)  
	(Intercept)    0.57046    0.23295   2.449   0.0368 *
	NUMPROCESSORS -1.10862    0.51910  -2.136   0.0615 .
	PK            -0.32948    0.26427  -1.247   0.2440  
	PCTUPDATE      0.01632    0.26611   0.061   0.9524  
	PK:PCTUPDATE   0.94690    0.60596   1.563   0.1526  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.198 on 9 degrees of freedom
	Multiple R-squared:  0.4482,	Adjusted R-squared:  0.203 
	F-statistic: 1.828 on 4 and 9 DF,  p-value: 0.2078

cor.test(x$PK, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 0.3358, df = 115, p-value = 0.7376
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1510899  0.2116320
	sample estimates:
	      cor 
	0.0313016

	Pearson's product-moment correlation

	data:  x$PK and x$MAXMPL
	t = 0.3248, df = 12, p-value = 0.7509
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.4600122  0.5944862
	sample estimates:
	       cor 
	0.09335201 

cor.test(x$ATP, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -0.5552, df = 115, p-value = 0.5798
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2310669  0.1310604
	sample estimates:
		cor 
	-0.05170266 

	Pearson's product-moment correlation

	data:  x$ATP and x$MAXMPL
	t = -1.4697, df = 12, p-value = 0.1674
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.7630249  0.1766155
	sample estimates:
	       cor 
	-0.3905631

cor.test(x$NUMPROCESSORS, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = 2.2176, df = 115, p-value = 0.02855
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 0.02177562 0.37042358
	sample estimates:
	      cor 
	0.2025081

	Pearson's product-moment correlation

	data:  x$NUMPROCESSORS and x$MAXMPL
	t = 1.4393, df = 12, p-value = 0.1756
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1844460  0.7596222
	sample estimates:
	      cor 
	0.3836818 

cor.test(x$ACTROWPOOL, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$ACTROWPOOL and x$MAXMPL
	t = -0.8634, df = 115, p-value = 0.3897
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.2580305  0.1027735
	sample estimates:
		cor 
	-0.08025684 

	Pearson's product-moment correlation

	data:  x$ACTROWPOOL and x$MAXMPL
	t = -1.9718, df = 12, p-value = 0.07213
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.81210883  0.04867243
	sample estimates:
	      cor 
	-0.494682 

cor.test(x$PCTUPDATE, x$MAXMPL)

	Pearson's product-moment correlation

	data:  x$PCTUPDATE and x$MAXMPL
	t = 0.3268, df = 115, p-value = 0.7444
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.1519124  0.2108277
	sample estimates:
	       cor 
	0.03046054 

	Pearson's product-moment correlation

	data:  x$PCTUPDATE and x$MAXMPL
	t = 0.6105, df = 12, p-value = 0.5529
	alternative hypothesis: true correlation is not equal to 0
	95 percent confidence interval:
	 -0.3932213  0.6447716
	sample estimates:
	      cor 
	0.1735712 

out.fit <- lm(MAXMPL ~ PK + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	Call:
	lm(formula = MAXMPL ~ PK + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, 
	    data = x)

	Residuals:
	     Min       1Q   Median       3Q      Max 
	-0.91981  0.01916  0.11422  0.16065  0.21246 

	Coefficients:
		      Estimate Std. Error t value Pr(>|t|)    
	(Intercept)    0.82229    0.11173   7.360 3.42e-11 ***
	PK             0.01093    0.05965   0.183   0.8549    
	PCTUPDATE      0.02127    0.10438   0.204   0.8389    
	ACTROWPOOL    -0.09516    0.10472  -0.909   0.3655    
	ATP            0.04863    0.17895   0.272   0.7863    
	NUMPROCESSORS  0.18929    0.08874   2.133   0.0351 *  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.3112 on 111 degrees of freedom
	Multiple R-squared:  0.0492,	Adjusted R-squared:  0.006376 
	F-statistic: 1.149 on 5 and 111 DF,  p-value: 0.3391

		#### modified
		out.fit <- lm(MAXMPL ~ ATP + NUMPROCESSORS, data = x)
		summary(out.fit)

		Call:
		lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

		Residuals:
		     Min       1Q   Median       3Q      Max 
		-0.91851  0.01884  0.11718  0.16087  0.18168 

		Coefficients:
			      Estimate Std. Error t value Pr(>|t|)    
		(Intercept)    0.78958    0.07466  10.576   <2e-16 ***
		ATP            0.02322    0.16724   0.139   0.8898    
		NUMPROCESSORS  0.18604    0.08696   2.139   0.0345 *  
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.3084 on 114 degrees of freedom
		Multiple R-squared:  0.04117,	Adjusted R-squared:  0.02435 
		F-statistic: 2.448 on 2 and 114 DF,  p-value: 0.09104

		#### modified 2
		out.fit <- lm(MAXMPL ~ NUMPROCESSORS, data = x)
		summary(out.fit)
	
		Call:
		lm(formula = MAXMPL ~ NUMPROCESSORS, data = x)

		Residuals:
		     Min       1Q   Median       3Q      Max 
		-0.91841  0.02037  0.11148  0.15704  0.17982 

		Coefficients:
			      Estimate Std. Error t value Pr(>|t|)    
		(Intercept)    0.79740    0.04879  16.342   <2e-16 ***
		NUMPROCESSORS  0.18223    0.08218   2.218   0.0285 *  
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.3071 on 115 degrees of freedom
		Multiple R-squared:  0.04101,	Adjusted R-squared:  0.03267 
		F-statistic: 4.918 on 1 and 115 DF,  p-value: 0.02855

	### thrashing samples
	Call:
	lm(formula = MAXMPL ~ PK + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, 
	    data = x)

	Residuals:
	      Min        1Q    Median        3Q       Max 
	-0.028750 -0.009050  0.002367  0.009169  0.023873 

	Coefficients:
		       Estimate Std. Error t value Pr(>|t|)  
	(Intercept)    0.056494   0.020853   2.709   0.0267 *
	PK            -0.007799   0.015886  -0.491   0.6367  
	PCTUPDATE      0.005026   0.023111   0.217   0.8333  
	ACTROWPOOL    -0.030322   0.022208  -1.365   0.2093  
	ATP           -0.007313   0.032440  -0.225   0.8273  
	NUMPROCESSORS  0.029845   0.035397   0.843   0.4236  
	---
	Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

	Residual standard error: 0.01858 on 8 degrees of freedom
	Multiple R-squared:  0.3932,	Adjusted R-squared:  0.01392 
	F-statistic: 1.037 on 5 and 8 DF,  p-value: 0.4577

		#### modified
		out.fit <- lm(MAXMPL ~ ATP + NUMPROCESSORS, data = x)
		summary(out.fit)

		Call:
		lm(formula = MAXMPL ~ ATP + NUMPROCESSORS, data = x)

		Residuals:
		      Min        1Q    Median        3Q       Max 
		-0.031617 -0.009953  0.004076  0.009946  0.022584 

		Coefficients:
			      Estimate Std. Error t value Pr(>|t|)   
		(Intercept)    0.04230    0.01333   3.173  0.00887 **
		ATP           -0.02305    0.02537  -0.909  0.38302   
		NUMPROCESSORS  0.02192    0.02528   0.867  0.40444   
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.01812 on 11 degrees of freedom
		Multiple R-squared:  0.2068,	Adjusted R-squared:  0.06252 
		F-statistic: 1.434 on 2 and 11 DF,  p-value: 0.2797

		#### modified 2
		out.fit <- lm(MAXMPL ~ NUMPROCESSORS, data = x)
		summary(out.fit)

		Call:
		lm(formula = MAXMPL ~ NUMPROCESSORS, data = x)

		Residuals:
		      Min        1Q    Median        3Q       Max 
		-0.036802 -0.008617  0.003068  0.010186  0.020390 

		Coefficients:
			      Estimate Std. Error t value Pr(>|t|)   
		(Intercept)   0.032770   0.008168   4.012  0.00172 **
		NUMPROCESSORS 0.032257   0.022412   1.439  0.17565   
		---
		Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

		Residual standard error: 0.01799 on 12 degrees of freedom
		Multiple R-squared:  0.1472,	Adjusted R-squared:  0.07615 
		F-statistic: 2.071 on 1 and 12 DF,  p-value: 0.1756
