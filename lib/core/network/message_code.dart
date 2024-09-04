import 'package:flutter/material.dart';

String messageCode(String code, BuildContext context) {
  switch (code) {
    case 'notAuthorized':
      return 'Not Authorized';
    case 'notFound':
      return 'Not Found';
    case 'internalServerError':
      return 'Internal Server Error';
    case 'unprocessableEntity':
      return 'Unprocessable Entity';

    case 'tokenNotFound':
      return 'Token Not Found';
    case 'tokenExpiredOrUsed':
      return 'Token Expired Or Used';
    case 'refreshTokenExpired':
      return 'Refresh Token Expired';

    default:
      return code;
  }
}
