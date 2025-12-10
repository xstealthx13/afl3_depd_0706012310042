part of 'widgets.dart';

class BottomSheetsCost extends StatefulWidget {
  final Costs cost;
  const BottomSheetsCost({super.key, required this.cost});

  @override
  State<BottomSheetsCost> createState() => _BottomSheetsCostState();
}

class _BottomSheetsCostState extends State<BottomSheetsCost> {
  // Helper: Memformat angka menjadi mata uang Rupiah
  String _rupiahMoneyFormatter(int? value) {
    if (value == null) return "Rp0,00";
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 2,
    );
    return formatter.format(value);
  }

  // Helper: Memformat satuan "day" menjadi "hari"
  String _formatEtd(String? etd) {
    if (etd == null || etd.isEmpty) return '-';
    return etd.replaceAll(RegExp(r'\s*days?'), ' hari');
  }

  // Helper: Widget untuk menampilkan satu baris detail
  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120, // Lebar tetap untuk label
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.black54,
              ),
            ),
          ),
          const Text(' : ', style: TextStyle(color: Colors.black)),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: valueColor ?? Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cost = widget.cost;

    // Menggunakan Column dalam Container untuk Bottom Sheet
    return Container(
      // Dekorasi Bottom Sheet: Sudut melengkung di atas
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Membuat Column menyesuaikan konten
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle (Opsional, tapi bagus untuk UX Bottom Sheet)
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Header (Nama Kurir)
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue[50],
                child: Icon(Icons.local_shipping, color: Colors.blue[800]),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cost.name ?? '-',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue[800],
                    ),
                  ),
                  Text(
                    cost.service ?? '-',
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),

          const Divider(height: 20, thickness: 1),

          // Detail Informasi Pengiriman
          // Gunakan SingleChildScrollView di sini untuk mencegah overflow jika detailnya panjang
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Nama Kurir', cost.name ?? '-'),
                _buildDetailRow('Kode', cost.code ?? '-'),
                _buildDetailRow('Layanan', cost.service ?? '-'),
                _buildDetailRow('Deskripsi', cost.description ?? '-'),
                _buildDetailRow(
                  'Biaya',
                  _rupiahMoneyFormatter(cost.cost),
                  valueColor: Colors.red[800],
                ),
                _buildDetailRow(
                  'Estimasi Pengiriman',
                  _formatEtd(cost.etd),
                  valueColor: Colors.green[800],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}