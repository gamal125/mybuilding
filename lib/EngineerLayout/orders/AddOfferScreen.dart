// ignore_for_file: file_names

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:enginner/Componant/Componant.dart';
import 'package:enginner/Cubit/AppCubit.dart';
import 'package:enginner/Cubit/AppStates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddOfferScreen extends StatefulWidget {
  const AddOfferScreen({super.key, required this.workerRate, required this.name, required this.id, required this.image, required this.phone, required this.orderId});
 final double workerRate;
  final String name;
  final String id;
  final String image;
  final String phone;
  final String orderId;
  @override
  State<AddOfferScreen> createState() => _AddOfferScreenState();
}

class _AddOfferScreenState extends State<AddOfferScreen> {
  var scaffoldkey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var descriptionController = TextEditingController();
  var priceController = TextEditingController();
  var dateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var cubit=AppCubit.get(context);
    return   BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){
        if(state is InsertedToList){
          titleController.clear();
          descriptionController.clear();
          priceController.clear();
          dateController.clear();
          Navigator.pop(context);
        }
        if(state is SumationDoneState){
cubit.AddOffer(name: widget.name, phone: widget.phone, id: widget.id, image: widget.image, workerRate: widget.workerRate, orderId: widget.orderId);
        }
        if(state is AddOfferSuccessState){
          Navigator.pop(context);
        }
      },
      builder: (context,state) {
        return Scaffold(
          key: scaffoldkey,
          appBar: AppBar(
            actions: [Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: ConditionalBuilder(
                condition: state is !AddOfferLoadingState,
                builder: (context) {
                  return InkWell(
                    onTap: (){
                      if(cubit.engOffers.isNotEmpty){
                                cubit.Sum();
                      }else{
                        showToast(text: 'Add Steps First', state: ToastStates.warning);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 18),
                      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(5),),
                      child: const Text('Save',style: TextStyle(color: Colors.green),),
                    ),
                  );
                }, fallback: (BuildContext context) {return const Center(child:CircularProgressIndicator() ,); },
              ),
            )],
          ),
          body: ConditionalBuilder(
            condition: cubit.engOffers.isNotEmpty,
            builder: (BuildContext context) {return tasksBuilder( tasks:cubit.engOffers, id: widget.id, orderId: widget.orderId, ); },
            fallback: (BuildContext context) { return const Center(child: Text('Add your plan steps !',style: TextStyle(color: Colors.grey),)); },),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (cubit.isBottomSheetShown) {
                if (formkey.currentState!.validate()) {
                  cubit.insertToOfferList(
                    title: titleController.text,
                   price: double.parse(priceController.text),
                    duration: double.parse(dateController.text),
                    description: descriptionController.text,
                    state: '',
                  );
                }
              } else {
                scaffoldkey.currentState!
                    .showBottomSheet(
                      (context) => Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(
                      20.0,
                    ),
                    child: Form(
                      key: formkey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            defaultTextFormField(
                              controller: titleController,
                         keyboardType: TextInputType.text,
                              validate: (String? value) {
                                if (value!.isEmpty) {
                                  return 'title must not be empty';
                                }
                                return null;
                              },
                              label: 'Task Title',
                              prefix: Icons.title,
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            defaultTextFormField(
                              controller: priceController,
                              keyboardType: TextInputType.number,
                        
                              validate: (String? value) {
                                if (value!.isEmpty) {
                                  return 'price must not be empty';
                                }
                                return null;
                              },
                              label: 'price',
                              prefix: Icons.money,
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            defaultTextFormField(
                              controller: dateController,
                              keyboardType: TextInputType.number,
                              onTap: () {
                        
                              },
                              validate: (String? value) {
                                if (value!.isEmpty) {
                                  return 'duration must not be empty';
                                }
                                return null;
                              },
                              label: 'duration (per Day)',
                              prefix: Icons.watch_later_outlined,
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            defaultTextFormField(
                              controller: descriptionController,
                              keyboardType: TextInputType.text,
                              min: 3,
                              max: 4,
                              onTap: () {
                        
                              },
                              validate: (String? value) {
                                if (value!.isEmpty) {
                                  return 'description must not be empty';
                                }
                                return null;
                              },
                              label: 'description',
                              prefix: Icons.edit,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  elevation: 20.0,
                )
                    .closed
                    .then((value) {
                  cubit.changeBottomSheetState(
                    isShow: false,
                    icon: Icons.edit,
                  );
                });
                cubit.changeBottomSheetState(
                  isShow: true,
                  icon: Icons.add,
                );
              }
            },
            child: Icon(
              cubit.fabIcon,
            ),
          ),
        );
      }
    );
  }
}
