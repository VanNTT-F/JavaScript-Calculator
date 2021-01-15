//background
var screenX = 500, screenY = 500;
size(screenX, screenY, 0);
background(0, 0, 140);

//Buttons' position(4 rows & 5 columns)
var row1Y = screenY / 3.6, row2Y = screenY / 2.25, row3Y = screenY / 1.64, row4Y = screenY / 1.29;
var col1X = screenX / 16, col2X = screenX / 4.2, col3X = screenX / 2.4, col4X = screenX / 1.6, col5X = screenX / 1.25;
var btnWidth = screenX / 7, btnHeight = screenY / 7;

//math input variables
var input = ""; //this var takes a number value of the current onClick button
var inputAccum = ""; // this var accumulates number values from input var
var num1 = "", num2 = "", result = "", cal = ""; //these vars store contants, operators and result of the calculation


//Button object constructor
var Button = function (config) {
    this.x = config.x;
    this.y = config.y;
    this.width = config.width;
    this.height =  config.height;
    this.label = config.label;
};

//buttons instances
var btn7 = new Button({x: col1X, y: row1Y, width: btnWidth, height: btnHeight, label: "7"});
var btn8 = new Button({x: col2X, y: row1Y, width: btnWidth, height: btnHeight, label: "8"});
var btn9 = new Button({x: col3X, y: row1Y, width: btnWidth, height: btnHeight, label: "9"});
var btnDivide = new Button({x: col4X, y: row1Y, width: btnWidth, height: btnHeight, label: "/"});
var btnPercent = new Button({x: col5X, y: row1Y, width: btnWidth, height: btnHeight, label: "%"});

var btn4 = new Button({x: col1X, y: row2Y, width: btnWidth, height: btnHeight, label: "4"});
var btn5 = new Button({x: col2X, y: row2Y, width: btnWidth, height: btnHeight, label: "5"});
var btn6 = new Button({x: col3X, y: row2Y, width: btnWidth, height: btnHeight, label: "6"});
var btnMultiply = new Button({x: col4X, y: row2Y, width: btnWidth, height: btnHeight, label: "x"});
var btnSquare = new Button({x: col5X, y: row2Y, width: btnWidth, height: btnHeight, label: "()\u00B2"});

var btn1 = new Button({x: col1X, y: row3Y, width: btnWidth, height: btnHeight, label: "1"});
var btn2 = new Button({x: col2X, y: row3Y, width: btnWidth, height: btnHeight, label: "2"});
var btn3 = new Button({x: col3X, y: row3Y, width: btnWidth, height: btnHeight, label: "3"});
var btnMinus = new Button({x: col4X, y: row3Y, width: btnWidth, height: btnHeight, label: "-"});
var btnSqrt = new Button({x: col5X, y: row3Y, width: btnWidth, height: btnHeight, label: "\u221A"});

var btn0 = new Button({x: col1X, y: row4Y, width: btnWidth, height: btnHeight, label: "0"});
var btnClear = new Button({x: col2X, y: row4Y, width: btnWidth, height: btnHeight, label: "C",});
var btnEqual = new Button({x: col3X, y: row4Y, width: btnWidth, height: btnHeight, label: "="});
var btnPlus = new Button({x: col4X, y: row4Y, width: btnWidth, height: btnHeight, label: "+"});
var btnLog = new Button({x: col5X, y: row4Y, width: btnWidth, height: btnHeight, label: "ln"});

//Button draw prototype
Button.prototype.draw = function() {
    fill(110, 110, 110);
    rect(this.x, this.y, this.width, this.height, 5);
    fill(255, 255, 255);
    textSize(screenX/12);
    textAlign(CENTER, CENTER);
    text(this.label, this.x + screenX/14, this.y + screenY/14);
};

//Check if mouse is inside the Buttons
Button.prototype.isMouseInside = function () {
  return mouseX > this.x &&
         mouseX < this.x + this.width &&
         mouseY > this.y &&
         mouseY < this.y + this.height;
};

/*Format the result number. If number has decimal round up to 4 digits*/
var resultFormat = function() {
if (Number.isInteger(result)) {}
  else {result = result.toFixed(4);}
};

/*Button onClick prototype event: main calculation algorithm.

  The input variable will take only current clicked button's label .
  The inputAccum will adding up all those input values up to the operators are clicked.
  For %, ^2, sqrt, log operators (only one contant), results will be showed when click those operators' buttons.
  For +, - , x, / operators (2 contants), result will be showed when click "=" button.

  When operators are clicked, the num1 constant will take the 1st inputAccum value.
  The inputAccum will be reset to empty and continue to adding up input values for num2 constant.
  The result variable is a combination of num1 & operator & inputAccum(of num2).

  When "=" is clicked, the num2 contant will take the 2nd inputAccum.
  The inputAccum will be reset to empty again.
  The result variable will be the result of the math.
*/
Button.prototype.onClick = function() {
  if (this.isMouseInside()) {

    //"C" button clear everything and start again
    if (this.label === "C") {
      inputAccum = "";
      num1 = "";
      num2 = "";
      result = "";
      cal = "";
      calScreen();

    //%, square, square root, and log calculation
    } else if (this.label === "%" || this.label === "()\u00B2" || this.label === "\u221A" || this.label === "ln") {
        calScreen();
        num1 = inputAccum;
        cal = this.label;
        if (cal === "%") {result = Number(num1) / 100;}
        if (cal === "()\u00B2") {result = sq(Number(num1));}
        if (cal === "\u221A") {result = sqrt(Number(num1));}
        if (cal === "ln") {result = log(Number(num1)) / 100;}
        resultFormat();
        inputAccum = "";
        num1 = "";
        cal = "";

    //+, - , x, / calculation. To show the calculation result, we have to click "=" button.
    } else if (this.label === "/" || this.label === "x" || this.label === "-" || this.label === "+") {
        calScreen();
        num1 = inputAccum;
        inputAccum = "";
        cal = this.label;
        result = num1 + cal;

    //"=" button show results of +, - , x, / calculation
    } else if (this.label === "=") {
        num2 = inputAccum;
        calScreen();
        if (cal === "/") {result = Number(num1) / Number(num2);}
        else if (cal === "x") {result = Number(num1) * Number(num2);}
        else if (cal === "+") {result = Number(num1) + Number(num2);}
        else if (cal === "-") {result = Number(num1) - Number(num2);}
        resultFormat();
        inputAccum = "";
        num1 = "";
        num2 = "";
        cal = "";
    //contants input
    } else {
        input = this.label;
        inputAccum += input;
        if (inputAccum === "0") {inputAccum = "";}//the 1st integer of the number cannot be 0
        calScreen();
        result = num1 + cal + inputAccum;
      }
  }
};

//draw the frame
strokeWeight(5);
stroke(110, 110, 110);
fill(200, 200, 200);
rect(screenX / 40, screenY / 44, screenX * (38/40), screenY * (42/44), 10);

//draw the calculator screen
var calScreen = function () {
fill(250, 250, 250);
rect(screenX / 18, screenY / 17, screenX - 55, screenY / 6, 10);
};
calScreen();

//draw buttons
btn0.draw();
btn1.draw();
btn2.draw();
btn3.draw();
btn4.draw();
btn5.draw();
btn6.draw();
btn7.draw();
btn8.draw();
btn9.draw();
btnPlus.draw();
btnMinus.draw();
btnMultiply.draw();
btnDivide.draw();
btnEqual.draw();
btnClear.draw();
btnPercent.draw();
btnSquare.draw();
btnSqrt.draw();
btnLog.draw();

//main event
mouseClicked = function () {
  btn0.onClick();
  btn1.onClick();
  btn2.onClick();
  btn3.onClick();
  btn4.onClick();
  btn5.onClick();
  btn6.onClick();
  btn7.onClick();
  btn8.onClick();
  btn9.onClick();
  btnDivide.onClick();
  btnMultiply.onClick();
  btnMinus.onClick();
  btnPlus.onClick();
  btnClear.onClick();
  btnEqual.onClick();
  btnPercent.onClick();
  btnSquare.onClick();
  btnSqrt.onClick();
  btnLog.onClick();
  fill(0, 0, 0);
  textSize(50);
  textAlign(RIGHT, BOTTOM);
  text(result, screenX - 40, screenY / 5);
};
