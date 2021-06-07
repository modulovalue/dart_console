
/// API for the keyboard.
abstract class TerminalKeyboard {
  void handleKey(List<int>? bytes, String? name);

  Stream<String> bindKey(String code);

  Stream<String> bindKeys(List<String> codes);

  void destroy();
}
