import 'dart:async';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:iKCHECK/providers/mainProvider.dart';
import 'package:iKCHECK/views/Auth/SignInScreen.dart';
import 'package:iKCHECK/views/Auth/signupScreen.dart';
import 'package:iKCHECK/widgets/navbar.dart';
import 'package:provider/provider.dart';

navvigatorfunction(context){
  Timer.run(() {
    Provider.of<MainProvider>(context,listen:false).setselectedIndex(0);
  });
  Get.offAll(NavbarScreen(apiCallString: 'getDashboardDetails'));
}

languageFunction(){
  Get.updateLocale(Locale('nl'));
}

languageFunctionen(){
  Get.updateLocale(Locale('en'));
}


loginNavigation(){
  Get.offAll(SignInScreen());
}


deleteAccountNav(){
  Get.offAll(SignUpScreen(deleteAccount: true));
}