import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // User Profile Methods
  Future<Map<String, dynamic>> getProfile(String userId) async {
    return await _client.from('profiles').select().eq('id', userId).single();
  }

  // Savings Plan Methods
  Future<List<Map<String, dynamic>>> getUserSavingsPlans(String userId) async {
    return await _client
        .from('savings_plans')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
  }

  // Transaction Methods
  Future<List<Map<String, dynamic>>> getSavingsPlanTransactions(
    String planId,
  ) async {
    return await _client
        .from('transactions')
        .select()
        .eq('savings_plan_id', planId)
        .order('transaction_date', ascending: false);
  }
}
