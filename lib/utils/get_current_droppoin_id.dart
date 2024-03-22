import 'package:ewaste_banksampah/main.dart';

Future<num> getCurrentBanksampahId() async {
  final user = supabase.auth.currentUser;
  final userEmail = user?.email;
  final userBanksampahId = (await supabase.from('profile_banksampah').select('banksampah_id').eq('email', userEmail!).single().limit(1))['banksampah_id'] as num;
  return userBanksampahId;
}