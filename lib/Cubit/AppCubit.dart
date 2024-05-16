// ignore_for_file: non_constant_identifier_names, file_names

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enginner/Componant/constant.dart';
import 'package:enginner/Models/OfferModel.dart';
import 'package:enginner/Models/OrderModel.dart';
import 'package:enginner/Models/ProductModel.dart';
import 'package:enginner/Models/TotalOfferModel.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:enginner/Models/StoreModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../Componant/Componant.dart';
import '../Componant/cache_helper.dart';
import '../LoginScreen/LoginScreen.dart';
import '../Models/UserModel.dart';
import 'AppStates.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());
  static AppCubit get(context) => BlocProvider.of(context);
bool isBottomSheetShown=false;
List<OfferModel> engOffers=[];
void insertToOfferList({required String title,required double price,required double duration,required String description,required String state,}){
  var model=OfferModel(
      title: title,
      state: state,
      description: description,
      duration: duration,
      price: price);
engOffers.add(model);
emit(InsertedToList());
}
  IconData fabIcon = Icons.edit;
  void changeBottomSheetState({
    required bool isShow,
    required IconData icon,
  }) {
    isBottomSheetShown = isShow;
    fabIcon = icon;
    emit(AppChangeBottomSheetState());
  }

  void DeleteFromOfferList({
    required int id,
  }) {
engOffers.removeAt(id);
    emit((AppDeleteDatabaseState()));
  }
////////////////////logout////////////////////////////
double totalPrice=0.0;
  double totalDays=0.0;
  Future<void> Sum()async {
     for (var element in engOffers){
      totalPrice+=element.price;
      totalDays+=element.duration;
    }
     emit(SumationDoneState());
  }
  Future<void> AddOffer({required name,required phone,required id,required image,required workerRate,required orderId,}) async {
    emit(AddOfferLoadingState());
    var totalOfferModel=TotalOfferModel(
        name: name,
        phone: phone,
        id: id,
        image: image,
        totalDays: totalDays,
        workerRate: workerRate,
        totalPrice: totalPrice, state: '');

    await FirebaseFirestore.instance.collection('orders').doc(orderId).collection('offers').doc(id).set(totalOfferModel.toMap()).then((value) async {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).collection('offers').doc(id).update({'state':'offered'});
      for (var element in engOffers) {
       await AddStepOffer(model: element, orderId: orderId,id:id);
      }
    });
    emit(AddOfferSuccessState());
  }
  Future<void> AddStepOffer({required OfferModel model,required orderId,required id,}) async {

    await FirebaseFirestore.instance.collection('orders').doc(orderId).collection('offers').doc(id).collection('offer').add(model.toMap());

  }
 UserModel? engineerModel;
  void getEngineer(String id){
    FirebaseFirestore.instance.collection('users').doc(id).get().then((value) => engineerModel=UserModel.fromJson(value.data()!));
  }
  void signOut(BuildContext context)  {
    emit(LogoutLoadingState());

    FirebaseAuth.instance.signOut().then((value) async {
      CacheHelper.removeData(key: 'uId');
      CacheHelper.removeData(key: 'type');
      navigateAndFinish(context, LoginScreen());
      emit(LogoutSuccessState());
    });
  }
  //////////// userRegister  ////////////

  final ImagePicker picker2 = ImagePicker();
  File? PickedFile2;
  void userRegister({
    required String email,
    required String password,
    required String phone,
    required String image,
    required String firstName,
    required String lastName,
    required String userRole,
    required String address,
    required String major,
    required double rate,
    required double cash,
  }) {
    emit(CreateUserInitialState());

    FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((value) {
      createUser(
          image: '',
          email: email,
          phone: phone,
          uId: value.user!.uid,
          firstName: firstName,
          lastName: lastName,
          userRole: userRole,
          address: address,
          major: major,
        rate: rate, cash: cash,

      );
      emit(RegisterSuccessState());
    }).catchError((error) {
      emit(RegisterErrorState(error.toString()));
    });
  }
  ////////////////createUser///////////////
  void createUser({
    required String email,
    required String phone,
    required String uId,
    required String image,
    required String firstName,
    required String lastName,
    required String userRole,
    required String address,
    required String major,
    required double rate,
    required double cash,
  }) {
    UserModel model=UserModel(
        email: email,
        phone: phone,
        uId: uId,
        image: image,
        firstName: firstName,
        lastName: lastName,
        userRole: userRole,
        address: address,
        major: major,
      rate: rate,
      cash: cash,

    );

    FirebaseFirestore.instance.collection("users").doc(uId).set(model.toMap()).then((value) {

    emit(CreateUserSuccessState(uId));
    }).catchError((error) {
      emit(CreateUserErrorState(error.toString()));
    });
  }
  //////////// getUser Model ////////////

  UserModel? user;
  Future<UserModel?> getUser(String uid) async {
    uid!=''? await FirebaseFirestore.instance.collection('users').doc(uid.toString())
        .get()
        .then((value) {
      user = UserModel.fromJson(value.data()!);
      CacheHelper.saveData(key: 'type', value: user!.userRole);
      emit(GetUserSuccessState(value.id,user!.userRole));
      return user;

    }): null;
    return user;
  }
  Future<UserModel?> getUser2(String uid) async {
    uid!=''? await FirebaseFirestore.instance.collection('users').doc(uid.toString())
        .get()
        .then((value) {
      user = UserModel.fromJson(value.data()!);
      CacheHelper.saveData(key: 'type', value: user!.userRole);

      return user;

    }): null;
    return user;
  }
  void changeCash(String cash){
    emit(ChangeCashStates(cash));
  }
/////////////////////updateProfile//////////////////////////
  var ud=CacheHelper.getData(key: 'uId');
  void updateProfile({
    required String image,
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String userRole,
    required String major,
    required String address,
    required double rate,
    required double cash,
  }) {
    UserModel model = UserModel(
        image: image,
        uId: ud,
        phone: phone,
        email: email,
        firstName: firstName,
        lastName: lastName,
        rate: rate,
        cash: cash,
        userRole:userRole,
        major: major,
        address: address
    );
    emit(ImageintStates());
    FirebaseFirestore.instance.collection('users').doc(ud).update(model.toMap()).then((value) {
      emit(UpdateProfileSuccessStates());
    }).catchError((error) {
      emit(UpdateProfileErrorStates(error.toString()));
    });
  }

  void uploadProfileImage({
    required String image,
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String userRole,
    required String major,
    required String address,
    required double rate,
    required double cash,
  }) {
    emit(ImageintStates());
    firebase_storage.FirebaseStorage.instance.ref().child('users/${Uri
        .file(PickedFile2!.path)
        .pathSegments
        .last}').putFile(PickedFile2!).
    then((value) {
      value.ref.getDownloadURL().then((value) {


        createUser(
            image: value,
            email: email,
            phone: phone,
            uId:ud,
            firstName: firstName,
            lastName: lastName,
            userRole: userRole,
            address: address,
            major: major,
            rate: rate,
            cash: cash
        );
        PickedFile2 = null;

        emit(ImageSuccessStates())
        ;
      }).catchError((error) {
        emit(ImageErrorStates(error));
      });
    }).catchError((error) {
      emit(ImageErrorStates(error));
    });
  }
  //////////// userLogin  ////////////

  Future<void> userLogin({required String email, required String password}) async {
    emit(LoginLoadingState());
    await  FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password) .then((value) {
      CacheHelper.saveData(key: 'uId', value: value.user!.uid);
      emit(LoginSuccessState(value.user!.uid,'patient'));
    }).catchError((error) {
      showToast(text: error.toString(), state: ToastStates.error);
      emit(LoginErrorState(error.toString()));
    });
  }

////////////  ChangePassword ////////////
  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;


  void changePassword() {
    isPassword = !isPassword;
    suffix =
    isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;

    emit(ChangePasswordState());
  }
  ////////select  image ///////////////

  Future<void> getImage2() async {
    final imageFile = await picker2.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      PickedFile2 = File(imageFile.path);
      emit(UpdateStoreImageSuccessStates());
    }
    else {
      var error = 'no Image selected';
      emit(UpdateStoreImageErrorStates(error.toString()));
    }
  }
  //////////create store///////////
  void createStore({

    required String phone,
    required String id,
    required String image,
    required String storeName,
    required String address,

  }) {
    emit(CreateStoreLoadingState());
    if (PickedFile2 == null) {
      StoreModel model = StoreModel(
        phone: phone,
        image: image,
        address: address,
        rate: 0.0,
        id: id,
        storeName: storeName,

      );
      FirebaseFirestore.instance.collection("stores").doc(id)
          .set(model.toMap())
          .then((value) {
        emit(CreateStoreSuccessState());
      }).catchError((error) {
        emit(CreateStoreErrorState(error.toString()));
      });
    } else {
      firebase_storage.FirebaseStorage.instance.ref().child('stores/${Uri
          .file(PickedFile2!.path)
          .pathSegments
          .last}').putFile(PickedFile2!).
      then((value) {
        PickedFile2=null;
        value.ref.getDownloadURL().then((value) {
          StoreModel model = StoreModel(
            phone: phone,
            image: value,
            address: address,
            rate: 0.0,
            id: id,
            storeName: storeName,

          );
          FirebaseFirestore.instance.collection("stores").doc(id)
              .set(model.toMap())
              .then((value) {
            emit(CreateStoreSuccessState());
          }).catchError((error) {
            emit(CreateStoreErrorState(error.toString()));
          });
        });
      });
    }
  }
  ////////////create product/////////
//////////create store///////////
  void createProduct({
    required String id,
    required String image,
    required String name,
    required String description,
    required double price,

  }) {
    emit(CreateProductLoadingState());
    if (PickedFile2 == null) {
      ProductModel model = ProductModel(

        image: image,
         rate: 0.0,
        id: id,
        name:name ,
        available: true,
        price: price,
        description: description,
        tenantId: '',
        myTenantId: '',

      );
      FirebaseFirestore.instance.collection("stores").doc(id).collection('products')
          .add(model.toMap())
          .then((value) {
        emit(CreateProductSuccessState());
      }).catchError((error) {
        emit(CreateProductErrorState(error.toString()));
      });
    } else {
      firebase_storage.FirebaseStorage.instance.ref().child('products/${Uri
          .file(PickedFile2!.path)
          .pathSegments
          .last}').putFile(PickedFile2!).
      then((value) {
        PickedFile2=null;
        value.ref.getDownloadURL().then((value) {
          ProductModel model = ProductModel(

            image: value,
            rate: 0.0,
            id: id,
            name:name ,
            available: true,
            price: price,
            description: description, tenantId: '', myTenantId: '',
          );
          FirebaseFirestore.instance.collection("stores").doc(id).collection('products')
              .add(model.toMap())
              .then((value) {
            emit(CreateProductSuccessState());
          }).catchError((error) {
            emit(CreateProductErrorState(error.toString()));
          });
        });
      });
    }
  }
  ///////////////////add order////////////////



  int randomNumber = random.nextInt(1000);
  void addOrder({
    required String type,

    required String state,
    required String description,
    required String address,

  }) {
    emit(AddOrderInitialState());
    if(PickedFile2==null) {
      OrderModel? model =
    user!=null?
    OrderModel(
        type: type,
        orderId:user!.uId+randomNumber.toString(),
        publisherId: user!.uId,
        publisherPhone: user!.phone,
        publisherName: '${user!.firstName} ${user!.lastName}',
        publisherImage: user!.image,
        orderImage: '',
        state: state,
        description: description, address: address):null;
      model!=null? FirebaseFirestore.instance.collection('orders').doc(user!.uId+randomNumber.toString()).set(model.toMap()).then((value) {
        emit(AddOrderSuccessState());
      }).catchError((error){

        emit(AddOrderErrorState(error.toString()));
      }):null;
    }else{
      firebase_storage.FirebaseStorage.instance.ref().child('products/${Uri
          .file(PickedFile2!.path)
          .pathSegments
          .last}').putFile(PickedFile2!).
      then((value) {
        PickedFile2=null;
        value.ref.getDownloadURL().then((value) {
          OrderModel? model =
          user!=null?
          OrderModel(
              type: type,
              orderId:user!.uId+randomNumber.toString(),
              publisherId: user!.uId,
              publisherPhone: user!.phone,
              publisherName: '${user!.firstName} ${user!.lastName}',
              publisherImage: user!.image,
              orderImage: value,
              state: state,
              description: description, address: address):null;
          model!=null? FirebaseFirestore.instance.collection('orders').doc(user!.uId+randomNumber.toString()).set(model.toMap()).then((value) {
            emit(AddOrderSuccessState());
          }).catchError((error){

            emit(AddOrderErrorState(error.toString()));
          }):null;
        });
    });

    }



}
}