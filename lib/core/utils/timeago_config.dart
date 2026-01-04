import 'package:timeago/timeago.dart' as timeago;

class TimeagoConfig {
  static void initialize() {
    timeago.setLocaleMessages('vi', timeago.ViMessages());
    timeago.setLocaleMessages('en', timeago.EnMessages());
  }
}
