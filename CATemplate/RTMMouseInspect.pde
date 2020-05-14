// Obsługa wyszukiwania obiektu po kliknięciu myszy
///////////////////////////////////////////////////////////////////////
int searchedX=-1;
int searchedY=-1;
boolean Clicked=false;
int selectedX=-1;
int selectedY=-1;

//double minDist2Selec=MAX_INT;//???
//double maxTransSelec=-MAX_INT;//???

class PairOfInt
//Simple version of Pair returning a pair of Int
{
    public final int a;
    public final int b;

    public PairOfInt(int a,int b) 
    {
        this.a = a;
        this.b = b;
    }
};

void mouseClicked()
{
  println("Mouse clicked at ",mouseX,mouseY);//DEBUG
  Clicked=true;
  searchedX=mouseX;
  searchedY=mouseY; //Searching may be implemented in visualisation!
  
  PairOfInt result=findCell(TheWorld.cells);//But 1D searching is belong to you!
  if(result!=null)//Znaleziono
  {
    selectedX=result.a;
    selectedY=result.b;
    println("Cell",selectedX,selectedY,TheWorld.cells[selectedY][selectedX]);
  }
}

PairOfInt findCell(int[][] cells)
{ //Przeliczanie współrzędnych myszy na współrzędne komórki 
  //Parametr jest tylko do sprawdzenie typu i ROZMIARÓW
  //Działa o tyle o ile wizualizacja komórek startuje w punkcie 0,0
  int x=mouseX/cwidth;
  int y=mouseY/cwidth;
  if(0<=y && y<cells.length
  && 0<=x && x<cells[y].length)
      return new PairOfInt(x,y);
  else
      return null;
}
