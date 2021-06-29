import 'dart:ffi';
import 'dart:io';

import 'package:dart_ansi/ansi.dart';
import 'package:ffi/ffi.dart';

import '../../interface/terminal_lib.dart';

/// glibc-dependent library for interrogating and manipulating the console.
///
/// This class provides raw wrappers for the underlying terminal system calls
/// that are not available through ANSI mode control sequences, and is not
/// designed to be called directly. Package consumers should normally use the
/// `Console` class to call these methods.
class SneathTerminalUnixImpl implements SneathTerminal {
  final DynamicLibrary stdlib;
  final Pointer<TermIOS> origTermIOSPointer;
  final IOCTL_Dart ioctl;
  final TERMIOS_tcgetattrDart tcgetattr;
  final TERMIOS_tcsetattrDart tcsetattr;

  factory SneathTerminalUnixImpl() {
    final _stdlib = Platform.isMacOS ? DynamicLibrary.open('/usr/lib/libSystem.dylib') : DynamicLibrary.open('libc.so.6');
    final _tcgetattr = _stdlib.lookupFunction<TERMIOS_tcgetattrNative, TERMIOS_tcgetattrDart>('tcgetattr');
    final _origTermIOSPointer = calloc<TermIOS>();
    _tcgetattr(UnistdConstants.STDIN_FILENO, _origTermIOSPointer);
    return SneathTerminalUnixImpl._(
      stdlib: _stdlib,
      origTermIOSPointer: _origTermIOSPointer,
      ioctl: _stdlib.lookupFunction<IOCTL_Native, IOCTL_Dart>('ioctl'),
      tcgetattr: _tcgetattr,
      tcsetattr: _stdlib.lookupFunction<TERMIOS_tcsetattrNative, TERMIOS_tcsetattrDart>('tcsetattr'),
    );
  }

  const SneathTerminalUnixImpl._({
    required this.stdlib,
    required this.origTermIOSPointer,
    required this.ioctl,
    required this.tcgetattr,
    required this.tcsetattr,
  });

  @override
  int getWindowHeight() {
    final winSizePointer = calloc<IOCTL_WinSize>();
    final result = ioctl(UnistdConstants.STDOUT_FILENO, IOCTL_TIOCGWINSZ, winSizePointer.cast());
    if (result == -1) {
      return -1;
    } else {
      final winSize = winSizePointer.ref;
      if (winSize.ws_row == 0) {
        return -1;
      } else {
        final result = winSize.ws_row;
        calloc.free(winSizePointer);
        return result;
      }
    }
  }

  @override
  int getWindowWidth() {
    final winSizePointer = calloc<IOCTL_WinSize>();
    final result = ioctl(UnistdConstants.STDOUT_FILENO, IOCTL_TIOCGWINSZ, winSizePointer.cast());
    if (result == -1) {
      return -1;
    } else {
      final winSize = winSizePointer.ref;
      if (winSize.ws_col == 0) {
        return -1;
      } else {
        final result = winSize.ws_col;
        calloc.free(winSizePointer);
        return result;
      }
    }
  }

  @override
  void enableRawMode() {
    final _origTermIOS = origTermIOSPointer.ref;
    final newTermIOSPointer = calloc<TermIOS>();
    final newTermIOS = newTermIOSPointer.ref;
    newTermIOS.c_iflag = _origTermIOS.c_iflag &
        ~(TermiosConstants.BRKINT | TermiosConstants.ICRNL | TermiosConstants.INPCK | TermiosConstants.ISTRIP | TermiosConstants.IXON);
    newTermIOS.c_oflag = _origTermIOS.c_oflag & ~TermiosConstants.OPOST;
    newTermIOS.c_cflag = _origTermIOS.c_cflag | TermiosConstants.CS8;
    newTermIOS.c_lflag =
        _origTermIOS.c_lflag & ~(TermiosConstants.ECHO | TermiosConstants.ICANON | TermiosConstants.IEXTEN | TermiosConstants.ISIG);
    newTermIOS.c_cc0 = _origTermIOS.c_cc0;
    newTermIOS.c_cc1 = _origTermIOS.c_cc1;
    newTermIOS.c_cc2 = _origTermIOS.c_cc2;
    newTermIOS.c_cc3 = _origTermIOS.c_cc3;
    newTermIOS.c_cc4 = _origTermIOS.c_cc4;
    newTermIOS.c_cc5 = _origTermIOS.c_cc5;
    newTermIOS.c_cc6 = _origTermIOS.c_cc6;
    newTermIOS.c_cc7 = _origTermIOS.c_cc7;
    newTermIOS.c_cc8 = _origTermIOS.c_cc8;
    newTermIOS.c_cc9 = _origTermIOS.c_cc9;
    newTermIOS.c_cc10 = _origTermIOS.c_cc10;
    newTermIOS.c_cc11 = _origTermIOS.c_cc11;
    newTermIOS.c_cc12 = _origTermIOS.c_cc12;
    newTermIOS.c_cc13 = _origTermIOS.c_cc13;
    newTermIOS.c_cc14 = _origTermIOS.c_cc14;
    newTermIOS.c_cc15 = _origTermIOS.c_cc15;
    newTermIOS.c_cc16 = 0; // VMIN -- return each byte, or 0 for timeout
    newTermIOS.c_cc17 = 1; // VTIME -- 100ms timeout (unit is 1/10s)
    newTermIOS.c_cc18 = _origTermIOS.c_cc18;
    newTermIOS.c_cc19 = _origTermIOS.c_cc19;
    newTermIOS.c_ispeed = _origTermIOS.c_ispeed;
    newTermIOS.c_oflag = _origTermIOS.c_ospeed;
    tcsetattr(UnistdConstants.STDIN_FILENO, TermiosConstants.TCSAFLUSH, newTermIOSPointer);
    calloc.free(newTermIOSPointer);
  }

  @override
  void disableRawMode() {
    if (nullptr != origTermIOSPointer.cast()) {
      tcsetattr(UnistdConstants.STDIN_FILENO, TermiosConstants.TCSAFLUSH, origTermIOSPointer);
    }
  }

  @override
  void clearScreen() => stdout.write(ansiEraseInDisplayAll + ansiResetCursorPosition);

  @override
  void setCursorPosition(int col, int row) => stdout.write(ansiCursorPositionTo(row + 1, col + 1));
}

final IOCTL_TIOCGWINSZ = Platform.isMacOS ? 0x40087468 : 0x5413;

// struct winsize {
// 	unsigned short  ws_row;         /* rows, in characters */
// 	unsigned short  ws_col;         /* columns, in characters */
// 	unsigned short  ws_xpixel;      /* horizontal size, pixels */
// 	unsigned short  ws_ypixel;      /* vertical size, pixels */
// };
class IOCTL_WinSize extends Struct {
  @Int16()
  external int ws_row;

  @Int16()
  external int ws_col;

  @Int16()
  external int ws_xpixel;

  @Int16()
  external int ws_ypixel;
}

// int ioctl(int, unsigned long, ...);
typedef IOCTL_Native = Int32 Function(Int32, Int64, Pointer<Void>);
typedef IOCTL_Dart = int Function(int, int, Pointer<Void>);

abstract class TermiosConstants {
  // INPUT FLAGS
  static const int IGNBRK = 0x00000001; // ignore BREAK condition
  static const int BRKINT = 0x00000002; // map BREAK to SIGINTR
  static const int IGNPAR = 0x00000004; // ignore (discard) parity errors
  static const int PARMRK = 0x00000008; // mark parity and framing errors
  static const int INPCK = 0x00000010; // enable checking of parity errors
  static const int ISTRIP = 0x00000020; // strip 8th bit off chars
  static const int INLCR = 0x00000040; // map NL into CR
  static const int IGNCR = 0x00000080; // ignore CR
  static const int ICRNL = 0x00000100; // map CR to NL (ala CRMOD)
  static const int IXON = 0x00000200; // enable output flow control
  static const int IXOFF = 0x00000400; // enable input flow control
  static const int IXANY = 0x00000800; // any char will restart after stop
  static const int IMAXBEL = 0x00002000; // ring bell on input queue full
  static const int IUTF8 = 0x00004000; // maintain state for UTF-8 VERASE
  // OUTPUT FLAGS
  static const int OPOST = 0x00000001; // enable following output processing
  static const int ONLCR = 0x00000002; // map NL to CR-NL (ala CRMOD)
  static const int OXTABS = 0x00000004; // expand tabs to spaces
  static const int ONOEOT = 0x00000008; // discard EOT's (^D) on output)
  // CONTROL FLAGS
  static const int CIGNORE = 0x00000001; // ignore control flags
  static const int CSIZE = 0x00000300; // character size mask
  static const int CS5 = 0x00000000; // 5 bits (pseudo)
  static const int CS6 = 0x00000100; // 6 bits
  static const int CS7 = 0x00000200; // 7 bits
  static const int CS8 = 0x00000300; // 8 bits
  // LOCAL FLAGS
  static const int ECHOKE = 0x00000001; // visual erase for line kill
  static const int ECHOE = 0x00000002; // visually erase chars
  static const int ECHOK = 0x00000004; // echo NL after line kill
  static const int ECHO = 0x00000008; // enable echoing
  static const int ECHONL = 0x00000010; // echo NL even if ECHO is off
  static const int ECHOPRT = 0x00000020; // visual erase mode for hardcopy
  static const int ECHOCTL = 0x00000040; // echo control chars as ^(Char)
  static const int ISIG = 0x00000080; // enable signals INTR, QUIT, [D]SUSP
  static const int ICANON = 0x00000100; // canonicalize input lines
  static const int ALTWERASE = 0x00000200; // use alternate WERASE algorithm
  static const int IEXTEN = 0x00000400; // enable DISCARD and LNEXT
  static const int EXTPROC = 0x00000800; // external processing
  static const int TOSTOP = 0x00400000; // stop background jobs from output
  static const int FLUSHO = 0x00800000; // output being flushed (state)
  static const int NOKERNINFO = 0x02000000; // no kernel output from VSTATUS
  static const int PENDIN = 0x20000000; // XXX retype pending input (state)
  static const int NOFLSH = 0x80000000; // don't flush after interrupt
  static const int TCSANOW = 0; // make change immediate
  static const int TCSADRAIN = 1; // drain output, then change
  static const int TCSAFLUSH = 2; // drain output, flush input
  static const int VMIN = 16; // minimum number of characters to receive
  static const int VTIME = 17; // time in 1/10s before returning
}

// typedef unsigned long   tcflag_t;
// typedef unsigned char   cc_t;
// typedef unsigned long   speed_t;
// #define NCCS            20

// struct termios {
// 	tcflag_t        c_iflag;        /* input flags */
// 	tcflag_t        c_oflag;        /* output flags */
// 	tcflag_t        c_cflag;        /* control flags */
// 	tcflag_t        c_lflag;        /* local flags */
// 	cc_t            c_cc[NCCS];     /* control chars */
// 	speed_t         c_ispeed;       /* input speed */
// 	speed_t         c_ospeed;       /* output speed */
// };
class TermIOS extends Struct {
  @Int64()
  external int c_iflag;
  @Int64()
  external int c_oflag;
  @Int64()
  external int c_cflag;
  @Int64()
  external int c_lflag;

  // This replaces c_cc[20]
  @Int8()
  external int c_cc0;
  @Int8()
  external int c_cc1;
  @Int8()
  external int c_cc2;
  @Int8()
  external int c_cc3;
  @Int8()
  external int c_cc4;
  @Int8()
  external int c_cc5;
  @Int8()
  external int c_cc6;
  @Int8()
  external int c_cc7;
  @Int8()
  external int c_cc8;
  @Int8()
  external int c_cc9;
  @Int8()
  external int c_cc10;
  @Int8()
  external int c_cc11;
  @Int8()
  external int c_cc12;
  @Int8()
  external int c_cc13;
  @Int8()
  external int c_cc14;
  @Int8()
  external int c_cc15;
  @Int8()
  external int c_cc16; // VMIN
  @Int8()
  external int c_cc17; // VTIME
  @Int8()
  external int c_cc18;
  @Int8()
  external int c_cc19;
  @Int64()
  external int c_ispeed;
  @Int64()
  external int c_ospeed;
}

// int tcgetattr(int, struct termios *);
typedef TERMIOS_tcgetattrNative = Int32 Function(Int32 fildes, Pointer<TermIOS> termios);
typedef TERMIOS_tcgetattrDart = int Function(int fildes, Pointer<TermIOS> termios);

// int tcsetattr(int, int, const struct termios *);
typedef TERMIOS_tcsetattrNative = Int32 Function(Int32 fildes, Int32 optional_actions, Pointer<TermIOS> termios);
typedef TERMIOS_tcsetattrDart = int Function(int fildes, int optional_actions, Pointer<TermIOS> termios);

abstract class UnistdConstants {
  static const STDIN_FILENO = 0;
  static const STDOUT_FILENO = 1;
  static const STDERR_FILENO = 2;
}
