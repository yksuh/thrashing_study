# Makefile of The Tucson Protocol
CC	= gcc
JC	= javac
JR	= jar
INCS	= synctest.h timechecker.h
SRCS	= synctest.c timechecker.c
OBJS	= ${SRCS:.c=.o}
CFLAGS	= -O -ansi -pedantic -lm

all: TimeChecker/synctest \
	TimeChecker/timechecker \
	CheckIOStat.class \
	JDBCTester/JDBCTester.class

TimeChecker/synctest: TimeChecker/synctest.o
	$(CC) $(CFLAGS) -o TimeChecker/synctest synctest.o

TimeChecker/timechecker: TimeChecker/timechecker.o
	$(CC) $(CFLAGS) -o TimeChecker/timechecker timechecker.o

CheckIOStat.class: TimeChecker/CheckIOStat.java
	$(JC) TimeChecker/CheckIOStat.java
	$(JR) cmf TimeChecker/mainclass checkiostat.jar TimeChecker/CheckIOStat.class

JDBCTester/JDBCTester.class: JDBCTester/JDBCTester.java
	$(JC) JDBCTester/JDBCTester.java

install:
	mkdir bin
	cp TimeChecker/synctest bin/
	cp TimeChecker/timechecker bin/
	cp TimeChecker/runscript bin/
	cp TimeChecker/setdropcaches bin/
	cp checkiostat.jar bin/
	cp JDBCTester/runjdbctest bin/

clean:
	rm -rf bin
	rm -f *.o
	rm -f TimeChecker/*.class
	rm -f JDBCTester/*.class
	rm -f *.jar

.c.o:; $(CC) $(CFLAGS) -c $<
