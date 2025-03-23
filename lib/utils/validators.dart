String? validateEmail(String? email) {
  if (email == null || email.isEmpty) {
    return 'Email is required';
  } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
      .hasMatch(email)) {
    return 'Invalid email address';
  }
  return null;
}

String? validatePassword(String? password) {
  if (password == null || password.isEmpty) {
    return 'Password is required';
  } else if (password.length < 6) {
    return 'Password must be at least 6 characters long';
  }
  return null;
}

String? validateInput(String? input) {
  if (input == null || input.isEmpty) {
    return 'this is required';
  } else {
    return null;
  }
}

String? validateAge(String? age) {
  if (age!.isEmpty) {
    return "age req";
  }
  if (int.tryParse(age)! < 3 || int.tryParse(age)! > 18) {
    return "age range";
  }
  return null;
}
String? validatePhone(String? phone){
  if (phone == null || phone.isEmpty) {
    return 'req';
  } else if (!RegExp(r'^[0-9]{8}$')
      .hasMatch(phone)) {
    return 'Invalid';
  }
  return null;
}

