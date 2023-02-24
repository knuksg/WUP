part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const SPLASH = _Paths.SPLASH;
  static const LOGIN = _Paths.LOGIN;
  static const WELCOME = _Paths.WELCOME;
  static const INPUT = _Paths.INPUT;
  static const QUESTION = _Paths.QUESTION;
  static const FLUTTERMOJI = _Paths.FLUTTERMOJI;
  static const RESULT = _Paths.RESULT;
  static const CALENDAR = _Paths.CALENDAR;
  static const PROFILE = _Paths.PROFILE;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const WELCOME = '/welcome';
  static const INPUT = '/input';
  static const QUESTION = '/question';
  static const FLUTTERMOJI = '/fluttermoji';
  static const RESULT = '/result';
  static const CALENDAR = '/calendar';
  static const PROFILE = '/profile';
}
