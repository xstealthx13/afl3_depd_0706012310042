part of 'pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeViewModel vm;

  final weightController = TextEditingController();
  final courierOptions = ["jne", "pos", "tiki", "lion", "sicepat"];
  String selectedCourier = "jne";

  int? selectedProvinceOriginId;
  int? selectedCityOriginId;
  int? selectedProvinceDestinationId;
  int? selectedCityDestinationId;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      vm = context.read<HomeViewModel>();
      vm.getProvinceList();
    });
  }

  @override
  void dispose() {
    weightController.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------
  // CUSTOM ALERT (because SnackBar cannot be used without Scaffold)
  // ----------------------------------------------------------
  void showAlert(String msg) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: Text(msg),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            )
          ],
        );
      },
    );
  }

  // ----------------------------------------------------------
  // BOTTOM SHEET DETAIL
  // ----------------------------------------------------------
  void showCostDetailBottomSheet(dynamic cost) {
    final detail = (cost.cost != null && cost.cost.isNotEmpty) ? cost.cost[0] : null;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: SizedBox(
                  width: 60,
                  height: 4,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                cost.service ?? '-',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _detail("Description", cost.description ?? '-'),
              _detail("Price", detail != null ? "Rp ${detail.value}" : '-'),
              _detail("ETD", detail?.etd ?? '-'),
              _detail("Note", detail?.note ?? '-'),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Tutup"),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _detail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 5, child: Text(value, textAlign: TextAlign.right)),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // MAIN UI (NO SCAFFOLD)
  // ----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [

              // ====================
              // CARD INPUT
              // ====================
              Card(
                color: Colors.white,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [

                      // COURIER + WEIGHT ROW
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: selectedCourier,
                              items: courierOptions
                                  .map((c) => DropdownMenuItem(
                                      value: c, child: Text(c.toUpperCase())))
                                  .toList(),
                              onChanged: (v) => setState(() => selectedCourier = v ?? "jne"),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: weightController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(labelText: 'Berat (gr)'),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                      const Align(alignment: Alignment.centerLeft, child: Text("Origin", style: TextStyle(fontWeight: FontWeight.bold))),

                      // ORIGIN ROW
                      Row(
                        children: [
                          Expanded(
                            child: Consumer<HomeViewModel>(
                              builder: (context, vm, _) {
                                final data = vm.provinceList;

                                if (data.status == Status.loading) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                                if (data.status == Status.error) {
                                  return Text(data.message ?? "Error", style: const TextStyle(color: Colors.red));
                                }

                                final provinces = data.data ?? [];

                                return DropdownButton<int>(
                                  isExpanded: true,
                                  value: selectedProvinceOriginId,
                                  hint: const Text("Pilih provinsi"),
                                  items: provinces
                                      .map((p) => DropdownMenuItem(
                                            value: p.id,
                                            child: Text(p.name ?? ""),
                                          ))
                                      .toList(),
                                  onChanged: (id) {
                                    setState(() {
                                      selectedProvinceOriginId = id;
                                      selectedCityOriginId = null;
                                    });
                                    if (id != null) vm.getCityOriginList(id);
                                  },
                                );
                              },
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: Consumer<HomeViewModel>(
                              builder: (context, vm, _) {
                                final data = vm.cityOriginList;

                                if (data.status == Status.notStarted) {
                                  return const Text("Pilih provinsi dulu",
                                      style: TextStyle(fontSize: 12, color: Colors.grey));
                                }
                                if (data.status == Status.loading) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                                if (data.status == Status.error) {
                                  return Text(data.message ?? "Error",
                                      style: const TextStyle(color: Colors.red));
                                }

                                final cities = data.data ?? [];

                                return DropdownButton<int>(
                                  isExpanded: true,
                                  value: selectedCityOriginId,
                                  hint: const Text("Pilih kota"),
                                  items: cities
                                      .map((c) => DropdownMenuItem(
                                            value: c.id,
                                            child: Text(c.name ?? ""),
                                          ))
                                      .toList(),
                                  onChanged: (id) => setState(() => selectedCityOriginId = id),
                                );
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // DESTINATION
                      const Align(alignment: Alignment.centerLeft, child: Text("Destination", style: TextStyle(fontWeight: FontWeight.bold))),

                      Row(
                        children: [
                          Expanded(
                            child: Consumer<HomeViewModel>(
                              builder: (context, vm, _) {
                                final data = vm.provinceList;

                                if (data.status == Status.loading) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                                if (data.status == Status.error) {
                                  return Text(data.message ?? "Error", style: const TextStyle(color: Colors.red));
                                }

                                final provinces = data.data ?? [];

                                return DropdownButton<int>(
                                  isExpanded: true,
                                  value: selectedProvinceDestinationId,
                                  hint: const Text("Pilih provinsi"),
                                  items: provinces
                                      .map((p) => DropdownMenuItem(
                                            value: p.id,
                                            child: Text(p.name ?? ""),
                                          ))
                                      .toList(),
                                  onChanged: (id) {
                                    setState(() {
                                      selectedProvinceDestinationId = id;
                                      selectedCityDestinationId = null;
                                    });
                                    if (id != null) vm.getCityDestinationList(id);
                                  },
                                );
                              },
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: Consumer<HomeViewModel>(
                              builder: (context, vm, _) {
                                final data = vm.cityDestinationList;

                                if (data.status == Status.notStarted) {
                                  return const Text("Pilih provinsi dulu",
                                      style: TextStyle(fontSize: 12, color: Colors.grey));
                                }
                                if (data.status == Status.loading) {
                                  return const Center(child: CircularProgressIndicator());
                                }

                                final cities = data.data ?? [];

                                return DropdownButton<int>(
                                  isExpanded: true,
                                  value: selectedCityDestinationId,
                                  hint: const Text("Pilih kota"),
                                  items: cities
                                      .map((c) => DropdownMenuItem(
                                            value: c.id,
                                            child: Text(c.name ?? ""),
                                          ))
                                      .toList(),
                                  onChanged: (id) => setState(() => selectedCityDestinationId = id),
                                );
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // BUTTON
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (selectedCityOriginId == null ||
                                selectedCityDestinationId == null ||
                                weightController.text.isEmpty) {
                              showAlert("Lengkapi semua field!");
                              return;
                            }

                            final weight = int.tryParse(weightController.text) ?? 0;
                            if (weight <= 0) {
                              showAlert("Berat harus lebih dari 0!");
                              return;
                            }

                            vm.checkShipmentCost(
                              selectedCityOriginId!.toString(),
                              "city",
                              selectedCityDestinationId!.toString(),
                              "city",
                              weight,
                              selectedCourier,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.all(16),
                          ),
                          child: const Text("Hitung Ongkir", style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ====================
              // COST LIST
              // ====================
              Card(
                color: Colors.blue[50],
                elevation: 2,
                child: Consumer<HomeViewModel>(
                  builder: (context, vm, _) {
                    switch (vm.costList.status) {
                      case Status.loading:
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );

                      case Status.error:
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(vm.costList.message ?? 'Error',
                              style: const TextStyle(color: Colors.red)),
                        );

                      case Status.completed:
                        final list = vm.costList.data ?? [];
                        if (list.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text("Tidak ada data ongkir."),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: list.length,
                          itemBuilder: (_, i) {
                            final item = list[i];
                            return GestureDetector(
                              onTap: () => showCostDetailBottomSheet(item),
                              child: CardCost(item),
                            );
                          },
                        );

                      default:
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text("Pilih kota dan klik Hitung Ongkir terlebih dulu."),
                        );
                    }
                  },
                ),
              ),
            ],
          ),
        ),

        // GLOBAL LOADING
        Consumer<HomeViewModel>(
          builder: (context, vm, _) {
            return vm.isLoading
                ? Container(
                    color: Colors.black.withOpacity(0.4),
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  )
                : const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
