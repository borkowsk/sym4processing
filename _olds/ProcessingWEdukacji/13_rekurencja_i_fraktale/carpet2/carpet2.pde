// RECURSIVE PATTERNS – THE SIERPINSKI CARPET
// Wersja uproszczona
///////////////////////////////////////////////////////////////////////////////////////////////
int limit=3;
 
void setup() 
{
   size(729, 729);//Okno winno być symetryczne
   noLoop(); //wywołania draw() niepotrzebne
   noSmooth();background(255);stroke(0);fill(0); 

   sierpinskiCarpet(0,0,729);
}
  
void sierpinskiCarpet(int x, int y, int size)
{
   if (size < limit)
      return;
      
   size = size / 3;
   
   rect(x+size, y+size, size-1, size-1);//Wycięcie
   
   //Wywołania rekurencyjne dla 8 kwadratowych sąsiedztw
   //Po rogach
   sierpinskiCarpet(x,y,size);
   sierpinskiCarpet(x+2*size,y+2*size,size);
   sierpinskiCarpet(x,y+2*size,size);
   sierpinskiCarpet(x+2*size,y,size);
   //Po bokach
   sierpinskiCarpet(x,y+size,size);
   sierpinskiCarpet(x+size,y,size);
   sierpinskiCarpet(x+2*size,y+size,size);
   sierpinskiCarpet(x+size,y+2*size,size);
}
