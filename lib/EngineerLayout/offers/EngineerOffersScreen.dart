// ignore_for_file: file_names

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enginner/Componant/Componant.dart';
import 'package:enginner/Componant/cache_helper.dart';
import 'package:enginner/Models/ProductModel.dart';
import 'package:flutter/material.dart';

class EngineerOffersScreen extends StatefulWidget {
  const EngineerOffersScreen({super.key});

  @override
  State<EngineerOffersScreen> createState() => _EngineerOffersScreenState();
}

class _EngineerOffersScreenState extends State<EngineerOffersScreen> {
  List<ProductModel> productModels=[];
  List<String> productsIds=[];
  var id=CacheHelper.getData(key: 'uId');
  @override
  Widget build(BuildContext context) {
    return     Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 15),
      child: StreamBuilder<QuerySnapshot>(
          stream:FirebaseFirestore.instance.collection('stores').doc(id).collection('products').snapshots(),
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
                if( !model.available) {
                  productModels.add(model);
                  productsIds.add(doc.id);
                }

              }}
            return snapshot.data!=null?
            GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10,
                childAspectRatio: 1 / 1.7,
                children: List.generate(
                    productModels.length, (index) => productsIds.isNotEmpty? productWidget(productModels[index],productsIds[index]):const Center(child: Text('لا توجد منتجات مستأجره!',style: TextStyle(color: Colors.black),),))
            ):const Center(child: Text('لا توجد منتجات مستأجره!',style: TextStyle(color: Colors.grey),),);
          }

      ),
    );
  }
  Widget productWidget(ProductModel model,String docId)=> Card(
    child: Container(
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
                  ),
                  defaultMaterialButton(function: (){
                    AwesomeDialog(
                      body:    const Padding(
                        padding: EdgeInsets.all(18.0),
                        child: Column(
                          children: [
                            Text('هل استلمت المنتج بالفعل ؟'),
                            SizedBox(height: 20,),

                          ],
                        ),
                      ),
                      context: context,
                      dialogType: DialogType.warning,
                      animType: AnimType.rightSlide,

                      btnCancelOnPress: () {},
                      btnCancelText: 'لا',
                      btnOkText: 'نعم',
                      btnOkOnPress: ()  {
                         FirebaseFirestore.instance.collection('stores').doc(model.id).collection('products').
                        doc(docId).update({'available':true});
                         FirebaseFirestore.instance.collection('stores').doc(model.id).collection('products').
                        doc(docId).update({'tenantId':''});
                        showToast(text: 'تم استلام المنتج', state: ToastStates.success);
                      },
                    ).show();
                  }, text: 'استلام', context: context,color: Colors.green)
                ],),
            )
    
    
          ],
        ),
      ),
    ),
  );
}
