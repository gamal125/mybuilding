// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enginner/Componant/Componant.dart';
import 'package:enginner/Componant/cache_helper.dart';
import 'package:enginner/CustomerLayout/stores/ProductDetailsScreen.dart';
import 'package:enginner/Models/ProductModel.dart';
import 'package:enginner/Models/StoreModel.dart';
import 'package:flutter/material.dart';

class RentedProductsScreen extends StatefulWidget {
  const RentedProductsScreen({super.key});

  @override
  State<RentedProductsScreen> createState() => _RentedProductsScreenState();
}

class _RentedProductsScreenState extends State<RentedProductsScreen> {
  final String id = CacheHelper.getData(key: 'uId') as String;
  final List<StoreModel> storeModels = [];
  final List<ProductModel> productModels = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.75,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('stores').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                storeModels.clear();
                for (var doc in snapshot.data!.docs) {
                  final model = StoreModel(
                    address: doc['address'],
                    id: doc['id'],
                    image: doc['image'],
                    phone: doc['phone'],
                    storeName: doc['storeName'],
                    rate: doc['rate'],
                  );

                    storeModels.add(model);

                }

                return storeModels.isNotEmpty? ListView.builder(
                  itemCount: storeModels.length,
                  itemBuilder: (context, index) {
                    return StoreProductList(store: storeModels[index], id: id,);
                  },
                ):const Center(child: Text('لا توجد منتجات مستأجره!',style: TextStyle(color: Colors.grey),),);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class StoreProductList extends StatelessWidget {
  final StoreModel store;
  final String id;
   StoreProductList({super.key, required this.store,required this.id});
  final List<String> productIds = [];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('stores')
          .doc(store.id)
          .collection('products')
          .snapshots(),
      builder: (context, snapshot) {
        productIds.clear();
        if (!snapshot.hasData) {
          return const SizedBox();
        }

        final productModels = snapshot.data!.docs.map((doc) {
          productIds.add(doc.id);
          return  ProductModel(
            id: doc['id'],
            image: doc['image'],
            rate: doc['rate'],
            name: doc['name'],
            description: doc['description'],
            available: doc['available'],
            price: doc['price'],
            tenantId: doc['tenantId'],
            myTenantId:  doc['myTenantId'],
          );


        }).toList();

    return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: productModels.length,
    itemBuilder: (context, index) {
    final product = productModels[index];
    return ProductWidget(
    product: product,
      productId:productIds[index],
      myId: id,
    );});
      },
    );
  }
}

class ProductWidget extends StatelessWidget {
  final ProductModel product;
  final String myId;
  final String productId;


  const ProductWidget({super.key, required this.product,required this.myId,required this.productId,});

  @override
  Widget build(BuildContext context) {
    return product.tenantId==myId? InkWell(
      onTap: () {

        navigateTo(context, ProductDetailsScreen(model: product, id:productId, tenanted: true,));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
          border: Border.all(color: Colors.green, width: 1),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.25,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  image: product.image.isEmpty
                      ? const DecorationImage(
                    image: AssetImage('assets/images/worker.png'),
                    fit: BoxFit.fill,
                  )
                      : DecorationImage(
                    image: NetworkImage(product.image),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(product.name),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product.description,
                            style: const TextStyle(color: Colors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (index) {
                        if (index < product.rate.floor()) {
                          return const Icon(Icons.star, color: Colors.orange, size: 12);
                        } else if (index < product.rate.ceil()) {
                          return const Icon(Icons.star_half, color: Colors.orange, size: 12);
                        } else {
                          return const Icon(Icons.star_border, color: Colors.orange, size: 12);
                        }
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ):const SizedBox();
  }
}