library(lavaan)
thrashing_model <- '
     # mediator
     # ATP ~ a1*NUMPROCESSORS+a2*ACTROWPOOL+a3*PK+a4*PCTUPDATE+a5*PCTREAD
    # dependent variable
      ATP ~ c2*PK
    # interactions
     '
fit <- sem(thrashing_model, data = x)
summary(fit, fit.measures = TRUE, standardized=TRUE, rsq=T)

# Overall: 33.4% (close to suboptimal)
x = read.csv(file="expl.dat",head=TRUE,sep="\t")

pdf("raw_atp_maxmpl.pdf")
plot(x$ATP, x$MAXMPL, col="black", main='ATP time (raw) vs. MPL Capability (raw)', xlab='ATP time (ms)', ylab=expression('MPL Capability'))
dev.off()

pdf("raw_nprocs_maxmpl.pdf")
plot(x$NUMPROCESSORS, x$MAXMPL, col="black", main='# of Procs (raw) vs. MPL Capability (raw)', xlab='# of Procs', ylab=expression('MPL Capability'))
dev.off()

pdf("raw_nprocs_atp.pdf")
plot(x$NUMPROCESSORS, x$ATP, col="black", main='# of Procs (raw) vs. ATP time (raw)', xlab='# of Procs', ylab=expression('ATP time (ms)'))
dev.off()

pdf("raw_pk_atp.pdf")
plot(x$PK, x$ATP, col="black", main='Primary Key vs. ATP time (raw)', xlab='Primary Key Presence', ylab=expression('ATP time (ms)'))
dev.off()

pdf("raw_pk_mpl.pdf")
plot(x$PK, x$MAXMPL, col="black", main='Primary Key vs. MPL Capability (raw)', xlab='Primary Key Presence', ylab=expression('MPL Capability'))
dev.off()

# db2
db2 <- subset(x, x$DBMS=='db2')
db2$ATP = (db2$ATP-min(db2$ATP))/(max(db2$ATP)-min(db2$ATP))
db2$MAXMPL = (db2$MAXMPL-min(db2$MAXMPL))/(max(db2$MAXMPL)-min(db2$MAXMPL))
# oracle
oracle <- subset(x, x$DBMS=='oracle')
oracle$ATP = (oracle$ATP-min(oracle$ATP))/(max(oracle$ATP)-min(oracle$ATP))
oracle$MAXMPL = (oracle$MAXMPL-min(oracle$MAXMPL))/(max(oracle$MAXMPL)-min(oracle$MAXMPL))
# mysql
mysql <- subset(x, x$DBMS=='mysql')
mysql$ATP = (mysql$ATP-min(mysql$ATP))/(max(mysql$ATP)-min(mysql$ATP))
mysql$MAXMPL = (mysql$MAXMPL-min(mysql$MAXMPL))/(max(mysql$MAXMPL)-min(mysql$MAXMPL))
# pgsql
pgsql <- subset(x, x$DBMS=='pgsql')
pgsql$ATP = (pgsql$ATP-min(pgsql$ATP))/(max(pgsql$ATP)-min(pgsql$ATP))
pgsql$MAXMPL = (pgsql$MAXMPL-min(pgsql$MAXMPL))/(max(pgsql$MAXMPL)-min(pgsql$MAXMPL))
# sqlserver
sqlserver <- subset(x, x$DBMS=='sqlserver')
sqlserver$ATP = (sqlserver$ATP-min(sqlserver$ATP))/(max(sqlserver$ATP)-min(sqlserver$ATP))
sqlserver$MAXMPL = (sqlserver$MAXMPL-min(sqlserver$MAXMPL))/(max(sqlserver$MAXMPL)-min(sqlserver$MAXMPL))
x = rbind(db2,oracle,mysql,pgsql,sqlserver) 
x$NUMPROCESSORS = (x$NUMPROCESSORS-min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)-min(x$NUMPROCESSORS))

pdf("feature_scaled_atp_maxmpl.pdf")
plot(x$ATP, x$MAXMPL, col="black", main='ATP time (scaled) vs. MPL Capability (scaled)', xlab='ATP time (ms)', ylab=expression('MPL Capability'))
dev.off()

pdf("feature_scaled_nprocs_maxmpl.pdf")
plot(x$NUMPROCESSORS, x$MAXMPL, col="black", main='# of Procs (scaled) vs. MPL Capability (scaled)', xlab='# of Procs', ylab=expression('MPL Capability'))
dev.off()

pdf("feature_scaled_nprocs_atp.pdf")
plot(x$NUMPROCESSORS, x$ATP, col="black", main='# of Procs (scaled) vs. ATP time (scaled)', xlab='# of Procs', ylab=expression('ATP time'))
dev.off()

pdf("feature_scaled_pk_atp.pdf")
plot(x$PK, x$ATP, col="black", main='PK (scaled) vs. ATP time (scaled)', xlab='Primary Key Presence', ylab=expression('ATP time'))
dev.off()

pdf("feature_scaled_pk_maxmpl.pdf")
plot(x$PK, x$MAXMPL, col="black", main='PK (scaled) vs. MPL Capability (scaled)', xlab='Primary Key Presence', ylab=expression('ATP time'))
dev.off()

# Overall
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
# ATP & MAXMPL normalization
db2 <- subset(x, x$DBMS=='db2')
db2$ATP = (db2$ATP-min(db2$ATP))/(max(db2$ATP)-min(db2$ATP))
db2$MAXMPL = (db2$MAXMPL-min(db2$MAXMPL))/(max(db2$MAXMPL)-min(db2$MAXMPL))
#nrow(db2)
#nrow(subset(db2, db2$MAXMPL < 1))
#nrow(subset(db2, db2$MAXMPL <= 0.5))
#x = rbind(db2,oracle,mysql,pgsql,sqlserver) 
x$ACTROWPOOL = (x$ACTROWPOOL-min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)-min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD-min(x$PCTREAD))/(max(x$PCTREAD)-min(x$PCTREAD))
x$PCTUPDATE = (x$PCTUPDATE-min(x$PCTUPDATE))/(max(x$PCTUPDATE)-min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS-min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)-min(x$NUMPROCESSORS))

library(lavaan)
thrashing_model <- '
     # mediator
      ATP ~ a1*NUMPROCESSORS+a2*ACTROWPOOL+a3*PK+a4*PCTUPDATE+a5*PCTREAD
    # dependent variable
      MAXMPL ~ b1*ATP + c2*NUMPROCESSORS + c3*ACTROWPOOL + c4*PCTUPDATE + c5*PCTREAD + c6*PK
    # interactions
     INT_1 := a3*a4
     INT_2 := a3*a5
     INT_3 := a1*a2
     '
fit <- sem(thrashing_model, data = x)
summary(fit, fit.measures = TRUE, standardized=TRUE, rsq=T) 

### mediation test
### regression on ATP 
library(mediation)
med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + PK + PCTREAD + PCTREAD:PK + PCTUPDATE + PCTUPDATE:PK, data = x)
summary(med.fit)

### regression on MAXMPL 
out.fit <- lm(MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + PCTREAD, data = x)
summary(out.fit)

### mediation of NUMPROCESSORS via ATP on MAXMPL 
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
summary(med.out)

### moderated mediation of NUMPROCESSORS by ACTROWPOOL through ATP  on MAXMPL
test.modmed(med.out, covariates.1 = list (x$ACTROWPOOL < 0.5), covariates.2 = list (x$x$ACTROWPOOL >= 0.5), data = x)

###  mediation of PCTREAD via ATP on MAXMPL 
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTREAD")
summary(med.out)

### moderated mediation of NUMPROCESSORS by PK through ATP on MAXMPL
test.modmed(med.out, covariates.1 = list (x$PK == 1), covariates.2 = list (x$PK == 0), data = x)

###  mediation of PCTUPDATE via ATP on MAXMPL 
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE")
summary(med.out)

### moderated mediation of PCTUPDATE by PK through ATP on MAXMPL
test.modmed(med.out, covariates.1 = list (x$PK == 1), covariates.2 = list (x$PK == 0), data = x)

## non primary key
y <- subset(x, x$PK == 0) # non-pk
library(lavaan)
thrashing_model <- '
     # mediator
      ATP ~ a1*NUMPROCESSORS+a2*ACTROWPOOL+a4*PCTUPDATE+a5*PCTREAD
    # dependent variable
      MAXMPL ~ b1*ATP + c2*NUMPROCESSORS + c3*ACTROWPOOL + c4*PCTUPDATE + c5*PCTREAD
    # interactions
     INT_3 := a1*a2
     '
fit <- sem(thrashing_model, data = y)
summary(fit, fit.measures = TRUE, standardized=TRUE, rsq=T)

### mediation test
### regression on ATP 
library(mediation)
med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + PCTREAD + PCTUPDATE, data = y)
summary(med.fit)


### regression on MAXMPL 
out.fit <- lm(MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + PCTREAD, data = y)
summary(out.fit)

y <- subset(x, x$PK == 1) # pk
#nrow(y)
library(lavaan)
thrashing_model <- '
     # mediator
      ATP ~ a1*NUMPROCESSORS+a2*ACTROWPOOL+a4*PCTUPDATE+a5*PCTREAD
    # dependent variable
      MAXMPL ~ b1*ATP + c2*NUMPROCESSORS + c3*ACTROWPOOL + c4*PCTUPDATE + c5*PCTREAD
    # interactions
     INT_3 := a1*a2
     '
fit <- sem(thrashing_model, data = y)
summary(fit, fit.measures = TRUE, standardized=TRUE, rsq=T)

### mediation test
### regression on ATP 
library(mediation)
med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + NUMPROCESSORS:ACTROWPOOL + PCTREAD + PCTUPDATE, data = y)
summary(med.fit)


### regression on MAXMPL 
out.fit <- lm(MAXMPL ~ ATP + ACTROWPOOL + NUMPROCESSORS + PCTUPDATE + PCTREAD, data = y)
summary(out.fit)
