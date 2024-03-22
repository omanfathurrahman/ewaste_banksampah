import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';


String formatDateTime(String dateTimeString) {
  DateTime dateTime = DateTime.parse(dateTimeString);

    // Initialize locale data
  initializeDateFormatting('id', null);

  // Format tanggal dalam format yang diinginkan
  String formattedDateTime = DateFormat('HH:mm, dd MMMM yyyy', 'id').format(dateTime);
  return formattedDateTime;
}