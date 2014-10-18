cor(x$NUMPROCESSORS, x$ATP)
cor(x$PCTREAD, x$ATP)
cor(x$PCTUPDATE, x$ATP)
cor(x$ACTROWPOOL, x$ATP)
cor(x$PK, x$ATP)

cor(x$ATP, x$MAXMPL)
cor(x$NUMPROCESSORS, x$MAXMPL)
cor(x$PCTREAD, x$MAXMPL)
cor(x$PCTUPDATE, x$MAXMPL)
cor(x$ACTROWPOOL, x$MAXMPL)
cor(x$PK, x$MAXMPL)

library(lavaan)
thrashing_model <- '
     # mediator
      ATP ~ a1*NUMPROCESSORS+a2*ACTROWPOOL+a3*PK+a4*PCTUPDATE
    # dependent variable
      MAXMPL ~ b1*ATP+c1*NUMPROCESSORS+c2*ACTROWPOOL+c3*PK+c4*PCTUPDATE+c5*PCTREAD
   # interactions
       INT_1 := a3*a4
     '
fit <- sem(thrashing_model, estimator="DWLS", data = x)
summary(fit, fit.measures = TRUE, standardized=TRUE, rsq=T)


np        : -0.084439928 =  0.1362576 + -0.06130778 + -0.05379866 + 0.1098935 + -0.5532443
pctread   : 0.12778041   = -0.09527966 + 0.1141366 + 0.4425066 + 0.267628 + -0.09008949
actrowpool: 0.097332914  =  0.09376998 + 0.1048952 + 0.2523362 + 0.03082916 + 0.004834028
pctupdate : -0.21378181  = -0.2649032 + 0.00436664 + -0.6174895 + -0.355188 + 0.164305
PK:          -0.23774037 =  0.1384043 -0.7105615 -0.2962706 -0.3455648 + 0.02529076
sens.out$r.square.y
sens.out$r.square.m

PK, PCTUPDATE, NUMPROCESSORS, PCTREAD, ACTROWPOOL

med.fit <- lm(ATP ~ NUMPROCESSORS, data = x)
summary(med.fit)

med.fit <- lm(ATP ~ PCTUPDATE, data = x)
summary(med.fit)

med.fit <- lm(ATP ~ PCTREAD, data = x)
summary(med.fit)

med.fit <- lm(ATP ~ PK, data = x)
summary(med.fit)

med.fit <- lm(ATP ~ NUMPROCESSORS + PCTREAD, data = x)
summary(med.fit)

med.fit <- lm(ATP ~ NUMPROCESSORS +PCTREAD + PCTUPDATE, data = x)
summary(med.fit)

db2:PCTUPDATE
sqlserver:PCTUPDATE
oracle:PCTUPDATE
pgsql:PCTUPDATE
mysql:PCTREAD

med.fit <- lm(ATP ~ NUMPROCESSORS + PK + PCTREAD + PCTREAD:PK, data = x)
summary(med.fit)

med.fit <- lm(ATP ~ NUMPROCESSORS + PK + PCTUPDATE + PCTUPDATE:PK, data = x)
summary(med.fit)

read:
	mysql
	oracle
	pgsql


