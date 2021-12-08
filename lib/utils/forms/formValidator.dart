String validateEmail(String email) {
  email = email.trim();
  if (email.isEmpty) return 'Email can not be empty';
  var emailValid = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
  return emailValid ? '' : 'Enter a valid email address';
}

String validatePassword(String password) {
  password = password.trim();
  if (password.isEmpty) return 'Password can not be empty';
  return password.length < 6 ? 'Use at least 6 characters' : '';
}

String validateSecondPassword(String? password1, String password2) {
  if (password1 == null) return 'First password is empty';
  password1 = password1.trim();
  password2 = password2.trim();
  if (password1 != password2) {
    return 'Passwords must be same';
  } else {
    return '';
  }
}
