String? validateNotEmpty(String? value) {
  if (value == null || value.isEmpty || value.length < 3) {
    return 'Field must be longer than 3 characters';
  }
  return null;
}

String? validateEmail(String? formEmail) {
  if (formEmail == null || formEmail.isEmpty) {
    return 'Email address is require';
  }
  String pattern = r'\w+@\w+\.\w+';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formEmail)) {
    return 'Invalid Email Address Format';
  }
  return null;
}

String? validatePassword(String? formPassword) {
  if (formPassword == null || formPassword.isEmpty) {
    return 'Password address is require';
  }
  String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(formPassword)) {
    return '''
      Password must be at least 6 characters,
      include an uppercase letter, number and symbol.
      ''';
  }
  return null;
}