// ignore_for_file: file_names

class ProductModel{

  String name='';
  String description='';
  String id='';
  String tenantId='';  String myTenantId='';

  String image='';
  bool available=true;
  double rate=0;
  double price=0;


  ProductModel({

    required this.name,
    required this.description ,
    required this.id,
    required this.tenantId,
    required this.image,
    required this.available,
    required this.rate,
    required this.price,  required this.myTenantId,

  });

  ProductModel.fromJson(Map<String,dynamic>json){
    name=json['name'];
    description =json['description'];
    id=json['id'];
    image=json['image'];
    available=json['available'];
    rate=json['rate'];
    price=json['price'];
    tenantId=json['tenantId'];
    myTenantId=json['myTenantId'];








  }
  Map<String,dynamic> toMap(){
    return{
      'name':name,
      'description':description,
      'image':image,
      'id':id,
      'available':available,
      'rate':rate,
      'price':price,
      'tenantId':tenantId,
      'myTenantId':myTenantId,







    };
  }


}