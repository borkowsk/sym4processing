/// @file
/// @brief Obsługa wyszukiwania obiektu po kliknięciu myszy
//*        CA: MOUSE EVENTS HANDLING
//*////////////////////////////////////////////////////////

// Last read mouse data
int searchedX=-1; ///< The horizontal coordinate of the mouse cursor.
int searchedY=-1; ///< The vertical coordinate of the mouse cursor.
boolean Clicked=false; ///< Was there a click too?

// Last selection
int selectedX=-1; ///< Converted into "world" indices, the agent's horizontal coordinate.
int selectedY=-1; ///< Converted into "world" indices, the agent's vertical coordinate.

/// Pair of integers. Simple version of Pair containing a pair of integers.
class PairOfInt
{
    public final int a;
    public final int b;

    public PairOfInt(int a,int b) 
    {
        this.a = a;
        this.b = b;
    }
} //_EndOfClass PairOfInt

/// Mouse click handler. This function is automatically run by Processing
/// when any mouse button is pressed. 
/// Inside, you can use the variables 'mouseX' and 'mouseY'.
/// @note In C++ translation it is "global" by default.
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
    //... more info about cell?
  }
}

/// Searching for cell. Funtion converts mouse coordinates to 
/// cell coordinates.
/// The parameter is only for checking type and SIZES.
/// It works as long as the agents visualization starts at point 0,0
PairOfInt findCell(int[][] cells) ///< GLOBAL!
{ 
  int x=mouseX/cwidth;
  int y=mouseY/cwidth;
  if(0<=y && y<cells.length
  && 0<=x && x<cells[y].length)
      return new PairOfInt(x,y);
  else
      return null;
}

//*//////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - CA (Cellular Automaton) TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*//////////////////////////////////////////////////////////////////////////////////////////////
