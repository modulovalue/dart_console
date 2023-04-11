// ignore_for_file: cancel_subscriptions

import 'dart:async';
import 'dart:convert';
import 'dart:io';

List<StreamSubscription<Object?>> inherit_io({
  required final Process process,
  final String? prefix,
  final bool line_based = true,
}) {
  if (line_based) {
    final stdout_lines = process.stdout
        .transform(
          utf8.decoder,
        )
        .transform(
          const LineSplitter(),
        );
    final sub_a = stdout_lines.listen(
      (final data) {
        if (prefix != null) {
          stdout.write(prefix);
        }
        stdout.writeln(data);
      },
    );
    final stderr_lines = process.stderr
        .transform(
          utf8.decoder,
        )
        .transform(
          const LineSplitter(),
        );
    final sub_b = stderr_lines.listen(
      (final data) {
        if (prefix != null) {
          stderr.write(prefix);
        }
        stderr.writeln(data);
      },
    );
    return [sub_a, sub_b];
  } else {
    final sub_a = process.stdout.listen(
      stdout.add,
    );
    final sub_b = process.stderr.listen(
      stderr.add,
    );
    return [sub_a, sub_b];
  }
}
