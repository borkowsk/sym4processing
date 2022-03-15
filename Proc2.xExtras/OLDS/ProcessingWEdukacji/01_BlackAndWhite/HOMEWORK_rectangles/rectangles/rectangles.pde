size(300,300);

rectMode(CORNER);  // Default rectMode is CORNER
fill(155);  // Set fill to white
rect(25, 25, 50, 50);  // Draw white rect using CORNER mode

stroke(255);
point(25,25);
point(50,50);
stroke(0);

rectMode(CORNERS);  // Set rectMode to CORNERS
fill(50);  // Set fill to gray
rect(50, 50, 75, 75);  // Draw gray rect using CORNERS mode

stroke(255);
point(50,50);
point(75,75);
stroke(0);

rectMode(RADIUS);  // Set rectMode to RADIUS
fill(200);  // Set fill to white
rect(150, 150, 30, 30);  // Draw white rect using RADIUS mode

stroke(255);
point(150,150);
stroke(0);

rectMode(CENTER);  // Set rectMode to CENTER
fill(255);  // Set fill to gray
rect(250, 250, 30, 30);  // Draw gray rect using CENTER mode

stroke(0);
point(250,250);
