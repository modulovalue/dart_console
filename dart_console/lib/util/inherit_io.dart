import 'dart:convert';
import 'dart:io';

void inheritIO(
  final Process process, {
  final String? prefix,
  final bool lineBased = true,
}) {
  if (lineBased) {
    final stdoutLines = process.stdout.transform(utf8.decoder).transform(const LineSplitter());
    stdoutLines.listen(
      (final data) {
        if (prefix != null) {
          stdout.write(prefix);
        }
        stdout.writeln(data);
      },
    );
    final stderrLines = process.stderr.transform(utf8.decoder).transform(const LineSplitter());
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
