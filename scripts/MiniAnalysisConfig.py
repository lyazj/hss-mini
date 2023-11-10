import os

### Maximum number of entries to process ###
#   type: int
nevent = -1

### input root file list ###
#   type: iterable
#   note: Prefix 'file:' should be used to mark a local path.
_dirin = '/eos/user/l/legao/hss/src/aod/WplusH_HToSS_WToLNu_M-125_TuneCP5_13TeV-powheg-pythia8/HIG-RunIISummer20UL18MiniAODv2-00000/output'
filein = ('file:' + f for f in (os.path.join(_dirin, f) for f in os.listdir(_dirin)) if os.stat(f).st_size > 1024*1024)

### output root file ###
#   type: str
fileout = 'MiniAnalysisResult.root'
