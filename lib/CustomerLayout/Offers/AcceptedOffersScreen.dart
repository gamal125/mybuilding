// ignore_for_file: file_names, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:enginner/Componant/Componant.dart';
import 'package:enginner/Cubit/AppCubit.dart';
import 'package:enginner/Models/OrderModel.dart';
import 'package:enginner/Models/TotalOfferModel.dart';
import 'package:flutter/material.dart';


class  AcceptedOffersScreen extends StatefulWidget {
  const  AcceptedOffersScreen({super.key, required this.model});
  final OrderModel model;
  @override
  State< AcceptedOffersScreen> createState() => _AcceptedOffersScreenState();
}

class _AcceptedOffersScreenState extends State<AcceptedOffersScreen> {
  List<TotalOfferModel> offersModels=[];
  @override
  Widget build(BuildContext context) {
   var id='';
    return  StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').doc(widget.model.orderId).collection('offers').snapshots(),
        builder: (context, snapshot) {
          if(snapshot.data!=null){
            offersModels.clear();
            for (var doc in snapshot.data!.docs) {
              if(doc['state']=='accepted'){
                final model = TotalOfferModel(

                  totalPrice:doc['totalPrice'],
                  totalDays:doc['totalDays'],
                  workerRate:doc['workerRate'],
                  name:doc['name'],
                  id:doc['id'],
                  image:doc['image'],
                  phone:doc['phone'],
                  state: doc['state'],

                );
               AppCubit.get(context).getEngineer(doc['id']);
                offersModels.add(model);
              }
            }
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text("Accepted Offers"),
              backgroundColor: Colors.green,
              centerTitle: true,
            ),
            body: ConditionalBuilder(
              condition: offersModels.isNotEmpty,
              builder: (context) {
                return GestureDetector(
                  onTap:(){
                    FocusScope.of(context).unfocus();
                  },
                  child: Column(
                    children: [
                      const SizedBox(height: 10,),

                      Expanded(


                        child: ListView.builder(
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) =>acceptedOfferCard(offersModels[index],widget.model.orderId,context),

                          itemCount:  offersModels.length,
                        ),
                      ),

                    ],
                  ),
                );
              }, fallback: (BuildContext context) { return const Center(child:  Text('No Orders Yet!'));  },
            ),
          );
        }
    );
  }
}
