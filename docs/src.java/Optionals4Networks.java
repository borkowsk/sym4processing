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

/// @file Optionals4Networks.pde
/// @date 2023.03.04 (Last modification)
/// @brief Minimal program for testing linking of networks optionals.
//*/////////////////////////////////////////////////////////////////////////////

static int   DEBUG_LEVEL=0;       ///< General DEBUG level.
static int   NET_DEBUG_LEV=1;     ///< DEBUG level for network.
final int    LINK_INTENSITY=128;  ///< For network visualisation.
final float  MAX_LINK_WEIGHT=1.0f; ///< Also for network visualisation.
final int    MASKBITS=0xffffffff; ///< Redefine, when smaller width is required.

Visual2DNodeAsList[]  AllNodes;   ///< Nodes have to be visualisable!!!
AllLinks vfilter;
float defX=1;
float defY=1;

/// Mandatory Processing function.
public void setup()
{
  
  
  AllNodes=new Visual2DNodeAsList[10];
  for(int i=0;i<AllNodes.length;i++)
  {
    AllNodes[i]=new Visual2DNodeAsList(random(width),random(height));
  }
  
  randomWeightLinkFactory factory=new randomWeightLinkFactory(-1,1,1);
  makeFullNet(AllNodes,factory);
  
  int neighborhood=1;
  //makeRingNet(AllNodes,factory,neighborhood);
  
  int sizeOfFirstCluster=4;
  int numberOfNewLinkPerNode=1;
  boolean reciprocal=true; 
  //makeScaleFree(AllNodes,factory,sizeOfFirstCluster,numberOfNewLinkPerNode,reciprocal); //It works only sometime!
}

public void draw()
{
  float cellside=1;
  visualiseLinks2D(AllNodes,vfilter,defX,defY,cellside,true);
  //visualiseLinks1D(AllNodes,vfilter,defX,defY,cellside,true);
}


//*////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS 
//*  - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////
/// @file aInterfaces.pde 
/// Common INTERFACES like iNamed, iDescribable, iColorable, iPositioned & Function2D.
/// @date 2023.03.04 (Last modification)
//*///////////////////////////////////////////////////////////////////////////////////
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

//*/////////////////////////////////////////////////////////////////////////////////////////////
//*  See: "https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI" - USEFULL COMMON INTERFACES
//*  See also: "https://github.com/borkowsk/RTSI_public"
//*/////////////////////////////////////////////////////////////////////////////////////////////
/// @file 
/// @date 2023.03.04 (Last modification)
/// @brief Different filters of links and other link tools for a (social) network
//*/////////////////////////////////////////////////////////////////////////////
/// @details
///   Available filters: 
///   ------------------
///   AllLinks, AndFilter, OrFilter, TypeFilter,
///   LowPassFilter,   HighPassFilter,
///   AbsLowPassFilter, AbsHighPassFilter,
///   TypeAndAbsHighPassFilter (special type for efficient visualisation).

/// Simplest link filtering class which accepts all links.
class AllLinks extends LinkFilter
{
  public boolean meetsTheAssumptions(iLink l) { return true;}
}//EndOfClass

final AllLinks allLinks=new AllLinks();  ///< Such type of filter is used very frequently.

/// Special type of filter for efficient visualisation.
class TypeAndAbsHighPassFilter  extends LinkFilter
{
  int ltype;
  float treshold;
  TypeAndAbsHighPassFilter(){ ltype=-1;treshold=0;}
  TypeAndAbsHighPassFilter(int t,float tres) { ltype=t;treshold=tres;}
  public TypeAndAbsHighPassFilter reset(int t,float tres) { ltype=t;treshold=tres;return this;}
  public boolean meetsTheAssumptions(iLink l) { return l.getTypeMarker()==ltype && abs(l.getWeight())>treshold;}
}//EndOfClass

/// `AND` on two filters assembling class.
/// A class for logically joining two filters with the `AND` operator.
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

/// `OR` on two filters assembly class.
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
/// Class which filters links of specific "color"/"type".
class TypeFilter extends LinkFilter
{
  int ltype;
  TypeFilter(int t) { ltype=t;}
  public boolean meetsTheAssumptions(iLink l) { return l.getTypeMarker()==ltype;}
}//EndOfClass

/// Low Pass Filter.
/// Class which filters links with lower weights.
class LowPassFilter extends LinkFilter
{
  float treshold;
  LowPassFilter(float tres) { treshold=tres;}
  public boolean meetsTheAssumptions(Link l) { return l.weight<treshold;}
}//EndOfClass

/// High Pass Filter.
/// Class which filters links with higher weights.
class HighPassFilter extends LinkFilter
{
  float treshold;
  HighPassFilter(float tres) { treshold=tres;}
  public boolean meetsTheAssumptions(iLink l) { return l.getWeight()>treshold;}
}//EndOfClass

/// Absolute Low Pass Filter.
/// lowPassFilter filtering links with lower absolute value of weight.
class AbsLowPassFilter extends LinkFilter
{
  float treshold;
  AbsLowPassFilter(float tres) { treshold=abs(tres);}
  public boolean meetsTheAssumptions(iLink l) { return abs(l.getWeight())<treshold;}
}//EndOfClass

/// Absolute High Pass Filter.
/// highPassFilter filtering links with higher absolute value of weight.
class AbsHighPassFilter extends LinkFilter
{
  float treshold;
  AbsHighPassFilter(float tres) { treshold=abs(tres);}
  public boolean meetsTheAssumptions(iLink l) { return abs(l.getWeight())>treshold;}
}//EndOfClass

//*////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS 
//*  - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////
/// @file 
/// @date 2023.03.04 (Last modification)
/// @brief Network Only Interfaces.
//*/////////////////////////////////////////////////////////////////////////////

/// Network connection/link interface.
/// Is iLink interface really needed?
interface iLink { 
  /*_interfunc*/ public float getWeight()/*_forcbody*/;
  /*_interfunc*/ public int   getTypeMarker()/*_forcbody*/;
  /*_interfunc*/ public iNode getTarget()/*_forcbody*/;
  /*_interfunc*/ public void  setTarget(iNode tar)/*_forcbody*/;
}//EndOfClass

/// Interface for any filter for links.
interface iLinkFilter
{
  /*_interfunc*/ public boolean meetsTheAssumptions(iLink l)/*_forcbody*/;
}//EndOfClass

/// Network node interface.
/// "Conn" below is a shortage from Connection.
/// @note Somewhere may uses class Link not interface iLink because of efficiency!
interface iNode extends iNamed { 
  /*_interfunc*/ public int      addConn(iLink  l)/*_forcbody*/;
  /*_interfunc*/ public int      delConn(iLink  l)/*_forcbody*/;
  /*_interfunc*/ public int      numOfConn()      /*_forcbody*/;
  /*_interfunc*/ public iLink    getConn(int    i)/*_forcbody*/;
  /*_interfunc*/ public iLink    getConn(iNode  n)/*_forcbody*/;
  /*_interfunc*/ public iLink    getConn(String k)/*_forcbody*/;
  /*_interfunc*/ public iLink[]  getConns(iLinkFilter f)/*_forcbody*/;
}//EndOfClass

/// Visualisable network node.
interface iVisNode extends iNode,iNamed,iColorable,iPositioned {
}//EndOfClass

/// Visualisable network connection.
interface  iVisLink extends iLink,iNamed,iColorable {
  /*_interfunc*/ public int     defColor()/*_forcebody*/;
  /*_interfunc*/ public iVisNode  getVisTarget()/*_forcbody*/;
}//EndOfClass

/// Any factory producing links.
interface  iLinkFactory {
  /*_interfunc*/ public iLink  makeLink(iNode Source,iNode Target)/*_forcebody*/;
  /*_interfunc*/ public iLink  makeSelfLink(iNode Self)/*_forcebody*/;     
}//EndOfClass

//*////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS 
//*  - FUNCTIONS & CLASSES  - NETWORKS INTERFACES
//*  https://github.com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////
/// @file 
/// @date 2023.03.04 (Last modification)
/// @brief Generic (social) network classes.
//*/////////////////////////////////////////////////////////////////////////////
/// @details
///   Classes:
///   ========
///   - `class Link extends Colorable implements iLink`
///   - `class NodeList extends Node`
///   - `class NodeMap extends Node`
///
///   INTERFACES:
///   ===========
///   - `interface iLink`
///   - `interface iNode`
///
///   Abstractions:
///   =============
///   - `abstract class Node extends Positioned` 
///   - `abstract class LinkFilter`
///   - `abstract class LinkFactory`
///
///   - `abstract class Named implements iNamed`
///   - `abstract class Colorable extends Named implements iColorable`
///   - `abstract class Positioned extends Colorable implements iPositioned`
///
///   Network generators: 
///   ===================
///   - `void makeRingNet(Node[] nodes,LinkFactory links,int neighborhood)`
///   - `void makeTorusNet(Node[] nodes,LinkFactory links,int neighborhood)`
///   - `void makeTorusNet(Node[][] nodes,LinkFactory links,int neighborhood)`
/// 
///   - `void makeFullNet(Node[] nodes,LinkFactory links)`
///   - `void makeFullNet(Node[][] nodes,LinkFactory links)`
/// 
///   - `void makeRandomNet(Node[] nodes,LinkFactory links,float probability, boolean reciprocal)`
///   - `void makeRandomNet(Node[][] nodes,LinkFactory links,float probability, boolean reciprocal)`
///
///   - `void makeOrphansAdoption(Node[] nodes,LinkFactory links, boolean reciprocal)`
/// 
///   - `void makeSmWorldNet(Node[] nodes,LinkFactory links,int neighborhood,float probability, boolean reciprocal)`
///   - `void makeImSmWorldNet(Node[] nodes,LinkFactory links,int neighborhood,float probability, boolean reciprocal)`
///



/// int NET_DEBUG_LEV=1;  ///< DEBUG level for network. Should be defined autside this file!

//  ABSTRACT BASE CLASSES
//*/////////////////////////////////

/// Abstraction of link filtering class.
abstract class LinkFilter implements iLinkFilter {
  /*_interfunc*/ public boolean meetsTheAssumptions(iLink l)
                  {assert false : "Pure abstract meetsTheAssumptions(Link) called"; return false;}
}//EndOfClass

/// Abstraction of link factory class. Forcing `makeLink()` and `makeSalfLink()` methods.
abstract class LinkFactory implements iLinkFactory {
  /*_interfunc*/ public iLink  makeLink(iNode Source,iNode Target)
                  {assert false : "Pure abstract make(Node,Node) called"; return null;}
                 public iLink  makeSelfLink(iNode Self)
                  {assert false : "Pure abstract make(Node) called"; return null;}
}//EndOfClass

/// Abstraction of string-named class. Forcing `name()` method for visualisation and mapping. 
abstract class Named implements iNamed {       
  /*_interfunc*/ public String    name(){assert false : "Pure interface name() called"; return null;}
}//EndOfClass

/// Abstraction for any colorable object. Only for visualisation.
abstract class Colorable extends Named implements iColorable {
  /*_interfunc*/ public void setFill(float modifier)  {assert false : "Pure abstract setFill() called";}
  /*_interfunc*/ public void setStroke(float modifier){assert false : "Pure abstract setStroke() called";}
}//EndOfClass

/// Forcing posX() & posY() & posZ() methods for visualisation and mapping.  
abstract class Positioned extends Colorable implements iPositioned {
  /*_interfunc*/ public float    posX(){assert false : "Pure abstract posX() called"; return 0;}
  /*_interfunc*/ public float    posY(){assert false : "Pure abstract posY() called"; return 0;}
  /*_interfunc*/ public float    posZ(){assert false : "Pure abstract posZ() called"; return 0;}
}//EndOfClass

/// Abstraction class for any network node.
abstract class Node extends Positioned implements iNode {
  /*_interfunc*/ public int      addConn(iLink   l){assert false : "Pure abstract addConn(Link "+l+") called"; return   -1;}
  /*_interfunc*/ public int      delConn(iLink   l){assert false : "Pure abstract delConn(Link "+l+") called"; return   -1;}
  /*_interfunc*/ public int      numOfConn()       {assert false : "Pure abstract numOfConn() called"; return   -1;}
  /*_interfunc*/ public iLink    getConn(int    i) {assert false : "Pure abstract getConn(int "+i+")  called"; return null;}
  /*_interfunc*/ public iLink    getConn(iNode   n){assert false : "Pure abstract getConn(Node "+n+") called"; return null;}
  /*_interfunc*/ public iLink    getConn(String k) {assert false : "Pure abstract getConn(String '"+k+"') called"; return null;}
  /*_interfunc*/ public iLink[]  getConns(iLinkFilter f)
                  { assert false : "Pure abstract getConns(LinkFilter "+f+") called"; return null;}
}//EndOfClass

//   CLASS FOR MODIFICATION:
//*//////////////////////////

/// Real link implementation. This class is available for user modifications.
class Link extends Colorable implements iLink,iVisLink,Comparable<Link> {
  Node  target;  //!< targetet node.
  float weight;  //!< importance/trust
  int   ltype;   //!< "color"
  
  //... add something, if you need in derived classes.
  
  /// Constructor.
  Link(Node targ,float we,int ty){ target=targ;weight=we;ltype=ty;}
  
  /// Text formated data from the object.
  public String fullInfo(String fieldSeparator)
  {
    return "W:"+weight+fieldSeparator+"Tp:"+ltype+fieldSeparator+"->"+target;
  }
  
  /// For sorting. Much weighted link should be at the begining of the array!
  /// Compares this object with the specified object for order.
  public int  compareTo(Link o) 
  {
     if(o==this || o.weight==weight) return 0;
     else
     if(o.weight>weight) return 1;
     else return -1;
  }
  
  /// For visualisation and mapping.  
  public String name(){ return target.name(); }
  
  /// Read only access to `weight`.
  public float getWeight() { return weight;}
  
  /// Provide target node
  public iNode getTarget() { return target;}

  /// Provide target casted on visualisable node.
  public iVisNode  getVisTarget() { return (iVisNode)target;}
  
  public void  setTarget(iNode tar) { target=(Node)(tar); }
  
  /// 
  public int   getTypeMarker() { return ltype; }
  
  /// How object should be collored.
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
  
  /// Setting `stroke` for this object. 
  /// @param Intensity - used for alpha channel.
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
}//EndOfClass

/// Simplest link factory creates identical links except for the targets.
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
}//EndOfClass

//   IMPLEMENTATIONS:
//*////////////////////

/// Ring network.
public void makeRingNet(iNode[] nodes,iLinkFactory linkfac,int neighborhood)  ///< Global namespace.
{
  int n=nodes.length;
  for(int i=0;i<n;i++)
  {
    iNode Source=nodes[i];
    
    if(Source!=null)
    {
      if(DEBUG_LEVEL>2) println("i="+i,"Source="+Source,' ');
      
      for(int j=1;j<=neighborhood;j++)
      {
        int g=(n+i-j)%n;//left index
        int h=(i+j+n)%n;//right index
        
        if(nodes[g]!=null)
        {
          if(DEBUG_LEVEL>2) print("i="+i,"g="+g,' ');
          Source.addConn( linkfac.makeLink(Source,nodes[g]) );
        }
        
        if(nodes[h]!=null)
        {
          if(DEBUG_LEVEL>2) print("i="+i,"h="+h,' ');
          Source.addConn( linkfac.makeLink(Source,nodes[h]) );
        }    
        
        if(DEBUG_LEVEL>2) println();
      }
    }
  }
}

/// Torus lattice 1D - It is alias for Ring net only.
public void makeTorusNet(iNode[] nodes,iLinkFactory links,int neighborhood)      ///< Global namespace.
{  
   makeRingNet(nodes,links,neighborhood);
}

/// Torus lattice 2D.
public void makeTorusNet(iNode[][] nodes,iLinkFactory linkfac,int neighborhood)  ///< Global namespace.
{
  int s=nodes.length;   
  for(int i=0;i<s;i++)
  {
    int z=nodes[i].length;
    for(int k=0;k<z;k++)
    {
      iNode Source=nodes[i][k];
      
      if(Source!=null)
      {
        if(DEBUG_LEVEL>2) println("i="+i,"k="+k,"Source="+Source,' ');
        
        for(int j=-neighborhood;j<=neighborhood;j++)
        {
          int vert=(s+i+j)%s;//up index
          
          for(int m=-neighborhood;m<=neighborhood;m++)
          {
            int hor=(z+k+m)%z;//right index
            
            iNode Target;
            
            if((Target=nodes[vert][hor])!=null && Target!=Source)
            {
              if(DEBUG_LEVEL>2) print("Vert="+vert,"Hor="+hor,' ');
              Source.addConn( linkfac.makeLink(Source,Target) );
            }
  
            if(DEBUG_LEVEL>2) println();
          }
        }
      }
    }
  }
}

/// Rewire some connection for Small World 1D.
public void rewireLinksRandomly(iNode[] nodes,float probability, boolean reciprocal)  ///< Global namespace.
{ 
  for(int i=0;i<nodes.length;i++)
  {
    iNode Source=nodes[i];
    if(Source==null) 
                  continue;
                  
    if(random(1.0f)<probability)
    {
      int j=(int)random(nodes.length);
      iNode Target=nodes[j];
      
      if(Target==null || Source==Target 
         || Source.getConn(Target)!=null 
         )
         continue; //To losowanie nie ma sensu   
         
      //if(debug_level>2) print("i="+i,"g="+g,"j="+j);
       
      int index=(int)random(Source.numOfConn());  assert index<Source.numOfConn(); 
      iLink l=Source.getConn(index);
      
      if(reciprocal)
      {
        iLink r=l.getTarget().getConn(Source);
        if(r!=null) 
        {
          l.getTarget().delConn(r);//Usunięcie zwrotnego linku jesli był
          r.setTarget(Source);//Poprawienie linku
          Target.addConn(r);//Dodanie nowego zwrotnego linku w Targecie
        }  
      }
      
      l.setTarget(Target);//Replacing target!    
      //if(debug_level>2) println();
    }  
  }
}

/// Rewire some connection for Small World 2D.
public void rewireLinksRandomly(iNode[][] nodes,float probability, boolean reciprocal)  ///< Global namespace.
{ 
  for(int i=0;i<nodes.length;i++)
  for(int g=0;g<nodes[i].length;g++)
  {
    iNode Source=nodes[i][g];
    if(Source==null) 
                  continue;                  
    //Czy tu jakiś link zostanie przerobiony?
    if(random(1.0f)<probability)
    {
      //Nowy target - trzeba trafić           
      int j=(int)random(nodes.length);
      int h=(int)random(nodes[j].length);
      iNode Target=nodes[j][h];
      if(Target==null || Source==Target 
         || Source.getConn(Target)!=null 
         )
         continue; //To losowanie nie ma sensu       
      
      //if(debug_level>2) print("i="+i,"g="+g,"j="+j,"h="+h);
       
      int index=(int)random(Source.numOfConn());      assert index<Source.numOfConn();       
      iLink l=Source.getConn(index);
 
      if(reciprocal)
      {
        iLink r=l.getTarget().getConn(Source);
        if(r!=null) 
        {
          l.getTarget().delConn(r);//Usunięcie zwrotnego linku jesli był
          r.setTarget(Source);//Poprawienie linku
          Target.addConn(r);//Dodanie nowego zwrotnego linku w Targecie
        }  
      }
      
      l.setTarget(Target); //Replacing target!
      //if(debug_level>2) println();
    }  
  }
}

/// Classic Small World 1D.
public void makeSmWorldNet(iNode[] nodes,iLinkFactory links,int neighborhood,float probability, boolean reciprocal)  ///< Global namespace.
{ 
  makeTorusNet(nodes,links,neighborhood);
  rewireLinksRandomly(nodes,probability,  reciprocal);
}

/// Classic Small World 2D.
public void makeSmWorldNet(iNode[][] nodes,iLinkFactory links,int neighborhood,float probability, boolean reciprocal)  ///< Global namespace.
{ 
  makeTorusNet(nodes,links,neighborhood);
  rewireLinksRandomly(nodes,probability,  reciprocal);
}

/// Improved Small World 2D.
public void makeImSmWorldNet(iNode[][] nodes,iLinkFactory links,int neighborhood,float probability, boolean reciprocal)  ///< Global namespace.
{ 
  makeTorusNet(nodes,links,neighborhood);
  makeRandomNet(nodes,links,probability,  reciprocal);
}

/// Improved Small World 1D.
public void makeImSmWorldNet(iNode[] nodes,iLinkFactory links,int neighborhood,float probability, boolean reciprocal)  ///< Global namespace.
{ 
  makeTorusNet(nodes,links,neighborhood);
  makeRandomNet(nodes,links,probability,  reciprocal);
}

/// It tests if node `what` is in `cluster`.
/*_inline*/ public boolean inCluster(iNode[] cluster,iNode what)
{
  for(int j=0;j<cluster.length;j++)
   if(cluster[j]==what) //juz jest w cluster'ze
   {
     if(DEBUG_LEVEL>2) 
         println("node",what,"already on list!!!");
     return true;
   }
  return false;
}

/// Scale Free 1D.
public void makeScaleFree(iNode[] nodes,iLinkFactory linkfac,int sizeOfFirstCluster,int numberOfNewLinkPerNode, boolean reciprocal)  ///< Global namespace.
{
  if(DEBUG_LEVEL>1) println("MAKING SCALE FREE",sizeOfFirstCluster,numberOfNewLinkPerNode,reciprocal);
  iNode[] cluster=new iNode[sizeOfFirstCluster]; //if(debug_level>3) println("Initial:",(Node[])cluster);//Nodes for initial cluster
  
  for(int i=0;i<sizeOfFirstCluster;)
  {
    int  pos=(int)random(nodes.length);
    iNode pom=nodes[pos];
    if(inCluster(cluster,pom))
            continue;
    cluster[i]=pom;     
    i++;
  }
  
  makeFullNet(cluster,linkfac); //Linking of initial cluster
  
  float numberOfLinks=0;
  for(iNode nod:nodes )
    if(nod!=null)
      numberOfLinks+=nod.numOfConn();
      
  float EPS=1e-45f; //Najmniejszy możliwy float
  println("Initial number of links is",numberOfLinks,EPS);
  
  for(int i=0;i<numberOfNewLinkPerNode;i++)
    for(int j=0;j<nodes.length;)//Próbujemy każdego przyłączyć do czegoś
    {
        iNode source=nodes[j];
        if(source==null)
            continue;
            
        float where=EPS+random(1.0f);                      assert(where>0.0f); //"where" okresli do którego węzła się przyłączymy
        float start=0;                                    if(DEBUG_LEVEL>2) print(j,where,"->");
        for(int k=0;k<nodes.length;k++)
        {
          iNode target=nodes[k];
          if(target==null)
            continue;  
            
          float pwindow=target.numOfConn()/numberOfLinks; if(DEBUG_LEVEL>3) print(pwindow,"; ");
          if(start<where && where<=start+pwindow)         //Czy trafił w przedział?
          {
                                                          if(DEBUG_LEVEL>2) print(k,"!");
            if(source!=target)
            {
              int success=source.addConn( linkfac.makeLink(source,target) );
              if( success==1 ) //TYLKO GDY NOWY LINK!
              {
                numberOfLinks++;
                if(reciprocal)
                  if(target.addConn( linkfac.makeLink(target,source) )==1)//OK TYLKO GDY NOWY LINK
                      numberOfLinks++;
                j++; //Można przejść do podłączania nastepnego agenta
              }
            }
            
            break; //Znaleziono potencjalny target. Jeśli nie nastąpiło podłączenie to i tak trzeba losować od nowa
          }
          else
          {
            start+=pwindow; //To jeszcze nie ten
          }
        }                                                  if(DEBUG_LEVEL>2) println();
    }
    if(DEBUG_LEVEL>1) println("DONE! SCALE FREE HAS MADE");
}

/// Full connected network 1D.
public void makeFullNet(iNode[] nodes,iLinkFactory linkfac)         ///< Global namespace.
{
  int n=nodes.length;
  for(int i=0;i<n;i++)
  {
    iNode Source=nodes[i];
    if(Source!=null)
      for(int j=0;j<n;j++)
        if(i!=j && nodes[j]!=null )
        {
          if(DEBUG_LEVEL>4) print("i="+i,"j="+j);
          
          Source.addConn( linkfac.makeLink(Source,nodes[j]) );
          
          if(DEBUG_LEVEL>4) println();
        }
  }
}

/// Full connected network 2D.
public void makeFullNet(iNode[][] nodes,iLinkFactory linkfac)      ///< Global namespace.
{
  for(int i=0;i<nodes.length;i++)
  for(int g=0;g<nodes[i].length;g++)
  {
    iNode Source=nodes[i][g];
    
    if(Source!=null)
      for(int j=0;j<nodes.length;j++)
      for(int h=0;h<nodes[j].length;h++)
      {
        iNode Target=nodes[j][h];
        
        if(Target!=null && Source!=Target)
        {
          if(DEBUG_LEVEL>4) print("i="+i,"g="+g,"j="+j,"h="+h);
          
          Source.addConn( linkfac.makeLink(Source,Target) );
          
          if(DEBUG_LEVEL>4) println();
        }
      }
  }
}

/// Randomly connected network 1D.
public void makeRandomNet(iNode[] nodes,iLinkFactory linkfac,float probability, boolean reciprocal)  ///< Global namespace.
{  
  //NO ERROR!: rings in visualisation are because agents may have sometimes exactly same position!!!
  int n=nodes.length;
  for(int i=0;i<n;i++)
  {
    iNode Source=nodes[i];
    if(Source==null)
        continue;
        
    if(reciprocal)
    {
      for(int j=i+1;j<n;j++)
      {
        iNode Target=nodes[j];
        if(Target!=null && Source!=Target && random(1.0f)<probability)
        {
          if(DEBUG_LEVEL>2) print("i="+i,"j="+j);
                                                                
          int success=Source.addConn( linkfac.makeLink( Source, Target ) );
          if(success==1)
            Target.addConn( linkfac.makeLink( Target, Source ) );
          
          if(DEBUG_LEVEL>2) println();
        }
      }   
    }
    else
    {
      for(int j=0;j<n;j++)
      {
        iNode Target=nodes[j];
        if(Target!=null && Source!=Target && random(1.0f)<probability)
        {
          if(DEBUG_LEVEL>2) print("i="+i,"j="+j);
                                                                
          //int success=
          Source.addConn( linkfac.makeLink( Source, Target ) );
          
          if(DEBUG_LEVEL>2) println();
        }
      }       
    }
  }
}

/// Connect all orphaned nodes with at least one link.
public void makeOrphansAdoption(iNode[] nodes,iLinkFactory linkfac, boolean reciprocal)    ///< Global namespace.
{
  int n=nodes.length;
  for(int i=0;i<n;i++)
  {
    iNode Source=nodes[i];
    if(Source==null || Source.numOfConn() > 0)
        continue;
        
    //Only if exists and is orphaned
                                                                      if(DEBUG_LEVEL>0) print("Orphan",nf(i,3),":");
    iNode Target=null;
    int Ntry=n;
    while(Target==null) //Searching for foster parent
    {
      int t=(int)random(n);
      if( t==i                //candidate is not self
      ||  nodes[t]==null      //is not empty 
      ||  (nodes[t].numOfConn()==0 //is not other orphan
           && Ntry-- > 0  )   //but not when all are orphans!
      ) continue;
                                                                       
      Target=nodes[t]; //Candidate ok
                                                                      if(DEBUG_LEVEL>0) print("(",Ntry,")",nf(t,3),"is a chosen one ", Target.name() ); 
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
    
                                                                      if(DEBUG_LEVEL>0)
                                                                        if(success==1)  println(" --> Not any more orphaned!");
                                                                        else  println("???",success);
  }
}

/// Randomly connected network 2D.
public void makeRandomNet(iNode[][] nodes,iLinkFactory linkfac,float probability, boolean reciprocal)  ///< Global namespace.
{
  for(int i=0;i<nodes.length;i++)
  for(int g=0;g<nodes[i].length;g++)
  {
    iNode Source=nodes[i][g];
    
    if(Source==null)
      continue;
    
    if(reciprocal)
    {  
      for(int j=i+1;j<nodes.length;j++)
      for(int h=g+1;h<nodes[j].length;h++)
      {
        iNode Target=nodes[j][h];
        
        if(Target!=null && Source!=Target && random(1)<probability)
        {
          if(DEBUG_LEVEL>2) print("i="+i,"g="+g,"j="+j,"h="+h);
                                                               
          int success=Source.addConn( linkfac.makeLink(Source,Target) );
          if(success==1)
            Target.addConn( linkfac.makeLink(Target,Source) );
            
          if(DEBUG_LEVEL>2) println();
        }
      }
    }
    else
    {
      for(int j=0;j<nodes.length;j++)
      for(int h=0;h<nodes[j].length;h++)
      {
        iNode Target=nodes[j][h];
        
        if(Target!=null && Source!=Target && random(1)<probability)
        {
          if(DEBUG_LEVEL>2) print("i="+i,"g="+g,"j="+j,"h="+h);
                                                               
          //int success=
          Source.addConn( linkfac.makeLink(Source,Target) );
            
          if(DEBUG_LEVEL>2) println();
        }
      }
    }
  }
}

/// Node implementation based on ArrayList.
/// See: //https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html
class NodeAsList extends Node  implements iVisNode {
  ArrayList<Link> connections; 
  
  NodeAsList()
  {
    connections=new ArrayList<Link>();
  }
  
  public int     numOfConn()  //!< By interface required.    
  { return connections.size(); }
  
  public int     addConn(iLink   l)
  {
     return addConn((Link)l);
  }
  
  public int     addConn(Link   l) //!< By interface required.
  {
                                          assert l!=null : "Empty link in "+this.getClass().getName()+".addConn(Link)?";
    if(NET_DEBUG_LEV>2 && l.getTarget()==this)   //It may not be expected!
            print("Self connecting of",l.getTarget().name());
            
    boolean res=false;
    
    if(getConn(l.getTarget())==null)
    {
        res=connections.add(l);
        if(NET_DEBUG_LEV>0) print('|');
    }
    else if(NET_DEBUG_LEV>1) println("Link",this.name(),
                                   "->",l.target.name(), // new line for C++ sed-translator
                                   "already exist"); // '.' should not be between '"' 

    if(res) return   1;
    else    return   0;
  }
  
  public int     delConn(iLink   l) //!< By interface required.
  {
    if(connections.remove(l))
      return 1;
    else
      return 0;
  }
  
  public Link    getConn(int    i) //!< By interface required.
  {
    assert i<connections.size(): "Index '"+i+"' out of bound '"+connections.size()+"' in "+this.getClass().getName()+".getConn(int)"; 
    return connections.get(i);
  }
  
  public Link    getConn(iNode   n) //!< By interface required.
  {
                                           assert n!=null : "Empty node in "+this.getClass().getName()+".getConn(Node)";
    for(Link l:connections)
    {
      if(l.target==n) 
            return l;
    }
    return null;
  }
  
  public Link    getConn(String k) //!< By interface required.
  {
                              assert k==null || k=="" : "Empty string in "+this.getClass().getName()+".getConn(String)";
    for(Link l:connections)
    {
      if(l.target.name()==k) 
            return l;
    }
    return null;
  }
  
  public Link[]  getConns(iLinkFilter f) //!< By interface required.
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

/// Node implementation based on hash map.
/// See: //https://docs.oracle.com/javase/6/docs/api/java/util/HashMap.html
class NodeAsMap extends Node implements iVisNode {  
  //HashMap<Integer,Link> connections; //TODO using Object.hashCode(). Could be a bit faster than String
  HashMap<String,Link> connections; 
  
  NodeAsMap()
  {
    connections=new HashMap<String,Link>(); 
  }
  
  public int     numOfConn()      { return connections.size();}
  
  public int     addConn(iLink   l)
  {
     return addConn((Link)l);
  }
  
  public int     addConn(Link   l)
  {
    assert l!=null : "Empty link in "+this.getClass().getName()+".addConn(Link)?"; 
    if(DEBUG_LEVEL>2 && l.target==this) //It may not be expected!
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

//*////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS 
//*  - FUNCTIONS & CLASSES  - NETWORKS TOOLBOX
//*  https://github.com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////
/// @file uFigures.pde
/// Various shapes drawing procedures.
/// @date 2023.03.04 (Last modification)
//*//////////////////////////////////////////////////////////////

/// Horizontal view of a bald head of a man seen from above.
public void baldhead_hor(float x,float y,float r,float direction)         ///< Global namespace.
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
  
  for(int i=0;i<=10;i++)
  {
      float angle=PI/2+PI/10*i;
      xn=x+0.75f*r*cos(angle+direction);
      yn=y+0.75f*r*sin(angle+direction);
      float xm=x+0.35f*r*cos(angle+direction);
      float ym=y+0.35f*r*sin(angle+direction);
      line(xm,ym,xn,yn);
  }
  
  //OCZY
  fill(200);
  xn=x+0.75f*r*cos(direction+PI/5);
  yn=y+0.75f*r*sin(direction+PI/5);
  arc(xn,yn,D/5,D/5,-PI/2+direction,PI/2+direction,CHORD);  //Oko  1
  
  fill(0);
  xn=x+0.84f*r*cos(direction+PI/6);
  yn=y+0.84f*r*sin(direction+PI/6);  
  ellipse(xn,yn,D/12,D/12);
  
  fill(200);
  xn=x+0.75f*r*cos(direction-PI/5);
  yn=y+0.75f*r*sin(direction-PI/5);
  arc(xn,yn,D/5,D/5,-PI/2+direction,PI/2+direction,CHORD);  //Oko  2
  
  fill(0);
  xn=x+0.84f*r*cos(direction-PI/6);
  yn=y+0.84f*r*sin(direction-PI/6);
  ellipse(xn,yn,D/12,D/12);
}

/// Vertical view on agava plant.
public void agava_ver(float x,float y,float visual_size,float num_of_leafs)    ///< Global namespace.
{
  float lstep=PI/(num_of_leafs);
  
  for(float angle=PI+lstep/2;angle<2*PI;angle+=lstep)
  {
    float x2=x+cos(angle)*visual_size/2;
    float y2=y+sin(angle)*visual_size/2;
    triangle(x-visual_size/8,y,x+visual_size/8,y,x2,y2);
    line(x,y,x2,y2);
  }
  
  arc(x,y,visual_size/4,visual_size/4,PI,2*PI,PIE);
}

/// Horizontal view on agava plant.
public void agava_hor(float x,float y,float visual_size,float num_of_leafs)      ///< Global namespace.
{
  float lstep=(2*PI)/min(num_of_leafs,3)+PI/5;
  float maxan=lstep*num_of_leafs;
  
  for(float angle=lstep/2;angle<=maxan;angle+=lstep)
  {
    visual_size*=0.966f;
    float x0=x+cos(angle+PI/2)*visual_size/8;
    float y0=y+sin(angle+PI/2)*visual_size/8;
    float x1=x+cos(angle-PI/2)*visual_size/8;
    float y1=y+sin(angle-PI/2)*visual_size/8;    
    float x2=x+cos(angle)*visual_size/2;
    float y2=y+sin(angle)*visual_size/2;
    triangle(x0,y0,x1,y1,x2,y2);
    line(x,y,x2,y2);
  }
  
  ellipse(x,y,visual_size/4,visual_size/4);//,PI,2*PI,PIE);
  ellipse(x,y,1,1);
}


/// Vertical view of simple droid.
public void gas_bottle_droid_ver(float x,float y,float visual_size,float direction)       ///< Global namespace.
{
  rect(x-visual_size/4, y-visual_size,     visual_size/2,   visual_size-3*visual_size/5,   visual_size/10); //Głowa
  rect(x-visual_size/3, y-3*visual_size/5, 2*visual_size/3, 3*visual_size/5-visual_size/10,visual_size/10); //Tułów
  rect(x-visual_size/4, y-visual_size/10,  visual_size/2,   visual_size/10);  //Stopy
  
  if(-.25f*PI<=direction && direction<=PI*1.25f) //Przód
  {
    float rotx=x+cos(direction)*visual_size/4.f;
    float rots=visual_size/8.f*sin(direction);

    fill(200);
    arc(rotx,y-visual_size+visual_size/5.f,rots,visual_size/10.f,1.f/2.f*PI,6.f/4.f*PI,PIE); //nos lewo
    arc(rotx,y-visual_size+visual_size/5.f,rots,visual_size/10.f,6.f/4.f*PI,  2.5f*PI,PIE); //nos prawo
        
    float lefte=(direction - PI/4 >0  ? x+cos(direction-PI/4)*visual_size/4 : x + visual_size/4);
    float rigte=(direction + PI/4 <PI ? x+cos(direction+PI/4)*visual_size/4 : x-visual_size/4);
    
    stroke(64,0,0);
    line(lefte,y-visual_size+visual_size/5+visual_size/10,rigte,y-visual_size+visual_size/5+visual_size/10); //usta
    stroke(0,0,64);
    line(lefte,y-visual_size+visual_size/16,lefte,y-visual_size+visual_size/8); //jego lewe oko
    line(rigte,y-visual_size+visual_size/16,rigte,y-visual_size+visual_size/8); //jego prawe oko
    
    float lefth=(direction - PI/4 >0  ? x+cos(direction-PI/4)*visual_size/3 : x + visual_size/3);
    float lefts=(direction - PI/5 >0  ? x+cos(direction-PI/5)*visual_size/3 : x + visual_size/3);
    float rigth=(direction + PI/4 <PI ? x+cos(direction+PI/4)*visual_size/3 : x - visual_size/3);
    float rigts=(direction + PI/5 <PI ? x+cos(direction+PI/5)*visual_size/3 : x - visual_size/3);
    
    stroke(0);
    triangle(lefts,y-3*visual_size/5+visual_size/8,lefth,y-3*visual_size/5+visual_size/8,lefth,y-3*visual_size/5+visual_size/3); //jego lewa ręka
    triangle(rigts,y-3*visual_size/5+visual_size/8,rigth,y-3*visual_size/5+visual_size/8,rigth,y-3*visual_size/5+visual_size/3); //jego prawa ręka
  }
  
  if(PI<=direction && direction<=2*PI)
  {
    float leftb=x+cos(direction+PI-PI/10)*visual_size/3; //(direction+PI - PI/4 >0  ? x+cos(direction+PI-PI/4)*visual_size/3 : x + visual_size/3);
    float rigtb=x+cos(direction+PI+PI/10)*visual_size/3; 
    
    fill(64);
    quad(leftb, y-3*visual_size/5+visual_size/8, 
         rigtb, y-3*visual_size/5+visual_size/8,
         rigtb, y-3*visual_size/5+visual_size/4, 
         leftb, y-3*visual_size/5+visual_size/4); 
       
    fill(110);
    leftb=x+cos(direction+PI-PI/10)*visual_size/4;     
    rigtb=x+cos(direction+PI+PI/10)*visual_size/4;
    quad(leftb, y-visual_size+visual_size/8, 
         rigtb, y-visual_size+visual_size/8,
         rigtb, y-visual_size+visual_size/5, 
         leftb, y-visual_size+visual_size/5); 
  }
  
  if(0<=direction && direction<=PI)
  {
    float rotx=x+cos(direction)*visual_size/4.f;
    float rots=visual_size/8.f*sin(direction);
    fill(0);
    triangle(rotx-rots/2,y-visual_size/10,rotx+rots/2,y-visual_size/10,rotx,y-1);  // granica stóp
  }
  else //Tył
  {
    float rotx0=x+cos(direction+PI)*visual_size/4;
    float rots=visual_size/8.f*sin(direction+PI);
    fill(128);
    triangle(rotx0-rots/2,y,rotx0+rots/2,y,rotx0,y-visual_size/10+1);  // granica stóp
  }
  
}

//*
/// ARROW IN ANY DIRECTION
//*
//*////////////////////////////////////////

float def_arrow_size=15;         ///< Default size of arrows heads
float def_arrow_theta=PI/6.0f+PI; ///< Default arrowhead spacing //3.6651914291881

/// Function that draws an arrow with default settings.
public void arrow(float x1,float y1,float x2,float y2)                           ///< Global namespace.
{
  arrow_d(PApplet.parseInt(x1),PApplet.parseInt(y1),PApplet.parseInt(x2),PApplet.parseInt(y2),def_arrow_size,def_arrow_theta);
}

/// Function that draws an arrow with changable settings.
public void arrow_d(int x1,int y1,int x2,int y2,float size,float theta)          ///< Global namespace.
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
  float alfa=atan2(poY,poX);                if(abs(alfa)>PI+0.0000001f)
                                                 println("Alfa=%e\n",alfa);
                                          //assert(fabs(alfa)<=M_PI);//cerr<<alfa<<endl;
  float xo1=A*cos(theta+alfa);
  float yo1=A*sin(theta+alfa);
  float xo2=A*cos(alfa-theta);
  float yo2=A*sin(alfa-theta);            //cross(x2,y2,128);DEBUG!

  line(PApplet.parseInt(x2+xo1),PApplet.parseInt(y2+yo1),x2,y2);
  line(PApplet.parseInt(x2+xo2),PApplet.parseInt(y2+yo2),x2,y2);
  line(x1,y1,x2,y2);
}


//*////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS 
//*  - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////
/// @file uGraphix.pde
/// Various helpful drawing procedures, like crosses, polygons & bar3D
/// @date 2023.03.04 (Last modification)
//*/////////////////////////////////////////////////////////////////////

/// A class to represent two-dimensional points.
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

/// Frame drawn with a default line.
public void surround(int x1,int y1,int x2,int y2)                     ///< Global namespace.
{
  line(x1,y1,x2,y1); //--->
  line(x2,y1,x2,y2); //vvv
  line(x1,y2,x2,y2); //<---
  line(x1,y1,x1,y2); //^^^
}

/// Cross drawn with a default line.
public void cross(float x,float y,float cross_width)                  ///< Global namespace.
{
  line(x-cross_width,y,x+cross_width,y);
  line(x,y-cross_width,x,y+cross_width);
}

/// Cross drawn with a default line.
/// The version that uses parameters of type int.
public void cross(int x,int y,int cross_width)                        ///< Global namespace.
{
  line(x-cross_width,y,x+cross_width,y);
  line(x,y-cross_width,x,y+cross_width);
}

//*
/// POLYGONS
//*
//*/////////////////////

/// A regular polygon with a given radius and number of vertices.
public void regularpoly(float x, float y, float radius, int npoints)  ///< Global namespace.
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

/// Drawing a polygon. 
/// This function utilises vertices given as an array of points
public void polygon(pointxy[] lst/*+1*/)                               ///< Global namespace.
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
public void polygon(pointxy[] lst/*+1*/,int N)                        ///< Global namespace.
{
  beginShape();
  for (int a = 0; a < N; a ++) 
  {
    vertex(lst[a].x,lst[a].y);
  }
  endShape(CLOSE);
}



//*
//* Visualisation of BAR3D.
//*
//*/////////////////////////////////////////

/// Configuration set of BAR3D visualisation.
class settings_bar3d
{
int a=10;
int b=6;
int c=6;
int wire=color(255,255,255); //Kolor ramek
int back=color(0,0,0); //Informacja o kolorze tla
}//EndOfClass

/// Default configuration set of BAR3D visualisation.
settings_bar3d bar3dsett=new settings_bar3d();                       ///< Default settings of bar3d

/// Rhomb polygon used for draving bar3D
pointxy bar3dromb[]={new pointxy(),new pointxy(),new pointxy(),new pointxy(),new pointxy(),new pointxy()};  ///< Global namespace.

/// Function which draving bar3d using current configuration.
public void bar3dRGB(float x,float y,float h,int R,int G,int B,int Shad)    ///< Global namespace.
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

 

//*////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS 
//*  - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////
/// @file 
/// @date 2023.03.04 (Last modification)
/// @brief Others factories for fabrication of links for a (social) network
//*/////////////////////////////////////////////////////////////////////////////

/// Random link factory.
/// It creates links with random weights.
class randomWeightLinkFactory implements iLinkFactory
{
  float min_weight,max_weight;
  int   default_type;
  
  /// Constructor for setting up requirements.
  randomWeightLinkFactory(float min_we,float max_we,int def_type)
  { 
    min_weight=min_we;max_weight=max_we;
    default_type=def_type;
  }
  
  /// Real factory job.
  public Link  makeLink(iNode Source,iNode Target)
  {
    return new Link((Node)Target,random(min_weight,max_weight),default_type);
  }
  
  public Link  makeSelfLink(iNode Self)
  {
    return new Link((Node)Self,random(min_weight,max_weight),default_type);
  }
  
}//EndOfClass

//*////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS 
//*  - FUNCTIONS & CLASSES  - NETWORKS TOOLBOX
//*  https://github.com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////
/// @file 
/// @date 2023.03.04 (Last modification)
/// @brief Generic visualisations of a (social) network
//*/////////////////////////////////////////////////////////////////////////////
///
/// @details
///   CLASSES:
///   ========
///   - `class Visual2DNodeAsList extends NodeAsList implements iVisNode` 
///      -> Visualisable node based on `NodeAsList` core.
///   - `class Visual2DNodeAsMap extends NodeAsMap implements iVisNode` 
///      -> Visualisable node based on `NodeAsMap` core.
///
///   FUNCTIONS:
///   ==========
///   - `void visualiseLinks(iVisNode[]   nodes,float defX,float defY,float cellside)`
///   - `void visualiseLinks(iVisNode[][] nodes,float defX,float defY,float cellside)`
///

float XSPREAD=0.01f;   ///< how far is target point of link of type 1, from center of the cell
int   linkCounter=0;  ///< number od=f links visualised last time

/// Visualisable node based on `NodeAsList` core.
/// It implements all things needed for visualisation.
class Visual2DNodeAsList extends NodeAsList implements iVisNode
{
  float X=0;
  float Y=0;
  int fillc=0x0;
  int strok=0x0;
  
  Visual2DNodeAsList(float x, float y) { super();
    X=x; Y=y;  
  }
 
  public void setFill(float intensity) { fill(fillc,intensity); }
  public void setStroke(float intensity) { stroke(strok,intensity); }
  public float  posX() { return X;}
  public float  posY() { return Y;}
  public String name() { return ("("+X+","+Y+")"+this);}
}//EndOfClass

/// Visualisable node based on `NodeAsMap` core.
/// It implements all things needed for visualisation.
class Visual2DNodeAsMap extends NodeAsMap implements iVisNode
{
  float X=0;
  float Y=0;
  int fillc=0x0;
  int strok=0x0;
  
  Visual2DNodeAsMap(float x, float y) { super();
    X=x; Y=y;  
  }
 
  public void setFill(float intensity) { fill(fillc,intensity); }
  public void setStroke(float intensity) { stroke(strok,intensity); }
  public float  posX() { return X;}
  public float  posY() { return Y;}
  public String name() { return ("("+X+","+Y+")"+this);}
}//EndOfClass


//   IMPLEMENTATIONS:
//*///////////////////

/// One dimensional visualisation using arcs().
public void visualiseLinks1D(iVisNode[] nodes,LinkFilter filter,float defX,float defY,float cellside,boolean intMode)  ///< Global namespace.
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
      iVisLink[] links=(iVisLink[])Source.getConns(filter);    assert links!=null;
      
      int m=links.length;
      for(int j=0;j<m;j++)
      {
        float Xt=links[j].getVisTarget().posX();
        //print(X,Xt,"; "); 
        float R=abs(Xt-X)*cellside;
        float C=(X+Xt)/2;
        
        if(X<Xt) { Xt+=links[j].getTypeMarker()*XSPREAD;}
        else     { Xt-=links[j].getTypeMarker()*XSPREAD;}
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

/// Two dimensional visualisation using arrows().
public void visualiseLinks2D(iVisNode[] nodes,LinkFilter filter,float defX,float defY,float cellside,boolean intMode)  ///< Global namespace.
{
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
      float Y=Source.posY();                                       //circle(X,Y,1);
      iLink[] links=Source.getConns(filter);                       assert links!=null;
      
      int l=links.length;
      for(int k=0;k<l;k++)
      {
        iVisLink k_link=(iVisLink)links[k];
        iVisNode k_node=(iVisNode)k_link.getTarget();
        float Xt=k_node.posX();                                   //strokeWeight(1);stroke(10);
        float Yt=k_node.posY();                                   //circle(Xt,Yt,k+1*2);
                                                  if(DEBUG_LEVEL>4 && Source==links[k].getTarget())//Będzie kółko!
                                                        println(Source.name(),"-o-",links[k].getTarget().name());
                                                        
        if(X<Xt) { Xt+=links[k].getTypeMarker()*XSPREAD;}
        else    { Xt-=links[k].getTypeMarker()*XSPREAD;}
                                                  if(DEBUG_LEVEL>1 && X==Xt && Y==Yt)//TEŻ będzie kółko!!!
                                                        println("Connection",Source.name(),"->-",links[k].getTarget().name(),"visualised as circle");
        k_link.setStroke(LINK_INTENSITY);
        
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

/// Alternative 2D links visualisation.
public void visualiseLinks(iVisNode[][] nodes,LinkFilter filter,float defX,float defY,float cellside,boolean intMode) ///< Global namespace.
{ 
  noFill();
  linkCounter=0;
  
  if(intMode) defX+=0.5f*cellside; //WYSTARCZY DODAĆ RAZ!
  if(intMode) defY+=0.5f*cellside; //W tym miejscu.
  
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

        if(X<Xt) { Xt+=links[k].getTypeMarker()*XSPREAD;}
        else    { Xt-=links[k].getTypeMarker()*XSPREAD;}
        
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

//*////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS 
//*  - FUNCTIONS & CLASSES  - NETWORKS TOOLBOX
//*  https://github.com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////
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
