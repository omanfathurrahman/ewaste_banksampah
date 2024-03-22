import 'package:ewaste_banksampah/main.dart';

Future<String> getFullnamePembuangPendonasi(String id) async {
  final fullnamePembuangMap = await supabase.from('profile').select('nama_lengkap').eq('id', id).single().limit(1);
  final fullnamePembuang = fullnamePembuangMap['nama_lengkap'] as String;
  return fullnamePembuang;
}