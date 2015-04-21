x <- subset(x, x$MAXMPL < 1100)

a = subset(y, y$PCTUPDATE== 100)
b = subset(y, y$PCTUPDATE== 75)
c = subset(y, y$PCTUPDATE== 50)
d = subset(y, y$PCTUPDATE== 25)

e = subset(z, z$ACTROWPOOL== 0.25)
f = subset(z, z$ACTROWPOOL== 0.50)
g = subset(z, z$ACTROWPOOL== 0.75)
h = subset(z, z$ACTROWPOOL== 1)

