/// Generic visualisations of a (social) network
//*/////////////////////////////////////////////////////////
float XSPREAD=0.01;   ///< how far is target point of link of type 1, from center of the cell
int   linkCounter=0;  ///< number od=f links visualised last time

//   FUNCTIONS:
//*/////////////
//void visualiseLinks(iVisNode[]   nodes,float defX,float defY,float cellside);
//void visualiseLinks(iVisNode[][] nodes,float defX,float defY,float cellside);

//   IMPLEMENTATIONS:
//*///////////////////

/// One dimensional visualisation using arcs()
void visualiseLinks1D(iVisNode[] nodes,LinkFilter filter,float defX,float defY,float cellside,boolean intMode) 
{ 
  noFill();strokeCap(ROUND);
  linkCounter=0;
  ellipseMode(CENTER);
  
  if(intMode) //Wystarczy raz! 
      defX+=0.5*cellside;
  
  int n=nodes.length;
  for(int i=0;i<n;i++)
  {
    iVisNode Source=nodes[i];
    
    if(Source!=null)
    {
      float X=Source.posX(); 
      Link[] links=(Link[])Source.getConns(filter); assert links!=null;
      
      int m=links.length;
      for(int j=0;j<m;j++)
      {
        float Xt=links[j].target.posX();
        //print(X,Xt,"; "); 
        float R=abs(Xt-X)*cellside;
        float C=(X+Xt)/2;
        
        if(X<Xt) { Xt+=links[j].ltype*XSPREAD;}
        else    { Xt-=links[j].ltype*XSPREAD;}
        C*=cellside;
        
        links[j].setStroke(LINK_INTENSITY);
        
        arc(defX+C,defY,R,R,0,PI);
        stroke(255);
        point(defX+(Xt*cellside),defY);
        linkCounter++;
      }
    }
  }
}

/// Two dimensional visualisation using arrows()
void visualiseLinks2D(iVisNode[] nodes,LinkFilter filter,float defX,float defY,float cellside,boolean intMode) { ///
  noFill();strokeCap(ROUND);
  linkCounter=0;
  ellipseMode(CENTER);
  
  if(intMode) 
        defX+=0.5*cellside;
  if(intMode) 
        defY+=0.5*cellside;
  
  int N=nodes.length;
  for(int i=0;i<N;i++)
  {
    iVisNode Source=nodes[i];
    
    if(Source!=null)
    {
      float X=Source.posX();
      float Y=Source.posY();
      Link[] links=(Link[])Source.getConns(filter); assert links!=null;
      
      int l=links.length;
      for(int k=0;k<l;k++)
      {
        float Xt=links[k].target.posX();
        float Yt=links[k].target.posY();
                                                  if(debug_level>4 && Source==links[k].target)//Będzie kółko!
                                                        println(Source.name(),"-o-",links[k].target.name());
        if(X<Xt) { Xt+=links[k].ltype*XSPREAD;}
        else    { Xt-=links[k].ltype*XSPREAD;}
                                                  if(debug_level>1 && X==Xt && Y==Yt)//TEŻ będzie kółko!!!
                                                        println("Connection",Source.name(),"->-",links[k].target.name(),"visualised as circle");
        links[k].setStroke(LINK_INTENSITY);
        arrow(defX+(X*cellside)+1,defY+(Y*cellside)+1,defX+(Xt*cellside)-1,defY+(Yt*cellside)-1);
        
        stroke(255);point(defX+(Xt*cellside),defY+(Yt*cellside));
        
        linkCounter++;
      }
      
      strokeWeight(2);
      stroke(255,255,0,64);
      ellipse(defX+(X*cellside),defY+(Y*cellside),cellside,cellside);
    }
  }
}

/// Alternative 2D links visualisation
void visualiseLinks(iVisNode[][] nodes,LinkFilter filter,float defX,float defY,float cellside,boolean intMode) 
{ 
  noFill();
  linkCounter=0;
  
  if(intMode) defX+=0.5*cellside;//WYSTARCZY DODAĆ RAZ!
  if(intMode) defY+=0.5*cellside;//W tym miejscu.
  
  for(int i=0;i<nodes.length;i++)
  for(int j=0;j<nodes[i].length;j++)
  {
    iVisNode Source=nodes[i][j];
    
    if(Source!=null)
    {
      float X=Source.posX();
      float Y=Source.posY();
      Link[] links=(Link[])Source.getConns(filter); assert links!=null;
      int n=links.length;
      
      for(int k=0;k<n;k++)
      {
        float Xt=links[k].target.posX();
        float Yt=links[k].target.posY();

        if(X<Xt) { Xt+=links[k].ltype*XSPREAD;}
        else    { Xt-=links[k].ltype*XSPREAD;}
        
        links[k].setStroke(LINK_INTENSITY);
        arrow(defX+(X*cellside),defY+(Y*cellside),defX+(Xt*cellside),defY+(Yt*cellside));
        /*
        float midX=defX+( X*cellside + Xt*cellside )/2.0;
        float midY=defY+( Y*cellside + Yt*cellside )/2.0;
        stroke(255,0,0);
        line(defX+(X*cellside),defY+(Y*cellside),midX,midY);
        links[k].setStroke(LINK_INTENSITY*0.77);
        stroke(0,0,255);
        line(midY,midY,defX+(Xt*cellside),defY+(Yt*cellside));
        */
        
        stroke(255);point(defX+(Xt*cellside),defY+(Yt*cellside));
        
        linkCounter++;
      }
    }
  }
}

///////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - SOCIAL NETWORK TEMPLATE mod.
///////////////////////////////////////////////////////////////////////////////////////////
