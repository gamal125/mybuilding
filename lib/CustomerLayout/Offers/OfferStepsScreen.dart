// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:enginner/Componant/Componant.dart';
import 'package:enginner/Cubit/AppCubit.dart';
import 'package:enginner/Cubit/AppStates.dart';
import 'package:enginner/Models/OfferModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OfferStepsScreen extends StatefulWidget {
  const OfferStepsScreen({super.key, required this.orderId, required this.id});
final String orderId;
  final String  id;
  @override
  State<OfferStepsScreen> createState() => _OfferStepsScreenState();
}

class _OfferStepsScreenState extends State<OfferStepsScreen> {
  List<OfferModel> offerModels=[];
  List<String> ids=[];
  @override
  Widget build(BuildContext context) {


    return   BlocConsumer<AppCubit,AppStates>(
        listener: (context,state){

        },
        builder: (context,state) {
          return  Scaffold(
            appBar: AppBar(),
            body: StreamBuilder<QuerySnapshot>(

                stream: FirebaseFirestore.instance.collection('orders').doc(widget.orderId).collection('offers').doc(widget.id).collection('offer').snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.data!=null){
                    offerModels.clear();
                    for (var doc in snapshot.data!.docs) {

                        final model = OfferModel(
                          state:doc['state'],
                          description:doc['description'],
                          title: doc['title'],
                          duration: doc['duration'],
                          price: doc['price'],
                        );
                        offerModels.add(model);
                        ids.add(doc.id);

                    }
                  }
                      return ConditionalBuilder(
                    condition: offerModels.isNotEmpty,
                    builder: (BuildContext context) {return offerBuilder( tasks:offerModels, id: widget.id, orderId: widget.orderId,offerIds: ids, context1: this.context ); },
                    fallback: (BuildContext context) { return const Center(child: Text('No plan steps !',style: TextStyle(color: Colors.grey),)); },);


              }
            ),
          );
        }
    );
  }
}
