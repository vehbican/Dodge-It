import 'package:flutter/material.dart';
import '../game/utilities/sound_manager.dart';
import '../game/managers/local_score_manager.dart';

class MainMenu extends StatefulWidget {
  final void Function(BuildContext) onStart;

  const MainMenu({required this.onStart, Key? key}) : super(key: key);

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  late Future<List<int>> _sortedScores;

  @override
  void initState() {
    super.initState();
    _fetchScores();
  }

  void _fetchScores() {
    setState(() {
      _sortedScores = LocalScoreManager.getSortedScores();
    });
  }

  void _toggleMute() {
    setState(() {
      SoundManager.toggleMute();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => widget.onStart(context),
              child: const Text('Start Game'),
            ),
            const SizedBox(height: 20),
            IconButton(
              onPressed: _toggleMute,
              icon: Icon(
                SoundManager.getMuteStatus()
                    ? Icons.volume_off
                    : Icons.volume_up,
                size: 32,
              ),
              tooltip: SoundManager.getMuteStatus() ? 'Unmute' : 'Mute',
            ),
            const SizedBox(height: 20),
            const Text(
              'Top Scores',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            FutureBuilder<List<int>>(
              future: _sortedScores,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No scores available');
                }

                final scores = snapshot.data!;
                return Expanded(
                  child: ListView.builder(
                    itemCount: scores.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Text('${index + 1}.',
                            style: const TextStyle(fontSize: 18)),
                        title: Text('${scores[index]}',
                            style: const TextStyle(fontSize: 18)),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchScores();
  }
}
