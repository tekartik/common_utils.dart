import 'dart:math';

import 'map_utils.dart';

T first<T>(Iterable<T> list) => listFirst(list);

T listFirst<T>(Iterable<T> list) {
  return listIsEmpty(list) ? null : list.first;
}

T listLast<T>(Iterable<T> list) {
  return listIsEmpty(list) ? null : list.last;
}

int listLength(Iterable list) {
  return list?.length ?? 0;
}

/// Safe way to get a list, never fails
List<T> asList<T>(dynamic value) {
  if (value is List<T>) {
    return value;
  }
  if (value is Iterable) {
    try {
      return value.cast<T>().toList(growable: false);
    } catch (_) {}
  }
  return null;
}

@Deprecated('use listIsEmpty')
bool isEmpty(Iterable list) => listIsEmpty(list);

/// True if list is null or empty
bool listIsEmpty(Iterable list) => listLength(list) == 0;

/// True if list is not null and not
bool listIsNoteEmpty(Iterable list) => listLength(list) > 0;

@Deprecated('use listTruncate')
List<T> truncate<T>(List<T> list, int maxCount) => listTruncate(list, maxCount);

int _listSafeStartOrEnd(List list, int index) {
  if (index < 0) {
    return 0;
  } else if (index > list.length) {
    return list.length;
  }
  return index;
}

/// Safe sub list sub list
List<T> listSubList<T>(List<T> list, int start, [int end]) {
  if (listIsEmpty(list)) {
    return list;
  }
  start = _listSafeStartOrEnd(list, start);
  if (end != null) {
    end = max(_listSafeStartOrEnd(list, end), start);
  }
  return list.sublist(start, end);
}

/// Truncate at max element.
List<T> listTruncate<T>(List<T> list, int len) => listSubList(list, 0, len);

/// Clone list and list of list
List<T> cloneList<T>(List<T> original) {
  if (original == null) {
    return null;
  }
  var clone = <T>[];
  original.forEach((dynamic item) {
    if (item is List) {
      item = cloneList(item as List);
    } else if (item is Map) {
      item = cloneMap(item as Map);
    }
    clone.add(item as T);
  });
  return clone;
}

/// better to have original1 bigger than original2
/// optimization could handle that
List<T> intersectList<T>(List<T> original1, List<T> original2) {
  var list = <T>[];

  original1.forEach((element) {
    if (original2.contains(element)) {
      list.add(element);
    }
  });

  return list;
}

/// Split a list in sub list with a maximum size.
///
/// Never returns list. if list is null, returns an empty list.
/// If [chunkSize] is null or 0, returns all in one list;
List<List<T>> listChunk<T>(List<T> list, int chunkSize) {
  var chunks = <List<T>>[];
  final len = list?.length ?? 0;
  if ((chunkSize ?? 0) == 0) {
    chunkSize = len;
  }
  for (var i = 0; i < len; i += chunkSize) {
    final size = i + chunkSize;
    chunks.add(list.sublist(i, size > len ? len : size));
  }

  return chunks;
}
