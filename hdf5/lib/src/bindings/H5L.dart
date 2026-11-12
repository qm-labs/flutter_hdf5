import 'dart:ffi';
import 'package:ffi/ffi.dart';

import 'package:hdf5/src/bindings/H5.dart';
import 'package:hdf5/src/c_to_dart_calls/utility.dart';
import 'package:hdf5/src/utility/logging.dart';

// H5L_type_t
const int H5L_TYPE_ERROR = -1; //**< Invalid link type id         */
const int H5L_TYPE_HARD = 0; //**< Hard link id                 */
const int H5L_TYPE_SOFT = 1; //**< Soft link id                 */
const int H5L_TYPE_EXTERNAL = 64; //**< External link id             */
const int H5L_TYPE_MAX = 255;

const Map<int, String> H5L_type_t = {
  -1: "H5L_TYPE_ERROR",
  0: "H5L_TYPE_HARD",
  1: "H5L_TYPE_SOFT",
  64: "H5L_TYPE_EXTERNAL",
  225: "H5L_TYPE_MAX"
};

final class H5L_info_t extends Struct {
  @Int32()
  external int type;

  @Bool()
  external bool corder_valid;

  @Int64()
  external int corder;

  @Int64()
  external int cset;

  external H5L_u_t u;
}

final class H5L_u_t extends Union {
  @Array<Uint8>(16)
  external Array<Uint8> token;

  @Int64()
  external int val_size;
}

typedef H5Lget_info_by_idx_c = Int64 Function(
    Int64 loc_id,
    Pointer<Uint8> group_name,
    Int64 ind_type,
    Int64 order,
    Int64 n,
    Pointer<H5L_info_t> linfo,
    Int64 lapl_id);

typedef H5Lget_info_by_idx = int Function(int loc_id, Pointer<Uint8> group_name,
    int ind_type, int order, int n, Pointer<H5L_info_t> linfo, int lapl_id);

typedef H5Lget_name_by_idx_c = Int64 Function(
    Int64 loc_id,
    Pointer<Uint8> group_name,
    Int64 ind_type,
    Int64 order,
    Int64 n,
    Pointer<Pointer<Uint8>> name,
    Int64 size,
    Int64 lapl_id);
typedef H5Lget_name_by_idx = int Function(
    int loc_id,
    Pointer<Uint8> group_name,
    int ind_type,
    int order,
    int n,
    Pointer<Pointer<Uint8>> name,
    int size,
    int lapl_id);

class H5LBindings {
  final H5Lget_info_by_idx __getInfoByIdx;
  final H5Lget_name_by_idx __getNameByIdx;

  final Pointer<Uint8> grp_name = strToChar('.');

  H5LBindings(DynamicLibrary HDF5Lib)
      : __getInfoByIdx = HDF5Lib.lookup<NativeFunction<H5Lget_info_by_idx_c>>(
                'H5Lget_info_by_idx2')
            .asFunction(),
        __getNameByIdx = HDF5Lib.lookup<NativeFunction<H5Lget_name_by_idx_c>>(
                'H5Lget_name_by_idx')
            .asFunction();

  void getInfoByIdx(int loc_id, int index, Pointer<H5L_info_t> linfo) {
    final status = __getInfoByIdx(loc_id, grp_name, H5_INDEX_NAME, H5_ITER_INC,
        index, linfo, H5P_DEFAULT);
    if (status < 0) {
      logger.severe('Failed to get link info by index for location $loc_id');
      throw Exception('Failed to get link info by index');
    }
  }

  String getNameByIdx(int loc_id, int idx) {
    final nameSize = __getNameByIdx(loc_id, grp_name, H5_INDEX_NAME,
        H5_ITER_INC, idx, nullptr, 0, H5P_DEFAULT);
    if (nameSize < 0) {
      logger.severe('Failed to get link name by index for location $loc_id');
      throw Exception('Failed to get link name by index');
    }

    Pointer<Uint8> name = calloc<Uint8>(nameSize + 1);
    Pointer<Pointer<Uint8>> namePtr = Pointer.fromAddress(name.address);

    final status = __getNameByIdx(loc_id, grp_name, H5_INDEX_NAME, H5_ITER_INC,
        idx, namePtr, nameSize + 1, H5P_DEFAULT);
    if (status < 0) {
      logger.severe('Failed to get link name by index for location $loc_id');
      throw Exception('Failed to get link name by index');
    }

    String linkName = charToName(name);
    calloc.free(name);
    return linkName;
  }
}
