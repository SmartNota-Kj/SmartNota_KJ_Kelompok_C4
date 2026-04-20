import 'package:intl/intl.dart';

class FormatUtils {
  static final _dateFmt   = DateFormat('d MMM yyyy', 'id_ID');
  static final _dateTimeFmt = DateFormat('d MMM yyyy HH:mm', 'id_ID');

  static String date(DateTime dt) => _dateFmt.format(dt);
  static String dateTime(DateTime dt) => _dateTimeFmt.format(dt);
}
