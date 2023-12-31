# usage: cmsRun MiniAnalysis.py

import MiniAnalysisConfig
import FWCore.ParameterSet.Config as cms

process = cms.Process('MiniAnalysis')
process.load('FWCore.MessageService.MessageLogger_cfi')
process.maxEvents = cms.untracked.PSet(input=cms.untracked.int32(MiniAnalysisConfig.nevent))
process.source = cms.Source('PoolSource', fileNames=cms.untracked.vstring(*MiniAnalysisConfig.filein), duplicateCheckMode=cms.untracked.string("noDuplicateCheck"))
process.analyzer = cms.EDAnalyzer('MiniAnalysis',
    jets=cms.InputTag('slimmedJets'),
    genpars=cms.InputTag('prunedGenParticles'),
    partonFlavour=cms.untracked.int32(MiniAnalysisConfig.partonFlavour),
    fileout=cms.untracked.string(MiniAnalysisConfig.fileout),
)
process.p = cms.Path(process.analyzer)
