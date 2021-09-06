class DrugsModel {
  int id;
  String name;
  String alcoholintroduction;
  String alcoholismsigns;
  String associatedhealthissues;
  String alcoholismtreatment;
  String alcoholismhelp;
  String alcoholhelpcontacts;
  String alcoholvideo;
  String heroineintro;
  String heroineeffects;
  String heroineinjection;
  String heroinerecovery;
  String heroinefurtherhelp;
  String weedintro;
  String weedmyths;
  String weedfacts;
  String quitweed;
  String weednote;
  String weedfaq;
  String weedhelp;
  String weeddyn;
  String created_at;

  DrugsModel(
      {this.id,
      this.name,
      this.alcoholintroduction,
      this.alcoholismsigns,
      this.associatedhealthissues,
      this.alcoholismtreatment,
      this.alcoholismhelp,
      this.alcoholhelpcontacts,
      this.alcoholvideo,
      this.heroineintro,
      this.heroineeffects,
      this.weedmyths,
      this.weedfacts,
      this.quitweed,
      this.weednote,
      this.weedintro,
      this.weedfaq,
      this.weedhelp,
      this.heroineinjection,
      this.heroinerecovery,
      this.heroinefurtherhelp,
      this.weeddyn,
      this.created_at});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'alcoholintroduction': alcoholintroduction,
      'alcoholismsigns': alcoholismsigns,
      'associatedhealthissues': associatedhealthissues,
      'alcoholismtreatment': alcoholismtreatment,
      'alcoholismhelp': alcoholismhelp,
      'alcoholhelpcontacts': alcoholhelpcontacts,
      'alcoholvideo': alcoholvideo,
      'heroineintro': heroineintro,
      'heroineeffects': heroineeffects,
      'heroineinjection': heroineinjection,
      'heroinerecovery': heroinerecovery,
      'heroinefurtherhelp': heroinefurtherhelp,
      'weedintro': weedintro,
      'weedmyths': weedmyths,
      'weedfacts': weedfacts,
      'quitweed': quitweed,
      'weednote': weednote,
      'weedfaq': weedfaq,
      'weedhelp': weedhelp,
      'weeddyn': weeddyn,
      'created_at': created_at,
    };
  }

  DrugsModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    alcoholintroduction = map['alcoholintroduction'];
    alcoholismsigns = map['alcoholismsigns'];
    associatedhealthissues = map['associatedhealthissues'];
    alcoholismtreatment = map['alcoholismtreatment'];
    alcoholismhelp = map['alcoholismhelp'];
    alcoholhelpcontacts = map['alcoholhelpcontacts'];
    alcoholvideo = map['alcoholvideo'];
    heroineintro = map['heroineintro'];
    heroineeffects = map['heroineeffects'];
    heroineinjection = map['heroineinjection'];
    heroinerecovery = map['heroinerecovery'];
    heroinefurtherhelp = map['heroinefurtherhelp'];
    weedintro = map['weedintro'];
    weedmyths = map['weedmyths'];
    weedfacts = map['weedfacts'];
    quitweed = map['quitweed'];
    weednote = map['weednote'];
    weedfaq = map['weedfaq'];
    weedhelp = map['weedhelp'];
    weeddyn = map['weeddyn'];
    created_at = map['created_at'].toString();
  }
}
