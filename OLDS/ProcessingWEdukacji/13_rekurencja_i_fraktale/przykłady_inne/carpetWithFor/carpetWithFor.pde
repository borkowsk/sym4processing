// RECURSIVE PATTERNS – THE SIERPINSKI CARPET
// https://craftofcoding.wordpress.com/2018/05/10/recursive-patterns-the-sierpinski-carpet/
///////////////////////////////////////////////////////////////////////////////////////////////
int dim;
int limit, depth;
 
void setup() 
{
   size(513, 513);//Okno musi być symetryczne
   dim = 513;
   limit = dim;
   depth = 6;
}
 
void draw() 
{
   background(255);
   stroke(0); 
   for (int i=1; i<=depth; i=i+1) 
   {
      sierpinskiCarpet(0,0,dim);
      limit = limit / 3;
   } 
   noLoop(); //Tylko jedno wywołanie draw()
}
 
void sierpinskiCarpet(int x, int y, int size){
   if (size < limit)
      return;
      
   size = size / 3;
   for (int i=0; i<9; i=i+1)
      if (i == 4)
      {
         fill(size/dim*100);
         rect(x+size, y+size, size, size);
         noFill();
      }
      else
        sierpinskiCarpet(x+(i%3)*size, y+(i/3)*size, size);
}
