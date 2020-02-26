// Generic (social) network
//////////////////////////////////////////////////////////////
import java.util.Map;
int debug_level=0;
float INTENSITY=20;

class Link extends Colorable
//This class is available for user modifications
{
  Node  target;
  float weight;//importance/trust
  int   ltype;//"color"
  //... add something, if you need in derived classes
  
  //Constructor (may vary)
  Link(Node targ,float we,int ty){ target=targ;weight=we;ltype=ty;}
  
  //For visualisation and mapping  
  String name(){ return target.name(); }
  
  void setStroke(/*float modifier=0 ?*/)
  {
     strokeWeight(abs(weight)>0.5?1:0);
     switch ( ltype )
     {
     case 0: if(weight>=0) stroke(0,0,weight*255,INTENSITY);else stroke(-weight*255,-weight*255,0,INTENSITY);break;
     case 1: if(weight>=0) stroke(weight*255,0,0,INTENSITY);else stroke(0,-weight*255,-weight*255,INTENSITY);break;
     case 2: if(weight>=0) stroke(0,weight*255,0,INTENSITY);else stroke(-weight*255,0,-weight*255,INTENSITY);break;
     default://Wszystkie inne 
             if(weight>=0) stroke(128,0,weight*255,INTENSITY);else stroke(-weight*255,-weight*255,128,INTENSITY);
             break;
     }
  }
}

// INTERFACES
///////////////////////////////////
abstract class LinkFilter
{
  boolean meetsTheAssumptions(Link l)
                  {assert false : "Pure interface meetsTheAssumptions(Link) called"; return false;}
}

abstract class LinkFactory
{
  Link  makeLink(Node Source,Node Target)
                  {assert false : "Pure interface make(Node,Node) called"; return null;}
}

abstract class Named //Forcing name() method
{
  //For visualisation and mapping                
  String    name(){assert false : "Pure interface name() called"; return null;}
}

abstract class Colorable extends Named //Forcing setFill & setStroke methods
{
  //For visualisation
  void setFill(/*float modifier=0 ?*/){assert false : "Pure interface setFill() called";}
  void setStroke(/*float modifier=0 ?*/){assert false : "Pure interface setStroke() called";}
}

abstract class Positioned extends Colorable //Forcing posX() & posY() & posZ() methods
{
  //For visualisation and mapping                
  float    posX(){assert false : "Pure interface posX() called"; return 0;}
  float    posY(){assert false : "Pure interface posY() called"; return 0;}
  float    posZ(){assert false : "Pure interface posZ() called"; return 0;}
}

abstract class Node extends Positioned /* derived class are NodeList, NodeMap & ...*/
{
  int     addConn(Link   l){assert false : "Pure interface addConn(Link "+l+") called"; return   -1;}
  int     delConn(Link   l){assert false : "Pure interface delConn(Link "+l+") called"; return   -1;}
  Link    getConn(int    i){assert false : "Pure interface getConn(int "+i+")  called"; return null;}
  Link    getConn(Node   n){assert false : "Pure interface getConn(Node "+n+") called"; return null;}
  Link    getConn(String k){assert false : "Pure method  getConn(String '"+k+"') called"; return null;}
  Link[]  getConns(LinkFilter f)
                  {assert false : "Pure interface getConns(LinkFilter "+f+") called"; return null;}
}

/* Network generators: 
void makeRingNet(Node[] nodes,LinkFactory links,int neighborhood);
void makeTorusNet(Node[] nodes,LinkFactory links,int neighborhood);
void makeTorusNet(Node[][] nodes,LinkFactory links,int neighborhood);

void makeFullNet(Node[] nodes,LinkFactory links);
void makeFullNet(Node[][] nodes,LinkFactory links);

void makeRandomNet(Node[] nodes,LinkFactory links,float probability);
void makeRandomNet(Node[][] nodes,LinkFactory links,float probability);

void makeSmWorldNet(Node[] nodes,LinkFactory links,...);
void makeImSmWorldNet(Node[] nodes,LinkFactory links,...);
*/

// IMPLEMENTATIONS
///////////////////////////////////

void makeRingNet(Node[] nodes,LinkFactory linkfac,int neighborhood)
{
  int n=nodes.length;
  for(int i=0;i<n;i++)
  {
    Node Source=nodes[i];
    
    if(Source!=null)
    {
      if(debug_level>2) println(i,Source,' ');
      for(int j=1;j<=neighborhood;j++)
      {
        int g=(i-j+n)%n;//left index
        int h=(i+j+n)%n;//right index
        
        if(nodes[g]!=null)
        {
          if(debug_level>2) print(i,g,' ');
          Source.addConn( linkfac.makeLink(Source,nodes[g]) );
        }
        
        if(nodes[h]!=null)
        {
          if(debug_level>2) print(i,h,' ');
          Source.addConn( linkfac.makeLink(Source,nodes[h]) );
        }    
        
        if(debug_level>2) println();
      }
    }
  }
}

void makeTorusNet(Node[] nodes,LinkFactory links,int neighborhood)//It is alias only
{
   makeRingNet(nodes,links,neighborhood);
}

void makeTorusNet(Node[][] nodes,LinkFactory linkfac,int neighborhood)
{
  int s=nodes.length;   
  for(int i=0;i<s;i++)
  {
    int z=nodes[i].length;
    for(int k=0;k<z;k++)
    {
      Node Source=nodes[i][k];
      
      if(Source!=null)
      {
        if(debug_level>2) println(i,k,Source,' ');
        
        for(int j=-neighborhood;j<=neighborhood;j++)
        {
          int vert=(s+i+j)%s;//up index
          
          for(int m=-neighborhood;m<=neighborhood;m++)
          {
            int hor=(z+k+m)%z;//right index
            
            Node Target;
            
            if((Target=nodes[vert][hor])!=null && Target!=Source)
            {
              if(debug_level>2) print(vert,hor,' ');
              Source.addConn( linkfac.makeLink(Source,Target) );
            }
  
            if(debug_level>2) println();
          }
        }
      }
    }
  }
}

void makeFullNet(Node[] nodes,LinkFactory linkfac)
{
  int n=nodes.length;
  for(int i=0;i<n;i++)
  {
    Node Source=nodes[i];
    if(Source!=null)
      for(int j=0;j<n;j++)
        if(i!=j && nodes[j]!=null )
        {
          if(debug_level>2) print(i,j);
          
          Source.addConn( linkfac.makeLink(Source,nodes[j]) );
          
          if(debug_level>2) println();
        }
  }
}

void makeRandomNet(Node[] nodes,LinkFactory linkfac,float probability)
{
  int n=nodes.length;
  for(int i=0;i<n;i++)
  {
    Node Source=nodes[i];
    if(Source!=null)
      for(int j=0;j<n;j++)
        if(i!=j && nodes[j]!=null && random(1)<probability)
        {
          if(debug_level>2) print(i,j);
          
          Source.addConn( linkfac.makeLink(Source,nodes[j]) );
          
          if(debug_level>2) println();
        }
  }
}

void makeFullNet(Node[][] nodes,LinkFactory linkfac)
{
  for(int i=0;i<nodes.length;i++)
  for(int g=0;g<nodes[i].length;g++)
  {
    Node Source=nodes[i][g];
    
    if(Source!=null)
      for(int j=0;j<nodes.length;j++)
      for(int h=0;h<nodes[j].length;h++)
      {
        Node Target=nodes[j][h];
        
        if(Target!=null && Source!=Target)
        {
          if(debug_level>2) print(i,g,j,h);
          
          Source.addConn( linkfac.makeLink(Source,Target) );
          
          if(debug_level>2) println();
        }
      }
  }
}

void makeRandomNet(Node[][] nodes,LinkFactory linkfac,float probability)
{
  for(int i=0;i<nodes.length;i++)
  for(int g=0;g<nodes[i].length;g++)
  {
    Node Source=nodes[i][g];
    
    if(Source!=null)
      for(int j=0;j<nodes.length;j++)
      for(int h=0;h<nodes[j].length;h++)
      {
        Node Target=nodes[j][h];
        
        if(Target!=null && Source!=Target && random(1)<probability)
        {
          if(debug_level>2) print(i,g,j,h);
          
          Source.addConn( linkfac.makeLink(Source,Target) );
          
          if(debug_level>2) println();
        }
      }
  }
}

class NodeList extends Node
{                             
  ArrayList<Link> connections;//https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html
  
  NodeList()
  {
    connections=new ArrayList<Link>();
  }
  
  int     addConn(Link   l)
  {
    assert l!=null : "Empty link in "+this.getClass().getName()+".addConn(Link)?"; 
    boolean res=connections.add(l); 
    if(res)
      return   1;
    else
      return   0;
  }
  
  int     delConn(Link   l)
  {
    assert false : "Not implemented "+this.getClass().getName()+".delConn(Link "+l+") called"; 
    return   -1;
  }
  
  Link    getConn(int    i)
  {
    assert i>=connections.size(): "Index out of bound in "+this.getClass().getName()+".getConn(int)"; 
    return connections.get(i);
  }
  
  Link    getConn(Node   n)
  {
    assert n!=null : "Empty node in "+this.getClass().getName()+".getConn(Node)"; 
    for(Link l:connections)
    {
      if(l.target==n) 
            return l;
    }
    return null;
  }
  
  Link    getConn(String k)
  {
    assert k==null || k=="" : "Empty string in "+this.getClass().getName()+".getConn(String)"; 
    for(Link l:connections)
    {
      if(l.target.name()==k) 
            return l;
    }
    return null;
  }
  
  Link[]  getConns(LinkFilter f)
  {
    assert f!=null : "Empty LinkFilter in "+this.getClass().getName()+".getConns(LinkFilter)"; 
    ArrayList<Link> selected=new ArrayList<Link>();
    for(Link l:connections)
    {
      if(f.meetsTheAssumptions(l)) 
            selected.add(l);
    }
    
    Link[] ret=new Link[selected.size()];
    selected.toArray(ret);
    return ret;
  }
}

class NodeMap extends Node
{
  HashMap<String,Link> connections;//https://docs.oracle.com/javase/6/docs/api/java/util/HashMap.html
  
  NodeMap()
  {
    connections=new HashMap<String,Link>(); 
  }
  
  int     addConn(Link   l)
  {
    assert l!=null : "Empty link in "+this.getClass().getName()+".addConn(Link)?"; 
    String key=l.target.name();
    Link old=connections.put(key,l); 
    if(old==null)
      return   1;
    else
      return 0;
  }
  
  int     delConn(Link   l)
  {
    assert false : "Not implemented "+this.getClass().getName()+".delConn(Link "+l+") called"; 
    return   -1;
  }
  
  Link    getConn(int    i)
  {
    assert i>=connections.size(): "Index out of bound in "+this.getClass().getName()+".getConn(int)"; 
    assert false: "Non optimal use of NodeMap in getConn(int)";
    int counter=0;
    for(Map.Entry<String,Link> ent:connections.entrySet())
    {
      if(i==counter) 
          return ent.getValue();
      counter++;
    }
    return null;
  }
  
  Link    getConn(Node   n)
  {
    assert n!=null : "Empty node in "+this.getClass().getName()+".getConn(Node)"; 
    String key=n.name();
    return connections.get(key);
  }
  
  Link    getConn(String k)
  {
    assert k==null || k=="" : "Empty string in "+this.getClass().getName()+".getConn(String)"; 
    return connections.get(k);
  }
  
  Link[]  getConns(LinkFilter f)
  {
    assert f!=null : "Empty LinkFilter in "+this.getClass().getName()+".getConns(LinkFilter)"; 
    ArrayList<Link> selected=new ArrayList<Link>();
    for(Map.Entry<String,Link> ent:connections.entrySet())
    {
      if(f.meetsTheAssumptions(ent.getValue())) 
            selected.add(ent.getValue());
    }
    Link[] ret=new Link[selected.size()];
    selected.toArray(ret);
    return ret;
  }
}

///////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - SOCIAL NETWORK TEMPLATE
///////////////////////////////////////////////////////////////////////////////////////////
