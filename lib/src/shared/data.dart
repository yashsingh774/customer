import 'package:foodexpress/models/speciality.dart';
import 'package:flutter/cupertino.dart';

List<SpecialityModel> getSpeciality(){

  List<SpecialityModel> specialities = new List<SpecialityModel>();
  SpecialityModel specialityModel = new SpecialityModel();

  //1
  
  specialityModel.speciality = "Groccery";
  specialityModel.imgAssetPath = "assets/images/1.jpg";
  specialityModel.backgroundColor = Color(0xffFBB97C);
  specialities.add(specialityModel);

  specialityModel = new SpecialityModel();

  //2
  specialityModel.speciality = "Cothes";
  specialityModel.imgAssetPath = "assets/images/2.jpg";
  specialityModel.backgroundColor = Color(0xffF69383);
  specialities.add(specialityModel);

  specialityModel = new SpecialityModel();

  //3
  
  specialityModel.speciality = "Medical";
  specialityModel.imgAssetPath = "assets/images/3.jpg";
  specialityModel.backgroundColor = Color(0xffEACBCB);
  specialities.add(specialityModel);

  specialityModel = new SpecialityModel();

  return specialities;
}