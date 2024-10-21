/// Generic visualisations of a (social) network. ("uNetVisual.pde")
/// @date 2024-10-21 (last modification)
//*/////////////////////////////////////////////////////////////////////////////

/// @details
///
///   CLASSES:
///   ========
///   - `class Visual2DNodeAsList extends NodeAsList implements iVisNode` 
///      -> Visualisable node based on `NodeAsList` core.
///   - `class Visual2DNodeAsMap extends NodeAsMap implements iVisNode` 
///      -> Visualisable node based on `NodeAsMap` core.
///
///   FUNCTIONS:
///   ==========
///   - `void visualiseLinks(iVisNode[]   nodes,float defX,float defY,float cellSide)`
///   - `void visualiseLinks(iVisNode[][] nodes,float defX,float defY,float cellSide)`
///

float linksXSpread=0.01;   ///< how far is target point of link of type 1, from center of the cell.
int   linksCounter=0;      ///< number od=f links visualised last time.

/**
* @brief Visualisable node based on `NodeAsList` core.
*        It implements all things needed for visualisation.
*/
class Visual2DNodeAsList extends NodeAsList implements iVisNode
{
  float X=0;
  float Y=0;
  color fillc=0x0; //TODO fillC
  color strok=0x0; //TODO strokeC
  
  Visual2DNodeAsList(float x, float y) { super();
    X=x; Y=y;  
  }
 
  void setFill(float intensity) { fill(fillc,intensity); }
  void setStroke(float intensity) { stroke(strok,intensity); }
  float  posX() { return X;}
  float  posY() { return Y;}
  String name() { return ("("+X+","+Y+")"+this);}
} //_EndOfClass Visual2DNodeAsList

/**
* @brief Visualisable node based on `NodeAsMap` core.
*        It implements all things needed for visualisation.
*/
class Visual2DNodeAsMap extends NodeAsMap implements iVisNode
{
  float X=0;
  float Y=0;
  color fillc=0x0;
  color strok=0x0;
  
  Visual2DNodeAsMap(float x, float y) { super();
    X=x; Y=y;  
  }
 
  void setFill(float intensity) { fill(fillc,intensity); }
  void setStroke(float intensity) { stroke(strok,intensity); }
  float  posX() { return X;}
  float  posY() { return Y;}
  String name() { return ("("+X+","+Y+")"+this);}
} //_EndOfClass Visual2DNodeAsMap


//   IMPLEMENTATIONS:
//*//////////////////


/// @brief Weight color scale visualisation.
/// @param textYoffset - TODO change name textYOffset
void visualiseWeightScale(Link lnk,float defX,float defY,float width,float hei,float textYoffset) ///< @NOTE GLOBAL!
{
  textAlign(LEFT,TOP);   text("0.0",defX,        defY+textYoffset);
  textAlign(CENTER,TOP); text("0.5",defX+width/2,defY+textYoffset);
  textAlign(RIGHT,TOP);  text("1.0",defX+width,  defY+textYoffset);
  for(float w=1.0;w>=0.0;w-=0.01)
  {
    float pos=defX+w*width;
    lnk.applyStroke(w,LINK_INTENSITY);
    line(pos,defY,pos,defY+hei);
  }
}

/// One dimensional visualisation using arcs(). TODO cellSide
void visualiseLinks1D(iVisNode[] nodes,LinkFilter filter,float defX,float defY,float cellSide,boolean intMode)  ///< @note Global namespace.
{ 
  noFill();strokeCap(ROUND); //<>//
  linksCounter=0;
  ellipseMode(CENTER);
  
  if(intMode) //Wystarczy raz! 
      defX+=0.5*cellSide;
  
  int n=nodes.length;
  for(int i=0;i<n;i++)
  {
    iVisNode Source=nodes[i];
    
    if(Source!=null)
    {
      float X=Source.posX(); 
      iVisLink[] links=(iVisLink[])Source.getConns(filter);    assert links!=null;
      
      int m=links.length;
      for(int j=0;j<m;j++)
      {
        float Xt=links[j].getVisTarget().posX();
        //print(X,Xt,"; "); 
        float R= abs(Xt-X)*cellSide;
        float C= (X+Xt) / 2;
        
        if(X<Xt) { Xt+=links[j].getTypeMarker()*linksXSpread;}
        else     { Xt-=links[j].getTypeMarker()*linksXSpread;}
        C*=cellSide;
        
        links[j].applyStroke(LINK_INTENSITY);
        
        arc(defX+C,defY,R,R,0,PI);
        stroke(255);
        point(defX+(Xt*cellSide),defY);
        linksCounter++;
      }
    }
  }
}

/// Two dimensional visualisation using `arrows()`.
void visualiseLinks2D(iVisNode[] nodes,LinkFilter filter,float defX,float defY,float cellSide,boolean intMode)  ///< @note Global namespace.
{
  noFill();strokeCap(ROUND);
  linksCounter=0;
  ellipseMode(CENTER);
  
  if(intMode) 
        defX+=0.5*cellSide;
  if(intMode) 
        defY+=0.5*cellSide;
  
  int N=nodes.length;
  for(int i=0;i<N;i++)
  {
    iVisNode Source=nodes[i];
    
    if(Source!=null)
    {
      float X=Source.posX();
      float Y=Source.posY();                                       //circle(X,Y,1);
      iLink[] links=Source.getConns(filter);                       assert links!=null;
      
      int l=links.length;
      for(int k=0;k<l;k++)
      {
        iVisLink k_link=(iVisLink)links[k];
        iVisNode k_node=(iVisNode)k_link.getTarget();
        float Xt=k_node.posX();                                   //strokeWeight(1);stroke(10);
        float Yt=k_node.posY();                                   //circle(Xt,Yt,k+1*2);
                                                  if(NET_DEBUG>4 && Source==links[k].getTarget()) //Będzie kółko!
                                                        println(Source.name(),"-o-",links[k].getTarget().name());
                                                        
        if(X<Xt) { Xt+=links[k].getTypeMarker()*linksXSpread;}
        else    { Xt-=links[k].getTypeMarker()*linksXSpread;}
                                                  if(NET_DEBUG>1 && X==Xt && Y==Yt) //TEŻ będzie kółko!!!
                                                        println("Connection",Source.name(),"->-",links[k].getTarget().name(),"visualised as circle");
        k_link.applyStroke(LINK_INTENSITY); //<>//
        
        arrow(defX+(X*cellSide)+1,defY+(Y*cellSide)+1,defX+(Xt*cellSide)-1,defY+(Yt*cellSide)-1);
        
        stroke(255);point(defX+(Xt*cellSide),defY+(Yt*cellSide));
        
        linksCounter++;
      }
      
      strokeWeight(2);
      stroke(255,255,0,64);
      ellipse(defX+(X*cellSide),defY+(Y*cellSide),cellSide,cellSide);
    }
  }
}

/// Alternative 2D links visualisation.
void visualiseLinks(iVisNode[][] nodes,LinkFilter filter,float defX,float defY,float cellSide,boolean intMode) ///< @note Global namespace.
{ 
  noFill();
  linksCounter=0;
  
  if(intMode) defX+=0.5*cellSide; //WYSTARCZY DODAĆ RAZ!
  if(intMode) defY+=0.5*cellSide; //W tym miejscu.
  
  for(int i=0;i<nodes.length;i++)
  for(int j=0;j<nodes[i].length;j++)
  {
    iVisNode Source=nodes[i][j];
    
    if(Source!=null)
    {
      float X=Source.posX();
      float Y=Source.posY();
      iVisLink[] links=(iVisLink[])Source.getConns(filter);                  assert links!=null;
      int n=links.length;
      
      for(int k=0;k<n;k++)
      {
        iVisNode visTarget=links[k].getVisTarget();
        float Xt=visTarget.posX();
        float Yt=visTarget.posY();

        if(X<Xt) { Xt+=links[k].getTypeMarker()*linksXSpread;}
        else    { Xt-=links[k].getTypeMarker()*linksXSpread;}
        
        links[k].applyStroke(LINK_INTENSITY);
        arrow(defX+(X*cellSide),defY+(Y*cellSide),defX+(Xt*cellSide),defY+(Yt*cellSide));
        /*
        float midX=defX+( X*cellSide + Xt*cellSide )/2.0;
        float midY=defY+( Y*cellSide + Yt*cellSide )/2.0;
        stroke(255,0,0);
        line(defX+(X*cellSide),defY+(Y*cellSide),midX,midY);
        links[k].setStroke(LINK_INTENSITY*0.77);
        stroke(0,0,255);
        line(midY,midY,defX+(Xt*cellSide),defY+(Yt*cellSide));
        */
        
        stroke(255);point(defX+(Xt*cellSide),defY+(Yt*cellSide));
        
        linksCounter++;
      }
    }
  }
}



//*////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS 
//*  - FUNCTIONS & CLASSES  - NETWORKS TOOLBOX
//*  https://github.com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////
