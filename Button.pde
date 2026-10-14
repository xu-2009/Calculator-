class Button {
  String label;
  float x;
  float y;
  float w;
  float h;

  Button(String tempLabel, float tempX, float tempY, float tempW, float tempH) {
    label = tempLabel;
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
  }

  void display() {
    if (label.equals("+") || label.equals("-") || label.equals("×") ||
        label.equals("÷") || label.equals("=")) {
      fill(255, 150, 30);
    } else if (label.equals("AC") || label.equals("C") || label.equals("+/-") ||
               label.equals("%") || label.equals("M+") || label.equals("M−") ||
               label.equals("MR") || label.equals("MC") || label.equals("⌫")) {
      fill(120);
    } else {
      fill(65);
    }

    stroke(100);
    strokeWeight(1);
    rect(x, y, w, h, 12);
    fill(255);
    textSize(label.length() > 2 ? 17 : 22);
    textAlign(CENTER, CENTER);
    text(label, x + w/2, y + h/2);
  }

  boolean isClicked(float mx, float my) {
    return mx >= x && mx <= x+w && my >= y && my <= y+h;
  }
}
