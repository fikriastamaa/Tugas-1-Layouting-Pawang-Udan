import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

void main() {
  runApp(PawangHujanApp());
}

class PawangHujanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pawang Hujan Digital',
      theme: ThemeData.dark(),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<_PawangHujanScreenState> _pawangHujanKey = GlobalKey();

  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      PawangHujanScreen(key: _pawangHujanKey),
      ListMantraScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _resetPawangHujanScreen() {
    if (_selectedIndex == 0) {
      _pawangHujanKey.currentState?.resetApp();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pawang Hujan Digital'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetPawangHujanScreen,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.cover, // Menyesuaikan ukuran gambar
                ),
              ),
              child: Text(
                'Menu\n'
                    'Fikri Astama Putra - 123220108',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text('List Mantra'),
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
    );
  }
}

class PawangHujanScreen extends StatefulWidget {
  const PawangHujanScreen({Key? key}) : super(key: key);

  @override
  _PawangHujanScreenState createState() => _PawangHujanScreenState();
}

class _PawangHujanScreenState extends State<PawangHujanScreen> {
  bool isCastingSpell = false;
  String statusText = "Langit Berawan";
  String currentAnimation = 'assets/cloudy.json';
  final AudioPlayer _audioPlayer = AudioPlayer();
  final TextEditingController _mantraController = TextEditingController();

  void castSpell() {
    String mantra = _mantraController.text.toLowerCase();

    setState(() {
      isCastingSpell = true;
      statusText = "Mantra sedang bekerja...";
      currentAnimation = 'assets/magic.json';
    });

    _audioPlayer.play(AssetSource('sounds/magic_spell.mp3'));

    Timer(Duration(seconds: 2), () {
      setState(() {
        switch (mantra) {
          case "pajulo julo mandiloko":
            statusText = "Hujan Turun";
            currentAnimation = 'assets/rain.json';
            _audioPlayer.play(AssetSource('sounds/rain.mp3'));
            break;
          case "suwung garing":
            statusText = "Langit Cerah";
            currentAnimation = 'assets/sunny.json';
            _audioPlayer.play(AssetSource('sounds/sunny.mp3'));
            break;
          case "mega gumulung":
            statusText = "Badai Datang!";
            currentAnimation = 'assets/storm.json';
            _audioPlayer.play(AssetSource('sounds/storm.mp3'));
            break;
          default:
            statusText = "Mantra tidak dikenali";
            currentAnimation = 'assets/magic.json';
            break;
        }
      });
      _audioPlayer.play(AssetSource('sounds/success.mp3'));
      isCastingSpell = false;
    });
  }

  void resetApp() {
    setState(() {
      isCastingSpell = false;
      statusText = "Langit Berawan";
      currentAnimation = 'assets/cloudy.json';
      _mantraController.clear();
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _mantraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(
            currentAnimation,
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 30),
          TextField(
            controller: _mantraController,
            decoration: InputDecoration(
              labelText: "Masukkan Mantra",
              border: OutlineInputBorder(),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Text(
            statusText,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: isCastingSpell ? null : castSpell,
            child: Text('Gunakan Mantra'),
          ),
        ],
      ),
    );
  }
}

class ListMantraScreen extends StatelessWidget {
  final List<String> mantras = [
    "pajulo julo mandiloko - Hujan Turun",
    "suwung garing - Langit Cerah",
    "mega gumulung - Badai Datang",
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: mantras.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(mantras[index]),
        );
      },
    );
  }
}
