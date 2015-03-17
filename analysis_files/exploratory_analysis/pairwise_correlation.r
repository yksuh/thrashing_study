x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD/min(x$PCTREAD))/(max(x$PCTREAD)/min(x$PCTREAD))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
nrow(x)

x <- subset(x, x$MAXMPL < 1)
nrow(x)

cor.test(x$NUMPROCESSORS, x$ATP)

cor.test(x$PCTREAD, x$ATP)

cor.test(x$PK, x$ATP)

cor.test(x$PCTREAD*x$PK, x$ATP)

med.fit <- lm(ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK, data = x)
summary(med.fit)

cor.test(x$PK, x$MAXMPL)

cor.test(x$ATP, x$MAXMPL)

cor.test(x$NUMPROCESSORS, x$MAXMPL)

cor.test(x$ACTROWPOOL, x$MAXMPL)

cor.test(x$PCTREAD, x$MAXMPL)

out.fit <- lm(MAXMPL ~ PK + PCTREAD + ACTROWPOOL + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

######### update
x$ACTROWPOOL = (x$ACTROWPOOL/min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)/min(x$ACTROWPOOL))
x$PCTUPDATE = (x$PCTUPDATE/min(x$PCTUPDATE))/(max(x$PCTUPDATE)/min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS/min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)/min(x$NUMPROCESSORS))
nrow(x)

x <- subset(x, x$MAXMPL < 1)
nrow(x)

cor.test(x$NUMPROCESSORS, x$ATP)

cor.test(x$PCTUPDATE, x$ATP)

cor.test(x$PK, x$ATP)

cor.test(x$PCTUPDATE*x$PK, x$ATP)

med.fit <- lm(ATP ~ NUMPROCESSORS + PK + PCTUPDATE + PCTUPDATE:PK, data = x)
summary(med.fit)

	#### modified
	med.fit <- lm(ATP ~ NUMPROCESSORS + PK, data = x)
	summary(med.fit)

cor.test(x$PK, x$MAXMPL)

cor.test(x$ATP, x$MAXMPL)

cor.test(x$NUMPROCESSORS, x$MAXMPL)

cor.test(x$ACTROWPOOL, x$MAXMPL)

cor.test(x$PCTUPDATE, x$MAXMPL)

out.fit <- lm(MAXMPL ~ PK + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS, data = x)
summary(out.fit)

	#### modified
	out.fit <- lm(MAXMPL ~ ATP + NUMPROCESSORS, data = x)
	summary(out.fit)

