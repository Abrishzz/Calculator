bool isValidOperation(String expression) {
  return RegExp(r'^-?(\d+|\d+\.\d+)([+\-*/]-?(\d+|\d+\.\d+))*$').hasMatch(expression) &&
         !RegExp(r'/0').hasMatch(expression); 
}
