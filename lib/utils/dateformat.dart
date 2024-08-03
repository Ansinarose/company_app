String formatMessageTime(DateTime dateTime) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(Duration(days: 1));
  final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

  String formatTimeAmPm(DateTime dt) {
    String hour = (dt.hour % 12 == 0 ? 12 : dt.hour % 12).toString().padLeft(2, '0');
    String minute = dt.minute.toString().padLeft(2, '0');
    String amPm = dt.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $amPm';
  }

  if (messageDate == today) {
    return "Today ${formatTimeAmPm(dateTime)}";
  } else if (messageDate == yesterday) {
    return "Yesterday ${formatTimeAmPm(dateTime)}";
  } else if (now.difference(messageDate).inDays < 7) {
    return "${dateTime.weekday == 1 ? 'Monday' : dateTime.weekday == 2 ? 'Tuesday' : dateTime.weekday == 3 ? 'Wednesday' : dateTime.weekday == 4 ? 'Thursday' : dateTime.weekday == 5 ? 'Friday' : dateTime.weekday == 6 ? 'Saturday' : 'Sunday'} ${formatTimeAmPm(dateTime)}";
  } else {
    return "${dateTime.day}/${dateTime.month}/${dateTime.year} ${formatTimeAmPm(dateTime)}";
  }
}