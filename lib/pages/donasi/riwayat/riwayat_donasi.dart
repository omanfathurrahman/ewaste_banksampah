import 'package:ewaste_banksampah/main.dart';
import 'package:ewaste_banksampah/utils/get_current_droppoin_id.dart';
import 'package:ewaste_banksampah/utils/get_formated_date.dart';
import 'package:ewaste_banksampah/utils/get_fullname_pembuang_pendonasi.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RiwayatDonasiPage extends StatefulWidget {
  const RiwayatDonasiPage({super.key});

  @override
  State<RiwayatDonasiPage> createState() => _RiwayatDonasiPageState();
}

class _RiwayatDonasiPageState extends State<RiwayatDonasiPage> {
  Future<List<Map<String, dynamic>>> _getRiwayatDonasiList() async {
    final userDroppoinId = await getCurrentBanksampahId();
    final riwayatKonfirmasiDonasiList = await supabase
        .from('sampah_didonasikan')
        .select()
        .eq('banksampah_id', userDroppoinId)
        .eq('status_didonasikan', 'Sudah diserahkan');
    return riwayatKonfirmasiDonasiList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Riwayat Konfirmasi Donasi'),
          leading: BackButton(
            onPressed: () {
              context.go('/afterLoginLayout');
            },
          ),
        ),
        body: FutureBuilder(
          future: _getRiwayatDonasiList(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final riwayatDonasiList =
                snapshot.data as List<Map<String, dynamic>>;
          if (riwayatDonasiList.isEmpty) return const Center(child: Text("Belum ada riwayat sampah didonasikan yang diambil"));

            return ListView.builder(
              itemCount: riwayatDonasiList.length,
              itemBuilder: (context, index) {
                final riwayatDonasi = riwayatDonasiList[index];
                return Card(
                  child: ListTile(
                    title: Text(riwayatDonasi['id'].toString()),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Tanggal: ${formatDateTime(riwayatDonasi['created_at'] as String)}"),
                        FutureBuilder(
                            future: getFullnamePembuangPendonasi(
                                riwayatDonasi['id_user']),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              final fullnamePembuang = snapshot.data as String;
                              return Text("Nama: $fullnamePembuang");
                            })
                      ],
                    ),
                    onTap: () {},
                  ),
                );
              },
            );
          },
        ));
  }
}
