// ignore_for_file: file_names, non_constant_identifier_names

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:enginner/Componant/Componant.dart';
import 'package:enginner/Componant/cache_helper.dart';
import 'package:enginner/CustomerLayout/orders/AddOrderScreen.dart';
import 'package:enginner/CustomerLayout/Offers/CustomerOffersScreen.dart';
import 'package:enginner/CustomerLayout/orders/CustomerOrdersScreen.dart';
import 'package:enginner/CustomerLayout/profile/CustomerProfileScreen.dart';
import 'package:enginner/CustomerLayout/stores/CustomerStoresScreen.dart';
import 'package:flutter/material.dart';

import '../Cubit/AppCubit.dart';
import 'RentedProductsScreen.dart';

class CustomerLayout extends StatefulWidget {
  const CustomerLayout({super.key,required this.type});
  final String type;
  @override
  State<CustomerLayout> createState() => _CustomerLayoutState();
}

class _CustomerLayoutState extends State<CustomerLayout> {
  List<Widget> screens=[
    const CustomerStoresScreen(),
    const CustomerOrdersScreen(),
    const CustomerOffersScreen(),
    const RentedProductsScreen(),
    const CustomerProfileScreen(),
  ];
  List<BottomNavigationBarItem> BottomItems = [

    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.local_offer),
      label: 'Orders',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.groups_rounded),
      label: 'Offers',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.shopping_cart),
      label: 'Rented products',
    ),

    const BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'profile',
    ),
  ];

  int indexx=0;
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar: indexx==0? AppBar(
        iconTheme: const IconThemeData(color: Colors.white),

        leading:
        IconButton(
            onPressed: (){
              AwesomeDialog(
          body:    const Padding(
            padding: EdgeInsets.all(18.0),
            child: Column(
              children: [
                Text('هل تريد حقا تسجيل الخروج'),
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
          btnOkOnPress: () {
            AppCubit.get(context).signOut(context);
          },
        ).show();}, icon: const Icon(Icons.logout)),

        title: const Center(child: Text('Home page',style: TextStyle(color: Colors.white),)),

      ): indexx==1? AppBar(
        iconTheme: const IconThemeData(color: Colors.white),

        title: const Center(child: Text('Orders',style: TextStyle(color: Colors.white),)),

      ): indexx==2? AppBar(
        iconTheme: const IconThemeData(color: Colors.white),

        title: const Center(child: Text('Accepted Offers',style: TextStyle(color: Colors.white),)),

      ):indexx==3? AppBar(
        iconTheme: const IconThemeData(color: Colors.white),

        title: const Center(child: Text('Rented products',style: TextStyle(color: Colors.white),)),

      ):null,
      body: screens[indexx],
      bottomNavigationBar: BottomNavigationBar(

        backgroundColor:  Colors.yellow,

        items:  BottomItems,
        currentIndex: indexx,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.green,
        onTap: (index) {
          if(index==3) {
            AppCubit.get(context).getUser(CacheHelper.getData(key: 'uId'), );
          }
          setState(() {

            indexx=index;
          });
        },
      ),
      floatingActionButton: indexx==1?FloatingActionButton(onPressed: (){
        AppCubit.get(context).user!=null?
        navigateTo(context, const AddOrderScreen()):AppCubit.get(context).getUser2(CacheHelper.getData(key: 'uId'));},child: const Icon(Icons.add),):null,
    );
  }
}
