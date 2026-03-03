import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'openrouter_client.g.dart';

class AIModel {
  final String id;
  final int rateLimit;

  AIModel(this.id, {this.rateLimit = 100});
}

class OpenRouterClient {
  static const String _baseUrl = 'https://openrouter.ai/api/v1/chat/completions';

  final Dio _dio;
  String? _apiKey;

  final List<AIModel> modelPriority = [
    AIModel('openai/gpt-4o', rateLimit: 200),
    AIModel('mistralai/mistral-large-latest', rateLimit: 100),
    AIModel('google/gemini-pro', rateLimit: 60),
    AIModel('meta-llama/llama-3.1-8b-instruct', rateLimit: 1000),
  ];

  OpenRouterClient({Dio? dio, String? apiKey})
      : _dio = dio ?? Dio(),
        _apiKey = apiKey;

  void setApiKey(String key) {
    _apiKey = key;
  }

  bool get isConfigured => _apiKey != null && _apiKey!.isNotEmpty;

  Future<String> chat(List<Map<String, String>> messages, {String? preferredModel}) async {
    if (!isConfigured) {
      return 'AI is not configured. Please set your OpenRouter API key in Settings.';
    }

    final models = preferredModel != null
        ? [AIModel(preferredModel), ...modelPriority]
        : modelPriority;

    for (final model in models) {
      try {
        final response = await _callModel(model.id, messages);
        return response;
      } on DioException catch (e) {
        if (e.response?.statusCode == 429 || e.response?.statusCode == 402) {
          // Rate limit or quota exceeded — try next model
          continue;
        }
        rethrow;
      }
    }

    return 'All AI models are currently unavailable. Please try again later.';
  }

  Future<String> _callModel(String modelId, List<Map<String, String>> messages) async {
    final response = await _dio.post(
      _baseUrl,
      options: Options(
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
          'HTTP-Referer': 'https://transbook.app',
          'X-Title': 'TransBook',
        },
      ),
      data: {
        'model': modelId,
        'messages': messages,
        'max_tokens': 2048,
      },
    );

    final data = response.data;
    if (data is Map && data['choices'] is List && (data['choices'] as List).isNotEmpty) {
      return data['choices'][0]['message']['content'] as String? ?? '';
    }
    return '';
  }
}

@riverpod
OpenRouterClient openRouterClient(OpenRouterClientRef ref) {
  return OpenRouterClient();
}
