import 'package:ewaste_banksampah/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SampahDidonasikanPage extends StatefulWidget {
  const SampahDidonasikanPage({Key? key}) : super(key: key);

  @override
  _SampahDidonasikanPageState createState() => _SampahDidonasikanPageState();
}

class _SampahDidonasikanPageState extends State<SampahDidonasikanPage> {
  @override
  void initState() {
    _getSampahDidonasikanList();
    _tes();
    super.initState();
  }

  Future<void> _tes() async {
    print(await _getSampahDidonasikanList());
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
    print(id);
    final banksampah_id = await _getBanksampahId();
    await supabase
        .from('sampah_didonasikan')
        .update({'banksampah_id': banksampah_id}).eq('id', id);

    setState(() {});
    if (mounted) context.go('/detailSampahDidonasikan/berangkat/$id	');
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
              FutureBuilder(
                future: _getSampahDidonasikanList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final data = snapshot.data as List;
                    return Column(
                      children: data
                          .map((itemSampahDidonasikan) =>(itemSampahDidonasikan[
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
                                              "Id: ${itemSampahDidonasikan['id'].toString()}"),
                                          Text(itemSampahDidonasikan[
                                              'status_didonasikan']),
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
                                                    '/detailSampahDidonasikan/detail/${itemSampahDidonasikan['id']}');
                                              },
                                              child: const Text('detail')),
                                          const SizedBox(height: 4),
                                          ElevatedButton(
                                            onPressed: () {
                                              _konfirmasi(
                                                  itemSampahDidonasikan['id']);
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
