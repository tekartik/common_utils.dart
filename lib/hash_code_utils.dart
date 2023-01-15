library hash_code_utils;

int safeHashCode(Object? object) => object == null ? 0 : object.hashCode;
