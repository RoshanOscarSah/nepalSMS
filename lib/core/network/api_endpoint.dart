import 'package:flutter_dotenv/flutter_dotenv.dart';
// Base URL

final String baseUrl = dotenv.env['BASE_URL'].toString();

// Auth
final String usersUrl = "${baseUrl}users/";
final String usersMeUrl = "${baseUrl}users/me/";
final String jwtCreateUrl = "${baseUrl}jwt/create/";
final String jwtRefreshUrl = "${baseUrl}jwt/refresh/";
final String usersReset0paswordUrl = "${baseUrl}users/reset_password/";
final String usersSet0paswordUrl = "${baseUrl}users/set_password/";

//products
final String productsUrl = "${baseUrl}products/";

//pricing
final String packagesUrl = "${baseUrl}packages/";

//Profile
final String imagesUrl = "${baseUrl}images/";
