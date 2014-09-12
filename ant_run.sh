#!/bin/sh
git pull origin BatchsetGenerator
ant -Dexec_dir=/cs/projects/tau/installations/azdblab/thrashing_study -Dplugins.dir=/cs/projects/tau/installations/azdblab/thrashing_study/plugins AZDBLAB xtplugin xtsch 
cp /cs/projects/tau/installations/azdblab/thrashing_study/plugins/Xact*.jar ~/sqlserver/
cp /cs/projects/tau/installations/azdblab/thrashing_study/azdblab.jar ~/sqlserver/

