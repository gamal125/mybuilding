// ignore_for_file: file_names, prefer_typing_uninitialized_variables

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:enginner/Componant/Componant.dart';
import 'package:enginner/Componant/cache_helper.dart';
import 'package:enginner/Cubit/AppCubit.dart';
import 'package:enginner/Cubit/AppStates.dart';
import 'package:enginner/CustomerLayout/profile/UpdateProfileScreen.dart';
import 'package:enginner/LoginScreen/LoginScreen.dart';
 import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({Key? key}) : super(key: key);

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  var selectionMode;
  final cashController = TextEditingController();
  var isChecked=false;

  @override
  Widget build(BuildContext context) {
    Size screenSiz = MediaQuery.of(context).size;

    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if(state is ChangeCashStates){
            setState(() {
              AppCubit.get(context).user!.cash=double.parse(state.cash);
            });

          }
          if(state is LogoutSuccessState){

            CacheHelper.removeData(key: 'uId',);
            CacheHelper.removeData(key: 'type',);

            navigateAndFinish(context, LoginScreen());
          }

        },
        builder: (context, state) {
          return CacheHelper.getData(key: 'uId')==null||CacheHelper.getData(key: 'uId')==''||AppCubit.get(context).user==null?


          Scaffold(
            appBar: AppBar(),

            body: Column(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [

                          Colors.green, // First color (top half)
                          Colors.white, // Second color (bottom half)
                        ],
                        stops: [0.2, 0.2], // Set the stops to create a sharp transition between the colors
                      ),
                    ),
                    child:  Column(

                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 72.0),
                          child: Stack(
                              alignment: AlignmentDirectional.bottomEnd,
                              children:[

                                CircleAvatar(backgroundImage: AssetImage('assets/images/1.jpg'),radius: 60,),


                              ]

                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                          child: Row(
                            children: [
                              const SizedBox(width: 10,),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Container(
                                    padding: const EdgeInsets.all(5),
                                    width: MediaQuery.of(context).size.width*0.2,
                                    height: MediaQuery.of(context).size.height*0.05,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white,width: 1),
                                        borderRadius: BorderRadius.circular(10)
                                        ,color: Colors.green
                                    ),
                                    child: const Text('Name',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),)),
                              ),
                              const SizedBox(width: 10,),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Container(
                                      padding: const EdgeInsets.all(5),
                                      width: MediaQuery.of(context).size.width*0.7,
                                      height: MediaQuery.of(context).size.height*0.05,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.green,width: 1),
                                          borderRadius: BorderRadius.circular(10)
                                          ,color: Colors.white
                                      ),
                                      child: const Text('new user',
                                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.green,overflow: TextOverflow.ellipsis),maxLines: 1,)),
                                ),
                              ),
                              const SizedBox(width: 10,),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                          child: Row(
                            children: [
                              const SizedBox(width: 10,),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Container(
                                    padding: const EdgeInsets.all(5),
                                    width: MediaQuery.of(context).size.width*0.2,
                                    height: MediaQuery.of(context).size.height*0.05,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white,width: 1),
                                        borderRadius: BorderRadius.circular(10)
                                        ,color: Colors.green
                                    ),
                                    child: const Text('Email',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),)),
                              ),
                              const SizedBox(width: 10,),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Container(
                                      padding: const EdgeInsets.all(5),
                                      width: MediaQuery.of(context).size.width*0.7,
                                      height: MediaQuery.of(context).size.height*0.05,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.green,width: 1),
                                          borderRadius: BorderRadius.circular(10)
                                          ,color: Colors.white
                                      ),
                                      child: const Text('******gmail.com',
                                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.green,overflow: TextOverflow.ellipsis),maxLines: 1,)),
                                ),
                              ),
                              const SizedBox(width: 10,),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 10),
                          child: Row(
                            children: [
                              const SizedBox(width: 10,),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Container(
                                    padding: const EdgeInsets.all(5),
                                    width: MediaQuery.of(context).size.width*0.2,
                                    height: MediaQuery.of(context).size.height*0.05,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white,width: 1),
                                        borderRadius: BorderRadius.circular(10)
                                        ,color: Colors.green
                                    ),
                                    child: const Text('Phone',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),)),
                              ),
                              const SizedBox(width: 10,),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Container(
                                      padding: const EdgeInsets.all(5),
                                      width: MediaQuery.of(context).size.width*0.7,
                                      height: MediaQuery.of(context).size.height*0.05,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.green,width: 1),
                                          borderRadius: BorderRadius.circular(10)
                                          ,color: Colors.white
                                      ),
                                      child: const Text("************",
                                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.green,overflow: TextOverflow.ellipsis),maxLines: 1,)),
                                ),
                              ),
                              const SizedBox(width: 10,),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0,right: 20,left: 20,bottom: 10),
                          child: Container(
                              height: 43,
                              width: double.infinity,
                              decoration: BoxDecoration(   borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [

                                  ConditionalBuilder(
                                    condition: state is! LogoutLoadingState,
                                    builder: (context)=>TextButton(onPressed: () {
                                      navigateAndFinish(context, LoginScreen());
                                    },
                                      child:const Text('تسجيل دخول',style: TextStyle(fontWeight: FontWeight.normal,fontSize: 18,color: Colors.black),),
                                    ),
                                    fallback: (context)=>const Center(child: CircularProgressIndicator(),),
                                  ) ,
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Container(   width: 40,height: 40,

                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.grey.withOpacity(0.2)),

                                      child: const Icon(Icons.logout_rounded,color: Colors.black),
                                    ),
                                  ),
                                ],
                              )),
                        ),


                      ],
                    ),
                  ),
                ),
              ],
            ),


          ):
          Scaffold(
            appBar: AppBar(),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [

                            Colors.green, // First color (top half)
                            Colors.white, // Second color (bottom half)
                          ],
                          stops: [0.2, 0.2], // Set the stops to create a sharp transition between the colors
                        ),
                      ),
                      child:  SingleChildScrollView(
                        child: Column(

                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 50.0),
                              child: Stack(
                                  alignment: AlignmentDirectional.bottomEnd,
                                  children:[

                                    AppCubit.get(context).user==null?const CircleAvatar(backgroundImage: AssetImage('assets/images/1.jpg'),radius: 60,):
                                    AppCubit.get(context).user!.image!=''?


                                    CircleAvatar(backgroundImage: NetworkImage(AppCubit.get(context).user!.image),radius: 60,):
                                    const CircleAvatar(backgroundImage: AssetImage('assets/images/1.jpg'),radius: 60,)
                                    ,
                                    Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),
                                          color: Colors.white,
                                        ),
                                        child: IconButton( onPressed: (){
                                          if(AppCubit.get(context).user!=null) {
                                            navigateTo(context, UpdateProfileScreen());
                                          }
                                          else{
                                            AppCubit.get(context).getUser(CacheHelper.getData(key: 'uId'), );
                                          }
                                        }, icon: const Icon(Icons.edit,color: Colors.green,size: 18,))),

                                  ]

                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),
                              child: Row(
                                children: [
                                  const SizedBox(width: 10,),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Container(
                                        padding: const EdgeInsets.all(5),
                                        width: MediaQuery.of(context).size.width*0.2,
                                        height: MediaQuery.of(context).size.height*0.05,
                                        decoration: BoxDecoration(
                                            border: Border.all(color: Colors.white,width: 1),
                                            borderRadius: BorderRadius.circular(10)
                                            ,color: Colors.green
                                        ),
                                        child: const Text('Name',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),)),
                                  ),
                                  const SizedBox(width: 10,),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Container(
                                          padding: const EdgeInsets.all(5),
                                          width: MediaQuery.of(context).size.width*0.7,
                                          height: MediaQuery.of(context).size.height*0.05,
                                          decoration: BoxDecoration(
                                              border: Border.all(color: Colors.green,width: 1),
                                              borderRadius: BorderRadius.circular(10)
                                              ,color: Colors.white
                                          ),
                                          child:
                                          Text('${AppCubit.get(context).user!.firstName}  ${AppCubit.get(context).user!.lastName}',
                                            style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.green,overflow: TextOverflow.ellipsis),maxLines: 1,)),

                                    ),
                                  ),
                                  const SizedBox(width: 10,),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),
                              child: Row(
                                children: [
                                  const SizedBox(width: 10,),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Container(
                                        padding: const EdgeInsets.all(5),
                                        width: MediaQuery.of(context).size.width*0.2,
                                        height: MediaQuery.of(context).size.height*0.05,
                                        decoration: BoxDecoration(
                                            border: Border.all(color: Colors.white,width: 1),
                                            borderRadius: BorderRadius.circular(10)
                                            ,color: Colors.green
                                        ),
                                        child: const Text('Email',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),)),
                                  ),
                                  const SizedBox(width: 10,),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Container(
                                          padding: const EdgeInsets.all(5),
                                          width: MediaQuery.of(context).size.width*0.7,
                                          height: MediaQuery.of(context).size.height*0.05,
                                          decoration: BoxDecoration(
                                              border: Border.all(color: Colors.green,width: 1),
                                              borderRadius: BorderRadius.circular(10)
                                              ,color: Colors.white
                                          ),
                                          child: Text(AppCubit.get(context).user!.email,
                                            style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.green,overflow: TextOverflow.ellipsis),maxLines: 1,)),
                                    ),
                                  ),
                                  const SizedBox(width: 10,),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),
                              child: Row(
                                children: [
                                  const SizedBox(width: 10,),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Container(
                                        padding: const EdgeInsets.all(5),
                                        width: MediaQuery.of(context).size.width*0.2,
                                        height: MediaQuery.of(context).size.height*0.05,
                                        decoration: BoxDecoration(
                                            border: Border.all(color: Colors.white,width: 1),
                                            borderRadius: BorderRadius.circular(10)
                                            ,color: Colors.green
                                        ),
                                        child: const Text('Phone',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),)),
                                  ),
                                  const SizedBox(width: 10,),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Container(
                                          padding: const EdgeInsets.all(5),
                                          width: MediaQuery.of(context).size.width*0.7,
                                          height: MediaQuery.of(context).size.height*0.05,
                                          decoration: BoxDecoration(
                                              border: Border.all(color: Colors.green,width: 1),
                                              borderRadius: BorderRadius.circular(10)
                                              ,color: Colors.white
                                          ),
                                          child: Text(AppCubit.get(context).user!.phone,
                                            style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.green,overflow: TextOverflow.ellipsis),maxLines: 1,)),
                                    ),
                                  ),
                                  const SizedBox(width: 10,),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),
                              child: Row(
                                children: [
                                  const SizedBox(width: 10,),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Container(
                                        padding: const EdgeInsets.all(5),
                                        width: MediaQuery.of(context).size.width*0.2,
                                        height: MediaQuery.of(context).size.height*0.05,
                                        decoration: BoxDecoration(
                                            border: Border.all(color: Colors.white,width: 1),
                                            borderRadius: BorderRadius.circular(10)
                                            ,color: Colors.green
                                        ),
                                        child: const Text('Address',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),)),
                                  ),
                                  const SizedBox(width: 10,),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Container(
                                          padding: const EdgeInsets.all(5),
                                          width: MediaQuery.of(context).size.width*0.7,
                                          height: MediaQuery.of(context).size.height*0.05,
                                          decoration: BoxDecoration(
                                              border: Border.all(color: Colors.green,width: 1),
                                              borderRadius: BorderRadius.circular(10)
                                              ,color: Colors.white
                                          ),
                                          child: Text(AppCubit.get(context).user!.address,
                                            style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.green,overflow: TextOverflow.ellipsis),maxLines: 1,)),
                                    ),
                                  ),
                                  const SizedBox(width: 10,),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),
                              child: Row(
                                children: [
                                  const SizedBox(width: 10,),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Container(
                                        padding: const EdgeInsets.all(5),
                                        width: MediaQuery.of(context).size.width*0.2,
                                        height: MediaQuery.of(context).size.height*0.05,
                                        decoration: BoxDecoration(
                                            border: Border.all(color: Colors.white,width: 1),
                                            borderRadius: BorderRadius.circular(10)
                                            ,color: Colors.green
                                        ),
                                        child: const Text('Job',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),)),
                                  ),
                                  const SizedBox(width: 10,),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Container(
                                          padding: const EdgeInsets.all(5),
                                          width: MediaQuery.of(context).size.width*0.7,
                                          height: MediaQuery.of(context).size.height*0.05,
                                          decoration: BoxDecoration(
                                              border: Border.all(color: Colors.green,width: 1),
                                              borderRadius: BorderRadius.circular(10)
                                              ,color: Colors.white
                                          ),
                                          child: Text(AppCubit.get(context).user!.major,
                                            style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.green,overflow: TextOverflow.ellipsis),maxLines: 1,)),
                                    ),
                                  ),
                                  const SizedBox(width: 10,),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),
                              child: Row(
                                children: [
                                  const SizedBox(width: 10,),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Container(
                                        padding: const EdgeInsets.all(5),
                                        width: MediaQuery.of(context).size.width*0.2,
                                        height: MediaQuery.of(context).size.height*0.05,
                                        decoration: BoxDecoration(
                                            border: Border.all(color: Colors.white,width: 1),
                                            borderRadius: BorderRadius.circular(10)
                                            ,color: Colors.green
                                        ),
                                        child: const Text('Balance',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white),)),
                                  ),
                                  const SizedBox(width: 10,),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Container(
                                          padding: const EdgeInsets.all(5),
                                          width: MediaQuery.of(context).size.width*0.7,
                                          height: MediaQuery.of(context).size.height*0.05,
                                          decoration: BoxDecoration(
                                              border: Border.all(color: Colors.green,width: 1),
                                              borderRadius: BorderRadius.circular(10)
                                              ,color: Colors.white
                                          ),
                                          child: Text(AppCubit.get(context).user!.cash.toString(),
                                            style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.green,overflow: TextOverflow.ellipsis),maxLines: 1,)),
                                    ),
                                  ),
                                  IconButton(onPressed: (){

                                    AwesomeDialog(
                                      body:     Padding(
                                        padding: const EdgeInsets.all(18.0),
                                        child: Column(
                                          children: [
                                            const Text('Add money to wallet'),
                                            const SizedBox(height: 20,),
                                            defaultTextFormField(
                                              onTap: (){
                                              },
                                              controller: cashController,
                                              keyboardType: TextInputType.number,
                                              prefix: Icons.monetization_on_sharp,
                                              validate: (String? value) {
                                                if (value!.isEmpty) {
                                                  return 'Please enter amount';
                                                }
                                                return null;
                                              },
                                              label: 'amount',
                                              hint: 'Enter your amount',
                                            ),
                                          ],
                                        ),
                                      ),
                                      context: context,
                                      dialogType: DialogType.warning,
                                      animType: AnimType.rightSlide,

                                      btnCancelOnPress: () {},
                                      btnCancelText: 'Cancel',
                                      btnOkText: 'Done',
                                      btnOkOnPress: () {
                                        double total=0.0;
                                        cashController.text.isNotEmpty?
                                        total=double.parse(cashController.text)+AppCubit.get(context).user!.cash:
                                        total=AppCubit.get(context).user!.cash;

                                        cashController.text.isNotEmpty?
                                        FirebaseFirestore.instance.collection('users').doc(AppCubit.get(context).user!.uId).update({"cash":total}).then((value) => {
                                          AppCubit.get(context).changeCash(total.toString())

                                        }):null;


                                      },
                                    ).show();

                                  },icon: const Icon(Icons.add)),
                                  const SizedBox(width: 10,),
                                ],
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height*0.05,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                ConditionalBuilder(
                                    condition: state is! LogoutLoadingState,
                                    builder: (context)=>

                                        Container(
                                            padding: const EdgeInsets.all(2),
                                            width: MediaQuery.of(context).size.width*0.5,
                                            height: MediaQuery.of(context).size.height*0.055,
                                            decoration: BoxDecoration(
                                                border: Border.all(color: Colors.white,width: 1),
                                                borderRadius: BorderRadius.circular(10)
                                                ,color: Colors.red
                                            ),
                                            child:TextButton(onPressed: (){

                                              AwesomeDialog(
                                                body:    const Padding(
                                                  padding: EdgeInsets.all(18.0),
                                                  child: Column(
                                                    children: [
                                                      Text('هل تريد حقا تسجيل الخروج'),
                                                      SizedBox(height: 20,),

                                                    ],
                                                  ),
                                                ),
                                                context: context,
                                                dialogType: DialogType.warning,
                                                animType: AnimType.rightSlide,

                                                btnCancelOnPress: () {},
                                                btnCancelText: 'لا',
                                                btnOkText: 'نعم',
                                                btnOkOnPress: () {
                                                  AppCubit.get(context).signOut(context);
                                                },
                                              ).show();

                                            },child: const Text('LogOut',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.white),))) , fallback: (context)=>  Center(
                                    child: LoadingAnimationWidget.inkDrop(
                                      color: Colors.green.withOpacity(.8),
                                      size: screenSiz.width / 12,
                                    ))
                                ) ,
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Container(   width: 40,height: 40,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.grey.withOpacity(0.2)),

                                    child: const Icon(Icons.logout_rounded,color: Colors.black),
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          );
        }



    );}
}