import 'package:ewaste_banksampah/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailSampahDidonasikanPage extends StatefulWidget {
  const DetailSampahDidonasikanPage(
      {super.key, required this.sampahDidonasikan});
  final num sampahDidonasikan;

  @override
  State<DetailSampahDidonasikanPage> createState() =>
      _DetailSampahDidonasikanPageState();
}

class _DetailSampahDidonasikanPageState
    extends State<DetailSampahDidonasikanPage> {
  late PostgrestFilterBuilder<List<Map<String, dynamic>>>
      detailSampahDidonasikan;

  @override
  void initState() {
    setState(() {
      detailSampahDidonasikan =
          supabase.from('detail_sampah_didonasikan').select('''
      jumlah,
      kategorisasi,
      jenis_elektronik (
        jenis
      )
    ''').eq('id_sampah_didonasikan', widget.sampahDidonasikan);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Sampah Didonasikan'),
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
              "Id Sampah Didonasikan: ${widget.sampahDidonasikan.toString()}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            const Text('Barang-barang yang didonasikan:'),
            SizedBox(
              width: double.infinity,
              child: FutureBuilder(
                future: detailSampahDidonasikan,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  final data = snapshot.data as List;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: data
                        .map((itemDetailSampahDidonasikan) => SizedBox(
                              width: double.infinity,
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'Jumlah: ${itemDetailSampahDidonasikan['jumlah']}'),
                                      if (itemDetailSampahDidonasikan[
                                              'kategorisasi'] !=
                                          null)
                                        Text(
                                            'Jenis: ${itemDetailSampahDidonasikan['kategorisasi']}'),
                                      Text(
                                          'Jenis Elektronik: ${itemDetailSampahDidonasikan['jenis_elektronik']['jenis']}'),
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