import 'package:aceup/models/learn_model.dart';
import 'package:aceup/models/quiz_model.dart';
import 'package:aceup/models/theme_model.dart';
import 'package:aceup/models/top_level_data_model.dart';
import 'package:scoped_model/scoped_model.dart';

class MainModel extends Model with TopLevelDataModel, LearnModel, QuizModel, ThemeModel {
  
}