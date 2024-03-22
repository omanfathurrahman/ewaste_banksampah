
import 'package:ewaste_banksampah/main.dart';

Future<String> getUserId() async {
  final response = supabase.auth.currentUser!.id;
  return response;
}

Future<String> getUserFullname() async {
  final userId = supabase.auth.currentUser!.id;
  final res = await supabase.from("profile_droppoin").select('nama').eq("user_id", userId).single().limit(1);
  final response = res['nama'] as String;
  return response;
}

Future<String> getUserEmail() async {
  final response = supabase.auth.currentUser!.email!;
  return response;
}

Future<num> getBanksampahId() async {
    final userId = supabase.auth.currentUser!.id;
  final res = await supabase.from("profile_banksampah").select('banksampah_id').eq("user_id", userId).single().limit(1);
  final banksampahId = res['banksampah_id'] as num;
  return banksampahId;
}

Future<String> getBanksampahName() async {
  final banksampahId = await getBanksampahId();
  final res = await supabase.from("daftar_banksampah").select('nama').eq("id", banksampahId).single().limit(1);
  final namaBanksampah = res['nama'] as String;
  return namaBanksampah;
}




