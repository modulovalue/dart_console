/// Non-printable characters that can be entered from the keyboard.
/// TODO this should be an adt.
/// TODO make ControlKey depend on the interface of that adt.
enum ControlCharacter {
  none,
  ctrlA,
  ctrlB,
  ctrlC, // Break
  ctrlD, // End of File
  ctrlE,
  ctrlF,
  ctrlG, // Bell
  ctrlH, // Backspace
  tab,
  ctrlJ,
  ctrlK,
  ctrlL,
  enter,
  ctrlN,
  ctrlO,
  ctrlP,
  ctrlQ,
  ctrlR,
  ctrlS,
  ctrlT,
  ctrlU,
  ctrlV,
  ctrlW,
  ctrlX,
  ctrlY,
  ctrlZ, // Suspend
  arrowLeft,
  arrowRight,
  arrowUp,
  arrowDown,
  pageUp,
  pageDown,
  wordLeft,
  wordRight,
  home,
  end,
  escape,
  delete,
  backspace,
  wordBackspace,
  F1,
  F2,
  F3,
  F4,
  unknown
}
