void showHelp(){
  textFont(font, 10); 
  int rowSpacing = 12;
  int currentY = rowSpacing;
  fill(200,100,100);
  text("Global Keys: ", 10,currentY+=rowSpacing);
  fill(200,50,100);
  text(" 'h' shows/hides help", 10,currentY+=rowSpacing);
  text(" 's' shows/hides settings", 10,currentY+=rowSpacing);
  text(" ' ' space bar sends midi data and moves balls", 10,currentY+=rowSpacing);
  text(" '+' add a ball", 10,currentY+=rowSpacing);
  text(" '-' subtract a ball", 10,currentY+=rowSpacing);
  text(" 'm' shows/sends mouse pressed midi cc", 10,currentY+=rowSpacing);
  text(" 'p' toggles movement around previous ball or center ball", 10,currentY+=rowSpacing);
  text(" 'u' show second ball group to control with right mouse button", 10,currentY+=rowSpacing);
  text(" 'e' decrease all distances from center", 10,currentY+=rowSpacing);
  text(" 'r' increase all distances from center", 10,currentY+=rowSpacing);
  text(" 'q' decrease all rotate rates", 10,currentY+=rowSpacing);
  text(" 'w' increase all rotate rates", 10,currentY+=rowSpacing);
  text(" 't' shows midi data for each ball", 10,currentY+=rowSpacing);
  text(" '.' move mouse to each ball", 10,currentY+=rowSpacing);
  currentY+=rowSpacing;
  fill(200,100,100);
  text("Keys to press when mouse over a ball: ", 10,currentY+=rowSpacing);
  fill(200,50,100);
  text(" 'x' sends midi cc controller x", 10,currentY+=rowSpacing);
  text(" 'y' sends midi cc controller y", 10,currentY+=rowSpacing);
  text(" 'n' sends midi note", 10,currentY+=rowSpacing);
  text(" 'c' moves closer to center ball", 10,currentY+=rowSpacing);
  text(" 'f' moves further away", 10,currentY+=rowSpacing);
  text(" 'o' switches the ball's move mode", 10,currentY+=rowSpacing);
  text(" 'a' accelerates ball", 10,currentY+=rowSpacing);
  text(" 'd' decelerates ball", 10,currentY+=rowSpacing);
}