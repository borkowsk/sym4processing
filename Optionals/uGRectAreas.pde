/// @file
/// @brief "Active rectangles" - proprietary application interface module in Processing ( "uGRectAreas.pde" )
/// @date 2023.03.04 (Last modification)
/// @author Wojciech Borkowski
//*/////////////////////////////////////////////////////////////////////////////////////////////////////////

// USE /*_interfunc*/ &  /*_forcbody*/ for interchangeable function 
// if you need translate the code into C++ (--> Processing2C )

ArrayList<RectArea>   allAreas = new ArrayList<RectArea>();     ///< Global list of areas to be displayed.
ArrayList<TextButton> allButtons = new ArrayList<TextButton>(); ///< Global button list.

int iniTxButtonSize=16;       ///< The initial size of the button.
int iniTxButtonCornerRadius=6;///< The default rounding of the corners of the buttons

/// Mouse click support for buttons.
/// If the program may also respond to clicks differently, this must be taken into account here.
/// @note This is global by default.
void mousePressed() 
{
  println("Pressed "+mouseX+" x "+mouseY);
  for(TextButton button : allButtons) 
  {
    if(button.hitted(mouseX,mouseY))
    {
      button.set_state(1,true);
    }
  }
}

/// Mouse button relase support.
/// If the program may also respond to clicks differently, this must be taken into account here.
/// @note This is global by default.
void mouseReleased() 
{
  println("Released "+mouseX+" x "+mouseY);
  for(TextButton button : allButtons) 
  {
    if(button.hitted(mouseX,mouseY))
    {
      button.flip_state(true);//println(button.title);
    } 
  }
}  

/// View all interface elements.
/// Should be called in draw() or in an event handlers.
void view_all_areas() ///< @note GLOBAL
{
  for( RectArea area: allAreas)
  {
    area.view();
  }
}

/// Rectangular screen area class as the basis for various active areas.
class RectArea
{
  int    x1,y1,x2,y2; //!< Corners of the area
  color  back;        //!< Colour of background
  
  /// Constructor. 
  /// Requires data on the corners of the area.
  RectArea(float iX1,float iY1,float iX2,float iY2)
  {
    back=color(178,178,178);
    if(iX1<iX2) { x1=round(iX1);x2=round(iX2);}
      else {x1=round(iX2);x2=round(iX1);}
    if(iY1<iY2) { y1=round(iY1);y2=round(iY2);}
      else {y1=round(iY2);y2=round(iY1);}
    //println(x1+" "+y1+" "+x2+" "+y2);
  }
  
  /// Area display function.
  /*_interfunc*/ void view()
  {
        rectMode(CORNERS);
        fill(back);
        noStroke();
        rect(x1,y1,x2,y2);
  }
  
  /// The function of checking if you click on an area.
  /*_interfunc*/ boolean hitted(int x,int y)
  {
    return x1<=x && x<=x2
        && y1<=y && y<=y2;
  }
} //EndOfClass RectArea

/// A class of a panel that contains many buttons.
class PanelOfTextButtons extends RectArea
{
  ArrayList<TextButton> list; 
  
  /// Constructor.
  /// Requires data on the corners of the area.
  PanelOfTextButtons(float iX1,float iY1,float iX2,float iY2)
  {
    super(iX1,iY1,iX2,iY2);
    list = new ArrayList<TextButton>();
  }
  
  /// Area display function.
  void view()
  {
     super.view();
     for( RectArea area: list)
     {
      area.view();
     }
  }
  
  /// Filling the panel with buttons.
  void add(TextButton but)
  {
    list.add(but);
    but.x1+=x1;
    but.x2+=x1;
    but.y1+=y1;
    but.y2+=y1; //Przy move() trzeba z powrotem odjąć, a potem dodać nowe
  }
  
} //EndOfClass

/// Rectangular button with text content.
class TextButton extends RectArea implements iNamed
{
  color  txt,strok;
  int strokW;
  int txtSiz;
  int corner=iniTxButtonCornerRadius;
  
  String title;
  protected int state;
  
  /// Constructor.
  /// Requires data on the corners of the area and text content ("title").
  TextButton(String iTitle,float iX1,float iY1,float iX2,float iY2)
  {
    super(iX1,iY1,iX2,iY2);
    state=0; 
    txt=color(255,255,255); back=color(0,0,0);corner=iniTxButtonCornerRadius;
    strok=color(100,100,100); strokW=3;
    title=iTitle; 
    txtSiz=iniTxButtonSize; //Wartość domyślna
    
    //Dopasowywanie rozmiaru fontu żeby się zmieściło title
    textSize(txtSiz);
    while(textWidth(title) > x2-x1) textSize(--txtSiz);
    while(textAscent()+textDescent() > y2-y1) textSize(--txtSiz);
  }
  
  /// Implements the iNamed interface requirement.
  String name() { return title; }
  
  /// Area display function.
  void view()
  {
    color cfill=(state==0?txt:back);
    color afill=(state==0?back:txt);
    
    rectMode(CORNERS);
    fill(red(afill),green(afill),blue(afill));
    stroke(strok);
    strokeWeight(strokW);  
    rect(x1,y1,x2,y2,corner);
    fill(cfill);
    textSize(txtSiz);
    textAlign(CENTER, CENTER);
    text(title,x1,y1,x2,y2); 
  }
  
  /// Change to the opposite state (0 to 1, other to 0) and possibly visualize.
  /*_interfunc*/ void flip_state(boolean visual)
  {
    if(state==0) state=1;
    else state=0;
    if(visual)
        view();
  }
  
  /// It changes the state to 0 or 1 and optionally visualizes.
  /*_interfunc*/ void set_state(int new_state,boolean visual)
  {
    if(new_state!=state)
    {
      state=new_state;
      if(visual)
          view();
    }
  }
  
} //EndOfClass TextButton


/// A pseudo-button class that displays the state, not the name. 
/// Also ignores flip_state() and that changes to state through set_state() are "protected".
class StateLabel extends TextButton 
{
  /// Normally using set_state() in this class does not change anything. 
  /// You have to set this field, which clears always after changing, 
  /// so only code working on objects of this class can do it, 
  /// but code working on base class can't :-)
  private boolean allowChng;
  
  /// Constructor.
  /// Requires data on the corners of the area, text "title" and initial state.
  StateLabel(int iState,String iTitle,float iX1,float iY1,float iX2,float iY2)
  {
    super(iTitle,iX1,iY1,iX2,iY2);
    state=iState;allowChng=false;
  }
 
  /// Area display function.
  void view()
  {
    color bfill=(allowChng?strok:back);
    color dfill=(allowChng?back:strok);

    rectMode(CORNERS);
    fill(red(txt),green(txt),blue(txt));
    stroke(dfill);
    strokeWeight(strokW);  
    rect(x1,y1,x2,y2);
    fill(bfill);
    textSize(txtSiz);
    textAlign(CENTER, CENTER);
    text(state+"",x1,y1,x2,y2); 
  }
 
  /// A function that allows you to change the state.
  /*_interfunc*/ void allow()
  {
    allowChng=true;
    view();
  }
  
  /// Specific for the class - It does not change the state by flip, 
  /// at most it repeats the display - although it is probably useless
  void flip_state(boolean visual)   
  { 
    if(visual)
        view();
  }
  
  /// Specific for the class. It uses allowChng field and then clears it.
  void set_state(int new_state,boolean visual)
  {
    if(allowChng)
    {
      if(new_state!=state)
      {
        state=new_state;
      }
      
      allowChng=false; // Whether there was an actual change or not, it will no longer be possible
      
      if(visual)
          view();
    }
  }
} //EndOfClass StateLabel

/// A button class that increments a state label. 
/// It possibly undoes the operation of the opposite pair.
class StateLabelInc extends TextButton
{
  StateLabel     target;
  StateLabelInc  opponent;
  
  /// Constructor.
  /// Requires data on the corners of the area, text "title" and connected areas.
  StateLabelInc(String iTitle,
                float iX1,float iY1,float iX2,float iY2,
                StateLabel iTarget,
                StateLabelInc iOpponent)
  {
    super(iTitle,iX1,iY1,iX2,iY2);
    target=iTarget;opponent=iOpponent;
  }
  
  /// Class-specific implementation of the inherited method.
  /// It increases or decreses the state.
  void flip_state(boolean visual)
  { 
    super.flip_state(visual);
    if(opponent.state!=0) 
            opponent.decrement(visual);
    target.allow(); //Odbezpieczenie        
    if(state>0) target.set_state(target.state+1,visual);
           else target.set_state(target.state-1,visual);
   } 
   
   /// The method that undoes state increments, i.e. decreases the "counter".
   void decrement(boolean visual)
   {
     state=0;view();
     target.allow(); //Odbezpieczenie       
     target.set_state(target.state-1,visual);
   }
} //EndOfClass StateLabelInc

/// Unique button. 
/// The class of the button, which when clicked, resets the state of all the others on the list.
class UniqTextButton extends TextButton 
{
  ArrayList<TextButton> siblings; //!< List of mutually exclusive buttons
  
  /// Constructor.
  /// Requires data on the corners of the area, text "title" and a list of mutual siblings.
  UniqTextButton(ArrayList<TextButton> iSibl,String iTitle,float iX1,float iY1,float iX2,float iY2)
  {
    super(iTitle,iX1,iY1,iX2,iY2);
    siblings=iSibl;
  }
  
  /// This method changes the state to the opposite (0 to 1, other to 0) 
  /// and possibly visualizes.
  /// However, if the button state changes to other than 0 then
  /// his companions (siblings) on the list must be reset.
  void flip_state(boolean visual)   
  {
    if(state==0) state=1;
    else state=0;
    if(visual)
    {
        view();
        if(state!=0)
        for(TextButton button : siblings)
        if(button!=this)
          button.set_state(0,true); //set_state jest po klasie bazowej żeby uniknąć niechcianej rekurencji
    }
  }
} //EndOfClass UniqTextButton

/// A button that remembers the column to which its unique marker is to be saved.
class WrTextButton extends TextButton 
{   
  int column;
  String marker; 
  
  /// Constructor.
  /// Requires data on the corners of the area, text "title", text marker and specific output column.
  WrTextButton(String iTitle,float iX1,float iY1,float iX2,float iY2,String iMarker,int iColumn)
  {
    super(iTitle,iX1,iY1,iX2,iY2);
    marker=iMarker;
    column=iColumn;
  }
} //EndOfClass WrTextButton

/// UniqButton additionally remembers the column to which it is to save its unique marker.
class WrUniqTextButton extends UniqTextButton 
{   
  int column;
  String marker; 
  
  /// Constructor.
  /// Requires data on the corners of the area, text "title", text marker and specific output column,
  /// and, of course, a list of mutual siblings.
  WrUniqTextButton(ArrayList<TextButton> iSibl,String iTitle,float iX1,float iY1,float iX2,float iY2,String iMarker,int iColumn)
  {
    super(iSibl,iTitle,iX1,iY1,iX2,iY2);
    marker=iMarker;
    column=iColumn;
  }
} //EndOfClass WrUniqTextButton

//*/////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS 
//*  - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*/////////////////////////////////////////////////////////////////////////////
