import 'package:url_launcher/url_launcher.dart';

class UrlLauncher {
  Future<void> open(String url) async {
     final Uri open = Uri.parse(url);
    if (!await launchUrl(open)) {
      throw Exception('Could not launch $url');
    }
  }
}
