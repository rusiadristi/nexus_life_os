import 'package:flutter/foundation.dart';

class UserProfileProvider with ChangeNotifier {
  String _userName = 'Rusi Adristi';
  String _userRank = 'Executive Lead';
  int _cyberLevel = 7;
  int _currentXp = 1840;
  final int _xpToNextLevel = 2500;
  final int _streakDays = 14;
  int _lifeScore = 92; // 0 - 100
  final int _biometricEnergy = 88; // 0 - 100
  final int _cognitiveFocus = 95; // 0 - 100
  bool _biometricLock = true;
  bool _hapticFeedback = true;
  bool _neuralSoundFx = false;

  // Getters
  String get userName => _userName;
  String get userRank => _userRank;
  int get cyberLevel => _cyberLevel;
  int get currentXp => _currentXp;
  int get xpToNextLevel => _xpToNextLevel;
  int get streakDays => _streakDays;
  int get lifeScore => _lifeScore;
  int get biometricEnergy => _biometricEnergy;
  int get cognitiveFocus => _cognitiveFocus;
  bool get biometricLock => _biometricLock;
  bool get hapticFeedback => _hapticFeedback;
  bool get neuralSoundFx => _neuralSoundFx;

  double get levelProgress => (_currentXp % 1000) / 1000.0;

  void addXp(int xp) {
    _currentXp += xp;
    int calculatedLevel = (_currentXp / 1000).floor() + 5;
    if (calculatedLevel > _cyberLevel) {
      _cyberLevel = calculatedLevel;
      _updateRank();
    }
    _recalculateLifeScore();
    notifyListeners();
  }

  void _updateRank() {
    if (_cyberLevel >= 15) {
      _userRank = 'Master Strategist';
    } else if (_cyberLevel >= 10) {
      _userRank = 'Senior Director';
    } else if (_cyberLevel >= 7) {
      _userRank = 'Executive Lead';
    } else {
      _userRank = 'Professional Associate';
    }
  }

  void _recalculateLifeScore() {
    _lifeScore = ((_cognitiveFocus * 0.4) + (_biometricEnergy * 0.3) + (_streakDays * 2)).clamp(60, 99).toInt();
  }

  void setBiometricLock(bool val) {
    _biometricLock = val;
    notifyListeners();
  }

  void setHapticFeedback(bool val) {
    _hapticFeedback = val;
    notifyListeners();
  }

  void setNeuralSoundFx(bool val) {
    _neuralSoundFx = val;
    notifyListeners();
  }

  void updateName(String name) {
    _userName = name;
    notifyListeners();
  }
}
