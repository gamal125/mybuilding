// ignore_for_file: file_names, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enginner/Componant/Componant.dart';
import 'package:enginner/Componant/cache_helper.dart';
import 'package:enginner/EngineerLayout/stores/AddProductScreen.dart';
import 'package:enginner/Models/ProductModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class EngineerProductsScreen extends StatefulWidget {
  const EngineerProductsScreen({super.key,required this.id,required this.storeName,required this.phone});
  final String id;
  final String storeName;
  final String phone;
  @override
  State<EngineerProductsScreen> createState() => _EngineerProductsScreenState();
}

class _EngineerProductsScreenState extends State<EngineerProductsScreen> {

  List<ProductModel> productModels=[];
  List<ProductModel>  Search=[];
  List<ProductModel>  filesSearch=[];
  String myId=CacheHelper.getData(key: 'uId');
  var searchController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    var  screenSize= MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.storeName),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: IconButton(onPressed: ()async{
              await   FlutterPhoneDirectCaller.callNumber(widget.phone);
            }, icon: const Icon(Icons.phone,color: Colors.white,)),
          )
        ],
      ),
      body: ListView(children: [
        const SizedBox(height: 10,),
        Row(
          children: [
            const SizedBox(width: 30,),
            const Icon(Icons.search),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0,left: 20,),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Products",style: TextStyle(color: Colors.black,fontSize: screenSize.width*0.05,fontWeight: FontWeight.bold),),


            ],),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: StreamBuilder<QuerySnapshot>(
              stream:FirebaseFirestore.instance.collection('stores').doc(widget.id).collection('products').snapshots(),
              builder: (context,snapshot){
                if(snapshot.data!=null){
                  productModels.clear();
                  for (var doc in snapshot.data!.docs) {

                    final model = ProductModel(
                      id:doc['id'],
                      image:doc['image'],
                      rate:doc['rate'],
                      name: doc['name'],
                      description: doc['description'],
                      available: doc['available'],
                      price: doc['price'],
                      tenantId: doc['tenantId'],
                      myTenantId: doc['myTenantId'],
                    );
                    productModels.add(model);

                  }}
                return snapshot.data!=null?
                GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1 / 1.42,
                    children:searchController.text.isEmpty? List.generate(
                        productModels.length, (index) => storeWidget(productModels[index])):List.generate(
                        filesSearch.length, (index) => storeWidget(filesSearch[index]))
                ):const SizedBox();
              }

          ),
        ),
      ],),
      floatingActionButton: widget.id==myId? FloatingActionButton(onPressed: (){
        navigateTo(context, const AddProductScreen());
      },child: const Icon(Icons.add),):null,
    );
  }
  Widget storeWidget(ProductModel model)=> Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(18),
      color: Colors.white,
      border: Border.all(color: Colors.green,width: 1),),
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height*0.22,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                image:model.image==''? const DecorationImage(image: AssetImage('assets/images/worker.png'),fit: BoxFit.fill):
                DecorationImage(image: NetworkImage(model.image),fit: BoxFit.fill)
            ),



          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                Text(model.name),

                Row(
                  children: [
                    Expanded(child: Text(model.description,style: const TextStyle(color: Colors.grey),maxLines: 1,overflow: TextOverflow.ellipsis,)),
                  ],
                ),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (index) {
                    if (index < model.rate.floor()) {
                      return const Icon(Icons.star, color: Colors.orange,size: 12,);
                    } else if (index < model.rate.ceil()) {
                      return const Icon(Icons.star_half, color: Colors.orange,size: 12,);
                    } else {
                      return const Icon(Icons.star_border, color: Colors.orange,size: 12,);
                    }
                  }),
                )
              ],),
          )


        ],
      ),
    ),
  );
  void searchPhone(String query) async {
    final suggest=productModels.where((service){
      final serviceTitle=service.name.toLowerCase();
      final input=query.toLowerCase();
      return serviceTitle.contains(input);
    }).toList();


    setState(() {
      filesSearch.clear();
      Search.clear();
      Search=suggest;

      for (var element in Search) {
        filesSearch.contains(element)?null:filesSearch.add(element);
      }

      filesSearch.toSet().toList();


    });
  }
}
