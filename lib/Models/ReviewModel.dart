// ignore_for_file: file_names

class ReviewModel{

  String name='';
  String description='';
  String id='';

  String image='';

  double rate=0;



  ReviewModel({

    required this.name,
    required this.description ,
    required this.id,
    required this.image,

    required this.rate,


  });

  ReviewModel.fromJson(Map<String,dynamic>json){
    name=json['name'];
    description =json['description'];
    id=json['id'];
    image=json['image'];

    rate=json['rate'];









  }
  Map<String,dynamic> toMap(){
    return{
      'name':name,
      'description':description,
      'image':image,
      'id':id,

      'rate':rate,








    };
  }


}