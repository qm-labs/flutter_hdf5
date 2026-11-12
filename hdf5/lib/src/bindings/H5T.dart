import 'dart:ffi';
import 'package:hdf5/src/bindings/H5.dart';

import 'package:hdf5/src/c_to_dart_calls/utility.dart';
import 'package:hdf5/src/utility/enum_utils.dart';
import 'package:hdf5/src/utility/logging.dart';

enum H5T_class_t implements IndexEnum<H5T_class_t>{
  NO_CLASS(-1, "No Class"),
  INTEGER(0, "Integer"),
  FLOAT(1, "Float"),
  TIME(2, "Time"),
  STRING(3, "String"),
  BITFIELD(4, "Bitfield"),
  OPAQUE(5, "Opaque"),
  COMPOUND(6, "Compound"),
  REFERENCE(7, "Reference"),
  ENUM(8, "Enum"),
  VLEN(9, "Vlen"),
  ARRAY(10, "Array");

  final int value;
  final String string;
  const H5T_class_t(this.value, this.string);

  @override
  toString() => string;

  static H5T_class_t fromIdx(int value) => IndexEnum.fromIdx(H5T_class_t.values, value);
}

enum BaseType{
  Char,
  UChar,
  Int8,
  Int16,
  Int32,
  Int64,
  Uint8,
  Uint16,
  Uint32,
  Uint64,
  Float16,
  Float32,
  Float64,
  Binary8,
  Binary16,
  Binary32,
  Binary64;

  @override
  toString() => name;
}

enum H5T_cset_t implements IndexEnum<H5T_cset_t>{
  ERROR(-1, "Error"),
  ASCII(0, "ASCII"),
  UTF8(1, "UTF-8"),
  RESERVED_2(2, "Reserved 2"),
  RESERVED_3(3, "Reserved 3"),
  RESERVED_4(4, "Reserved 4"),
  RESERVED_5(5, "Reserved 5"),
  RESERVED_6(6, "Reserved 6"),
  RESERVED_7(7, "Reserved 7"),
  RESERVED_8(8, "Reserved 8"),
  RESERVED_9(9, "Reserved 9"),
  RESERVED_10(10, "Reserved 10"),
  RESERVED_11(11, "Reserved 11"),
  RESERVED_12(12, "Reserved 12"),
  RESERVED_13(13, "Reserved 13"),
  RESERVED_14(14, "Reserved 14"),
  RESERVED_15(15, "Reserved 15");

  final int value;
  final String string;
  const H5T_cset_t(this.value, this.string);

  @override
  toString() => string;

  static H5T_cset_t fromIdx(int value) => IndexEnum.fromIdx(H5T_cset_t.values, value);
}
final class hvl_t extends Struct {
  @Size()
  external int len; /* Length of VL data (in base type units) */

  external Pointer<Void> p; /* Pointer to VL data */
}

// typedef enum H5T_direction_t
const int H5T_DIR_DEFAULT = 0;
const int H5T_DIR_ASCEND = 1;
const int H5T_DIR_DESCEND = 2;

typedef H5Tclose_c = Int64 Function(Int64 type_id);
typedef H5Tclose = int Function(int type_id);

typedef H5Tget_class_c = Int64 Function(Int64 type_id);
typedef H5Tget_class = int Function(int type_id);

typedef H5Tget_super_c = Int64 Function(Int64 type_id);
typedef H5Tget_super = int Function(int type_id);

typedef H5Tdetect_class_c = Int64 Function(Int64 type_id, Int64 cls);
typedef H5Tdetect_class = int Function(int type_id, int cls);

typedef H5Tget_size_c = Int64 Function(Int64 type_id);
typedef H5Tget_size = int Function(int type_id);

typedef H5Tis_variable_str_c = Int64 Function(Int64 type_id);
typedef H5Tis_variable_str = int Function(int type_id);

typedef H5Tget_cset_c = Int64 Function(Int64 type_id);
typedef H5Tget_cset = int Function(int type_id);

typedef H5Tget_native_type_c = Int64 Function(Int64 type_id, Int64 direction);
typedef H5Tget_native_type = int Function(int type_id, int direction);

typedef H5Tequal_c = Int64 Function(Int64 type_id1, Int64 type_id2);
typedef H5Tequal = int Function(int type_id1, int type_id2);

typedef H5Tget_nmembers_c = Int64 Function(Int64 type_id);
typedef H5Tget_nmembers = int Function(int type_id);

typedef H5Tget_member_type_c = Int64 Function(Int64 type_id, Uint64 membno);
typedef H5Tget_member_type = int Function(int type_id, int membno);

typedef H5Tget_member_class_c = Int64 Function(Int64 type_id, Uint64 membno);
typedef H5Tget_member_class = int Function(int type_id, int membno);

typedef H5Tget_member_offset_c = Int64 Function(Int64 type_id, Uint64 membno);
typedef H5Tget_member_offset = int Function(int type_id, int membno);

typedef H5Tget_member_name_c = Pointer<Uint8> Function(
    Int64 type_id, Int64 membno);
typedef H5Tget_member_name = Pointer<Uint8> Function(int type_id, int membno);

typedef H5Tget_member_value_c = Int64 Function(
    Int64 type_id, Uint64 membno, Pointer value);
typedef H5Tget_member_value = int Function(
    int type_id, int membno, Pointer value);

typedef H5Treclaim_c = Int64 Function(
    Int64 type_id, Int64 space_id, Int64 plist_id, Pointer buf);
typedef H5Treclaim = int Function(
    int type_id, int space_id, int plist_id, Pointer buf);

class H5TBindings {
  final H5Tclose __close;
  final H5Tget_class __getClass;
  final H5Tget_super __getSuper;
  final H5Tdetect_class __detectClass;
  final H5Tget_size __getSize;
  final H5Tis_variable_str __isVariableStr;
  final H5Tget_cset __getCSet;
  final H5Tget_native_type __getNativeType;
  final H5Tequal __equalType;
  final H5Tget_nmembers __getNMembers;
  final H5Tget_member_type __getMemberType;
  final H5Tget_member_class __getMemberClass;
  final H5Tget_member_offset __getMemberOffset;
  final H5Tget_member_name __getMemberName;
  final H5Tget_member_value __getMemberValue;
  final H5Treclaim __reclaim;

  final H5free_memory __freeMemory;

  final int H5T_NATIVE_CHAR;
  final int H5T_NATIVE_SHORT;
  final int H5T_NATIVE_INT;
  final int H5T_NATIVE_LONG;
  final int H5T_NATIVE_LLONG;
  final int H5T_NATIVE_UCHAR;
  final int H5T_NATIVE_USHORT;
  final int H5T_NATIVE_UINT;
  final int H5T_NATIVE_ULONG;
  final int H5T_NATIVE_ULLONG;
  final int H5T_NATIVE_FLOAT;
  final int H5T_NATIVE_DOUBLE;
  final int H5T_NATIVE_LDOUBLE;
  final int H5T_NATIVE_B8;
  final int H5T_NATIVE_B16;
  final int H5T_NATIVE_B32;
  final int H5T_NATIVE_B64;

  H5TBindings(DynamicLibrary HDF5Lib)
      : __close =
            HDF5Lib.lookup<NativeFunction<H5Tclose_c>>('H5Tclose').asFunction(),
        __getClass =
            HDF5Lib.lookup<NativeFunction<H5Tget_class_c>>('H5Tget_class')
                .asFunction(),
        __getSuper =
            HDF5Lib.lookup<NativeFunction<H5Tget_super_c>>('H5Tget_super')
                .asFunction(),
        __detectClass =
            HDF5Lib.lookup<NativeFunction<H5Tdetect_class_c>>('H5Tdetect_class')
                .asFunction(),
        __getSize = HDF5Lib.lookup<NativeFunction<H5Tget_size_c>>('H5Tget_size')
            .asFunction(),
        __isVariableStr = HDF5Lib.lookup<NativeFunction<H5Tis_variable_str_c>>(
                'H5Tis_variable_str')
            .asFunction(),
        __getCSet = HDF5Lib.lookup<NativeFunction<H5Tget_cset_c>>(
                'H5Tget_cset')
            .asFunction(),
        __getNativeType = HDF5Lib.lookup<NativeFunction<H5Tget_native_type_c>>(
                'H5Tget_native_type')
            .asFunction(),
        __equalType =
            HDF5Lib.lookup<NativeFunction<H5Tequal_c>>('H5Tequal').asFunction(),
        __getNMembers =
            HDF5Lib.lookup<NativeFunction<H5Tget_nmembers_c>>('H5Tget_nmembers')
                .asFunction(),
        __getMemberType = HDF5Lib.lookup<NativeFunction<H5Tget_member_type_c>>(
                'H5Tget_member_type')
            .asFunction(),
        __getMemberClass =
            HDF5Lib.lookup<NativeFunction<H5Tget_member_class_c>>(
                    'H5Tget_member_class')
                .asFunction(),
        __getMemberOffset =
            HDF5Lib.lookup<NativeFunction<H5Tget_member_offset_c>>(
                    'H5Tget_member_offset')
                .asFunction(),
        __getMemberName = HDF5Lib.lookup<NativeFunction<H5Tget_member_name_c>>(
                'H5Tget_member_name')
            .asFunction(),
        __getMemberValue =
            HDF5Lib.lookup<NativeFunction<H5Tget_member_value_c>>(
                    'H5Tget_member_value')
                .asFunction(),
        __reclaim = HDF5Lib.lookup<NativeFunction<H5Treclaim_c>>('H5Treclaim')
            .asFunction(),
        __freeMemory =
            HDF5Lib.lookup<NativeFunction<H5free_memory_c>>('H5free_memory')
                .asFunction(),
        
        H5T_NATIVE_CHAR = HDF5Lib.lookup<Int64>('H5T_NATIVE_SCHAR_g').value,
        H5T_NATIVE_SHORT = HDF5Lib.lookup<Int64>('H5T_NATIVE_UCHAR_g').value,
        H5T_NATIVE_INT = HDF5Lib.lookup<Int64>('H5T_NATIVE_INT_g').value,
        H5T_NATIVE_LONG = HDF5Lib.lookup<Int64>('H5T_NATIVE_LONG_g').value,
        H5T_NATIVE_LLONG = HDF5Lib.lookup<Int64>('H5T_NATIVE_LLONG_g').value,
        H5T_NATIVE_UCHAR = HDF5Lib.lookup<Int64>('H5T_NATIVE_UCHAR_g').value,
        H5T_NATIVE_USHORT = HDF5Lib.lookup<Int64>('H5T_NATIVE_USHORT_g').value,
        H5T_NATIVE_UINT = HDF5Lib.lookup<Int64>('H5T_NATIVE_UINT_g').value,
        H5T_NATIVE_ULONG = HDF5Lib.lookup<Int64>('H5T_NATIVE_ULONG_g').value,
        H5T_NATIVE_ULLONG = HDF5Lib.lookup<Int64>('H5T_NATIVE_ULLONG_g').value,
        H5T_NATIVE_FLOAT = HDF5Lib.lookup<Int64>('H5T_NATIVE_FLOAT_g').value,
        H5T_NATIVE_DOUBLE = HDF5Lib.lookup<Int64>('H5T_NATIVE_DOUBLE_g').value,
        H5T_NATIVE_LDOUBLE = HDF5Lib.lookup<Int64>('H5T_NATIVE_LDOUBLE_g').value,
        H5T_NATIVE_B8 = HDF5Lib.lookup<Int64>('H5T_NATIVE_B8_g').value,
        H5T_NATIVE_B16 = HDF5Lib.lookup<Int64>('H5T_NATIVE_B16_g').value,
        H5T_NATIVE_B32 = HDF5Lib.lookup<Int64>('H5T_NATIVE_B32_g').value,
        H5T_NATIVE_B64 = HDF5Lib.lookup<Int64>('H5T_NATIVE_B64_g').value;

  void close(int type_id) {
    final status = __close(type_id);
    if (status < 0) {
      logger.severe('Failed to close datatype');
      throw Exception('Failed to close datatype');
    }
  }

  H5T_class_t getClass(int type_id) {
    final cls = __getClass(type_id);
    if (cls < 0) {
      logger.severe('Failed to get datatype class');
      throw Exception('Failed to get datatype class');
    }
    return H5T_class_t.fromIdx(cls);
  }

  int getSuper(int type_id) {
    final super_id = __getSuper(type_id);
    if (super_id < 0) {
      logger.severe('Failed to get super datatype');
      throw Exception('Failed to get super datatype');
    }
    return super_id;
  }

  int detectClass(int type_id, int cls) {
    final status = __detectClass(type_id, cls);
    if (status < 0) {
      logger.severe('Failed to detect datatype class');
      throw Exception('Failed to detect datatype class');
    }
    return status;
  }

  int getSize(int type_id) {
    final size = __getSize(type_id);
    if (size < 0) {
      logger.severe('Failed to get datatype size');
      throw Exception('Failed to get datatype size');
    }
    return size;
  }

  int isVariableStr(int type_id) {
    final isVarStr = __isVariableStr(type_id);
    if (isVarStr < 0) {
      logger.severe('Failed to check if datatype is variable-length string');
      throw Exception('Failed to check if datatype is variable-length string');
    }
    return isVarStr;
  }

  int getNativeType(int type_id, int direction) {
    final native_type = __getNativeType(type_id, direction);
    if (native_type < 0) {
      logger.severe('Failed to get native datatype');
      throw Exception('Failed to get native datatype');
    }
    return native_type;
  }

  H5T_cset_t getCSet(int type_id) {
    final cset = __getCSet(type_id);
    if (cset < 0) {
      logger.severe('Failed to get character set');
      throw Exception('Failed to get character set');
    }
    return H5T_cset_t.fromIdx(cset);
  }

  int getNMembers(int type_id) {
    final nMembers = __getNMembers(type_id);
    if (nMembers < 0) {
      logger.severe('Failed to get number of members in compound datatype');
      throw Exception('Failed to get number of members in compound datatype');
    }
    return nMembers;
  }

  int getMemberType(int type_id, int membno) {
    final member_type = __getMemberType(type_id, membno);
    if (member_type < 0) {
      logger.severe('Failed to get member datatype');
      throw Exception('Failed to get member datatype');
    }
    return member_type;
  }

  int getMemberClass(int type_id, int membno) {
    final member_class = __getMemberClass(type_id, membno);
    if (member_class < 0) {
      logger.severe('Failed to get member class');
      throw Exception('Failed to get member class');
    }
    return member_class;
  }

  int getMemberOffset(int type_id, int membno) {
    final offset = __getMemberOffset(type_id, membno);
    if (offset < 0) {
      logger.severe('Failed to get member offset');
      throw Exception('Failed to get member offset');
    }
    return offset;
  }

  String getMemberName(int type_id, int membno) {
    Pointer<Uint8> memberNamePtr = __getMemberName(type_id, membno);
    if (memberNamePtr == nullptr) {
      logger.severe('Failed to get member name');
      throw Exception('Failed to get member name');
    }

    String memberName = charToName(memberNamePtr);
    __freeMemory(memberNamePtr);
    return memberName;
  }

  void getMemberValue(int type_id, int membno, Pointer buffer) {
    final status = __getMemberValue(type_id, membno, buffer);
    if (status < 0) {
      logger.severe('Failed to get member value');
      throw Exception('Failed to get member value');
    }
  }

  void reclaim(int type_id, int space_id, int plist_id, Pointer buf) {
    final status = __reclaim(type_id, space_id, plist_id, buf);
    if (status < 0) {
      logger.severe('Failed to reclaim datatype');
      throw Exception('Failed to reclaim datatype');
    }
  }

  bool equalType(int type_id1, int type_id2) {
    final equal = __equalType(type_id1, type_id2);
    if (equal < 0) {
      logger.severe('Failed to check if datatypes are equal');
      throw Exception('Failed to check if datatypes are equal');
    }
    return equal == 1;
  }

  BaseType getBaseTypeFromNativeType(int nativeType, int size) {
    if (equalType(H5T_NATIVE_CHAR, nativeType)) {
      return BaseType.Char;
    } else if (equalType(H5T_NATIVE_UCHAR, nativeType)) {
      return BaseType.UChar;
    } else if (equalType(H5T_NATIVE_INT, nativeType) ||
                equalType(H5T_NATIVE_SHORT, nativeType) ||
                equalType(H5T_NATIVE_LONG, nativeType) ||
                equalType(H5T_NATIVE_LLONG, nativeType)) {
        switch (size){
          case 1:
            return BaseType.Int8;
          case 2:
            return BaseType.Int16;
          case 4:
            return BaseType.Int32;
          case 8:
            return BaseType.Int64;
          default:
            throw Exception('Unknown size for integer type');
        }
    } else if (equalType(H5T_NATIVE_UINT, nativeType) ||
                equalType(H5T_NATIVE_USHORT, nativeType) ||
                equalType(H5T_NATIVE_ULONG, nativeType) ||
                equalType(H5T_NATIVE_ULLONG, nativeType)) {
        switch (size){
          case 1:
            return BaseType.Uint8;
          case 2:
            return BaseType.Uint16;
          case 8:
            return BaseType.Uint32;
          case 8:
            return BaseType.Uint64;
          default:
            throw Exception('Unknown size for unsigned integer type');
        }
    } else if (equalType(H5T_NATIVE_DOUBLE, nativeType) ||
                equalType(H5T_NATIVE_LDOUBLE, nativeType)) {
      return BaseType.Float64;
    } else if (equalType(H5T_NATIVE_FLOAT, nativeType)) {
        switch (size){
          case 2:
            return BaseType.Float16;
          case 4:
            return BaseType.Float32;
          default:
            throw Exception('Unknown size for float type');
        }
    } else if (equalType(H5T_NATIVE_B8, nativeType)) {
      return BaseType.Binary8;
    } else if (equalType(H5T_NATIVE_B16, nativeType)) {
      return BaseType.Binary16;
    } else if (equalType(H5T_NATIVE_B32, nativeType)) {
      return BaseType.Binary32;
    } else if (equalType(H5T_NATIVE_B64, nativeType)) {
      return BaseType.Binary64;
    } else {
      throw Exception('Unknown native type');
    }
  }
}
