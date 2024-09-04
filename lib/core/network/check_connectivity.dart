import 'package:connectivity_widget/connectivity_widget.dart';

Future<bool> checkConnectivity() async {
  return ConnectivityUtils.instance.isPhoneConnected();
}
