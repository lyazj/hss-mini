# usage: cmsRun MiniAnalysis.py

import MiniAnalysisConfig
import FWCore.ParameterSet.Config as cms

process = cms.Process('MiniAnalysis')
process.load('FWCore.MessageService.MessageLogger_cfi')
process.maxEvents = cms.untracked.PSet(input=cms.untracked.int32(MiniAnalysisConfig.nevent))
process.source = cms.Source('PoolSource', fileNames=cms.untracked.vstring(*MiniAnalysisConfig.filein))
process.analyzer = cms.EDAnalyzer('MiniAnalysis', jets=cms.InputTag('slimmedJets'))
process.p = cms.Path(process.analyzer)
