import 'dart:math';

T first<T>(List<T> list) {
  return isEmpty(list) ? null : list[0];
}

bool isEmpty(List list) {
  return list == null || list.length == 0;
}

List<T> truncate<T>(List<T> list, int maxCount) {
  if (isEmpty(list)) {
    return list;
  }
  if (maxCount < 0) {
    maxCount = 0;
  }
  maxCount = min(maxCount, list.length);
  return list.sublist(0, maxCount);
}
