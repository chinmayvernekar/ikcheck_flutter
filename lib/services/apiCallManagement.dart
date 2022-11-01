// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iKCHECK/Utils/globalFunctions.dart';
import 'package:iKCHECK/Utils/globalVariables.dart';
import 'package:iKCHECK/Utils/localStorage.dart';
import 'package:iKCHECK/providers/mainProvider.dart';
import 'package:provider/provider.dart';

import '../Models/AccountModel.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

var tempval;
var userIdlocal;
var finalToken;

class ApiCallManagement {
  userDetailApi(BuildContext context) async {
    String accessToken = await getString('access_token') ?? '';
    String userId = await getString('US_user_id') ?? '';

    final response = await http.get(
      Uri.parse(BASE_URL + '/user-service' + '/users/' + userId),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    try {
      if (response.statusCode == 200) {
        var decodeddata = jsonDecode(response.body);
        print(decodeddata);
        print("First Name" + decodeddata['firstName']);
        print("UserIDDDDDDDDD" + decodeddata['userId']);
        tempval = decodeddata['firstName'];
        userIdlocal = decodeddata['userId'];
        await storeString('userid', tempval);
        await storeString('localuserid', userIdlocal);
      } else {
        print("Something went wrong");
      }
      return response;
    } catch (e) {
      print(e);
      return e;
    }
  }

  signInApiCall(data) async {
    var response = await http.post(
      Uri.parse("$BASE_URL/login-service/oauth/token?"),
      body: data,
      headers: {"Authorization": "Basic Y2xpZW50OnNlY3JldA=="},
    );

    if (response.statusCode == 200) {
      var res = json.decode(response.body);
      await storeString('US_user_id', res['id']);
    }
    print(response);
    return response;
  }

  // rdwRegisterUnregister(data) async {
  //   var response = await http.post(
  //       Uri.parse(
  //           "$BASE_URL/authentication-service/rdwRegisterUnregister"),
  //       body: jsonEncode(data),
  //       headers: {
  //         "Authorization":
  //             "Bearer  eyJjdHkiOiJKV1QiLCJlbmMiOiJBMjU2R0NNIiwiYWxnIjoiUlNBLU9BRVAtMjU2In0.Hms3wmS833xeIU_kuDOzFcgfWhqJhGO625-Y4y800al0_Tt_VJNHU7-e5Bahxc43NfOgJEGGMg81QkvLtikCGzqsz2iCxNKWlsxvZP05QCBOeW1dOipko_PBFq8qzLExubrXZVuFCZAQJXUtflhOph_ZzqpWTntE-iQmy_qxhTL2PSWjE0VdvjiEU306ljaRZ00tR0wdD3fFhgyjbWtCmjrDTzQmZHJvlm-2OoJxtRRQZ7EIcoe6JKa5hssMxileGDZWaIdW4R8T34yipQDWaYiekUSaN98GFcOY80QNRsrW-JWkCdSVktxBCI05A4rXyvbxfEFvCGT_ATgQhmtY1w.X1bIHJYh7NLFkxoM.5-cJQx0bUv5toYsDmbjZrwMI_UBuj1OZ4b0Dim5amrzG0fjU7maFXpOZhDbql0R2nLgrP7qMUcQimlZ_P1vqcmA8-taT5SNlTdXVubSB90pLRuM-QMAduYj2Dh5EBHSdS0wvpIk4XxxKMT-R61ijMjj68oPtKkdsGgsEplziDvj2inc0GJ26xubCGanHiBn9dI4x1Q5xH2FUMmR8vu8kzqumHRnWlxStRC1wx_rHNvBQp-w86b0gi9JnmqgVB2OObguzeHzMSWM3Dl9USuFW_uTbuEd-FJLCehrh5bB0YmHmxt6-6AYi676vBA_Uz-hJYeyJbpxjLR6GZ--FvOHuM2dDeAj0cXqqsh1KMFUF5EA6Yu-_uuTbVmNHKs49i3QimbvaZ3Jj8fBu-odGh96pApMi4UOXvt69YUskTQSEd4kwJD7xtOcakx5ze-JrOYFYl04qeQyXyc6KqErx92-FV0oz-ULbVMsx2mI7D6iVmfbYd9fIjS8S-xyGNDuI0O5oGcfaAfDm6-_BFVNBhl1akQHEZrlSfHgfjv892Ta7cmfbll1qq4Z94_Ts1P04wNi5t4lDBhBmRPIlSregscXZK5oucqLiJc4fkGAKsiDFS47nlLzIs0hl8kvqUQhIn9dYxbuwPDxh1bSvFByK5TLnLQROsWUBKlqklvTHo19eUgSLVsp5DNMJCnfzXj7cIn2hzGeAVi1jYGfqjtYj7MwB3_Joi_wAt7zCjnROnNoTMrtFzKKgpqk52BIZNbq3-B-oASxbM5q7bO-0YKqfemeAFdrqkxyZkkhObClJdOoxuLvlj8qmmtoxZZZJbFtDtqI-pDCNnYHMxlhUc4IhltLoNc_qPTKQEYa-.HSn42xSQVy9duoAC-K72SA"
  //       });
  //   return response;
  // }

  forgotPasswordScreenApi(data) async {
    var response = await http.post(
      Uri.parse("$BASE_URL/user-service/forgot-password"),
      body: jsonEncode(data),
      headers: {"Content-Type": "application/json"},
    );
    return response;
  }

  enableSubscription(context) async {
    String accessToken = await getString('access_token') ?? '';
    var localuserid = await getString('US_user_id') ?? '';

    // var headers = {
    //   'Authorization': 'Bearer $accessToken',
    //   'Content-Type': 'application/json'
    // };
    var data = await http.post(
        Uri.parse(
            '$BASE_URL/subscription-service/enableSubscription/$localuserid'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json'
        });
    print("data.body${data.statusCode}");
    print("Bearer ${accessToken}");
    print('$BASE_URL/subscription-service/enableSubscription/$localuserid');
    data = await checkApiResponse(data, context);
    if (data.statusCode == 201) {
      return json.decode(data.body);
    } else {
      print("enable error${data.body}");
    }
  }

  getSubscriptionDetails(context) async {
    String accessToken = await getString('access_token') ?? '';
    String userId = await getString('US_user_id') ?? '';
    var data = await http.get(
      Uri.parse(
          '$BASE_URL/subscription-service/getSubscriptionDetails/$userId'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    print("data.body${data.statusCode}");
    data = await checkApiResponse(data, context);
    if (data.statusCode == 200) {
      return json.decode(data.body);
    } else {
      print("getSubscription ${data.body}");
    }
  }

  disableSubscription(context) async {
    String accessToken = await getString('access_token') ?? '';
    var localuserid = await getString('US_user_id') ?? '';

    print(localuserid);
    print(accessToken);

    var data = await http.post(
        Uri.parse(
            '$BASE_URL/subscription-service/disableSubscription/$localuserid'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json'
        });

    print(data.body);
    data = await checkApiResponse(data, context);
    if (data.statusCode == 200) {
      return json.decode(data.body);
      // showDialog(
      //     context: context,
      //     builder: (context)=>AlertDialog(
      //       title: Text("Sucess"),
      //       content: Text("Disabled Sucessfully"),
      //       actions: [
      //         MaterialButton(onPressed: (){
      //           Navigator.pop(context);
      //         },child: Text("Ok"),)
      //       ],
      //     )
      // );
    } else {
      // showDialog(
      //   context: context,
      //   builder: (context)=>AlertDialog(
      //     title: Text("Disabled"),
      //     content: Text("Data breach alerts are disabled"),
      //     actions: [
      //       MaterialButton(onPressed: (){
      //         Navigator.pop(context);
      //       },child: Text("Ok"),)
      //     ],
      //   )
      // );
    }
  }

  signUpApiCall(data) async {
    var response = await http.post(
      Uri.parse("$BASE_URL/user-service/users"),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    return response;
  }

  confirmPasscode(data) async {
    return await http.post(
      Uri.parse("$BASE_URL/user-service/confirm-passcode"),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
  }

  resetPassword(data) async {
    return await http.post(
      Uri.parse("$BASE_URL/user-service/reset-password"),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
  }

  createDynamicLink(String uuid, deepLinkObj) async {
    Map object = {
      'dynamicLinkInfo': {
        'domainUriPrefix': FIREBASE_DEEPLINK_URI_PREFIX,
        'link': RETURN_URL + (Uri.encodeComponent(deepLinkObj.toString())),
        'androidInfo': {'androidPackageName': 'check.app'},
        'iosInfo': {'iosBundleId': 'ikcheck.app'}
      }
    };
    var response = await http.post(
      Uri.parse(FIREBASE_DEEPLINK_API),
      body: jsonEncode(object),
      headers: {'Content-Type': 'application/json'},
    );
    return json.decode(response.body);
  }

  rdwRegisterUnregister(int register, BuildContext context) async {
    var localuserid = await getString('US_user_id') ?? '';
    String accessToken = await getString('access_token') ?? '';
    dynamic data = {"userId": localuserid, "register": register};

    var response = await http.post(
      Uri.parse('$BASE_URL/authentication-service/rdwRegisterUnregister'),
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
    );
    response = await checkApiResponse(response, context);
    return json.decode(response.body);
  }

  getIdentityStatus(BuildContext context) async {
    String userId = await getString('US_user_id') ?? '';
    String accessToken = await getString('access_token') ?? '';
    Map object = {'userId': userId, 'countryCode': 'NLD'};

    var response = await http.post(
      Uri.parse('$BASE_URL/authentication-service/user/Authentication/Status'),
      body: jsonEncode(object),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
    );
    response = await checkApiResponse(response, context);

    Provider.of<MainProvider>(context, listen: false).setIdentityStatus(
      json.decode(response.body),
    );
  }

  getIdentityEnquiryDetails(
      BuildContext context, Map? object, String identifyString) async {
    String accessToken = await getString('access_token') ?? '';
    print("MyBody $object");
    var response = await http.post(
      Uri.parse('$BASE_URL/alert-service/alerts/enquiry'),
      body: jsonEncode(object),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
    );

    response = await checkApiResponse(response, context);

    print("MyResp ${response.body}");
    if (identifyString == 'pickedAlert') {
      Provider.of<MainProvider>(context, listen: false)
          .setPickedAlertEnquiryItems(
        json.decode(response.body),
      );
      // print("alerttype ${response.body}");
    } else if (identifyString == 'handledAlertEnquiryItems') {
      print("MyResponse from alert");
      print("MyResp1 ${response.body}");
      Provider.of<MainProvider>(context, listen: false)
          .setHandledAlertEnquiryItems(
        json.decode(response.body),
      );
    } else if (identifyString == 'pickedhandledAlertEnquiryItems') {
      Provider.of<MainProvider>(context, listen: false)
          .setPickedHandledAlertEnquiryItems({});
      Provider.of<MainProvider>(context, listen: false)
          .setPickedHandledAlertEnquiryItems(
        json.decode(response.body),
      );
    } else if (identifyString == "enquiryItemsOnMonitoring") {
      var data = json.decode(response.body);

      try {
        (data['items'] as List).sort((a, b) => (b['id']).compareTo(a['id']));
      } catch (e) {
        print(e);
      }
      print("MyRespmonitor ${response.body}");
      print("data $data");
      Provider.of<MainProvider>(context, listen: false)
          .setEnquiryItemsOnMonitoring(
        data ?? {},
      );
    } else {
      var data = json.decode(response.body);
      // var data = {
      //   "items": [
      //     {
      //       "id": 3772,
      //       "identity": "5986D47C-EC80-11EC-8D6C-9F5CDC4B9F20",
      //       "identityType": "RDW-UID-DL",
      //       "read": false,
      //       "details": "Rijbewijs koppelen mislukt",
      //       "time": "2022-06-16 08:19:52",
      //       "sourceSystemId": "RDW",
      //       "orgId": "RDW",
      //       "usageBy": "User",
      //       "amount": 0.0,
      //       "reference": "0000",
      //       "type": "RDW_DL_RVK",
      //       "alertTypeDesc": null,
      //       "alertTypeMsg": null,
      //       "alertTypeQuestion": null,
      //       "alertTypeShortDesc": null,
      //       "events": 0,
      //       "fraudId": 0,
      //       "status": "To Be Attended"
      //     },
      //     {
      //       "id": 3773,
      //       "identity": "E0B813CB-ED4C-11EC-8D6C-437703F5B41C",
      //       "identityType": "RDW-UID-DL",
      //       "read": false,
      //       "details": "Rijbewijs gekoppeld",
      //       "time": "2022-06-16 08:19:52",
      //       "sourceSystemId": "RDW",
      //       "orgId": "RDW",
      //       "usageBy": "User",
      //       "amount": 0.0,
      //       "reference": "0113",
      //       "type": "RDW_DL_CON",
      //       "alertTypeDesc": null,
      //       "alertTypeMsg": null,
      //       "alertTypeQuestion": null,
      //       "alertTypeShortDesc": null,
      //       "events": 0,
      //       "fraudId": 0,
      //       "status": "To Be Attended"
      //     },
      //     {
      //       "id": 3771,
      //       "identity": "5986D47C-EC80-11EC-8D6C-9F5CDC4B9F20",
      //       "identityType": "RDW-UID-DL",
      //       "read": false,
      //       "details": "Rijbewijs koppelen mislukt",
      //       "time": "2022-06-16 08:11:57",
      //       "sourceSystemId": "RDW",
      //       "orgId": "RDW",
      //       "usageBy": "User",
      //       "amount": 0.0,
      //       "reference": "0000",
      //       "type": "RDW_DL_RVK",
      //       "alertTypeDesc": null,
      //       "alertTypeMsg": null,
      //       "alertTypeQuestion": null,
      //       "alertTypeShortDesc": null,
      //       "events": 0,
      //       "fraudId": 0,
      //       "status": "To Be Attended"
      //     },
      //     {
      //       "id": 3768,
      //       "identity": "5986D47C-EC80-11EC-8D6C-9F5CDC4B9F20",
      //       "identityType": "RDW-UID-DL",
      //       "read": false,
      //       "details": "Rijbewijs koppelen mislukt",
      //       "time": "2022-06-16 07:54:41",
      //       "sourceSystemId": "RDW",
      //       "orgId": "RDW",
      //       "usageBy": "User",
      //       "amount": 0.0,
      //       "reference": "0000",
      //       "type": "RDW_DL_RVK",
      //       "alertTypeDesc": null,
      //       "alertTypeMsg": null,
      //       "alertTypeQuestion": null,
      //       "alertTypeShortDesc": null,
      //       "events": 0,
      //       "fraudId": 0,
      //       "status": "To Be Attended"
      //     },
      //     {
      //       "id": 3765,
      //       "identity": "5986D47C-EC80-11EC-8D6C-9F5CDC4B9F20",
      //       "identityType": "RDW-UID-DL",
      //       "read": false,
      //       "details": "Rijbewijs koppelen mislukt",
      //       "time": "2022-06-16 07:51:47",
      //       "sourceSystemId": "RDW",
      //       "orgId": "RDW",
      //       "usageBy": "User",
      //       "amount": 0.0,
      //       "reference": "0000",
      //       "type": "RDW_DL_RVK",
      //       "alertTypeDesc": null,
      //       "alertTypeMsg": null,
      //       "alertTypeQuestion": null,
      //       "alertTypeShortDesc": null,
      //       "events": 0,
      //       "fraudId": 0,
      //       "status": "To Be Attended"
      //     },
      //     {
      //       "id": 3763,
      //       "identity": "560027BA-EC1D-11EC-8D6C-FDCB2F122D21",
      //       "identityType": "RDW-UID-DL",
      //       "read": false,
      //       "details": "Rijbewijs koppelen mislukt",
      //       "time": "2022-06-16 07:47:54",
      //       "sourceSystemId": "RDW",
      //       "orgId": "RDW",
      //       "usageBy": "User",
      //       "amount": 0.0,
      //       "reference": "0000",
      //       "type": "RDW_DL_RVK",
      //       "alertTypeDesc": null,
      //       "alertTypeMsg": null,
      //       "alertTypeQuestion": null,
      //       "alertTypeShortDesc": null,
      //       "events": 0,
      //       "fraudId": 0,
      //       "status": "To Be Attended"
      //     },
      //     {
      //       "id": 3751,
      //       "identity": "5986D47C-EC80-11EC-8D6C-9F5CDC4B9F20",
      //       "identityType": "RDW-UID-DL",
      //       "read": false,
      //       "details": "Rijbewijs gekoppeld",
      //       "time": "2022-06-15 18:04:23",
      //       "sourceSystemId": "RDW",
      //       "orgId": "RDW",
      //       "usageBy": "User",
      //       "amount": 0.0,
      //       "reference": "0113",
      //       "type": "RDW_DL_CON",
      //       "alertTypeDesc": null,
      //       "alertTypeMsg": null,
      //       "alertTypeQuestion": null,
      //       "alertTypeShortDesc": null,
      //       "events": 0,
      //       "fraudId": 0,
      //       "status": "To Be Attended"
      //     },
      //     {
      //       "id": 3749,
      //       "identity": "5986D47C-EC80-11EC-8D6C-9F5CDC4B9F20",
      //       "identityType": "RDW-UID-DL",
      //       "read": false,
      //       "details": "Rijbewijs gekoppeld",
      //       "time": "2022-06-15 18:03:48",
      //       "sourceSystemId": "RDW",
      //       "orgId": "RDW",
      //       "usageBy": "User",
      //       "amount": 0.0,
      //       "reference": "0113",
      //       "type": "RDW_DL_CON",
      //       "alertTypeDesc": null,
      //       "alertTypeMsg": null,
      //       "alertTypeQuestion": null,
      //       "alertTypeShortDesc": null,
      //       "events": 0,
      //       "fraudId": 0,
      //       "status": "To Be Attended"
      //     },
      //     {
      //       "id": 3733,
      //       "identity": "560027BA-EC1D-11EC-8D6C-FDCB2F122D21",
      //       "identityType": "RDW-UID-DL",
      //       "read": true,
      //       "details": "Rijbewijs koppelen mislukt",
      //       "time": "2022-06-15 10:58:45",
      //       "sourceSystemId": "RDW",
      //       "orgId": "RDW",
      //       "usageBy": "User",
      //       "amount": 0.0,
      //       "reference": "0000",
      //       "type": "RDW_DL_RVK",
      //       "alertTypeDesc": null,
      //       "alertTypeMsg": null,
      //       "alertTypeQuestion": null,
      //       "alertTypeShortDesc": null,
      //       "events": 1,
      //       "fraudId": 0,
      //       "status": "NF_CLOSE"
      //     },
      //     {
      //       "id": 3730,
      //       "identity": "560027BA-EC1D-11EC-8D6C-FDCB2F122D21",
      //       "identityType": "RDW-UID-DL",
      //       "read": false,
      //       "details": "Rijbewijs koppelen mislukt",
      //       "time": "2022-06-15 10:51:17",
      //       "sourceSystemId": "RDW",
      //       "orgId": "RDW",
      //       "usageBy": "User",
      //       "amount": 0.0,
      //       "reference": "0000",
      //       "type": "RDW_DL_RVK",
      //       "alertTypeDesc": null,
      //       "alertTypeMsg": null,
      //       "alertTypeQuestion": null,
      //       "alertTypeShortDesc": null,
      //       "events": 0,
      //       "fraudId": 0,
      //       "status": "To Be Attended"
      //     }
      //   ],
      //   "pages": 2,
      //   "count": 16
      // };

      try {
        (data['items'] as List).sort((a, b) => (b['id']).compareTo(a['id']));
      } catch (e) {
        print(e);
      }
      Provider.of<MainProvider>(context, listen: false).setEnquiryItems(
        data ?? {},
      );
    }
  }

  getDashboardDetails(BuildContext context) async {
    try {
      String accessToken = await getString('access_token') ?? '';
      String userId = await getString('US_user_id') ?? '';
      Map object = {
        'userId': userId,
        'countryCode': 'NLD',
      };

      var response = await http.post(
        Uri.parse("$BASE_URL/user-service/userDashboardDetail"),
        body: json.encode(object),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
      response = await checkApiResponse(response, context);
      print("setdashboard details ${json.decode(response.body)}");
      Provider.of<MainProvider>(context, listen: false)
          .setDashboardDetails(json.decode(response.body));
      Provider.of<MainProvider>(context, listen: false).setAlertBool(
        showingBadgeBasedonDashboardApi(json.decode(response.body), context),
      );
      Provider.of<MainProvider>(context, listen: false).setMessageBool(
        checkingForUnreadMessage(json.decode(response.body), context),
      );
    } catch (e) {
      print("$e");
    }
  }

  getHelpAlertsDetails(
      BuildContext context, String alertType, String orgId) async {
    String accessToken = await getString('access_token') ?? '';
    String currentLang = await getString('LANG') ?? '';
    if (currentLang == '') {
      currentLang = 'nl';
    }

    Map object = {
      'alertTypeId': alertType,
      'orgId': orgId,
      "language": currentLang.toUpperCase(),
    };

    var response = await http.post(
      Uri.parse("$BASE_URL/alert-service/help"),
      body: json.encode(object),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    response = await checkApiResponse(response, context);

    return json.decode(response.body);
    // Provider.of<MainProvider>(context, listen: false).setAlertHelpDetails();
  }

  updateFraudCall(
    object,
    BuildContext context,
  ) async {
    String accessToken = await getString('access_token') ?? '';

    var response = await http.post(
      Uri.parse("$BASE_URL/fraud-service/updateFraud"),
      body: json.encode(object),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    response = await checkApiResponse(response, context);
    print("response ${response.statusCode}");
    if (response.statusCode == 201) {
      print(json.encode(response.body));
      print("response of fraud api ${json.encode(response.body)}");
    }
  }

  fraudDetailsApiCall(object, context, identify) async {
    String accessToken = await getString('access_token') ?? '';

    var response = await http.post(
      Uri.parse("$BASE_URL/fraud-service/fraudAddlDetails"),
      body: json.encode(object),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    response = await checkApiResponse(response, context);

    if (identify == 'pickedFraudDetails') {
      Provider.of<MainProvider>(context, listen: false)
          .setPickedHandledAlertFraudItems(json.decode(response.body));
    } else {
      Provider.of<MainProvider>(context, listen: false)
          .setAlertFraudDetails(json.decode(response.body));
    }

    // if (response.statusCode == 201) {
    //   // print(json.encode(response.body));
    // }
  }

  updateReadCountApi(Map object, BuildContext context) async {
    String accessToken = await getString('access_token') ?? '';
    var response = await http.post(
      Uri.parse("$BASE_URL/alert-service/setAlertAsReadUnread"),
      body: json.encode(object),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    response = await checkApiResponse(response, context);
  }

  getMessagesUserNewsApi(BuildContext context, int page) async {
    String userId = await getString('US_user_id') ?? '';
    String accessToken = await getString('access_token') ?? '';

    Map object = {
      'fromDate': null,
      'page': 1,
      'sort': "Date time",
      'toDate': null,
      'userId': userId,
    };

    print(object);
    print("$BASE_URL/user-news-service/userNews");
    print(accessToken);

    var response = await http.post(
      Uri.parse("$BASE_URL/user-news-service/userNews"),
      body: json.encode(object),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    print("response of message is ${response.body}");
    print("accesstoken: ${accessToken}");
    response = await checkApiResponse(response, context);
    const utf8Decoder = Utf8Decoder(allowMalformed: true);
    //final decodedBytes = utf8Decoder.convert(response.bodyBytes);
    Provider.of<MainProvider>(context, listen: false).setUserNewsMessages(
      json.decode(
        utf8Decoder.convert(response.bodyBytes),
      ),
    );
  }

  updateMessageAsReadUnreadDelete(String heading, int newsId, String msgStatus,
      BuildContext context) async {
    String userId = await getString('US_user_id') ?? '';
    String accessToken = await getString('access_token') ?? '';

    Map object = {
      'heading': heading,
      'newsId': newsId,
      'readStatus': msgStatus,
      'userId': userId,
    };

    var response = await http.post(
      Uri.parse("$BASE_URL/user-news-service/userNewsReadStatus"),
      body: json.encode(object),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    response = await checkApiResponse(response, context);
  }

//Firebase devicetoken api call
  postFirebaseToken(
      String? firebaseToken, String tokenStatus, BuildContext context) async {
    String userId = await getString('US_user_id') ?? '';
    String accessToken = await getString('access_token') ?? '';

    Map object = {
      'userId': userId,
      'token': firebaseToken,
      'tokenStatus': tokenStatus
    };

    var response = await http.post(
      Uri.parse("$BASE_URL/user-service/fireBaseToken"),
      body: json.encode(object),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    await checkApiResponse(response, context);
  }

  getAccountDetails(BuildContext context) async {
    String accessToken = await getString('access_token') ?? '';
    String userId = await getString('US_user_id') ?? '';
    var response = await http.get(
      Uri.parse('$BASE_URL/user-service/userDetails/$userId'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    response = await checkApiResponse(response, context);

    if (response.statusCode == 200) {
      Map decodedData = json.decode(response.body);
      try {
        AccountModal data = AccountModal(
          userId: decodedData['userId'],
          firstName: decodedData['firstName'],
          middleName: decodedData['middleName'],
          lastName: decodedData['lastName'],
          email: decodedData['email'],
          mobile: decodedData['mobile'],
          birthDate: decodedData['birthDate'],
          addressNo: decodedData['addressNo'],
          addressSuffix: decodedData['addressSuffix'],
          addressLine1: decodedData['addressLine1'],
          addressLine2: decodedData['addressLine2'],
          addressLine3: decodedData['addressLine3'],
          region: decodedData['region'],
          zipCode: decodedData['zipCode'],
          countryCode: decodedData['countryCode'],
          gender: decodedData['gender'],
          password: decodedData['password'],
        );

        Provider.of<MainProvider>(context, listen: false)
            .setAccountDetails(data);
      } catch (e) {
        print('Err at decoding $e');
      }
    } else {
      print('Err at decoding ${response.body}');
    }
  }

//Firebase devicetoken api call
  Future<String> updateAccountDetails(Map object, BuildContext context) async {
    String accessToken = await getString('access_token') ?? '';

    var response = await http.post(
      Uri.parse("$BASE_URL/user-service/userDetails"),
      body: json.encode(object),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    // print(json.decode(response.body));
    response = await checkApiResponse(response, context);
    if (response.statusCode == 200) {
      print('Succesfully token updated');
      await storeString('userid', object['firstName']);
      return 'SUCCESS';
    } else if (response.statusCode == 400) {
      if (json.decode(response.body)['code'].contains('U_211')) {
        return 'Old password incorrect';
      } else {
        return 'FAILED';
      }
    } else {
      print('Failed token update ${response.body}');
      return 'FAILED';
    }
  }

  Future<String> deleteAccount(BuildContext context) async {
    String accessToken = await getString('access_token') ?? '';
    String userId = await getString('US_user_id') ?? '';
    try {
      var response = await http.get(
        Uri.parse('$BASE_URL/fraud-service/clearFraud/$userId'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      response = await checkApiResponse(response, context);

      // print(response);
      // We are awaiting to clear the Alerts before we clear the Identities.
      http.Response response1 = await http.get(
        Uri.parse('$BASE_URL/alert-service/clearAlert/$userId'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      print(response1);

      http.get(
        Uri.parse('$BASE_URL/authentication-service/clearAuth/$userId'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      // print(response);

      http.get(
        Uri.parse('$BASE_URL/user-service/clearUserConsent/$userId'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      // print(response);

      http.get(
        Uri.parse('$BASE_URL/audit-log-service/clearLogs-Audit/$userId'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      // print(response);

      http.get(
        Uri.parse('$BASE_URL/user-news-service/clearLogsUserNews/$userId'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      // print(response);

      http.get(
        Uri.parse(
            '$BASE_URL/subscription-service/clearUserSubscriptionLnk/$userId'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      // print(response);

      http.get(
        Uri.parse('$BASE_URL/todo-service/clearLogToDo/$userId'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      // print(response);

      http.get(
        Uri.parse('$BASE_URL/user-service/deleteUserAccount/$userId'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      // print(response);

      return 'SUCCESS';
    } catch (e) {
      print('Err at deleting the account $e');
      return 'FAILED';
    }
  }

  Future<String> clearAccount(BuildContext context) async {
    String accessToken = await getString('access_token') ?? '';
    String userId = await getString('US_user_id') ?? '';
    try {
      // http.Response response;
      http.Response response = await http.get(
        Uri.parse('$BASE_URL/fraud-service/clearFraud/$userId'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      response = await checkApiResponse(response, context);

      // print(response);
      // We are awaiting to clear the Alerts before we clear the Identities.
      http.Response response1 = await http.get(
        Uri.parse('$BASE_URL/alert-service/clearAlert/$userId'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      print(response1);

      http.get(
        Uri.parse('$BASE_URL/authentication-service/clearAuth/$userId'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      // print(response);

      http.get(
        Uri.parse('$BASE_URL/user-service/clearUserConsent/$userId'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      // print(response);

      http.get(
        Uri.parse('$BASE_URL/audit-log-service/clearLogs-Audit/$userId'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      // print(response);

      http.get(
        Uri.parse('$BASE_URL/user-news-service/clearLogsUserNews/$userId'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      // print(response);

      http.get(
        Uri.parse(
            '$BASE_URL/subscription-service/clearUserSubscriptionLnk/$userId'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      // print(response);

      http.get(
        Uri.parse('$BASE_URL/todo-service/clearLogToDo/$userId'),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      // print(response);
      Provider.of<MainProvider>(context, listen: false).setEnquiryItems({});
      return 'SUCCESS';
    } catch (e) {
      print('Err at clearing the account data $e');
      return 'FAILED';
    }
  }

  Future getAppVersionForDB() async {
    Map object = {
      "category": "VERSION",
    };
    final response = await http.post(
      Uri.parse("$BASE_URL/system-service/getParam"),
      body: json.encode(object),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return 'FAILED';
    }
  }

//https://api.acc.ikcheck.app/user-service/getRegisterUser/
  Future getDeepLinkDetails(String regId) async {
    var response = await http.get(
      Uri.parse('$BASE_URL/user-service/getRegisterUser/$regId'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
  }
}
