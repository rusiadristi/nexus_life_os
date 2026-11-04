import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/focus_session_model.dart';

class FocusProvider with ChangeNotifier {
  final _uuid = const Uuid();

  // Mode settings
  final List<Map<String, dynamic>> modes = [
    {'name': 'Fokus Standar', 'minutes': 25, 'desc': 'Siklus kerja efektif 25 menit'},
    {'name': 'Siklus Mendalam', 'minutes': 50, 'desc': 'Fokus mendalam tanpa distraksi'},
    {'name': 'Istirahat Singkat', 'minutes': 10, 'desc': 'Relaksasi mental & fisik sejenak'},
    {'name': 'Sesi Puncak', 'minutes': 90, 'desc': 'Siklus energi kognitif maksimal'},
  ];

  final List<String> ambientFrequencies = [
    'Gelombang Alpha (432Hz)',
    'Fokus Binaural',
    'Suara Hujan Lembut',
    'White Noise Alami',
    'Hening Mutlak',
  ];

  late int _selectedModeIndex;
  late String _selectedAmbient;
  late int _totalSeconds;
  late int _remainingSeconds;
  bool _isRunning = false;
  Timer? _timer;

  // History & Stats
  final List<FocusSessionModel> _sessions = [];
  int _todayMinutes = 75;

  FocusProvider() {
    _selectedModeIndex = 0;
    _selectedAmbient = ambientFrequencies[0];
    _totalSeconds = modes[0]['minutes'] * 60;
    _remainingSeconds = _totalSeconds;
  }

  // Getters
  int get selectedModeIndex => _selectedModeIndex;
  String get selectedAmbient => _selectedAmbient;
  int get remainingSeconds => _remainingSeconds;
  int get totalSeconds => _totalSeconds;
  bool get isRunning => _isRunning;
  double get progress => _totalSeconds > 0 ? (1 - (_remainingSeconds / _totalSeconds)) : 0.0;
  int get todayMinutes => _todayMinutes;
  List<FocusSessionModel> get sessions => _sessions;

  String get formattedTime {
    final minutes = (_remainingSeconds / 60).floor().toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void selectMode(int index) {
    if (_isRunning) return;
    _selectedModeIndex = index;
    _totalSeconds = modes[index]['minutes'] * 60;
    _remainingSeconds = _totalSeconds;
    notifyListeners();
  }

  void selectAmbient(String ambient) {
    _selectedAmbient = ambient;
    notifyListeners();
  }

  void startTimer({Function(int xp)? onComplete}) {
    if (_isRunning) return;
    _isRunning = true;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _onSessionComplete(onComplete);
      }
    });
  }

  void pauseTimer() {
    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  void resetTimer() {
    _timer?.cancel();
    _isRunning = false;
    _remainingSeconds = _totalSeconds;
    notifyListeners();
  }

  void _onSessionComplete(Function(int xp)? onComplete) {
    _timer?.cancel();
    _isRunning = false;

    final sessionMinutes = modes[_selectedModeIndex]['minutes'] as int;
    _todayMinutes += sessionMinutes;

    final newSession = FocusSessionModel(
      id: _uuid.v4(),
      modeName: modes[_selectedModeIndex]['name'] as String,
      durationMinutes: sessionMinutes,
      completedAt: DateTime.now(),
      flowScore: 94,
      ambientMode: _selectedAmbient,
    );
    _sessions.insert(0, newSession);

    if (onComplete != null) {
      onComplete(sessionMinutes * 5);
    }

    _remainingSeconds = _totalSeconds;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
