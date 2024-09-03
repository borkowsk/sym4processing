/// @file 
/// @brief Generic (social) network classes ("aNetwork.pde")
/// @date 2024-09-03 (last modification)
//*/////////////////////////////////////////////////////////////////////////////

/// @details
///
///   Classes:
///   ========
///   - `class Link extends Colorable implements iLink`
///   - `class NodeList extends Node`
///   - `class NodeMap extends Node`
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

import java.util.Map;

/// int NET_DEBUG_LEV=1;  ///< DEBUG level for network. Should be defined autside this file!

///  ABSTRACT BASE CLASSES:
//*////////////////////////

/**
* @brief Abstraction of link filtering class.
*/
abstract class LinkFilter implements iLinkFilter {
  /*_interfunc*/ boolean meetsTheAssumptions(iLink l)
                  {assert false : "Pure abstract meetsTheAssumptions(Link) called"; return false;}
} //_EndOfClass LinkFilter

/**
* @brief Abstraction of link factory class. Forcing `makeLink()` and `makeSalfLink()` methods.
*/
abstract class LinkFactory implements iLinkFactory {
  /*_interfunc*/ iLink  makeLink(iNode Source,iNode Target)
                  {assert false : "Pure abstract make(Node,Node) called"; return null;}
                 iLink  makeSelfLink(iNode Self)
                  {assert false : "Pure abstract make(Node) called"; return null;} //<>//
} //EndOfClass LinkFactory

/**
* @brief Abstraction of string-named class. Forcing `name()` method for visualisation and mapping.
*/
abstract class Named implements iNamed {       
  /*_interfunc*/ String    name(){assert false : "Pure interface name() called"; return null;}
} //EndOfClass Named

/**
* @brief Abstraction for any colorable object. Only for visualisation.
*/
abstract class Colorable extends Named implements iColorable {
  /*_interfunc*/ void   applyFill(float modifier) {assert false : "Pure abstract   `applyFill()` called";}
  /*_interfunc*/ void applyStroke(float modifier) {assert false : "Pure abstract `applyStroke()` called";}
} //EndOfClass Colorable

/**
* @brief Forcing `posX()` & `posY()` & `posZ()` methods for visualisation and mapping.
*/
abstract class Positioned extends Colorable implements iPositioned {
  /*_interfunc*/ float    posX(){assert false : "Pure abstract posX() called"; return 0;}
  /*_interfunc*/ float    posY(){assert false : "Pure abstract posY() called"; return 0;}
  /*_interfunc*/ float    posZ(){assert false : "Pure abstract posZ() called"; return 0;}
} //EndOfClass Positioned

/**
* @brief Abstraction class for any network node.
*/
abstract class Node extends Positioned implements iNode {
  /*_interfunc*/ int      addConn(iLink   l){assert false : "Pure abstract addConn(Link "+l+") called"; return   -1;}
  /*_interfunc*/ int      delConn(iLink   l){assert false : "Pure abstract delConn(Link "+l+") called"; return   -1;}
  /*_interfunc*/ int      numOfConn()       {assert false : "Pure abstract numOfConn() called"; return   -1;}
  /*_interfunc*/ iLink    getConn(int    i) {assert false : "Pure abstract getConn(int "+i+")  called"; return null;}
  /*_interfunc*/ iLink    getConn(iNode   n){assert false : "Pure abstract getConn(Node "+n+") called"; return null;}
  /*_interfunc*/ iLink    getConn(String k) {assert false : "Pure abstract getConn(String '"+k+"') called"; return null;}
  /*_interfunc*/ iLink[]  getConns(iLinkFilter f)
                  { assert false : "Pure abstract getConns(LinkFilter "+f+") called"; return null;}
} //EndOfClass Node

///  CLASS FOR MODIFICATION:
//*/////////////////////////

/**
* @brief Real link implementation. This class is available for user modifications.
*/
class Link extends Colorable implements iLink,iVisLink,Comparable<Link> {
  Node  target;  //!< targetet node.
  float weight;  //!< importance/trust
  int   ltype;   //!< "color"
  
  //... add something, if you need in derived classes.
  
  /// Constructor.
  Link(Node targ,float we,int ty){ target=targ;weight=we;ltype=ty;}
  
  /// Text formated data from the object.
  String fullInfo(String fieldSeparator)
  {
    return "W:"+weight+fieldSeparator+"Tp:"+ltype+fieldSeparator+"->"+target;
  }
  
  /// For sorting. Much weighted link should be at the begining of the array!
  /// Compares this object with the specified object for order.
  int  compareTo(Link o) 
  {
     if(o==this || o.weight==weight) return 0;
     else
     if(o.weight>weight) return 1;
     else return -1;
  }
  
  /// For visualisation and mapping.  
  String    name(){ return target.name(); }
  String getName(){ return target.name(); }
  
  /// Read only access to `weight`.
  float getWeight() { return weight;}
  
  /// Provide target node
  iNode getTarget() { return target;}

  /// Provide target casted on visualisable node.
  iVisNode  getVisTarget() { return (iVisNode)target;}
  
  void  setTarget(iNode tar) { target=(Node)(tar); }
  
  /// 
  int   getTypeMarker() { return ltype; }
  
  /// How object should be collored.
  color     defColor()
  {
     switch ( ltype )
     {
     case 0: if(weight<=0) return color(0,-weight*255,0);else return color(weight*255,0,weight*255);
     case 1: if(weight<=0) return color(-weight*255,0,0);else return color(0,weight*255,weight*255);
     case 2: if(weight<=0) return color(0,0,-weight*255);else return color(weight*255,weight*255,0);
     default: //Wszystkie inne 
             if(weight>=0) return color(128,0,weight*255);else return color(-weight*255,-weight*255,128);
     }   
  }
  
  /// Setting `stroke` for this object. 
  /// @param Intensity - used for alpha channel.
  void applyStroke(float Intensity)
  {  //float   MAX_LINK_WEIGHT=2;   ///Use maximal strokeWidth for links
     strokeWeight(abs(weight)*MAX_LINK_WEIGHT);
     switch ( ltype )
     {
     case 0: if(weight<=0) stroke(0,-weight*255,0,Intensity);else stroke(weight*255,0,weight*255,Intensity);break;
     case 1: if(weight<=0) stroke(-weight*255,0,0,Intensity);else stroke(0,weight*255,weight*255,Intensity);break;
     case 2: if(weight<=0) stroke(0,0,-weight*255,Intensity);else stroke(weight*255,weight*255,0,Intensity);break;
     default: //Wszystkie inne 
             if(weight>=0) stroke(128,0,weight*255,Intensity);else stroke(-weight*255,-weight*255,128,Intensity);
             break;
     }
  }
  
  /// @note Use maximal `strokeWidth()` for links. 
  /// @todo Zerowe znikają w grafice SVG!
  void applyStroke(float weight,float MaxIntensity)
  {  //float   MAX_LINK_WEIGHT=2;   
     strokeWeight(1+abs(weight)*MAX_LINK_WEIGHT); 
     switch ( ltype )
     {
     case 0: if(weight<=0) stroke(0,-weight*255,0,MaxIntensity);else stroke(weight*255,0,weight*255,MaxIntensity);break;
     case 1: if(weight<=0) stroke(-weight*255,0,0,MaxIntensity);else stroke(0,weight*255,weight*255,MaxIntensity);break;
     case 2: if(weight<=0) stroke(0,0,-weight*255,MaxIntensity);else stroke(weight*255,weight*255,0,MaxIntensity);break;
     default: //Wszystkie inne 
             if(weight>=0) stroke(128,0,weight*255,MaxIntensity);else stroke(-weight*255,-weight*255,128,MaxIntensity);
             break;
     }
  }
} //_EndOfClass

/**
* @brief Simplest link factory creates identical links except for the targets.
* @note It also serves as an example of designing factories.
*/
class basicLinkFactory extends LinkFactory
{
  float default_weight;
  int   default_type;
  
  basicLinkFactory(float def_weight,int def_type){ default_weight=def_weight;default_type=def_type;}
  
  Link  makeLink(Node Source,Node Target)
  {
    return new Link(Target,default_weight,default_type);
  }
} //_EndOfClass

///   IMPLEMENTATIONS:
//*///////////////////

/// Ring network.
void makeRingNet(iNode[] nodes,iLinkFactory linkfac,int neighborhood)  ///< Global namespace.
{
  int n=nodes.length;
  for(int i=0;i<n;i++)
  {
    iNode Source=nodes[i];
    
    if(Source!=null)
    {
      if(NET_DEBUG>2) println("i="+i,"Source="+Source,' ');
      
      for(int j=1;j<=neighborhood;j++)
      {
        int g=(n+i-j)%n; //left index
        int h=(i+j+n)%n; //right index
        
        if(nodes[g]!=null)
        {
          if(NET_DEBUG>2) print("i="+i,"g="+g,' ');
          Source.addConn( linkfac.makeLink(Source,nodes[g]) );
        }
        
        if(nodes[h]!=null)
        {
          if(NET_DEBUG>2) print("i="+i,"h="+h,' ');
          Source.addConn( linkfac.makeLink(Source,nodes[h]) );
        }    
        
        if(NET_DEBUG>2) println();
      }
    }
  }
}

/// Torus lattice 1D - It is alias for Ring net only.
void makeTorusNet(iNode[] nodes,iLinkFactory links,int neighborhood)      ///< Global namespace.
{  
   makeRingNet(nodes,links,neighborhood);
}

/// Torus lattice 2D.
void makeTorusNet(iNode[][] nodes,iLinkFactory linkfac,int neighborhood)  ///< Global namespace.
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
        if(NET_DEBUG>2) println("i="+i,"k="+k,"Source="+Source,' ');
        
        for(int j=-neighborhood;j<=neighborhood;j++)
        {
          int vert=(s+i+j)%s; //up index
          
          for(int m=-neighborhood;m<=neighborhood;m++)
          {
            int hor=(z+k+m)%z; //right index
            
            iNode Target;
            
            if((Target=nodes[vert][hor])!=null && Target!=Source)
            {
              if(NET_DEBUG>2) print("Vert="+vert,"Hor="+hor,' ');
              Source.addConn( linkfac.makeLink(Source,Target) );
            }
  
            if(NET_DEBUG>2) println();
          }
        }
      }
    }
  }
}

/// Rewire some connection for Small World 1D.
void rewireLinksRandomly(iNode[] nodes,float probability, boolean reciprocal)  ///< Global namespace.
{ 
  for(int i=0;i<nodes.length;i++)
  {
    iNode Source=nodes[i];
    if(Source==null) 
                  continue;
                  
    if(random(1.0)<probability)
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
          l.getTarget().delConn(r); //Usunięcie zwrotnego linku jesli był
          r.setTarget(Source); //Poprawienie linku
          Target.addConn(r); //Dodanie nowego zwrotnego linku w Targecie
        }  
      }
      
      l.setTarget(Target); //Replacing target!    
      //if(debug_level>2) println();
    }  
  }
}

/// Rewire some connection for Small World 2D.
void rewireLinksRandomly(iNode[][] nodes,float probability, boolean reciprocal)  ///< Global namespace.
{ 
  for(int i=0;i<nodes.length;i++)
  for(int g=0;g<nodes[i].length;g++)
  {
    iNode Source=nodes[i][g];
    if(Source==null) 
                  continue;                  
    //Czy tu jakiś link zostanie przerobiony?
    if(random(1.0)<probability)
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
          l.getTarget().delConn(r); //Usunięcie zwrotnego linku jesli był
          r.setTarget(Source); //Poprawienie linku
          Target.addConn(r); //Dodanie nowego zwrotnego linku w Targecie
        }  
      }
      
      l.setTarget(Target); //Replacing target!
      //if(debug_level>2) println();
    }  
  }
}

/// Classic Small World 1D.
void makeSmWorldNet(iNode[] nodes,iLinkFactory links,int neighborhood,float probability, boolean reciprocal)  ///< Global namespace.
{ 
  makeTorusNet(nodes,links,neighborhood);
  rewireLinksRandomly(nodes,probability,  reciprocal);
}

/// Classic Small World 2D.
void makeSmWorldNet(iNode[][] nodes,iLinkFactory links,int neighborhood,float probability, boolean reciprocal)  ///< Global namespace.
{ 
  makeTorusNet(nodes,links,neighborhood);
  rewireLinksRandomly(nodes,probability,  reciprocal);
}

/// Improved Small World 2D.
void makeImSmWorldNet(iNode[][] nodes,iLinkFactory links,int neighborhood,float probability, boolean reciprocal)  ///< Global namespace.
{ 
  makeTorusNet(nodes,links,neighborhood);
  makeRandomNet(nodes,links,probability,  reciprocal);
}

/// Improved Small World 1D.
void makeImSmWorldNet(iNode[] nodes,iLinkFactory links,int neighborhood,float probability, boolean reciprocal)  ///< Global namespace.
{ 
  makeTorusNet(nodes,links,neighborhood);
  makeRandomNet(nodes,links,probability,  reciprocal);
}

/// It tests if node `what` is in `cluster`.
/*_inline*/ boolean inCluster(iNode[] cluster,iNode what)
{
  for(int j=0;j<cluster.length;j++)
   if(cluster[j]==what) //juz jest w cluster'ze
   {
     if(NET_DEBUG>2) 
         println("node",what,"already on list!!!");
     return true; //<>// //<>//
   }
  return false;
}

/// Scale Free 1D.
void makeScaleFree(iNode[] nodes,iLinkFactory linkfac,int sizeOfFirstCluster,int numberOfNewLinkPerNode, boolean reciprocal)  ///< Global namespace.
{
  if(NET_DEBUG>1) println("MAKING SCALE FREE",sizeOfFirstCluster,numberOfNewLinkPerNode,reciprocal);
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
    for(int j=0;j<nodes.length;) //Próbujemy każdego przyłączyć do czegoś
    {
        iNode source=nodes[j];
        if(source==null)
            continue;
            
        float where=EPS+random(1.0);                      assert(where>0.0f); //"where" okresli do którego węzła się przyłączymy
        float start=0;                                    if(NET_DEBUG>2) print(j,where,"->");
        for(int k=0;k<nodes.length;k++)
        {
          iNode target=nodes[k];
          if(target==null)
            continue;  
            
          float pwindow = target.numOfConn() / numberOfLinks; if(NET_DEBUG>3) print(pwindow,"; ");
          if(start<where && where<=start+pwindow)         //Czy trafił w przedział?
          {
                                                          if(NET_DEBUG>2) print(k,"!");
            if(source!=target)
            {
              int success=source.addConn( linkfac.makeLink(source,target) );
              if( success==1 ) //TYLKO GDY NOWY LINK!
              {
                numberOfLinks++;
                if(reciprocal)
                  if(target.addConn( linkfac.makeLink(target,source) )==1) //OK TYLKO GDY NOWY LINK
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
        }                                                  if(NET_DEBUG>2) println();
    }
    if(NET_DEBUG>1) println("DONE! SCALE FREE HAS MADE");
}

/// Full connected network 1D.
void makeFullNet(iNode[] nodes,iLinkFactory linkfac)         ///< Global namespace.
{
  int n=nodes.length;
  for(int i=0;i<n;i++)
  {
    iNode Source=nodes[i];
    if(Source!=null)
      for(int j=0;j<n;j++)
        if(i!=j && nodes[j]!=null )
        {
          if(NET_DEBUG>4) print("i="+i,"j="+j);
          
          Source.addConn( linkfac.makeLink(Source,nodes[j]) );
          
          if(NET_DEBUG>4) println();
        }
  }
}

/// Full connected network 2D.
void makeFullNet(iNode[][] nodes,iLinkFactory linkfac)      ///< Global namespace.
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
          if(NET_DEBUG>4) print("i="+i,"g="+g,"j="+j,"h="+h);
          
          Source.addConn( linkfac.makeLink(Source,Target) );
          
          if(NET_DEBUG>4) println();
        }
      }
  }
}

/// Randomly connected network 1D.
void makeRandomNet(iNode[] nodes,iLinkFactory linkfac,float probability, boolean reciprocal)  ///< Global namespace.
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
        if(Target!=null && Source!=Target && random(1.0)<probability)
        {
          if(NET_DEBUG>2) print("i="+i,"j="+j);
                                                                
          int success=Source.addConn( linkfac.makeLink( Source, Target ) );
          if(success==1)
            Target.addConn( linkfac.makeLink( Target, Source ) );
          
          if(NET_DEBUG>2) println();
        }
      }   
    }
    else
    {
      for(int j=0;j<n;j++)
      {
        iNode Target=nodes[j];
        if(Target!=null && Source!=Target && random(1.0)<probability)
        {
          if(NET_DEBUG>2) print("i="+i,"j="+j);
                                                                
          //int success=
          Source.addConn( linkfac.makeLink( Source, Target ) );
          
          if(NET_DEBUG>2) println();
        }
      }       
    }
  }
}

/// Connect all orphaned nodes with at least one link.
void makeOrphansAdoption(iNode[] nodes,iLinkFactory linkfac, boolean reciprocal)    ///< Global namespace.
{
  int n=nodes.length;
  for(int i=0;i<n;i++)
  {
    iNode Source=nodes[i];
    if(Source==null || Source.numOfConn() > 0)
        continue;
        
    //Only if exists and is orphaned
                                                                      if(NET_DEBUG>0) print("Orphan",nf(i,3),":");
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
                                                                      if(NET_DEBUG>0) print("(",Ntry,")",nf(t,3),"is a chosen one ", Target.name() ); 
    }
                                                                      //if(debug_level>1) print(" S has ", Source.numOfConn() ," links");
    int success=Source.addConn( linkfac.makeLink( Source, Target ) ); 
                                                                      //if(debug_level>1) print(" Now S has ", Source.numOfConn() ," ");
    if(success!=1)
    {
       print(" WRONG! BUT WHY? "); //<>// //<>//
    }
    else
    if(reciprocal)
    {                                                                 //if(debug_level>1) print(" T has", Target.numOfConn() ," links");
       success=Target.addConn( linkfac.makeLink( Target, Source ) );
                                                                      //if(debug_level>1) print(" Now T has", Target.numOfConn() ," ");
    }
    
                                                                      if(NET_DEBUG>0)
                                                                        if(success==1)  println(" --> Not any more orphaned!");
                                                                        else  println("???",success);
  }
}

/// Randomly connected network 2D.
void makeRandomNet(iNode[][] nodes,iLinkFactory linkfac,float probability, boolean reciprocal)  ///< Global namespace.
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
          if(NET_DEBUG>2) print("i="+i,"g="+g,"j="+j,"h="+h);
                                                               
          int success=Source.addConn( linkfac.makeLink(Source,Target) );
          if(success==1)
            Target.addConn( linkfac.makeLink(Target,Source) );
            
          if(NET_DEBUG>2) println();
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
          if(NET_DEBUG>2) print("i="+i,"g="+g,"j="+j,"h="+h);
                                                               
          //int success=
          Source.addConn( linkfac.makeLink(Source,Target) );
            
          if(NET_DEBUG>2) println();
        }
      }
    }
  }
}

/**
* @brief Node implementation based on `ArrayList.`
* @internal "https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html"
*/
class NodeAsList extends Node  implements iVisNode {
  ArrayList<Link> connections; 
  
  NodeAsList()
  {
    connections=new ArrayList<Link>();
  }
  
  int     numOfConn()  //!< By interface required.    
  { return connections.size(); }
  
  int     addConn(iLink   l)
  {
     return addConn((Link)l);
  }
  
  int     addConn(Link   l) //!< By interface required.
  {
                                          assert l!=null : "Empty link in "+this.getClass().getName()+".addConn(Link)?";
    if(NET_DEBUG>2 && l.getTarget()==this)   //It may not be expected!
            print("Self connecting of",l.getTarget().name());
            
    boolean res=false;
    
    if(getConn(l.getTarget())==null)
    {
        res=connections.add(l);
        if(NET_DEBUG>1) print("* ");
    }
    else if(NET_DEBUG>1) println("Link",this.name(),
                                   "->",l.target.name(), // new line for C++ sed-translator
                                   "already exist"); // '.' should not be between '"' 

    if(res) return   1;
    else    return   0;
  }
  
  int     delConn(iLink   l) //!< By interface required.
  {
    if(connections.remove(l))
      return 1;
    else
      return 0;
  }
  
  Link    getConn(int    i) //!< By interface required.
  {
    assert i<connections.size(): "Index '"+i+"' out of bound '"+connections.size()+"' in "+this.getClass().getName()+".getConn(int)"; 
    return connections.get(i);
  }
  
  Link    getConn(iNode   n) //!< By interface required.
  {
                                           assert n!=null : "Empty node in "+this.getClass().getName()+".getConn(Node)";
    for(Link l:connections)
    {
      if(l.target==n) 
            return l;
    }
    return null;
  }
  
  Link    getConn(String k) //!< By interface required.
  {
                              assert k==null || k=="" : "Empty string in "+this.getClass().getName()+".getConn(String)";
    for(Link l:connections)
    {
      if(l.target.name()==k) 
            return l;
    }
    return null;
  }
  
  Link[]  getConns(iLinkFilter f) //!< By interface required.
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
  } //<>//
  
  // REMAINING INTERFACES REQUIREMENTS:
  //*//////////////////////////////////
  color defColor() { return color(0,128); }
  float     getX() { return posX(); }
  float     getY() { return posY(); }
  float     getZ() { return 0; }
  String getName() { return name();}
  
} //_EndOfClass

/**
* @brief Node implementation based on hash map.
* @internal "https://docs.oracle.com/javase/6/docs/api/java/util/HashMap.html"
*/
class NodeAsMap extends Node implements iVisNode {  
  //HashMap<Integer,Link> connections; //TODO using Object.hashCode(). Could be a bit faster than String
  HashMap<String,Link> connections; 
  
  NodeAsMap()
  {
    connections=new HashMap<String,Link>(); 
  }
  
  int     numOfConn()      { return connections.size();}
  
  int     addConn(iLink   l)
  {
     return addConn((Link)l);
  }
  
  int     addConn(Link   l)
  {
    assert l!=null : "Empty link in "+this.getClass().getName()+".addConn(Link)?"; 
    if(NET_DEBUG>2 && l.target==this) //It may not be expected!
            print("Self connecting of",l.target.name());
            
    //int hash=l.target.hashCode();//((Object)this).hashCode() for HashMap<Integer,Link>      
    String key=l.target.name();
    Link old=connections.put(key,l); 
    
    if(old==null)
      return   1;
    else
      return 0;
  }
  
  int     delConn(iLink   l)
  {
    assert false : "Not implemented "+this.getClass().getName()+".delConn(Link "+l+") called"; 
    return   -1;
  }
  
  Link    getConn(int    i)
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
  
  Link    getConn(iNode   n)
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
  
  Link[]  getConns(iLinkFilter f)
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

  // REMAINING INTERFACES REQUIREMENTS:
  //*//////////////////////////////////
  color defColor() { return color(255,128); }
  float     getX() { return posX(); }
  float     getY() { return posY(); }
  float     getZ() { return 0; }
  String getName() { return name();}
  
} //_EndOfClass

//*////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS 
//*  - FUNCTIONS & CLASSES  - NETWORKS TOOLBOX
//*  https://github.com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////
