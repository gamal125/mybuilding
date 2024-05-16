// ignore_for_file: file_names, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enginner/Componant/Componant.dart';
import 'package:enginner/Componant/cache_helper.dart';
import 'package:enginner/Cubit/AppCubit.dart';
import 'package:enginner/CustomerLayout/stores/AllWorkersScreen.dart';
import 'package:enginner/CustomerLayout/stores/workerDetailsScreen.dart';
import 'package:enginner/Models/UserModel.dart';
import 'package:flutter/material.dart';
import '../../Models/StoreModel.dart';

class CustomerStoresScreen extends StatefulWidget {
  const CustomerStoresScreen({super.key});

  @override
  State<CustomerStoresScreen> createState() => _CustomerStoresScreenState();
}

class _CustomerStoresScreenState extends State<CustomerStoresScreen> {
  List<UserModel> userModels=[];
  List<StoreModel> storeModels=[];
  var id=CacheHelper.getData(key: 'uId');
  List<StoreModel>  Search=[];
  List<StoreModel>  filesSearch=[];
  var searchController=TextEditingController();
  @override
  void initState() {

    id!=null?AppCubit.get(context).getUser2(id):null;
    super.initState();


  }
  @override
  Widget build(BuildContext context) {
    var  screenSize= MediaQuery.of(context).size;
    return Column(
      children: [
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
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("workers",style: TextStyle(color: Colors.black,fontSize: screenSize.width*0.05,fontWeight: FontWeight.bold),),
              Row(
                children: [
                  TextButton(onPressed: () {

                    userModels.isNotEmpty?navigateTo(context, AllWorkersScreen(users: userModels,)):null;
                  },
                      child: Text("See All",style: TextStyle(color: Colors.grey,fontSize: screenSize.width*0.04,fontWeight: FontWeight.bold),)),
                  Icon(Icons.arrow_forward_ios,color: Colors.grey,size:screenSize.width*0.04 ,)
                ],
              ),

            ],),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height*0.14,
          child: StreamBuilder<QuerySnapshot>(
              stream:FirebaseFirestore.instance.collection('users').orderBy('rate',descending: true).snapshots(),
              builder: (context,snapshot){
                if(snapshot.data!=null){
                  userModels.clear();
                  for (var doc in snapshot.data!.docs) {
                    if(doc['userRole']=='worker'){

                      final model = UserModel(
                        firstName:doc['firstName'],
                        lastName:doc['lastName'],
                        phone:doc['phone'],
                        email:doc['email'],
                        uId:doc['uId'],
                        image:doc['image'],
                        userRole:doc['userRole'],
                        address:doc['address'],
                        major:doc['major'],
                        rate:doc['rate'],
                        cash:doc['cash'],

                      );
                      userModels.add(model);
                    }
                  }}
                return snapshot.data!=null? ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {return workerWidget(userModels[index],);  },
                  itemCount: userModels.length,

                ):const SizedBox();
              }

          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Stores",style: TextStyle(color: Colors.black,fontSize: screenSize.width*0.05,fontWeight: FontWeight.bold),),


            ],),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
              stream:FirebaseFirestore.instance.collection('stores').snapshots(),
              builder: (context,snapshot){
                if(snapshot.data!=null){
                  storeModels.clear();
                  for (var doc in snapshot.data!.docs) {
          
                    final model = StoreModel(
                      address:doc['address'],
                      id:doc['id'],
                      image:doc['image'],
                      phone:doc['phone'],
                      storeName:doc['storeName'],
                      rate:doc['rate'],
                    );
                    storeModels.add(model);
          
                  }}
                return snapshot.data!=null?   Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: SingleChildScrollView(
                    child: GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        crossAxisSpacing: 15.0,
                        mainAxisSpacing: 15,
                        childAspectRatio: 1 / 1.4,
                        children: searchController.text.isEmpty? List.generate(
                            storeModels.length, (index) => storeWidget(storeModels[index],context)):
                        List.generate(
                            filesSearch.length, (index) => storeWidget(filesSearch[index],context))
                    ),
                  ),
                ):const SizedBox();
              }
          
          ),
        ),
      ],
    );
  }
  Widget workerWidget(UserModel model)=>InkWell(
    onTap: (){
      navigateTo(context, WorkerDetailsScreen(model: model, haveOrder: false,));
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          Stack(
            alignment: AlignmentDirectional.topEnd,
            children: [
              Container(
                width: MediaQuery.of(context).size.width*0.25,
                height: MediaQuery.of(context).size.height*0.11,
    
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.green,width: 1),
                    image:model.image==''? const DecorationImage(image: AssetImage('assets/images/worker.png'),fit: BoxFit.cover):
                    DecorationImage(image: NetworkImage(model.image),fit: BoxFit.cover)
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white,),
                      child: const Icon(Icons.star, color: Colors.orange,size: 15,)),
                  const SizedBox(width: 1,),
                  Text(model.rate.toStringAsFixed(1),style: const TextStyle(color: Colors.grey),)
                ],)
            ],
          ),
          const SizedBox(height: 5,),
          Expanded(child: Text('${model.firstName} ${model.lastName}',maxLines: 1,overflow: TextOverflow.ellipsis,)),
    
        ],
      ),
    ),
  );

  void searchPhone(String query) async {
    final suggest=storeModels.where((service){
      final serviceTitle=service.storeName.toLowerCase();
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
