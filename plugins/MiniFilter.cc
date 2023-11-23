// -*- C++ -*-
//
// Package:    PhysicsTools/MiniFilter
// Class:      MiniFilter
// 
/**\class MiniFilter MiniFilter.cc PhysicsTools/MiniFilter/plugins/MiniFilter.cc

 Description: Filter MiniAOD samples with specified hard process patterns.

 Implementation:
     Reference: https://twiki.cern.ch/twiki/bin/view/CMSPublic/SWGuideAboutPythonConfigFile
*/
//
// Original Author:  Leyun Gao
//         Created:  Wed, 22 Nov 2023 10:57:57 GMT
//
//


// system include files
#include <stdint.h>
#include <stdlib.h>
#include <memory>
#include <vector>
#include <string>
#include <stdexcept>

// user include files
#include "FWCore/Framework/interface/Frameworkfwd.h"
#include "FWCore/Framework/interface/stream/EDFilter.h"
#include "FWCore/Framework/interface/Event.h"
#include "FWCore/Framework/interface/MakerMacros.h"
#include "FWCore/ParameterSet/interface/ParameterSet.h"
#include "FWCore/Utilities/interface/StreamID.h"
#include "DataFormats/HepMCCandidate/interface/GenParticle.h"

//
// class declaration
//
struct InvalidPattern : std::runtime_error {
  InvalidPattern(const char *pattern)
    : std::runtime_error("invalid pattern: " + std::string(pattern)) { }
};

class PIDMatchPattern {
public:
  explicit PIDMatchPattern(const char *&pattern, bool complete = true);
  explicit PIDMatchPattern(const char *&&pattern, bool complete = true)
    : PIDMatchPattern(pattern, complete) { }

  /*
   * NOTE: The const qualifier is observed after the matching functions
   * return, but may NOT during the matching procedure.
   */
  bool match_current_node(const reco::GenParticle &genpar) const;
  bool match(const edm::View<reco::GenParticle> &genpars) const;
  bool match(const reco::GenParticle &parent) const;
  template<class Iterator> bool match(Iterator b, Iterator e) const;

private:
  int pid_;
  bool use_abs_;
  std::unique_ptr<PIDMatchPattern> children_;
  std::unique_ptr<PIDMatchPattern> next_;
};

PIDMatchPattern::PIDMatchPattern(const char *&pattern, bool complete)
  : pid_(0), use_abs_(false)
{
  /*
   * PATTERN ::= PID | PID(PATTERN) | PATTERN,PATTERN
   * PID ::= [+|-|*]INTEGER
   */
  const char *end;

  // STEP 1: Extract PID.
  if(pattern[0] == '*') { use_abs_ = true; ++pattern; }
  pid_ = strtol(pattern, (char **)&end, 10);
  if(pattern == end) throw InvalidPattern(pattern);
  pattern = end;

  // STEP 2: Extract children.
  if(pattern[0] == '(') {
    children_.reset(new PIDMatchPattern(++pattern, false));
    if(pattern[0] != ')') throw InvalidPattern(pattern);
    ++pattern;
  }

  // STEP 3: Extract next patterns.
  if(pattern[0] == ',') {
    next_.reset(new PIDMatchPattern(++pattern, false));
  }

  // STEP 4: Check terminator.
  if(complete && pattern[0] != 0) throw InvalidPattern(pattern);
}

bool PIDMatchPattern::match_current_node(const reco::GenParticle &genpar) const
{
  int pid = genpar.pdgId();
  if(use_abs_) pid = abs(pid);
  return pid == pid_;
}

template<class Iterator>
bool PIDMatchPattern::match(Iterator b, Iterator e) const
{
  for(Iterator i = b; i != e; ++i) {
    const reco::GenParticle &genpar = dynamic_cast<const reco::GenParticle &>(*i);
    if(match_current_node(genpar)) {
      bool next_matched;
      if(!next_) next_matched = true; else {
        int pdgId = genpar.pdgId();
        const_cast<reco::GenParticle &>(genpar).setPdgId(0);  // mask [XXX]
        next_matched = next_->match(b, e);
        const_cast<reco::GenParticle &>(genpar).setPdgId(pdgId);  // unmask [XXX]
      }
      if(!next_matched) continue;
      if(!children_ || children_->match(genpar)) return true;
    }
  }
  return false;
}

bool PIDMatchPattern::match(const edm::View<reco::GenParticle> &genpars) const
{
  return match(genpars.begin(), genpars.end());
}

bool PIDMatchPattern::match(const reco::GenParticle &parent) const
{
  return match(parent.begin(), parent.end());
}

class MiniFilter : public edm::stream::EDFilter<> {
public:
  explicit MiniFilter(const edm::ParameterSet&);
  ~MiniFilter();

  static void fillDescriptions(edm::ConfigurationDescriptions& descriptions);

private:
  virtual void beginStream(edm::StreamID) override;
  virtual bool filter(edm::Event&, const edm::EventSetup&) override;
  virtual void endStream() override;

  //virtual void beginRun(edm::Run const&, edm::EventSetup const&) override;
  //virtual void endRun(edm::Run const&, edm::EventSetup const&) override;
  //virtual void beginLuminosityBlock(edm::LuminosityBlock const&, edm::EventSetup const&) override;
  //virtual void endLuminosityBlock(edm::LuminosityBlock const&, edm::EventSetup const&) override;

  // ----------member data ---------------------------
  /*
   * An event will be kept if and only if at least one pattern matches its hard-process gen-particles.
   * A PATTERN string serializes a full list of required decay trees.
   *     PATTERN ::= PID | PID(PATTERN) | PATTERN,PATTERN
   *     PID ::= [+|-|*]INTEGER
   * If PID is leaded by an asterisk, the absolute values are taken for matching.
   */
  std::vector<std::string> pattern_strings_;
  std::vector<PIDMatchPattern> patterns_;
  edm::EDGetTokenT<edm::View<reco::GenParticle>> genparsToken_;
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
MiniFilter::MiniFilter(const edm::ParameterSet& iConfig)
  : pattern_strings_(iConfig.getUntrackedParameter<std::vector<std::string>>("patterns"))
  , genparsToken_(consumes<edm::View<reco::GenParticle>>(iConfig.getParameter<edm::InputTag>("genpars")))
{
  // now do what ever initialization is needed
  patterns_.reserve(pattern_strings_.size());
  for(const std::string &pattern : pattern_strings_) {
    patterns_.emplace_back(pattern.c_str());
  }
}


MiniFilter::~MiniFilter()
{
  // do anything here that needs to be done at destruction time
  // (e.g. close files, deallocate resources etc.)
}


//
// member functions
//

// ------------ method called on each new Event  ------------
bool
MiniFilter::filter(edm::Event& iEvent, const edm::EventSetup& iSetup)
{
  using namespace edm;

#ifdef THIS_IS_AN_EVENT_EXAMPLE
  Handle<ExampleData> pIn;
  iEvent.getByLabel("example", pIn);
#endif

#ifdef THIS_IS_AN_EVENTSETUP_EXAMPLE
  ESHandle<SetupData> pSetup;
  iSetup.get<SetupRecord>().get(pSetup);
#endif

  Handle<edm::View<reco::GenParticle>> genpars;
  iEvent.getByToken(genparsToken_, genpars);
  for(const PIDMatchPattern &pattern : patterns_) {
    if(pattern.match(*genpars)) return true;
  }
  return false;
}

// ------------ method called once each stream before processing any runs, lumis or events  ------------
void
MiniFilter::beginStream(edm::StreamID)
{
}

// ------------ method called once each stream after processing all runs, lumis and events  ------------
void
MiniFilter::endStream()
{
}

// ------------ method called when starting to processes a run  ------------
/*
   void
   MiniFilter::beginRun(edm::Run const&, edm::EventSetup const&)
   { 
   }
   */

// ------------ method called when ending the processing of a run  ------------
/*
   void
   MiniFilter::endRun(edm::Run const&, edm::EventSetup const&)
   {
   }
   */

// ------------ method called when starting to processes a luminosity block  ------------
/*
   void
   MiniFilter::beginLuminosityBlock(edm::LuminosityBlock const&, edm::EventSetup const&)
   {
   }
   */

// ------------ method called when ending the processing of a luminosity block  ------------
/*
   void
   MiniFilter::endLuminosityBlock(edm::LuminosityBlock const&, edm::EventSetup const&)
   {
   }
   */

// ------------ method fills 'descriptions' with the allowed parameters for the module  ------------
void
MiniFilter::fillDescriptions(edm::ConfigurationDescriptions& descriptions) {
  // The following says we do not know what parameters are allowed so do no validation
  // Please change this to state exactly what you do use, even if it is no parameters
  edm::ParameterSetDescription desc;
  desc.setUnknown();
  descriptions.addDefault(desc);
}
// define this as a plug-in
DEFINE_FWK_MODULE(MiniFilter);
