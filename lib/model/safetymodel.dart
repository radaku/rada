class SafetyModel {
  int id;
  String name;
  String safedating;
  String datingrules;
  String formen;
  String forladies;
  String datingtips;
  String gbv;
  String cybercrimes;
  String safetytips;
  String gbvintro;
  String prominentplaces;
  String protectyourself;
  String gbveffects;
  String gettinghelp;
  String campussafety;
  String campussafetytips;
  String cybercrimesintro;
  String cybercrimestips;
  String cybercrimestypes;
  String cyberlaws;
  String socialmediabenefits;
  String socialmediapitfalls;
  String socialmediarules;
  String socialmediasafety;
  String created_at;

  SafetyModel({this.id, this.name,this.safedating,
    this.datingrules,this.formen,this.forladies,this.datingtips,this.gbv,
    this.cybercrimes,this.safetytips,this.gbvintro,this.prominentplaces,this.protectyourself,this.gbveffects,this.gettinghelp,
    this.campussafety,
    this.campussafetytips,
    this.cybercrimesintro,
    this.cybercrimestips,
    this.cyberlaws,
    this.cybercrimestypes,
    this.socialmediasafety,
    this.socialmediarules,
    this.socialmediapitfalls,
    this.socialmediabenefits,
    this.created_at});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'safedating':safedating,
      'datingrules':datingrules,
      'formen':formen,
      'forladies':forladies,
      'safetytips':safetytips,
      'gbvintro':gbvintro,
      'prominentplaces':prominentplaces,
      'protectyourself':protectyourself,
      'gbveffects':gbveffects,
      'gettinghelp':gettinghelp,
      'campussafety':campussafety,
      'campussafetytips':campussafetytips,
      'cybercrimesintro':cybercrimesintro,
      'cybercrimestips':cybercrimestips,
      'cyberlaws':cyberlaws,
      'cybercrimestypes':cybercrimestypes,
      'socialmediasafety':socialmediasafety,
      'socialmediarules':socialmediarules,
      'socialmediapitfalls':socialmediapitfalls,
      'socialmediabenefits':socialmediabenefits,

      'created_at': created_at,
    };
  }


  SafetyModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    safedating=map['safedating'];
    datingrules=map['datingrules'];
    formen=map['formen'];
    forladies=map['forladies'];
    //datingtips=map['datingtips'];
    gbv=map['gbv'];
    cybercrimesintro=map['cybercrimesintro'];
    cybercrimestips=map['cybercrimestips'];
    cyberlaws=map['cyberlaws'];
    cybercrimestypes=map['cybercrimestypes'];
    socialmediasafety=map['socialmediasafety'];

    socialmediarules=map['socialmediarules'];
    socialmediapitfalls=map['socialmediapitfalls'];
    socialmediabenefits=map['socialmediabenefits'];
    safetytips=map['safetytips'];
    gbvintro=map['gbvintro'];
    prominentplaces=map['prominentplaces'];
    protectyourself=map['protectyourself'];
    gbveffects=map['gbveffects'];
    gettinghelp=map['gettinghelp'];
    campussafety=map['campussafety'];
    campussafetytips=map["campussafetytips"];
    created_at = map['created_at'].toString();
  }

}