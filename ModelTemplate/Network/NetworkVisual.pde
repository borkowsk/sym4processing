// Generic visualisations of a (social) network
///////////////////////////////////////////////////////////

//void visualiseLinks(Node[] nodes,float defX,float defY,float cellside);
//void visualiseLinks(Node[][] nodes,float defX,float defY,float cellside);

void visualiseLinks(Node[] nodes,float defX,float defY,float cellside)
{
  noFill();
  ellipseMode(CENTER);
  int n=nodes.length;
  for(int i=0;i<n;i++)
  {
    Node Source=nodes[i];
    
    if(Source!=null)
    {
      float X=Source.posX();
      Link[] links=Source.getConns(allLinks);
      int m=links.length;
      for(int j=0;j<m;j++)
      {
        float Xt=links[j].target.posX();
        //print(X,Xt,"; "); 
        float R=abs(Xt-X)*cellside;
        float C=(X+Xt)/2;
        
        if(X<Xt) { C+=0.1;Xt+=0.1;}
        else    { C-=0.1;Xt-=0.1;}
        C*=cellside;
        
        links[j].setStroke();
        
        arc(defX+C,defY,R,R,0,PI);
        stroke(255);
        point(defX+(Xt*cellside),defY);
      }
    }
  }
}

void visualiseLinks(Node[][] nodes,float defX,float defY,float cellside)
{
  noFill();
  for(int i=0;i<nodes.length;i++)
  for(int j=0;j<nodes[i].length;j++)
  {
    Node Source=nodes[i][j];
    
    if(Source!=null)
    {
      float X=Source.posX();
      float Y=Source.posY();
      Link[] links=Source.getConns(allLinks);
      int n=links.length;
      
      for(int k=0;k<n;k++)
      {
        float Xt=links[k].target.posX();
        float Yt=links[k].target.posY();

        if(X<Xt) { Xt+=0.1;}
        else    { Xt-=0.1;}
        
        links[k].setStroke();
        
        line(defX+(X*cellside),defY+(Y*cellside),defX+(Xt*cellside),defY+(Yt*cellside));
        //stroke(255);
        //point(defX+(Xt*cellside),defY+(Yt*cellside) );
      }
    }
  }
}

///////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - SOCIAL NETWORK TEMPLATE
///////////////////////////////////////////////////////////////////////////////////////////
