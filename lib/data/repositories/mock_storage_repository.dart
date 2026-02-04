import 'dart:convert';
import 'dart:typed_data';

import '../../domain/repositories/storage_repository.dart';

class MockStorageRepository implements StorageRepository {
  // In-memory storage for mock images (base64 encoded)
  final Map<String, String> _storage = {};

  @override
  Future<String> uploadImage({
    required Uint8List bytes,
    required String fileName,
  }) async {
    // Mock: Store the image bytes as base64 and return a data URL
    await Future.delayed(const Duration(milliseconds: 300));
    final base64 = base64Encode(bytes);
    final dataUrl = 'data:image/jpeg;base64,$base64';
    _storage[fileName] = dataUrl;
    return dataUrl;
  }

  @override
  Future<void> deleteImage(String path) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _storage.remove(path);
  }

  @override
  Future<String> getImageUrl(String path) async {
    return _storage[path] ?? path;
  }
}
