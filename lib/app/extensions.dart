import '../data/mapper/mapper.dart';

// extension on String
extension NonNullString on String? {
  String orEmpty() {
    if (this == null) {
      return EMPTY;
    } else {
      return this!;
    }
  }
}

// extension on Integer
extension NonNullInteger on int? {
  int orZero() {
    if (this == null) {
      return ZERO;
    } else {
      return this!;
    }
  }
}

// extension on Double
extension NonNullDouble on double? {
  double orZeroDouble() {
    if (this == null) {
      return ZERO_DOUBLE;
    } else {
      return this!;
    }
  }
}

// extension on Bool
extension NonNullBool on bool? {
  bool orNullBoolean() {
    if (this == null) {
      return BOOLEAN_FALSE;
    } else {
      return this!;
    }
  }
}