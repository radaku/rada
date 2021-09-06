class MentalModel {
  int id;
  String name;
  String mentaldef;
  String mentalilldef;
  String riskfactors;
  String disorders;
  String suicideprevention;
  String suicidehelp;
  String suicidevideo;
  String eatingdisordersinto;
  String anorexia;
  String bulimia;
  String biengeeating;
  String eatinghelp;
  String mentalhelpintro;
  String psychotherapy;
  String medication;
  String selfhelp;
  String created_at;

  MentalModel({this.id, this.name,this.mentaldef,
    this.mentalilldef,this.riskfactors,this.disorders,this.suicideprevention,this.suicidehelp,
    this.suicidevideo,this.eatingdisordersinto,this.anorexia,this.bulimia,this.biengeeating,this.eatinghelp,this.mentalhelpintro,
    this.psychotherapy,
    this.medication,
    this.selfhelp,
    this.created_at});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'mentaldef':mentaldef,
      'mentalilldef':mentalilldef,
      'riskfactors':riskfactors,
      'disorders':disorders,
      'suicideprevention':suicideprevention,
      'suicidehelp':suicidehelp,
      'suicidevideo':suicidevideo,
      'eatingdisordersinto':eatingdisordersinto,
      'anorexia':anorexia,
      'bulimia':bulimia,
      'biengeeating':biengeeating,
      'eatinghelp':eatinghelp,
      'mentalhelpintro':mentalhelpintro,
      'psychotherapy':psychotherapy,
      'medication':medication,
      'selfhelp':selfhelp,
      'created_at': created_at,
    };
  }


  MentalModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    mentaldef=map['mentaldef'];
    mentalilldef=map['mentalilldef'];
    riskfactors=map['riskfactors'];
    disorders=map['disorders'];
    suicideprevention=map['suicideprevention'];
    suicidehelp=map['suicidehelp'];
    suicidevideo=map['suicidevideo'];
    eatingdisordersinto=map['eatingdisordersinto'];
    anorexia=map['anorexia'];
    bulimia=map['bulimia'];
    biengeeating=map['biengeeating'];
    eatinghelp=map['eatinghelp'];
    mentalhelpintro=map['mentalhelpintro'];
    psychotherapy=map['psychotherapy'];
    medication=map['medication'];
    selfhelp=map['selfhelp'];
    created_at = map['created_at'].toString();
  }

}