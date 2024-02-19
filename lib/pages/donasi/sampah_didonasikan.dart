import 'package:ewaste_banksampah/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SampahDidonasikanPage extends StatefulWidget {
  const SampahDidonasikanPage({Key? key}) : super(key: key);

  @override
  _SampahDidonasikanPageState createState() => _SampahDidonasikanPageState();
}

class _SampahDidonasikanPageState extends State<SampahDidonasikanPage> {
  var sampahDidonasikan = supabase.from('sampah_didonasikan').select('''
    id,
    status_didonasikan
    ''').eq('status_didonasikan', "Belum diserahkan");

  Future<void> _konfirmasi(num id) async {
    print(id);
    await supabase
        .from('sampah_didonasikan')
        .update({'status_didonasikan': 'Sudah diserahkan'}).eq('id', id);

    setState(() {
      sampahDidonasikan = supabase.from('sampah_didonasikan').select('''
        id,
        status_didonasikan
        ''').eq('status_didonasikan', "Belum diserahkan");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children: [
          Column(
            children: [
              FutureBuilder(
                future: sampahDidonasikan,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final data = snapshot.data as List;
                    return Column(
                      children: data
                          .map((itemSampahDidonasikan) => Card(
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
                                                    '/detailSampahDibuang/${itemSampahDidonasikan['id']}');
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
