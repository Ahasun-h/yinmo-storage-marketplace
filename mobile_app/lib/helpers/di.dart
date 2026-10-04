//import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:urban_koala/providers/generic_provider.dart';

final locator = GetIt.instance;

///Templated Code copied from YogaVillage Project
final appData = locator.get<GetStorage>();

void diSetup() {
  // locator.registerLazySingleton(() => FirebaseMessaging.instance);
  locator.registerSingleton<GetStorage>(GetStorage());
  // locator.registerSingleton<WebViewController>(WebViewController());
  // locator.registerSingleton<DistanceProvider>(DistanceProvider());
  locator.registerSingleton<GenericDi>(GenericDi());
  // locator.registerSingleton<PlcaeMarkAddress>(PlcaeMarkAddress());
  //locator.registerSingleton<DefaultAddress>(DefaultAddress());

  ///Changes made by Imtiaz
}
