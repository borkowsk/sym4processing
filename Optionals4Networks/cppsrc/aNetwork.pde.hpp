/// Generic (social) network classes. ("aNetwork.pde")
/// @date 2024-10-21 (last modification)
//*/////////////////////////////////////////////////////////////////////////////

//HashMap will be used here

/// @details
///
///   Classes:
///   ========
///   - `class Link : public  Colorable : public virtual iLink`
///   - `class NodeList : public  Node`
///   - `class NodeMap : public  Node`
///
///   Abstractions:
///   =============
///   - `virtual  class Node : public  Positioned` 
///   - `virtual  class LinkFilter`
///   - `virtual  class LinkFactory`
///
///   - `virtual  class Named : public virtual iNamed`
///   - `virtual  class Colorable : public  Named : public virtual iColorable`
///   - `virtual  class Positioned : public  Colorable : public virtual iPositioned`
///
///   Network generators: 
///   ===================
///   - `void makeRingNet(sarray<pNode> nodes,pLinkFactory links,int neighborhood)`
///   - `void makeTorusNet(sarray<pNode> nodes,pLinkFactory links,int neighborhood)`
///   - `void makeTorusNet(smatrix<pNode> nodes,pLinkFactory links,int neighborhood)`
/// 
///   - `void makeFullNet(sarray<pNode> nodes,pLinkFactory links)`
///   - `void makeFullNet(smatrix<pNode> nodes,pLinkFactory links)`
/// 
///   - `void makeRandomNet(sarray<pNode> nodes,pLinkFactory links,float probability, bool    reciprocal)`
///   - `void makeRandomNet(smatrix<pNode> nodes,pLinkFactory links,float probability, bool    reciprocal)`
///
///   - `void makeOrphansAdoption(sarray<pNode> nodes,pLinkFactory links, bool    reciprocal)`
/// 
///   - `void makeSmWorldNet(sarray<pNode> nodes,pLinkFactory links,int neighborhood,float probability, bool    reciprocal)`
///   - `void makeImSmWorldNet(sarray<pNode> nodes,pLinkFactory links,int neighborhood,float probability, bool    reciprocal)`
///

/*_extern*/ int NET_DEBUG_LEV=1;  ///< DEBUG level for network->Should be defined outside this file!

///  ABSTRACT BASE CLASSES:
//*////////////////////////

/**
* @brief Abstraction of link filtering class.
*/
//abstract
class LinkFilter : public virtual iLinkFilter , public virtual Object{
  public:
  virtual  bool    meetsTheAssumptions(piLink l)
                  {
	assert(false );	//  "Pure virtual  meetsTheAssumptions(Link) called";
 	return  false;
	}
} ; //_EndOfClass_


/**
* @brief Abstraction of link factory class->Forcing `makeLink()` and `makeSelfLink()` methods.
*/
//abstract
class LinkFactory : public virtual iLinkFactory , public virtual Object{
  public:
  virtual  piLink  makeLink(piNode Source,piNode Target)
                  {
	assert(false );	//  "Pure virtual  make(Node,Node) called";
 	return  nullptr;
	}
                 piLink  makeSelfLink(piNode Self)
                  {
	assert(false );	//  "Pure virtual  make(Node) called";
 	return  nullptr;
	} //<>//
} ; //_EndOfClass


/**
* @brief Abstraction of string-named class->Forcing `name()` method for visualisation and mapping.
*/
//abstract
class Named : public virtual iNamed , public virtual Object{
  public:       
  virtual  String    name(){assert(false );	//  "Pure interface name() called";
 	return  nullptr;}
} ; //_EndOfClass


/**
* @brief Abstraction for any colorable object->Only for visualisation.
*/

//_endOfSuperClass; // Now will change of superclass!
//Base class is now:
#define _superclass _
//_derivedClass:Colorable

//abstract
class Colorable : public  Named, public virtual iColorizer , public virtual Object{
  public:
  virtual  void   applyFill(float modifier) {
	assert(false );	//  "Pure virtual    `applyFill()` called";
	}
  virtual  void applyStroke(float modifier) {
	assert(false );	//  "Pure virtual  `applyStroke()` called";
	}
} ; //_EndOfClass


/**
* @brief Forcing `posX()` & `posY()` & `posZ()` methods for visualisation and mapping.
*/

//_endOfSuperClass; // Now will change of superclass!
//Base class is now:
#define _superclass _
//_derivedClass:Positioned

//abstract
class Positioned : public  Colorable, public virtual iPositioned , public virtual Object{
  public:
  virtual  float    posX(){assert(false );	//  "Pure virtual  posX() called";
 	return  0;}
  virtual  float    posY(){assert(false );	//  "Pure virtual  posY() called";
 	return  0;}
  virtual  float    posZ(){assert(false );	//  "Pure virtual  posZ() called";
 	return  0;}
} ; //_EndOfClass


/**
* @brief Abstraction class for any network node.
*/

//_endOfSuperClass; // Now will change of superclass!
//Base class is now:
#define _superclass _
//_derivedClass:Node

//abstract
class Node : public  Positioned, public virtual iNode , public virtual Object{
  public:
  virtual  int      addConn(piLink   l){assert(false );	//  String("Pure virtual  addConn(Link ")+l+ String(") called");
 	return    -1;}
  virtual  int      delConn(piLink   l){assert(false );	//  String("Pure virtual  delConn(Link ")+l+ String(") called");
 	return    -1;}
  virtual  int      numOfConn()       {
	assert(false );	//  "Pure virtual  numOfConn() called";
 	return    -1;
	}
  virtual  piLink    getConn(int    i) {
	assert(false );	//  String("Pure virtual  getConn(int ")+i+ String(")  called");
 	return  nullptr;
	}
  virtual  piLink    getConn(piNode   n){assert(false );	//  String("Pure virtual  getConn(Node ")+n+ String(") called");
 	return  nullptr;}
  virtual  piLink    getConn(String k) {
	assert(false );	//  String("Pure virtual  getConn(String '")+k+ String("') called");
 	return  nullptr;
	}
  virtual  sarray<piLink>  getConns(piLinkFilter f)
                  {
	 assert(false );	//  String("Pure virtual  getConns(LinkFilter ")+f+ String(") called");
 	return  nullptr;
	}
} ; //_EndOfClass


///  CLASS FOR MODIFICATION:
//*/////////////////////////

/**
* @brief Real link implementation->This class is available for user modifications.
*/

//_endOfSuperClass; // Now will change of superclass!
//Base class is now:
#define _superclass _
//_derivedClass:Link

class Link : public  Colorable, public virtual iLink,iVisLink,Comparable<pLink> , public virtual Object{
  public:
  pNode  target;  //!< targeted node.
  float weight;  //!< importance/trust
  int   ltype;   //!< "color"
  
  //... add something, if you need in derived classes.
  
  /// Constructor.
  Link(pNode targ,float we,int ty){ target=targ;weight=we;ltype=ty;}
  
  /// Text formatted data from the object.
  String fullInfo(String fieldSeparator)
  {
    return String("W:")+weight+fieldSeparator+String("Tp:")+ltype+fieldSeparator+String("->")+target;
  }
  
  /// For sorting->Much weighted link should be at the beginning of the array!
  /// Compares this object with the specified object for order.
  int  compareTo(pLink o) 
  {
     if(o==this || o->weight==weight) return 0;
     else
     if(o->weight>weight) return 1;
     else return -1;
  }
  
  /// For visualisation and mapping.  
  String    name(){ return target->name(); }
  String getName(){ return target->name(); }
  
  /// Read only access to `weight`.
  float getWeight() {
	 return weight;
	}
  
  /// Provide target node
  piNode getTarget() {
	 return target;
	}

  /// Provide target casted on visualisable node.
  piVisNode  getVisTarget() {
	 return std::dynamic_pointer_cast<iVisNode>(target);
	}
  
  void  setTarget(piNode tar) {
	 target=std::dynamic_pointer_cast<Node>(tar); 
	}
  
  /// Marker for type of link.
  int   getTypeMarker() {
	 return ltype; 
	}
  
  /// How object should be colored.
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
     strokeWeight(std::abs(weight)*MAX_LINK_WEIGHT);
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
  /// @todo Zerowe znikają w grafice SVG!!! A także X11 !!!
  void applyStroke(float weight,float MaxIntensity)
  {  //float   MAX_LINK_WEIGHT=2;   
     strokeWeight(1+std::abs(weight)*MAX_LINK_WEIGHT); 
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
} ; //_EndOfClass_


/**
* @brief Simplest link factory creates identical links except for the targets.
* @note It also serves as an example of designing factories.
*/

//_endOfSuperClass; // Now will change of superclass!
//Base class is now:
#define _superclass _
//_derivedClass:BasicLinkFactory

class BasicLinkFactory : public  LinkFactory , public virtual Object{
  public:
  float default_weight;
  int   default_type;
  
  BasicLinkFactory(float def_weight,int def_type){ default_weight=def_weight;default_type=def_type;}
  
  pLink  makeLink(pNode source,pNode target)
  {
    return new Link(target,default_weight,default_type);
  }
} ; //_EndOfClass_


//  IMPLEMENTATIONS:
//*/////////////////

/// Ring network.
void makeRingNet(sarray<piNode> nodes,piLinkFactory linkFact,int neighborhood)  ///< Global namespace.
{
  int n=nodes->length;
  for(int i=0;i<n;i++)
  {
    piNode Source=nodes[i];
    
    if(Source!=nullptr)
    {
      if(NET_DEBUG>2) println(String("i=")+i,String("Source=")+Source,' ');
      
      for(int j=1;j<=neighborhood;j++)
      {
        int g=(n+i-j)%n; //left index
        int h=(i+j+n)%n; //right index
        
        if(nodes[g]!=nullptr)
        {
          if(NET_DEBUG>2) print(String("i=")+i,String("g=")+g,' ');
          Source->addConn( linkFact->makeLink(Source,nodes[g]) );
        }
        
        if(nodes[h]!=nullptr)
        {
          if(NET_DEBUG>2) print(String("i=")+i,String("h=")+h,' ');
          Source->addConn( linkFact->makeLink(Source,nodes[h]) );
        }    
        
        if(NET_DEBUG>2) println();
      }
    }
  }
}

/// Torus lattice 1D - It is alias for Ring net only.
void makeTorusNet(sarray<piNode> nodes,piLinkFactory links,int neighborhood)      ///< Global namespace.
{  
   makeRingNet(nodes,links,neighborhood);
}

/// Torus lattice 2D.
void makeTorusNet(smatrix<piNode> nodes,piLinkFactory linkFact,int neighborhood)  ///< Global namespace.
{
  int s=nodes->length;   
  for(int i=0;i<s;i++)
  {
    int z=nodes[i]->length;
    for(int k=0;k<z;k++)
    {
      piNode Source=nodes[i][k];
      
      if(Source!=nullptr)
      {
        if(NET_DEBUG>2) println(String("i=")+i,String("k=")+k,String("Source=")+Source,' ');
        
        for(int j=-neighborhood;j<=neighborhood;j++)
        {
          int vert=(s+i+j)%s; //up index
          
          for(int m=-neighborhood;m<=neighborhood;m++)
          {
            int hor=(z+k+m)%z; //right index
            
            piNode Target;
            
            if((Target=nodes[vert][hor])!=nullptr && Target!=Source)
            {
              if(NET_DEBUG>2) print(String("Vert=")+vert,String("Hor=")+hor,' ');
              Source->addConn( linkFact->makeLink(Source,Target) );
            }
  
            if(NET_DEBUG>2) println();
          }
        }
      }
    }
  }
}

/// Rewire some connection for Small World 1D.
void rewireLinksRandomly(sarray<piNode> nodes,float probability, bool    reciprocal)  ///< Global namespace.
{ 
  for(int i=0;i<nodes->length;i++)
  {
    piNode Source=nodes[i];
    if(Source==nullptr) 
                  continue;
                  
    if(random(1.0)<probability)
    {
      int j=(int)random(nodes->length);
      piNode Target=nodes[j];
      
      if(Target==nullptr || Source==Target 
         || Source->getConn(Target)!=nullptr 
         )
         continue; //To losowanie nie ma sensu   
         
      //if(debug_level>2) print(String("i=")+i,String("g=")+g,String("j=")+j);
       
      int index=(int)random(Source->numOfConn());  assert(index<Source->numOfConn());	// 
      piLink l=Source->getConn(index);
      
      if(reciprocal)
      {
        piLink r=l->getTarget()->getConn(Source);
        if(r!=nullptr) 
        {
          l->getTarget()->delConn(r); //Usunięcie zwrotnego linku jeśli był
          r->setTarget(Source); //Poprawienie linku
          Target->addConn(r); //Dodanie nowego zwrotnego linku w Targecie
        }  
      }
      
      l->setTarget(Target); //Replacing target!    
      //if(debug_level>2) println();
    }  
  }
}

/// Rewire some connection for Small World 2D.
void rewireLinksRandomly(smatrix<piNode> nodes,float probability, bool    reciprocal)  ///< Global namespace.
{ 
  for(int i=0;i<nodes->length;i++)
  for(int g=0;g<nodes[i]->length;g++)
  {
    piNode Source=nodes[i][g];
    if(Source==nullptr) 
                  continue;                  
    //Czy tu jakiś link zostanie przerobiony?
    if(random(1.0)<probability)
    {
      //Nowy target - trzeba trafić           
      int j=(int)random(nodes->length);
      int h=(int)random(nodes[j]->length);
      piNode Target=nodes[j][h];
      if(Target==nullptr || Source==Target 
         || Source->getConn(Target)!=nullptr 
         )
         continue; //To losowanie nie ma sensu       
      
      //if(debug_level>2) print(String("i=")+i,String("g=")+g,String("j=")+j,String("h=")+h);
       
      int index=(int)random(Source->numOfConn());      assert(index<Source->numOfConn());	//       
      piLink l=Source->getConn(index);
 
      if(reciprocal)
      {
        piLink r=l->getTarget()->getConn(Source);
        if(r!=nullptr) 
        {
          l->getTarget()->delConn(r); //Usunięcie zwrotnego linku jeśli był
          r->setTarget(Source); //Poprawienie linku
          Target->addConn(r); //Dodanie nowego zwrotnego linku w Targecie
        }  
      }
      
      l->setTarget(Target); //Replacing target!
      //if(debug_level>2) println();
    }  
  }
}

/// Classic Small World 1D.
void makeSmWorldNet(sarray<piNode> nodes,piLinkFactory links,int neighborhood,float probability, bool    reciprocal)  ///< Global namespace.
{ 
  makeTorusNet(nodes,links,neighborhood);
  rewireLinksRandomly(nodes,probability,  reciprocal);
}

/// Classic Small World 2D.
void makeSmWorldNet(smatrix<piNode> nodes,piLinkFactory links,int neighborhood,float probability, bool    reciprocal)  ///< Global namespace.
{ 
  makeTorusNet(nodes,links,neighborhood);
  rewireLinksRandomly(nodes,probability,  reciprocal);
}

/// Improved Small World 2D.
void makeImSmWorldNet(smatrix<piNode> nodes,piLinkFactory links,int neighborhood,float probability, bool    reciprocal)  ///< Global namespace.
{ 
  makeTorusNet(nodes,links,neighborhood);
  makeRandomNet(nodes,links,probability,  reciprocal);
}

/// Improved Small World 1D.
void makeImSmWorldNet(sarray<piNode> nodes,piLinkFactory links,int neighborhood,float probability, bool    reciprocal)  ///< Global namespace.
{ 
  makeTorusNet(nodes,links,neighborhood);
  makeRandomNet(nodes,links,probability,  reciprocal);
}

/// It tests if node `what` is in `cluster`.
inline  bool    inCluster(sarray<piNode> cluster,piNode what)
{
  for(int j=0;j<cluster->length;j++)
   if(cluster[j]==what) //juz jest w cluster'ze
   {
     if(NET_DEBUG>2) 
         println("node",what,"already on list!!!");
     return true; //<>//<>//
   }
  return false;
}

/// Scale Free 1D.
void makeScaleFree(sarray<piNode> nodes,piLinkFactory linkFact,int sizeOfFirstCluster,int numberOfNewLinkPerNode, bool    reciprocal)  ///< Global namespace.
{
  if(NET_DEBUG>1) println("MAKING SCALE FREE",sizeOfFirstCluster,numberOfNewLinkPerNode,reciprocal);
  sarray<piNode> cluster=new array<piNode>(sizeOfFirstCluster); //if(debug_level>3) println("Initial:",(sarray<pNode>)cluster);//Nodes for initial cluster
  
  for(int i=0;i<sizeOfFirstCluster;)
  {
    int  pos=(int)random(nodes->length);
    piNode pom=nodes[pos];
    if(inCluster(cluster,pom))
            continue;
    cluster[i]=pom;     
    i++;
  }
  
  makeFullNet(cluster,linkFact); //Linking of initial cluster
  
  float numberOfLinks=0;
  for(piNode nod:nodes )
    if(nod!=nullptr)
      numberOfLinks+=nod->numOfConn();
      
  float EPS=1e-45f; //Najmniejszy możliwy float
  println("Initial number of links is",numberOfLinks,EPS);
  
  for(int i=0;i<numberOfNewLinkPerNode;i++)
    for(int j=0;j<nodes->length;) //Próbujemy każdego przyłączyć do czegoś
    {
        piNode source=nodes[j];
        if(source==nullptr)
            continue;
            
        float where=EPS+random(1.0);                      assert(where>0.0f); //"where" określi, do którego węzła się przyłączymy
        float start=0;                                    if(NET_DEBUG>2) print(j,where,"->");
        for(int k=0;k<nodes->length;k++)
        {
          piNode target=nodes[k];
          if(target==nullptr)
            continue;  
            
          float pwindow = target->numOfConn() / numberOfLinks; if(NET_DEBUG>3) print(pwindow,"; ");
          if(start<where && where<=start+pwindow)         //Czy trafił w przedział?
          {
                                                          if(NET_DEBUG>2) print(k,"!");
            if(source!=target)
            {
              int success=source->addConn( linkFact->makeLink(source,target) );
              if( success==1 ) //TYLKO GDY NOWY LINK!
              {
                numberOfLinks++;
                if(reciprocal)
                  if(target->addConn( linkFact->makeLink(target,source) )==1) //OK TYLKO GDY NOWY LINK
                      numberOfLinks++;
                j++; //Można przejść do podłączania następnego agenta
              }
            }
            
            break; //Znaleziono potencjalny target->Jeśli nie nastąpiło podłączenie to i tak trzeba losować od nowa
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
void makeFullNet(sarray<piNode> nodes,piLinkFactory linkFact)         ///< Global namespace.
{
  int n=nodes->length;
  for(int i=0;i<n;i++)
  {
    piNode Source=nodes[i];
    if(Source!=nullptr)
      for(int j=0;j<n;j++)
        if(i!=j && nodes[j]!=nullptr )
        {
          if(NET_DEBUG>4) print(String("i=")+i,String("j=")+j);
          
          Source->addConn( linkFact->makeLink(Source,nodes[j]) );
          
          if(NET_DEBUG>4) println();
        }
  }
}

/// Full connected network 2D.
void makeFullNet(smatrix<piNode> nodes,piLinkFactory linkFact)      ///< Global namespace.
{
  for(int i=0;i<nodes->length;i++)
  for(int g=0;g<nodes[i]->length;g++)
  {
    piNode Source=nodes[i][g];
    
    if(Source!=nullptr)
      for(int j=0;j<nodes->length;j++)
      for(int h=0;h<nodes[j]->length;h++)
      {
        piNode Target=nodes[j][h];
        
        if(Target!=nullptr && Source!=Target)
        {
          if(NET_DEBUG>4) print(String("i=")+i,String("g=")+g,String("j=")+j,String("h=")+h);
          
          Source->addConn( linkFact->makeLink(Source,Target) );
          
          if(NET_DEBUG>4) println();
        }
      }
  }
}

/// Randomly connected network 1D.
void makeRandomNet(sarray<piNode> nodes,piLinkFactory linkFact,float probability, bool    reciprocal)  ///< Global namespace.
{  
  //NO ERROR!: rings in visualisation are because agents may have sometimes exactly same position!!!
  int n=nodes->length;
  for(int i=0;i<n;i++)
  {
    piNode Source=nodes[i];
    if(Source==nullptr)
        continue;
        
    if(reciprocal)
    {
      for(int j=i+1;j<n;j++)
      {
        piNode Target=nodes[j];
        if(Target!=nullptr && Source!=Target && random(1.0)<probability)
        {
          if(NET_DEBUG>2) print(String("i=")+i,String("j=")+j);
                                                                
          int success=Source->addConn( linkFact->makeLink( Source, Target ) );
          if(success==1)
            Target->addConn( linkFact->makeLink( Target, Source ) );
          
          if(NET_DEBUG>2) println();
        }
      }   
    }
    else
    {
      for(int j=0;j<n;j++)
      {
        piNode Target=nodes[j];
        if(Target!=nullptr && Source!=Target && random(1.0)<probability)
        {
          if(NET_DEBUG>2) print(String("i=")+i,String("j=")+j);
                                                                
          //int success=
          Source->addConn( linkFact->makeLink( Source, Target ) );
          
          if(NET_DEBUG>2) println();
        }
      }       
    }
  }
}

/// Connect all orphaned nodes with at least one link.
void makeOrphansAdoption(sarray<piNode> nodes,piLinkFactory linkFact, bool    reciprocal)    ///< Global namespace.
{
  int n=nodes->length;
  for(int i=0;i<n;i++)
  {
    piNode Source=nodes[i];
    if(Source==nullptr || Source->numOfConn() > 0)
        continue;
        
    //Only if exists and is orphaned
                                                                      if(NET_DEBUG>0) print("Orphan",nf(i,3),":");
    piNode Target=nullptr;
    int NofAttempts=n;
    while(Target==nullptr) //Searching for foster parent
    {
      int t=(int)random(n);
      if( t==i                //candidate is not self
      ||  nodes[t]==nullptr      //is not empty 
      ||  (nodes[t]->numOfConn()==0 //is not other orphan
           && NofAttempts-- > 0  )   //but not when all are orphans!
      ) continue;
                                                                       
      Target=nodes[t]; //Candidate ok
                                                                      if(NET_DEBUG>0) print("(",NofAttempts,")",nf(t,3),"is a chosen one ", Target->name() ); 
    }
                                                                      //if(debug_level>1) print(" S has ", Source.numOfConn() ," links");
    int success=Source->addConn( linkFact->makeLink( Source, Target ) ); 
                                                                      //if(debug_level>1) print(" Now S has ", Source.numOfConn() ," ");
    if(success!=1)
    {
       print(" WRONG! BUT WHY? "); //<>//<>//
    }
    else
    if(reciprocal)
    {                                                                 //if(debug_level>1) print(" T has", Target.numOfConn() ," links");
       success=Target->addConn( linkFact->makeLink( Target, Source ) );
                                                                      //if(debug_level>1) print(" Now T has", Target.numOfConn() ," ");
    }
    
                                                                      if(NET_DEBUG>0)
                                                                        if(success==1)  println(" --> Not any more orphaned!");
                                                                        else  println("???",success);
  }
}

/// Randomly connected network 2D.
void makeRandomNet(smatrix<piNode> nodes,piLinkFactory linkFact,float probability, bool    reciprocal)  ///< Global namespace.
{
  for(int i=0;i<nodes->length;i++)
  for(int g=0;g<nodes[i]->length;g++)
  {
    piNode Source=nodes[i][g];
    
    if(Source==nullptr)
      continue;
    
    if(reciprocal)
    {  
      for(int j=i+1;j<nodes->length;j++)
      for(int h=g+1;h<nodes[j]->length;h++)
      {
        piNode Target=nodes[j][h];
        
        if(Target!=nullptr && Source!=Target && random(1)<probability)
        {
          if(NET_DEBUG>2) print(String("i=")+i,String("g=")+g,String("j=")+j,String("h=")+h);
                                                               
          int success=Source->addConn( linkFact->makeLink(Source,Target) );
          if(success==1)
            Target->addConn( linkFact->makeLink(Target,Source) );
            
          if(NET_DEBUG>2) println();
        }
      }
    }
    else
    {
      for(int j=0;j<nodes->length;j++)
      for(int h=0;h<nodes[j]->length;h++)
      {
        piNode Target=nodes[j][h];
        
        if(Target!=nullptr && Source!=Target && random(1)<probability)
        {
          if(NET_DEBUG>2) print(String("i=")+i,String("g=")+g,String("j=")+j,String("h=")+h);
                                                               
          //int success=
          Source->addConn( linkFact->makeLink(Source,Target) );
            
          if(NET_DEBUG>2) println();
        }
      }
    }
  }
}

/**
* @brief Node implementation based on `ArrayList.`
* @internal "https://docs->oracle->com/javase/8/docs/api/java/util/ArrayList.html"
*/

//_endOfSuperClass; // Now will change of superclass!
//Base class is now:
#define _superclass _
//_derivedClass:NodeAsList

class NodeAsList : public  Node, public virtual iVisNode , public virtual Object{
  public:
  pArrayList<pLink> connections; 
  
  NodeAsList()
  {
    connections=new ArrayList<pLink>();
  }
  
  int     numOfConn()  //!< By interface required.    
  {
	 return connections->size(); 
	}
  
  int     addConn(piLink   l)
  {
     return addConn((Link)l);
  }
  
  int     addConn(pLink   l) //!< By interface required.
  {
                                          assert(l!=nullptr );	//  String("Empty link in ")+this->getClass().getName()+ String("->addConn(Link)?");
    if(NET_DEBUG>2 && l->getTarget()==this)   //It may not be expected!
            print("Self connecting of",l->getTarget()->name());
            
    bool    res=false;
    
    if(getConn(l->getTarget())==nullptr)
    {
        res=connections->add(l);
        if(NET_DEBUG>1) print("* ");
    }
    else if(NET_DEBUG>1) println("Link",this->name(),
                                   "->",l->target->name(), // new line for C++ sed-translator
                                   "already exist"); // '.' should not be between '"' 

    if(res) return   1;
    else    return   0;
  }
  
  int     delConn(piLink   l) //!< By interface required.
  {
    if(connections->remove(l))
      return 1;
    else
      return 0;
  }
  
  pLink    getConn(int    i) //!< By interface required.
  {
    assert(i<connections->size());	//  String("Index '")+i+String("' out of bound '")+connections.size()+String("' in ")+this->getClass()->getName()+ String("->getConn(int)"); 
    return connections->get(i);
  }
  
  pLink    getConn(piNode   n) //!< By interface required.
  {
                                           assert(n!=nullptr );	//  String("Empty node in ")+this->getClass().getName()+ String("->getConn(Node)");
    for(pLink l:connections)
    {
      if(l->target==n) 
            return l;
    }
    return nullptr;
  }
  
  pLink    getConn(String k) //!< By interface required.
  {
                              assert(k==nullptr || k=="" );	//  String("Empty string in ")+this->getClass().getName()+ String("->getConn(String)");
    for(pLink l:connections)
    {
      if(l->target->name()==k) 
            return l;
    }
    return nullptr;
  }
  
  sarray<pLink>  getConns(piLinkFilter f) //!< By interface required.
  {
                            //assert(f!=nullptr );	//  String("Empty LinkFilter in ")+this->getClass().getName()+ String("->getConns(LinkFilter)");
    pArrayList<pLink> selected=new ArrayList<pLink>();
    for(pLink l:connections)
    {
      if(f==nullptr || f->meetsTheAssumptions(l)) 
            selected->add(l);
    }
    
    sarray<pLink> ret=new array<pLink>(selected->size());
    selected->toArray(ret);
    return ret;
  } //<>//
  
  // REMAINING INTERFACES REQUIREMENTS:
  //*//////////////////////////////////
  color defColor() {
	 return color(0,128); 
	}
  float     getX() {
	 return posX(); 
	}
  float     getY() {
	 return posY(); 
	}
  float     getZ() {
	 return 0; 
	}
  String getName() {
	 return name();
	}
  
} ; //_EndOfClass_


/**
* @brief Node implementation based on hash map.
* @internal "https://docs->oracle->com/javase/6/docs/api/java/util/HashMap.html"
*/

//_endOfSuperClass; // Now will change of superclass!
//Base class is now:
#define _superclass _
//_derivedClass:NodeAsMap

class NodeAsMap : public  Node, public virtual iVisNode , public virtual Object{
  public:  
  //pHashMap<int,pLink> connections; //@todo Maybe using Object::hashCode(). Could be a bit faster than String
  pHashMap<String,pLink> connections; 
  
  NodeAsMap()
  {
    connections=new HashMap<String,pLink>(); 
  }
  
  int     numOfConn()      {
	 return connections->size();
	}
  
  int     addConn(piLink   l)
  {
     return addConn((Link)l);
  }
  
  int     addConn(pLink   l)
  {
    assert(l!=nullptr );	//  String("Empty link in ")+this->getClass().getName()+ String("->addConn(Link)?"); 
    if(NET_DEBUG>2 && l->target==this) //It may not be expected!
            print("Self connecting of",l->target->name());
            
    //int hash=l->target->hashCode();//((Object)this)->hashCode() for HashMap<int,pLink>      
    String key=l->target->name();
    pLink old=connections->put(key,l); 
    
    if(old==nullptr)
      return   1;
    else
      return 0;
  }
  
  int     delConn(piLink   l)
  {
    assert(false );	//  String("Not implemented ")+this->getClass().getName()+String("->delConn(Link ")+l+ String(") called"); 
    return   -1;
  }
  
  pLink    getConn(int    i)
  {
    assert(i>=connections->size());	// String("Index '")+i+String("' out of bound '")+connections.size()+String("' in ")+this->getClass()->getName()+ String("->getConn(int)"); 
    assert(false);	//  "Non optimal use of NodeMap in getConn(int)";
    int counter=0;
    for(auto<String,pLink> ent:connections->entrySet())
    {
      if(i==counter) 
          return ent->getValue();
      counter++;
    }
    return nullptr;
  }
  
  pLink    getConn(piNode   n)
  {
    assert(n!=nullptr );	//  String("Empty node in ")+this->getClass().getName()+ String("->getConn(Node)"); 
    String key=n->name();
    return connections->get(key);
  }
  
  pLink    getConn(String k)
  {
    assert(k==nullptr || k=="" );	//  String("Empty string in ")+this->getClass().getName()+ String("->getConn(String)"); 
    return connections->get(k);
  }
  
  sarray<pLink>  getConns(piLinkFilter f)
  {
    assert(f!=nullptr );	//  String("Empty LinkFilter in ")+this->getClass().getName()+ String("->getConns(LinkFilter)"); 
    pArrayList<pLink> selected=new ArrayList<pLink>();
    for(auto<String,pLink> ent:connections->entrySet())
    {
      if(f->meetsTheAssumptions(ent->getValue())) 
            selected->add(ent->getValue());
    }
    sarray<pLink> ret=new array<pLink>(selected->size());
    selected->toArray(ret);
    return ret;
  }

  // REMAINING INTERFACES REQUIREMENTS:
  //*//////////////////////////////////
  color defColor() {
	 return color(255,128); 
	}
  float     getX() {
	 return posX(); 
	}
  float     getY() {
	 return posY(); 
	}
  float     getZ() {
	 return 0; 
	}
  String getName() {
	 return name();
	}
  
} ; //_EndOfClass_


//*////////////////////////////////////////////////////////////////////////////
//*  https://www->researchgate->net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS 
//*  - FUNCTIONS & CLASSES  - NETWORKS TOOLBOX
//*  https://github->com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////
//MADE NOTE: /data/wb/SCC/public/Processing2C/scripts did it 2024-10-21 21:30:14 !

