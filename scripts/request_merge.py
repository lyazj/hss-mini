#!/usr/bin/env python3

import os
import sys
import uuid

if len(sys.argv) != 3:
    print('usage: %s <dirin> <dirout>' % os.path.basename(sys.argv[0]), file=sys.stderr)
    sys.exit(1)
dirin = sys.argv[1]
dirout = sys.argv[2]

script = open('merge.sh', 'w')
lines = open('merge.txt', 'w')
files = os.popen("ls '%s/'*.root" % os.path.abspath(dirin)).read().strip().split()
for i in range((len(files) + 99) // 100):
    filein = ','.join('file:' + f for f in files[i*100 : (i+1)*100] if os.stat(f).st_size > 1024*1024)
    fileout = 'file:%s/' % os.path.abspath(dirout) + uuid.uuid3(uuid.NAMESPACE_DNS, filein).__str__().upper() + '.root'
    print('cmsRun %s inputFiles=' % os.path.abspath('copyPickMerge_cfg.py') + filein + ' outputFile=' + fileout + ' maxSize=-1', file=script)
    print(i + 1, file=lines)
lines.close()
script.close()
