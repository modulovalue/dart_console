import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

import 'terminal_lib.dart';

// region public
_SneathTerminalWindowsImpl auto_windows_sneath_terminal() {
  return _SneathTerminalWindowsImpl();
}
// endregion

// region internal
/// Win32-dependent library for interrogating and manipulating the console.
///
/// This class provides raw wrappers for the underlying terminal system calls
/// that are not available through ANSI mode control sequences.
class _SneathTerminalWindowsImpl implements SneathTerminal {
  final int _input_handle;
  final int _output_handle;

  _SneathTerminalWindowsImpl()
      : _output_handle = GetStdHandle(STD_OUTPUT_HANDLE),
        _input_handle = GetStdHandle(STD_INPUT_HANDLE);

  @override
  int get_window_height() {
    final p_buffer_info = calloc<CONSOLE_SCREEN_BUFFER_INFO>();
    try {
      final buffer_info = p_buffer_info.ref;
      GetConsoleScreenBufferInfo(
        _output_handle,
        p_buffer_info,
      );
      final window_height =
          buffer_info.srWindow.Bottom - buffer_info.srWindow.Top + 1;
      return window_height;
    } finally {
      calloc.free(p_buffer_info);
    }
  }

  @override
  int get_window_width() {
    final p_buffer_info = calloc<CONSOLE_SCREEN_BUFFER_INFO>();
    try {
      final buffer_info = p_buffer_info.ref;
      GetConsoleScreenBufferInfo(
        _output_handle,
        p_buffer_info,
      );
      final window_width =
          buffer_info.srWindow.Right - buffer_info.srWindow.Left + 1;
      return window_width;
    } finally {
      calloc.free(p_buffer_info);
    }
  }

  @override
  void enable_raw_mode() {
    SetConsoleMode(
      _input_handle,
      (~ENABLE_ECHO_INPUT) &
          (~ENABLE_ECHO_INPUT) &
          (~ENABLE_PROCESSED_INPUT) &
          (~ENABLE_LINE_INPUT) &
          (~ENABLE_WINDOW_INPUT),
    );
  }

  @override
  void disable_raw_mode() {
    SetConsoleMode(
      _input_handle,
      ENABLE_ECHO_INPUT &
          ENABLE_EXTENDED_FLAGS &
          ENABLE_INSERT_MODE &
          ENABLE_LINE_INPUT &
          ENABLE_MOUSE_INPUT &
          ENABLE_PROCESSED_INPUT &
          ENABLE_QUICK_EDIT_MODE &
          ENABLE_VIRTUAL_TERMINAL_INPUT,
    );
  }

  void hide_cursor() {
    final lp_console_cursor_info = calloc<CONSOLE_CURSOR_INFO>()
      ..ref.bVisible = 0;
    SetConsoleCursorInfo(
      _output_handle,
      lp_console_cursor_info,
    );
    calloc.free(lp_console_cursor_info);
  }

  void show_cursor() {
    final lp_console_cursor_info = calloc<CONSOLE_CURSOR_INFO>()
      ..ref.bVisible = 1;
    SetConsoleCursorInfo(
      _output_handle,
      lp_console_cursor_info,
    );
    calloc.free(lp_console_cursor_info);
  }

  @override
  void clear_screen() {
    final p_buffer_info = calloc<CONSOLE_SCREEN_BUFFER_INFO>();
    final p_chars_written = calloc<Uint32>();
    final origin = calloc<COORD>();
    try {
      final buffer_info = p_buffer_info.ref;
      GetConsoleScreenBufferInfo(
        _output_handle,
        p_buffer_info,
      );
      final console_size = buffer_info.dwSize.X * buffer_info.dwSize.Y;
      FillConsoleOutputCharacter(
        _output_handle,
        ' '.codeUnitAt(0),
        console_size,
        origin.ref,
        p_chars_written,
      );
      GetConsoleScreenBufferInfo(
        _output_handle,
        p_buffer_info,
      );
      FillConsoleOutputAttribute(
        _output_handle,
        buffer_info.wAttributes,
        console_size,
        origin.ref,
        p_chars_written,
      );
      SetConsoleCursorPosition(
        _output_handle,
        origin.ref,
      );
    } finally {
      calloc.free(origin);
      calloc.free(p_chars_written);
      calloc.free(p_buffer_info);
    }
  }

  @override
  void set_cursor_position(
    final int x,
    final int y,
  ) {
    final coord = calloc<COORD>()
      ..ref.X = x
      ..ref.Y = y;
    SetConsoleCursorPosition(
      _output_handle,
      coord.ref,
    );
    calloc.free(coord);
  }
}
// endregion
