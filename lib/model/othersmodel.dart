class OthersModel {
  int id;
  String name;
  String introduction;
  String seventips;
  String savingmoney;
  String takeaction;
  String moneysavingtips;
  String earnextracoin;
  String gratuationjob;
  String careerresourses;
  String internships;
  String cvletter;
  String professionaljobs;
  String alumni;
  String recentgratuates;
  String createopportunities;

  String created_at;

  OthersModel({

    this.id,
    this.name,
    this.introduction,
    this.seventips,
    this.savingmoney,
    this.takeaction,
    this.moneysavingtips,
    this.earnextracoin,
    this.gratuationjob,
    this.careerresourses,
    this.internships,
    this.cvletter,
    this.professionaljobs,
    this.alumni,
    this.recentgratuates,
    this.createopportunities,
    this.created_at
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'introduction':introduction,
      'seventips':seventips,
      'savingmoney':savingmoney,
      'takeaction':takeaction,
      'moneysavingtips':moneysavingtips,
      'earnextracoin':earnextracoin,
      'gratuationjob':gratuationjob,
      'careerresourses':careerresourses,
      'internships':internships,
      'cvletter':cvletter,
      'professionaljobs':professionaljobs,
      'alumni':alumni,

      'recentgratuates':recentgratuates,
      'createopportunities':createopportunities,


      'created_at': created_at,
    };
  }


  OthersModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    introduction=map['introduction'];
    seventips=map['seventips'];
    savingmoney=map['savingmoney'];
    takeaction=map['takeaction'];
    moneysavingtips=map['moneysavingtips'];
    earnextracoin=map['earnextracoin'];
    gratuationjob=map['gratuationjob'];
    careerresourses=map['careerresourses'];
    internships=map['internships'];
    cvletter=map['cvletter'];
    professionaljobs=map['professionaljobs'];
    alumni=map['alumni'];

    recentgratuates=map['recentgratuates'];
    createopportunities=map['createopportunities'];

    created_at = map['created_at'].toString();
  }

}