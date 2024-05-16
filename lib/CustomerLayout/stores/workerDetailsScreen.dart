// ignore_for_file: file_names

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enginner/Componant/Componant.dart';
import 'package:enginner/Cubit/AppCubit.dart';
import 'package:enginner/Models/ReviewModel.dart';
import 'package:enginner/Models/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class WorkerDetailsScreen extends StatefulWidget {
  const WorkerDetailsScreen({super.key,required this.model,required this.haveOrder});
final UserModel model;
final bool haveOrder;

  @override
  State<WorkerDetailsScreen> createState() => _WorkerDetailsScreenState();
}

class _WorkerDetailsScreenState extends State<WorkerDetailsScreen> {
  final  formKey2 = GlobalKey<FormState>();
  double ratingvalue=3.0;
  final review = TextEditingController();
  List<ReviewModel> reviews=[];
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("Profile",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
        centerTitle: true,
      ),
      body: Column(
        children: [




          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Container(
                width:MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.4,
                decoration: BoxDecoration(image:widget.model.image==''?
                const DecorationImage(image: AssetImage('assets/images/1.jpg'),fit: BoxFit.fill):
                DecorationImage(image: NetworkImage(widget.model.image),fit: BoxFit.fill)

                ),

              ),

              Container(
                alignment: AlignmentDirectional.centerStart,
                width:MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.12,
                decoration: BoxDecoration(

                  color: Colors.black.withOpacity(0.4),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text("${widget.model.firstName} ${widget.model.lastName}",style: TextStyle(fontWeight: FontWeight.bold,fontSize:MediaQuery.of(context).size.width*0.06,color: Colors.white ),)),
                          Text(widget.model.major,style: TextStyle(fontWeight: FontWeight.bold,fontSize:MediaQuery.of(context).size.width*0.04,color: Colors.white ),),

                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: Text(widget.model.phone,style: TextStyle(fontWeight: FontWeight.bold,fontSize:MediaQuery.of(context).size.width*0.06,color: Colors.white ),)),
                          Text(widget.model.address,style: TextStyle(fontWeight: FontWeight.bold,fontSize:MediaQuery.of(context).size.width*0.04,color: Colors.white ),),

                        ],
                      ),

                    ],),
                ),
              )

            ],
          ),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Reviews'),
            widget.haveOrder?    defaultReviewButton(function: (){
                  AwesomeDialog(
                    body:    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Form(
                        key: formKey2,
                        child: Column(
                          children: [

                            RatingBar.builder(
                              initialRating: 3,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {
                                ratingvalue=rating;
                              },
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text('Add Review'),
                            const SizedBox(
                              height: 5,
                            ),
                            defaultTextFormField(
                              onTap: (){
                              },
                              controller: review,
                              keyboardType: TextInputType.text,
                              prefix: Icons.edit,
                              validate: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Please enter Review';
                                }
                                return null;
                              },
                              label: 'Review',
                              hint: 'Enter your Review',
                            ),
                          ],
                        ),
                      ),
                    ),
                    context: context,
                    dialogType: DialogType.warning,
                    animType: AnimType.rightSlide,

                    btnCancelOnPress: () {

                    },
                    btnCancelText: 'لا',
                    btnOkText: 'نعم',
                    btnOkOnPress: () {
                      if(formKey2.currentState!.validate()){
                        if(      AppCubit.get(context).user!=null  ) {
                          var model= ReviewModel(name: AppCubit.get(context).user!.firstName+ AppCubit.get(context).user!.lastName ,
                            description: review.text,
                            id: AppCubit.get(context).user!.uId,
                            image: AppCubit.get(context).user!.image,
                            rate: ratingvalue);
                          double totalrate=ratingvalue;
                          if(reviews.isNotEmpty){
                            for (var element in reviews) { totalrate+=element.rate;}
                            double total=totalrate/(reviews.length+1);
                            FirebaseFirestore.instance.collection('users').doc(widget.model.uId).collection('reviews').doc(AppCubit.get(context).user!.uId).set(
                                model.toMap()
                            );
                            FirebaseFirestore.instance.collection('users').doc(widget.model.uId).update(
                                {'rate':total}
                            );
                          }else{

                          FirebaseFirestore.instance.collection('users').doc(widget.model.uId).collection('reviews').doc(AppCubit.get(context).user!.uId).set(
                              model.toMap()
                          );
                          FirebaseFirestore.instance.collection('users').doc(widget.model.uId).update(
                              {'rate':ratingvalue}
                          );
                        }
                        }

                      }
                    },
                  ).show();
                }, text: 'Add Review', context: context,color: Colors.green):const SizedBox()
              ],),
          ),
          Expanded(child:
          StreamBuilder<QuerySnapshot>(
              stream:FirebaseFirestore.instance.collection('users').doc(widget.model.uId).collection('reviews').snapshots(),
              builder: (context,snapshot){
                if(snapshot.data!=null){
                  reviews.clear();
                  for (var doc in snapshot.data!.docs) {

                      final model = ReviewModel(

                        name:doc['name'],
                        id:doc['id'],
                        image:doc['image'],
                        rate:doc['rate'],
                        description:doc['description'],


                      );
                      reviews.add(model);

                  }}
                return snapshot.data!=null?
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {return reviewWidget(reviews[index],);  },
                    itemCount: reviews.length,

                  ),
                ):const SizedBox();
              }

          ),
          )
        ],
      ),
    );
  }
  Widget reviewWidget(ReviewModel model)=>Padding(
    padding: const EdgeInsets.all(8.0),
    child: SizedBox(
      height: MediaQuery.of(context).size.height*0.13,
      width: MediaQuery.of(context).size.width*0.9,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                model.image!=''?


                CircleAvatar(backgroundImage: NetworkImage(model.image),radius: 30,):
                const CircleAvatar(backgroundImage: AssetImage('assets/images/1.jpg'),radius: 30,),

                Text(model.name),
              ],),

              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (index) {
                  if (index < model.rate.floor()) {
                    return const Icon(Icons.star, color: Colors.orange,size: 12,);
                  } else if (index <  model.rate.ceil()) {
                    return const Icon(Icons.star_half, color: Colors.orange,size: 12,);
                  } else {
                    return const Icon(Icons.star_border, color: Colors.orange,size: 12,);
                  }
                }),
              ),
          ],),
          Expanded(child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(model.description,maxLines: 3,overflow: TextOverflow.ellipsis,),
            ),
          ))

        ],
      ),
    ),
  );
}
