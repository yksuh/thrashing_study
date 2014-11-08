x$PCTREAD[x$PCTREAD==0] <- NA
x$PCTUPDATE[x$PCTUPDATE==0] <- NA
write(x, file="expl_normal.dat")

