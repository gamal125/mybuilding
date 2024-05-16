// ignore_for_file: file_names, non_constant_identifier_names

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:enginner/Componant/Componant.dart';
import 'package:enginner/Componant/cache_helper.dart';
import 'package:enginner/Cubit/AppCubit.dart';
import 'package:enginner/EngineerLayout/stores/AddStoreScreen.dart';
import 'package:flutter/material.dart';
import 'offers/EngineerOffersScreen.dart';
import 'orders/EngineerOrdersScreen.dart';
import 'profile/EngineerProfileScreen.dart';
import 'stores/EngineerStoresScreen.dart';

class EngineerLayout extends StatefulWidget {
  const EngineerLayout({super.key});
  @override
  State<EngineerLayout> createState() => _EngineerLayoutState();

}

class _EngineerLayoutState extends State<EngineerLayout> {
  List<Widget> screens=[
    const EngineerStoresScreen(),
    const EngineerOrdersScreen(),
    const EngineerOffersScreen(),
    const EngineerProfileScreen(),
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
      label: 'Rented products',
    ),

    const BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'profile',
    ),
  ];

  var searchController=TextEditingController();
  int indexx=0;
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      appBar:indexx==0? AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor:Colors.green ,
        leading:
        IconButton(onPressed: (){AwesomeDialog(
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

      ):indexx==2? AppBar(
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
            AppCubit.get(context).getUser(CacheHelper.getData(key: 'uId'),);
          }
          setState(() {

            indexx=index;
          });
        },
      ),
  floatingActionButton:indexx==0? FloatingActionButton(onPressed: (){
    navigateTo(context, const AddStoreScreen());
  },child: const Icon(Icons.add),):null,
    );
  }

}
