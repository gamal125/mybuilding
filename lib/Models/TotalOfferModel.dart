// ignore_for_file: file_names

class TotalOfferModel{
  double totalPrice=0;
  double totalDays=0;
  double workerRate=0;
  String name='';
  String id='';
  String image='';
  String phone='';
  String state='';







  TotalOfferModel({

    required this.name,
    required this.phone ,
    required this.id,
    required this.image,
    required this.totalDays,
    required this.workerRate,
    required this.totalPrice, required this.state,

  });

  TotalOfferModel.fromJson(Map<String,dynamic>json){
    name=json['name'];
    phone =json['phone'];
    id=json['id'];
    image=json['image'];
    totalDays=json['totalDays'];
    workerRate=json['workerRate'];
    totalPrice=json['totalPrice'];
    state=json['state'];








  }
  Map<String,dynamic> toMap(){
    return{
      'name':name,
      'phone':phone,
      'image':image,
      'id':id,
      'totalDays':totalDays,
      'workerRate':workerRate,
      'totalPrice':totalPrice,
      'state':state,







    };
  }


}