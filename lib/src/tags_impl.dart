import 'package:meta/meta.dart';
import 'package:tekartik_common_utils/list_utils.dart';
import 'package:tekartik_common_utils/string_utils.dart';

/// Tags are a list or trimmed string.
abstract class Tags {
  /// Tags from a list of strings.
  factory Tags.fromList(List<String>? tags) {
    return _Tags(tags);
  }

  /// Tags from a string (tags are comma separated).
  factory Tags.fromText(String? text) {
    if (text == null) {
      return _Tags(null);
    } else {
      return _Tags(text.split(',').map((String tag) => tag.trim()).toList());
    }
  }

  /// Empty tag list
  factory Tags() => Tags.fromList(null);

  /// Tags as a list of strings.
  List<String> toList();

  List<String> get _tags;
}

/// Tags extension.
extension TagsExt on Tags {
  /// Tags as a string (tags are comma separated).
  String toText() {
    return _tags.join(',');
  }

  /// Tags as a string (tags are comma separated) or null if empty.
  String? toTextOrNull() => toText().nonEmpty();

  /// Tags as a list of strings or null if empty.
  List<String>? toListOrNull() => _tags.nonEmpty();

  /// Check if the tags contain a given tag.
  bool has(String tag) {
    return _tags.contains(tag);
  }

  /// Add a tag if not already present, return true if added.
  bool add(String tag) {
    if (has(tag)) {
      return false;
    }
    _tags.add(tag);
    return true;
  }

  /// Remove a tag if present, return true if removed.
  bool remove(String tag) {
    return _tags.remove(tag);
  }

  /// Sort the tags
  void sort() {
    _tags.sort();
  }
}

class _Tags implements Tags {
  @override
  final List<String> _tags;

  _Tags(List<String>? tags) : _tags = List.of(tags ?? <String>[]);

  @override
  List<String> toList() => _tags;

  @override
  String toString() => 'Tags(${toText()})';
}

/// Tags condition (tag1 && tag2 && !tag3 || tag4 && (tag1 && tag4).
abstract class TagsCondition {
  /// Parse a tags condition.
  ///
  /// Don't assume precedence, use parenthesis, don't mix && and || without parenthesis.
  ///
  /// empty expression means always true
  factory TagsCondition(String expression) {
    expression = expression.trim();
    if (expression.isEmpty) {
      return _TagsConditionAlwaysTrue();
    }
    return _parseTagsCondition(expression.trim());
  }

  /// Check if the tags match the condition.
  bool check(Tags tags);

  /// Text representation of the condition.
  String toText();

  /// Private
  String _toInnerText();

  factory TagsCondition._or(
      TagsCondition condition1, TagsCondition condition2) {
    if (condition2 is _TagsConditionAny) {
      return _TagsConditionAny([condition1, ...condition2.conditions]);
    } else if (condition1 is _TagsConditionAny) {
      return _TagsConditionAny([...condition1.conditions, condition1]);
    } else if (condition1 is _TagsConditionAll ||
        condition2 is _TagsConditionAll) {
      throw ArgumentError(
          'You cannot mixed || and && operator without parenthesis');
    }
    return _TagsConditionAny([condition1, condition2]);
  }
  factory TagsCondition._and(
      TagsCondition condition1, TagsCondition condition2) {
    if (condition2 is _TagsConditionAll) {
      return _TagsConditionAll([condition1, ...condition2.conditions]);
    } else if (condition1 is _TagsConditionAll) {
      return _TagsConditionAll([...condition1.conditions, condition1]);
    } else if (condition1 is _TagsConditionAny ||
        condition2 is _TagsConditionAny) {
      throw ArgumentError(
          'You cannot mixed && and || operator without parenthesis');
    }
    return _TagsConditionAll([condition1, condition2]);
  }
}

/// A condition is either single or multi
@visibleForTesting
abstract class TagsConditionSingle implements TagsConditionSealed {}

/// A condition is either single or multi
@visibleForTesting
abstract interface class TagsConditionMulti implements TagsCondition {}

/// A sealed condition
@visibleForTesting
abstract interface class TagsConditionSealed implements TagsCondition {}

mixin _TagsConditionMixin implements TagsCondition {
  @override
  String toString() => 'Condition(${toText()})';
}

class _TagsConditionAlwaysTrue
    with _TagsConditionMixin
    implements TagsCondition {
  @override
  bool check(Tags tags) => true;

  @override
  String toText() => _toInnerText();

  @override
  String _toInnerText() => '';
}

class _TagsConditionTag
    with _TagsConditionMixin
    implements TagsConditionSingle {
  final String tag;

  _TagsConditionTag(this.tag);

  @override
  bool check(Tags tags) {
    return tags.has(tag);
  }

  @override
  String toText() => tag;

  @override
  String _toInnerText() => tag;
}

abstract class _TagsConditionSingleBase
    with _TagsConditionMixin
    implements TagsConditionSingle {
  final TagsCondition condition;

  _TagsConditionSingleBase(this.condition);

  @override
  String toText() => _toInnerText();

  @override
  String _toInnerText() => condition._toInnerText();
}

abstract class _TagsConditionMultiBase
    with _TagsConditionMixin
    implements TagsConditionMulti {
  List<TagsCondition> conditions;

  _TagsConditionMultiBase(this.conditions);

  List<String> conditionTexts() =>
      conditions.map((condition) => condition._toInnerText()).toList();

  @override
  String _toInnerText() => '(${toText()})';
}

class _TagsConditionAny extends _TagsConditionMultiBase {
  _TagsConditionAny(super.conditions);

  @override
  bool check(Tags tags) {
    for (var condition in conditions.toList()) {
      if (condition.check(tags)) {
        return true;
      }
    }
    return false;
  }

  @override
  String toText() => conditionTexts().join(' || ');
}

class _TagsConditionAll extends _TagsConditionMultiBase {
  _TagsConditionAll(super.conditions);

  @override
  bool check(Tags tags) {
    for (var condition in conditions.toList()) {
      if (!condition.check(tags)) {
        return false;
      }
    }
    return true;
  }

  @override
  String toText() {
    var conditionTexts = this.conditionTexts();
    return conditionTexts.join(' && ');
  }
}

class _TagConditionSealed
    with _TagsConditionMixin
    implements TagsConditionSealed {
  final TagsCondition condition;

  _TagConditionSealed(this.condition);

  @override
  String _toInnerText() => condition._toInnerText();

  @override
  bool check(Tags tags) => condition.check(tags);

  @override
  String toText() => condition.toText();
}

class _TagsConditionNot extends _TagsConditionSingleBase {
  _TagsConditionNot(super.condition);

  @override
  bool check(Tags tags) {
    return !condition.check(tags);
  }

  @override
  String _toInnerText() => '!${condition._toInnerText()}';
}

/// Find macthing end parentheses
int findMatchingEndParenthesis(String expression, int startIndex) {
  var index = startIndex;
  var count = 1;
  while (index < expression.length) {
    var chr = expression[index];
    if (chr == '(') {
      count++;
    } else if (chr == ')') {
      count--;
      if (count == 0) {
        return index;
      }
    }
    index++;
  }
  return -1;
}

const _or = '||';
const _and = '&&';
var _allOperators = [_or, _and];

/// Assumed trimmed
TagsCondition _parseTagsCondition(String expression) {
  var parts = expression.splitFirst(' ');
  var token = parts.first;
  var firstChar = token[0];

  var not = firstChar == '!';

  TagsCondition wrapCondition(TagsCondition condition) {
    if (not) {
      return _TagsConditionNot(condition);
    }
    return condition;
  }

  if (not) {
    token = token.substring(1);
    expression = expression.substring(1);
    firstChar = token[0];
  }
  if (token.isEmpty) {
    throw ArgumentError('Missing tag or expression after ! in "$expression"');
  }
  late TagsCondition firstCondition;
  late String afterFirstCondition;
  if (firstChar == '(') {
    var endIndex = findMatchingEndParenthesis(expression, 1);
    if (endIndex == -1) {
      throw ArgumentError('Missing matching ) in "$expression"');
    }
    firstCondition = _TagConditionSealed(
        _parseTagsCondition(expression.substring(1, endIndex).trim()));
    afterFirstCondition = expression.substring(endIndex + 1).trim();
  } else if (_allOperators.contains(token)) {
    throw ArgumentError('Unexpected operator "$token" found in "$expression"');
  } else {
    firstCondition = _TagsConditionTag(token);
    if (parts.length == 1) {
      return wrapCondition(firstCondition);
    }
    afterFirstCondition = parts.last.trim();
  }

  if (afterFirstCondition.isEmpty) {
    return wrapCondition(firstCondition);
  }

  /// expect condition
  parts = afterFirstCondition.splitFirst(' ');
  var operator = parts.first;
  var secondCondition = parts.last.trim();

  if (!_allOperators.contains(operator)) {
    throw ArgumentError('Missing operator in "$expression"');
  }
  var subExpression = _parseTagsCondition(secondCondition);
  if (operator == _or) {
    return wrapCondition(TagsCondition._or(firstCondition, subExpression));
  } else if (operator == _and) {
    return wrapCondition(TagsCondition._and(firstCondition, subExpression));
  } else {
    throw ArgumentError('Missing operators token "$operator" in "$expression"');
  }
}
