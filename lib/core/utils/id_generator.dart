import 'package:uuid/uuid.dart';

class IdGenerator {
  IdGenerator._();
  static String generate() => const Uuid().v4();
}
