# usage: cmsRun MiniFilter.py

import MiniFilterConfig
import FWCore.ParameterSet.Config as cms

process = cms.Process('MiniFilter')
process.load('FWCore.MessageService.MessageLogger_cfi')
process.maxEvents = cms.untracked.PSet(input=cms.untracked.int32(MiniFilterConfig.nevent))
process.source = cms.Source('PoolSource',
    fileNames=cms.untracked.vstring(*MiniFilterConfig.filein),
    duplicateCheckMode=cms.untracked.string("noDuplicateCheck"),
)
process.destination = cms.OutputModule('PoolOutputModule',
    SelectEvents=cms.untracked.PSet(SelectEvents=cms.vstring('p')),
    fileName=cms.untracked.string(MiniFilterConfig.fileout),
)
process.filter = cms.EDFilter('MiniFilter',
    genpars=cms.InputTag('prunedGenParticles'),
    patterns=cms.untracked.vstring(*MiniFilterConfig.patterns),
    reverse=cms.untracked.bool(MiniFilterConfig.reverse),
)
process.p = cms.Path(process.filter)
process.outpath = cms.EndPath(process.destination)
