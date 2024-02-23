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
    final response = await supabase
        .from('sampah_dibuang')
        .select('''
          id,
          status_dibuang,
          banksampah_id,
          profile(
            nama_lengkap
          )
        ''')
        .eq('status_dibuang', "Belum diserahkan")
        .eq('pilihan_antar_jemput', "dijemput");

    return response;
  }

  Future<void> _konfirmasi(num id) async {
    print(id);
    final banksampah_id = await _getBanksampahId();
    await supabase
        .from('sampah_dibuang')
        .update({'banksampah_id': banksampah_id}).eq('id', id);

    setState(() {});
    if (mounted) context.go('/detailSampahDibuang/berangkat/$id	');
  }

  Future<num> _getBanksampahId() async {
    final response = await supabase
        .from('profile_banksampah')
        .select('banksampah_id')
        .eq('user_id', supabase.auth.currentUser!.id)
        .single()
        .limit(1);

    return response['banksampah_id'] as num;
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
                          .map((itemSampahDibuang) => (itemSampahDibuang[
                                      'banksampah_id'] ??
                                  0) > 0  
                              ? Container()
                              : Card(
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
                                                      '/detailSampahDibuang/detail/${itemSampahDibuang['id']}');
                                                },
                                                child: const Text('detail')),
                                            const SizedBox(height: 4),
                                            ElevatedButton(
                                              onPressed: () {
                                                _konfirmasi(
                                                    itemSampahDibuang['id']);
                                              },
                                              child: const Text("Ambil"),
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
