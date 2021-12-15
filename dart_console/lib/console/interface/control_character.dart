/// Non-printable characters that can be entered from the keyboard.
// TODO sum type.
// TODO Unknown is not a control character and should be removed. These cases should be handled outside.
// TODO Or perhaps add a supertype where one child is unknown and the other represent all valid control characters.
abstract class ControlCharacters {
  static const ControlCharacterUnknownImpl unknown = ControlCharacterUnknownImpl._();
  static const ControlCharacterCtrlAImpl ctrlA = ControlCharacterCtrlAImpl._();
  static const ControlCharacterCtrlBImpl ctrlB = ControlCharacterCtrlBImpl._();
  static const ControlCharacterCtrlCImpl ctrlC = ControlCharacterCtrlCImpl._(); // Break
  static const ControlCharacterCtrlDImpl ctrlD = ControlCharacterCtrlDImpl._(); // End of File
  static const ControlCharacterCtrlEImpl ctrlE = ControlCharacterCtrlEImpl._();
  static const ControlCharacterCtrlFImpl ctrlF = ControlCharacterCtrlFImpl._();
  static const ControlCharacterCtrlGImpl ctrlG = ControlCharacterCtrlGImpl._(); // Bell
  static const ControlCharacterCtrlHImpl ctrlH = ControlCharacterCtrlHImpl._(); // Backspace
  static const ControlCharacterTabImpl tab = ControlCharacterTabImpl._();
  static const ControlCharacterCtrlJImpl ctrlJ = ControlCharacterCtrlJImpl._();
  static const ControlCharacterCtrlKImpl ctrlK = ControlCharacterCtrlKImpl._();
  static const ControlCharacterCtrlLImpl ctrlL = ControlCharacterCtrlLImpl._();
  static const ControlCharacterEnterImpl enter = ControlCharacterEnterImpl._();
  static const ControlCharacterCtrlNImpl ctrlN = ControlCharacterCtrlNImpl._();
  static const ControlCharacterCtrlOImpl ctrlO = ControlCharacterCtrlOImpl._();
  static const ControlCharacterCtrlPImpl ctrlP = ControlCharacterCtrlPImpl._();
  static const ControlCharacterCtrlQImpl ctrlQ = ControlCharacterCtrlQImpl._();
  static const ControlCharacterCtrlRImpl ctrlR = ControlCharacterCtrlRImpl._();
  static const ControlCharacterCtrlSImpl ctrlS = ControlCharacterCtrlSImpl._();
  static const ControlCharacterCtrlTImpl ctrlT = ControlCharacterCtrlTImpl._();
  static const ControlCharacterCtrlUImpl ctrlU = ControlCharacterCtrlUImpl._();
  static const ControlCharacterCtrlVImpl ctrlV = ControlCharacterCtrlVImpl._();
  static const ControlCharacterCtrlWImpl ctrlW = ControlCharacterCtrlWImpl._();
  static const ControlCharacterCtrlXImpl ctrlX = ControlCharacterCtrlXImpl._();
  static const ControlCharacterCtrlYImpl ctrlY = ControlCharacterCtrlYImpl._();
  static const ControlCharacterCtrlZImpl ctrlZ = ControlCharacterCtrlZImpl._(); // Suspend
  static const ControlCharacterArrowLeftImpl arrowLeft = ControlCharacterArrowLeftImpl._();
  static const ControlCharacterArrowRightImpl arrowRight = ControlCharacterArrowRightImpl._();
  static const ControlCharacterArrowUpImpl arrowUp = ControlCharacterArrowUpImpl._();
  static const ControlCharacterArrowDownImpl arrowDown = ControlCharacterArrowDownImpl._();
  static const ControlCharacterPageUpImpl pageUp = ControlCharacterPageUpImpl._();
  static const ControlCharacterPageDownImpl pageDown = ControlCharacterPageDownImpl._();
  static const ControlCharacterWordLeftImpl wordLeft = ControlCharacterWordLeftImpl._();
  static const ControlCharacterWordRightImpl wordRight = ControlCharacterWordRightImpl._();
  static const ControlCharacterHomeImpl home = ControlCharacterHomeImpl._();
  static const ControlCharacterEndImpl end = ControlCharacterEndImpl._();
  static const ControlCharacterEscapeImpl escape = ControlCharacterEscapeImpl._();
  static const ControlCharacterDeleteImpl delete = ControlCharacterDeleteImpl._();
  static const ControlCharacterBackspaceImpl backspace = ControlCharacterBackspaceImpl._();
  static const ControlCharacterWordBackspaceImpl wordBackspace = ControlCharacterWordBackspaceImpl._();
  static const ControlCharacterF1Impl F1 = ControlCharacterF1Impl._();
  static const ControlCharacterF2Impl F2 = ControlCharacterF2Impl._();
  static const ControlCharacterF3Impl F3 = ControlCharacterF3Impl._();
  static const ControlCharacterF4Impl F4 = ControlCharacterF4Impl._();
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
