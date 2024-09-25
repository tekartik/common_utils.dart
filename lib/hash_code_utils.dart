library;

/// Safe hashCode for null object
int safeHashCode(Object? object) => object == null ? 0 : object.hashCode;
