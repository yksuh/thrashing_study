x = read.csv(file="expl.dat",head=TRUE,sep="\t")
library("mediation")
set.seed(2014)
# ATP normalization
# db2
db2 <- subset(x, x$DBMS=='db2')
db2$ATP = (db2$ATP-min(db2$ATP))/(max(db2$ATP)-min(db2$ATP))
db2$MAXMPL = (db2$MAXMPL-min(db2$MAXMPL))/(max(db2$MAXMPL)-min(db2$MAXMPL))
# oracle
oracle <- subset(x, x$DBMS=='oracle')
oracle$ATP = (oracle$ATP-min(oracle$ATP))/(max(oracle$ATP)-min(oracle$ATP))
oracle$MAXMPL = (oracle$MAXMPL-min(oracle$MAXMPL))/(max(oracle$MAXMPL)-min(oracle$MAXMPL))
# pgsql
pgsql <- subset(x, x$DBMS=='pgsql')
pgsql$ATP = (pgsql$ATP-min(pgsql$ATP))/(max(pgsql$ATP)-min(pgsql$ATP))
pgsql$MAXMPL = (pgsql$MAXMPL-min(pgsql$MAXMPL))/(max(pgsql$MAXMPL)-min(pgsql$MAXMPL))
# mysql
mysql <- subset(x, x$DBMS=='mysql')
mysql$ATP = (mysql$ATP-min(mysql$ATP))/(max(mysql$ATP)-min(pgsql$ATP))
mysql$MAXMPL = (mysql$MAXMPL-min(mysql$MAXMPL))/(max(mysql$MAXMPL)-min(mysql$MAXMPL))
# sqlserver
sqlserver <- subset(x, x$DBMS=='sqlserver')
sqlserver$ATP = (sqlserver$ATP-min(sqlserver$ATP))/(max(sqlserver$ATP)-min(sqlserver$ATP))
sqlserver$MAXMPL = (sqlserver$MAXMPL-min(sqlserver$MAXMPL))/(max(sqlserver$MAXMPL)-min(sqlserver$MAXMPL))
x = rbind(db2,oracle,pgsql,mysql,sqlserver) 
x$ACTROWPOOL = (x$ACTROWPOOL-min(x$ACTROWPOOL))/(max(x$ACTROWPOOL)-min(x$ACTROWPOOL))
x$PCTREAD = (x$PCTREAD-min(x$PCTREAD))/(max(x$PCTREAD)-min(x$PCTREAD))
x$PCTUPDATE = (x$PCTUPDATE-min(x$PCTUPDATE))/(max(x$PCTUPDATE)-min(x$PCTUPDATE))
x$NUMPROCESSORS = (x$NUMPROCESSORS-min(x$NUMPROCESSORS))/(max(x$NUMPROCESSORS)-min(x$NUMPROCESSORS))

library(lavaan)
thrashing_model <- '
    # latent variable
    #   ATP =~ NUMPROCESSORS+ACTROWPOOL+NUMPROCESSORS*ACTROWPOOL+PK+PCTREAD+PCTUPDATE+PK*PCTUPDATE
    #  MAXMPL =~  ATP + ACTROWPOOL + PK + PCTREAD + PCTUPDATE + NUMPROCESSORS
    # mediator
      ATP ~ NUMPROCESSORS+ACTROWPOOL+PK+PCTREAD+PCTUPDATE
    # dependent variable
      #MAXMPL ~ ATP + ACTROWPOOL + PK + PCTREAD + PCTUPDATE + NUMPROCESSORS
      MAXMPL ~ ATP + ACTROWPOOL + PK + PCTUPDATE + NUMPROCESSORS'
fit <- sem(thrashing_model,data = x)
summary(fit, standardized=TRUE, rsq=T) 


library(lavaan)
thrashing_model <- '
    # latent variable
      #M1 =~ ACTROWPOOL*NUMPROCESSORS
      #M2 =~ PK*PCTREAD
      #M3 =~ PK*PCTUPDATE
    # mediator
      ATP ~ NUMPROCESSORS+ACTROWPOOL+ACTROWPOOL*NUMPROCESSORS+PK+PCTREAD+PCTUPDATE+PK*PCTUPDATE+PK*PCTREAD
    # dependent variable
      MAXMPL ~ ATP + PCTREAD + PK + PCTUPDATE + NUMPROCESSORS'
fit <- sem(thrashing_model,data = x)
summary(fit, standardized=TRUE, rsq=T) 

#causal mediation analysis
med.fit <- lm(ATP ~ NUMPROCESSORS+ACTROWPOOL+NUMPROCESSORS*ACTROWPOOL+PK+PCTUPDATE+PK*PCTUPDATE+PCTREAD+PK*PCTREAD, data = x)
out.fit <- lm(MAXMPL ~ ATP + PCTREAD + PCTUPDATE + ACTROWPOOL + NUMPROCESSORS, data = x)
library(mediation)
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS")
summary(med.out)

Causal Mediation Analysis 

Quasi-Bayesian Confidence Intervals

                Estimate 95% CI Lower 95% CI Upper p-value
ACME            0.008343     0.000976     0.017694    0.02
ADE            -0.032428    -0.098607     0.031923    0.29
Total Effect   -0.024085    -0.087537     0.041077    0.41
Prop. Mediated -0.178003    -4.260251     2.781678    0.41

Sample Size Used: 1004 


Simulations: 1000


thrashing_model <- '
    # direct effect
      MAXMPL ~ c2*PCTREAD + c3*PCTUPDATE + c4*ACTROWPOOL + c5*NUMPROCESSORS
    # moderator
      M1 =~ NUMPROCESSORS*ACTROWPOOL
      M2 =~ PK*PCTUPDATE
      M3 =~ PK*PCTREAD
    # mediator
      ATP ~ a1*NUMPROCESSORS+a2*ACTROWPOOL+a3*M1+a4*PK+a5*PCTUPDATE+a6*M2+a7*PCTREAD+a8*M3
      MAXMPL ~ b1*ATP
    # indirect effect 
      ie := a1*b1 + a2*b1 + a3*b1 + a4*b1 + a5*b1 + a6*b1 + a7*b1 + a8*b1 
    # total effect
      total := (b1+c2+c3+c4+c5)+(a1*b1 + a2*b1 + a3*b1 + a4*b1 + a5*b1 + a6*b1 + a7*b1 + a8*b1)'
fit <- sem(thrashing_model,data = x)
summary(fit, rsq=T) 

library(foreign)
write.foreign(x, "expl_normal.txt", "expl_data.sps",   package="SPSS")


# write out text datafile and
# an SPSS program to read it
#library(foreign)
#write.foreign(mydata, "c:/mydata.txt", "c:/mydata.sps",   package="SPSS")
# write out text datafile and
# an SAS program to read it
#library(foreign)
#write.foreign(mydata, "c:/mydata.txt", "c:/mydata.sas",   package="SAS")
#write.table(x, "expl_normal.dat", quote = FALSE, sep="\t", row.names=FALSE)

med.fit <- lm(ATP ~ NUMPROCESSORS+ACTROWPOOL+NUMPROCESSORS*ACTROWPOOL+PK+PCTUPDATE+PK*PCTUPDATE+PCTREAD+PK*PCTREAD, data = x)
summary(med.fit)
out.fit <- glm(MAXMPL ~ ATP + PCTREAD + PCTUPDATE + ACTROWPOOL + NUMPROCESSORS, data = x)
summary(out.fit)
med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "NUMPROCESSORS", robustSE = TRUE, family=binnomial("probit"))
summary(med.out)

Causal Mediation Analysis 

Quasi-Bayesian Confidence Intervals

               Estimate 95% CI Lower 95% CI Upper p-value
ACME            0.00866      0.00199      0.01794    0.01
ADE            -0.02995     -0.09298      0.02924    0.34
Total Effect   -0.02129     -0.08245      0.03781    0.48
Prop. Mediated -0.19713     -4.49803      3.40880    0.49

Sample Size Used: 1004 

Simulations: 1000 

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "ACTROWPOOL", robustSE = TRUE)
summary(med.out)

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTREAD", robustSE = TRUE)
summary(med.out)

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE", robustSE = TRUE)
summary(med.out)

Causal Mediation Analysis 

Quasi-Bayesian Confidence Intervals

               Estimate 95% CI Lower 95% CI Upper p-value
ACME           -0.00381     -0.01155      0.00077    0.15
ADE            -0.07499     -0.15210     -0.00302    0.04
Total Effect   -0.07880     -0.15536     -0.01001    0.04
Prop. Mediated  0.04233     -0.02644      0.30056    0.18

Sample Size Used: 1004 


Simulations: 1000 




med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "PCTUPDATE", robustSE = TRUE)

Causal Mediation Analysis 

Quasi-Bayesian Confidence Intervals

               Estimate 95% CI Lower 95% CI Upper p-value
ACME             0.0201      -0.0758       0.1189    0.66
ADE             -0.1001      -0.7749       0.5242    0.78
Total Effect    -0.0801      -0.7548       0.5513    0.83
Prop. Mediated   0.0129      -1.4752       2.0336    0.95

Sample Size Used: 1004 


Simulations: 1000 

med.out <- mediate(med.fit, out.fit, mediator = "ATP", treat = "ATP", robustSE = TRUE)

