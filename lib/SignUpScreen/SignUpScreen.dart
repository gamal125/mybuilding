// ignore_for_file: prefer_const_constructors_in_immutables, file_names

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import '../Componant/Componant.dart';
import '../Cubit/AppCubit.dart';
import '../Cubit/AppStates.dart';
import '../LoginScreen/LoginScreen.dart';



class RegisterScreen extends StatefulWidget {

  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordController2 = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  bool userRole=false;

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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is RegisterSuccessState) {

          navigateAndFinish(context, LoginScreen());
        }


      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [

                    const SizedBox(
                      height: 30,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Create an account',style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold,fontFamily: 'Dubai',),),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 5,left: 5,bottom:10),
                      child: Column(children: [

                        defaultTextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'Enter  Email';
                            }
                            return null;
                          },
                          label: 'Email',
                          hint: 'Email',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        defaultTextFormField(
                          controller: firstNameController,
                          keyboardType: TextInputType.text,

                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'Enter First Name';
                            }
                            return null;
                          },
                          label: 'First Name',
                          hint: 'First Name',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        defaultTextFormField(
                          controller: lastNameController,
                          keyboardType: TextInputType.text,

                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'Enter Last Name';
                            }
                            return null;
                          },
                          label: 'Last Name',
                          hint: 'Last Name',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        defaultTextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'Enter Phone';
                            }
                            return null;
                          },
                          label: ' Phone',
                          hint: ' Phone',
                        ),
                        defaultTextFormField(
                          controller: addressController,
                          keyboardType: TextInputType.text,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'Enter Address';
                            }
                            return null;
                          },
                          label: 'Address',
                          hint: 'Address',
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        defaultTextFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.text,

                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'Enter Password';
                            }
                            return null;
                          },
                          label: 'Password',
                          hint: 'Password',
                        ),

                        const SizedBox(
                          height: 10,
                        ),
                        defaultTextFormField(
                          controller: passwordController2,
                          keyboardType: TextInputType.text,

                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'Enter Confirm Password';
                            }
                            return null;
                          },
                          label: 'Confirm Password',
                          hint: 'Confirm Password',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [


                                Text('Customer',style: TextStyle(color:!userRole ?Colors.black: Colors.grey,fontSize: MediaQuery.of(context).size.width*0.04,),),
                                const SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () {

                                    setState(() {
                                      userRole=false;
                                    });
                                  },
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors:[ !userRole
                                              ?Colors.deepPurpleAccent:Colors.transparent,!userRole
                                              ?Colors.cyan:Colors.transparent]),
                                      shape: BoxShape.circle,
                                      border:userRole
                                          ? Border.all(
                                        color: Colors.grey,
                                        width: 3,
                                      ):null,
                                    ),
                                    child: !userRole
                                        ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    )
                                        : null,
                                  ),
                                ),


                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [


                                Text('worker',style: TextStyle(color:userRole ?Colors.black: Colors.grey,fontSize: MediaQuery.of(context).size.width*0.04,),),
                                const SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () {

                                    setState(() {
                                      userRole=true;
                                    });
                                  },
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors:[ userRole
                                              ?Colors.deepPurpleAccent:Colors.transparent,userRole
                                              ?Colors.cyan:Colors.transparent]),
                                      shape: BoxShape.circle,
                                      border:!userRole
                                          ? Border.all(
                                        color: Colors.grey,
                                        width: 3,
                                      ):null,
                                    ),
                                    child: userRole
                                        ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    )
                                        : null,
                                  ),
                                ),


                              ],
                            ),

                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        userRole?
                        Padding(
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
                        )
                            :const SizedBox(),
                        const SizedBox(
                          height: 20,
                        ),
                        ConditionalBuilder(
                          condition: state is! CreateUserInitialState,
                          builder: (context) => Center(
                            child: defaultMaterialButton3(
                              function: () {
                                if (formKey.currentState!.validate()) {
                                  if(passwordController.text!=passwordController2.text){
                                    showToast(text:'Password Not Matched' , state: ToastStates.error);
                                  }else{
                                    if(phoneController.text.length!=9){
                                      showToast(text:'phone number must be 9 numbers' , state: ToastStates.error);
                                    }else{
                                      userRole?
                                      AppCubit.get(context).userRegister(
                                        email: emailController.text,
                                        password: passwordController.text,
                                        firstName: firstNameController.text,
                                        lastName:lastNameController.text ,
                                        phone: phoneController.text,
                                        image: '',
                                        userRole: 'worker',
                                        address: addressController.text,
                                        major:selectedItem,
                                        rate: 0,
                                        cash: 0,


                                      ):
                                      AppCubit.get(context).userRegister(
                                        email: emailController.text,
                                        password: passwordController.text,
                                        firstName: firstNameController.text,
                                        lastName:lastNameController.text ,
                                        phone: phoneController.text,
                                        image: '',
                                        userRole: 'user',
                                        address: addressController.text,
                                        major: '',
                                        rate: 0,
                                        cash: 0,


                                      )
                                      ;
                                    }

                                  }

                                }
                              },
                              text: 'Sign Up',
                              radius: 20, color: Colors.green, context: context,
                            ),
                          ),
                          fallback: (context) =>
                          const Center(child: CircularProgressIndicator()),
                        ),

                        Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Do you already have an account?',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: Colors.grey),),

                            TextButton(onPressed: () { navigateTo(context, LoginScreen()); },
                              child:Text('Login',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,color: HexColor('#F88B94'),),),
                            ),
                          ],
                        ),


                      ]),
                    ),


                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
