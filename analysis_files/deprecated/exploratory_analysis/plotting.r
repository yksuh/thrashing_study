# Overall: 33.4% (close to suboptimal)
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
## overall
pdf("overall_raw_pk_atp.pdf")
plot(x$PK, x$ATP, col="black", main='Overall - Primary Key (raw) vs. ATP time (raw)', xlab='Primary Key Presence', ylab=expression('ATP time (ms)'))
dev.off()
pdf("overall_raw_pk_mpl.pdf")
plot(x$PK, x$MAXMPL, col="black", main='Overall - Primary Key (raw) vs. MPL Capability (raw)', xlab='Primary Key Presence', ylab=expression('MPL Capability'))
dev.off()
# db2
db2 <- subset(x, x$DBMS=='db2')
pdf("db2_raw_pk_atp.pdf")
plot(db2$PK, db2$ATP, col="black", main='DB2 - Primary Key (raw) vs. ATP time (raw)', xlab='Primary Key Presence', ylab=expression('ATP time (ms)'))
dev.off()
pdf("db2_raw_pk_mpl.pdf")
plot(db2$PK, db2$MAXMPL, col="black", main='DB2 - Primary Key (raw) vs. MPL Capa. (raw)', xlab='Primary Key Presence', ylab=expression('MPL Capa.'))
dev.off()
db2$ATP = (db2$ATP-min(db2$ATP))/(max(db2$ATP)-min(db2$ATP))
db2$ATP[db2$ATP > 0.8 & db2$ATP <= 1] <- 5
db2$ATP[db2$ATP > 0.6 & db2$ATP <= 0.8] <- 4
db2$ATP[db2$ATP > 0.4 & db2$ATP <= 0.6] <- 3
db2$ATP[db2$ATP > 0.2 & db2$ATP <= 0.4] <- 2
db2$ATP[db2$ATP <= 0.2 ] <- 1
db2$ATP = (db2$ATP-min(db2$ATP))/(max(db2$ATP)-min(db2$ATP))
db2$MAXMPL = (db2$MAXMPL-min(db2$MAXMPL))/(max(db2$MAXMPL)-min(db2$MAXMPL))
db2$MAXMPL[db2$MAXMPL == 1] <- 5
db2$MAXMPL[db2$MAXMPL > 0.75 & db2$MAXMPL <= 1] <- 4
db2$MAXMPL[db2$MAXMPL > 0.5 & db2$MAXMPL <= 0.75] <- 3
db2$MAXMPL[db2$MAXMPL > 0.25 & db2$MAXMPL <= 0.50] <- 2
db2$MAXMPL[db2$MAXMPL<=0.25] <- 1
db2$MAXMPL = (db2$MAXMPL-min(db2$MAXMPL))/(max(db2$MAXMPL)-min(db2$MAXMPL))
x = rbind(db2) 

pdf("checking_assumptions.pdf")
plot(out.fit, col="black", main='Checking assumptions', xlab='Regression for MPL Capability')
par(mfrow=c(2,2))
dev.off()


pdf("db2_scaled_pk_atp.pdf")
plot(x$PK, x$ATP, col="black", main='DB2 - Primary Key (scaled) vs. ATP time (scaled)', xlab='Primary Key Presence', ylab=expression('ATP time'))
dev.off()
pdf("db2_scaled_pk_mpl.pdf")
plot(x$PK, x$MAXMPL, col="black", main='DB2 - Primary Key (scaled) vs. MPL Capa. (scaled)', xlab='Primary Key Presence', ylab=expression('MPL Capa.'))
dev.off()

# mysql
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
mysql <- subset(x, x$DBMS=='mysql')
pdf("mysql_raw_pk_atp.pdf")
plot(mysql$PK, mysql$ATP, col="black", main='MySQL - Primary Key (raw) vs. ATP time (raw)', xlab='Primary Key Presence', ylab=expression('ATP time (ms)'))
dev.off()
pdf("mysql_raw_pk_mpl.pdf")
plot(mysql$PK, mysql$MAXMPL, col="black", main='MySQL - Primary Key (raw) vs. MPL Capa. (raw)', xlab='Primary Key Presence', ylab=expression('MPL Capa.'))
dev.off()
mysql$ATP = (mysql$ATP-min(mysql$ATP))/(max(mysql$ATP)-min(mysql$ATP))
mysql$ATP[mysql$ATP > 0.8 & mysql$ATP <= 1] <- 5
mysql$ATP[mysql$ATP > 0.6 & mysql$ATP <= 0.8] <- 4
mysql$ATP[mysql$ATP > 0.4 & mysql$ATP <= 0.6] <- 3
mysql$ATP[mysql$ATP > 0.2 & mysql$ATP <= 0.4] <- 2
mysql$ATP[mysql$ATP <= 0.2 ] <- 1
mysql$ATP = (mysql$ATP-min(mysql$ATP))/(max(mysql$ATP)-min(mysql$ATP))
mysql$MAXMPL = (mysql$MAXMPL-min(mysql$MAXMPL))/(max(mysql$MAXMPL)-min(mysql$MAXMPL))
mysql$MAXMPL[mysql$MAXMPL == 1] <- 5
mysql$MAXMPL[mysql$MAXMPL > 0.75 & mysql$MAXMPL <= 1] <- 4
mysql$MAXMPL[mysql$MAXMPL > 0.5 & mysql$MAXMPL <= 0.75] <- 3
mysql$MAXMPL[mysql$MAXMPL > 0.25 & mysql$MAXMPL <= 0.50] <- 2
mysql$MAXMPL[mysql$MAXMPL<=0.25] <- 1
mysql$MAXMPL = (mysql$MAXMPL-min(mysql$MAXMPL))/(max(mysql$MAXMPL)-min(mysql$MAXMPL))
x = rbind(mysql) 
pdf("mysql_scaled_pk_atp.pdf")
plot(x$PK, x$ATP, col="black", main='MySQL - Primary Key (scaled) vs. ATP time (scaled)', xlab='Primary Key Presence', ylab=expression('ATP time'))
dev.off()
pdf("mysql_scaled_pk_mpl.pdf")
plot(x$PK, x$MAXMPL, col="black", main='MySQL - Primary Key (scaled) vs. MPL Capa. (scaled)', xlab='Primary Key Presence', ylab=expression('MPL Capa.'))
dev.off()

# oracle
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
oracle <- subset(x, x$DBMS=='oracle')
pdf("oracle_raw_pk_atp.pdf")
plot(oracle$PK, oracle$ATP, col="black", main='Oracle - Primary Key (raw) vs. ATP time (raw)', xlab='Primary Key Presence', ylab=expression('ATP time (ms)'))
dev.off()
pdf("oracle_raw_pk_mpl.pdf")
plot(oracle$PK, oracle$MAXMPL, col="black", main='Oracle - Primary Key (raw) vs. MPL Capa. (raw)', xlab='Primary Key Presence', ylab=expression('MPL Capa.'))
dev.off()
oracle$ATP = (oracle$ATP-min(oracle$ATP))/(max(oracle$ATP)-min(oracle$ATP))
oracle$ATP[oracle$ATP > 0.8 & oracle$ATP <= 1] <- 5
oracle$ATP[oracle$ATP > 0.6 & oracle$ATP <= 0.8] <- 4
oracle$ATP[oracle$ATP > 0.4 & oracle$ATP <= 0.6] <- 3
oracle$ATP[oracle$ATP > 0.2 & oracle$ATP <= 0.4] <- 2
oracle$ATP[oracle$ATP <= 0.2 ] <- 1
oracle$ATP = (oracle$ATP-min(oracle$ATP))/(max(oracle$ATP)-min(oracle$ATP))
oracle$MAXMPL = (oracle$MAXMPL-min(oracle$MAXMPL))/(max(oracle$MAXMPL)-min(oracle$MAXMPL))
oracle$MAXMPL[oracle$MAXMPL == 1] <- 5
oracle$MAXMPL[oracle$MAXMPL > 0.75 & oracle$MAXMPL <= 1] <- 4
oracle$MAXMPL[oracle$MAXMPL > 0.5 & oracle$MAXMPL <= 0.75] <- 3
oracle$MAXMPL[oracle$MAXMPL > 0.25 & oracle$MAXMPL <= 0.50] <- 2
oracle$MAXMPL[oracle$MAXMPL<=0.25] <- 1
oracle$MAXMPL = (oracle$MAXMPL-min(oracle$MAXMPL))/(max(oracle$MAXMPL)-min(oracle$MAXMPL))
x = rbind(oracle) 
pdf("oracle_scaled_pk_atp.pdf")
plot(x$PK, x$ATP, col="black", main='Oracle - Primary Key (scaled) vs. ATP time (scaled)', xlab='Primary Key Presence', ylab=expression('ATP time'))
dev.off()
pdf("oracle_scaled_pk_mpl.pdf")
plot(x$PK, x$MAXMPL, col="black", main='Oracle - Primary Key (scaled) vs. MPL Capa. (scaled)', xlab='Primary Key Presence', ylab=expression('MPL Capa.'))
dev.off()

# pgsql
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
pgsql <- subset(x, x$DBMS=='pgsql')
pdf("pgsql_raw_pk_atp.pdf")
plot(pgsql$PK, pgsql$ATP, col="black", main='PostgreSQL - Primary Key (raw) vs. ATP time (raw)', xlab='Primary Key Presence', ylab=expression('ATP time (ms)'))
dev.off()
pdf("pgsql_raw_pk_mpl.pdf")
plot(pgsql$PK, pgsql$MAXMPL, col="black", main='PostgreSQL - Primary Key (raw) vs. MPL Capa. (raw)', xlab='Primary Key Presence', ylab=expression('MPL Capa.'))
dev.off()
pgsql$ATP = (pgsql$ATP-min(pgsql$ATP))/(max(pgsql$ATP)-min(pgsql$ATP))
pgsql$ATP[pgsql$ATP > 0.8 & pgsql$ATP <= 1] <- 5
pgsql$ATP[pgsql$ATP > 0.6 & pgsql$ATP <= 0.8] <- 4
pgsql$ATP[pgsql$ATP > 0.4 & pgsql$ATP <= 0.6] <- 3
pgsql$ATP[pgsql$ATP > 0.2 & pgsql$ATP <= 0.4] <- 2
pgsql$ATP[pgsql$ATP <= 0.2 ] <- 1
pgsql$ATP = (pgsql$ATP-min(pgsql$ATP))/(max(pgsql$ATP)-min(pgsql$ATP))
pgsql$MAXMPL = (pgsql$MAXMPL-min(pgsql$MAXMPL))/(max(pgsql$MAXMPL)-min(pgsql$MAXMPL))
pgsql$MAXMPL[pgsql$MAXMPL == 1] <- 5
pgsql$MAXMPL[pgsql$MAXMPL > 0.75 & pgsql$MAXMPL <= 1] <- 4
pgsql$MAXMPL[pgsql$MAXMPL > 0.5 & pgsql$MAXMPL <= 0.75] <- 3
pgsql$MAXMPL[pgsql$MAXMPL > 0.25 & pgsql$MAXMPL <= 0.50] <- 2
pgsql$MAXMPL[pgsql$MAXMPL<=0.25] <- 1
pgsql$MAXMPL = (pgsql$MAXMPL-min(pgsql$MAXMPL))/(max(pgsql$MAXMPL)-min(pgsql$MAXMPL))
x = rbind(pgsql) 
pdf("pgsql_scaled_pk_atp.pdf")
plot(x$PK, x$ATP, col="black", main='Primary Key (scaled) vs. ATP time (scaled)', xlab='Primary Key Presence', ylab=expression('ATP time'))
dev.off()
pdf("pgsql_scaled_pk_mpl.pdf")
plot(x$PK, x$MAXMPL, col="black", main='Primary Key (scaled) vs. MPL Capa. (scaled)', xlab='Primary Key Presence', ylab=expression('MPL Capa.'))
dev.off()

# sqlserver
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
sqlserver <- subset(x, x$DBMS=='sqlserver')
pdf("sqlserver_raw_pk_atp.pdf")
plot(sqlserver$PK, sqlserver$ATP, col="black", main='SQL Server - Primary Key (raw) vs. ATP time (raw)', xlab='Primary Key Presence', ylab=expression('ATP time (ms)'))
dev.off()
pdf("sqlserver_raw_pk_mpl.pdf")
plot(sqlserver$PK, sqlserver$MAXMPL, col="black", main='SQL Server - Primary Key (raw) vs. MPL Capa. (raw)', xlab='Primary Key Presence', ylab=expression('MPL Capa.'))
dev.off()
sqlserver$ATP = (sqlserver$ATP-min(sqlserver$ATP))/(max(sqlserver$ATP)-min(sqlserver$ATP))
sqlserver$ATP[sqlserver$ATP > 0.8 & sqlserver$ATP <= 1] <- 5
sqlserver$ATP[sqlserver$ATP > 0.6 & sqlserver$ATP <= 0.8] <- 4
sqlserver$ATP[sqlserver$ATP > 0.4 & sqlserver$ATP <= 0.6] <- 3
sqlserver$ATP[sqlserver$ATP > 0.2 & sqlserver$ATP <= 0.4] <- 2
sqlserver$ATP[sqlserver$ATP <= 0.2 ] <- 1
sqlserver$ATP = (sqlserver$ATP-min(sqlserver$ATP))/(max(sqlserver$ATP)-min(sqlserver$ATP))
sqlserver$MAXMPL = (sqlserver$MAXMPL-min(sqlserver$MAXMPL))/(max(sqlserver$MAXMPL)-min(sqlserver$MAXMPL))
sqlserver$MAXMPL[sqlserver$MAXMPL == 1] <- 5
sqlserver$MAXMPL[sqlserver$MAXMPL > 0.75 & sqlserver$MAXMPL <= 1] <- 4
sqlserver$MAXMPL[sqlserver$MAXMPL > 0.5 & sqlserver$MAXMPL <= 0.75] <- 3
sqlserver$MAXMPL[sqlserver$MAXMPL > 0.25 & sqlserver$MAXMPL <= 0.50] <- 2
sqlserver$MAXMPL[sqlserver$MAXMPL<=0.25] <- 1
sqlserver$MAXMPL = (sqlserver$MAXMPL-min(sqlserver$MAXMPL))/(max(sqlserver$MAXMPL)-min(sqlserver$MAXMPL))
x = rbind(sqlserver) 
pdf("sqlserver_scaled_pk_atp.pdf")
plot(x$PK, x$ATP, col="black", main='SQL Server - Primary Key (scaled) vs. ATP time (scaled)', xlab='Primary Key Presence', ylab=expression('ATP time'))
dev.off()
pdf("sqlserver_scaled_pk_mpl.pdf")
plot(x$PK, x$MAXMPL, col="black", main='SQL Server - Primary Key (scaled) vs. MPL Capa. (scaled)', xlab='Primary Key Presence', ylab=expression('MPL Capa.'))
dev.off()

## collect all
x = rbind(db2,oracle,mysql,pgsql,sqlserver) 
pdf("overall_scaled_pk_atp.pdf")
plot(x$PK, x$ATP, col="black", main='Overall - Primary Key (scaled) vs. ATP time (scaled)', xlab='Primary Key Presence', ylab=expression('ATP time'))
dev.off()

pdf("overall_scaled_pk_mpl.pdf")
plot(x$PK, x$MAXMPL, col="black", main='Overall - Primary Key (scaled) vs. MPL Capability (scaled)', xlab='Primary Key Presence', ylab=expression('MPL Capability'))
dev.off()

-----

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
plot(x$PK, x$ATP, col="black", main='Primary Key (raw) vs. ATP time (raw)', xlab='Primary Key Presence', ylab=expression('ATP time (ms)'))
dev.off()

pdf("raw_pk_mpl.pdf")
plot(x$PK, x$MAXMPL, col="black", main='Primary Key (raw) vs. MPL Capability (raw)', xlab='Primary Key Presence', ylab=expression('MPL Capability'))
dev.off()

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
plot(x$PK, x$ATP, col="black", main='Primary Key (scaled) vs. ATP time (scaled)', xlab='Primary Key Presence', ylab=expression('ATP time'))
dev.off()

pdf("feature_scaled_pk_maxmpl.pdf")
plot(x$PK, x$MAXMPL, col="black", main='Primary Key (scaled) vs. MPL Capability (scaled)', xlab='Primary Key Presence', ylab=expression('MPL Capability'))
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
