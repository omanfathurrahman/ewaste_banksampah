import 'package:ewaste_banksampah/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailSampahDibuangPage extends StatefulWidget {
  const DetailSampahDibuangPage({super.key, required this.sampahDibuangId});
  final num sampahDibuangId;

  @override
  State<DetailSampahDibuangPage> createState() =>
      _DetailSampahDibuangPageState();
}

class _DetailSampahDibuangPageState extends State<DetailSampahDibuangPage> {
  late PostgrestFilterBuilder<List<Map<String, dynamic>>> detailSampahDibuang;

  @override
  void initState() {
    tes();
    detailSampahDibuang = supabase.from('detail_sampah_dibuang').select('''
      jumlah,
      kategorisasi,
      jenis_elektronik (
        jenis
      )
    ''').eq('id_sampah_dibuang', widget.sampahDibuangId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Sampah Dibuang'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.go('/afterLoginLayout');
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: ListView(children: [
            Text(
              "Id Sampah Dibuang: ${widget.sampahDibuangId.toString()}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            const Text('Barang-barang yang dibuang:'),
            SizedBox(
              width: double.infinity,
              child: FutureBuilder(
                future: detailSampahDibuang,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  final data = snapshot.data as List;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: data
                        .map((itemDetailSampahDibuang) => SizedBox(
                              width: double.infinity,
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'Jumlah: ${itemDetailSampahDibuang['jumlah']}'),
                                      if (itemDetailSampahDibuang[
                                              'kategorisasi'] !=
                                          null)
                                        Text(
                                            'Jenis: ${itemDetailSampahDibuang['kategorisasi']}'),
                                      Text(
                                          'Jenis Elektronik: ${itemDetailSampahDibuang['jenis_elektronik']['jenis']}'),
                                    ],
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  );
                },
              ),
            ),
          ]),
        ));
  }
}

Future<void> tes() async {
  final res = await supabase.from('detail_sampah_dibuang').select('''
  jumlah,
  kategorisasi,
  jenis_elektronik (
    jenis
  )
''').eq('id_sampah_dibuang', 27);
  print(res);
}
