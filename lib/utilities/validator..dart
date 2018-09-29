bool isDate(String str) {
  try {
    DateTime.parse(str);
    return true;
  } catch (e) {
    return false;
  }
}

bool isPassword(String pw) {
  return pw.length >= 8 or pw.length <= 30;
}

bool isEmail(String email) {

  String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regExp = new RegExp(p);

  return regExp.hasMatch(email);
}

bool isName(String name){
  RegExp _alpha = new RegExp(r'^[a-zA-Z]+$');
  return _alpha.hasMatch(name);
}
