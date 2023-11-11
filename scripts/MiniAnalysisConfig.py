import os

### Maximum number of entries to process ###
#   type: int
nevent = int(os.getenv('NEVENT')) or -1

### input root file list ###
#   type: iterable
#   note: Prefix 'file:' should be used to mark a local path.
filein = os.getenv('FILEIN').split(',')

### output root file ###
#   type: str
fileout = os.getenv('FILEOUT') or 'file:MiniAnalysisResult.root'
