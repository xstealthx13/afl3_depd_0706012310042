part of 'pages.dart';

class InternasionalPage extends StatefulWidget {
  const InternasionalPage({super.key});

  @override
  State<InternasionalPage> createState() => _InternasionalPageState();
}

class _InternasionalPageState extends State<InternasionalPage> {
  Country? selectedCountry;
  TextEditingController weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<InternationalViewModel>(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // -----------------------
          // SEARCH COUNTRY
          // -----------------------
          TextField(
            decoration: const InputDecoration(
              label: Text("Search Country"),
            ),
            onChanged: (keyword) {
              if (keyword.isNotEmpty) {
                vm.getInternationalCountries(keyword);
              }
            },
          ),

          const SizedBox(height: 16),

          // -----------------------
          // COUNTRY LIST RESULTS
          // -----------------------
          Expanded(
            child: () {
              switch (vm.countryList.status) {
                case Status.loading:
                  return const Center(child: CircularProgressIndicator());

                case Status.error:
                  return Center(
                    child: Text(
                      vm.countryList.message ?? "Error loading countries",
                      style: const TextStyle(color: Colors.red),
                    ),
                  );

                case Status.completed:
                  final list = vm.countryList.data ?? [];
                  if (list.isEmpty) {
                    return const Center(child: Text("No country found"));
                  }

                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (_, i) {
                      final item = list[i];
                      return ListTile(
                        title: Text(item.countryName ?? "-"),
                        trailing: selectedCountry?.countryId == item.countryId
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : null,
                        onTap: () {
                          setState(() => selectedCountry = item);
                        },
                      );
                    },
                  );

                default:
                  return const Center(child: Text("Search a country..."));
              }
            }(),
          ),

          const SizedBox(height: 16),

          // -----------------------
          // WEIGHT FIELD
          // -----------------------
          TextField(
            controller: weightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              label: Text("Weight (gram)"),
            ),
          ),

          const SizedBox(height: 16),

          // -----------------------
          // CHECK COST BUTTON
          // -----------------------
          ElevatedButton(
            onPressed: () {
              if (selectedCountry == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please select a country"),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              vm.checkInternationalCost(
                origin: "501", // FIXED ORIGIN CITY (SAME AS PREVIOUS CODE)
                originType: "city",
                destination: selectedCountry!.countryId.toString(),
                weight: int.tryParse(weightController.text) ?? 1000,
                courier: "pos", // INTERNATIONAL ONLY USE POS
              );
            },
            child: vm.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text("Check Cost"),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}