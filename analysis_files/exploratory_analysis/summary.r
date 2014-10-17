
med.fit <- lm(ATP ~ NUMPROCESSORS + PCTUPDATE  + PK + PK:PCTUPDATE, data = x)
summary(med.fit)

out.fit <- lm(MAXMPL ~ NUMPROCESSORS + ATP + PCTREAD + PCTUPDATE + ACTROWPOOL + PK, data = x)
summary(out.fit)

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS", robustSE = TRUE)
summary(med.out)

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PK", robustSE = TRUE)
summary(med.out)

sens.out <- medsens(med.out, effect.type = "both")
summary(sens.out)

> sens.out$r.square.y
[1] 0.03378934
> sens.out$r.square.m
[1] 0.1047084

db2:
	> sens.out$r.square.y
	[1] 0.2177873
	> sens.out$r.square.m
	[1] 0.1221305
oracle:
	> sens.out$r.square.y
	[1] 0.2376887
	> sens.out$r.square.m
	[1] 0.415412
mysql:
	> sens.out$r.square.y
	[1] 0.443036
	> sens.out$r.square.m
	[1] 0.6737662
pgsql:
	> sens.out$r.square.y
	[1] 0.4985336
	> sens.out$r.square.m
	[1] 0.5330371
sqlserver:
	> sens.out$r.square.y
	[1] 0.2717694
	> sens.out$r.square.m
	[1] 0.3307554
