import 'package:ewaste_banksampah/main.dart';

Future<num> getBeratTotalBarangDidonasikan(int id) async {
  num totalSementara = 0;
  final barangDidonasikanList = await supabase
      .from('detail_sampah_didonasikan')
      .select('id_jenis_elektronik, jumlah, kategorisasi')
      .eq('id_sampah_didonasikan', id);
  for (final item in barangDidonasikanList) {
    final beratItem =
        await _getBeratItem(item['id_jenis_elektronik'], item['kategorisasi']);
    totalSementara += beratItem * item['jumlah'];
  }
  final total = totalSementara;
  return total;
}

Future<num> _getBeratItem(num id, dynamic kategori) async {
  final barangElektronik = await supabase
      .from('jenis_elektronik')
      .select('id, kategorisasi')
      .eq('id', id)
      .single()
      .limit(1);
  final kategorisasiItem = barangElektronik['kategorisasi'] as String;
  if (kategorisasiItem == 'kecil_sedang_besar') {
    final beratItem = await supabase
        .from('kategorisasi_kecilsedangbesar')
        .select(kategori)
        .eq('id_jenis_elektronik', id)
        .single()
        .limit(1);
    return beratItem[kategori] as num;
  } else if (kategorisasiItem == 'pilihan') {
    final beratItem = await supabase
        .from('kategorisasi_pilihan')
        .select('berat')
        .eq('label', kategori)
        .eq('id_jenis_elektronik', id)
        .single()
        .limit(1);
    return beratItem['berat'] as num;
  }
  final beratItem = await supabase
      .from('kategorisasi_none')
      .select('berat')
      .eq('id_jenis_elektronik', id)
      .single()
      .limit(1);
  return beratItem['berat'] as num;
}
