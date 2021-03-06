// Generic visualisations of a (social) network
///////////////////////////////////////////////////////////
float XSPREAD=0.01; //how far is target point of link of type 1, from center of the cell
int   linkCounter=0;//number od=f links visualised last time

//FUNCTIONS:
////////////
//void visualiseLinks(iVisNode[]   nodes,float defX,float defY,float cellside);
//void visualiseLinks(iVisNode[][] nodes,float defX,float defY,float cellside);

// INTERFACES
///////////////////////////////////
interface iVisNode extends iNode,iNamed,iColorable,iPositioned
{}

interface  iVisLink extends iLink,iNamed,iColorable
{}

interface iNamed 
{
  //Forcing name for visualisation and mapping by names                
  String    name();
}

interface iColorable
{
  //Forcing setFill & setStroke methods for visualisation
  void setFill();
  void setStroke();
}

interface iPositioned  
{
  //Forcing posX() & posY() & posZ() methods for visualisation and mapping                
  float    posX();
  float    posY();
  float    posZ();
}

// IMPLEMENTATIONS:
///////////////////

void visualiseLinks(iVisNode[] nodes,LinkFilter filter,float defX,float defY,float cellside)
{
  noFill();
  linkCounter=0;
  ellipseMode(CENTER);
  int n=nodes.length;
  for(int i=0;i<n;i++)
  {
    iVisNode Source=nodes[i];
    
    if(Source!=null)
    {
      float X=Source.posX();
      Link[] links=Source.getConns(filter);
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
        
        links[j].setStroke();
        
        arc(defX+C,defY,R,R,0,PI);
        stroke(255);
        point(defX+(Xt*cellside),defY);
        linkCounter++;
      }
    }
  }
}

void visualiseLinks(iVisNode[][] nodes,LinkFilter filter,float defX,float defY,float cellside)
{
  noFill();
  linkCounter=0;
  for(int i=0;i<nodes.length;i++)
  for(int j=0;j<nodes[i].length;j++)
  {
    iVisNode Source=nodes[i][j];
    
    if(Source!=null)
    {
      float X=Source.posX();
      float Y=Source.posY();
      Link[] links=Source.getConns(filter);
      int n=links.length;
      
      for(int k=0;k<n;k++)
      {
        float Xt=links[k].target.posX();
        float Yt=links[k].target.posY();

        if(X<Xt) { Xt+=links[k].ltype*XSPREAD;}
        else    { Xt-=links[k].ltype*XSPREAD;}
        
        links[k].setStroke();
        
        
        line(defX+(X*cellside),defY+(Y*cellside),defX+(Xt*cellside),defY+(Yt*cellside));
        stroke(255);
        point(defX+(Xt*cellside),defY+(Yt*cellside));
        linkCounter++;
      }
    }
  }
}

///////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - SOCIAL NETWORK TEMPLATE
///////////////////////////////////////////////////////////////////////////////////////////
