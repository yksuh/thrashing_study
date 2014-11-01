out.fit <- lm(MAXMPL ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS + PK, data = x)

> library(car)
> outlierTest(out.fit) # Bonferonni p-value for most extreme obs

No Studentized residuals with Bonferonni p < 0.05
Largest |rstudent|:
     rstudent unadjusted p-value Bonferonni p
833 -2.010525           0.044645           NA

pdf("outliers_assumption.pdf")
qqPlot(out.fit , main="QQ Plot for checking outliers")
leveragePlots(out.fit) 
dev.off()

pdf("partial_regression.pdf")
# Influential Observations
# added variable plots 
avPlots(out.fit, main="Partial-regression plots")
dev.off()
# Cook's D plot
pdf("cooks_distance.pdf")
cd = cooks.distance(out.fit)
plot(cd, ylim=c(0,0.006), main="(CD shouldn't be greater than 1)", ylab="Cook's Distances (CDs)", xlab="Observeration Number")
dev.off()

# identify D values > 4/(n-k-1) 
#cutoff <- 4/((nrow(x)-length(out.fit$coefficients)-2)) 
med.fit <- lm(ATP ~ NUMPROCESSORS + ACTROWPOOL + PK + PCTUPDATE, data = x)
out.fit <- lm(MAXMPL ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS + PK, data = x)
plot(out.fit, which=4, caption = "", sub.caption="", cook.levels=cutoff)
dev.off()
x <- x[-c(28, 454, 485),]
rownames(x) <- NULL
#dimnames(x)
#names(dimnames(myMat)) <- c("Names.of.Rows", "")
out.fit <- lm(MAXMPL ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS + PK, data = x)
pdf("cooks_distance_after.pdf")
# identify D values > 4/(n-k-1) 
cutoff <- 4/((nrow(x)-length(out.fit$coefficients)-2)) 
plot(out.fit, which=4, caption = "", sub.caption="", cook.levels=cutoff)
x <- x[-c(188,290,942),]
rownames(x) <- NULL
out.fit <- lm(MAXMPL ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS + PK, data = x)
plot(out.fit, which=4, caption = "", sub.caption="", cook.levels=cutoff)
x <- x[-c(188,289,940),]
rownames(x) <- NULL
out.fit <- lm(MAXMPL ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS + PK, data = x)
plot(out.fit, which=4, caption = "", sub.caption="", cook.levels=cutoff)
x <- x[-c(27,447,778),]
rownames(x) <- NULL
out.fit <- lm(MAXMPL ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS + PK, data = x)
plot(out.fit, which=4, caption = "", sub.caption="", cook.levels=cutoff)
x <- x[-c(16,479,935),]
rownames(x) <- NULL
out.fit <- lm(MAXMPL ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS + PK, data = x)
plot(out.fit, which=4, caption = "", sub.caption="", cook.levels=cutoff)
x <- x[-c(473,746,933),]
rownames(x) <- NULL
out.fit <- lm(MAXMPL ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS + PK, data = x)
plot(out.fit, which=4, caption = "", sub.caption="", cook.levels=cutoff)
x <- x[-c(724,771,772),]
rownames(x) <- NULL
out.fit <- lm(MAXMPL ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS + PK, data = x)
plot(out.fit, which=4, caption = "", sub.caption="", cook.levels=cutoff)
x <- x[-c(25,770,771),]
rownames(x) <- NULL
out.fit <- lm(MAXMPL ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS + PK, data = x)
plot(out.fit, which=4, caption = "", sub.caption="", cook.levels=cutoff)
x <- x[-c(541,720,745),]
rownames(x) <- NULL
out.fit <- lm(MAXMPL ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS + PK, data = x)
plot(out.fit, which=4, caption = "", sub.caption="", cook.levels=cutoff)


dev.off()

# Influence Plot 
pdf("influential_observeration.pdf")
influencePlot(out.fit, main="Influence Plot", sub="Circle size is proportial to Cook's Distance" )
dev.off()

# Normality of Residuals
#par(mfrow=c(1,2));
pdf("normal_res_qqplot.pdf")
out.fit <- lm(MAXMPL ~ PCTREAD + PCTUPDATE + ACTROWPOOL + ATP + NUMPROCESSORS + PK, data = x)
qqnorm(out.fit$res,main="",ylim=c(-0.8,0.6)); qqline(out.fit$res);
dev.off()
pdf("normal_res_hist.pdf")
h <- hist(out.fit$res,main="",xlab="Residuals",ylim=c(0,200))
xfit<-seq(min(out.fit$res),max(out.fit$res),length=40) 
yfit<-dnorm(xfit,mean=mean(out.fit$res),sd=sd(out.fit$res)) 
yfit <- yfit*diff(h$mids[1:2])*length(out.fit$res) 
lines(xfit, yfit, col="blue")
dev.off()

##Non-normality
library(MASS)
sresid <- studres(out.fit) 
pdf("normality_test_hist.pdf")
hist(sresid, ylim=c(0, 0.6), xlab="Studentized Residuals", ylab="Probability Densities", freq=FALSE,main="")
xfit<-seq(min(sresid),max(sresid),length=40) 
yfit<-dnorm(xfit) 
lines(xfit, yfit, col="blue")
dev.off()

# Evaluate homoscedasticity
# non-constant error variance test
> ncvTest(out.fit)
Non-constant Variance Score Test 
Variance formula: ~ fitted.values 
Chisquare = 5.126085    Df = 1     p = 0.02356883
pdf("homoscedasticity_assumption_test_result.pdf")
# plot studentized residuals vs. fitted values 
spreadLevelPlot(out.fit, main="Homoscedasticity Test")
dev.off()

# Evaluate Collinearity
vif(out.fit) # variance inflation factors 
sqrt(vif(out.fit)) > 2 # problem?
> vif(out.fit)
      PCTREAD     PCTUPDATE    ACTROWPOOL           ATP NUMPROCESSORS 
     1.224962      1.241905      1.006105      1.088725      1.016900 
           PK 
     1.043479 
> sqrt(vif(out.fit))
      PCTREAD     PCTUPDATE    ACTROWPOOL           ATP NUMPROCESSORS 
     1.106780      1.114408      1.003048      1.043420      1.008415 
           PK 
     1.021508 

# Evaluate Nonlinearity
# component + residual plot 
pdf("linearity_assumption_test_result.pdf")
#crPlots(out.fit, main = "", ylab = "MPL Capability")
crPlots(out.fit, main = "",)
dev.off()
# Ceres plots 
pdf("nonlinearity_assumption_test_result2.pdf")
ceresPlots(out.fit)
dev.off()

gvmodel <- gvlma(out.fit) 

# Test for Autocorrelated Errors
durbinWatsonTest(out.fit)

> install.packages("lmtest")
dwtest(out.fit, alternative="two.sided")

> durbinWatsonTest(out.fit)
 lag Autocorrelation D-W Statistic p-value
   1        0.664225     0.6693103       0
 Alternative hypothesis: rho != 0


plot(out.fit, col="black", main='Checking assumptions', xlab='Regression for MPL Capability')
par(mfrow=c(2,2))
dev.off()

