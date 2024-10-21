/// @file
/// @note Automatically made from _uNetVisual.pde_ by __Processing to C++__ converter (/data/wb/SCC/public/Processing2C/scripts/procesing2cpp.sh).
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
using namespace Processing;
#include "local.h" //???.
#include <iostream>
//================================================================

/// @file 
/// @brief Generic visualisations of a (social) network ("uNetVisual.pde")
/// @date 2024-09-03 (last modification)
//*/////////////////////////////////////////////////////////////////////////////

/// @details
///
///   CLASSES:
///   ========
///   - `class Visual2DNodeAsList : public  NodeAsList : public virtual iVisNode` 
///      -> Visualisable node based on `NodeAsList` core.
///   - `class Visual2DNodeAsMap : public  NodeAsMap : public virtual iVisNode` 
///      -> Visualisable node based on `NodeAsMap` core.
///
///   FUNCTIONS:
///   ==========
///   - `void visualiseLinks(sarray<piVisNode>   nodes,float defX,float defY,float cellside)`
///   - `void visualiseLinks(smatrix<piVisNode> nodes,float defX,float defY,float cellside)`
///

float XSPREAD=0.01;   ///< how far is target point of link of type 1, from center of the cell
int   linkCounter=0;  ///< number od=f links visualised last time

/**
* @brief Visualisable node based on `NodeAsList` core.
*        It : public virtual all things needed for visualisation.
*/
#include "Visual2DNodeAsList_class.pde.hpp"

/**
* @brief Visualisable node based on `NodeAsMap` core.
*        It : public virtual all things needed for visualisation.
*/
#include "Visual2DNodeAsMap_class.pde.hpp"


//   IMPLEMENTATIONS:
//*//////////////////


/// @brief Weight color scale visualisation.
/// @param textYoffset - TODO change name textYOffset
void visualiseWeightScale(pLink lnk,float defX,float defY,float width,float hei,float textYoffset) ///< @NOTE GLOBAL!
{
  textAlign(LEFT,TOP);   text("0.0",defX,        defY+textYoffset);
  textAlign(CENTER,TOP); text("0.5",defX+width/2,defY+textYoffset);
  textAlign(RIGHT,TOP);  text("1.0",defX+width,  defY+textYoffset);
  for(float w=1.0;w>=0.0;w-=0.01)
  {
    float pos=defX+w*width;
    lnk->applyStroke(w,LINK_INTENSITY);
    line(pos,defY,pos,defY+hei);
  }
}

/// One dimensional visualisation using arcs().
void visualiseLinks1D(sarray<piVisNode> nodes,pLinkFilter filter,float defX,float defY,float cellside,bool    intMode)  ///< @note Global namespace.
{ 
  noFill();strokeCap(ROUND); //<>//
  linkCounter=0;
  ellipseMode(CENTER);
  
  if(intMode) //Wystarczy raz! 
      defX+=0.5*cellside;
  
  int n=nodes->length;
  for(int i=0;i<n;i++)
  {
    piVisNode Source=nodes[i];
    
    if(Source!=nullptr)
    {
      float X=Source->posX(); 
      sarray<piVisLink> links=(sarray<piVisLink>)Source->getConns(filter);    assert(links!=nullptr);	//
      
      int m=links->length;
      for(int j=0;j<m;j++)
      {
        float Xt=links[j]->getVisTarget()->posX();
        //print(X,Xt,"; "); 
        float R= std::abs(Xt-X)*cellside;
        float C= (X+Xt) / 2;
        
        if(X<Xt) {
	 Xt+=links[j]->getTypeMarker()*XSPREAD;
	}
        else     {
	 Xt-=links[j]->getTypeMarker()*XSPREAD;
	}
        C*=cellside;
        
        links[j]->applyStroke(LINK_INTENSITY);
        
        arc(defX+C,defY,R,R,0,PI);
        stroke(255);
        point(defX+(Xt*cellside),defY);
        linkCounter++;
      }
    }
  }
}

/// Two dimensional visualisation using `arrows()`.
void visualiseLinks2D(sarray<piVisNode> nodes,pLinkFilter filter,float defX,float defY,float cellside,bool    intMode)  ///< @note Global namespace.
{
  noFill();strokeCap(ROUND);
  linkCounter=0;
  ellipseMode(CENTER);
  
  if(intMode) 
        defX+=0.5*cellside;
  if(intMode) 
        defY+=0.5*cellside;
  
  int N=nodes->length;
  for(int i=0;i<N;i++)
  {
    piVisNode Source=nodes[i];
    
    if(Source!=nullptr)
    {
      float X=Source->posX();
      float Y=Source->posY();                                       //circle(X,Y,1);
      sarray<piLink> links=Source->getConns(filter);                       assert(links!=nullptr);	//
      
      int l=links->length;
      for(int k=0;k<l;k++)
      {
        piVisLink k_link=(iVisLink)links[k];
        piVisNode k_node=(iVisNode)k_link->getTarget();
        float Xt=k_node->posX();                                   //strokeWeight(1);stroke(10);
        float Yt=k_node->posY();                                   //circle(Xt,Yt,k+1*2);
                                                  if(NET_DEBUG>4 && Source==links[k]->getTarget()) //Będzie kółko!
                                                        println(Source->name(),"-o-",links[k]->getTarget()->name());
                                                        
        if(X<Xt) {
	 Xt+=links[k]->getTypeMarker()*XSPREAD;
	}
        else    {
	 Xt-=links[k]->getTypeMarker()*XSPREAD;
	}
                                                  if(NET_DEBUG>1 && X==Xt && Y==Yt) //TEŻ będzie kółko!!!
                                                        println("Connection",Source.name(),"->-",links[k]->getTarget()->name(),"visualised as circle");
        k_link->applyStroke(LINK_INTENSITY); //<>//
        
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
void visualiseLinks(smatrix<piVisNode> nodes,pLinkFilter filter,float defX,float defY,float cellside,bool    intMode) ///< @note Global namespace.
{ 
  noFill();
  linkCounter=0;
  
  if(intMode) defX+=0.5*cellside; //WYSTARCZY DODAĆ RAZ!
  if(intMode) defY+=0.5*cellside; //W tym miejscu.
  
  for(int i=0;i<nodes->length;i++)
  for(int j=0;j<nodes[i]->length;j++)
  {
    piVisNode Source=nodes[i][j];
    
    if(Source!=nullptr)
    {
      float X=Source->posX();
      float Y=Source->posY();
      sarray<piVisLink> links=(sarray<piVisLink>)Source->getConns(filter);                  assert(links!=nullptr);	//
      int n=links->length;
      
      for(int k=0;k<n;k++)
      {
        piVisNode visTarget=links[k]->getVisTarget();
        float Xt=visTarget->posX();
        float Yt=visTarget->posY();

        if(X<Xt) {
	 Xt+=links[k]->getTypeMarker()*XSPREAD;
	}
        else    {
	 Xt-=links[k]->getTypeMarker()*XSPREAD;
	}
        
        links[k]->applyStroke(LINK_INTENSITY);
        arrow(defX+(X*cellside),defY+(Y*cellside),defX+(Xt*cellside),defY+(Yt*cellside));
        /*
        float midX=defX+( X*cellside + Xt*cellside )/2.0;
        float midY=defY+( Y*cellside + Yt*cellside )/2.0;
        stroke(255,0,0);
        line(defX+(X*cellside),defY+(Y*cellside),midX,midY);
        links[k]->setStroke(LINK_INTENSITY*0.77);
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
//*  https://www->researchgate->net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS 
//*  - FUNCTIONS & CLASSES  - NETWORKS TOOLBOX
//*  https://github->com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////
//MADE NOTE: /data/wb/SCC/public/Processing2C/scripts did it 2024-10-21 19:06:46 !

