// ignore_for_file: unnecessary_import, non_constant_identifier_names, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enginner/Componant/Componant.dart';
import 'package:enginner/Componant/cache_helper.dart';
import 'package:enginner/Cubit/AppCubit.dart';
import 'package:enginner/Models/StoreModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Models/UserModel.dart';
import 'EngineerProductsScreen.dart';

class EngineerStoresScreen extends StatefulWidget {
  const EngineerStoresScreen({super.key});

  @override
  State<EngineerStoresScreen> createState() => _EngineerStoresScreenState();
}

class _EngineerStoresScreenState extends State<EngineerStoresScreen> {
  var id=CacheHelper.getData(key: 'uId');
  List<UserModel> userModels=[];
  List<StoreModel> storeModels=[];

  List<UserModel>  Search=[];
  List<UserModel>  filesSearch=[];
  var searchController=TextEditingController();
  @override
  void initState() {

    id!=null?AppCubit.get(context).getUser2(id):null;
    super.initState();


  }
  @override
  Widget build(BuildContext context) {
    var  screenSize= MediaQuery.of(context).size;
    return ListView(
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
                  TextButton(onPressed: () {  },
                      child: Text("See All",style: TextStyle(color: Colors.grey,fontSize: screenSize.width*0.04,fontWeight: FontWeight.bold),)),
                  Icon(Icons.arrow_forward_ios,color: Colors.grey,size:screenSize.width*0.04 ,)
                ],
              ),

            ],),
        ),
    SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height*0.16,
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
    StreamBuilder<QuerySnapshot>(
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
    return snapshot.data!=null?   GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 10.0,
      mainAxisSpacing: 10,
      childAspectRatio: 1 / 1.4,
      children: List.generate(
          storeModels.length, (index) => storeWidget(storeModels[index]))
    ):const SizedBox();
    }

    ),
      ],
    );
  }
  Widget workerWidget(UserModel model)=>Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    child: Column(
      children: [
        Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            Container(
              width: MediaQuery.of(context).size.width*0.25,
              height: MediaQuery.of(context).size.height*0.12,

              decoration: BoxDecoration(
                shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.deepPurpleAccent,width: 1),
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
                Text('${model.rate}',style: const TextStyle(color: Colors.grey),)
            ],)
          ],
        ),
        const SizedBox(height: 5,),
        Expanded(child: Text('${model.firstName} ${model.lastName}',maxLines: 1,overflow: TextOverflow.ellipsis,)),

      ],
    ),
  );
  Widget storeWidget(StoreModel model)=> InkWell(
    onTap:(){
      navigateTo(context, EngineerProductsScreen(id:model.id , storeName: model.storeName, phone: model.id,));
    },
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height*0.25,
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

                Text(model.storeName),

                Text(model.phone,style: const TextStyle(color: Colors.grey),),

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
    ),
  );
  void searchPhone(String query) async {
    final suggest=userModels.where((service){
      final serviceTitle=service.firstName.toLowerCase()+service.lastName.toLowerCase();
      final input=query.toLowerCase();
      return serviceTitle.contains(input);
    }).toList();

    final suggest1=userModels.where((service){
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
