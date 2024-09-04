import 'valid.dart';

String? emailValidator(String? value) {
  if (value!.isEmpty) {
    return "Email is required";
  } else if (value.isValidEmail && value.length <= 254 && value.isNotEmpty) {
    return null;
  } else {
    return "Enter valid email with @ and .";
  }
}

String? passwordValidator(String? value,
    {String? confirmPassword, String? oldPassword}) {
  if (value == null || value.isEmpty) {
    return "Password is required";
  }
  if (!value.isValidPassword || value.length < 8 || value.length > 254) {
    return "Password must be 8+ chars with uppercase, lowercase, digit, and special char.";
  }

  // Check if confirmPassword is provided and does not match the value
  if (confirmPassword != null && confirmPassword != value) {
    return "Passwords do not match";
  }

  // Check if confirmPassword and oldPassword are provided and do not match
  if (oldPassword != null &&
      oldPassword.isNotEmpty &&
      confirmPassword == oldPassword) {
    return "Old password and new password is same";
  }

  return null;
}

String? nameValidator(String? value) {
  if (value!.isEmpty) {
    return "This field is required";
  } else if (value.isValidName && value.length <= 100 && value.isNotEmpty) {
    return null;
  } else {
    return "Enter Letters only.";
  }
}

String? usernameValidator(String? value) {
  if (value!.isEmpty) {
    return "Username is required";
  } else if (value.isValidUsername && value.length <= 150 && value.isNotEmpty) {
    return null;
  } else {
    return "Enter Letters, digits and @ . + - _ only.";
  }
}

String? phoneValidator(String? value) {
  if (value!.isEmpty) {
    return "Phone number is required";
  } else if (value.isValidPhone && value.length == 10 && value.isNotEmpty) {
    return null;
  } else {
    return "Enter digits and - ( ) + only.";
  }
}

String? dateValidator(String? value) {
  if (value!.isEmpty) {
    return "Date is required";
  } else if (value.isValidDate && value.isNotEmpty) {
    return null;
  } else {
    return "Enter digits and / only";
  }
}

String? messageValidator(String? value) {
  if (value!.isEmpty) {
    return "message is required";
  } else if (value.length <= 1000 && value.isNotEmpty) {
    return null;
  } else {
    return "Enter letter number and character.";
  }
}

String? urlValidator(String? value) {
  if (value!.isEmpty) {
    return "url is required";
  } else if (value.isValidUrl && value.length <= 1000 && value.isNotEmpty) {
    return null;
  } else {
    return "Enter example.com";
  }
}