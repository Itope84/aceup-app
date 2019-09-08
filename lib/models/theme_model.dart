import 'package:scoped_model/scoped_model.dart';

class ThemeModel extends Model {
  bool _isDark = false;

  bool get isDark => _isDark;

  void toggleDarkness () {
    _isDark = !_isDark;

    notifyListeners();
  }

  void resetDarkness() {
    _isDark = false;
    notifyListeners();
  }
}