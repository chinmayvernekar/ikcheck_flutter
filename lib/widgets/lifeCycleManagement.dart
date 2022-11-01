import 'package:flutter/material.dart';
import 'package:iKCHECK/Utils/globalVariables.dart';
import 'package:iKCHECK/Utils/localStorage.dart';
import 'package:iKCHECK/providers/mainProvider.dart';
import 'package:iKCHECK/services/apiCallManagement.dart';
import 'package:iKCHECK/services/notificationManagement.dart';
import 'package:provider/provider.dart';

class LifeCycleManager extends StatefulWidget {
  final Widget child;
  String fromPage;

  LifeCycleManager(@required this.child, @required this.fromPage, {Key? key})
      : super(key: key);
  _LifeCycleManagerState createState() => _LifeCycleManagerState();
}

class _LifeCycleManagerState extends State<LifeCycleManager>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (AppLifecycleState.resumed == state) {
      if (state == AppLifecycleState.resumed) {
        if (widget.fromPage == 'main') {
          await flutterLocalNotificationsPlugin.cancelAll();
          // Provider.of<MainProvider>(context, listen: false)
          //     .setLoaderStatus(true);
          // await ApiCallManagement().getDashboardDetails(context);
          // Provider.of<MainProvider>(context, listen: false)
          //     .setLoaderStatus(false);

          // print(backgroundVariableCheck);
          // String backgroundNotificationType =
          //     await getString('BACKGROUNDNOTIFICATIONTYPE') ?? '';
          // print(
          //     'BACKGROUNDNOTIFICATIONTYPE1234 ${await getString('BACKGROUNDNOTIFICATIONTYPE')}');
          // if (backgroundNotificationType == 'MESSAGE') {
          //   Map data = Provider.of<MainProvider>(globelContext!, listen: false)
          //       .dashboardDetails;
          //   if (data['unReadNewsCount'] == null) {
          //     data['unReadNewsCount'] = 1;
          //   } else {
          //     data['unReadNewsCount'] = data['unReadNewsCount'] + 1;
          //   }
          //   Provider.of<MainProvider>(globelContext!, listen: false)
          //       .setDashboardDetails(data);
          //   await storeString('BACKGROUNDNOTIFICATIONTYPE', '');
          // } else if (backgroundNotificationType == 'ALERT') {
          //   Map data = Provider.of<MainProvider>(globelContext!, listen: false)
          //       .dashboardDetails;
          //   if (data['unreadAlert'] == null) {
          //     data['unreadAlert'] = 1;
          //   } else {
          //     data['unreadAlert'] = data['unreadAlert'] + 1;
          //   }
          //   Provider.of<MainProvider>(globelContext!, listen: false)
          //       .setDashboardDetails(data);
          //   await storeString('BACKGROUNDNOTIFICATIONTYPE', '');
          // }
        }
      }
    }

    // if (AppLifecycleState.detached == state) {
    //   String currentLang = await getString('LANG') ?? '';
    //   await clearStorage();
    //   await storeString('LANG', currentLang);
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.child,
    );
  }
}
