#!/bin/sh


if [ -z "$1" ]
  then
    echo "No DBMS specified\n"
    echo "[usage] ./start_dbms.sh DBMS_name [daemon_turnoff]\n"
    exit 1;
fi

if [ "$2" = "daemon_turnoff" ]; then
	echo "First, turn off daemons..."
	echo $2
	sudo daemon_control/manage_daemon_activity
	echo "Done..."
fi

if [ "$1" = "oracle" ]; then
    echo "Oracle start"
    sudo /etc/init.d/dbora start
elif [ "$1" = "db2" ]; then
    echo "DB2 Start"
    sudo /etc/init.d/db2 start
elif [ "$1" = "postgres" ]; then
    echo "PostgreSQL start"
    sudo /etc/init.d/postgresql-9.2 start
elif [ "$1" = "mysql" ]; then
    echo "MySQL start"
    sudo /etc/init.d/mysql start
elif [ "$1" = "derby" ]; then
    echo "JavaDB start"
    sudo /etc/init.d/derby start &
#elif [ "$1" -eq "Teradata" ]
#elif [ "$1" -eq "Teradata" ]
#    echo "Run MySQL database ..."
else
    echo "No" $1 "Exists..."
fi

exit 2;
