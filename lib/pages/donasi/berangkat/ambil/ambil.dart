import 'package:ewaste_banksampah/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AmbilDonasi extends StatefulWidget {
  const AmbilDonasi({super.key, required this.sampahDidonasikanId});
  final num sampahDidonasikanId;

  @override
  State<AmbilDonasi> createState() => _AmbilDonasiState();
}

class _AmbilDonasiState extends State<AmbilDonasi> {
  Future<void> _konfirmasiSampahSudahDiambil() async {
    await supabase
        .from('sampah_didonasikan')
        .update({'status_didonasikan': 'Sudah diserahkan'}).eq('id', widget.sampahDidonasikanId);
    final userId = (await supabase
        .from('sampah_didonasikan')
        .select('id_user')
        .eq('id', widget.sampahDidonasikanId)
        .single()
        .limit(1))['id_user'];

    final jumlahSampahDidonasikanList = await supabase
        .from('detail_sampah_didonasikan')
        .select('jumlah')
        .eq('id_sampah_didonasikan', widget.sampahDidonasikanId);
    final jumlahSampahDidonasikan = jumlahSampahDidonasikanList
        .map((item) => item['jumlah'])
        .reduce((value, element) => value + element) as num;
    final jumlahPoin = await supabase
        .from('profile')
        .select('jumlah_poin')
        .eq('id', userId)
        .single()
        .limit(1);

    await supabase.from('profile').update({
      'jumlah_poin': jumlahPoin['jumlah_poin'] + jumlahSampahDidonasikan
    }).eq('id', userId);
    setState(() {});
    if(mounted) context.go('/afterLoginLayout');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sampah telah diambil'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/afterLoginLayout');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          width: double.infinity,
          child: Column(children: [
            Text("Konfirmasi bahwa sampah telah diambil"),
            ElevatedButton(
                onPressed: () {
                  _konfirmasiSampahSudahDiambil();
                },
                child: Text("Sampah telah diambil"))
          ]),
        ),
      ),
    );
  }
}
