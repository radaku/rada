class Reproductive {
  int id;
  String name;
  String contraceptionintroduction;
  String methods;
  String condomswork;
  String injectable;
  String oralpill;
  String iucds;
  String implants;
  String emergency;
  String contraceptionvideo;
  String know;
  String boyfriend;
  String night;
  String casual;
  String sponsor;
  String dyn1;
  String sponsorvideo;
  String pregnancydyn;
  String pregnancycauses;
  String pregnancysigns;
  String stiintroduction;
  String pregnancytest;
  String prenatalcare;
  String antinetalcare;
  String postnatal;
  String pregnancynutrition;
  String pregnancydanger;
  String riskfactors;
  String stitypes;
  String stisigns;
  String commonstisigns;
  String treatment;
  String protectiontips;
  String facts;
  String myths;
  String stisharm;
  String hivsti;
  String created_at;

  Reproductive(
      {this.id,
      this.name,
      this.contraceptionintroduction,
      this.methods,
      this.condomswork,
      this.injectable,
      this.oralpill,
      this.iucds,
      this.implants,
      this.emergency,
      this.contraceptionvideo,
      this.know,
      this.boyfriend,
      this.night,
      this.casual,
      this.sponsor,
      this.dyn1,
      this.sponsorvideo,
      this.pregnancydyn,
      this.pregnancycauses,
      this.pregnancysigns,
      this.stiintroduction,
      this.pregnancytest,
      this.prenatalcare,
      this.antinetalcare,
      this.postnatal,
      this.pregnancynutrition,
      this.pregnancydanger,
      this.riskfactors,
      this.stitypes,
      this.stisigns,
      this.commonstisigns,
      this.treatment,
      this.protectiontips,
      this.facts,
      this.myths,
      this.stisharm,
      this.hivsti,
      this.created_at});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'contraceptionintroduction': contraceptionintroduction,
      'methods': methods,
      'condomswork': condomswork,
      'injectable': injectable,
      'oralpill': oralpill,
      'iucds': iucds,
      'implants': implants,
      'emergency': emergency,
      'contraceptionvideo': contraceptionvideo,
      'know': know,
      'boyfriend': boyfriend,
      'night': night,
      'casual': casual,
      'sponsor': sponsor,
      'dyn1': dyn1,
      'sponsorvideo': sponsorvideo,
      'pregnancydyn': pregnancydyn,
      'pregnancycauses': pregnancycauses,
      'pregnancysigns': pregnancysigns,
      'pregnancytest': pregnancytest,
      'prenatalcare': prenatalcare,
      'postnatal': postnatal,
      'antinetalcare': antinetalcare,
      'pregnancynutrition': pregnancynutrition,
      'stiintroduction': stiintroduction,
      'pregnancydanger': pregnancydanger,
      'riskfactors': riskfactors,
      'stitypes': stitypes,
      'stisigns': stisigns,
      'commonstisigns': commonstisigns,
      'treatment': treatment,
      'protectiontips': protectiontips,
      'facts': facts,
      'myths': myths,
      'stisharm': stisharm,
      'hivsti': hivsti,
      'created_at': created_at,
    };
  }

  Reproductive.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    contraceptionintroduction = map['contraceptionintroduction'];
    methods = map['methods'];
    condomswork = map['condomswork'];
    injectable = map['injectable'];
    oralpill = map['oralpill'];
    iucds = map['iucds'];
    implants = map['implants'];
    emergency = map['emergency'];
    contraceptionvideo = map['contraceptionvideo'];

    know = map['know'];
    boyfriend = map['boyfriend'];
    night = map['night'];
    casual = map['casual'];
    sponsor = map['sponsor'];
    dyn1 = map['dyn1'];
    sponsorvideo = map['sponsorvideo'];
    pregnancydyn = map['pregnancydyn'];
    pregnancycauses = map['pregnancycauses'];
    pregnancysigns = map['pregnancysigns'];
    stiintroduction = map['stiintroduction'];

    pregnancytest = map['pregnancytest'];
    prenatalcare = map['prenatalcare'];
    postnatal = map['postnatal'];
    antinetalcare = map['antinetalcare'];
    pregnancynutrition = map['pregnancynutrition'];
    pregnancydanger = map['pregnancydanger'];
    riskfactors = map['riskfactors'];
    stitypes = map['stitypes'];
    stisigns = map['stisigns'];
    commonstisigns = map["commonstisigns"];
    treatment = map["treatment"];
    protectiontips = map['protectiontips'];
    facts = map["facts"];
    myths = map['myths'];
    stisharm = map['stisharm'];
    hivsti = map['hivsti'];

    created_at = map['created_at'].toString();
  }
}
