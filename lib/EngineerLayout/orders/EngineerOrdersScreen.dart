// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:enginner/Componant/Componant.dart';
import 'package:enginner/Cubit/AppCubit.dart';
import 'package:flutter/material.dart';

import '../../Models/OrderModel.dart';

class EngineerOrdersScreen extends StatefulWidget {
  const EngineerOrdersScreen({super.key});

  @override
  State<EngineerOrdersScreen> createState() => _EngineerOrdersScreenState();
}

class _EngineerOrdersScreenState extends State<EngineerOrdersScreen> {
  List<OrderModel> orderModels=[];
  @override
  Widget build(BuildContext context) {
    return AppCubit.get(context).user!=null?  StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if(snapshot.data!=null){
            orderModels.clear();
            for (var doc in snapshot.data!.docs) {
              if(doc['type']==AppCubit.get(context).user!.major&&doc['state']!='accepted'){
                final model = OrderModel(
                  type:doc['type'],
                  orderId:doc['orderId'],
                  publisherId:doc['publisherId'],
                  publisherPhone:doc['publisherPhone'],
                  publisherName:doc['publisherName'],
                  publisherImage:doc['publisherImage'],
                  orderImage:doc['orderImage'],
                  state:doc['state'],
                  description:doc['description'],
                  address:doc['address'],
                );
                orderModels.add(model);
              }
            }
          }
          return ConditionalBuilder(
            condition: orderModels.isNotEmpty,
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
                        itemBuilder: (BuildContext context, int index) =>orderCard(orderModels[index],context),

                        itemCount:  orderModels.length,
                      ),
                    ),

                  ],
                ),
              );
            }, fallback: (BuildContext context) { return const Center(child:  Text('No Orders Yet!'));  },
          );
        }
    ):const Center(child:Text('Check NetWork!'));
  }
}
