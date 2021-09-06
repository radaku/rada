class HivModel {
  int id;
  String name;
  String kenyahiv;
  String definition;
  String hivsymptoms;
  String transmissionmodes;
  String nottransmitted;
  String hivmyths;
  String hivprevention;
  String mothertochild;
  String hivstigma;
  String created_at;

  HivModel(
      {this.id,
      this.name,
      this.kenyahiv,
      this.definition,
      this.hivsymptoms,
      this.transmissionmodes,
      this.nottransmitted,
      this.hivmyths,
      this.hivprevention,
      this.mothertochild,
      this.hivstigma,
      this.created_at});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'kenyahiv': kenyahiv,
      'definition': definition,
      'hivsymptoms': hivsymptoms,
      'transmissionmodes': transmissionmodes,
      'nottransmitted': nottransmitted,
      'hivmyths': hivmyths,
      'hivprevention': hivprevention,
      'mothertochild': mothertochild,
      'hivstigma': hivstigma,
      'created_at': created_at,
    };
  }

  HivModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    kenyahiv = map['kenyahiv'];
    definition = map['definition'];
    hivsymptoms = map['hivsymptoms'];
    nottransmitted = map['nottransmitted'];
    transmissionmodes = map['transmissionmodes'];
    hivmyths = map['hivmyths'];
    hivprevention = map['hivprevention'];
    mothertochild = map['mothertochild'];
    hivstigma = map['hivstigma'];
    created_at = map['created_at'].toString();
  }
}
