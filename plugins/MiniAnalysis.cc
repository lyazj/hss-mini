// -*- C++ -*-
//
// Package:    PhysicsTools/MiniAnalysis
// Class:      MiniAnalysis
//
/**\class MiniAnalysis MiniAnalysis.cc PhysicsTools/MiniAnalysis/plugins/MiniAnalysis.cc

 Description: Hss MiniAOD analysis routines.

 Implementation:
     Reference: https://twiki.cern.ch/twiki/bin/view/CMSPublic/WorkBookMiniAOD2017#Examples
*/
//
// Original Author:  Leyun Gao
//         Created:  Fri, 10 Nov 2023 09:46:19 GMT
//
//


// system include files
#include <stdint.h>
#include <stdlib.h>
#include <memory>
#include <iostream>
#include <stdexcept>
#include <TFile.h>
#include <TH1F.h>

// user include files
#include "FWCore/Framework/interface/Frameworkfwd.h"
#include "FWCore/Framework/interface/one/EDAnalyzer.h"
#include "FWCore/Framework/interface/Event.h"
#include "FWCore/Framework/interface/MakerMacros.h"
#include "FWCore/ParameterSet/interface/ParameterSet.h"
#include "FWCore/Utilities/interface/InputTag.h"
#include "DataFormats/PatCandidates/interface/Jet.h"
#include "DataFormats/PatCandidates/interface/PackedCandidate.h"
//
// class declaration
//

// If the analyzer does not use TFileService, please remove
// the template argument to the base class so the class inherits
// from  edm::one::EDAnalyzer<>
// This will improve performance in multithreaded jobs.


class MiniAnalysis : public edm::one::EDAnalyzer<edm::one::SharedResources>  {
public:
  explicit MiniAnalysis(const edm::ParameterSet&);
  ~MiniAnalysis();

  static void fillDescriptions(edm::ConfigurationDescriptions& descriptions);


private:
  virtual void beginJob() override;
  virtual void analyze(const edm::Event&, const edm::EventSetup&) override;
  virtual void endJob() override;

  // ----------member data ---------------------------
  edm::EDGetTokenT<pat::JetCollection> jetsToken_;
  std::string fileout_;
  int32_t partonFlavour_;
  std::shared_ptr<TFile> tfileout_;
  std::shared_ptr<TH1F> histCharge_;
  std::shared_ptr<TH1F> histSrecoPT_;
  std::shared_ptr<TH1F> histSrecoEta_;
  std::shared_ptr<TH1F> histSrecoPhi_;
  std::shared_ptr<TH1F> histSrecoM_;
};

//
// constants, enums and typedefs
//

//
// static data member definitions
//

//
// constructors and destructor
//
MiniAnalysis::MiniAnalysis(const edm::ParameterSet& iConfig)
  : jetsToken_(consumes<pat::JetCollection>(iConfig.getParameter<edm::InputTag>("jets")))
  , fileout_(iConfig.getUntrackedParameter<std::string>("fileout"))
  , partonFlavour_(iConfig.getUntrackedParameter<int32_t>("partonFlavour"))
{
  // now do what ever initialization is needed
  tfileout_.reset(new TFile(fileout_.c_str(), "RECREATE"));
  if(!tfileout_->IsOpen()) {
    throw std::runtime_error("error opening output file " + fileout_);
  }
  histCharge_.reset(new TH1F("histCharge", "Jet PF constituent charge", 50, -2.0, 2.0));
  histSrecoPT_.reset(new TH1F("histSrecoPT", "Strange hadron reconstruction pT", 50, 0.0, 30.0));
  histSrecoEta_.reset(new TH1F("histSrecoEta", "Strange hadron reconstruction eta", 50, -4.0, 4.0));
  histSrecoPhi_.reset(new TH1F("histSrecoPhi", "Strange hadron reconstruction phi", 50, -4.0, 4.0));
  histSrecoM_.reset(new TH1F("histSrecoM", "Strange hadron reconstruction mass", 50, 0.0, 1.0));
}


MiniAnalysis::~MiniAnalysis()
{
  // do anything here that needs to be done at desctruction time
  // (e.g. close files, deallocate resources etc.)
  tfileout_->cd();
  histCharge_->Write();
  histSrecoPT_->Write();
  histSrecoEta_->Write();
  histSrecoPhi_->Write();
  histSrecoM_->Write();
}


//
// member functions
//

// ------------ method called for each event  ------------
void
MiniAnalysis::analyze(const edm::Event& iEvent, const edm::EventSetup& iSetup)
{
  using namespace edm;

  Handle<pat::JetCollection> jets;
  iEvent.getByToken(jetsToken_, jets);

  for(const pat::Jet &jet : *jets) {
    if(partonFlavour_ > 0 && abs(jet.partonFlavour()) != partonFlavour_) continue;
    unsigned nd = jet.numberOfDaughters();
    float weight = 2.0f / (nd * (nd - 1));
    for(unsigned int id = 0; id < nd; ++id) {
      const pat::PackedCandidate &pfi = dynamic_cast<const pat::PackedCandidate &>(*jet.daughter(id));
      histCharge_->Fill(pfi.charge());
      for(unsigned int jd = id + 1; jd < nd; ++jd) {
        const pat::PackedCandidate &pfj = dynamic_cast<const pat::PackedCandidate &>(*jet.daughter(jd));
        auto p4 = pfi.p4() + pfj.p4();
        histSrecoPT_->Fill(p4.Pt(), weight);
        histSrecoEta_->Fill(p4.Eta(), weight);
        histSrecoPhi_->Fill(p4.Phi(), weight);
        histSrecoM_->Fill(p4.M(), weight);
      }
    }
  }

#ifdef THIS_IS_AN_EVENTSETUP_EXAMPLE
  ESHandle<SetupData> pSetup;
  iSetup.get<SetupRecord>().get(pSetup);
#endif
}


// ------------ method called once each job just before starting event loop  ------------
void
MiniAnalysis::beginJob()
{
}

// ------------ method called once each job just after ending the event loop  ------------
void
MiniAnalysis::endJob()
{
}

// ------------ method fills 'descriptions' with the allowed parameters for the module  ------------
void
MiniAnalysis::fillDescriptions(edm::ConfigurationDescriptions& descriptions) {
  //The following says we do not know what parameters are allowed so do no validation
  // Please change this to state exactly what you do use, even if it is no parameters
  edm::ParameterSetDescription desc;
  desc.setUnknown();
  descriptions.addDefault(desc);

  //Specify that only 'tracks' is allowed
  //To use, remove the default given above and uncomment below
  //ParameterSetDescription desc;
  //desc.addUntracked<edm::InputTag>("tracks","ctfWithMaterialTracks");
  //descriptions.addDefault(desc);
}

//define this as a plug-in
DEFINE_FWK_MODULE(MiniAnalysis);
