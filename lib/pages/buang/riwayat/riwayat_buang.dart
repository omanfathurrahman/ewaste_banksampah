import 'package:ewaste_banksampah/main.dart';
import 'package:ewaste_banksampah/utils/get_current_droppoin_id.dart';
import 'package:ewaste_banksampah/utils/get_formated_date.dart';
import 'package:ewaste_banksampah/utils/get_fullname_pembuang_pendonasi.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RiwayatBuangPage extends StatefulWidget {
  const RiwayatBuangPage({super.key});

  @override
  State<RiwayatBuangPage> createState() => _RiwayatBuangPageState();
}

class _RiwayatBuangPageState extends State<RiwayatBuangPage> {

  // @override
  // initState() {
  //   super.initState();
  //   _getRiwayatBuangList();
  // }

  Future<List<Map<String, dynamic>>> _getRiwayatBuangList() async {
    final userBanksampahId = await getCurrentBanksampahId();
    final riwayatKonfirmasiBuangList = await supabase.from('sampah_dibuang').select().eq('banksampah_id', userBanksampahId).eq('status_dibuang', 'Sudah diserahkan');
    return riwayatKonfirmasiBuangList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Konfirmasi Buang'),
        leading: BackButton(onPressed: () {
          context.go('/afterLoginLayout');
        },),
      ),
      body: FutureBuilder(
        future: _getRiwayatBuangList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          
          final riwayatBuangList = snapshot.data as List<Map<String, dynamic>>;
          if (riwayatBuangList.isEmpty) return const Center(child: Text("Belum ada riwayat sampah dibuang yang diambil"));
          return ListView.builder(
            itemCount: riwayatBuangList.length,
            itemBuilder: (context, index) {
              final riwayatBuang = riwayatBuangList[index];
              return Card(
                child: ListTile(
                  title: Text(riwayatBuang['id'].toString()),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Tanggal: ${formatDateTime(riwayatBuang['created_at'] as String)}"),
                      FutureBuilder(future: getFullnamePembuangPendonasi(riwayatBuang['id_user']), builder: (context, snapshot){
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
                  onTap: () {
                  },
                ),
              );
            },
          );

        },
      )
    );
  }
}