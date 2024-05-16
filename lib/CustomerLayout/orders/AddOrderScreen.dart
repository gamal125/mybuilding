// ignore_for_file: file_names

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:enginner/Componant/Componant.dart';
import 'package:enginner/Cubit/AppCubit.dart';
import 'package:enginner/Cubit/AppStates.dart';
import 'package:enginner/CustomerLayout/CustomerLayout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AddOrderScreen extends StatefulWidget {
  const AddOrderScreen({super.key});

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  final  formKey = GlobalKey<FormState>();
  String selectedItem = 'دهان';

  List<String> dropdownItems = [
    "دهان",
    "سباك",
    "نجار",
    "فني تكيف",
    "مبلط",
    "معلم ديكور خارجي/داخلي",
    "مليس",
    "مقاول عظم",
    "معلم جبس",
    "معلم تمديدات",
    "كهربائي",
    "معلم عوازل مائي /حراري",
    "حفار ارضية",
    "معلم ألمنيوم نوافذ وابواب",
    "حداد",
    "مكتب هندسي",
    "مشرف على المبنى",
    "فني تمديد سنترال وانترنت",
    "معلم حجر",
    "مصمم داخلي",

  ];

   var orderImage=TextEditingController();
   var description=TextEditingController();
   var addressController=TextEditingController();
  @override
  Widget build(BuildContext context) {

    var c= AppCubit.get(context);
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add Order',style: TextStyle(color: Colors.white),)),
      ),
    body:  BlocConsumer<AppCubit,AppStates>(
      listener:  (context, state){
        if(state is AddOrderSuccessState){
          navigateAndFinish(context, const CustomerLayout(type: 'user',));
        }
      },
      builder: (context, state) {
        return GestureDetector(
        onTap: (){
        FocusManager.instance.primaryFocus?.unfocus();
        },
        child:  Center(
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
                  BoxDecoration(image: DecorationImage(image: FileImage(c.PickedFile2!),fit: BoxFit.fill))
                      : const BoxDecoration(image:

                  DecorationImage(image: NetworkImage(
                      'https://www.leedsandyorkpft.nhs.uk/advice-support/wp-content/uploads/sites/3/2021/06/pngtree-image-upload-icon-photo-upload-icon-png-image_2047546.jpg'),fit: BoxFit.fill)
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
                          defaultTextFormField(
                            onTap: (){

                            },
                            max: 10,
                            min: 5,
                            controller: description,
                            keyboardType: TextInputType.text,

                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return 'Please enter description';
                              }
                              return null;
                            },
                            label: 'description',
                            hint: 'Enter description',
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              const Text('Major : '),
                              Expanded(
                                child: Padding(
                                  padding:  EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.2),
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: selectedItem,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedItem = newValue!;
                                      });
                                    },
                                    items: dropdownItems.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ConditionalBuilder(
                              condition:state is! AddOrderInitialState ,
                              builder: ( context)=> Center(
                                child: defaultMaterialButton(function: () {
                                  if (formKey.currentState!.validate()) {
                                      AppCubit.get(context).addOrder(
                                          type: selectedItem,
                                          state: '',
                                          description: description.text, address: addressController.text);

                                  }

                                }, text: 'نشر', radius: 20, color: Colors.green, context: context,),
                              ),
                              fallback: (context)=>
                                  Center(
                                      child: LoadingAnimationWidget.inkDrop(
                                        color: Colors.blue.withOpacity(.8),
                                        size: MediaQuery.of(context).size.width / 12,
                                      ))
                          ),

                          const SizedBox(
                            height: 10,
                          ),

                        ]),
                      ),


                    ),


                  ],
                ),
              ),


            ],
          )
          ,)
        )
        )
        ),
        );
      }
    ),

    );

  }
}
