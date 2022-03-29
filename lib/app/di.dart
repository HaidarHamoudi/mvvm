import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mvvm/app/app_prefs.dart';
import 'package:mvvm/data/data_source/local_data_source.dart';
import 'package:mvvm/data/data_source/remote_data_source.dart';
import 'package:mvvm/data/network/dio_factory.dart';
import 'package:mvvm/data/network/network_info.dart';
import 'package:mvvm/domain/repository/repository.dart';
import 'package:mvvm/domain/usecase/home_usecase.dart';
import 'package:mvvm/domain/usecase/login_usecase.dart';
import 'package:mvvm/presentation/login/login_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/network/app_api.dart';
import '../data/repository/repository_impl.dart';
import '../domain/usecase/forget_password_usecase.dart';
import '../domain/usecase/register_usecase.dart';
import '../domain/usecase/store_details_usecase.dart';
import '../presentation/forget_password/forget_password_viewmodel.dart';
import '../presentation/main/home/home_viewmodel.dart';
import '../presentation/register/register_viewmodel.dart';
import '../presentation/store_details/store_details_viewmodel.dart';

final instance = GetIt.instance;

Future<void> initAppModule() async {
  final sharedPrefs = await SharedPreferences.getInstance();
  /*
  Singleton means that I have only one instance of
  this class through all the application.
  Lazy means that this initialization for this instance will not be called
  and won't be added until we need it or call it.
  */

  // SharedPreferences instance
  instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  // AppPreferences instance
  instance
      .registerLazySingleton<AppPreferences>(() => AppPreferences(instance()));

  // NetworkInfo
  /*
  Because this is an abstract class I need to add an instance for
  initialization.(Abstract class can't be initialize).
  And for NetworkInfoImplementer I need InternetConnectionChecker, and for
  InternetConnectionChecker you can initialize it directly because it doesn't need
  any dependence.
  */
  instance.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImplementer(InternetConnectionChecker()));

  // DioFactory
  /*
  And this DioFactory class needs inside its class constructor AppPreferences,
  but we also have already instance of it. So we can initialize it directly.
  (The instance automatically will be assigned from instance of GetIt by AppPreferences
  which already registered inside our dependency injection)
  */
  instance.registerLazySingleton<DioFactory>(() => DioFactory(instance()));

  // AppServiceClient
  final dio = await instance<DioFactory>().getDio();
  instance.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));

  // RemoteDataSource
  instance.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImplementer(instance()));

  // LocalDataSource
  instance.registerLazySingleton<LocalDataSource>(
      () => LocalDataSourceImplementer());

  // Repository
  instance.registerLazySingleton<Repository>(
      () => RepositoryImplementer(instance(), instance(), instance()));

  /*
  We can call initLoginModule() here, but this isn't the best practice,
  because it should be called the moment I open the LoginScreen(In Routes manager),
   no need to make it generic inside the AppModule.
  AppModule is containing all the instances that will be shared through the app.
  */
}

/*
RegisterFactory means that every time I will call this instance, I will get
a new instance from factory.
*/
initLoginModule() {
  /*
  I have here to check at least one of this instances is registered before.
  So I will ignore adding them again inside GetIt.
  */
  if (!GetIt.I.isRegistered<LoginUseCase>()) {
    instance.registerFactory<LoginUseCase>(() => LoginUseCase(instance()));
    instance.registerFactory<LoginViewModel>(() => LoginViewModel(instance()));
  }
}

initForgetPasswordModule() {
  /*
  I have here to check at least one of this instances is registered before.
  So I will ignore adding them again inside GetIt.
  */
  if (!GetIt.I.isRegistered<ForgetPasswordUseCase>()) {
    instance.registerFactory<ForgetPasswordUseCase>(
        () => ForgetPasswordUseCase(instance()));
    instance.registerFactory<ForgetPasswordViewModel>(
        () => ForgetPasswordViewModel(instance()));
  }
}

initRegisterModule() {
  /*
  I have here to check at least one of this instances is registered before.
  So I will ignore adding them again inside GetIt.
  */
  if (!GetIt.I.isRegistered<RegisterUseCase>()) {
    instance
        .registerFactory<RegisterUseCase>(() => RegisterUseCase(instance()));
    instance.registerFactory<RegisterViewModel>(
        () => RegisterViewModel(instance()));
    instance.registerFactory<ImagePicker>(() => ImagePicker());
  }
}

initHomeModule() {
  /*
  I have here to check at least one of this instances is registered before.
  So I will ignore adding them again inside GetIt.
  */
  if (!GetIt.I.isRegistered<HomeUseCase>()) {
    instance.registerFactory<HomeUseCase>(() => HomeUseCase(instance()));
    instance.registerFactory<HomeViewModel>(() => HomeViewModel(instance()));
  }
}

initStoreDetailsModule() {
  if (!GetIt.I.isRegistered<StoreDetailsUseCase>()) {
    instance.registerFactory<StoreDetailsUseCase>(
        () => StoreDetailsUseCase(instance()));
    instance.registerFactory<StoreDetailsViewModel>(
        () => StoreDetailsViewModel(instance()));
  }
}

resetAllModules(){
  instance.reset(dispose: false);
  initAppModule();
  initHomeModule();
  initLoginModule();
  initRegisterModule();
  initForgetPasswordModule();
  initStoreDetailsModule();
}