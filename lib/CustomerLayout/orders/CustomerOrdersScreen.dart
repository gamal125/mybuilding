// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:enginner/Componant/Componant.dart';
import 'package:enginner/Componant/cache_helper.dart';
import 'package:flutter/material.dart';

import '../../Models/OrderModel.dart';

class CustomerOrdersScreen extends StatefulWidget {
  const CustomerOrdersScreen({super.key});

  @override
  State<CustomerOrdersScreen> createState() => _CustomerOrdersScreenState();
}

class _CustomerOrdersScreenState extends State<CustomerOrdersScreen> {
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
            if(doc['publisherId']==id && doc['state']!='accepted'){
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
    );
  }
}
