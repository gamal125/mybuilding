// ignore_for_file: file_names

class UserModel{
  String email='';
  String uId='';
  String firstName='';
  String lastName='';
  String phone='';
  String image='';
  String userRole='';
  String address='';
  String major='';

  double rate=0;
  double cash=0;


  UserModel({



    required this.firstName,
    required this.lastName,
    required this.rate,
    required this.cash,
    required this.uId,
    required this.image,
    required this.userRole,
    required this.phone,
    required this.email,
    required this.major,
    required this.address,



  });

  UserModel.fromJson(Map<String,dynamic>json){
    firstName=json['firstName'];
    lastName=json['lastName'];
    phone=json['phone'];
    email=json['email'];
    uId=json['uId'];
    image=json['image'];
    userRole=json['userRole'];
    address=json['address'];
    major=json['major'];
    rate=json['rate'];
    cash=json['cash'];







  }
  Map<String,dynamic> toMap(){
    return{
      'firstName':firstName,
      'lastName':lastName,
      'phone':phone,
      'email':email,
      'uId':uId,
      'image':image,
      'address':address,
      'userRole':userRole,
      'major':major,
      'rate':rate,
      'cash':cash,







    };
  }


}