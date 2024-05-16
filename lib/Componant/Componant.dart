// ignore_for_file: file_names, prefer_const_literals_to_create_immutables


import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:enginner/Componant/cache_helper.dart';
import 'package:enginner/Cubit/AppCubit.dart';
import 'package:enginner/CustomerLayout/Offers/AcceptedOffersScreen.dart';
import 'package:enginner/CustomerLayout/Offers/OfferStepsScreen.dart';
import 'package:enginner/CustomerLayout/orders/OffersScreen.dart';
import 'package:enginner/CustomerLayout/stores/CustomerProductsScreen.dart';
import 'package:enginner/CustomerLayout/stores/workerDetailsScreen.dart';
import 'package:enginner/EngineerLayout/orders/AddOfferScreen.dart';
import 'package:enginner/Models/OfferModel.dart';
import 'package:enginner/Models/OrderModel.dart';
import 'package:enginner/Models/StoreModel.dart';
 import 'package:enginner/Models/TotalOfferModel.dart';
import 'package:enginner/Models/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
 import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

 Widget defaultTextButton({
  required Function function,
  required String text,
}) =>
    TextButton(
      onPressed: () {
        function();
      },
      child: Text(text,style: const TextStyle(color: Colors.cyan),),
    );
void navigateTo(context, widget) => Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => widget,
  ),
);
void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
    builder: (_) => widget,
  ),
      (route) => false,
);
Widget defaultTextFormField({
  FocusNode? focusNode,
  required TextEditingController controller,
  required TextInputType keyboardType,
  required String? Function(String?) validate,
  required String label,
  Color? fillColor,
  String? hint,
  int? max,
  int? min,

  onTap,
  onChanged,
  Function(String)? onFieldSubmitted,
  bool isPassword = false,
  bool isClickable = true,
  InputDecoration? decoration,
  IconData? suffix,
  IconData? prefix,
  Function? suffixPressed,
}) =>
    Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(

        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        maxLines:max?? 1,
        minLines:min?? 1,
        controller: controller,
        validator: validate,
        enabled: isClickable,
        onTap: onTap,
        onFieldSubmitted: onFieldSubmitted,
        onChanged: onChanged,
        obscureText: isPassword,
        keyboardType: keyboardType,
        autofocus: false,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          hintTextDirection: TextDirection.rtl,

          prefixIcon: Icon(
            prefix,
            color: Colors.grey,
          ),
          suffixIcon: suffix != null ? IconButton(
            onPressed: () {suffixPressed!();},
            icon: Icon(suffix, color: Colors.grey,),
          ):null,
          filled: true,
          isCollapsed: false,
          fillColor:fillColor?? Colors.white,
          hoverColor: Colors.red.withOpacity(0.2),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color:Colors.white,
            ),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),
          labelText: label,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          focusColor: const Color.fromRGBO(199, 0, 58,1),
          disabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.green,
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
callNumber(String number) async{
   //set the number here
  await FlutterPhoneDirectCaller.callNumber("+96$number");
}
Widget storeWidget(StoreModel model,BuildContext context)=> InkWell(
  onTap:(){
    navigateTo(context, CustomerProductsScreen(id: model.id, storeName: model.storeName, phone: model.phone,));
  },
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
Widget workerCard(UserModel model,context)=>InkWell(

    onTap: (){
      navigateTo(context, WorkerDetailsScreen(model: model,haveOrder: false,));

  },
  child: Padding(
    padding: const EdgeInsets.only(left: 1.0,right: 20,top: 10,bottom: 10),
    child: Card(
      elevation: 4,
      child: Container(
        height: MediaQuery.of(context).size.height*0.3,
        width: MediaQuery.of(context).size.width*0.9,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.green,Colors.cyan]),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:10.0),
              child: Container(
                height: MediaQuery.of(context).size.height*0.25,
                width: MediaQuery.of(context).size.width*0.26,

                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    image:model.image==''? const DecorationImage(image: AssetImage('assets/images/worker.png'),fit: BoxFit.fill):
                    DecorationImage(image: NetworkImage(model.image),fit: BoxFit.fill)
                ),
              ),
            ),
            Column(
              mainAxisAlignment:MainAxisAlignment.spaceEvenly,

              children: [
                Text('Name: ',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.045,fontWeight: FontWeight.bold),),
                Text('Phone: ',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.045,fontWeight: FontWeight.bold),),
                Text('Major: ',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.045,fontWeight: FontWeight.bold),),
                Text('Address: ',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.045,fontWeight: FontWeight.bold),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                  InkWell(onTap: (){
                    sendToWhatsApp(phone:model.phone.toString());
                  },
                  child:SvgPicture.asset('assets/images/whatsapp96.svg',width:MediaQuery.of(context).size.width*0.065 ,height: MediaQuery.of(context).size.height*0.065,),

                  ),
                ],)
              ],),
            Expanded(
              child: Column(
                mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(model.firstName,style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.04),overflow: TextOverflow.ellipsis,maxLines: 1,),
                      const SizedBox(width: 5,),
                      Text(model.lastName,style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.04),overflow: TextOverflow.ellipsis,maxLines: 1,),
                    ],
                  ),
                  Text(model.phone,style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.04),overflow: TextOverflow.ellipsis,maxLines: 1,),
                  Text(model.major,style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.04),overflow: TextOverflow.ellipsis,maxLines: 1,)
                  , Text(model.address,style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.04),overflow: TextOverflow.ellipsis,maxLines: 1,)
               ,   Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Container(
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white
                        ),
                        child: IconButton(onPressed: (){
                          callNumber(model.phone);
                        }, icon: const Icon(Icons.phone,color: Colors.green,)))
                  ],)
              ,

                ],
              ),
            )

          ],
        ),
      ),
    ),
  ),
);
void sendToWhatsApp({required String phone,})async{
  var mes='مرحبا!';
  var url='https://api.whatsapp.com/send?phone=966$phone&text=$mes';
  await launchUrl(Uri.parse(url),mode: LaunchMode.externalApplication);
}
Widget defaultMaterialButton({
  required Function function,
  required String text,
  required var context,
  Color color=Colors.cyan,


  double radius = 5.0,
  bool isUpperCase = true,
  Function? onTap,
}) =>
    Container(
      width: MediaQuery.of(context).size.width*0.8,
      height: MediaQuery.of(context).size.width*0.12,
      decoration: BoxDecoration(
        gradient:  LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color,Colors.cyan]),
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: color,
        //  color: background,
      ),
      child: MaterialButton(
        onPressed: () {
          function();
        },
        child: Text(
          text,
          textAlign:TextAlign.start,


          style: const TextStyle(

            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
      ),
    );
Widget orderCard(OrderModel model,context)=>InkWell(
  onTap: (){


    AppCubit.get(context).user!.userRole!='worker'?  navigateTo(context, OffersScreen(model:model )):null;
  },
  child: Padding(
    padding: const EdgeInsets.only(left: 10.0,right: 10,top: 5,bottom: 10),
    child: Card(
      elevation: 8,
      child: Container(
        height: MediaQuery.of(context).size.height*0.4,
        width: MediaQuery.of(context).size.width*0.95,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.green,Colors.green]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 5),
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.14,
                    width: MediaQuery.of(context).size.width*0.26,

                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        image:model.orderImage==''? const DecorationImage(image: AssetImage('assets/images/worker.png'),fit: BoxFit.fill):
                        DecorationImage(image: NetworkImage(model.orderImage),fit: BoxFit.fill)
                    ),
                  ),
                ),

                Column(
                  mainAxisAlignment:MainAxisAlignment.spaceEvenly,

                  children: [
                    Text('Name: ',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.045,fontWeight: FontWeight.bold),),
                    const SizedBox(height: 5,),
                    Text('Phone: ',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.045,fontWeight: FontWeight.bold),),
                    const SizedBox(height: 5,),
                    Text('address: ',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.045,fontWeight: FontWeight.bold),),
                    const SizedBox(height: 5,),
                    Text('state: ',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.045,fontWeight: FontWeight.bold),),

                  ],),
                Expanded(
                  child: Column(
                    mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(model.publisherName,style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.04),overflow: TextOverflow.ellipsis,maxLines: 1,),

                      const SizedBox(height: 5,),
                      Text(model.publisherPhone,style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.04),overflow: TextOverflow.ellipsis,maxLines: 1,),
                      const SizedBox(height: 5,),
                      Text(model.address,style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.04),overflow: TextOverflow.ellipsis,maxLines: 1,)
                     , const SizedBox(height: 5,),
                AppCubit.get(context).user!.userRole=='worker'&& model.state!=''?
                 Text('! يوجد بعض العروض  ',style: TextStyle(color: Colors.black,fontSize: MediaQuery.of(context).size.width*0.04),overflow: TextOverflow.ellipsis,maxLines: 1,)
:                 Text('! لا يوجد عروض حتي الان',style: TextStyle(color: Colors.black,fontSize: MediaQuery.of(context).size.width*0.04),overflow: TextOverflow.ellipsis,maxLines: 1,)

                    ],),
                )

              ],
            ),
            const SizedBox(height: 5,),
            Text('description: ',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.045,fontWeight: FontWeight.bold),),

    Expanded(child: Center(child: Text(model.description,style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.04),overflow: TextOverflow.ellipsis,maxLines: 4,)))
,
  AppCubit.get(context).user!.userRole!='worker'?  Center(
      child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: defaultMaterialButton3(function: (){

                  AwesomeDialog(
                    body:    const Padding(
                      padding: EdgeInsets.all(18.0),
                      child: Column(
                        children: [
                          Text('هل تريد حقا حذف الطلب؟'),
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

                      FirebaseFirestore.instance.collection('orders').doc(model.orderId).delete();
                    },
                  ).show();

                }, text: 'Delete', context: context,color: Colors.red),
              ),
    ):Center(
      child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: defaultMaterialButton3(function: (){
navigateTo(context, AddOfferScreen(
  workerRate: AppCubit.get(context).user!.rate,
  name: '${AppCubit.get(context).user!.firstName}  ${AppCubit.get(context).user!.firstName}',
  id: AppCubit.get(context).user!.uId,
  image: AppCubit.get(context).user!.image,
  phone:AppCubit.get(context).user!.phone, orderId:model.orderId,));
                }, text: 'Add Offer', context: context,color: Colors.black),
              ),
    ),
            const SizedBox(height: 5,),   ],
        ),
      ),
    ),
  ),
);
Widget acceptedOrderCard(OrderModel model,context)=>InkWell(
  onTap: (){
    navigateTo(context, AcceptedOffersScreen(model:model ));
  },
  child: Padding(
    padding: const EdgeInsets.only(left: 10.0,right: 10,top: 5,bottom: 10),
    child: Card(
      elevation: 8,
      child: Container(
        height: MediaQuery.of(context).size.height*0.4,
        width: MediaQuery.of(context).size.width*0.95,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.green,Colors.green]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:10.0,vertical: 5),
                  child: Container(
                    height: MediaQuery.of(context).size.height*0.14,
                    width: MediaQuery.of(context).size.width*0.26,

                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        image:model.orderImage==''? const DecorationImage(image: AssetImage('assets/images/worker.png'),fit: BoxFit.fill):
                        DecorationImage(image: NetworkImage(model.orderImage),fit: BoxFit.fill)
                    ),
                  ),
                ),

                Column(
                  mainAxisAlignment:MainAxisAlignment.spaceEvenly,

                  children: [
                    Text('Name: ',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.045,fontWeight: FontWeight.bold),),
                    const SizedBox(height: 5,),
                    Text('Phone: ',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.045,fontWeight: FontWeight.bold),),
                    const SizedBox(height: 5,),
                    Text('address: ',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.045,fontWeight: FontWeight.bold),),
                    const SizedBox(height: 5,),
                    Text('state: ',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.045,fontWeight: FontWeight.bold),),

                  ],),
                Expanded(
                  child: Column(
                    mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(model.publisherName,style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.04),overflow: TextOverflow.ellipsis,maxLines: 1,),

                      const SizedBox(height: 5,),
                      Text(model.publisherPhone,style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.04),overflow: TextOverflow.ellipsis,maxLines: 1,),
                      const SizedBox(height: 5,),
                      Text(model.address,style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.04),overflow: TextOverflow.ellipsis,maxLines: 1,)
                      , const SizedBox(height: 5,),
                      model.state!=''?
                      Text(model.state,style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.04),overflow: TextOverflow.ellipsis,maxLines: 1,)
                          :                 Text('! لا يوجد عروض حتي الان',style: TextStyle(color: Colors.black,fontSize: MediaQuery.of(context).size.width*0.04),overflow: TextOverflow.ellipsis,maxLines: 1,)

                    ],),
                )

              ],
            ),
            const SizedBox(height: 5,),
            Text('description: ',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.045,fontWeight: FontWeight.bold),),

            Expanded(child: Center(child: Text(model.description,style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.04),overflow: TextOverflow.ellipsis,maxLines: 4,)))
            ,
            AppCubit.get(context).user!.userRole!='worker'?  Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: defaultMaterialButton3(function: (){

                  AwesomeDialog(
                    body:    const Padding(
                      padding: EdgeInsets.all(18.0),
                      child: Column(
                        children: [
                          Text('هل تريد حقا حذف الطلب؟'),
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
                      FirebaseFirestore.instance.collection('orders').doc(model.orderId).delete();
                    },
                  ).show();

                }, text: 'Delete', context: context,color: Colors.red),
              ),
            ):Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: defaultMaterialButton3(function: (){
                  navigateTo(context, AddOfferScreen(
                    workerRate: AppCubit.get(context).user!.rate,
                    name: '${AppCubit.get(context).user!.firstName}  ${AppCubit.get(context).user!.firstName}',
                    id: AppCubit.get(context).user!.uId,
                    image: AppCubit.get(context).user!.image,
                    phone:AppCubit.get(context).user!.phone, orderId:model.orderId,));
                }, text: 'Add Offer', context: context,color: Colors.black),
              ),
            ),
            const SizedBox(height: 5,),   ],
        ),
      ),
    ),
  ),
);
Widget offerCard(TotalOfferModel model,String orderId,context)=>InkWell(
  onTap: (){},
  child: Padding(
    padding: const EdgeInsets.only(left: 10.0,right: 10,top: 5,bottom: 10),
    child: Card(
      elevation: 8,
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width*0.3,
                      height: MediaQuery.of(context).size.height*0.15,

                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Colors.amber,width: 1),
                          image:model.image==''? const DecorationImage(image: AssetImage('assets/images/worker.png'),fit: BoxFit.cover):
                          DecorationImage(image: NetworkImage(model.image),fit: BoxFit.cover)
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black,),
                            child: const Icon(Icons.star, color: Colors.orange,size: 15,)),
                        const SizedBox(width: 1,),
                        Text(model.workerRate.toStringAsFixed(1),style: const TextStyle(color: Colors.amber,fontWeight: FontWeight.w900),)
                      ],)
                  ],
                ),
              ),

              Column(
                mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.045,fontWeight: FontWeight.bold),),
                  const SizedBox(height: 5,),
                  Text('Phone: ',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.045,fontWeight: FontWeight.bold),),
                  const SizedBox(height: 5,),
                  Text('price: ',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.045,fontWeight: FontWeight.bold),),
                  const SizedBox(height: 5,),
                  Text('duration: ',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.045,fontWeight: FontWeight.bold),),

                ],),
              Expanded(
                child: Column(
                  mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(model.name,style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.045),overflow: TextOverflow.ellipsis,maxLines: 1,),
                    const SizedBox(height: 5,),
                    Text(model.phone,style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.045),overflow: TextOverflow.ellipsis,maxLines: 1,),
                    const SizedBox(height: 5,),
                    Text(model.totalPrice.toString(),style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.045),overflow: TextOverflow.ellipsis,maxLines: 1,)
                    , const SizedBox(height: 5,),
                            Text(model.totalDays.toString(),style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.045),overflow: TextOverflow.ellipsis,maxLines: 1,)

                  ],),
              )

            ],
          ),
          const SizedBox(height: 5,),

           Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: defaultMaterialButton3(function: (){

                AwesomeDialog(
                  body:    const Padding(
                    padding: EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        Text('هل تريد حقا قبول العرض؟'),
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
                  FirebaseFirestore.instance.collection('orders').doc(orderId).update({'state':'accepted'});
                  FirebaseFirestore.instance.collection('orders').doc(orderId).collection('offers').doc(model.id).update({'state':'accepted'});
                  },
                ).show();

              }, text: 'Accept', context: context,color: Colors.green),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: defaultMaterialButton3(function: (){
                navigateTo(context, OfferStepsScreen(orderId: orderId, id: model.id,));

              }, text: 'show plan', context: context,color: Colors.grey),
            ),
          ),
          const SizedBox(height: 5,),   ],
      ),
    ),
  ),
);
Widget acceptedOfferCard(TotalOfferModel model,String orderId,context)=>InkWell(
  onTap: (){

  },
  child: Padding(
    padding: const EdgeInsets.only(left: 10.0,right: 10,top: 5,bottom: 10),
    child: Card(
      elevation: 8,
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width*0.3,
                      height: MediaQuery.of(context).size.height*0.15,

                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Colors.amber,width: 1),
                          image:model.image==''? const DecorationImage(image: AssetImage('assets/images/worker.png'),fit: BoxFit.cover):
                          DecorationImage(image: NetworkImage(model.image),fit: BoxFit.cover)
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black,),
                            child: const Icon(Icons.star, color: Colors.orange,size: 15,)),
                        const SizedBox(width: 1,),
                        Text(model.workerRate.toStringAsFixed(1),style: const TextStyle(color: Colors.amber,fontWeight: FontWeight.w900),)
                      ],)
                  ],
                ),
              ),

              Column(
                mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.045,fontWeight: FontWeight.bold),),
                  const SizedBox(height: 5,),
                  Text('Phone: ',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.045,fontWeight: FontWeight.bold),),
                  const SizedBox(height: 5,),
                  Text('price: ',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.045,fontWeight: FontWeight.bold),),
                  const SizedBox(height: 5,),
                  Text('duration: ',style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.045,fontWeight: FontWeight.bold),),

                ],),
              Expanded(
                child: Column(
                  mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(model.name,style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.045),overflow: TextOverflow.ellipsis,maxLines: 1,),
                    const SizedBox(height: 5,),
                    Text(model.phone,style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.045),overflow: TextOverflow.ellipsis,maxLines: 1,),
                    const SizedBox(height: 5,),
                    Text(model.totalPrice.toString(),style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.045),overflow: TextOverflow.ellipsis,maxLines: 1,)
                    , const SizedBox(height: 5,),
                    Text(model.totalDays.toString(),style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width*0.045),overflow: TextOverflow.ellipsis,maxLines: 1,)

                  ],),
              )

            ],
          ),
          const SizedBox(height: 5,),

          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: defaultMaterialButton3(function: (){

                AwesomeDialog(
                  body:    const Padding(
                    padding: EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        Text(' !! انت علي وشك دفع جميع الرسوم  '),
                        SizedBox(height: 20,),
                        Text(' هل حقا استلمت المشروع بالكامل ؟ '),
                      ],
                    ),
                  ),
                  context: context,
                  dialogType: DialogType.warning,
                  animType: AnimType.rightSlide,

                  btnCancelOnPress: () {},
                  btnCancelText: 'إلغاء',
                  btnOkText: 'تم',
                  btnOkOnPress: () async {
                    var myCash=AppCubit.get(context).user!.cash;
                if(myCash>=model.totalPrice){
                UserModel? model2= AppCubit.get(context).engineerModel;
                if( model2!=null){
                await FirebaseFirestore.instance.collection('orders').doc(orderId).collection('offers').doc(model.id).delete();
                await FirebaseFirestore.instance.collection('orders').doc(orderId).delete();
                await FirebaseFirestore.instance.collection('users').doc(model.id).update({'cash':model.totalPrice+model2.cash});
                await FirebaseFirestore.instance.collection('users').doc(model.id).update({'cash':myCash-model.totalPrice});
                navigateTo(context, WorkerDetailsScreen(model: model2, haveOrder: true,));
                }else{
                showToast(text: 'try again', state: ToastStates.warning);
                }

                }else{
                  showToast(text: 'you not have enough cash', state: ToastStates.warning);
                }
                  },
                ).show();

              }, text: 'استلام العمل بالكامل', context: context,color: Colors.green),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: defaultMaterialButton3(function: (){
                navigateTo(context, OfferStepsScreen(orderId: orderId, id: model.id,));

              }, text: 'show plan', context: context,color: Colors.grey),
            ),
          ),
          const SizedBox(height: 5,),   ],
      ),
    ),
  ),
);
Widget buildTaskItem(OfferModel model,int index,BuildContext context, String id, String orderId, ) => Dismissible(
  key: Key(index.toString()),
  child: Card(
    elevation: 20.0,
    color: Colors.grey[200],
    margin: const EdgeInsetsDirectional.all(20),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 40.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      model.duration.toStringAsFixed(0),
                    ),
                    const Text(
                      'Days',
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.title,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            model.description,
                            style: const TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'price',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${model.price} \$',
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ],
                  ),


                ],
              ),

              const SizedBox(
                width: 20.0,
              ),

            ],
          ),
        ),

      ],
    ),
  ),
  onDismissed: (direction) {
    AppCubit.get(context).DeleteFromOfferList(
      id: index,
    );
  },
);
Widget buildOfferItem(OfferModel model,int index,BuildContext context, String id, String orderId, String offerId,int isLast) => Dismissible(
  key: Key(index.toString()),
  child: Card(
    elevation: 20.0,
    color: Colors.grey[200],
    margin: const EdgeInsetsDirectional.all(20),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 40.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      model.duration.toStringAsFixed(0),
                    ),
                    const Text(
                      'Days',
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 20.0,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.title,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            model.description,
                            style: const TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'price',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${model.price} \$',
                        style: const TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ],
                  ),


                ],
              ),

              const SizedBox(
                width: 20.0,
              ),

            ],
          ),
        ),
        defaultMaterialButton3(function: (){
          AwesomeDialog(
            body:    const Padding(
              padding: EdgeInsets.all(18.0),
              child: Column(
                children: [
                  Text(' !! انت علي وشك دفع الرسوم  '),
                  SizedBox(height: 20,),
                  Text(' هل حقا استلمت هذه المرحله ؟ '),
                ],
              ),
            ),
            context: context,
            dialogType: DialogType.warning,
            animType: AnimType.rightSlide,

            btnCancelOnPress: () {},
            btnCancelText: 'إلغاء',
            btnOkText: 'تم',
            btnOkOnPress: () async {
              var myCash=AppCubit.get(context).user!.cash;
              TotalOfferModel? model3;
              var myId=CacheHelper.getData(key: 'uId');
              if(myCash>=model.price){
                UserModel? model2= AppCubit.get(context).engineerModel;
                if( model2!=null){
               await FirebaseFirestore.instance.collection('orders').doc(orderId).collection('offers').doc(id).collection('offer').doc(offerId).delete();
               await FirebaseFirestore.instance.collection('orders').doc(orderId).collection('offers').doc(id).get().then((value) async {
                  model3=TotalOfferModel.fromJson(value.data()!);
                 await FirebaseFirestore.instance.collection('orders').doc(orderId).collection('offers').doc(id).update({
                    'totalDays':model3!.totalDays-model.duration,
                    'totalPrice':model3!.totalPrice-model.price,
                  });
              });

               isLast==1?  await FirebaseFirestore.instance.collection('orders').doc(orderId).collection('offers').doc(id).delete():null;
                  isLast==1? await FirebaseFirestore.instance.collection('orders').doc(orderId).delete():null;
               await FirebaseFirestore.instance.collection('users').doc(id).update({'cash':model.price+model2.cash});
                await FirebaseFirestore.instance.collection('users').doc(myId).update({'cash':myCash-model.price}).then((value) {
                  isLast==1?navigateTo(context, WorkerDetailsScreen(model: model2, haveOrder: true,)):null;
                });


                }else{
                 showToast(text: 'try again', state: ToastStates.warning);
                }

              }else{
               showToast(text: 'you not have enough cash', state: ToastStates.warning);
              }
            },
          ).show();
        }, text: 'استلام',color: Colors.green, context: context),
        const SizedBox(
          height: 10.0,
        ),
      ],
    ),
  ),

);
Widget tasksBuilder( {required List<OfferModel> tasks,required String id,required String orderId,}) => ConditionalBuilder(
  condition: tasks.isNotEmpty,
  builder: (context) => ListView.separated(
    itemBuilder: (context, index) => buildTaskItem(tasks[index], index,context,id,orderId),
    separatorBuilder: (context, index) => myDivider(),
    itemCount: tasks.length,
  ),
  fallback: (context) => const Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(
        Icons.menu,
        size: 150.0,
        color: Colors.grey,
      ),
      Text(
        'No Tasks Yet, please Add Some',
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    ]),
  ),
);
Widget offerBuilder( {required BuildContext context1,required List<OfferModel> tasks,required String id,required String orderId,required List<String> offerIds,}) => ConditionalBuilder(
  condition: tasks.isNotEmpty,
  builder: (context) => ListView.separated(
    itemBuilder: (context, index) => buildOfferItem(tasks[index], index,context1,id,orderId,offerIds[index],tasks.length),
    separatorBuilder: (context, index) => myDivider(),
    itemCount: tasks.length,
  ),
  fallback: (context) => const Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(
        Icons.menu,
        size: 150.0,
        color: Colors.grey,
      ),
      Text(
        'No Tasks Yet, please Add Some',
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    ]),
  ),
);

Widget myDivider() => Padding(
  padding: const EdgeInsets.all(8.0),
  child: Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.grey,
  ),
);
Widget defaultMaterialButton3({
  required Function function,
  required String text,
  required var context,
  Color color=Colors.cyan,


  double radius = 5.0,
  bool isUpperCase = true,
  Function? onTap,
}) =>
    Container(
      width: MediaQuery.of(context).size.width*0.8,
      height: MediaQuery.of(context).size.width*0.12,
      decoration: BoxDecoration(

        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: color,
        //  color: background,
      ),
      child: MaterialButton(
        onPressed: () {
          function();
        },
        child: Text(
          text,
          textAlign:TextAlign.start,


          style: const TextStyle(

            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
      ),
    );
Widget defaultReviewButton({
  required Function function,
  required String text,
  required var context,
  Color color=Colors.cyan,


  double radius = 5.0,
  bool isUpperCase = true,
  Function? onTap,
}) =>
    Container(
      width: MediaQuery.of(context).size.width*0.3,
      height: MediaQuery.of(context).size.width*0.10,
      decoration: BoxDecoration(
        gradient:  LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color,Colors.cyan]),
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: color,
        //  color: background,
      ),
      child: MaterialButton(
        onPressed: () {
          function();
        },
        child: Text(
          text,
          textAlign:TextAlign.start,


          style: const TextStyle(

            color: Colors.white,
            fontSize: 15.0,
          ),
        ),
      ),
    );
void showToast({
  required String text,
  required ToastStates state,
}) =>
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 10,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0,
    );

// enum  كذا اختيار من حاجة

enum ToastStates { success, error, warning }

Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.success:
      color = Colors.green;
      break;

    case ToastStates.error:
      color = Colors.red;
      break;

    case ToastStates.warning:
      color = Colors.amber;
      break;
  }
  return color;
}