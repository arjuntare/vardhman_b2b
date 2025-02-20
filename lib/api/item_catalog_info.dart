// This file is "main.dart"
import 'package:freezed_annotation/freezed_annotation.dart';

// required: associates our `main.dart` with the code generated by Freezed
part 'item_catalog_info.freezed.dart';
// optional: Since our Person class is serializable, we must add this line.
// But if Person was not serializable, we could skip it.
part 'item_catalog_info.g.dart';

@freezed
class ItemCatalogInfo with _$ItemCatalogInfo {
  const factory ItemCatalogInfo({
    required String article,
    required String uom,
    required String category,
    required String categoryDesc,
    required String subSegment,
    required String subSegmentDesc,
    required String brand,
    required String brandDesc,
    required String substrate,
    required String substrateDesc,
    required String count,
    required String length,
    required String ticket,
    required String tex,
    required String variant,
  }) = _ItemCatalogInfo;

  factory ItemCatalogInfo.fromJson(Map<String, Object?> json) =>
      _$ItemCatalogInfoFromJson(json);
}
