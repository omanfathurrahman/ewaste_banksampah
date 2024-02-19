import 'package:ewaste_banksampah/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SampahDibuangPage extends StatefulWidget {
  const SampahDibuangPage({Key? key}) : super(key: key);

  @override
  _SampahDibuangPageState createState() => _SampahDibuangPageState();
}

class _SampahDibuangPageState extends State<SampahDibuangPage> {

  @override
  void initState() {
    _getSampahDibuangList();
    _tes();
    super.initState();
  }

  Future<void> _tes() async {
    print(await _getSampahDibuangList());
  }

  Future<List<Map<String, dynamic>>> _getSampahDibuangList() async {
    final droppoinId = await _getDroppoinId();
    final response = await supabase
      .from('sampah_dibuang')
      .select('''
    id,
    status_dibuang,
    profile(
      nama_lengkap
    )
    ''')
      .eq('status_dibuang', "Belum diserahkan")
      .eq('pilihan_antar_jemput', "diantar")
      .eq("droppoin_id", droppoinId);

    return response;
  }

  Future<num> _getDroppoinId() async {
    final response = await supabase
        .from('profile_droppoin')
        .select('id')
        .eq('email', supabase.auth.currentUser!.email!)
        .single()
        .limit(1);
    return response['id'];
  }

  Future<void> _konfirmasi(num id) async {
    await supabase
        .from('sampah_dibuang')
        .update({'status_dibuang': 'Sudah diserahkan'}).eq('id', id);

  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children: [
          Column(
            children: [
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _getSampahDibuangList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final listSampahDibuang = snapshot.data as List;
                    return Column(
                      children: listSampahDibuang
                          .map((itemSampahDibuang) => Card(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              "Id: ${itemSampahDibuang['id'].toString()}"),
                                          Text(itemSampahDibuang['profile']
                                              ['nama_lengkap']),
                                          const Text("Sampah belum diterima"),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.orange[500]),
                                              onPressed: () {
                                                context.go(
                                                    '/detailSampahDibuang/${itemSampahDibuang['id']}');
                                              },
                                              child: const Text('detail')),
                                          const SizedBox(height: 4),
                                          ElevatedButton(
                                            onPressed: () {
                                              _konfirmasi(
                                                  itemSampahDibuang['id']);
                                            },
                                            child: const Text("selesai"),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ))
                          .toList(),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
