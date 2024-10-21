/// Network Only Interfaces. ("aNetInterfaces.pde")
/// @date 2024-10-21 (last modification)
//*/////////////////////////////////////////////////////////////////////////////

/// @details
///   INTERFACES:
///   ===========
///   - `interface iLink`
///   - `interface iNode`
///

/** @brief Network connection/link interface. */
//interface
class iLink: public virtual Object{
  public:
  virtual  float     getWeight() =0;
  virtual  int   getTypeMarker() =0;
  virtual  piNode     getTarget() =0;
  virtual  void      setTarget(piNode tar) =0;
} ; //_EndOfClass_


/** @brief Interface for any filter for links. */
//interface
class iLinkFilter: public virtual Object{
  public:
  virtual  bool    meetsTheAssumptions(piLink l)=0;
} ; //_EndOfClass_


/**
* @brief Network node interface.
*        "Conn" below is a shortage from "connection".
* @note Somewhere may uses class Link not interface iLink because of efficiency!
*/

//_endOfSuperClass; // Now will change of superclass!
//Base class is now:
#define _superclass _
//_derivedClass:iNode

//interface
class iNode : public virtual  iNamed , public virtual Object{
  public:
  virtual  int      numOfConn()         =0;
  virtual  int        addConn(piLink  l) =0;
  virtual  int        delConn(piLink  l) =0;

  virtual  piLink      getConn(int    i) =0;
  virtual  piLink      getConn(piNode  n) =0;
  virtual  piLink      getConn(String k) =0;
  virtual  sarray<piLink>    getConns(piLinkFilter f) =0;
} ; //_EndOfClass_


/** @brief Visualisable network node. */

//_endOfSuperClass; // Now will change of superclass!
//Base class is now:
#define _superclass _
//_derivedClass:iVisNode

//interface
class iVisNode : public virtual  iNode,iNamed,iColorizer,iPositioned , public virtual Object{
  public:
  /// @brief It provides default color.
  virtual  color     defColor() =0;
} ; //_EndOfClass_


/** @brief Visualisable network connection. */

//_endOfSuperClass; // Now will change of superclass!
//Base class is now:
#define _superclass _
//_derivedClass:iVisLink

//interface
class  iVisLink : public virtual  iLink,iNamed,iColorizer , public virtual Object{
  public:
  virtual  color     defColor() =0;
  virtual  piVisNode  getVisTarget() =0;
} ; //_EndOfClass_


/** @brief Any factory producing links. */
//interface
class iLinkFactory: public virtual Object{
  public:
  virtual  piLink  makeLink(piNode Source,piNode Target) =0;
  virtual  piLink  makeSelfLink(piNode Self) =0;     
} ; //_EndOfClass_


//*////////////////////////////////////////////////////////////////////////////
//*  https://www->researchgate->net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS 
//*  - FUNCTIONS & CLASSES  - NETWORKS INTERFACES
//*  https://github->com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////
//MADE NOTE: /data/wb/SCC/public/Processing2C/scripts did it 2024-10-21 21:30:14 !

