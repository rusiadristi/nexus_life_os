import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/chat_message_model.dart';

class AiChatProvider with ChangeNotifier {
  final _uuid = const Uuid();
  final List<ChatMessageModel> _messages = [];
  bool _isGenerating = false;

  List<ChatMessageModel> get messages => _messages;
  bool get isGenerating => _isGenerating;

  final List<String> promptPresets = [
    '📈 Tren Karir & Skill 2030',
    '⚡ Strategi Deep Work Efektif',
    '💼 Alokasi Portofolio Finansial',
    '🧘 Rutinitas Harian yang Tenang',
  ];

  AiChatProvider() {
    _initializeChat();
  }

  void _initializeChat() {
    _messages.add(
      ChatMessageModel(
        id: _uuid.v4(),
        text: 'Halo! Saya asisten produktivitas personal Anda.\n\nSaya siap membantu Anda menyusun rencana kerja, mengevaluasi prioritas harian, menganalisis peluang karir & finansial, serta merancang rutinitas yang terstruktur dan tenang. Apa yang ingin kita bahas hari ini?',
        isUser: false,
        timestamp: DateTime.now(),
        actionSuggestions: [
          'Bagaimana menyusun rencana kerja 1 hari yang efektif?',
          'Skill apa yang paling penting untuk dipelajari?',
          'Tips menjaga fokus tanpa kelelahan kognitif',
        ],
      ),
    );
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMsg = ChatMessageModel(
      id: _uuid.v4(),
      text: text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );
    _messages.add(userMsg);
    _isGenerating = true;
    notifyListeners();

    // Generate response with natural delay
    await Future.delayed(const Duration(milliseconds: 900));

    final aiReply = _generateNeuralResponse(text);

    _messages.add(
      ChatMessageModel(
        id: _uuid.v4(),
        text: aiReply,
        isUser: false,
        timestamp: DateTime.now(),
        actionSuggestions: _generateSuggestions(text),
      ),
    );

    _isGenerating = false;
    notifyListeners();
  }

  String _generateNeuralResponse(String query) {
    final q = query.toLowerCase();

    if (q.contains('tren') || q.contains('karir') || q.contains('2030') || q.contains('skill')) {
      return '📊 **Panduan Skill & Karir Masa Depan:**\n\n'
          '1. **System Thinking & Problem Framing:** Kemampuan merumuskan masalah kompleks ke dalam alur kerja terstruktur.\n'
          '2. **Otomatisasi Alur Kerja:** Memanfaatkan teknologi untuk menangani tugas rutin sehingga Anda bisa fokus pada keputusan strategis.\n'
          '3. **Manajemen Energi Pribadi:** Menjaga ritme kerja yang berkelanjutan agar performa tetap prima dalam jangka panjang.\n'
          '4. **Literasi Data & Finansial:** Membaca tren data dan mengelola aset secara terukur.\n\n'
          '💡 *Saran Praktis:* Mulailah dari satu skill utama, latih secara konsisten 30 menit setiap hari daripada mencoba mempelajari semuanya sekaligus.';
    }

    if (q.contains('produktivitas') || q.contains('deep work') || q.contains('fokus') || q.contains('rencana')) {
      return '⚡ **Rekomendasi Rutinitas Kerja Efektif:**\n\n'
          '• **Pagi (Fase Fokus Utama):** Alokasikan 90 menit pertama untuk tugas dengan dampak terbesar tanpa membuka pesan atau notifikasi.\n'
          '• **Siang (Fase Kolaborasi):** Tangani email, pertemuan, koordinasi tim, dan hal-hal administratif.\n'
          '• **Sore (Fase Evaluasi):** Tinjau pencapaian hari ini dan siapkan 3 prioritas utama untuk esok hari.\n\n'
          '🎯 *Prinsip Utama:* Mengurangi distraksi mikro jauh lebih berdampak daripada menambah jam kerja.';
    }

    if (q.contains('investasi') || q.contains('aset') || q.contains('finansial') || q.contains('uang') || q.contains('portofolio')) {
      return '💼 **Kerangka Pengelolaan Finansial Sehat:**\n\n'
          '1. **Dana Darurat & Likuiditas (3-6 Bulan):** Prioritas pertama untuk ketenangan pikiran dan stabilitas hidup.\n'
          '2. **Instrumen Pertumbuhan Jangka Panjang (50-60%):** Indeks pasar global, saham blue-chip, atau aset terdiversifikasi.\n'
          '3. **Inovasi & Teknologi (15-20%):** Alokasi terukur ke sektor teknologi baru dan infrastruktur masa depan.\n'
          '4. **Investasi Pengembangan Diri (10%):** Buku, kursus, seminar, dan alat penunjang produktivitas kerja.\n\n'
          'Prinsip terpenting adalah konsistensi akumulasi berkala (DCA) dibandingkan berspekulasi pada waktu pasar.';
    }

    if (q.contains('kebiasaan') || q.contains('tidur') || q.contains('kesehatan') || q.contains('rutinitas')) {
      return '🌱 **Optimalisasi Ritme Istirahat & Produktivitas:**\n\n'
          '• **Pencahayaan Pagi:** Dapatkan sinar matahari alami 10-15 menit setelah bangun tidur untuk menyelaraskan ritme sirkadian tubuh.\n'
          '• **Jeda Teratur:** Istirahatkan mata dan berdiri sejenak setiap 45-50 menit bekerja.\n'
          '• **Waktu Tenang Malam Hari:** Kurangi paparan layar gawai 1 jam sebelum tidur untuk kualitas istirahat yang lebih restoratif.';
    }

    return '✨ **Catatan Strategis:**\n\n'
        'Terkait pertanyaan Anda mengenai: *"$query"*\n\n'
        'Langkah praktis yang direkomendasikan:\n'
        '1. **Sederhanakan Tujuan:** Fokuskan energi pada satu luaran nyata yang terukur hari ini.\n'
        '2. **Bagi Menjadi Langkah Kecil:** Eksekusi langkah awal dalam 15 menit pertama untuk mengatasi hambatan inersia.\n'
        '3. **Evaluasi Berkala:** Perbaiki proses secara bertahap setiap akhir pekan.\n\n'
        'Apakah Anda ingin merinci langkah kerja atau membuat daftar tugas spesifik untuk topik ini?';
  }

  List<String> _generateSuggestions(String query) {
    final q = query.toLowerCase();
    if (q.contains('karir') || q.contains('skill')) {
      return [
        'Bagaimana menyusun rencana belajar bulanan?',
        'Rekomendasi bacaan untuk kepemimpinan',
      ];
    }
    if (q.contains('produktivitas') || q.contains('deep work')) {
      return [
        'Mulai sesi fokus 25 menit sekarang',
        'Bagaimana mengatasi rasa lelah di siang hari?',
      ];
    }
    return [
      'Detailkan langkah-langkahnya',
      'Buatkan jadwal prioritas harian',
      'Beri contoh penerapannya',
    ];
  }

  void clearChat() {
    _messages.clear();
    _initializeChat();
    notifyListeners();
  }
}
