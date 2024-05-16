// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:enginner/Componant/Componant.dart';
import 'package:enginner/Models/OrderModel.dart';
 import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Componant/cache_helper.dart';

class CustomerOffersScreen extends StatefulWidget {
  const CustomerOffersScreen({super.key});

  @override
  State<CustomerOffersScreen> createState() => _CustomerOffersScreenState();
}

class _CustomerOffersScreenState extends State<CustomerOffersScreen> {
  List<OrderModel> orderModels=[];
  @override
  Widget build(BuildContext context) {
    var id=CacheHelper.getData(key: 'uId');
    return  StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if(snapshot.data!=null){
            orderModels.clear();
            for (var doc in snapshot.data!.docs) {
              if(doc['publisherId']==id && doc['state']=='accepted'){
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
                        itemBuilder: (BuildContext context, int index) =>acceptedOrderCard(orderModels[index],context),

                        itemCount:  orderModels.length,
                      ),
                    ),

                  ],
                ),
              );
            }, fallback: (BuildContext context) { return const Center(child:  Text('No Accepted Orders Yet!'));  },
          );
        }
    );
  }
}
