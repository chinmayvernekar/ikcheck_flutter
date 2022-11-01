// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

const SCREENWIDTH = 428;
const SCREENHEIGHT = 926;


// ikcheck acc
const BASE_URL = 'https://api.acc.ikcheck.app';
const DOMAIN_URL = 'https://acc.ikcheck.app';
const RDW_CONSENT_URL =
    'https://meldingrijbewijscontrole.gatrdw.nl/aanmelden/akkoord?subscriptionId=';
const RDW_REVOKE_URL =
    'https://meldingrijbewijscontrole.gatrdw.nl/afmelden/akkoord?subscriptionId=';
const RETURN_URL = 'https://acc.ikcheck.app?data=';
const WHR_URL = '&whr=http://taccount.otrdw.nl/adfs/services/trust';
const FIREBASE_DEEPLINK_API =
    'https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=AIzaSyCIpagnSmBtcERvdyZMOxmkEmxYrEMgmYM';
const FIREBASE_DEEPLINK_URI_PREFIX = 'https://ikcheckacc.page.link';
const SHARE_LINK = "https://ikcheck.com";
// const SHARE_LINK = "https://ikcheckacc.page.link/jdF1";

// ikcheck prod
// const BASE_URL = 'https://api.ikcheck.app';
// const DOMAIN_URL = 'https://ikcheck.app';
// const RDW_CONSENT_URL =
//     'https://meldingrijbewijscontrole.rdw.nl/aanmelden/akkoord?subscriptionId=';
// const RDW_REVOKE_URL =
//     'https://meldingrijbewijscontrole.rdw.nl/afmelden/akkoord?subscriptionId=';
// const RETURN_URL = 'https://ikcheck.app?data=';
// const WHR_URL = '';
// const FIREBASE_DEEPLINK_API =
//     'https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=AIzaSyA8gxlVYlTUZ6QGolOkNQTiUwPLpCZyscQ';
// const FIREBASE_DEEPLINK_URI_PREFIX = 'https://ikcheckapp.page.link';
// // const SHARE_LINK = "https://ikcheckapp.page.link/tobR";
// const SHARE_LINK = "https://ikcheck.com";

BuildContext? globelContext;
int navBarIndex = -1;

bool isLoadingPD = false;
String userIdForMsgAndAlert = '';
String userNameGlobel = '';
String? backgroundVariableCheck;
Map deepLinkDecodedData = {};

String emailInfoMonitoring = "";
int? lastScanId;
int buttonStatus = 0;
String emailForCache = '';
//Commends for localization
// flutter pub run easy_localization:generate --source-dir ./assets/i18n
// flutter pub run easy_localization:generate -S assets/i18n -f keys -o locale_keys.g.dart