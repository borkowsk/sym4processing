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

import java.util.Map;

int debug_level=1;  ///< DEBUG level for network. Visible autside this file!

// ABSTRACT BASE CLASSES
///////////////////////////////////

/// 
abstract class LinkFilter implements iLinkFilter {
  /*_interfunc*/ boolean meetsTheAssumptions(iLink l)
                  {assert false : "Pure interface meetsTheAssumptions(Link) called"; return false;}
};

/// 
abstract class LinkFactory {
  /*_interfunc*/ Link  makeLink(Node Source,Node Target)
                  {assert false : "Pure interface make(Node,Node) called"; return null;}
                 Link  makeSelfLink(Node Self)
                  {assert false : "Pure interface make(Node) called"; return null;}
};

/// Forcing name() method for visualisation and mapping 
abstract class Named implements iNamed {       
  /*_interfunc*/ String    name(){assert false : "Pure interface name() called"; return null;}
};

/// Only for visualisation
abstract class Colorable extends Named implements iColorable {
  /*_interfunc*/ void setFill(float modifier){assert false : "Pure interface setFill() called";}
  /*_interfunc*/ void setStroke(float modifier){assert false : "Pure interface setStroke() called";}
};

/// Forcing posX() & posY() & posZ() methods for visualisation and mapping  
abstract class Positioned extends Colorable implements iPositioned {
  /*_interfunc*/ float    posX(){assert false : "Pure interface posX() called"; return 0;}
  /*_interfunc*/ float    posY(){assert false : "Pure interface posY() called"; return 0;}
  /*_interfunc*/ float    posZ(){assert false : "Pure interface posZ() called"; return 0;}
};

///INFO: 
abstract class Node extends Positioned implements iNode {
  /*_interfunc*/ int     addConn(Link   l){assert false : "Pure interface addConn(Link "+l+") called"; return   -1;}
  /*_interfunc*/ int     delConn(Link   l){assert false : "Pure interface delConn(Link "+l+") called"; return   -1;}
  /*_interfunc*/ int     numOfConn()      {assert false : "Pure interface numOfConn() called"; return   -1;}
  /*_interfunc*/ Link    getConn(int    i){assert false : "Pure interface getConn(int "+i+")  called"; return null;}
  /*_interfunc*/ Link    getConn(Node   n){assert false : "Pure interface getConn(Node "+n+") called"; return null;}
  /*_interfunc*/ Link    getConn(String k){assert false : "Pure method  getConn(String '"+k+"') called"; return null;}
  /*_interfunc*/ Link[]  getConns(LinkFilter f)
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
  
  String fullInfo(String fieldSeparator)
  {
    return "W:"+weight+fieldSeparator+"Tp:"+ltype+fieldSeparator+"->"+target;
  }
  
  //For sorting. Much weighted link should be at the begining of the array!
  int  compareTo(Link o)//Compares this object with the specified object for order.
  {
     if(o==this || o.weight==weight) return 0;
     else
     if(o.weight>weight) return 1;
     else return -1;
  }
  
  //For visualisation and mapping  
  String name(){ return target.name(); }
  
  float getWeight() { return weight;}
  int   getTypeMarker() { return ltype; }
  
  color     defColor()
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
  
  void setStroke(float Intensity)
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
  
  Link  makeLink(Node Source,Node Target)
  {
    return new Link(Target,default_weight,default_type);
  }
}

//   IMPLEMENTATIONS:
//*////////////////////

/// Ring network
void makeRingNet(Node[] nodes,LinkFactory linkfac,int neighborhood) {
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
void makeTorusNet(Node[] nodes,LinkFactory links,int neighborhood) {  
   makeRingNet(nodes,links,neighborhood);
}

/// Torus lattice 2D
void makeTorusNet(Node[][] nodes,LinkFactory linkfac,int neighborhood) {
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
void rewireLinksRandomly(Node[] nodes,float probability, boolean reciprocal) { 
  for(int i=0;i<nodes.length;i++)
  {
    Node Source=nodes[i];
    if(Source==null) 
                  continue;
                  
    if(random(1.0)<probability)
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
void rewireLinksRandomly(Node[][] nodes,float probability, boolean reciprocal) { 
  for(int i=0;i<nodes.length;i++)
  for(int g=0;g<nodes[i].length;g++)
  {
    Node Source=nodes[i][g];
    if(Source==null) 
                  continue;                  
    //Czy tu jakiś link zostanie przerobiony?
    if(random(1.0)<probability)
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
void makeSmWorldNet(Node[] nodes,LinkFactory links,int neighborhood,float probability, boolean reciprocal) { 
  makeTorusNet(nodes,links,neighborhood);
  rewireLinksRandomly(nodes,probability,  reciprocal);
}

/// Classic Small World 2D
void makeSmWorldNet(Node[][] nodes,LinkFactory links,int neighborhood,float probability, boolean reciprocal) { 
  makeTorusNet(nodes,links,neighborhood);
  rewireLinksRandomly(nodes,probability,  reciprocal);
}

/// Improved Small World 2D
void makeImSmWorldNet(Node[][] nodes,LinkFactory links,int neighborhood,float probability, boolean reciprocal) { 
  makeTorusNet(nodes,links,neighborhood);
  makeRandomNet(nodes,links,probability,  reciprocal);
}

/// Improved Small World 1D
void makeImSmWorldNet(Node[] nodes,LinkFactory links,int neighborhood,float probability, boolean reciprocal) { 
  makeTorusNet(nodes,links,neighborhood);
  makeRandomNet(nodes,links,probability,  reciprocal);
}

/*_inline*/ boolean inCluster(Node[] cluster,Node what)
{
  for(int j=0;j<cluster.length;j++)
   if(cluster[j]==what) //juz jest w cluster'ze
   {
     if(debug_level>2) 
         println("node",what,"already on list!!!");
     return true; //<>//
   }
  return false;
}

/// Scale Free 1D
void makeScaleFree(Node[] nodes,LinkFactory linkfac,int sizeOfFirstCluster,int numberOfNewLinkPerAgent, boolean reciprocal) {
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
            
        float where=EPS+random(1.0);                      assert(where>0.0f);//"where" okresli do którego węzła się przyłączymy
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
void makeFullNet(Node[] nodes,LinkFactory linkfac) {
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
void makeFullNet(Node[][] nodes,LinkFactory linkfac) {
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
void makeRandomNet(Node[] nodes,LinkFactory linkfac,float probability, boolean reciprocal) {  
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
        if(Target!=null && Source!=Target && random(1.0)<probability)
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
        if(Target!=null && Source!=Target && random(1.0)<probability)
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
void makeOrphansAdoption(Node[] nodes,LinkFactory linkfac, boolean reciprocal) {
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
       print(" WRONG! BUT WHY? "); //<>//
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
void makeRandomNet(Node[][] nodes,LinkFactory linkfac,float probability, boolean reciprocal) {
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
  
  int     numOfConn()      { return connections.size();}
  
  int     addConn(iLink   l)
  {
    println("NodeList.addConn(iLink   l) not implemented");
    return -1;
  }
  
  int     addConn(Link   l)
  {
    assert l!=null : "Empty link in "+this.getClass().getName()+".addConn(Link)?"; 
    if(debug_level>2 && l.target==this) //It may not be expected!
            print("Self connecting of",l.target.name()); //<>//
            
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
  
  int     delConn(iLink   l)
  {
    if(connections.remove(l))
      return 1;
    else
      return 0;
  }
  
  Link    getConn(int    i)
  {
    assert i<connections.size(): "Index '"+i+"' out of bound '"+connections.size()+"' in "+this.getClass().getName()+".getConn(int)"; 
    return connections.get(i);
  }
  
  Link    getConn(iNode   n)
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
  
  Link[]  getConns(iLinkFilter f)
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
  
  int     numOfConn()      { return connections.size();}
  
  int     addConn(iLink   l)
  {
    println("NodeMap.addConn(iLink   l) not implemented");
    return -1;
  }
  
  int     addConn(Link   l)
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
};

//*///////////////////////////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*///////////////////////////////////////////////////////////////////////////////////////////////////
