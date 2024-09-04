import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationResult {
  final String name;
  final Position position;

  LocationResult(this.name, this.position);
}

class NotificationResult {
  final bool allowed;

  NotificationResult(this.allowed);
}

class AppPermission {
  //PERMISSION LOCATION
  Future<bool> checkLocation() async {
    PermissionStatus status = await Permission.location.request();

    if (status.isGranted || status.isLimited || status.isProvisional) {
      return true;
    } else {
      return false;
    }
  }

  Future<LocationResult> getLocation() async {
    bool locationPermission = await checkLocation();
    if (!locationPermission) {
      throw Exception("Location permission denied");
    } else {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];

      String name =
          "${place.name == "" ? place.locality : place.name}, ${place.administrativeArea}, ${place.country}";

      return LocationResult(name, position);
    }
  }

  //PERMISSION NOTIFICATION
  Future<bool> checkNotification() async {
    PermissionStatus status = await Permission.notification.request();

    if (status.isGranted || status.isLimited || status.isProvisional) {
      return true;
    } else {
      return false;
    }
  }

  Future<NotificationResult> getNotification() async {
    bool notificationPermission = await checkNotification();

    if (!notificationPermission) {
      throw Exception("Notification permission denied");
    } else {
      return NotificationResult(true);
    }
  }
}
