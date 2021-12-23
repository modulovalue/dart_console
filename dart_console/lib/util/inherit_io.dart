import 'dart:convert';
import 'dart:io';

void inheritIO(
  final Process process, {
  final String? prefix,
  final bool lineBased = true,
}) {
  if (lineBased) {
    final utf8Stdout = process.stdout.transform(utf8.decoder);
    final stdoutLines = utf8Stdout.transform(const LineSplitter());
    stdoutLines.listen(
      (final data) {
        if (prefix != null) {
          stdout.write(prefix);
        }
        stdout.writeln(data);
      },
    );
    final utf8stderr = process.stderr.transform(utf8.decoder);
    final stderrLines = utf8stderr.transform(const LineSplitter());
    stderrLines.listen(
      (final data) {
        if (prefix != null) {
          stderr.write(prefix);
        }
        stderr.writeln(data);
      },
    );
  } else {
    process.stdout.listen(
      (final data) => stdout.add(data),
    );
    process.stderr.listen(
      (final data) => stderr.add(data),
    );
  }
}
