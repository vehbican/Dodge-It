import 'package:flutter/material.dart';
import '../game/utilities/sound_manager.dart';
import '../game/managers/local_score_manager.dart';

class MainMenu extends StatefulWidget {
  final void Function(BuildContext) onStart;
  final List<int>? scores;

  const MainMenu({
    required this.onStart,
    this.scores,
    Key? key,
  }) : super(key: key);

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  late Future<List<int>> _sortedScores;

  @override
  void initState() {
    super.initState();
    _initializeScores();
    SoundManager.initialize();
    SoundManager.playBackgroundMusic();
  }

  void _initializeScores() {
    if (widget.scores == null) {
      _sortedScores = LocalScoreManager.getSortedScores();
    } else {
      _sortedScores = Future.value(widget.scores);
      print("Received scores: ${widget.scores}");
    }
  }

  void updateScores(List<int> scores) {
    setState(() {
      _sortedScores = Future.value(scores);
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
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Dodge It',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => widget.onStart(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    backgroundColor: Colors.pink,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Start Game',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                IconButton(
                  onPressed: _toggleMute,
                  icon: Icon(
                    SoundManager.getMuteStatus()
                        ? Icons.volume_off
                        : Icons.volume_up,
                    size: 36,
                    color: Colors.white,
                  ),
                  tooltip: SoundManager.getMuteStatus() ? 'Unmute' : 'Mute',
                ),
                const SizedBox(height: 30),
                const Text(
                  'Top Scores',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                FutureBuilder<List<int>>(
                  future: _sortedScores,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text(
                        'No scores available',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      );
                    }

                    final scores = snapshot.data!;
                    return SizedBox(
                      height: 200,
                      child: ListView.builder(
                        itemCount: scores.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Text(
                              '${index + 1}.',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              '${scores[index]}',
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

