cor(x$PK, x$MAXMPL)

cor(x$ATP, x$MAXMPL)

cor(x$NUMPROCESSORS, x$MAXMPL)

cor(x$ACTROWPOOL, x$MAXMPL)

cor(x$PCTREAD, x$MAXMPL)

cor(x$PCTUPDATE, x$MAXMPL)

re <- subset(x, x$PCTREAD!=0)
re <- subset(re, select = -PCTUPDATE)

cor(re$NUMPROCESSORS, re$MAXMPL)

cor(re$ACTROWPOOL, re$MAXMPL)

cor(re$PK, re$MAXMPL)

cor(re$PCTREAD, re$MAXMPL)

cor(re$ATP, re$MAXMPL)


cor(re$PCTREAD, re$ATP)

cor(re$PCTREAD, re$ATP)

cor(re$PCTREAD, re$ATP)

cor(re$PCTREAD, re$ATP)

up <- subset(x, x$PCTUPDATE!=0)
up <- subset(up, select = -PCTREAD)
cor(up$NUMPROCESSORS, up$MAXMPL)

cor(up$ACTROWPOOL, up$MAXMPL)

cor(up$ATP, up$MAXMPL)

cor(up$PCTUPDATE, up$MAXMPL)

cor(up$NUMPROCESSORS, up$ATP)

cor(up$PK, up$ATP)

cor(up$ACTROWPOOL, up$ATP)

cor(up$PCTUPDATE, up$ATP)

