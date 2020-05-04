// Aktywne prostokąty - autorski system interfejsu aplikacji w Processingu
// Wojciech Borkowski
///////////////////////////////////////////////////////////////////////////////
ArrayList<RectArea>   allAreas = new ArrayList<RectArea>();     //Lista obszarów do wyświetlania
ArrayList<TextButton> allButtons = new ArrayList<TextButton>(); //Lista przycisków

int iniTxButtonSize=16;
int iniTxButtonCornerRadius=6;//Domyślne zaokrąglenie rogów przycisków

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

void view_all_areas()
{
  for( RectArea area: allAreas)   //Lista obszarów do wyświetlania
  {
    area.view();
  }
}

class RectArea //Prostokątny obszar ekranu jako postawa pod rożne obszary aktywne
{
  int    x1,y1,x2,y2;//Rogi obszaru
  color  back;       //Kolor tła
  
  RectArea(float iX1,float iY1,float iX2,float iY2)
  {
    back=color(178,178,178);
    if(iX1<iX2) { x1=round(iX1);x2=round(iX2);}
      else {x1=round(iX2);x2=round(iX1);}
    if(iY1<iY2) { y1=round(iY1);y2=round(iY2);}
      else {y1=round(iY2);y2=round(iY1);}
    //println(x1+" "+y1+" "+x2+" "+y2);
  }
  
  void view()//Wyświetlanie
  {
        rectMode(CORNERS);
        fill(back);
        noStroke();
        rect(x1,y1,x2,y2);
  }
  
  boolean hitted(int x,int y)//Sprawdzenie kliknięcia
  {
    return x1<=x && x<=x2
        && y1<=y && y<=y2;
  }
}

class PanelOfTextButtons extends RectArea
{
  ArrayList<TextButton> list; 
  
  PanelOfTextButtons(float iX1,float iY1,float iX2,float iY2)
  {
    super(iX1,iY1,iX2,iY2);
    list = new ArrayList<TextButton>();
  }
  
  void view()
  {
     super.view();
     for( RectArea area: list)   //Lista obszarów do wyświetlania
     {
      area.view();
     }
  }
  
  void add(TextButton but)
  {
    list.add(but);
    but.x1+=x1;
    but.x2+=x1;
    but.y1+=y1;
    but.y2+=y1; //Przy move() trzeba z powrotem odjąć a potem dodać nowe
  }
  
}

/* From Interfaces.pde
interface named //Any object which have name as printable String
{
  String getName();
}
*/

class TextButton extends RectArea implements named//Prostokątny przycisk z zawartością tekstową
{
  color  txt,strok;
  int strokW;
  int txtSiz;
  int corner=iniTxButtonCornerRadius;
  
  String title;
  protected int state;
  
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
  
  String getName() { return title; }
  
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
  
  void flip_state(boolean visual) //Zmienia stan na przeciwny (0 na 1, inna na 0) i ewentualnie wizualizuje
  {
    if(state==0) state=1;
    else state=0;
    if(visual)
        view();
  }
  
  void set_state(int new_state,boolean visual) //Zmienia stan na przeciwny (0 na 1, inna na 0) i ewentualnie wizualizuje
  {
    if(new_state!=state)
    {
      state=new_state;
      if(visual)
          view();
    }
  }
  
}

class StateLabel extends TextButton //Klasa pseudobuttonu, która wyświetla stan a nie title, ignoruje flip_state() 
{                                   //a zmiany stanu przez set_state ma zabezpieczone
  private boolean allowChng;  //Normalnie uzycie set_state() nic nie zmienia, trzeba ustawić to pole, które po zmnianie się kasuje
                              //Więc tylko kod działający na obiektach tej klasy może to zrobić, akod działajacy na klasie bazowej nie
                              
  StateLabel(int iState,String iTitle,float iX1,float iY1,float iX2,float iY2)
  {
    super(iTitle,iX1,iY1,iX2,iY2);
    state=iState;allowChng=false;
  }
 
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
 
  void allow()
  {
    allowChng=true;
    view();
  }
  
  void flip_state(boolean visual) //Zmienia stan na przeciwny (0 na 1, inna na 0) i ewentualnie wizualizuje
  { //Nie zmienia stanu przez flip, najwyżej ponawia wyświetlenie - choć i to chyba nieprzydatne
    if(visual)
        view();
  }
  
  void set_state(int new_state,boolean visual) //Zmienia stan na przeciwny (0 na 1, inna na 0) i ewentualnie wizualizuje
  {
    if(allowChng)
    {
      if(new_state!=state)
      {
        state=new_state;
      }
      allowChng=false;//Czy była faktyczna zmiana czy nie
      if(visual)
          view();
    }
  }
}

class StateLabelInc extends TextButton //Klasa buttonu inkrementująca jakieś state label, ewentualnie cofająca działanie drugiej pary
{
  StateLabel     target;
  StateLabelInc  opponent;
  
  StateLabelInc(String iTitle,float iX1,float iY1,float iX2,float iY2,StateLabel iTarget,StateLabelInc iOpponent)
  {
    super(iTitle,iX1,iY1,iX2,iY2);
    target=iTarget;opponent=iOpponent;
  }
  
  void flip_state(boolean visual) //Nakładka metody
  { 
    super.flip_state(visual);
    if(opponent.state!=0) 
            opponent.decrement(visual);
    target.allow(); //Odbezpieczenie        
    if(state>0) target.set_state(target.state+1,visual);
           else target.set_state(target.state-1,visual);
   } 
    
   void decrement(boolean visual) //Metoda cofająca zmianę
   {
     state=0;view();
     target.allow(); //Odbezpieczenie       
     target.set_state(target.state-1,visual);
   }
}

class UniqTextButton extends TextButton //Klasa buttonu, którego kliknięcie zeruje stan wszystkich innych z listy
{
  ArrayList<TextButton> siblings; //Lista wykluczających się
  UniqTextButton(ArrayList<TextButton> iSibl,String iTitle,float iX1,float iY1,float iX2,float iY2)
  {
    super(iTitle,iX1,iY1,iX2,iY2);
    siblings=iSibl;
  }
  
  //Jeśli stan przycisku kliknieciem zmienia się na różny od 0 to jego rodzeństwo musi zostac wyzerowane
  void flip_state(boolean visual) //Zmienia stan na przeciwny (0 na 1, inna na 0) i ewentualnie wizualizuje
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
}

class WrTextButton extends TextButton //Button pamiętający kolumnę do jakiej ma zapisać swój unikalny marker
{   
  int column;
  String marker; 
  
  WrTextButton(String iTitle,float iX1,float iY1,float iX2,float iY2,String iMarker,int iColumn)
  {
    super(iTitle,iX1,iY1,iX2,iY2);
    marker=iMarker;
    column=iColumn;
  }
}

class WrUniqTextButton extends UniqTextButton //UniqButton pamiętający kolumnę do jakiej ma zapisać swój unikalny marker
{   
  int column;
  String marker; 
  
  WrUniqTextButton(ArrayList<TextButton> iSibl,String iTitle,float iX1,float iY1,float iX2,float iY2,String iMarker,int iColumn)
  {
    super(iSibl,iTitle,iX1,iY1,iX2,iY2);
    marker=iMarker;
    column=iColumn;
  }
}
