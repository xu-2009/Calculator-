import java.util.Locale;

String display = "0";

// Keep the actual value separate from the text shown on screen.
double currentValue = 0;
double firstNumber = 0;
double memoryValue = 0;
String operator = "";

boolean startNewNumber = true;
boolean errorState = false;
boolean memorySet = false;

final int MAX_INPUT_CHARS = 15;
final int MAX_DISPLAY_CHARS = 14;

Button[] buttons;

void setup() {
  size(440, 730);
  textAlign(CENTER, CENTER);
  createButtons();
}

void draw() {
  background(30);
  drawDisplay();
  for (Button b : buttons) {
    b.display();
  }
}

void createButtons() {
  buttons = new Button[25];
  float w = 80;
  float h = 65;
  float gap = 10;
  float x = 40;
  float y = 180;
  int i = 0;

  buttons[i++] = new Button("M+", x, y, w, h);
  buttons[i++] = new Button("M−", x+90, y, w, h);
  buttons[i++] = new Button("MR", x+180, y, w, h);
  buttons[i++] = new Button("MC", x+270, y, w, h);
  y += h + gap;

  buttons[i++] = new Button("AC", x, y, w, h);
  buttons[i++] = new Button("C", x+90, y, w, h);
  buttons[i++] = new Button("+/-", x+180, y, w, h);
  buttons[i++] = new Button("%", x+270, y, w, h);
  y += h + gap;

  buttons[i++] = new Button("7", x, y, w, h);
  buttons[i++] = new Button("8", x+90, y, w, h);
  buttons[i++] = new Button("9", x+180, y, w, h);
  buttons[i++] = new Button("÷", x+270, y, w, h);
  y += h + gap;

  buttons[i++] = new Button("4", x, y, w, h);
  buttons[i++] = new Button("5", x+90, y, w, h);
  buttons[i++] = new Button("6", x+180, y, w, h);
  buttons[i++] = new Button("×", x+270, y, w, h);
  y += h + gap;

  buttons[i++] = new Button("1", x, y, w, h);
  buttons[i++] = new Button("2", x+90, y, w, h);
  buttons[i++] = new Button("3", x+180, y, w, h);
  buttons[i++] = new Button("-", x+270, y, w, h);
  y += h + gap;

  buttons[i++] = new Button("0", x, y, w, h);
  buttons[i++] = new Button(".", x+90, y, w, h);
  buttons[i++] = new Button("⌫", x+180, y, w, h);
  buttons[i++] = new Button("+", x+270, y, w, h);
  y += h + gap;

  buttons[i++] = new Button("=", x, y, 350, h);
}

void drawDisplay() {
  fill(15);
  stroke(80);
  strokeWeight(2);
  rect(40, 40, 350, 110, 15);
  fill(255);
  textAlign(RIGHT, CENTER);
  String shown = errorState ? "Error" : display;
  textSize(shown.length() > 10 ? 24 : 38);
  while (textWidth(shown) > 320 && textSize > 16) {
    textSize(textSize - 2);
  }
  text(shown, 375, 95);
  textAlign(CENTER, CENTER);
}

void mousePressed() {
  for (Button b : buttons) {
    if (b.isClicked(mouseX, mouseY)) {
      handleButton(b.label);
      return;
    }
  }
}

// Keyboard and mouse use the same action handler.
void keyPressed() {
  if (key >= '0' && key <= '9') {
    handleButton(str(key));
  } else if (key == '.') {
    handleButton(".");
  } else if (key == '+') {
    handleButton("+");
  } else if (key == '-') {
    handleButton("-");
  } else if (key == '*') {
    handleButton("×");
  } else if (key == '/') {
    handleButton("÷");
  } else if (key == '=' || key == ENTER || key == RETURN) {
    handleButton("=");
  } else if (key == 'c' || key == 'C' || key == BACKSPACE || key == DELETE) {
    handleButton("C");
  }
}

void handleButton(String action) {
  if (errorState) {
    if (isNumber(action) || action.equals(".")) {
      clearAll();
    } else if (!action.equals("AC") && !action.equals("C")) {
      return;
    }
  }

  if (isNumber(action)) {
    inputNumber(action);
  } else if (action.equals(".")) {
    inputDecimal();
  } else if (action.equals("+") || action.equals("-") || action.equals("×") || action.equals("÷")) {
    chooseOperator(action);
  } else if (action.equals("=")) {
    equalsPressed();
  } else if (action.equals("AC")) {
    clearAll();
  } else if (action.equals("C")) {
    currentValue = 0;
    display = "0";
    startNewNumber = true;
    errorState = false;
  } else if (action.equals("+/-")) {
    toggleSign();
  } else if (action.equals("%")) {
    percent();
  } else if (action.equals("⌫")) {
    backspace();
  } else if (action.equals("M+")) {
    memoryValue += currentValue;
    memorySet = true;
  } else if (action.equals("M−") || action.equals("M-")) {
    memoryValue -= currentValue;
    memorySet = true;
  } else if (action.equals("MR")) {
    currentValue = memorySet ? memoryValue : 0;
    display = displayFor(currentValue);
    startNewNumber = false;
  } else if (action.equals("MC")) {
    memoryValue = 0;
    memorySet = false;
  }
}

void inputNumber(String number) {
  String digit = number;
  if (startNewNumber || display.equals("0")) {
    display = digit;
    currentValue = Double.parseDouble(display);
    startNewNumber = false;
  } else if (display.length() < MAX_INPUT_CHARS) {
    display += digit;
    currentValue = Double.parseDouble(display);
  }
}

void inputDecimal() {
  if (startNewNumber) {
    display = "0.";
    currentValue = 0;
    startNewNumber = false;
  } else if (!display.contains(".") && display.length() < MAX_INPUT_CHARS) {
    display += ".";
  }
}

void chooseOperator(String newOperator) {
  if (!operator.equals("") && !startNewNumber) {
    performCalc(currentValue);
    if (errorState) return;
  }
  firstNumber = currentValue;
  operator = newOperator;
  startNewNumber = true;
}

void equalsPressed() {
  if (operator.equals("")) return;
  performCalc(currentValue);
  if (!errorState) {
    operator = "";
    startNewNumber = true;
  }
}

void performCalc(double secondNumber) {
  double result;
  if (operator.equals("+")) result = firstNumber + secondNumber;
  else if (operator.equals("-")) result = firstNumber - secondNumber;
  else if (operator.equals("×")) result = firstNumber * secondNumber;
  else if (operator.equals("÷")) {
    if (secondNumber == 0) {
      display = "Error";
      errorState = true;
      operator = "";
      return;
    }
    result = firstNumber / secondNumber;
  } else return;

  if (Double.isNaN(result) || Double.isInfinite(result)) {
    display = "Error";
    errorState = true;
    operator = "";
    return;
  }
  currentValue = result;
  display = displayFor(currentValue);
  firstNumber = result;
}

void toggleSign() {
  if (display.equals("0")) return;
  currentValue = -currentValue;
  if (display.startsWith("-")) display = display.substring(1);
  else display = "-" + display;
}

void percent() {
  currentValue = currentValue / 100.0;
  display = displayFor(currentValue);
}

void backspace() {
  if (startNewNumber) return;
  if (display.length() > 1) {
    display = display.substring(0, display.length()-1);
    if (display.equals("-") || display.equals("")) display = "0";
  } else {
    display = "0";
    startNewNumber = true;
  }
  currentValue = Double.parseDouble(display);
}

void clearAll() {
  currentValue = 0;
  firstNumber = 0;
  operator = "";
  display = "0";
  startNewNumber = true;
  errorState = false;
}

boolean isNumber(String value) {
  return value.length() == 1 && value.charAt(0) >= '0' && value.charAt(0) <= '9';
}

// Compact values for display while keeping currentValue unrounded for calculations.
String displayFor(double value) {
  if (Double.isNaN(value) || Double.isInfinite(value)) return "Error";
  if (value == 0) return "0";

  String result;
  if (Math.abs(value) >= 1.0e12 || Math.abs(value) < 1.0e-7) {
    result = String.format(Locale.US, "%.6g", value);
  } else {
    result = String.format(Locale.US, "%.9g", value);
    if (!result.contains("E") && result.contains(".")) {
      result = trimTrailingZeros(result);
    }
  }

  // Keep the complete display text within the chosen character limit.
  if (result.length() > MAX_DISPLAY_CHARS) {
    result = String.format(Locale.US, "%.5g", value);
  }
  return result;
}

String trimTrailingZeros(String value) {
  while (value.contains(".") && value.endsWith("0")) {
    value = value.substring(0, value.length()-1);
  }
  if (value.endsWith(".")) value = value.substring(0, value.length()-1);
  return value;
}
