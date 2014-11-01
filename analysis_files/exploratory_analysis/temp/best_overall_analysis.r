# Overall: 33.4% (close to suboptimal)
x = read.csv(file="expl.dat",head=TRUE,sep="\t")
# ATP normalization
# db2
db2 <- subset(x, x$DBMS=='db2')
db2$ATP = (db2$ATP-min(db2$ATP))/(max(db2$ATP)-min(db2$ATP))
db2$ATP = (db2$ATP-min(db2$ATP))/(max(db2$ATP)-min(db2$ATP))
db2$ATP[db2$ATP > 0.8 & db2$ATP <= 1] <- 1
db2$ATP[db2$ATP > 0.6 & db2$ATP <= 0.8] <- 0.8
db2$ATP[db2$ATP > 0.4 & db2$ATP <= 0.6] <- 0.6
db2$ATP[db2$ATP > 0.2 & db2$ATP <= 0.4] <- 0.4
db2$ATP[db2$ATP <= 0.2 ] <- 0.2
db2$MAXMPL[db2$MAXMPL == 1100] <- 0
db2$MAXMPL[db2$MAXMPL > 0 & db2$MAXMPL < 1000] <- 1
# mysql
mysql <- subset(x, x$DBMS=='mysql')
mysql$ATP = (mysql$ATP-min(mysql$ATP))/(max(mysql$ATP)-min(mysql$ATP))
mysql$ATP[mysql$ATP > 0.8 & mysql$ATP <= 1] <- 1
mysql$ATP[mysql$ATP > 0.6 & mysql$ATP <= 0.8] <- 0.8
mysql$ATP[mysql$ATP > 0.4 & mysql$ATP <= 0.6] <- 0.6
mysql$ATP[mysql$ATP > 0.2 & mysql$ATP <= 0.4] <- 0.4
mysql$ATP[mysql$ATP <= 0.2 ] <- 0.2
mysql$MAXMPL[mysql$MAXMPL == 1100] <- 0
mysql$MAXMPL[mysql$MAXMPL > 0 & mysql$MAXMPL < 1000] <- 1
# oracle
oracle <- subset(x, x$DBMS=='oracle')
oracle$ATP = (oracle$ATP-min(oracle$ATP))/(max(oracle$ATP)-min(oracle$ATP))
oracle$ATP[oracle$ATP > 0.8 & oracle$ATP <= 1] <- 1
oracle$ATP[oracle$ATP > 0.6 & oracle$ATP <= 0.8] <- 0.8
oracle$ATP[oracle$ATP > 0.4 & oracle$ATP <= 0.6] <- 0.6
oracle$ATP[oracle$ATP > 0.2 & oracle$ATP <= 0.4] <- 0.4
oracle$ATP[oracle$ATP <= 0.2 ] <- 0.2
oracle$MAXMPL[oracle$MAXMPL == 1100] <- 0
oracle$MAXMPL[oracle$MAXMPL > 0 & oracle$MAXMPL < 1000] <- 1
# pgsql
pgsql <- subset(x, x$DBMS=='pgsql')
pgsql$ATP = (pgsql$ATP-min(pgsql$ATP))/(max(pgsql$ATP)-min(pgsql$ATP))
pgsql$ATP[pgsql$ATP > 0.8 & pgsql$ATP <= 1] <- 1
pgsql$ATP[pgsql$ATP > 0.6 & pgsql$ATP <= 0.8] <- 0.8
pgsql$ATP[pgsql$ATP > 0.4 & pgsql$ATP <= 0.6] <- 0.6
pgsql$ATP[pgsql$ATP > 0.2 & pgsql$ATP <= 0.4] <- 0.4
pgsql$ATP[pgsql$ATP <= 0.2 ] <- 0.2
pgsql$MAXMPL[pgsql$MAXMPL == 1100] <- 0
pgsql$MAXMPL[pgsql$MAXMPL > 0 & pgsql$MAXMPL < 1000] <- 1
# sqlserver
sqlserver <- subset(x, x$DBMS=='sqlserver')
sqlserver$ATP = (sqlserver$ATP-min(sqlserver$ATP))/(max(sqlserver$ATP)-min(sqlserver$ATP))
sqlserver$ATP[sqlserver$ATP > 0.8 & sqlserver$ATP <= 1] <- 1
sqlserver$ATP[sqlserver$ATP > 0.6 & sqlserver$ATP <= 0.8] <- 0.8
sqlserver$ATP[sqlserver$ATP > 0.4 & sqlserver$ATP <= 0.6] <- 0.6
sqlserver$ATP[sqlserver$ATP > 0.2 & sqlserver$ATP <= 0.4] <- 0.4
sqlserver$ATP[sqlserver$ATP <= 0.2 ] <- 0.2
sqlserver$MAXMPL[sqlserver$MAXMPL == 1100] <- 0
sqlserver$MAXMPL[sqlserver$MAXMPL > 0 & sqlserver$MAXMPL < 1000] <- 1
x = rbind(db2,oracle,mysql,pgsql,sqlserver) 
x$ACTROWPOOL = (x$ACTROWPOOL-min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)-min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD-min(x$PCTREAD))/(max(x$PCTREAD)-min(x$PCTREAD))
x$PCTUPDATE = (x$PCTUPDATE-min(x$PCTUPDATE))/(max(x$PCTUPDATE)-min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS-min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)-min(x$NUMPROCESSORS))

med.fit <- lm(ATP ~ NUMPROCESSORS + PK + PCTUPDATE + PCTUPDATE:PK, data = x)
summary(med.fit)

med.fit <- glm(ATP ~ NUMPROCESSORS + PK + PCTUPDATE + PCTUPDATE:PK, family=quasibinomial, data = x)
summary(med.fit)

out.fit <- glm(MAXMPL ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS + PK, family=quasibinomial, data = x)
summary(out.fit)
1-out.fit$deviance/out.fit$null.deviance
> 1-out.fit$deviance/out.fit$null.deviance
[1] 0.01555723

