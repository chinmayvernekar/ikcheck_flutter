import 'package:flutter/cupertino.dart';
import 'package:iKCHECK/Models/AccountModel.dart';

class MainProvider with ChangeNotifier {
  Map identityStatus = {};
  Map enquiryItems = {};
  Map enquiryItemsOnMonitoring = {};
  Map dashboardDetails = {};
  List alertHelpDetails = [];
  Map pickedAlertEnquiryItems = {};
  Map handledAlertEnquiryItems = {};
  Map pickedHandledAlertEnquiryItems = {};
  Map alertFraudDetails = {};
  Map pickedHandledAlertFraudDetails = {};
  Map userNewsMessages = {};
  bool alertBool = false;
  bool messageBool = false;
  int selectedIndex = 0;
  AccountModal accountDetails = AccountModal();
  //Account Screen
  bool accStripBool = false;
  bool accStripStatusBool = false;
  String accStripContent = '';
  int playVideo =0;

  //Whole page loader
  bool isLoading = false;
  bool isLoadingMsg = false;
  bool isLoadingAlert = false;
  Locale? language;
  bool passwordValidatorChangePassword = false;
  bool passwordValidatorOldChangePassword = false;
  bool isnameloading = false;
  bool datalet = false;
  bool isfrsttimeusermonitoring = true;

  setPasswordValidatorChangePassword(bool data) {
    passwordValidatorChangePassword = data;
    notifyListeners();
  }

  setPasswordValidatorOldChangePassword(bool data) {
    passwordValidatorOldChangePassword = data;
    notifyListeners();
  }

  setLoaderStatus(bool data) {
    isLoading = data;
    notifyListeners();
  }

  setLanguageTitle(Locale data) {
    language = data;
    notifyListeners();
  }

  setfirstUser(bool data) {
    isfrsttimeusermonitoring = data;
    notifyListeners();
  }

  setPersonalLoading(bool data) {
    isnameloading = data;
    notifyListeners();
  }

  setselectedIndex(int data) {
    selectedIndex = data;
    notifyListeners();
  }

  setplayVideo(int data) {
    playVideo = data;
    notifyListeners();
  }

  setdataletvalue(bool data) {
    datalet = data;
    notifyListeners();
  }

  setLoaderMsgStatus(bool data) {
    isLoadingMsg = data;
    notifyListeners();
  }

  setLoaderAlertStatus(bool data) {
    isLoadingAlert = data;
    notifyListeners();
  }

  setIdentityStatus(Map data) {
    identityStatus = data;
    notifyListeners();
  }

  setAccStrip(bool data1, bool data2, String content) {
    accStripBool = data1;
    accStripStatusBool = data2;
    accStripContent = content;
    notifyListeners();
  }

  setEnquiryItems(Map data) {
    enquiryItems = data;
    notifyListeners();
  }

  setEnquiryItemsOnMonitoring(Map data) {
    enquiryItemsOnMonitoring = data;
    notifyListeners();
  }

  setPickedAlertEnquiryItems(Map data) {
    pickedAlertEnquiryItems = data;
    notifyListeners();
  }

  setDashboardDetails(Map data) {
    dashboardDetails = data;
    print("setdashboard details$data");
    notifyListeners();
  }

  setAlertHelpDetails(List data) {
    alertHelpDetails = data;
    notifyListeners();
  }

  setAlertFraudDetails(Map data) {
    alertFraudDetails = data;
    notifyListeners();
  }

  setHandledAlertEnquiryItems(Map data) {
    handledAlertEnquiryItems = data;
    notifyListeners();
  }

  setPickedHandledAlertFraudItems(Map data) {
    pickedHandledAlertFraudDetails = data;
    notifyListeners();
  }

  setPickedHandledAlertEnquiryItems(Map data) {
    pickedHandledAlertEnquiryItems = data;
    notifyListeners();
  }

  setUserNewsMessages(Map data) {
    userNewsMessages = data;
    notifyListeners();
  }

  setAlertBool(bool data) {
    alertBool = data;
    notifyListeners();
  }

  setMessageBool(bool data) {
    messageBool = data;
    notifyListeners();
  }

  setAccountDetails(AccountModal data) {
    accountDetails = data;
    notifyListeners();
  }
}
