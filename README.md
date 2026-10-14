# Calculator Project

A simple calculator built with Processing for Computer Programming 1.

## Features

- Mouse and keyboard input use the same calculator logic.
- Addition, subtraction, multiplication, and division.
- Decimal input, sign toggle, percent, backspace, clear, and all clear.
- Calculator memory: M+, M−, MR, and MC.
- Handles division by zero with an error display.
- Limits typed input length and formats long results for the display.

## Run

1. Open `calculator2_2.pde` in Processing. Keep `Button.pde` in the same sketch folder.
2. Run the sketch.

## Controls

| Key | Action |
|---|---|
| `0`–`9` | Enter a digit |
| `.` | Enter a decimal point |
| `+`, `-`, `*`, `/` | Select an operation |
| `Enter` or `=` | Calculate |
| `C` | Clear the current entry |
| Mouse click | Use the on-screen buttons, including memory controls |

## Memory buttons

- **M+** adds the displayed value to memory.
- **M−** subtracts the displayed value from memory.
- **MR** recalls the memory value for display and continued calculation.
- **MC** clears memory.

`C` and `AC` clear calculator state without clearing memory; use `MC` to clear memory.

## Notes

The percent button divides the current value by 100. The display may round or use scientific notation for long values while calculations retain the stored numeric value.
