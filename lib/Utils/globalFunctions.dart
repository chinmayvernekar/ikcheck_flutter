import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:iKCHECK/Utils/globalVariables.dart';
import 'package:iKCHECK/Utils/localStorage.dart';
import 'package:iKCHECK/generated/locale_keys.g.dart';
import 'package:iKCHECK/providers/mainProvider.dart';
import 'package:iKCHECK/services/apiCallManagement.dart';
import 'package:iKCHECK/services/notificationManagement.dart';
import 'package:iKCHECK/views/Auth/NavigatorSignIn.dart';
import 'package:iKCHECK/views/Auth/SignInScreen.dart';
import 'package:iKCHECK/views/Auth/signupScreen.dart';
import 'package:iKCHECK/views/home/dashboardScreen.dart';
import 'package:iKCHECK/widgets/navbar.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

Future<String> createDeepLink(String uuid, deepLinkObj, String rdwUrl) async {
  String returnLink = await ApiCallManagement()
      .createDynamicLink(uuid, deepLinkObj)
      .then((response) async {
    if (response.isNotEmpty) {
      var responseUrl;
      responseUrl = response;
      String href;
      href = rdwUrl + uuid + '&returnUrl=' + responseUrl['shortLink'] + WHR_URL;
      return href;
    } else {
      return null;
    }
  });
  return returnLink;
}

String getFormatedDateTime(String item) {
  // print(DateTime.parse('${item}z').toLocal().timeZoneOffset);
  String date = DateFormat('dd MMM yyyy, HH:mm')
      .format((DateTime.parse('${item}z').toLocal()));
  return date;
}

String getFormatedDateOnlyTrimmed(String item) {
  // print(DateTime.parse('${item}z').toLocal().timeZoneOffset);
  String date = DateFormat('dd MMM yyyy, HH:mm')
      .format((DateTime.parse('${item}z').toLocal()));
  return date.substring(0,(date.length - 7));
}

String getFormatedNumberDateOnlyTrimmed(String item) {
  // print(DateTime.parse('${item}z').toLocal().timeZoneOffset);
  String date = DateFormat('dd-MM-yyyy, HH:mm')
      .format((DateTime.parse('${item}').toLocal()));
  return date.substring(0,(date.length - 7));
}

String getFormatedDateOnly(String item, String filter, bool isUTC) {
  String date = '';

  try {
    if (filter == 'onlyNumber') {

      date = DateFormat('dd-MM-yyyy')
          .format(DateTime.parse('$item${!isUTC ? 'z' : ''}').toLocal());
      print("wrong date $date");
    } else if (filter == 'dmy') {

      date = DateFormat('dd MMMM yyyy')
          .format(DateTime.parse('$item${!isUTC ? 'z' : ''}').toLocal());
      print("wrong date $date");
    } else {
      print("wrong date $date");
      date = DateFormat('yyyy MMM dd')
          .format(DateTime.parse('$item${!isUTC ? 'z' : ''}').toLocal());
      print("wrong date $date");
    }
  } catch (e) {
   // date = DateFormat('dd-MM-yyyy').format(DateTime.parse(item).toLocal());
    print("wrong date $date");
  }

  return date;
}

String getFormatedTimeOnly(String item, bool isUTC) {
  String date = '';
  try {
    date = DateFormat('HH:mm')
        .format(DateTime.parse('$item${isUTC ? 'z' : ''}').toLocal());
  } catch (e) {
    date = DateFormat('HH:mm').format(DateTime.parse(item).toLocal());
  }
  return date;
}

bool showingBadgeBasedonDashboardApi(Map details, BuildContext context) {
  try {
    return (details['unreadAlert'] != null) && details.isNotEmpty && details['unreadAlert'] > 0;
  } catch (e) {
    return false;
  }
    

}

bool checkingForUnreadMessage(Map details, BuildContext context) {
  try {
    return (details['unReadNewsCount'] != null) && (details.isNotEmpty && details['unReadNewsCount'] > 0);
  } catch (e) {
    return false;
  }
  
}

String getDateOrTime(String date) {
  String returnString = '';
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final dateToCheck = DateTime.parse(date);
  final aDate = DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);
  if (aDate == today) {
    returnString = getFormatedTimeOnly(date, true);
  } else {
    // returnString = getFormatedDateOnly(date, 'onlyNumber', true);
    returnString = getFormatedNumberDateOnlyTrimmed(date
    //  , 'onlyNumber', true
    );
  }
  return returnString;
}

routingFunctionForNotificationAndDeeplink(
    Map data, BuildContext context) async {
  await storeString('cacheDataNotificationAndDeeplink', json.encode(data));

  // Provider.of<MainProvider>(globelContext!, listen: false)
  //     .setLoaderStatus(true);
  String loginStatus = await getString('access_token') ?? '';
  if (data['type'] == 'CONSENTRETURN') {
    await ApiCallManagement().getDashboardDetails(context);
    pushNewScreen(
      context,
      screen: DashBoardScreen(),
      withNavBar: true, // OPTIONAL VALUE. True by default.
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
    await ApiCallManagement().getDashboardDetails(context);
  } else if (data['type'] == 'REGISTRATIONREQUEST') {
    String currentLang = await getString('LANG') ?? '';
    await clearStorage();
    await storeString('LANG', currentLang);

    if (data['regId'] != null && data['regId'].isNotEmpty) {
      deepLinkDecodedData =
          await ApiCallManagement().getDeepLinkDetails(data['regId']);

      // var route = PageRouteBuilder(
      //   pageBuilder: (context, animation1, animation2) => SignUpScreen(
      //     email: deepLinkDecodedData['email'],
      //     name: deepLinkDecodedData['name'],
      //   ),
      //   transitionDuration: Duration.zero,
      //   reverseTransitionDuration: Duration.zero,
      // );
      Navigator.of(context).pushNamed(
        'registrationDeepLinkRoute',
      );
    } else {
      // Navigator.of(context).pushNamedAndRemoveUntil(
      //     'loginRoute', (Route<dynamic> route) => false);
      await ApiCallManagement().getDashboardDetails(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return NavbarScreen(apiCallString: 'getDashboardDetails');
          },
        ),
      );
      await ApiCallManagement().getDashboardDetails(context);
    }
  } else if (data['type'] == 'ALERT') {
    userIdForMsgAndAlert = await getString('US_user_id') ?? '';
    // var navigator = Navigator.of(context);
    // var route = PageRouteBuilder(
    //   pageBuilder: (context, animation1, animation2) =>
    //       NavbarScreen(apiCallString: 'notifyAlertRoute'),
    //   transitionDuration: Duration.zero,
    //   reverseTransitionDuration: Duration.zero,
    // );

    // navigator.pushAndRemoveUntil(route, (route) => false);
    Map object = {
      'alertId': 0,
      'content': null,
      'fromDate': null,
      'page': 1,
      'read': null,
      'sort': "Date time",
      'source': null,
      'status': "To Be Attended",
      'toDate': null,
      'type': null,
      'userId': userIdForMsgAndAlert,
    };

    if (navBarIndex != 3) {
      Provider.of<MainProvider>(context, listen: false)
          .setLoaderAlertStatus(true);
      await ApiCallManagement()
          .getIdentityEnquiryDetails(context, object, '');
      Provider.of<MainProvider>(context, listen: false)
          .setLoaderAlertStatus(false);
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => NavbarScreen(
            selectedPageIndex: 3,
            apiCallString: 'getEnquiryDetails',
            apiData: object,
          ),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    } else {
      await ApiCallManagement().getIdentityEnquiryDetails(context, object, '');
    }
  } else if (data['type'] == 'MESSAGE') {
    await ApiCallManagement().getMessagesUserNewsApi(context, 1);
    if (navBarIndex != 1) {
      Provider.of<MainProvider>(context, listen: false)
          .setLoaderAlertStatus(true);
      await ApiCallManagement()
          .getIdentityEnquiryDetails(context, {}, '');
      Provider.of<MainProvider>(context, listen: false)
          .setLoaderAlertStatus(false);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return NavbarScreen(
              selectedPageIndex: 1,
              apiCallString: 'getEnquiryDetails',
            );
          },
        ),
      );
    } else {
      await ApiCallManagement().getMessagesUserNewsApi(context, 1);
    }
  } else {
    await ApiCallManagement().getDashboardDetails(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return NavbarScreen(apiCallString: 'getDashboardDetails');
        },
      ),
    );
    await ApiCallManagement().getDashboardDetails(context);
  }
  // Provider.of<MainProvider>(globelContext!, listen: false)
  //     .setLoaderStatus(false);
}
Future<String> checkAppVersion(BuildContext context) async {
  callDynamicLinkFunction(context);
  List apiResponse = await ApiCallManagement().getAppVersionForDB();
  String androidDBVersion = '';
  String iosDBVersion = '';
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String currentVersion = packageInfo.version;
  apiResponse.forEach((element) {
    if (element['key'] == 'ANDROID') {
      androidDBVersion = element['value'];
    } else {
      iosDBVersion = element['value'];
    }
  });

  try {
    if (Platform.isAndroid) {
      int androidDBV = getExtendedVersionNumber(androidDBVersion);
      int localV = getExtendedVersionNumber(currentVersion);
      if (androidDBV > localV) {
        return "version_update";
      }
    }

    if (Platform.isIOS) {
      int iosDBV = getExtendedVersionNumber(iosDBVersion);
      int localV = getExtendedVersionNumber(currentVersion);
      if (iosDBV > localV) {
        return "version_update";
      }
    }
  } catch (e) {
    print('Because it is web $e');
  }

  String accessToken = await getString('access_token') ?? '';
  if (accessToken.isNotEmpty) {
    String userId = await getString('US_user_id') ?? '';
    http.Response response = await http.get(
      Uri.parse('$BASE_URL/user-service/userDetails/$userId'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    // response = await checkApiResponse(response, context);

    if (response.statusCode == 200) {
      return 'true';
    } else if (response.statusCode == 401) {
      return 'false';
    } else if (await getString('PATH_FOR_IPAD') == 'SIGNUP' &&
        MediaQuery.of(context).size.width >= 768) {
      return 'SIGNUP';
    } else if (await getString('PATH_FOR_IPAD') == 'SIGNUP_ACTIVATE' &&
        await getString('EMAIL_FOR_IPAD') != null &&
        MediaQuery.of(context).size.width >= 768) {
      emailForCache = await getString('EMAIL_FOR_IPAD') ?? '';
      return 'SIGNUP_ACTIVATE';
    } else if (await getString('PATH_FOR_IPAD') == 'SIGNIN' &&
        MediaQuery.of(context).size.width >= 768) {
      return 'false';
    } else if (await getString('PATH_FOR_IPAD') == 'FORGETPASSWORD_1' &&
        MediaQuery.of(context).size.width >= 768) {
      return 'FORGETPASSWORD_1';
    } else if (await getString('PATH_FOR_IPAD') == 'FORGETPASSWORD_2' &&
        await getString('EMAIL_FOR_IPAD') != null &&
        MediaQuery.of(context).size.width >= 768) {
      emailForCache = await getString('EMAIL_FOR_IPAD') ?? '';
      return 'FORGETPASSWORD_2';
    } else {
      return 'false';
    }
  } else {
    if (await getString('PATH_FOR_IPAD') == 'SIGNUP' &&
        MediaQuery.of(context).size.width >= 768) {
      return 'SIGNUP';
    } else if (await getString('PATH_FOR_IPAD') == 'SIGNUP_ACTIVATE' &&
        await getString('EMAIL_FOR_IPAD') != null &&
        MediaQuery.of(context).size.width >= 768) {
      emailForCache = await getString('EMAIL_FOR_IPAD') ?? '';
      return 'SIGNUP_ACTIVATE';
    } else if (await getString('PATH_FOR_IPAD') == 'SIGNIN' &&
        MediaQuery.of(context).size.width >= 768) {
      return 'false';
    } else if (await getString('PATH_FOR_IPAD') == 'FORGETPASSWORD_1' &&
        MediaQuery.of(context).size.width >= 768) {
      return 'FORGETPASSWORD_1';
    } else if (await getString('PATH_FOR_IPAD') == 'FORGETPASSWORD_2' &&
        await getString('EMAIL_FOR_IPAD') != null &&
        MediaQuery.of(context).size.width >= 768) {
      emailForCache = await getString('EMAIL_FOR_IPAD') ?? '';
      return 'FORGETPASSWORD_2';
    } else {
      return 'false';
    }
  }
}
void callDynamicLinkFunction(BuildContext context) {
  try {
    if (Platform.isAndroid || Platform.isIOS) {
      FirebaseDynamicLinks.instance.onLink.listen(
        ((dynamicLink) async {
          var deepLink = dynamicLink.link;

          Map data1 = json.decode(Uri.decodeFull(deepLink.query.split('=')[1]));

          routingFunctionForNotificationAndDeeplink(data1, context);
        }),
      );
    }
  } catch (e) {
    print('Because its web $e');
  }
}

int getExtendedVersionNumber(String version) {
  List versionCells = version.split('.');
  versionCells = versionCells.map((i) => int.parse(i)).toList();
  return versionCells[0] * 10000 + versionCells[1] * 100 + versionCells[2];
}

Future checkApiResponse(var response, BuildContext context) async {
  if (response != null &&
      (response.statusCode == 200 || response.statusCode == 201)) {
    return response;
  } else if (response == null || response.statusCode == 401) {
    String currentLang = await getString('LANG') ?? '';
    await clearStorage();
    await storeString('LANG', currentLang);
    try {
      loginNavigation();

      // Navigator.of(context).pushNamedAndRemoveUntil(
      //     'loginRoute', (Route<dynamic> route) => false);
    } catch (e) {
      print('err $e');
      // Navigator.push(context, MaterialPageRoute(
      //   builder: (context) {
      //     return SignInScreen();
      //   },
      // ));
    }

    return response;
  } else {
    return response;
  }
}

getValidLicenseNo(data) {
  if (data == '' || data == 'null' || data == null ) {
    return false;
  } else {
    return true;
  }
}

String replaceSpecials(String tr) {
  tr = tr.replaceAll("USD", '\$');
  return tr.replaceAll("BACKSLASH", r'\');
}

String alertTranslate(String str) {
  if (str == 'Rijbewijs koppelen') {
    return LocaleKeys.ALERTS_RIJBEWIJSKOPPELEN.tr();
  } else if (str == 'Rijbewijs gekoppeld') {
    return LocaleKeys.ALERTS_RIJBEWIJSGEKOPPELD.tr();
  } else if (str == 'Rijbewijs koppelen mislukt') {
    return LocaleKeys.ALERTS_RIJBEWIJSKOPPELENMISLUKT.tr();
  } else if (str == 'Rijbewijs gecontroleerd') {
    return LocaleKeys.ALERTS_RIJBEWIJSGECONTROLEERD.tr();
  } else if (str == "Rijbewijs ontkoppeld") {
    return LocaleKeys.ALERTS_RIJBEWIJSONTKOPPELD.tr();
  } else if (str == "Datalek Gevonden") {
    return LocaleKeys.DATALEKGEVONDEN.tr();
  } else if (str == "Datalek gevonden") {
    return LocaleKeys.DATALEKGEVONDEN.tr();
  }else if (str == "Geen Datalek Gevonden") {
    return LocaleKeys.GEENDATALEKGEVONDEN.tr();
  }
  else {
    return "$str";
  }
}


String dateTranslate(String string) {

  List temp = string.split(" ");
  print('HHHH $temp');
  if(temp.length==3){
    String str = temp[1].toString().toLowerCase();
    if (str == 'january') {
      return temp[0]+" "+LocaleKeys.MONITORING_JANUARY.tr()+" "+temp[2];
    } else if (str == 'february') {
      return temp[0]+" "+LocaleKeys.MONITORING_FEBRUARY.tr()+" "+temp[2];
    } else if (str == 'march') {
      return temp[0]+" "+LocaleKeys.MONITORING_MARCH.tr()+" "+temp[2];
    } else if (str == 'april') {
      return temp[0]+" "+LocaleKeys.MONITORING_APRIL.tr()+" "+temp[2];
    } else if (str == "may") {
      return temp[0]+" "+LocaleKeys.MONITORING_MAY.tr()+" "+temp[2];
    } else if (str == "june") {
      return temp[0]+" "+LocaleKeys.MONITORING_JUNE.tr()+" "+temp[2];
    } else if (str == "july") {
      return temp[0]+" "+LocaleKeys.MONITORING_JULY.tr()+" "+temp[2];
    }else if (str == "august") {
      return temp[0]+" "+LocaleKeys.MONITORING_AUGUST.tr()+" "+temp[2];
    }else if (str == "september") {
      return temp[0]+" "+LocaleKeys.MONITORING_SEPTEMBER.tr()+" "+temp[2];
    }else if (str == "october") {
      return temp[0]+" "+LocaleKeys.MONITORING_OCTOBER.tr()+" "+temp[2];
    }else if (str == "november") {
      return temp[0]+" "+LocaleKeys.MONITORING_NOVEMBER.tr()+" "+temp[2];
    }else if (str == "december") {
      return temp[0]+" "+LocaleKeys.MONITORING_DECEMBER.tr()+" "+temp[2];
    }
    else {
      return "$string";
    }
  }else {
    return "$string";
  }

}