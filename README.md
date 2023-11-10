# MiniAnalysis

Simple Miniaod analysis routines for Hss study.

```bash
source /cvmfs/cms.cern.ch/cmsset_default.sh
export SCRAM_ARCH=slc7_amd64_gcc700
[ -r CMSSW_10_6_31 ] || cmsrel CMSSW_10_6_31
cd CMSSW_10_6_31/src
cmsenv

git clone https://github.com/lyazj/hss-mini PhysicsTools/MiniAnalysis

scram b -j16
cd PhysicsTools/MiniAnalysis/scripts
cmsRun MiniAnalysis.py
```
