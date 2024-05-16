// ignore_for_file: file_names

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enginner/Componant/Componant.dart';
import 'package:enginner/Componant/cache_helper.dart';
import 'package:enginner/Cubit/AppCubit.dart';
import 'package:enginner/CustomerLayout/CustomerLayout.dart';
import 'package:enginner/Models/ProductModel.dart';
import 'package:enginner/Models/ReviewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key,required this.model,required this.id,required this.tenanted});
  final ProductModel model;
  final bool tenanted;
final String id;
  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {

  final  formKey2 = GlobalKey<FormState>();
  double ratingvalue=3.0;
  final review = TextEditingController();
  var myId=CacheHelper.getData(key: 'uId');
  double salesCash=0.0;
  List<ReviewModel> reviews=[];
  @override
  Widget build(BuildContext context) {

    FirebaseFirestore.instance.collection('users').doc(widget.model.id).get().then((value) {var x=value.data();
    salesCash=x!["cash"];
    } );
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
                          Expanded(child: Text(widget.model.name,style: TextStyle(fontWeight: FontWeight.bold,fontSize:MediaQuery.of(context).size.width*0.06,color: Colors.white ),)),
                          Row(
                            children: [

                              Text(widget.model.rate.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize:MediaQuery.of(context).size.width*0.04,color: Colors.white ),),
                            const Icon(Icons.star,color:Colors.amber,)
                            ],
                          ),

                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: Text(widget.model.price.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize:MediaQuery.of(context).size.width*0.06,color: Colors.white ),)),
                          widget.model.available?       Text('available',style: TextStyle(fontWeight: FontWeight.bold,fontSize:MediaQuery.of(context).size.width*0.04,color: Colors.white ),):

                          Text('not available'.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize:MediaQuery.of(context).size.width*0.04,color: Colors.grey ),),

                        ],
                      ),

                    ],),
                ),
              )

            ],
          ),

          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Reviews'),

              ],),
          ),
          Expanded(child:
          StreamBuilder<QuerySnapshot>(
              stream:FirebaseFirestore.instance.collection('stores').doc(widget.model.id).collection('products').doc(widget.id).collection('reviews').snapshots(),
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

          ),),
          widget.tenanted? widget.model.myTenantId==myId? Padding(
            padding: const EdgeInsets.all(8.0),
            child: defaultMaterialButton3(function: (){
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
                btnOkOnPress: () async {
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
                     await   FirebaseFirestore.instance.collection('stores').doc(widget.model.id).collection('products').doc(widget.id).collection('reviews').doc(myId).set(
                            model.toMap()
                        );
                        await  FirebaseFirestore.instance.collection('stores').doc(widget.model.id).collection('products').doc(widget.id).update(
                            {'rate':total}
                        );
                        await  FirebaseFirestore.instance.collection('stores').doc(widget.model.id).collection('products').doc(widget.id).update(
                            {'myTenantId':''}
                        ).then((value) => navigateAndFinish(context,const CustomerLayout(type: 'user')));
                      }else{

                        await   FirebaseFirestore.instance.collection('stores').doc(widget.model.id).collection('products').doc(widget.id).collection('reviews').doc(myId).set(
                            model.toMap()
                        );
                        await  FirebaseFirestore.instance.collection('stores').doc(widget.model.id).collection('products').doc(widget.id).update(
                            {'rate':ratingvalue}
                        );
                        await  FirebaseFirestore.instance.collection('stores').doc(widget.model.id).collection('products').doc(widget.id).update(
                            {'myTenantId':''}
                        ).then((value) => navigateAndFinish(context,const CustomerLayout(type: 'user')));
                      }
                    }

                  }
                },
              ).show();
            }, text: "تسليم", context: context,color: Colors.green),
          ):Padding(
            padding: const EdgeInsets.all(8.0),
            child: defaultMaterialButton3(function: (){}, text: "في انتظار الاستلام", context: context,color: Colors.grey),
          ): widget.model.available? Padding(
         padding: const EdgeInsets.all(8.0),
         child: defaultMaterialButton(function: () async {
           if(AppCubit.get(context).user!=null){
             if(AppCubit.get(context).user!.cash>=widget.model.price){
              double newCash=AppCubit.get(context).user!.cash-widget.model.price;
              salesCash+=widget.model.price;
             await  FirebaseFirestore.instance.collection('users').doc(CacheHelper.getData(key: 'uId')).update({'cash':newCash});
              await   FirebaseFirestore.instance.collection('users').doc(widget.model.id).update({'cash':salesCash});
              await FirebaseFirestore.instance.collection('stores').doc(widget.model.id).collection('products').
              doc(widget.id).update({'available':false}).then((value) =>   navigateAndFinish(context,const CustomerLayout(type: 'user',)));
              showToast(text: 'Booking Done', state: ToastStates.success);

             }else{
               showToast(text: 'The balance is insufficient', state: ToastStates.warning);
             }
           }else{
             showToast(text: 'please wait some seconds and try again', state: ToastStates.warning);
             AppCubit.get(context).getUser(CacheHelper.getData(key: 'uId'),);
           }
         }, text: "book Now!", context: context,color: Colors.green),
       ): Padding(
         padding: const EdgeInsets.all(8.0),
         child: defaultMaterialButton3(function: (){}, text: "Not Available", context: context,color: Colors.grey),
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
