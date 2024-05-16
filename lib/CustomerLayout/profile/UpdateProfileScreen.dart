

// ignore_for_file: file_names

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:enginner/Componant/Componant.dart';
import 'package:enginner/Componant/cache_helper.dart';
import 'package:enginner/Cubit/AppCubit.dart';
import 'package:enginner/Cubit/AppStates.dart';
import 'package:enginner/CustomerLayout/CustomerLayout.dart';
import 'package:enginner/EngineerLayout/EngineerLayout.dart';
import 'package:flutter/material.dart';
 import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';




class UpdateProfileScreen extends StatelessWidget {


  final  formKey = GlobalKey<FormState>();

  final imageController = TextEditingController();
  final nameController = TextEditingController();
  final nameController2 = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  UpdateProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {

    Size screenSiz = MediaQuery.of(context).size;
    var c= AppCubit.get(context);
    imageController.text=c.user!.image;
    nameController.text=c.user!.firstName;
    nameController2.text=c.user!.lastName;
    addressController.text=c.user!.address;
    phoneController.text=c.user!.phone;

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is ImageSuccessStates) {
          AppCubit.get(context).getUser(CacheHelper.getData(key: 'uId'),);
          CacheHelper.getData(key: 'type')!='worker'?
          navigateAndFinish(context, const CustomerLayout(type: 'type')): navigateAndFinish(context, const EngineerLayout());

        }
        if (state is UpdateProfileSuccessStates) {
          AppCubit.get(context).getUser(CacheHelper.getData(key: 'uId'),);
          CacheHelper.getData(key: 'type')!='worker'?
          navigateAndFinish(context, const CustomerLayout(type: 'type')): navigateAndFinish(context, const EngineerLayout());

        }

      },
      builder: (context, state) {
        var imageo=c.user!.image;
        return Scaffold(
          backgroundColor: Colors.white,

          appBar: AppBar(backgroundColor: Colors.white,iconTheme: const IconThemeData(color: Colors.blue),elevation: 0,),
          body: GestureDetector(
            onTap: (){
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: (){
                            c.getImage2();
                          },
                          child: Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height*0.25,

                            decoration: c.PickedFile2!=null?
                            BoxDecoration(image: DecorationImage(image: FileImage(c.PickedFile2!)))
                                : BoxDecoration(image:
                            imageo==''?
                            const DecorationImage(image: NetworkImage(
                                'https://www.leedsandyorkpft.nhs.uk/advice-support/wp-content/uploads/sites/3/2021/06/pngtree-image-upload-icon-photo-upload-icon-png-image_2047546.jpg')):
                            DecorationImage(image: NetworkImage(imageo) )

                            )
                            ,
                          ),
                        ) ,

                        Center(

                          child: Column(
                            children: [

                              Container(
                                decoration:  BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white24
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20.0,right: 20,left: 20,bottom:10),
                                  child: Column(children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    defaultTextFormField(
                                      onTap: (){

                                      },
                                      controller: nameController,
                                      keyboardType: TextInputType.text,
                                      prefix: Icons.drive_file_rename_outline_sharp,
                                      validate: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter First name ';
                                        }
                                        return null;
                                      },
                                      label: 'First Name',
                                      hint: 'Enter your name',
                                    ),

                                    const SizedBox(
                                      height: 20,
                                    ),
                                    defaultTextFormField(
                                      onTap: (){

                                      },
                                      controller: nameController2,
                                      keyboardType: TextInputType.text,
                                      prefix: Icons.drive_file_rename_outline_sharp,
                                      validate: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter First name ';
                                        }
                                        return null;
                                      },
                                      label: 'Last Name',
                                      hint: 'Enter your Last name',
                                    ),

                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ////////////////////
                                    defaultTextFormField(
                                      onTap: (){

                                      },
                                      controller: phoneController,
                                      keyboardType: TextInputType.number,
                                      prefix: Icons.phone,
                                      validate: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter phone';
                                        }
                                        return null;
                                      },
                                      label: 'رقم الهاتف',
                                      hint: 'Enter phone',
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    ////////////////////
                                    defaultTextFormField(
                                      onTap: (){

                                      },
                                      controller: addressController,
                                      keyboardType: TextInputType.text,
                                      prefix: Icons.location_on_sharp,
                                      validate: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter address';
                                        }
                                        return null;
                                      },
                                      label: 'Address',
                                      hint: 'Enter Address',
                                    ),

                                    const SizedBox(
                                      height: 20,
                                    ),

                                    ConditionalBuilder(
                                        condition:state is! ImageintStates ,
                                        builder: ( context)=> Center(
                                          child: defaultMaterialButton(function: () {
                                            if (formKey.currentState!.validate()) {
                                              if(AppCubit.get(context).PickedFile2!=null){
                                                AppCubit.get(context).uploadProfileImage(


                                                  email: AppCubit.get(context).user!.email,
                                                  image: '',
                                                  firstName: nameController.text,
                                                  lastName: nameController2.text,
                                                  phone: phoneController.text,
                                                  userRole: c.user!.userRole,
                                                  major: c.user!.major,
                                                  address: addressController.text,
                                                  rate: c.user!.rate,
                                                  cash: c.user!.cash,
                                                );}
                                              else{
                                                AppCubit.get(context).updateProfile(

                                                  email: AppCubit.get(context).user!.email,
                                                  image: c.user!.image,
                                                  firstName: nameController.text,
                                                  lastName: nameController2.text,
                                                  phone: phoneController.text,
                                                  userRole: c.user!.userRole,
                                                  major: c.user!.major,
                                                  address: addressController.text,
                                                  rate: c.user!.rate,
                                                  cash: c.user!.cash,

                                                );
                                              }

                                            }

                                          }, text: 'نشر', radius: 20, color: Colors.green, context: context,),
                                        ),
                                        fallback: (context)=>
                                            Center(
                                                child: LoadingAnimationWidget.inkDrop(
                                                  color: Colors.blue.withOpacity(.8),
                                                  size: screenSiz.width / 12,
                                                ))
                                    ),

                                    const SizedBox(
                                      height: 20,
                                    ),

                                  ]),
                                ),


                              ),


                            ],
                          ),
                        ),


                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}