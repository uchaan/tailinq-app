import 'dart:typed_data';

abstract class StorageRepository {
  Future<String> uploadImage({
    required Uint8List bytes,
    required String fileName,
  });

  Future<void> deleteImage(String path);

  Future<String> getImageUrl(String path);
}
