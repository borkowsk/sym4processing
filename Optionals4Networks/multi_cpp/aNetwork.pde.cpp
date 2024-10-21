/// @file
/// @note Automatically made from _aNetwork.pde_ by __Processing to C++__ converter (/data/wb/SCC/public/Processing2C/scripts/procesing2cpp.sh).
/// @date 2024-10-21 19:06:46 (translation)
//
#include "processing_consts.hpp"
#include "processing_templates.hpp"
#include "processing_library.hpp"
#include "processing_window.hpp"
#ifndef _NO_INLINE
#include "processing_inlines.hpp" //...is optional.
#endif // _NO_INLINE
#include "processing_string.hpp"  //Processing::String class
#include "processing_console.hpp"   //...is optional. Should be deleted when not needed.
#include "processing_alist.hpp" //...is optional. Should be deleted when not needed.
#include "processing_map.hpp"   //...is optional. Should be deleted when not needed.
using namespace Processing;
#include "local.h" //???.
#include <iostream>
//================================================================

/// @file 
/// @brief Generic (social) network classes ("aNetwork.pde")
/// @date 2024-09-03 (last modification)
//*/////////////////////////////////////////////////////////////////////////////

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

//HashMap will be used here

/// int NET_DEBUG_LEV=1;  ///< DEBUG level for network->Should be defined autside this file!

///  ABSTRACT BASE CLASSES:
//*////////////////////////

/**
* @brief Abstraction of link filtering class.
*/
#include "LinkFilter_class.pde.hpp"

/**
* @brief Abstraction of link factory class->Forcing `makeLink()` and `makeSalfLink()` methods.
*/
#include "LinkFactory_class.pde.hpp"

/**
* @brief Abstraction of string-named class->Forcing `name()` method for visualisation and mapping.
*/
#include "Named_class.pde.hpp"

/**
* @brief Abstraction for any colorable object->Only for visualisation.
*/
#include "Colorable_class.pde.hpp"

/**
* @brief Forcing `posX()` & `posY()` & `posZ()` methods for visualisation and mapping.
*/
#include "Positioned_class.pde.hpp"

/**
* @brief Abstraction class for any network node.
*/
#include "Node_class.pde.hpp"

///  CLASS FOR MODIFICATION:
//*/////////////////////////

/**
* @brief Real link implementation->This class is available for user modifications.
*/
#include "Link_class.pde.hpp"

/**
* @brief Simplest link factory creates identical links except for the targets.
* @note It also serves as an example of designing factories.
*/
#include "basicLinkFactory_class.pde.hpp"

///   IMPLEMENTATIONS:
//*///////////////////

/// Ring network.
void makeRingNet(sarray<piNode> nodes,piLinkFactory linkfac,int neighborhood)  ///< Global namespace.
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
          Source->addConn( linkfac->makeLink(Source,nodes[g]) );
        }
        
        if(nodes[h]!=nullptr)
        {
          if(NET_DEBUG>2) print(String("i=")+i,String("h=")+h,' ');
          Source->addConn( linkfac->makeLink(Source,nodes[h]) );
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
void makeTorusNet(smatrix<piNode> nodes,piLinkFactory linkfac,int neighborhood)  ///< Global namespace.
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
              Source->addConn( linkfac->makeLink(Source,Target) );
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
          l->getTarget()->delConn(r); //Usunięcie zwrotnego linku jesli był
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
          l->getTarget()->delConn(r); //Usunięcie zwrotnego linku jesli był
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
void makeScaleFree(sarray<piNode> nodes,piLinkFactory linkfac,int sizeOfFirstCluster,int numberOfNewLinkPerNode, bool    reciprocal)  ///< Global namespace.
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
  
  makeFullNet(cluster,linkfac); //Linking of initial cluster
  
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
            
        float where=EPS+random(1.0);                      assert(where>0.0f); //"where" okresli do którego węzła się przyłączymy
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
              int success=source->addConn( linkfac->makeLink(source,target) );
              if( success==1 ) //TYLKO GDY NOWY LINK!
              {
                numberOfLinks++;
                if(reciprocal)
                  if(target->addConn( linkfac->makeLink(target,source) )==1) //OK TYLKO GDY NOWY LINK
                      numberOfLinks++;
                j++; //Można przejść do podłączania nastepnego agenta
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
void makeFullNet(sarray<piNode> nodes,piLinkFactory linkfac)         ///< Global namespace.
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
          
          Source->addConn( linkfac->makeLink(Source,nodes[j]) );
          
          if(NET_DEBUG>4) println();
        }
  }
}

/// Full connected network 2D.
void makeFullNet(smatrix<piNode> nodes,piLinkFactory linkfac)      ///< Global namespace.
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
          
          Source->addConn( linkfac->makeLink(Source,Target) );
          
          if(NET_DEBUG>4) println();
        }
      }
  }
}

/// Randomly connected network 1D.
void makeRandomNet(sarray<piNode> nodes,piLinkFactory linkfac,float probability, bool    reciprocal)  ///< Global namespace.
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
                                                                
          int success=Source->addConn( linkfac->makeLink( Source, Target ) );
          if(success==1)
            Target->addConn( linkfac->makeLink( Target, Source ) );
          
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
          Source->addConn( linkfac->makeLink( Source, Target ) );
          
          if(NET_DEBUG>2) println();
        }
      }       
    }
  }
}

/// Connect all orphaned nodes with at least one link.
void makeOrphansAdoption(sarray<piNode> nodes,piLinkFactory linkfac, bool    reciprocal)    ///< Global namespace.
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
    int Ntry=n;
    while(Target==nullptr) //Searching for foster parent
    {
      int t=(int)random(n);
      if( t==i                //candidate is not self
      ||  nodes[t]==nullptr      //is not empty 
      ||  (nodes[t]->numOfConn()==0 //is not other orphan
           && Ntry-- > 0  )   //but not when all are orphans!
      ) continue;
                                                                       
      Target=nodes[t]; //Candidate ok
                                                                      if(NET_DEBUG>0) print("(",Ntry,")",nf(t,3),"is a chosen one ", Target->name() ); 
    }
                                                                      //if(debug_level>1) print(" S has ", Source.numOfConn() ," links");
    int success=Source->addConn( linkfac->makeLink( Source, Target ) ); 
                                                                      //if(debug_level>1) print(" Now S has ", Source.numOfConn() ," ");
    if(success!=1)
    {
       print(" WRONG! BUT WHY? "); //<>//<>//
    }
    else
    if(reciprocal)
    {                                                                 //if(debug_level>1) print(" T has", Target.numOfConn() ," links");
       success=Target->addConn( linkfac->makeLink( Target, Source ) );
                                                                      //if(debug_level>1) print(" Now T has", Target.numOfConn() ," ");
    }
    
                                                                      if(NET_DEBUG>0)
                                                                        if(success==1)  println(" --> Not any more orphaned!");
                                                                        else  println("???",success);
  }
}

/// Randomly connected network 2D.
void makeRandomNet(smatrix<piNode> nodes,piLinkFactory linkfac,float probability, bool    reciprocal)  ///< Global namespace.
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
                                                               
          int success=Source->addConn( linkfac->makeLink(Source,Target) );
          if(success==1)
            Target->addConn( linkfac->makeLink(Target,Source) );
            
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
          Source->addConn( linkfac->makeLink(Source,Target) );
            
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
#include "NodeAsList_class.pde.hpp"

/**
* @brief Node implementation based on hash map.
* @internal "https://docs->oracle->com/javase/6/docs/api/java/util/HashMap.html"
*/
#include "NodeAsMap_class.pde.hpp"

//*////////////////////////////////////////////////////////////////////////////
//*  https://www->researchgate->net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS 
//*  - FUNCTIONS & CLASSES  - NETWORKS TOOLBOX
//*  https://github->com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////
//MADE NOTE: /data/wb/SCC/public/Processing2C/scripts did it 2024-10-21 19:06:46 !

