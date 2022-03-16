import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.Map; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Optionals4Networks extends PApplet {

//static int debug_level=0;
final int    LINK_INTENSITY=2;    ///< For network visualisation
final float  MAX_LINK_WEIGHT=1.0f; ///< Also for network visualisation
final int    MASKBITS=0xffffffff; ///< Redefine, when smaller width is required

public void setup()
{
  
}
/// COMMON TEMPLATES 
///*/////////////////////////////////////////////////////////////////////////////////////////
/// USE /*_interfunc*/ &  /*_forcbody*/ for interchangeable function 
/// if you need translate the code into C++ (--> Processing2C )

/// Simple version of Pair template useable for returning a pair of values
public class Pair<A,B> {
    public final A a;
    public final B b;

    public Pair(A a, B b) 
    {
        this.a = a;
        this.b = b;
    }
}//EndOfClass

//*///////////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*///////////////////////////////////////////////////////////////////////////////////////////////////
/// COMMON INTERFACES
/// See: "https://github.com/borkowsk/RTSI_public"
//*//////////////////////////////////////////////////////////////////////////////
/// USE /*_interfunc*/ &  /*_forcbody*/ for interchangeable function 
/// if you need translate the code into C++ (--> Processing2C )

//*
/// Generally useable interfaces:
//*
//*//////////////////////////////

/// Forcing name available as String (planty of usage)
interface iNamed {
  /*_interfunc*/ public String    name() /*_forcbody*/;
}//EndOfClass

/// Any object which have description as (potentially) long, multi line string
interface iDescribable { 
  /*_interfunc*/ public String Description() /*_forcbody*/;
}//EndOfClass

//*
/// MATH INTERFACES:
//*
//*////////////////////////////////////////////////////////////////////////////

final float INF_NOT_EXIST=Float.MAX_VALUE;  ///< Missing value marker

/// A function of two values in the form of a class - a functor
interface Function2D {
  /*_interfunc*/ public float calculate(float X,float Y)/*_forcbody*/;
  /*_interfunc*/ public float getMin()/*_forcbody*/;//MIN_RANGE_VALUE?
  /*_interfunc*/ public float getMax()/*_forcbody*/;//Always must be different!
}//EndOfClass

//*
/// VISUALISATION INTERFACES:
//*
//*///////////////////////////

/// Forcing setFill & setStroke methods for visualisation
interface iColorable {
  /*_interfunc*/ public void setFill(float intensity)/*_forcbody*/;
  /*_interfunc*/ public void setStroke(float intensity)/*_forcbody*/;
}//EndOfClass

/// Forcing posX() & posY() & posZ() methods for visualisation and mapping  
interface iPositioned {              
  /*_interfunc*/ public float    posX()/*_forcbody*/;
  /*_interfunc*/ public float    posY()/*_forcbody*/;
  /*_interfunc*/ public float    posZ()/*_forcbody*/;
}//EndOfClass

//*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//*  Last modification 2022.03.16
//*  See: "https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI" - USEFULL COMMON INTERFACES
//*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Different filters of links and other link tools for a (social) network
//*/////////////////////////////////////////////////////////////////////////
/// Available filters: 
///   AllLinks, AndFilter, OrFilter, TypeFilter,
///   LowPassFilter,   HighPassFilter,
///   AbsLowPassFilter, AbsHighPassFilter
///   TypeAndAbsHighPassFilter - special type for efficient visualisation

/// Simplest link filtering class which accepts all links
class AllLinks extends LinkFilter
{
  public boolean meetsTheAssumptions(iLink l) { return true;}
}//EndOfClass

final AllLinks allLinks=new AllLinks();  ///< Such type of filter is used very frequently

/// Special type of filter for efficient visualisation
class TypeAndAbsHighPassFilter  extends LinkFilter
{
  int ltype;
  float treshold;
  TypeAndAbsHighPassFilter(){ ltype=-1;treshold=0;}
  TypeAndAbsHighPassFilter(int t,float tres) { ltype=t;treshold=tres;}
  public TypeAndAbsHighPassFilter reset(int t,float tres) { ltype=t;treshold=tres;return this;}
  public boolean meetsTheAssumptions(iLink l) { return l.getTypeMarker()==ltype && abs(l.getWeight())>treshold;}
}//EndOfClass

/// AND two filters assembly class.
/// A class for logically joining two filters with the AND operator.
class AndFilter extends LinkFilter
{
   LinkFilter a;
   LinkFilter b;
   AndFilter(LinkFilter aa,LinkFilter bb){a=aa;b=bb;}
   public boolean meetsTheAssumptions(iLink l) 
   { 
     return a.meetsTheAssumptions(l) && b.meetsTheAssumptions(l);
   }
}//EndOfClass

/// OR two filters assembly class.
/// A class for logically joining two filters with the OR operator.
class OrFilter extends LinkFilter
{
   LinkFilter a;
   LinkFilter b;
   OrFilter(LinkFilter aa,LinkFilter bb){a=aa;b=bb;}
   public boolean meetsTheAssumptions(iLink l) 
   { 
     return a.meetsTheAssumptions(l) || b.meetsTheAssumptions(l);
   }
}//EndOfClass

/// Type of link filter.
/// Class which filters links of specific "color"/"type"
class TypeFilter extends LinkFilter
{
  int ltype;
  TypeFilter(int t) { ltype=t;}
  public boolean meetsTheAssumptions(iLink l) { return l.getTypeMarker()==ltype;}
}//EndOfClass

/// Low Pass Filter.
/// Class which filters links with lower weights
class LowPassFilter extends LinkFilter
{
  float treshold;
  LowPassFilter(float tres) { treshold=tres;}
  public boolean meetsTheAssumptions(Link l) { return l.weight<treshold;}
}//EndOfClass

/// High Pass Filter.
/// Class which filters links with higher weights
class HighPassFilter extends LinkFilter
{
  float treshold;
  HighPassFilter(float tres) { treshold=tres;}
  public boolean meetsTheAssumptions(iLink l) { return l.getWeight()>treshold;}
}//EndOfClass

/// Absolute Low Pass Filter.
/// lowPassFilter filtering links with lower absolute value of weight
class AbsLowPassFilter extends LinkFilter
{
  float treshold;
  AbsLowPassFilter(float tres) { treshold=abs(tres);}
  public boolean meetsTheAssumptions(iLink l) { return abs(l.getWeight())<treshold;}
}//EndOfClass

/// Absolute High Pass Filter.
/// highPassFilter filtering links with higher absolute value of weight
class AbsHighPassFilter extends LinkFilter
{
  float treshold;
  AbsHighPassFilter(float tres) { treshold=abs(tres);}
  public boolean meetsTheAssumptions(iLink l) { return abs(l.getWeight())>treshold;}
}//EndOfClass

//*///////////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*///////////////////////////////////////////////////////////////////////////////////////////////////
/// Network Only Interfaces
//*///////////////////////////////////////////

// NETWORK INTERFACES:
/////////////////////////////////////////////////////////////////////////////////

/// Network connection/link interface
/// Is iLink interface really needed?
interface iLink { 
  /*_interfunc*/ public float getWeight()/*_forcbody*/;
  /*_interfunc*/ public int   getTypeMarker()/*_forcbody*/;
}//EndOfClass

interface iLinkFilter
{
  /*_interfunc*/ public boolean meetsTheAssumptions(iLink l)/*_forcbody*/;
}//EndOfClass

/// Network node interface
/// "Conn" below is a shortage from Connection.
interface iNode extends iNamed { 
  //using class Link not interface iLink because of efficiency!
  /*_interfunc*/ public int      addConn(iLink  l)/*_forcbody*/;
  /*_interfunc*/ public int      delConn(iLink  l)/*_forcbody*/;
  /*_interfunc*/ public int      numOfConn()      /*_forcbody*/;
  /*_interfunc*/ public iLink    getConn(int    i)/*_forcbody*/;
  /*_interfunc*/ public iLink    getConn(iNode  n)/*_forcbody*/;
  /*_interfunc*/ public iLink    getConn(String k)/*_forcbody*/;
  /*_interfunc*/ public iLink[]  getConns(iLinkFilter f)/*_forcbody*/;
}//EndOfClass

/// Visualisable network node
interface iVisNode extends iNode,iNamed,iColorable,iPositioned {
}//EndOfClass

/// Visualisable network connection
interface  iVisLink extends iLink,iNamed,iColorable {
  /*_interfunc*/ public int     defColor()/*_forcebody*/;
}//EndOfClass

//*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//*  Last modification 2022.03.16
//*  See: "https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI" - NETWORKS INTERFACES
//*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/// Generic (social) network classes
//*////////////////////////////////////////////////////////////
// Classes:
//*/////////
// class Link extends Colorable implements iLink //USER CAN MODIFY FOR THE SAKE OF EFFICIENCY
// class NodeList extends Node
// class NodeMap extends Node
//
//   INTERFACES:
//*///////////////////
// interface iLink 
// interface iNode
//
//   Abstractions:
//*///////////////////
// abstract class Node extends Positioned 
//
// abstract class LinkFilter
// abstract class LinkFactory
//
// abstract class Named implements iNamed
// abstract class Colorable extends Named implements iColorable
// abstract class Positioned extends Colorable implements iPositioned
//
//
// Network generators: 
//*////////////////////
// void makeRingNet(Node[] nodes,LinkFactory links,int neighborhood);
// void makeTorusNet(Node[] nodes,LinkFactory links,int neighborhood);
// void makeTorusNet(Node[][] nodes,LinkFactory links,int neighborhood);
// 
// void makeFullNet(Node[] nodes,LinkFactory links);
// void makeFullNet(Node[][] nodes,LinkFactory links);
// 
// void makeRandomNet(Node[] nodes,LinkFactory links,float probability, boolean reciprocal);
// void makeRandomNet(Node[][] nodes,LinkFactory links,float probability, boolean reciprocal);
//
// void makeOrphansAdoption(Node[] nodes,LinkFactory links, boolean reciprocal);
// 
// void makeSmWorldNet(Node[] nodes,LinkFactory links,int neighborhood,float probability, boolean reciprocal);
// void makeImSmWorldNet(Node[] nodes,LinkFactory links,int neighborhood,float probability, boolean reciprocal);
// 
//



int debug_level=1;  ///< DEBUG level for network. Visible autside this file!

// ABSTRACT BASE CLASSES
///////////////////////////////////

/// 
abstract class LinkFilter implements iLinkFilter {
  /*_interfunc*/ public boolean meetsTheAssumptions(iLink l)
                  {assert false : "Pure interface meetsTheAssumptions(Link) called"; return false;}
};

/// 
abstract class LinkFactory {
  /*_interfunc*/ public Link  makeLink(Node Source,Node Target)
                  {assert false : "Pure interface make(Node,Node) called"; return null;}
                 public Link  makeSelfLink(Node Self)
                  {assert false : "Pure interface make(Node) called"; return null;}
};

/// Forcing name() method for visualisation and mapping 
abstract class Named implements iNamed {       
  /*_interfunc*/ public String    name(){assert false : "Pure interface name() called"; return null;}
};

/// Only for visualisation
abstract class Colorable extends Named implements iColorable {
  /*_interfunc*/ public void setFill(float modifier){assert false : "Pure interface setFill() called";}
  /*_interfunc*/ public void setStroke(float modifier){assert false : "Pure interface setStroke() called";}
};

/// Forcing posX() & posY() & posZ() methods for visualisation and mapping  
abstract class Positioned extends Colorable implements iPositioned {
  /*_interfunc*/ public float    posX(){assert false : "Pure interface posX() called"; return 0;}
  /*_interfunc*/ public float    posY(){assert false : "Pure interface posY() called"; return 0;}
  /*_interfunc*/ public float    posZ(){assert false : "Pure interface posZ() called"; return 0;}
};

///INFO: 
abstract class Node extends Positioned implements iNode {
  /*_interfunc*/ public int     addConn(Link   l){assert false : "Pure interface addConn(Link "+l+") called"; return   -1;}
  /*_interfunc*/ public int     delConn(Link   l){assert false : "Pure interface delConn(Link "+l+") called"; return   -1;}
  /*_interfunc*/ public int     numOfConn()      {assert false : "Pure interface numOfConn() called"; return   -1;}
  /*_interfunc*/ public Link    getConn(int    i){assert false : "Pure interface getConn(int "+i+")  called"; return null;}
  /*_interfunc*/ public Link    getConn(Node   n){assert false : "Pure interface getConn(Node "+n+") called"; return null;}
  /*_interfunc*/ public Link    getConn(String k){assert false : "Pure method  getConn(String '"+k+"') called"; return null;}
  /*_interfunc*/ public Link[]  getConns(LinkFilter f)
                  {assert false : "Pure interface getConns(LinkFilter "+f+") called"; return null;}
};

//   CLASS FOR MODIFICATION:
//*//////////////////////////

/// This class is available for user modifications
class Link extends Colorable implements iLink,iVisLink,Comparable<Link> {
  Node  target;
  float weight;//importance/trust
  int   ltype;//"color"
  //... add something, if you need in derived classes
  
  //Constructor (may vary)
  Link(Node targ,float we,int ty){ target=targ;weight=we;ltype=ty;}
  
  public String fullInfo(String fieldSeparator)
  {
    return "W:"+weight+fieldSeparator+"Tp:"+ltype+fieldSeparator+"->"+target;
  }
  
  //For sorting. Much weighted link should be at the begining of the array!
  public int  compareTo(Link o)//Compares this object with the specified object for order.
  {
     if(o==this || o.weight==weight) return 0;
     else
     if(o.weight>weight) return 1;
     else return -1;
  }
  
  //For visualisation and mapping  
  public String name(){ return target.name(); }
  
  public float getWeight() { return weight;}
  public int   getTypeMarker() { return ltype; }
  
  public int     defColor()
  {
     switch ( ltype )
     {
     case 0: if(weight<=0) return color(0,-weight*255,0);else return color(weight*255,0,weight*255);
     case 1: if(weight<=0) return color(-weight*255,0,0);else return color(0,weight*255,weight*255);
     case 2: if(weight<=0) return color(0,0,-weight*255);else return color(weight*255,weight*255,0);
     default://Wszystkie inne 
             if(weight>=0) return color(128,0,weight*255);else return color(-weight*255,-weight*255,128);
     }   
  }
  
  public void setStroke(float Intensity)
  {  //float   MAX_LINK_WEIGHT=2;   ///Use maximal strokeWidth for links
     strokeWeight(abs(weight)*MAX_LINK_WEIGHT);
     switch ( ltype )
     {
     case 0: if(weight<=0) stroke(0,-weight*255,0,Intensity);else stroke(weight*255,0,weight*255,Intensity);break;
     case 1: if(weight<=0) stroke(-weight*255,0,0,Intensity);else stroke(0,weight*255,weight*255,Intensity);break;
     case 2: if(weight<=0) stroke(0,0,-weight*255,Intensity);else stroke(weight*255,weight*255,0,Intensity);break;
     default://Wszystkie inne 
             if(weight>=0) stroke(128,0,weight*255,Intensity);else stroke(-weight*255,-weight*255,128,Intensity);
             break;
     }
  }
};

/// Simplest link factory creates identical links except for the targets
/// It also serves as an example of designing factories.
class basicLinkFactory extends LinkFactory
{
  float default_weight;
  int   default_type;
  
  basicLinkFactory(float def_weight,int def_type){ default_weight=def_weight;default_type=def_type;}
  
  public Link  makeLink(Node Source,Node Target)
  {
    return new Link(Target,default_weight,default_type);
  }
}

//   IMPLEMENTATIONS:
//*////////////////////

/// Ring network
public void makeRingNet(Node[] nodes,LinkFactory linkfac,int neighborhood) {
  int n=nodes.length;
  for(int i=0;i<n;i++)
  {
    Node Source=nodes[i];
    
    if(Source!=null)
    {
      if(debug_level>2) println("i="+i,"Source="+Source,' ');
      
      for(int j=1;j<=neighborhood;j++)
      {
        int g=(n+i-j)%n;//left index
        int h=(i+j+n)%n;//right index
        
        if(nodes[g]!=null)
        {
          if(debug_level>2) print("i="+i,"g="+g,' ');
          Source.addConn( linkfac.makeLink(Source,nodes[g]) );
        }
        
        if(nodes[h]!=null)
        {
          if(debug_level>2) print("i="+i,"h="+h,' ');
          Source.addConn( linkfac.makeLink(Source,nodes[h]) );
        }    
        
        if(debug_level>2) println();
      }
    }
  }
}

/// Torus lattice 1D - It is alias for Ring net only
public void makeTorusNet(Node[] nodes,LinkFactory links,int neighborhood) {  
   makeRingNet(nodes,links,neighborhood);
}

/// Torus lattice 2D
public void makeTorusNet(Node[][] nodes,LinkFactory linkfac,int neighborhood) {
  int s=nodes.length;   
  for(int i=0;i<s;i++)
  {
    int z=nodes[i].length;
    for(int k=0;k<z;k++)
    {
      Node Source=nodes[i][k];
      
      if(Source!=null)
      {
        if(debug_level>2) println("i="+i,"k="+k,"Source="+Source,' ');
        
        for(int j=-neighborhood;j<=neighborhood;j++)
        {
          int vert=(s+i+j)%s;//up index
          
          for(int m=-neighborhood;m<=neighborhood;m++)
          {
            int hor=(z+k+m)%z;//right index
            
            Node Target;
            
            if((Target=nodes[vert][hor])!=null && Target!=Source)
            {
              if(debug_level>2) print("Vert="+vert,"Hor="+hor,' ');
              Source.addConn( linkfac.makeLink(Source,Target) );
            }
  
            if(debug_level>2) println();
          }
        }
      }
    }
  }
}

/// Rewire some connection for Small World 1D
public void rewireLinksRandomly(Node[] nodes,float probability, boolean reciprocal) { 
  for(int i=0;i<nodes.length;i++)
  {
    Node Source=nodes[i];
    if(Source==null) 
                  continue;
                  
    if(random(1.0f)<probability)
    {
      int j=(int)random(nodes.length);
      Node Target=nodes[j];
      
      if(Target==null || Source==Target 
         || Source.getConn(Target)!=null 
         )
         continue; //To losowanie nie ma sensu   
         
      //if(debug_level>2) print("i="+i,"g="+g,"j="+j);
       
      int index=(int)random(Source.numOfConn());  assert index<Source.numOfConn(); 
      Link l=Source.getConn(index);
      
      if(reciprocal)
      {
        Link r=l.target.getConn(Source);
        if(r!=null) 
        {
          l.target.delConn(r);//Usunięcie zwrotnego linku jesli był
          r.target=Source;//Poprawienie linku
          Target.addConn(r);//Dodanie nowego zwrotnego linku w Targecie
        }  
      }
      
      l.target=Target;//Replacing target!    
      //if(debug_level>2) println();
    }  
  }
}

/// Rewire some connection for Small World 2D
public void rewireLinksRandomly(Node[][] nodes,float probability, boolean reciprocal) { 
  for(int i=0;i<nodes.length;i++)
  for(int g=0;g<nodes[i].length;g++)
  {
    Node Source=nodes[i][g];
    if(Source==null) 
                  continue;                  
    //Czy tu jakiś link zostanie przerobiony?
    if(random(1.0f)<probability)
    {
      //Nowy target - trzeba trafić           
      int j=(int)random(nodes.length);
      int h=(int)random(nodes[j].length);
      Node Target=nodes[j][h];
      if(Target==null || Source==Target 
         || Source.getConn(Target)!=null 
         )
         continue; //To losowanie nie ma sensu       
      
      //if(debug_level>2) print("i="+i,"g="+g,"j="+j,"h="+h);
       
      int index=(int)random(Source.numOfConn());      assert index<Source.numOfConn();       
      Link l=Source.getConn(index);
 
      if(reciprocal)
      {
        Link r=l.target.getConn(Source);
        if(r!=null) 
        {
          l.target.delConn(r);//Usunięcie zwrotnego linku jesli był
          r.target=Source;//Poprawienie linku
          Target.addConn(r);//Dodanie nowego zwrotnego linku w Targecie
        }  
      }
      
      l.target=Target;//Replacing target!
      //if(debug_level>2) println();
    }  
  }
}

/// Classic Small World 1D
public void makeSmWorldNet(Node[] nodes,LinkFactory links,int neighborhood,float probability, boolean reciprocal) { 
  makeTorusNet(nodes,links,neighborhood);
  rewireLinksRandomly(nodes,probability,  reciprocal);
}

/// Classic Small World 2D
public void makeSmWorldNet(Node[][] nodes,LinkFactory links,int neighborhood,float probability, boolean reciprocal) { 
  makeTorusNet(nodes,links,neighborhood);
  rewireLinksRandomly(nodes,probability,  reciprocal);
}

/// Improved Small World 2D
public void makeImSmWorldNet(Node[][] nodes,LinkFactory links,int neighborhood,float probability, boolean reciprocal) { 
  makeTorusNet(nodes,links,neighborhood);
  makeRandomNet(nodes,links,probability,  reciprocal);
}

/// Improved Small World 1D
public void makeImSmWorldNet(Node[] nodes,LinkFactory links,int neighborhood,float probability, boolean reciprocal) { 
  makeTorusNet(nodes,links,neighborhood);
  makeRandomNet(nodes,links,probability,  reciprocal);
}

/*_inline*/ public boolean inCluster(Node[] cluster,Node what)
{
  for(int j=0;j<cluster.length;j++)
   if(cluster[j]==what) //juz jest w cluster'ze
   {
     if(debug_level>2) 
         println("node",what,"already on list!!!");
     return true;
   }
  return false;
}

/// Scale Free 1D
public void makeScaleFree(Node[] nodes,LinkFactory linkfac,int sizeOfFirstCluster,int numberOfNewLinkPerAgent, boolean reciprocal) {
  if(debug_level>1) println("MAKING SCALE FREE",sizeOfFirstCluster,numberOfNewLinkPerAgent,reciprocal);
  Node[] cluster=new Node[sizeOfFirstCluster];//if(debug_level>3) println("Initial:",(Node[])cluster);//Nodes for initial cluster
  
  for(int i=0;i<sizeOfFirstCluster;)
  {
    int  pos=(int)random(nodes.length);
    Node pom=nodes[pos];
    if(inCluster(cluster,pom))
            continue;
    cluster[i]=pom;     
    i++;
  }
  makeFullNet(cluster,linkfac);//Linking of initial cluster
  
  float numberOfLinks=0;
  for(Node nod:nodes )
    if(nod!=null)
      numberOfLinks+=nod.numOfConn();
      
  float EPS=1e-45f;//Najmniejszy możliwy float
  println("Initial number of links is",numberOfLinks,EPS);
  
  for(int i=0;i<numberOfNewLinkPerAgent;i++)
    for(int j=0;j<nodes.length;)//Próbujemy każdego przyłączyć do czegoś
    {
        Node source=nodes[j];
        if(source==null)
            continue;
            
        float where=EPS+random(1.0f);                      assert(where>0.0f);//"where" okresli do którego węzła się przyłączymy
        float start=0;                                    if(debug_level>2) print(j,where,"->");
        for(int k=0;k<nodes.length;k++)
        {
          Node target=nodes[k];
          if(target==null)
            continue;  
            
          float pwindow=target.numOfConn()/numberOfLinks; if(debug_level>3) print(pwindow,"; ");
          if(start<where && where<=start+pwindow)         //Czy trafił w przedział?
          {
                                                          if(debug_level>2) print(k,"!");
            if(source!=target)
            {
              int success=source.addConn( linkfac.makeLink(source,target) );
              if( success==1 ) //TYLKO GDY NOWY LINK!
              {
                numberOfLinks++;
                if(reciprocal)
                  if(target.addConn( linkfac.makeLink(target,source) )==1)//OK TYLKO GDY NOWY LINK
                      numberOfLinks++;
                j++;//Można przejść do podłączania nastepnego agenta
              }
            }
            
            break;//Znaleziono potencjalny target. Jeśli nie nastąpiło podłączenie to i tak trzeba losować od nowa
          }
          else
          {
            start+=pwindow;//To jeszcze nie ten
          }
        }                                                  if(debug_level>2) println();
    }
    if(debug_level>1) println("DONE! SCALE FREE HAS MADE");
}

/// Full connected network 1D
public void makeFullNet(Node[] nodes,LinkFactory linkfac) {
  int n=nodes.length;
  for(int i=0;i<n;i++)
  {
    Node Source=nodes[i];
    if(Source!=null)
      for(int j=0;j<n;j++)
        if(i!=j && nodes[j]!=null )
        {
          if(debug_level>4) print("i="+i,"j="+j);
          
          Source.addConn( linkfac.makeLink(Source,nodes[j]) );
          
          if(debug_level>4) println();
        }
  }
}

/// Full connected network 2D
public void makeFullNet(Node[][] nodes,LinkFactory linkfac) {
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
          if(debug_level>4) print("i="+i,"g="+g,"j="+j,"h="+h);
          
          Source.addConn( linkfac.makeLink(Source,Target) );
          
          if(debug_level>4) println();
        }
      }
  }
}

/// Randomly connected network 1D
public void makeRandomNet(Node[] nodes,LinkFactory linkfac,float probability, boolean reciprocal) {  
  //NO ERROR!: rings in visualisation are because agents may have sometimes exactly same position!!!
  int n=nodes.length;
  for(int i=0;i<n;i++)
  {
    Node Source=nodes[i];
    if(Source==null)
        continue;
        
    if(reciprocal)
    {
      for(int j=i+1;j<n;j++)
      {
        Node Target=nodes[j];
        if(Target!=null && Source!=Target && random(1.0f)<probability)
        {
          if(debug_level>2) print("i="+i,"j="+j);
                                                                
          int success=Source.addConn( linkfac.makeLink( Source, Target ) );
          if(success==1)
            Target.addConn( linkfac.makeLink( Target, Source ) );
          
          if(debug_level>2) println();
        }
      }   
    }
    else
    {
      for(int j=0;j<n;j++)
      {
        Node Target=nodes[j];
        if(Target!=null && Source!=Target && random(1.0f)<probability)
        {
          if(debug_level>2) print("i="+i,"j="+j);
                                                                
          //int success=
          Source.addConn( linkfac.makeLink( Source, Target ) );
          
          if(debug_level>2) println();
        }
      }       
    }
  }
}

/// Connect all orphaned nodes with at least one link
public void makeOrphansAdoption(Node[] nodes,LinkFactory linkfac, boolean reciprocal) {
  int n=nodes.length;
  for(int i=0;i<n;i++)
  {
    Node Source=nodes[i];
    if(Source==null || Source.numOfConn() > 0)
        continue;
        
    //Only if exists and is orphaned
                                                                      if(debug_level>0) print("Orphan",nf(i,3),":");
    Node Target=null;int Ntry=n;
    while(Target==null)//Searching for foster parent
    {
      int t=(int)random(n);
      if( t==i                //candidate is not self
      ||  nodes[t]==null      //is not empty 
      ||  (nodes[t].numOfConn()==0 //is not other orphan
           && Ntry-- > 0  )   //but not when all are orphans!
      ) continue;
                                                                       
      Target=nodes[t];//Candidate ok
                                                                      if(debug_level>0) print("(",Ntry,")",nf(t,3),"is a chosen one ", Target.name() ); 
    }
                                                                      //if(debug_level>1) print(" S has ", Source.numOfConn() ," links");
    int success=Source.addConn( linkfac.makeLink( Source, Target ) ); 
                                                                      //if(debug_level>1) print(" Now S has ", Source.numOfConn() ," ");
    if(success!=1)
    {
       print(" WRONG! BUT WHY? ");
    }
    else
    if(reciprocal)
    {                                                                 //if(debug_level>1) print(" T has", Target.numOfConn() ," links");
       success=Target.addConn( linkfac.makeLink( Target, Source ) );
                                                                      //if(debug_level>1) print(" Now T has", Target.numOfConn() ," ");
    }
    
                                                                      if(debug_level>0)
                                                                        if(success==1)  println(" --> Not any more orphaned!");
                                                                        else  println("???",success);
  }
}

/// Randomly connected network 2D
public void makeRandomNet(Node[][] nodes,LinkFactory linkfac,float probability, boolean reciprocal) {
  for(int i=0;i<nodes.length;i++)
  for(int g=0;g<nodes[i].length;g++)
  {
    Node Source=nodes[i][g];
    
    if(Source==null)
      continue;
    
    if(reciprocal)
    {  
      for(int j=i+1;j<nodes.length;j++)
      for(int h=g+1;h<nodes[j].length;h++)
      {
        Node Target=nodes[j][h];
        
        if(Target!=null && Source!=Target && random(1)<probability)
        {
          if(debug_level>2) print("i="+i,"g="+g,"j="+j,"h="+h);
                                                               
          int success=Source.addConn( linkfac.makeLink(Source,Target) );
          if(success==1)
            Target.addConn( linkfac.makeLink(Target,Source) );
            
          if(debug_level>2) println();
        }
      }
    }
    else
    {
      for(int j=0;j<nodes.length;j++)
      for(int h=0;h<nodes[j].length;h++)
      {
        Node Target=nodes[j][h];
        
        if(Target!=null && Source!=Target && random(1)<probability)
        {
          if(debug_level>2) print("i="+i,"g="+g,"j="+j,"h="+h);
                                                               
          //int success=
          Source.addConn( linkfac.makeLink(Source,Target) );
            
          if(debug_level>2) println();
        }
      }
    }
  }
}

/// Node implementation based on list
class NodeList extends Node {
  ArrayList<Link> connections;//https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html
  
  NodeList()
  {
    connections=new ArrayList<Link>();
  }
  
  public int     numOfConn()      { return connections.size();}
  
  public int     addConn(iLink   l)
  {
    println("NodeList.addConn(iLink   l) not implemented");
    return -1;
  }
  
  public int     addConn(Link   l)
  {
    assert l!=null : "Empty link in "+this.getClass().getName()+".addConn(Link)?"; 
    if(debug_level>2 && l.target==this) //It may not be expected!
            print("Self connecting of",l.target.name());
            
    boolean res=false;
    
    if(getConn(l.target)==null)
    {
        res=connections.add(l);
        if(debug_level>4) print('|');
    }
    else if(debug_level>0) println("Link",this.name(),"->",l.target.name(),"already exist");
        
    if(res)
      return   1;
    else
      return   0;
  }
  
  public int     delConn(iLink   l)
  {
    if(connections.remove(l))
      return 1;
    else
      return 0;
  }
  
  public Link    getConn(int    i)
  {
    assert i<connections.size(): "Index '"+i+"' out of bound '"+connections.size()+"' in "+this.getClass().getName()+".getConn(int)"; 
    return connections.get(i);
  }
  
  public Link    getConn(iNode   n)
  {
    assert n!=null : "Empty node in "+this.getClass().getName()+".getConn(Node)"; 
    for(Link l:connections)
    {
      if(l.target==n) 
            return l;
    }
    return null;
  }
  
  public Link    getConn(String k)
  {
    assert k==null || k=="" : "Empty string in "+this.getClass().getName()+".getConn(String)"; 
    for(Link l:connections)
    {
      if(l.target.name()==k) 
            return l;
    }
    return null;
  }
  
  public Link[]  getConns(iLinkFilter f)
  {
    //assert f!=null : "Empty LinkFilter in "+this.getClass().getName()+".getConns(LinkFilter)"; 
    ArrayList<Link> selected=new ArrayList<Link>();
    for(Link l:connections)
    {
      if(f==null || f.meetsTheAssumptions(l)) 
            selected.add(l);
    }
    
    Link[] ret=new Link[selected.size()];
    selected.toArray(ret);
    return ret;
  }
};

/// Node implementation based on hash map
class NodeMap extends Node {  
  //HashMap<Integer,Link> connections;//TODO using Object.hashCode(). Should be a bit faster than String
  HashMap<String,Link> connections;//https://docs.oracle.com/javase/6/docs/api/java/util/HashMap.html
  
  NodeMap()
  {
    connections=new HashMap<String,Link>(); 
  }
  
  public int     numOfConn()      { return connections.size();}
  
  public int     addConn(iLink   l)
  {
    println("NodeMap.addConn(iLink   l) not implemented");
    return -1;
  }
  
  public int     addConn(Link   l)
  {
    assert l!=null : "Empty link in "+this.getClass().getName()+".addConn(Link)?"; 
    if(debug_level>2 && l.target==this) //It may not be expected!
            print("Self connecting of",l.target.name());
            
    //int hash=l.target.hashCode();//((Object)this).hashCode() for HashMap<Integer,Link>      
    String key=l.target.name();
    Link old=connections.put(key,l); 
    
    if(old==null)
      return   1;
    else
      return 0;
  }
  
  public int     delConn(iLink   l)
  {
    assert false : "Not implemented "+this.getClass().getName()+".delConn(Link "+l+") called"; 
    return   -1;
  }
  
  public Link    getConn(int    i)
  {
    assert i>=connections.size():"Index '"+i+"' out of bound '"+connections.size()+"' in "+this.getClass().getName()+".getConn(int)"; 
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
  
  public Link    getConn(iNode   n)
  {
    assert n!=null : "Empty node in "+this.getClass().getName()+".getConn(Node)"; 
    String key=n.name();
    return connections.get(key);
  }
  
  public Link    getConn(String k)
  {
    assert k==null || k=="" : "Empty string in "+this.getClass().getName()+".getConn(String)"; 
    return connections.get(k);
  }
  
  public Link[]  getConns(iLinkFilter f)
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
};

//*///////////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*///////////////////////////////////////////////////////////////////////////////////////////////////
/// Various helpful drawing procedures
//*//////////////////////////////////////////////////////////////

/// Frame drawn with a default line
public void surround(int x1,int y1,int x2,int y2)
{
  line(x1,y1,x2,y1);//--->
  line(x2,y1,x2,y2);//vvv
  line(x1,y2,x2,y2);//<---
  line(x1,y1,x1,y2);//^^^
}

/// Cross drawn with a default line
public void cross(float x,float y,float cross_width)
{
  line(x-cross_width,y,x+cross_width,y);
  line(x,y-cross_width,x,y+cross_width);
}

/// Cross drawn with a default line 
/// The version that uses parameters of type int.
public void cross(int x,int y,int cross_width)
{
  line(x-cross_width,y,x+cross_width,y);
  line(x,y-cross_width,x,y+cross_width);
}

/// The bald head of a man seen from above
public void baldhead(int x,int y,int r,float direction)
{
  float D=2*r;
  float xn=x+r*cos(direction);
  float yn=y+r*sin(direction);
  ellipse(xn,yn,D/5,D/5);  //Nos
  xn=x+0.95f*r*cos(direction+PI/2);
  yn=y+0.95f*r*sin(direction+PI/2);
  ellipse(xn,yn,D/4,D/4);  //Ucho  1
  xn=x+0.95f*r*cos(direction-PI/2);
  yn=y+0.95f*r*sin(direction-PI/2);
  ellipse(xn,yn,D/4,D/4);  //Ucho  2
  //Glówny blok
  ellipse(x,y,D,D);
}

//*
/// POLYGONS
//*
//*/////////////////////

/// A regular polygon with a given radius and number of vertices
public void regularpoly(float x, float y, float radius, int npoints) 
{
  float angle = TWO_PI / npoints;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) 
  {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}

/// A class to represent two-dimensional points
class pointxy 
{
  float x,y;
  
  pointxy()
  {
    x=y=0;
  }
  
  pointxy(float ix,float iy)
  {
    x=ix;y=iy;
  }
}//EndOfClass

/// Drawing a polygon. 
/// It utilises vertices given as an array of points
public void polygon(pointxy[] lst/*+1*/)
{
  int N= lst.length;
  beginShape();
  for (int a = 0; a < N; a ++) 
  {
    vertex(lst[a].x,lst[a].y);
  }
  endShape(CLOSE);
}

/// Drawing a polygon. 
/// It utilises vertices given as an array of points
/// @param N, size of list, could be smaller than 'lst.lenght'
public void polygon(pointxy[] lst/*+1*/,int N)
{
  beginShape();
  for (int a = 0; a < N; a ++) 
  {
    vertex(lst[a].x,lst[a].y);
  }
  endShape(CLOSE);
}

/// Nearest points of two polygons.
public Pair<pointxy,pointxy> nearestPoints(final pointxy[] listA,final pointxy[] listB)
{                                    
                                    assert(listA.length>0);
                                    assert(listB.length>0);
  float mindist=MAX_FLOAT;
  int   minA=-1;
  int   minB=-1;
  for(int i=0;i<listA.length;i++)
    for(int j=0;j<listB.length;j++) //Pętla nadmiarowa (?)
    {
      float x2=(listA[i].x-listB[j].x)*(listA[i].x-listB[j].x);
      float y2=(listA[i].y-listB[j].y)*(listA[i].y-listB[j].y);
      
      if(x2+y2 < mindist)
      {
        mindist=x2+y2;
        minA=i; minB=j;
      }
    }
  return new Pair<pointxy,pointxy>(listA[minA],listB[minB]);
}

//*
/// BAR3D 
//*
//*/////////////////////////////////////////

class settings_bar3d
{
int a=10;
int b=6;
int c=6;
int wire=color(255,255,255); //Kolor ramek
int back=color(0,0,0); //Informacja o kolorze tla
}//EndOfClass

settings_bar3d bar3dsett=new settings_bar3d();///< Default settings of bar3d

pointxy bar3dromb[]={new pointxy(),new pointxy(),new pointxy(),new pointxy(),new pointxy(),new pointxy()};

public void bar3dRGB(float x,float y,float h,int R,int G,int B,int Shad)
{
                                                    /*      6 ------ 5    */
  bar3dromb[0].x= x;                                /*     /        / |   */
  bar3dromb[0].y= y - h;                            /*    1 ------ 2  |   */
  bar3dromb[1].x= x + bar3dsett.a;                  /*    |        |  |   */
  bar3dromb[1].y= bar3dromb[1-1].y;                 /*    |        |  |   */
  bar3dromb[2].x= bar3dromb[2-1].x;                 /*    |        |  |   */
  bar3dromb[2].y= y;                                /*    |        |  4   */
  bar3dromb[3].x= x + bar3dsett.a + bar3dsett.b;    /*    |        | /  c */
  bar3dromb[3].y= y - bar3dsett.c;                  /*  x,y ------ 3      */
  bar3dromb[4].x= bar3dromb[4-1].x;                 /*         a      b   */
  bar3dromb[4].y= y - h - bar3dsett.c;
  bar3dromb[5].x= x + bar3dsett.b;
  bar3dromb[5].y= bar3dromb[5-1].y;

  fill(R,G,B);
  rect(x,y-h,bar3dsett.a,h+1);               //front

  fill(R/Shad,G/Shad,B/Shad);
  polygon(bar3dromb/*+1*/,6);              //bok i gora

  stroke(bar3dsett.wire);
  //rect(bar3dromb[1-1].x,bar3dromb[1-1].y,bar3dromb[2-1].x+1,bar3dromb[2-1].y+1);//gorny poziom
  //rect(x,y,bar3dromb[3-1].x+1,bar3dromb[3-1].y+1);       //dolny poziom

  line(bar3dromb[2-1].x,bar3dromb[2-1].y,bar3dromb[5-1].x,bar3dromb[5-1].y); //blik?

  //point(bar3dromb[5].x,bar3dromb[5].y,wire_col-1);
  line(bar3dromb[1-1].x,bar3dromb[1-1].y,bar3dromb[6-1].x,bar3dromb[6-1].y);//lewy ukos
  line(bar3dromb[2-1].x,bar3dromb[2-1].y,bar3dromb[3-1].x,bar3dromb[3-1].y);//prawy ukos
  line(bar3dromb[3-1].x,bar3dromb[3-1].y,bar3dromb[4-1].x,bar3dromb[4-1].y);//dolny ukos
  line(bar3dromb[4-1].x,bar3dromb[4-1].y,bar3dromb[5-1].x,bar3dromb[5-1].y);//tyl bok
  line(bar3dromb[5-1].x,bar3dromb[5-1].y,bar3dromb[6-1].x,bar3dromb[6-1].y);//tyl bok

 // rect(x,y-h,1,h+1,wire_col);       // the left vertical edge is additionally marked
}/* end of bar3dRGB */

 
//*
/// ARROW IN ANY DIRECTION
//*
//*////////////////////////////////////////

float def_arrow_size=15; ///< Default size of arrows heads
float def_arrow_theta=PI/6.0f+PI;///< Default arrowhead spacing //3.6651914291881

/// Function that draws an arrow with default settings
public void arrow(float x1,float y1,float x2,float y2)
{
  arrow_d(PApplet.parseInt(x1),PApplet.parseInt(y1),PApplet.parseInt(x2),PApplet.parseInt(y2),def_arrow_size,def_arrow_theta);
}

/// Function that draws an arrow with changable settings
public void arrow_d(int x1,int y1,int x2,int y2,float size,float theta)
{
  // CALCULATION METHOD FROM ROTATION OF THE ARROW AXIS
  float A=(size>=1 ? size : size * sqrt( (x1-x2)*(x1-x2)+(y1-y2)*(y1-y2) ));
  float poY=PApplet.parseFloat(y2-y1);
  float poX=PApplet.parseFloat(x2-x1);

  if(poY==0 && poX==0)
  {
    // Rare error, but big problem
    float cross_width=def_arrow_size/2;
    line(x1-cross_width,y1,x1+cross_width,y1);
    line(x1,y1-cross_width,x1,y1+cross_width);
    ellipse(x1+def_arrow_size/sqrt(2.0f),y1-def_arrow_size/sqrt(2.0f)+1,
            def_arrow_size,def_arrow_size);
    return;
  }
                                        assert(!(poY==0 && poX==0));
  float alfa=atan2(poY,poX);            if(abs(alfa)>PI+0.0000001f)
                                             println("Alfa=%e\n",alfa);
                                      //assert(fabs(alfa)<=M_PI);//cerr<<alfa<<endl;
  float xo1=A*cos(theta+alfa);
  float yo1=A*sin(theta+alfa);
  float xo2=A*cos(alfa-theta);
  float yo2=A*sin(alfa-theta);        //cross(x2,y2,128);DEBUG!

  line(PApplet.parseInt(x2+xo1),PApplet.parseInt(y2+yo1),x2,y2);
  line(PApplet.parseInt(x2+xo2),PApplet.parseInt(y2+yo2),x2,y2);
  line(x1,y1,x2,y2);
}

//*/////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - HANDY FUNCTIONS & CLASSES
//*/////////////////////////////////////////////////////////////////////////////////////////
/// Others factories for fabrication of links for a (social) network
//*///////////////////////////////////////////////////////////////////

/// Random link factory.
/// It creates links with random weights
class randomWeightLinkFactory extends LinkFactory
{
  float min_weight,max_weight;
  int   default_type;
  
  randomWeightLinkFactory(float min_we,float max_we,int def_type)
  { 
    min_weight=min_we;max_weight=max_we;
    default_type=def_type;
  }
  
  public Link  makeLink(Node Source,Node Target)
  {
    return new Link(Target,random(min_weight,max_weight),default_type);
  }
  
}//EndOfClass

///////////////////////////////////////////////////////////////////////////////////////////
//  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - SOCIAL NETWORK TEMPLATE
///////////////////////////////////////////////////////////////////////////////////////////
/// Generic visualisations of a (social) network
//*/////////////////////////////////////////////////////////
float XSPREAD=0.01f;   ///< how far is target point of link of type 1, from center of the cell
int   linkCounter=0;  ///< number od=f links visualised last time

//   FUNCTIONS:
//*/////////////
//void visualiseLinks(iVisNode[]   nodes,float defX,float defY,float cellside);
//void visualiseLinks(iVisNode[][] nodes,float defX,float defY,float cellside);

//   IMPLEMENTATIONS:
//*///////////////////

/// One dimensional visualisation using arcs()
public void visualiseLinks1D(iVisNode[] nodes,LinkFilter filter,float defX,float defY,float cellside,boolean intMode) 
{ 
  noFill();strokeCap(ROUND);
  linkCounter=0;
  ellipseMode(CENTER);
  
  if(intMode) //Wystarczy raz! 
      defX+=0.5f*cellside;
  
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
public void visualiseLinks2D(iVisNode[] nodes,LinkFilter filter,float defX,float defY,float cellside,boolean intMode) { ///
  noFill();strokeCap(ROUND);
  linkCounter=0;
  ellipseMode(CENTER);
  
  if(intMode) 
        defX+=0.5f*cellside;
  if(intMode) 
        defY+=0.5f*cellside;
  
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
public void visualiseLinks(iVisNode[][] nodes,LinkFilter filter,float defX,float defY,float cellside,boolean intMode) 
{ 
  noFill();
  linkCounter=0;
  
  if(intMode) defX+=0.5f*cellside;//WYSTARCZY DODAĆ RAZ!
  if(intMode) defY+=0.5f*cellside;//W tym miejscu.
  
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
  public void settings() {  size(500,500); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Optionals4Networks" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
