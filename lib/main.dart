import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

void main() {
  runApp(const SoulApp());
}

class SoulApp extends StatelessWidget {
  const SoulApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soul Info',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: Colors.deepPurple,
          secondary: Colors.deepPurpleAccent,
        ),
      ),
      home: const SoulHomePage(),
    );
  }
}

class SoulHomePage extends StatefulWidget {
  const SoulHomePage({super.key});

  @override
  State<SoulHomePage> createState() => _SoulHomePageState();
}

class _SoulHomePageState extends State<SoulHomePage> {
  String formatDate(String? isoDate) {
    if (isoDate == null) return 'Невідома дата';
    try {
      final date = DateTime.parse(isoDate).toLocal();
      return DateFormat('dd.MM.yyyy HH:mm').format(date);
    } catch (_) {
      return 'Невірний формат дати';
    }
  }
  Map<String, dynamic>? soulData;
  Map<String, String>? futureRewards;
  bool loading = false;
  final TextEditingController _controller = TextEditingController(text: "21187");

  double calculateFutureRewards({required double currentAmount, required double rewardPercent, required int months}) {
    double monthlyRate = rewardPercent / 100;
    double future = currentAmount;
    for (int i = 0; i < months; i++) {
      future += future * monthlyRate;
    }
    return future - currentAmount;
  }

  Future<void> fetchSoulData(String soulId) async {
    setState(() => loading = true);
    final url = 'https://whitestat.com/api/v1/souls?soulId=$soulId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        soulData = data['souls']?.first;
        final holdAmount = double.tryParse(soulData!['holdAmount'].toString()) ?? 0.0;
        final rewardPercent = double.tryParse(soulData!['rewardPercent'].toString()) ?? 0.0;
        futureRewards = {
          'Через 3 міс.': "${calculateFutureRewards(currentAmount: holdAmount, rewardPercent: rewardPercent, months: 3).toStringAsFixed(2)} WBT",
          'Через 6 міс.': "${calculateFutureRewards(currentAmount: holdAmount, rewardPercent: rewardPercent, months: 6).toStringAsFixed(2)} WBT",
          'Через рік': "${calculateFutureRewards(currentAmount: holdAmount, rewardPercent: rewardPercent, months: 12).toStringAsFixed(2)} WBT",
        };
        loading = false;
      });
    } else {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Помилка завантаження даних')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSoulData(_controller.text);
  }

  Widget buildCard(String title, String value) {
    return Card(
      color: Colors.grey[900],
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Soul Info'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Soul ID',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => fetchSoulData(_controller.text),
                  child: const Text('Завантажити'),
                ),
              ],
            ),
          ),
          if (loading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (soulData != null)
            Expanded(
              child: ListView(
                children: [
                  buildCard("🕐 Next Reward Date", formatDate(soulData!['nextRewardStartAt'])),
                  buildCard("⏭️ Next Reward", "${soulData!['nextRewardAmount']} WBT"),
                  buildCard("💰 Hold Amount", "${soulData!['holdAmount']} WBT"),
                  buildCard("🎁 Reward Available", "${soulData!['rewardAvailableAmount']} WBT"),
                  buildCard("📊 Reward %", "${soulData!['rewardPercent']}%"),
                  buildCard("📤 Claimed Reward", "${soulData!['rewardClaimedAmount']} WBT"),
                  if (futureRewards != null) ...futureRewards!.entries.map((entry) =>
                    buildCard("📈 ${entry.key}", entry.value),
                  ),
                ],
              ),
            )
          else
            const Expanded(child: Center(child: Text('Дані не знайдені'))),
        ],
      ),
    );
  }
}