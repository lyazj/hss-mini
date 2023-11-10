import os

### Maximum number of entries to process ###
#   type: int
nevent = os.getenv('NEVENT') or -1

### input root file list ###
#   type: iterable
#   note: Prefix 'file:' should be used to mark a local path.
filein = os.getenv('FILEIN')

### output root file ###
#   type: str
fileout = os.getenv('FILEOUT') or 'MiniAnalysisResult.root'
