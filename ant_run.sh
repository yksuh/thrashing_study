#!/bin/sh
git pull origin ParallelTermination
ant -Dexec_dir=/cs/projects/tau/installations/azdblab/thrashing_study -Dplugins.dir=/cs/projects/tau/installations/azdblab/thrashing_study/plugins AZDBLAB xtplugin xtsch
cp /cs/projects/tau/installations/azdblab/thrashing_study/azdblab.jar ~/sqlserver/
cp /cs/projects/tau/installations/azdblab/thrashing_study/plugins/Xact*.jar ~/sqlserver/
