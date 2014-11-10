
#### reads
h_ct <- subset(x, x$ACTROWPOOL <= 0.5)
l_ct <- subset(x, x$ACTROWPOOL > 0.5)




#### updates

h_ct <- subset(x, x$ACTROWPOOL <= 0.5)
l_ct <- subset(x, x$ACTROWPOOL > 0.5)

> h_ct <- subset(x, x$ACTROWPOOL <= 0.5)
> l_ct <- subset(x, x$ACTROWPOOL > 0.5)
> cor.test(h_ct$ACTROWPOOL, h_ct$MAXMPL)

	Pearson's product-moment correlation

data:  h_ct$ACTROWPOOL and h_ct$MAXMPL
t = -0.6028, df = 303, p-value = 0.5471
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.14634912  0.07800015
sample estimates:
        cor 
-0.03461051 

> cor.test(l_ct$ACTROWPOOL, l_ct$MAXMPL)

	Pearson's product-moment correlation

data:  l_ct$ACTROWPOOL and l_ct$MAXMPL
t = 0.2458, df = 301, p-value = 0.806
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.09866903  0.12664240
sample estimates:
       cor 
0.01416651 


