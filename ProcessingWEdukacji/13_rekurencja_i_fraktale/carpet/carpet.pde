// RECURSIVE PATTERNS – THE SIERPINSKI CARPET
// Wersja uproszczona
///////////////////////////////////////////////////////////////////////////////////////////////
int limit=1;
 
void setup() 
{
   size(513, 513);//Okno winno być symetryczne
   noLoop(); //wywołania draw() niepotrzebne
   background(255);stroke(0);fill(0); 

   sierpinskiCarpet(0,0,513);
}
  
void sierpinskiCarpet(int x, int y, int size)
{
   if (size < limit)
      return;
      
   size = size / 3;
   
   rect(x+size, y+size, size, size);//Wycięcie
   
   //Wywołania rekurencyjne dla 8 kwadratowych sąsiedztw
   sierpinskiCarpet(x,y,size);
   sierpinskiCarpet(x+2*size,y+2*size,size);
   //sierpinskiCarpet(x,y+2*size,size);
   //... itd!!!
}
