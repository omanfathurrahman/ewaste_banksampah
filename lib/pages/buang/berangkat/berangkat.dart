import 'package:ewaste_banksampah/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BerangkatBuangList extends StatefulWidget {
  const BerangkatBuangList({super.key});

  @override
  State<BerangkatBuangList> createState() => _BerangkatBuangListState();
}

class _BerangkatBuangListState extends State<BerangkatBuangList> {

  Future<List<Map<String, dynamic>>> _getSampahDibuangYangDiambilList() async {
    final banksampahId = await _getBanksampahId();
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
        .eq('pilihan_antar_jemput', "dijemput")
        .eq("banksampah_id", banksampahId);

    return response;
  }

  Future<num> _getBanksampahId() async {
    final res = await supabase
        .from("profile_banksampah")
        .select("banksampah_id")
        .eq("user_id", supabase.auth.currentUser!.id)
        .single()
        .limit(1);

    return res["banksampah_id"] as num;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            context.go('/afterLoginLayout');
          },
        ),
        title: const Text('Sampah dibuang yang diambil'),
      ),
      body: ListView(children: [
        FutureBuilder(future: _getSampahDibuangYangDiambilList(), builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } 
          final data = snapshot.data as List<Map<String, dynamic>>;
          return Column(
            children: data.map((item) {
              return Card(
                child: ListTile(
                  title: Text(item["profile"]["nama_lengkap"] as String),
                  subtitle: Text(item["status_dibuang"] as String),
                  onTap: () {
                    context.go('/detailSampahDibuang/berangkat/${item["id"]}');
                  },
                ),
              );
            }).toList(),
          );
        },)
      ]),
    );
  }
}
