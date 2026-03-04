import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  bool _initialized = false;

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
    _initialized = true;
  }

  bool get isConfigured => _apiKey != null && _apiKey!.isNotEmpty;

  Future<void> init() async {
    if (_initialized) return;
    final prefs = await SharedPreferences.getInstance();
    _apiKey = prefs.getString('openrouter_api_key');
    _initialized = true;
  }

  Future<String> chat(List<Map<String, dynamic>> messages, {String? preferredModel}) async {
    await init();
    if (!isConfigured) {
      return 'AI is not configured. Please set your OpenRouter API key in Settings.';
    }

    final models = preferredModel != null
        ? [AIModel(preferredModel), ...modelPriority]
        : modelPriority;

    for (final model in models) {
      try {
        final response = await _callModel(model.id, messages);
        return response['content'] as String? ?? '';
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

  Future<Map<String, dynamic>> chatWithTools(
    List<Map<String, dynamic>> messages,
    List<Map<String, dynamic>> tools, {
    String? preferredModel,
  }) async {
    await init();
    if (!isConfigured) {
      return {'content': 'AI is not configured. Please set your OpenRouter API key in Settings.'};
    }

    final models = preferredModel != null ? [AIModel(preferredModel), ...modelPriority] : modelPriority;

    for (final model in models) {
      try {
        return await _callModel(model.id, messages, tools: tools);
      } on DioException catch (e) {
        if (e.response?.statusCode == 429 || e.response?.statusCode == 402) {
          continue;
        }
        rethrow;
      }
    }

    return {'content': 'All AI models are currently unavailable. Please try again later.'};
  }

  Future<Map<String, dynamic>> _callModel(
    String modelId,
    List<Map<String, dynamic>> messages, {
    List<Map<String, dynamic>>? tools,
  }) async {
    final payload = {
      'model': modelId,
      'messages': messages,
      'max_tokens': 2048,
    };

    if (tools != null && tools.isNotEmpty) {
      payload['tools'] = tools;
      payload['tool_choice'] = 'auto';
    }

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
      return data['choices'][0]['message'] as Map<String, dynamic>;
    }
    return {'content': ''};
  }
}

@riverpod
OpenRouterClient openRouterClient(OpenRouterClientRef ref) {
  return OpenRouterClient();
}
