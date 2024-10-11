/// @file 
/// @brief Supports agent search on a mouse click, and possible inspection.
//*        ABM: MOUSE EVENTS TEMPLATE
/// @date 2024-10-11 (last modification)
//*////////////////////////////////////////////////////////////////////////

// Last read mouse data
int searchedX=-1;      ///< The horizontal coordinate of the mouse cursor.
int searchedY=-1;      ///< The vertical coordinate of the mouse cursor.
boolean Clicked=false; ///< Was there a click too?

// Last selection data:
int selectedX=-1;      ///< Converted into "world" indices, the agent's horizontal coordinate.
int selectedY=-1;      ///< Converted into "world" indices, the agent's vertical coordinate.
Agent selected=null;   ///< Most recently selected agent.

/// Pair of integers. Simple version of Pair containing a pair of integers.
class PairOfInt {
    int a; //!< The first component.
    int b; //!< The second component.

    /// Constructor.
    public PairOfInt(int a,int b) 
    {
        this.a = a; this.b = b;
    }
    
} //_EndOfClass PairOfInt

/// @brief Mouse click handler. @details 
/// This function is automatically run by Processing
/// when any mouse button is pressed. 
/// Inside, you can use the variables 'mouseX' and 'mouseY'.
/// NOTE: In C++ translation it is "global" by default.
void mouseClicked()
{
  println("Mouse clicked at ",mouseX,mouseY); //DEBUG
  Clicked=true;
  searchedX=mouseX;
  searchedY=mouseY; 
  
  PairOfInt result=findCell(TheWorld.agents); //But 1D searching is belong to you!
  if(result!=null) //Znaleziono
  {
    selectedX=result.a;
    selectedY=result.b;
    if((selected=TheWorld.agents[selectedY][selectedX])!=null)
    {
      println("Cell",selectedX,selectedY,"belong to",TheWorld.agents[selectedY][selectedX]);
      //... more info about the cell & the agent
    }
    else
      println("Cell",selectedX,selectedY,"is empty");
  }
}

/// @brief Searching for cell. @details 
/// Funtion converts mouse coordinates to cell coordinates.
/// The parameter is only for checking type and SIZES.
/// It works as long as the agents visualization starts at point 0,0
PairOfInt findCell(Agent[][] agents)  ///< Must be predeclared!
{ 
  int x=mouseX/cwidth;
  int y=mouseY/cwidth;
  if(0<=y && y<agents.length
  && 0<=x && x<agents[y].length)
      return new PairOfInt(x,y);
  else
      return null;
}

//*////////////////////////////////////////////////////////////////////////////////////////////
//*  Partly sponsored by the EU project "GuestXR" (https://guestxr.eu/)
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - ABM (Agent Base Model) TEMPLATE
//*  https://github.com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////////////////////
