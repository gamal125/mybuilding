// ignore_for_file: file_names

class OfferModel{
  String title='';
  double price=0;
  double duration=0;
  String description='';
  String state='';

  OfferModel({
    required this.title ,
    required this.state,
    required this.description,
    required this.duration,
    required this.price,
  });

  OfferModel.fromJson(Map<String,dynamic>json){
    title =json['title'];
    state=json['state'];
    description=json['description'];
    duration=json['duration'];
    price=json['price'];
  }
  Map<String,dynamic> toMap(){
    return{
      'title':title,
      'description':description,
      'state':state,
      'duration':duration,
      'price':price,
    };
  }
}