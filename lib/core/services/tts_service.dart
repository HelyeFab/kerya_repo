import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'dart:math';
import 'package:googleapis/texttospeech/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:Keyra/features/books/domain/models/book_language.dart';

class TTSService {
  static final TTSService _instance = TTSService._internal();
  factory TTSService() => _instance;
  
  TTSService._internal() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      switch (state) {
        case PlayerState.playing:
          _isPlaying = true;
          break;
        case PlayerState.paused:
        case PlayerState.stopped:
        case PlayerState.completed:
        case PlayerState.disposed:
          _isPlaying = false;
          break;
      }
    });
  }

  TexttospeechApi? _ttsApi;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  String? _currentText;
  BookLanguage? _currentLanguage;

  Future<void> init() async {
    try {
      // Load credentials from assets
      final credentialsJson = await rootBundle.loadString('assets/config/google_tts_credentials.json');
      final credentials = ServiceAccountCredentials.fromJson(jsonDecode(credentialsJson));

      // Get an HTTP client with authentication
      final client = await clientViaServiceAccount(
        credentials,
        [TexttospeechApi.cloudPlatformScope],
      );

      // Create the Text-to-Speech API client
      _ttsApi = TexttospeechApi(client);

      await _audioPlayer.setVolume(1.0);
      debugPrint('TTS: Initialized successfully');
    } catch (e) {
      debugPrint('TTS Init Error: $e');
    }
  }

  AudioConfig _getAudioConfig(String languageCode) {
    // Base speaking rate is 1.0, so 0.9 is 90% speed
    final speakingRate = languageCode == 'ja-JP' ? 0.9 : 1.0;
    
    return AudioConfig(
      audioEncoding: 'MP3',
      speakingRate: speakingRate,
      pitch: 0.0,
      volumeGainDb: 0.0,
    );
  }

  Future<void> speak(String text, BookLanguage language) async {
    try {
      if (_ttsApi == null) {
        debugPrint('TTS: Not initialized');
        return;
      }

      debugPrint('TTS: Attempting to speak text: ${text.substring(0, min(50, text.length))}...');
      
      if (_isPlaying && text == _currentText) {
        debugPrint('TTS: Already playing this text, resuming...');
        await resume();
        return;
      }

      _currentText = text;
      _currentLanguage = language;

      final languageCode = _getLanguageCode(language);
      final voice = await _getVoice(languageCode);
      
      final input = SynthesisInput(text: text);
      final voiceParams = VoiceSelectionParams(
        languageCode: languageCode,
        name: voice,
      );
      
      // Get language-specific audio configuration
      final audioConfig = _getAudioConfig(languageCode);

      final request = SynthesizeSpeechRequest(
        input: input,
        voice: voiceParams,
        audioConfig: audioConfig,
      );

      final response = await _ttsApi!.text.synthesize(request);

      if (response.audioContent != null) {
        // Save audio content to temporary file
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/tts_audio.mp3');
        await tempFile.writeAsBytes(base64Decode(response.audioContent!));

        await _audioPlayer.play(DeviceFileSource(tempFile.path));
        debugPrint('TTS: Started playing audio (${languageCode == 'ja-JP' ? '90% speed' : 'normal speed'})');

        // Wait for completion and clean up
        await _audioPlayer.onPlayerComplete.first;
        await tempFile.delete();
        debugPrint('TTS: Finished playing audio');
      } else {
        debugPrint('TTS: Failed to get audio content');
      }
    } catch (e) {
      debugPrint('TTS Speak Error: $e');
    }
  }

  Future<void> pause() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
        debugPrint('TTS: Paused');
      }
    } catch (e) {
      debugPrint('TTS Pause Error: $e');
    }
  }

  Future<void> resume() async {
    try {
      if (!_isPlaying && _currentText != null) {
        await _audioPlayer.resume();
        debugPrint('TTS: Resumed');
      }
    } catch (e) {
      debugPrint('TTS Resume Error: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      _isPlaying = false;
      _currentText = null;
      debugPrint('TTS: Stopped');
    } catch (e) {
      debugPrint('TTS Stop Error: $e');
    }
  }

  String _getLanguageCode(BookLanguage language) {
    switch (language.code) {
      case 'ja':
        return 'ja-JP';
      case 'en':
        return 'en-GB'; 
      case 'es':
        return 'es-ES';
      case 'it':
        return 'it-IT';
      case 'fr':
        return 'fr-FR';
      case 'de':
        return 'de-DE';
      default:
        return 'en-GB'; 
    }
  }

  Future<String> _getVoice(String languageCode) async {
    if (_ttsApi == null) {
      throw Exception('TTS not initialized');
    }

    final voices = await _ttsApi!.voices.list($fields: 'voices');
    
    final matchingVoices = voices.voices?.where(
      (v) => v.languageCodes?.contains(languageCode) ?? false
    ).toList() ?? [];

    if (matchingVoices.isEmpty) {
      throw Exception('No voices found for language $languageCode');
    }

    final preferredVoices = {
      'en-GB': ['en-GB-Neural2-B', 'en-GB-Wavenet-B', 'en-GB-Standard-B'], // Male voice
      'ja-JP': ['ja-JP-Neural2-D', 'ja-JP-Wavenet-D', 'ja-JP-Standard-D'], // Male voice
      'es-ES': ['es-ES-Neural2-C', 'es-ES-Wavenet-C', 'es-ES-Standard-C'], // Female voice
      'it-IT': ['it-IT-Neural2-A', 'it-IT-Wavenet-A', 'it-IT-Standard-A'], // Female voice
      'fr-FR': ['fr-FR-Neural2-B', 'fr-FR-Wavenet-B', 'fr-FR-Standard-B'], // Male voice
      'de-DE': ['de-DE-Neural2-B', 'de-DE-Wavenet-B', 'de-DE-Standard-B'], // Male voice
    };

    // Try to find preferred voices first
    if (preferredVoices.containsKey(languageCode)) {
      for (final voiceName in preferredVoices[languageCode]!) {
        final voice = matchingVoices.firstWhere(
          (v) => v.name == voiceName,
          orElse: () => matchingVoices.first,
        );
        if (voice.name == voiceName) {
          return voice.name!;
        }
      }
    }

    // If no preferred voice found, try to find a male voice for Japanese
    if (languageCode == 'ja-JP') {
      final maleVoice = matchingVoices.firstWhere(
        (v) => v.ssmlGender == 'MALE' && (v.name?.contains('Neural2') ?? false),
        orElse: () => matchingVoices.firstWhere(
          (v) => v.ssmlGender == 'MALE' && (v.name?.contains('Wavenet') ?? false),
          orElse: () => matchingVoices.firstWhere(
            (v) => v.ssmlGender == 'MALE',
            orElse: () => matchingVoices.first,
          ),
        ),
      );
      return maleVoice.name!;
    }

    // Fallback to best available voice
    final voice = matchingVoices.firstWhere(
      (v) => v.name?.contains('Neural2') ?? false,
      orElse: () => matchingVoices.firstWhere(
        (v) => v.name?.contains('Wavenet') ?? false,
        orElse: () => matchingVoices.first,
      ),
    );

    return voice.name ?? matchingVoices.first.name!;
  }

  bool get isPlaying => _isPlaying;
  
  void dispose() {
    _audioPlayer.dispose();
  }
}
