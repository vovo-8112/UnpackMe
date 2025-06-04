import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
        useMaterial3: true,
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
  Map<String, dynamic>? soulData;
  bool loading = false;
  final TextEditingController _controller = TextEditingController(text: "21187");

  Future<void> fetchSoulData(String soulId) async {
    setState(() => loading = true);
    final url = 'https://whitestat.com/api/v1/souls?soulId=$soulId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        soulData = data['souls']?.first;
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
                  buildCard("🕐 Next Reward Date", soulData!['nextRewardStartAt']),
                  buildCard("⏭️ Next Reward", "${soulData!['nextRewardAmount']} WBT"),
                  buildCard("💰 Hold Amount", "${soulData!['holdAmount']} WBT"),
                  buildCard("🎁 Reward Available", "${soulData!['rewardAvailableAmount']} WBT"),
                  buildCard("📊 Reward %", "${soulData!['rewardPercent']}%"),
                  buildCard("📤 Claimed Reward", "${soulData!['rewardClaimedAmount']} WBT"),
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