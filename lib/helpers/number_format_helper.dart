import 'package:intl/intl.dart';

String numberWithDot(int number) {
  final numberFormat = NumberFormat('#,##0', 'en_US');

  return numberFormat.format(number);
}
