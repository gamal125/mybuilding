// ignore_for_file: file_names

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:enginner/Componant/cache_helper.dart';
import 'package:enginner/EngineerLayout/EngineerLayout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Componant/Componant.dart';
import '../../Cubit/AppCubit.dart';
import '../../Cubit/AppStates.dart';

class AddStoreScreen extends StatefulWidget {
  const AddStoreScreen({super.key});

  @override
  State<AddStoreScreen> createState() => _AddStoreScreenState();
}

class _AddStoreScreenState extends State<AddStoreScreen> {
  var id =CacheHelper.getData(key: 'uId');
  var storeNameController=TextEditingController();
  var phoneController=TextEditingController();
  var addressController=TextEditingController();
  final imageController = TextEditingController();

  final  formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){
          if(state is CreateStoreSuccessState){
            navigateAndFinish(context, const EngineerLayout());
          }
        },
        builder:(context,state){
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text('Add Store'),
              leading: IconButton(onPressed: (){
                navigateAndFinish(context, const EngineerLayout());
                AppCubit.get(context).PickedFile2=null;

              }, icon: const Icon(Icons.arrow_back_ios_outlined),),
              actions: [
                IconButton(onPressed: (){
                  AppCubit.get(context).getImage2();
                }, icon: const Icon( Icons.add_a_photo,color: Colors.deepPurpleAccent,))
              ],
            ),
            body: GestureDetector(
              onTap: (){
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: Form(
                key:formKey,
                child: ListView(children: [


                  Container(
                      width:MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height*0.31,
                      decoration: AppCubit.get(context).PickedFile2!=null?
                      BoxDecoration(image: DecorationImage(image: FileImage(AppCubit.get(context).PickedFile2!),fit: BoxFit.fill))
                          : const BoxDecoration(image:

                      DecorationImage(image: NetworkImage(
                          'https://www.leedsandyorkpft.nhs.uk/advice-support/wp-content/uploads/sites/3/2021/06/pngtree-image-upload-icon-photo-upload-icon-png-image_2047546.jpg'))


                      )

                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Store Name',style: TextStyle(fontWeight: FontWeight.bold,fontSize:MediaQuery.of(context).size.width*0.05,color: Colors.black ),),
                        defaultTextFormField(
                            prefix: Icons.person,

                            controller: storeNameController,
                            keyboardType: TextInputType.text,
                            validate: (String? s){
                              if(s!.isEmpty){
                                return 'Enter Store Name';
                              }
                              return null;
                            },
                            label: 'Store Name')

                      ],
                    ),
                  ),
                  Container(
                    color: Colors.grey,
                    width: double.infinity,
                    height: 1,
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Store Phone',style: TextStyle(fontWeight: FontWeight.bold,fontSize:MediaQuery.of(context).size.width*0.05,color: Colors.black ),),
                        defaultTextFormField(
                            prefix:Icons.phone ,

                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            validate: (String? s){
                              if(s!.isEmpty){
                                return 'Enter Store Phone';
                              }
                              return null;
                            },
                            label: 'Store Phone')


                      ],
                    ),
                  ),
                  Container(
                    color: Colors.grey,
                    width: double.infinity,
                    height: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Address',style: TextStyle(fontWeight: FontWeight.bold,fontSize:MediaQuery.of(context).size.width*0.05,color: Colors.black ),),
                        defaultTextFormField(
                            prefix:Icons.location_on_sharp ,

                            controller: addressController,
                            keyboardType: TextInputType.name,
                            validate: (String? s){
                              if(s!.isEmpty){
                                return 'Enter Address';
                              }
                              return null;
                            },
                            label: 'Address')

                      ],
                    ),
                  ),
                  Container(
                    color: Colors.grey,
                    width: double.infinity,
                    height: 1,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ConditionalBuilder(
                      condition: state  is! CreateStoreLoadingState,
                      builder: (context) => Center(
                        child: defaultMaterialButton(

                          function: () {
                            if (formKey.currentState!.validate()) {

                            AppCubit.get(context).createStore(
                                phone: phoneController.text,
                                id: id,
                                image: '',
                                storeName: storeNameController.text,
                                address: addressController.text);
                              }

                          },
                          text: 'Publish',
                          radius: 20, context: context,
                        ),
                      ),
                      fallback: (context) =>
                      const Center(child: CircularProgressIndicator()),
                    ),
                  ),


                ],),
              ),
            ),
          );
        }
    );
  }
}
