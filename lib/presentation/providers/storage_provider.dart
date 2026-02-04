import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/mock_storage_repository.dart';
import '../../domain/repositories/storage_repository.dart';

final storageRepositoryProvider = Provider<StorageRepository>((ref) {
  return MockStorageRepository();
});
