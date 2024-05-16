// ignore_for_file: file_names

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:enginner/Componant/cache_helper.dart';
import 'package:enginner/EngineerLayout/EngineerLayout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Componant/Componant.dart';
import '../../Cubit/AppCubit.dart';
import '../../Cubit/AppStates.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  var id =CacheHelper.getData(key: 'uId');
  var descriptionController=TextEditingController();
  var priceController=TextEditingController();
  var nameController=TextEditingController();
  final imageController = TextEditingController();

  final  formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    return  BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){
          if(state is CreateProductSuccessState){
            navigateAndFinish(context, const EngineerLayout());
          }
        },
        builder:(context,state){
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: const Text('Add Product'),
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
                        Text('Product Name',style: TextStyle(fontWeight: FontWeight.bold,fontSize:MediaQuery.of(context).size.width*0.05,color: Colors.black ),),
                        defaultTextFormField(
                            prefix:Icons.edit ,

                            controller: nameController,
                            keyboardType: TextInputType.name,
                            validate: (String? s){
                              if(s!.isEmpty){
                                return 'Enter Product Name';
                              }
                              return null;
                            },
                            label: 'Product Name')

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
                        Text('description ',style: TextStyle(fontWeight: FontWeight.bold,fontSize:MediaQuery.of(context).size.width*0.05,color: Colors.black ),),
                        defaultTextFormField(
                            prefix: Icons.person,

                            controller: descriptionController,
                            keyboardType: TextInputType.text,
                            validate: (String? s){
                              if(s!.isEmpty){
                                return 'Enter description ';
                              }
                              return null;
                            },
                            label: 'description')

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
                        Text('price',style: TextStyle(fontWeight: FontWeight.bold,fontSize:MediaQuery.of(context).size.width*0.05,color: Colors.black ),),
                        defaultTextFormField(
                            prefix:Icons.monetization_on_sharp ,

                            controller: priceController,
                            keyboardType: TextInputType.number,
                            validate: (String? s){
                              if(s!.isEmpty){
                                return 'Enter price';
                              }
                              return null;
                            },
                            label: 'price')


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
                      condition: state  is! CreateProductLoadingState,
                      builder: (context) => Center(
                        child: defaultMaterialButton(

                          function: () {
                            if (formKey.currentState!.validate()) {

                              AppCubit.get(context).createProduct(
                                  id: id,
                                  image: '',
                                  description: descriptionController.text,
                                 name: nameController.text,
                                price:double.parse(priceController.text),

                              );
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
