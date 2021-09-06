class HealthModel {
  int id;
  String name;
  String noncommunicableintro;
  String keyriskfactors;
  String poorlifestyles;
  String healthylifestyles;
  String weightobesity;
  String weightmanagement;
  String weightmanagementrecons;
  String weightmanagementhelp;
  String nutritionintro;
  String foodproduction;
  String foodconsumption;
  String nutrientutilization;
  String posthavest;
  String physicalinactivity;
  String nutrientsources;
  String nutritionandpregnancy;
  String nutritionandhiv;


  String hygieneintro;
  String hygieneimportance;
  String goodhabits;
  String emergencyplanning;
  String selfmaintainace;
  String offensivehabits;
  String support;
  String remember;
  String physicalintro;
  String benefits;

  String created_at;

  HealthModel({

    this.id,
    this.name,
    this.noncommunicableintro,
    this.keyriskfactors,
    this.poorlifestyles,
    this.healthylifestyles,
    this.weightobesity,
    this.weightmanagement,
    this.weightmanagementrecons,
    this.weightmanagementhelp,
    this.nutritionintro,
    this.foodproduction,
    this.foodconsumption,
    this.nutrientutilization,
    this.posthavest,
    this.physicalinactivity,
    this.nutrientsources,
    this.nutritionandpregnancy,
    this.nutritionandhiv,

    this.hygieneintro,
    this.hygieneimportance,
    this.goodhabits,
    this.emergencyplanning,
    this.selfmaintainace,
    this.offensivehabits,
    this.support,
    this.remember,

    this.physicalintro,
    this.benefits,

    this.created_at
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'noncommunicableintro':noncommunicableintro,
      'keyriskfactors':keyriskfactors,
      'poorlifestyles':poorlifestyles,
      'healthylifestyles':healthylifestyles,
      'weightobesity':weightobesity,
      'weightmanagement':weightmanagement,
      'weightmanagementrecons':weightmanagementrecons,
      'weightmanagementhelp':weightmanagementhelp,
      'nutritionintro':nutritionintro,
      'foodproduction':foodproduction,
      'foodconsumption':foodconsumption,
      'nutrientutilization':nutrientutilization,
      'posthavest':posthavest,
      'physicalinactivity':physicalinactivity,
      'nutrientsources':nutrientsources,
      'nutritionandpregnancy':nutritionandpregnancy,
      'nutritionandhiv':nutritionandhiv,

      'hygieneintro':hygieneintro,
      'hygieneimportance':hygieneimportance,
      'goodhabits':goodhabits,
      'emergencyplanning':emergencyplanning,
      'selfmaintainace':selfmaintainace,
      'offensivehabits':offensivehabits,
      'support':support,
      'remember':remember,

      'physicalintro':physicalintro,
      'benefits':benefits,


      'created_at': created_at,
    };
  }


  HealthModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    noncommunicableintro=map['noncommunicableintro'];
    keyriskfactors=map['keyriskfactors'];
    poorlifestyles=map['poorlifestyles'];
    healthylifestyles=map['healthylifestyles'];
    weightobesity=map['weightobesity'];
    weightmanagement=map['weightmanagement'];
    weightmanagementrecons=map['weightmanagementrecons'];
    weightmanagementhelp=map['weightmanagementhelp'];
    nutritionintro=map['nutritionintro'];
    foodproduction=map['foodproduction'];
    foodconsumption=map['foodconsumption'];
    nutrientutilization=map['nutrientutilization'];
    posthavest=map['posthavest'];
    physicalinactivity=map['physicalinactivity'];
    nutrientsources=map['nutrientsources'];
    nutritionandpregnancy=map['nutritionandpregnancy'];
    nutritionandhiv=map['nutritionandhiv'];

    hygieneintro=map['hygieneintro'];
    hygieneimportance=map['hygieneimportance'];
    goodhabits=map['goodhabits'];
    emergencyplanning=map['emergencyplanning'];
    selfmaintainace=map['selfmaintainace'];
    offensivehabits=map['offensivehabits'];
    support=map['support'];
    remember=map['remember'];
    physicalintro=map['physicalintro'];
    benefits=map['benefits'];

    created_at = map['created_at'].toString();
  }

}