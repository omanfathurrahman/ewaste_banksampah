import 'package:ewaste_banksampah/main.dart';
// import 'package:ewaste_banksampah/utils/get_berat_total_barang_dibuang.dart';
import 'package:ewaste_banksampah/utils/get_berat_total_barang_didonasikan.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SampahDidonasikanPage extends StatefulWidget {
  const SampahDidonasikanPage({Key? key}) : super(key: key);

  @override
  State<SampahDidonasikanPage> createState() => _SampahDidonasikanPageState();
}

class _SampahDidonasikanPageState extends State<SampahDidonasikanPage> {
  @override
  void initState() {
    _getSampahDidonasikanList();
    super.initState();
  }

  Future<List<Map<String, dynamic>>> _getSampahDidonasikanList() async {
    final response = await supabase
        .from('sampah_didonasikan')
        .select('''
          id,
          status_didonasikan,
          banksampah_id,
          profile(
            nama_lengkap
          )
        ''')
        .eq('status_didonasikan', "Belum diserahkan")
        .eq('pilihan_antar_jemput', "dijemput");

    return response;
  }

  Future<void> _konfirmasi(num id) async {
    final banksampahId = await _getBanksampahId();
    await supabase
        .from('sampah_didonasikan')
        .update({'banksampah_id': banksampahId}).eq('id', id);

    setState(() {});
    if (mounted) context.push('/detailSampahDidonasikan/berangkat/$id	');
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
                future: _getSampahDidonasikanList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  final listSampahDidonasikan = snapshot.data as List;
                  if (listSampahDidonasikan.isEmpty) {
                    return const Text("Tidak ada sampah didonasikan");
                  }
                  return Column(
                    children: listSampahDidonasikan
                        .map((itemSampahDidonasikan) => (itemSampahDidonasikan[
                                        'banksampah_id'] ??
                                    0) >
                                0
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
                                              "Id: ${itemSampahDidonasikan['id'].toString()}"),
                                          Text(itemSampahDidonasikan['profile']
                                              ['nama_lengkap']),
                                          FutureBuilder(
                                            future:
                                                getBeratTotalBarangDidonasikan(
                                                    itemSampahDidonasikan[
                                                        'id']),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return const CircularProgressIndicator();
                                              }
                                              final beratTotal =
                                                  snapshot.data as num;
                                              return Text(
                                                  "Berat: $beratTotal Kg");
                                            },
                                          ),
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
                                                context.push(
                                                    '/detailSampahDidonasikan/detail/${itemSampahDidonasikan['id']}');
                                              },
                                              child: const Text('detail')),
                                          const SizedBox(height: 4),
                                          ElevatedButton(
                                            onPressed: () {
                                              _konfirmasi(
                                                  itemSampahDidonasikan['id']);
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
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
