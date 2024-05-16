// ignore_for_file: file_names

class StoreModel{
  String id='';
  String storeName='';
  String phone='';
  String image='';
  String address='';
  double rate=0;


  StoreModel({




    required this.rate,
    required this.image,
    required this.phone,
    required this.id,
    required this.storeName,
    required this.address,



  });

  StoreModel.fromJson(Map<String,dynamic>json){
    storeName=json['storeName'];
    phone=json['phone'];
    id=json['id'];
    image=json['image'];
    address=json['address'];
    rate=json['rate'];








  }
  Map<String,dynamic> toMap(){
    return{
      'storeName':storeName,
      'phone':phone,
      'id':id,
      'image':image,
      'address':address,
      'rate':rate,








    };
  }


}