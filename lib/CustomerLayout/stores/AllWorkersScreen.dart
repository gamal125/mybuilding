// ignore_for_file: must_be_immutable, non_constant_identifier_names, file_names

import 'package:enginner/Componant/Componant.dart';
import 'package:enginner/Models/UserModel.dart';
import 'package:flutter/material.dart';

class AllWorkersScreen extends StatefulWidget {
   AllWorkersScreen({super.key,required this.users});
List<UserModel>users;
  @override
  State<AllWorkersScreen> createState() => _AllWorkersScreenState();
}

class _AllWorkersScreenState extends State<AllWorkersScreen> {
  List<UserModel> Search=[];
  List<UserModel> filesSearch=[];
  var searchController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('All Worker'),
        centerTitle: true,
      ),
     body: Column(
       children: [
         const SizedBox(height: 15,),
         Row(
           children: [
             const Padding(
               padding: EdgeInsets.symmetric(horizontal: 8.0),
               child: Icon(Icons.search),
             ),
             Expanded(
               child: Padding(
                 padding: const EdgeInsets.only(right: 30.0),
                 child: TextField(
                   onChanged: (value){
                     searchPhone(value);
                     setState(() {
                       searchController.text=value;
                     });

                   },
                   textAlign:TextAlign.left,
                   controller: searchController,
                   cursorColor: Colors.black,
                   decoration:  InputDecoration(
                     labelText: "",
                     filled: true,
                     fillColor: Colors.white,
                     border:  OutlineInputBorder(
                       borderRadius:  BorderRadius.circular(30.0),
                     ),
                   ),

                   keyboardType: TextInputType.text,

                 ),
               ),

             ),
           ],
         ),

     searchController.text.isEmpty?
     Expanded(
       child: ListView.builder(
           itemCount: widget.users.length,
           itemBuilder: (context,index){
             return workerCard(widget.users[index],context);
           }),
     ):
     Expanded(
       child: ListView.builder(
           itemCount: filesSearch.length,
           itemBuilder: (context,index){
             return workerCard(filesSearch[index],context);
           }),
     ),
       ],
     ),

    );
  }
  void searchPhone(String query) async {
    final suggest=widget.users.where((service){
      final serviceTitle=service.firstName.toLowerCase()+service.lastName.toLowerCase();
      final input=query.toLowerCase();
      return serviceTitle.contains(input);
    }).toList();

    final suggest1=widget.users.where((service){
      final serviceTitle=service.major.toLowerCase();
      final input=query.toLowerCase();
      return serviceTitle.contains(input);
    }).toList();

    setState(() {
      filesSearch.clear();
      Search.clear();
      Search=suggest1+suggest;

      for (var element in Search) {
        filesSearch.contains(element)?null:filesSearch.add(element);
      }

      filesSearch.toSet().toList();


    });
  }

}
