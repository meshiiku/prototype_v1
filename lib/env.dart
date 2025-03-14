import 'package:envied/envied.dart';

part "env.g.dart";

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'HOTPEPPER_API_KEY', obfuscate: true)
  static String apiKey = _Env.apiKey;
  @EnviedField(varName: 'BACKEND_BASEURL', obfuscate: true)
  static String backendBaseUrl = _Env.backendBaseUrl;
}
