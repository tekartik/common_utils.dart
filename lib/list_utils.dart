T first<T>(List<T> list) {
  return isEmpty(list) ? null : list[0];
}

bool isEmpty(List list) {
  return list == null || list.length == 0;
}
