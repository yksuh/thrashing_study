> cor(x$NUMPROCESSORS, x$ATP)
[1] -0.122788
> cor(x$PCTREAD, x$ATP)
[1] 0.08402555
> cor(x$PCTUPDATE, x$ATP)
[1] -0.145902
> cor(x$PK, x$ATP)
[1] -0.2029692
> cor(x$ACTROWPOOL, x$ATP)
[1] 0.07663052

> cor(x$ATP, x$MAXMPL)
[1] -0.07951011
> cor(x$NUMPROCESSORS, x$MAXMPL)
[1] -0.02375046
> cor(x$PCTREAD, x$MAXMPL)
[1] -0.059297
> cor(x$PCTUPDATE, x$MAXMPL)
[1] 0.01913866
> cor(x$ACTROWPOOL, x$MAXMPL)
[1] -0.0620389
> cor(x$PK, x$MAXMPL)
[1] 0.1646099

med.fit <- lm(ATP ~ NUMPROCESSORS + PCTUPDATE  + PK + PK:PCTUPDATE, data = x)
summary(med.fit)

out.fit <- lm(MAXMPL ~ NUMPROCESSORS + ATP + PCTREAD + PCTUPDATE + ACTROWPOOL + PK, data = x)
summary(out.fit)

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS", robustSE = TRUE)
summary(med.out)

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK", robustSE = TRUE)
summary(med.out)

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE", robustSE = TRUE)
summary(med.out)

sens.out <- medsens(med.out, effect.type = "both")
summary(sens.out)

> sens.out$r.square.y
[1] 0.03378934
> sens.out$r.square.m
[1] 0.1047084

ATP
 - PK: db2, oracle (-), mysql (-), pgsql (-)
 - PCTUPDATE: oracle (-), mysql (-), pgsql (-), sqlserver
 - NUMPROCS: db2, oracle, sqlserver
 - PCTUPDATE:PK: oracle, mysql, pgsql 

MAXMPL
 - ATP: mysql (-), pgsql, sqlserver
 - PCTREAD: pgsql
 - NUMPROCS: db2, oracle (-), pgsql (-), sqlserver
 - ACTROWPOOL: db2
 - PCTUPDATE: db2, oracle (-), mysql, pgsql (-), sqlserver (-)
 - PK: mysql (-), pgsql


db2:
ATP:PK (0.098), NUMPROCESSORS  (0.067), 
MAXMPL: PCTUPDATE (0.23), NUMPROCESSORS (0.19), ACTROWPOOL (0.014) / NS: ATP (0.21-0.07482) 
	> sens.out$r.square.y
	[1] 0.2177873
	> sens.out$r.square.m
	[1] 0.1221305

oracle:
ATP: PCTUPDATE (-0.30), PCTUPDATE:PK (0.31), PK (-0.23), NUMPROCESSORS (0.06)
MAXMPL: NUMPROCESSORS (-0.46), PCTUPDATE (-0.26) / NS: ATP (-0.38-0.053348)
	> sens.out$r.square.y
	[1] 0.2376887
	> sens.out$r.square.m
	[1] 0.415412

mysql:
ATP:  PK (-0.53), PCTUPDATE (-0.21), PCTUPDATE:PK (0.50)
MAXMPL: ATP (-1.09), PCTUPDATE (0.48), PK(-0.30)
	> sens.out$r.square.y
	[1] 0.443036
	> sens.out$r.square.m
	[1] 0.6737662

pgsql:
ATP:  PCTUPDATE (-0.59), PK (-0.28), PCTUPDATE:PK (0.37)
MAXMPL: PK(0.56), NUMPROCESSORS (-0.22), ATP (0.27), PCTUPDATE (-0.23), PCTREAD(-0.16)
	> sens.out$r.square.y
	[1] 0.4985336
	> sens.out$r.square.m
	[1] 0.5330371

sqlserver:
ATP:  NUMPROCESSORS (-0.45), PCTUPDATE (0.15)
MAXMPL: NUMPROCESSORS (0.42), PCTUPDATE (-0.13), ATP (0.16)
	> sens.out$r.square.y
	[1] 0.2717694
	> sens.out$r.square.m
	[1] 0.3307554
