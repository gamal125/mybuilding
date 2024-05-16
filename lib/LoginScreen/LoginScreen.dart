

// ignore_for_file: file_names

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:enginner/CustomerLayout/CustomerLayout.dart';
import 'package:enginner/EngineerLayout/EngineerLayout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Componant/Componant.dart';
import '../Componant/cache_helper.dart';
import '../Cubit/AppCubit.dart';
import '../Cubit/AppStates.dart';
import '../SignUpScreen/SignUpScreen.dart';



class LoginScreen extends StatelessWidget {
  final  formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is LoginSuccessState) {

          CacheHelper.saveData(key: 'uId', value: state.uId);

          AppCubit.get(context).getUser(state.uId);



        }
        if (state is GetUserSuccessState) {
          CacheHelper.saveData(key: 'type', value: state.type);
            if(state.type=='user'){
              navigateAndFinish(context,   CustomerLayout(type:state.type,));
            }
            else{
              navigateAndFinish(context, const EngineerLayout());
            }






        }

      },
      builder: (context, state) {
        return Scaffold(

          appBar: AppBar(),

          body: SafeArea(
            child: GestureDetector(
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
                          const Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          defaultTextFormField(
                            onTap: (){
                            },
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            prefix: Icons.email,
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return 'Please enter email';
                              }
                              return null;
                            },
                            label: 'Email',
                            hint: 'Enter your email',
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          defaultTextFormField(
                            onTap: (){
                              // LoginCubit.get(context).emit(LoginInitialState());
                            },
                            controller: passwordController,
                            keyboardType: TextInputType.visiblePassword,
                            prefix: Icons.key,
                            suffix: AppCubit.get(context).suffix,
                            isPassword: AppCubit.get(context).isPassword,
                            suffixPressed: () {
                              AppCubit.get(context).changePassword();
                            },
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return 'Please enter password';
                              }
                              return null;
                            },
                            label: 'Password',
                            hint: 'Enter your password',
                          ),

                          const SizedBox(
                            height: 20,
                          ),
                          ConditionalBuilder(
                            condition: state is! LoginLoadingState,
                            builder: (context) => Center(
                              child: defaultMaterialButton3(

                                function: () {
                                  if (formKey.currentState!.validate()) {
                                    AppCubit.get(context).userLogin(
                                        email: emailController.text,
                                        password: passwordController.text);
                                  }
                                },
                                text: 'Login',
                                radius: 20, context: context,
                                color: Colors.green
                              ),
                            ),
                            fallback: (context) =>
                            const Center(child: CircularProgressIndicator()),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'Don\'t have an account?',
                            style:
                            TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          defaultTextButton(
                            function: () {
                              navigateTo(context, RegisterScreen());
                            },
                            text: 'Register Now!',
                          ),

                        ],
                      ),
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
