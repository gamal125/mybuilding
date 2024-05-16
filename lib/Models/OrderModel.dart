// ignore_for_file: file_names

class OrderModel{
  String type='';
  String orderId='';
  String publisherId='';
  String publisherPhone='';
  String publisherName='';
  String publisherImage='';
  String orderImage='';
  String state='';
  String description='';
  String address='';


  OrderModel({

    required this.type,
    required this.orderId ,
    required this.publisherId,
    required this.publisherPhone,
    required this.publisherName,
    required this.publisherImage,
    required this.orderImage,
    required this.state,
    required this.description,
    required this.address,

  });

  OrderModel.fromJson(Map<String,dynamic>json){
    type=json['type'];
    orderId =json['orderId'];
    publisherId=json['publisherId'];
    publisherPhone=json['publisherPhone'];
    publisherName=json['publisherName'];
    publisherImage=json['publisherImage'];
    orderImage=json['orderImage'];
    state=json['state'];
    description=json['description'];
    address=json['address'];

  }
  Map<String,dynamic> toMap(){
    return{
      'type':type,
      'orderId':orderId,
      'publisherId':publisherId,
      'publisherPhone':publisherPhone,
      'publisherName':publisherName,
      'publisherImage':publisherImage,
      'orderImage':orderImage,
      'state':state,
      'description':description,
      'address':address,







    };
  }


}