import 'package:flutter/foundation.dart';
import 'package:goltens_core/models/auth.dart';

class GlobalState with ChangeNotifier {
  UserResponse? _userResponse;
  bool _isLoading = true;

  UserResponse? get user => _userResponse;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => !isLoading && user != null;

  void setUserResponse(UserResponse? userResponse) {
    _userResponse = userResponse;
    _isLoading = false;
    notifyListeners();
  }
}
