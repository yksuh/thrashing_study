#!/bin/sh
git pull origin NewExperiment
ant -Dexec_dir=/cs/projects/tau/installations/azdblab/dbms_thrashing -Dplugins.dir=/cs/projects/tau/installations/azdblab/dbms_thrashing/plugins AZDBLAB xtplugin db2plugin oraplugin pgsqlplugin mysqlplugin xtsch
#cp /cs/projects/tau/installations/azdblab/dbms_thrashing/azdblab.jar ~/sqlserver/
#cp /cs/projects/tau/installations/azdblab/dbms_thrashing/plugins/Xact*.jar ~/sqlserver/
