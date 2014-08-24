#!/bin/sh

#!/bin/sh
git pull origin TeradataCare
ant -Dexec_dir=/cs/projects/tau/installations/azdblab/thrashing_study -Dplugins.dir=/cs/projects/tau/installations/azdblab/thrashing_study/plugins AZDBLAB xtplugin xtsch
