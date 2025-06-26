import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  final SupabaseClient _client = Supabase.instance.client;

  // Upload receipt image
  Future<String> uploadReceipt({
    required String userId,
    required String filePath,
    required String fileName,
  }) async {
    final fileBytes = await Supabase.instance.storage
        .from('receipts')
        .uploadBinary(
          '$userId/$fileName',
          await Supabase.instance.storage
              .from('receipts')
              .upload(
                '$userId/$fileName',
                filePath,
                fileOptions: const FileOptions(
                  upsert: true,
                  contentType: 'image/jpeg',
                ),
              ),
        );

    return getReceiptUrl(userId: userId, fileName: fileName);
  }

  // Get receipt download URL
  String getReceiptUrl({required String userId, required String fileName}) {
    return _client.storage.from('receipts').getPublicUrl('$userId/$fileName');
  }

  // Delete receipt
  Future<void> deleteReceipt({
    required String userId,
    required String fileName,
  }) async {
    await _client.storage.from('receipts').remove(['$userId/$fileName']);
  }

  // List all receipts for a user
  Future<List<String>> listUserReceipts(String userId) async {
    final response = await _client.storage.from('receipts').list(path: userId);

    return response.map((file) => file.name).toList();
  }

  // Upload profile picture
  Future<String> uploadProfilePicture({
    required String userId,
    required String filePath,
  }) async {
    await _client.storage
        .from('profile_pictures')
        .upload(
          '$userId/avatar.jpg',
          filePath,
          fileOptions: const FileOptions(
            upsert: true,
            contentType: 'image/jpeg',
          ),
        );

    return getProfilePictureUrl(userId: userId);
  }

  // Get profile picture URL
  String getProfilePictureUrl({required String userId}) {
    return _client.storage
        .from('profile_pictures')
        .getPublicUrl('$userId/avatar.jpg');
  }
}
