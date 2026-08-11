import 'package:shelf/shelf.dart';

final allowedOrigins = ['https://malicash.ndal.ink'];

Middleware corsMiddleware() {
  return (Handler handler) {
    return (Request request) async {
      final origin = request.headers['origin'];

      // Détermine si l'origine est autorisée
      final bool isAllowed =
          origin == null ||
          allowedOrigins.contains(origin) ||
          origin.startsWith('http://localhost') ||
          origin.startsWith('http://127.0.0.1');

      if (!isAllowed) {
        return Response.forbidden('CORS origin not allowed');
      }

      final corsOrigin = origin ?? '*';

      // Preflight OPTIONS
      if (request.method == 'OPTIONS') {
        return Response(
          204,
          headers: {
            'Access-Control-Allow-Origin': corsOrigin,
            'Access-Control-Allow-Methods':
                'GET, POST, PUT, DELETE, OPTIONS, PATCH',
            'Access-Control-Allow-Headers':
                'Origin, Content-Type, Accept, Authorization',
            'Access-Control-Allow-Credentials': 'true',
            'Access-Control-Max-Age': '86400',
            'Vary': 'Origin',
          },
        );
      }

      // Requête normale
      final response = await handler(request);
      return response.change(
        headers: {
          ...response.headers,
          'Access-Control-Allow-Origin': corsOrigin,
          'Access-Control-Allow-Credentials': 'true',
          'Vary': 'Origin',
        },
      );
    };
  };
}

/// Middleware global pour l'API
