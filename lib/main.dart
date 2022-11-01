import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iKCHECK/Utils/globalFunctions.dart';
import 'package:iKCHECK/Utils/globalVariables.dart';
import 'package:iKCHECK/Utils/localStorage.dart';
import 'package:iKCHECK/generated/codegen_loader.g.dart';
import 'package:iKCHECK/providers/mainProvider.dart';
import 'package:iKCHECK/services/notificationManagement.dart';
import 'package:iKCHECK/test.dart';
import 'package:iKCHECK/views/Auth/ForgotPasswordScreen.dart';
import 'package:iKCHECK/views/Auth/LoaderScreen.dart';
import 'package:iKCHECK/views/Auth/SecondForgotPasswordScreen.dart';
import 'package:iKCHECK/views/Auth/SignInScreen.dart';
import 'package:iKCHECK/views/Auth/newVersionScreen.dart';
import 'package:iKCHECK/views/Auth/signupScreen.dart';
import 'package:iKCHECK/widgets/lifeCycleManagement.dart';
import 'package:iKCHECK/widgets/navbar.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'Utils/styles.dart';
import 'views/Auth/ActivationScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  try {
    if (Platform.isAndroid || Platform.isIOS) {
      await Firebase.initializeApp();
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      FirebaseMessaging.onBackgroundMessage(
          onBackgroundMessageFromNotification);
    }
  } catch (e) {
    print('Because its web $e');
  }

  String currentLang = await getString('LANG') ?? '';
  if (currentLang == '') {
    currentLang = 'nl';
  }

  await removeString('PATH_FOR_IPAD');
  await removeString('EMAIL_FOR_IPAD');

  runApp(
    EasyLocalization(
      path: 'assets/i18n',
      supportedLocales: const [
        Locale('nl'),
        Locale('en'),
      ],
      startLocale: Locale(currentLang),
      fallbackLocale: const Locale('en'),
      assetLoader: const CodegenLoader(),
      child: const MyApp(),
    ),
  );

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.background,
      statusBarIconBrightness: Brightness.dark));
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

String? finaltoken = "";

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        final firebaseMessaging = FCM();
        globelContext = context;
        firebaseMessaging.setNotifications();

        // FirebaseDynamicLinks.instance.onLink.listen(
        //   ((dynamicLink) async {
        //     var deepLink = dynamicLink.link;

        //     Map data1 =
        //         json.decode(Uri.decodeFull(deepLink.query.split('=')[1]));
        //     // List<String> filter = data1.split('type');
        //     // List<String> filter1 = filter[1].split(',');
        //     // Map data = {
        //     //   'type': data1['type'],
        //     // };
        //     // Map data = {
        //     //   'type': filter1[0],
        //     // };

        //     // if (data['type'].contains('REGISTRATIONREQUEST')) {
        //     //   data['type'] = "REGISTRATIONREQUEST";
        //     //   String data1 = Uri.decodeFull(deepLink.query);
        //     //   List<String> filter = data1.split('regId');
        //     //   List<String> filter1 = filter[1].split(',');
        //     //   data['regId'] = filter1[0];
        //     // }

        //     routingFunctionForNotificationAndDeeplink(data1, context);
        //   }),
        // );

      }
    } catch (e) {
      print('Because its web $e');
    }

    // initDynamicLinks(context);
  }

  // initDynamicLinks(BuildContext context) async {
  //   var data = await FirebaseDynamicLinks.instance.getInitialLink();
  //   var deepLink = data?.link;
  //   if (deepLink != null) {
  //     final queryParams = deepLink.queryParameters;
  //     if (queryParams.isNotEmpty) {
  //       var userName = queryParams['userId'];
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext ctx) {
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      minTextAdapt: true,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) {
              return MainProvider();
            },
          ),
        ],
        child: LifeCycleManager(
          GetMaterialApp(
            locale: ctx.locale,
            supportedLocales: ctx.supportedLocales,
            localizationsDelegates: ctx.localizationDelegates,
            debugShowCheckedModeBanner: false,
            builder: (context, widget) {
              return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaleFactor: 1.0,
                  ),
                  child: widget!);
            },
            theme: ThemeData(
                    brightness: Brightness.light,
                    fontFamily: 'Poppins',
                    androidOverscrollIndicator:
                        AndroidOverscrollIndicator.stretch)
                .copyWith(
              backgroundColor: AppColors.background,
            ),

            routes: {
              '/': (ctx) => FutureBuilder<String>(
                future: checkAppVersion(ctx),
                builder: (
                    BuildContext context,
                    AsyncSnapshot<String> snapshot,
                    ) {
                  return Stack(
                    children: <Widget>[
                      if (snapshot.data == 'version_update')
                        NewVersionScreen()
                      else if (snapshot.data == 'true')
                        // Container()

                        NavbarScreen(apiCallString: 'getDashboardDetails')
                      else if (snapshot.data == 'false')
                          SignInScreen()
                        else if (snapshot.data == 'SIGNUP')
                            SignUpScreen()
                          else if (snapshot.data == 'SIGNUP_ACTIVATE')
                              ActivationScreen(mail: emailForCache)
                            else if (snapshot.data == 'FORGETPASSWORD_1')
                                ForgotPasswordScreen()
                              else if (snapshot.data == 'FORGETPASSWORD_2')
                                  SecondForgotPasswordScreen(
                                    email: emailForCache,
                                  )
                                else
                                  LoaderScreen()
                    ],
                  );
                },
              ),

              'loginRoute': (ctx) => SignInScreen(),
              'registrationDeepLinkRoute': (ctx) => SignUpScreen(
                email: deepLinkDecodedData['email'],
                name: deepLinkDecodedData['name'],
              ),
              // '/': (ctx) => Test(),
              // '/': (ctx) => NavbarScreen(apiCallString: 'getDashboardDetails'),
              'home': (ctx) =>
                  NavbarScreen(apiCallString: 'getDashboardDetails'),
              'deleteAccountRoute': (ctx) => SignUpScreen(deleteAccount: true),
              'rdwLinkedBack': (ctx) => NavbarScreen(),
              'deleteRouteBackToAlert': (ctx) => NavbarScreen(
                selectedPageIndex: 3,
                apiCallString: 'deletedRouteAlert',
              ),
              // 'notifyAlertRoute': (ctx) => NavbarScreen(
              //       selectedPageIndex: 3,
              //       apiCallString: 'getEnquiryDetails',
              //       apiData: {
              //         'alertId': 0,
              //         'content': null,
              //         'fromDate': null,
              //         'page': 1,
              //         'read': null,
              //         'sort': "Date time",
              //         'source': null,
              //         'status': "To Be Attended",
              //         'toDate': null,
              //         'type': null,
              //         'userId': userIdForMsgAndAlert,
              //       },
              //     ),
            },

            // home: SignInScreen(),
            // home: NavbarScreen(),
          ),
          'main',
        ),
      ),
    );
  }
}
