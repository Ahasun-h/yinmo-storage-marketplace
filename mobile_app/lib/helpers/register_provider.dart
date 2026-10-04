import 'package:urban_koala/providers/all_providers.dart';
import 'package:urban_koala/providers/auth_providers.dart';
import 'package:provider/provider.dart';

var providers = [
  ChangeNotifierProvider<AuthProviders>(create: ((context) => AuthProviders())),
  ChangeNotifierProvider<AllProviders>(create: ((context) => AllProviders())),
];
