library hash_code_utils;

int safeHashCode(dynamic object) => object == null ? 0 : object.hashCode;
