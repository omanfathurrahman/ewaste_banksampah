import 'package:ewaste_banksampah/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AmbilBuang extends StatefulWidget {
  const AmbilBuang({super.key, required this.sampahDibuangId});
  final num sampahDibuangId;

  @override
  State<AmbilBuang> createState() => _AmbilBuangState();
}

class _AmbilBuangState extends State<AmbilBuang> {
  Future<void> _konfirmasiSampahSudahDiambil() async {
    await supabase
        .from('sampah_dibuang')
        .update({'status_dibuang': 'Sudah diserahkan'}).eq('id', widget.sampahDibuangId);
    final userId = (await supabase
        .from('sampah_dibuang')
        .select('id_user')
        .eq('id', widget.sampahDibuangId)
        .single()
        .limit(1))['id_user'];

    final jumlahSampahDibuangList = await supabase
        .from('detail_sampah_dibuang')
        .select('jumlah')
        .eq('id_sampah_dibuang', widget.sampahDibuangId);
    final jumlahSampahDibuang = jumlahSampahDibuangList
        .map((item) => item['jumlah'])
        .reduce((value, element) => value + element) as num;
    final jumlahPoin = await supabase
        .from('profile')
        .select('jumlah_poin')
        .eq('id', userId)
        .single()
        .limit(1);

    await supabase.from('profile').update({
      'jumlah_poin': jumlahPoin['jumlah_poin'] + jumlahSampahDibuang
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
