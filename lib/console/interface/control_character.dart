/// Non-printable characters that can be entered from the keyboard.
/// TODO collapse control characters into a subclass of key?
// Unknown is not a control character and should be removed. These cases should be handled outside.
// Or perhaps add a supertype where one child is unknown and the other represents all valid control characters.
abstract class ControlCharacters {
  static const unknown = ControlCharacterUnknownImpl._();
  static const ctrlA = ControlCharacterCtrlAImpl._();
  static const ctrlB = ControlCharacterCtrlBImpl._();
  static const ctrlC = ControlCharacterCtrlCImpl._(); // Break
  static const ctrlD = ControlCharacterCtrlDImpl._(); // End of File
  static const ctrlE = ControlCharacterCtrlEImpl._();
  static const ctrlF = ControlCharacterCtrlFImpl._();
  static const ctrlG = ControlCharacterCtrlGImpl._(); // Bell
  static const ctrlH = ControlCharacterCtrlHImpl._(); // Backspace
  static const tab = ControlCharacterTabImpl._();
  static const ctrlJ = ControlCharacterCtrlJImpl._();
  static const ctrlK = ControlCharacterCtrlKImpl._();
  static const ctrlL = ControlCharacterCtrlLImpl._();
  static const enter = ControlCharacterEnterImpl._();
  static const ctrlN = ControlCharacterCtrlNImpl._();
  static const ctrlO = ControlCharacterCtrlOImpl._();
  static const ctrlP = ControlCharacterCtrlPImpl._();
  static const ctrlQ = ControlCharacterCtrlQImpl._();
  static const ctrlR = ControlCharacterCtrlRImpl._();
  static const ctrlS = ControlCharacterCtrlSImpl._();
  static const ctrlT = ControlCharacterCtrlTImpl._();
  static const ctrlU = ControlCharacterCtrlUImpl._();
  static const ctrlV = ControlCharacterCtrlVImpl._();
  static const ctrlW = ControlCharacterCtrlWImpl._();
  static const ctrlX = ControlCharacterCtrlXImpl._();
  static const ctrlY = ControlCharacterCtrlYImpl._();
  static const ctrlZ = ControlCharacterCtrlZImpl._(); // Suspend
  static const arrowLeft = ControlCharacterArrowLeftImpl._();
  static const arrowRight = ControlCharacterArrowRightImpl._();
  static const arrowUp = ControlCharacterArrowUpImpl._();
  static const arrowDown = ControlCharacterArrowDownImpl._();
  static const pageUp = ControlCharacterPageUpImpl._();
  static const pageDown = ControlCharacterPageDownImpl._();
  static const wordLeft = ControlCharacterWordLeftImpl._();
  static const wordRight = ControlCharacterWordRightImpl._();
  static const home = ControlCharacterHomeImpl._();
  static const end = ControlCharacterEndImpl._();
  static const escape = ControlCharacterEscapeImpl._();
  static const delete = ControlCharacterDeleteImpl._();
  static const backspace = ControlCharacterBackspaceImpl._();
  static const wordBackspace = ControlCharacterWordBackspaceImpl._();
  static const F1 = ControlCharacterF1Impl._();
  static const F2 = ControlCharacterF2Impl._();
  static const F3 = ControlCharacterF3Impl._();
  static const F4 = ControlCharacterF4Impl._();
}

abstract class ControlCharacter {}

class ControlCharacterCtrlAImpl implements ControlCharacter {
  const ControlCharacterCtrlAImpl._();
}

class ControlCharacterCtrlBImpl implements ControlCharacter {
  const ControlCharacterCtrlBImpl._();
}

class ControlCharacterCtrlCImpl implements ControlCharacter {
  const ControlCharacterCtrlCImpl._();
}

class ControlCharacterCtrlDImpl implements ControlCharacter {
  const ControlCharacterCtrlDImpl._();
}

class ControlCharacterCtrlEImpl implements ControlCharacter {
  const ControlCharacterCtrlEImpl._();
}

class ControlCharacterCtrlFImpl implements ControlCharacter {
  const ControlCharacterCtrlFImpl._();
}

class ControlCharacterCtrlGImpl implements ControlCharacter {
  const ControlCharacterCtrlGImpl._();
}

class ControlCharacterCtrlHImpl implements ControlCharacter {
  const ControlCharacterCtrlHImpl._();
}

class ControlCharacterTabImpl implements ControlCharacter {
  const ControlCharacterTabImpl._();
}

class ControlCharacterCtrlJImpl implements ControlCharacter {
  const ControlCharacterCtrlJImpl._();
}

class ControlCharacterCtrlKImpl implements ControlCharacter {
  const ControlCharacterCtrlKImpl._();
}

class ControlCharacterCtrlLImpl implements ControlCharacter {
  const ControlCharacterCtrlLImpl._();
}

class ControlCharacterEnterImpl implements ControlCharacter {
  const ControlCharacterEnterImpl._();
}

class ControlCharacterCtrlNImpl implements ControlCharacter {
  const ControlCharacterCtrlNImpl._();
}

class ControlCharacterCtrlOImpl implements ControlCharacter {
  const ControlCharacterCtrlOImpl._();
}

class ControlCharacterCtrlPImpl implements ControlCharacter {
  const ControlCharacterCtrlPImpl._();
}

class ControlCharacterCtrlQImpl implements ControlCharacter {
  const ControlCharacterCtrlQImpl._();
}

class ControlCharacterCtrlRImpl implements ControlCharacter {
  const ControlCharacterCtrlRImpl._();
}

class ControlCharacterCtrlSImpl implements ControlCharacter {
  const ControlCharacterCtrlSImpl._();
}

class ControlCharacterCtrlTImpl implements ControlCharacter {
  const ControlCharacterCtrlTImpl._();
}

class ControlCharacterCtrlUImpl implements ControlCharacter {
  const ControlCharacterCtrlUImpl._();
}

class ControlCharacterCtrlVImpl implements ControlCharacter {
  const ControlCharacterCtrlVImpl._();
}

class ControlCharacterCtrlWImpl implements ControlCharacter {
  const ControlCharacterCtrlWImpl._();
}

class ControlCharacterCtrlXImpl implements ControlCharacter {
  const ControlCharacterCtrlXImpl._();
}

class ControlCharacterCtrlYImpl implements ControlCharacter {
  const ControlCharacterCtrlYImpl._();
}

class ControlCharacterCtrlZImpl implements ControlCharacter {
  const ControlCharacterCtrlZImpl._();
}

class ControlCharacterArrowUpImpl implements ControlCharacter {
  const ControlCharacterArrowUpImpl._();
}

class ControlCharacterArrowDownImpl implements ControlCharacter {
  const ControlCharacterArrowDownImpl._();
}

class ControlCharacterArrowRightImpl implements ControlCharacter {
  const ControlCharacterArrowRightImpl._();
}

class ControlCharacterArrowLeftImpl implements ControlCharacter {
  const ControlCharacterArrowLeftImpl._();
}

class ControlCharacterPageUpImpl implements ControlCharacter {
  const ControlCharacterPageUpImpl._();
}

class ControlCharacterPageDownImpl implements ControlCharacter {
  const ControlCharacterPageDownImpl._();
}

class ControlCharacterWordLeftImpl implements ControlCharacter {
  const ControlCharacterWordLeftImpl._();
}

class ControlCharacterWordRightImpl implements ControlCharacter {
  const ControlCharacterWordRightImpl._();
}

class ControlCharacterHomeImpl implements ControlCharacter {
  const ControlCharacterHomeImpl._();
}

class ControlCharacterEndImpl implements ControlCharacter {
  const ControlCharacterEndImpl._();
}

class ControlCharacterEscapeImpl implements ControlCharacter {
  const ControlCharacterEscapeImpl._();
}

class ControlCharacterDeleteImpl implements ControlCharacter {
  const ControlCharacterDeleteImpl._();
}

class ControlCharacterBackspaceImpl implements ControlCharacter {
  const ControlCharacterBackspaceImpl._();
}

class ControlCharacterWordBackspaceImpl implements ControlCharacter {
  const ControlCharacterWordBackspaceImpl._();
}

class ControlCharacterF1Impl implements ControlCharacter {
  const ControlCharacterF1Impl._();
}

class ControlCharacterF2Impl implements ControlCharacter {
  const ControlCharacterF2Impl._();
}

class ControlCharacterF3Impl implements ControlCharacter {
  const ControlCharacterF3Impl._();
}

class ControlCharacterF4Impl implements ControlCharacter {
  const ControlCharacterF4Impl._();
}

class ControlCharacterUnknownImpl implements ControlCharacter {
  const ControlCharacterUnknownImpl._();
}
