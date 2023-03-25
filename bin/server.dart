import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

// Define a simple endpoint that returns a JSON response
Response _helloWorld(Request request) {
  return Response.ok(
    jsonEncode({'message': 'Hello, world!'}),
    headers: {'Content-Type': 'application/json'},
  );
}

// Define a more complex endpoint that takes a query parameter and returns a response
Response _greetUser(Request request, String userId) {
  final name = request.url.queryParameters['name'] ?? 'Anonymous';
  final message = 'Hello, $name!';
  return Response.ok(
    jsonEncode({'userId': userId, 'message': message}),
    headers: {'Content-Type': 'application/json'},
  );
}

// Create a router and add the endpoints to it
final router = Router()
  ..get('/', _helloWorld)
  ..get('/users/<userId>', _greetUser);

// Create a Handler function that calls the router to handle requests
Handler getApiHandler() {
  return const Pipeline().addMiddleware(logRequests()).addHandler(router);
}

void main() async {
  final port = 5000;
  final server = await serve(getApiHandler(), InternetAddress.anyIPv4, port);
  print('Server listening on port $port');
}





// // Configure routes.
// final _router = Router()
//   ..get('/', _rootHandler)
//   ..get('/echo/<message>', _echoHandler);

// Response _rootHandler(Request req) {
//   return Response.ok('Hello, World!\n');
// }

// Response _echoHandler(Request request) {
//   final message = request.params['message'];
//   return Response.ok('$message\n');
// }

// void main(List<String> args) async {
//   // Use any available host or container IP (usually `0.0.0.0`).
//   final ip = InternetAddress.anyIPv4;

//   // Configure a pipeline that logs requests.
//   final handler = Pipeline().addMiddleware(logRequests()).addHandler(_router);

//   // For running in containers, we respect the PORT environment variable.
//   final port = int.parse(Platform.environment['PORT'] ?? '8083');
//   final server = await serve(handler, ip, port);
//   print('Server listening on port ${server.port}');
// }

// void main(List<String> args) async {
//   final app = Router();
//   app.get("/", (Request request) {
//     return Response.ok("Hello, World!");
//   });
//   await serve(app, "localhost", 8083);
// }
