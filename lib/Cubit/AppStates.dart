
// ignore_for_file: file_names

abstract class AppStates {}

class AppInitialState extends AppStates {}
class CreateUserInitialState extends AppStates {}
class ImageintStates extends AppStates {}
class UpdateProfileSuccessStates extends AppStates {}
class UpdateProfileErrorStates extends AppStates {
  final String error;
  UpdateProfileErrorStates(this.error);
}
class ChangeCashStates extends AppStates {
  final String cash;
  ChangeCashStates(this.cash);
}
class RegisterSuccessState extends AppStates {}
class InsertedToList extends AppStates {}
class AppChangeBottomSheetState extends AppStates {}
class AppDeleteDatabaseState extends AppStates {}
class SumationDoneState extends AppStates {}
class AddOfferLoadingState extends AppStates {}
class AddOfferSuccessState extends AppStates {}
class AddOrderSuccessState extends AppStates {}
class AddOrderInitialState extends AppStates {}
class AddOrderErrorState extends AppStates {
  final String error;
  AddOrderErrorState(this.error);
}
class ImageSuccessStates extends AppStates {}
class RegisterErrorState extends AppStates {
  final String error;
  RegisterErrorState(this.error);
}
class ImageErrorStates extends AppStates {
  final String error;
  ImageErrorStates(this.error);
}
class CreateUserSuccessState extends AppStates {
  final String uId;
  CreateUserSuccessState(this.uId);
}

class CreateUserErrorState extends AppStates {
  final String error;
  CreateUserErrorState(this.error);
}
class CreateStoreErrorState extends AppStates {
  final String error;
  CreateStoreErrorState(this.error);
}
class CreateStoreLoadingState extends AppStates {}
class CreateStoreSuccessState extends AppStates {}
class CreateProductErrorState extends AppStates {
  final String error;
  CreateProductErrorState(this.error);
}
class CreateProductLoadingState extends AppStates {}
class CreateProductSuccessState extends AppStates {}
class UpdatePatientLoadingState extends AppStates {}
class UpdatePatientSuccessState extends AppStates {}
class LoginLoadingState extends AppStates {}
class LogoutLoadingState extends AppStates {}
class LogoutSuccessState extends AppStates {}
class LoginSuccessState extends AppStates {
  final String uId;
  final String type;
  LoginSuccessState(this.uId,this.type);

}
class GetUserSuccessState extends AppStates {
  final String uId;
  final String type;
  GetUserSuccessState(this.uId,this.type);

}
class ChangePasswordState extends AppStates {}
class LoginErrorState extends AppStates {
  final String error;

  LoginErrorState(this.error);
}class UpdateStoreImageSuccessStates extends AppStates {}
class UpdateStoreImageErrorStates extends AppStates {
  final String error;

  UpdateStoreImageErrorStates(this.error);
}