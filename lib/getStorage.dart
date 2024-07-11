import 'package:get_storage/get_storage.dart';

class GetSetStorage {
  static String getAPI() {
    final box = GetStorage();
    return box.read("API") ?? "";
  }

  static setAPI(String API) {
    final box = GetStorage();
    box.write("API", API);
  }

  static bool getOnboard() {
    final box = GetStorage();
    return box.read("ONBOARD") ?? true;
  }

  static setOnboard(bool ONBOARD) {
    final box = GetStorage();
    box.write("ONBOARD", ONBOARD);
  }

  static String getFrom() {
    final box = GetStorage();
    return box.read("FROM") ?? "";
  }

  static setFrom(String FROM) {
    final box = GetStorage();
    box.write("FROM", FROM);
  }

  static String getTo() {
    final box = GetStorage();
    return box.read("TO") ?? "";
  }

  static setTo(String TO) {
    final box = GetStorage();
    box.write("TO", TO);
  }

  static String getLocation() {
    final box = GetStorage();
    return box.read("LOCATION") ?? "";
  }

  static setLocation(String LOCATION) {
    final box = GetStorage();
    box.write("LOCATION", LOCATION);
  }

  static String getEmergencyContact1() {
    final box = GetStorage();
    return box.read("EMERGENCYCONTACT1") ?? "";
  }

  static setEmergencyContact1(String EMERGENCYCONTACT1) {
    final box = GetStorage();
    box.write("EMERGENCYCONTACT1", EMERGENCYCONTACT1);
  }

  static String getEmergencyContact2() {
    final box = GetStorage();
    return box.read("EMERGENCYCONTACT2") ?? "";
  }

  static setEmergencyContact2(String EMERGENCYCONTACT2) {
    final box = GetStorage();
    box.write("EMERGENCYCONTACT2", EMERGENCYCONTACT2);
  }
}
