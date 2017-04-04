String formatYYYYdashMMdashDD(DateTime dateTime) {
  return "${dateTime.year.toString().padLeft(4,'0')}-${dateTime.month.toString().padLeft(2,'0')}-${dateTime.day.toString().padLeft(2,'0')}";
}
