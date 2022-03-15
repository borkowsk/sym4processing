//TAKA KLASA
////////////////////////
class RGB
{
  int R,G,B;
  
  RGB()
  { 
    R=G=B=0; 
    RGB_Counter++;
  }
  
  void Set(int iR,int iG,int iB)
  {
    R=iR;G=iG;B=iB;
  }
  
  boolean isEmpty()
  {
    return R<=0 && G<=0 && B<=0;
  }
  
  void Visualise(int X,int Y)
  {
    if(!isEmpty())
    {
      stroke(R,G,B);
      if(W>1)
      {
        fill(R,G,B);
        rect(X*W,Y*W,W,W);
      }
      else
      point(X,Y);
    }
  }
}

int RGB_Counter=0;