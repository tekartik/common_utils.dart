const String _columns = "columns";
const String _rows = "rows";
// Compact mode
const String _c = r'$c';
const String _r = r'$r';
const String _v = r'$v';

///
/// Convert to
/// { "columns": ["column1", "column2"],
/// "rows": [["row1_col1", "row1_col2"],["row2_col1", "row2_col2"]]
Map<String, List> packList(Iterable<Map<String, dynamic>> list,
    {String rowsField,
    String columnsField,
    dynamic Function(dynamic value) innerPack}) {
  if (list == null) {
    return null;
  }
  // ignore: prefer_collection_literals
  var columnSet = Set<String>(); //new HashSet<String>();
  // Gather all the columns
  for (Map<String, Object> item in list) {
    columnSet.addAll(item.keys);
  }

  List<String> columns = columnSet.toList();

  // build the rows
  List rows = [];
  for (Map<String, Object> item in list) {
    List row = [];
    for (String column in columns) {
      var value = item[column];
      // Convert inner if needed
      if (innerPack != null && value != null) {
        value = innerPack(value);
      }
      row.add(value);
    }
    rows.add(row);
  }

  Map<String, List> packed = {};
  packed[columnsField ?? _columns] = columns;
  packed[rowsField ?? _rows] = rows;

  return packed;
}

Map<String, dynamic> packItemList<T>(
    List<T> list, Map<String, dynamic> Function(T item) itemToJsonCallback) {
  var unpackedList = <Map<String, dynamic>>[];
  for (var item in list) {
    unpackedList.add(itemToJsonCallback(item));
  }
  return packList(unpackedList);
}

/// Pack map and list in a compact way
dynamic compackAny(dynamic unpacked) {
  if (unpacked is List) {
    var list = unpacked;
    // Pack as list if more than 2 map elements (and only map)
    if (list.length > 1) {
      // all maps
      bool allMap = true;
      for (int i = 0; i < list.length; i++) {
        var item = list[i];
        if (!(item is Map)) {
          allMap = false;
          break;
        }
      }
      if (allMap) {
        return packList(
            list.map((item) => (item as Map)?.cast<String, dynamic>()),
            rowsField: _r,
            columnsField: _c,
            innerPack: compackAny);
      }
    }
    return list.map(compackAny)?.toList();
  } else if (unpacked is Map) {
    var map = unpacked;
    // We are trying to packed something that looks like a pack, mark it
    if (map.keys.contains(_r) && map.keys.contains(_r)) {
      map = Map<String, dynamic>.from(unpacked);

      unpacked.forEach((key, value) {
        if (key.toString().startsWith(r'$v')) {
          map['\$v$key'] = compackAny(value);
        }
      });
      // Copy _v value to sub $_v$_v value
      // Put at lease one value
      map[_v] = true;
    }

    return map.map((key, value) => MapEntry(key, compackAny(value)));
  }
  return unpacked;
}

bool _isMapCompacked(Map map) {
  var keys = map?.keys;
  return (keys?.length == 2 && keys.contains(_r) && keys.contains(_c));
}

dynamic uncompackAny(dynamic packed) {
  if (packed is Map) {
    var map = packed;
    if (_isMapCompacked(map)) {
      return unpackList(map?.cast<String, dynamic>(),
          rowsField: _r, columnsField: _c, innerUnpack: uncompackAny);
    } else {
      if (map.keys.contains(_r) && map.keys.contains(_r)) {
        // Remove values and copy them again
        map = Map<String, dynamic>.from(map)
          ..removeWhere((key, value) => key?.toString()?.startsWith(_v));

        packed.forEach((key, value) {
          // remove the root for sure, typically set to true

          if (key != _v) {
            if (key.toString().startsWith(_v)) {
              map['${key?.toString()?.substring(2)}'] = uncompackAny(value);
            }
          }
        });
      }
    }
    return map.map((k, v) => MapEntry(k, uncompackAny(v)));
  } else if (packed is List) {
    var list = packed;
    return list.map((item) => uncompackAny(item)).toList(growable: false);
  }
  return packed;
}

class JsonUnpack {
  Map packed;

  JsonUnpack(this.packed);

  void forEach(callback(Map item)) {
    if (packed == null) {
      return null;
    }

    List<String> columns = packed[_columns] as List<String>;
    List<List> rows = packed[_rows] as List<List>;
    if (columns == null || rows == null) {
      return null;
    }

    int columnCount = columns.length;

    for (List row in rows) {
      Map<String, Object> item = {};
      for (int i = 0; i < columnCount; i++) {
        var value = row[i];
        if (value != null) {
          item[columns[i]] = value;
        }
      }
      callback(item);
    }
  }
}

///
/// Convert to
/// { "columns": ["column1", "column2"],
/// "rows": [["row1_col1", "row1_col2"],["row2_col1", "row2_col2"]]
List<Map<String, dynamic>> unpackList(Map<String, dynamic> packed,
    {String rowsField,
    String columnsField,
    dynamic Function(dynamic value) innerUnpack}) {
  if (packed == null) {
    return null;
  }

  List<String> columns =
      (packed[columnsField ?? _columns] as List)?.cast<String>();
  List<List> rows = (packed[rowsField ?? _rows] as List)?.cast<List>();
  if (columns == null || rows == null) {
    return null;
  }

  int columnCount = columns.length;

  List<Map<String, Object>> items = [];
  for (List row in rows) {
    Map<String, dynamic> item = {};
    for (int i = 0; i < columnCount; i++) {
      var value = row[i];
      if (value != null) {
        if (innerUnpack != null) {
          value = innerUnpack(value);
        }
        item[columns[i]] = value;
      }
    }
    items.add(item);
  }

  return items;
}
