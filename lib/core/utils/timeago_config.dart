import 'package:timeago/timeago.dart' as timeago;

class TimeagoConfig {
  static void initialize() {
    // Set Vietnamese locale messages
    timeago.setLocaleMessages('vi', timeago.ViMessages());
    
    // Set default locale to Vietnamese
    timeago.setDefaultLocale('vi');
  }
}