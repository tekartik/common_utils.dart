import 'dart:math';
import 'map_utils.dart';

T first<T>(Iterable<T> list) => listFirst(list);

T listFirst<T>(Iterable<T> list) {
  return isEmpty(list) ? null : list.first;
}

T listLast<T>(Iterable<T> list) {
  return isEmpty(list) ? null : list.last;
}

int listLength(Iterable list) {
  return list?.length ?? 0;
}

bool isEmpty(Iterable list) => listIsEmpty(list);

bool listIsEmpty(Iterable list) {
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

/**
 * Clone list and list of list
 */
List cloneList(List original) {
  if (original == null) {
    return null;
  }
  List clone = new List();
  original.forEach((item) {
    if (item is List) {
      item = cloneList(item);
    } else if (item is Map) {
      item = cloneMap(item);
    }
    clone.add(item);
  });
  return clone;
}

/**
 * better to have original1 bigger than original2
 * optimization could handle that
 */
List intersectList(List original1, List original2) {
  List list = new List();

  original1.forEach((element) {
    if (original2.contains(element)) {
      list.add(element);
    }
  });

  return list;
}
