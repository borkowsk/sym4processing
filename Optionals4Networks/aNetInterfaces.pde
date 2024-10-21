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
interface iLink
{
  /*_interfunc*/ float     getWeight() /*_forcebody*/;
  /*_interfunc*/ int   getTypeMarker() /*_forcebody*/;
  /*_interfunc*/ iNode     getTarget() /*_forcebody*/;
  /*_interfunc*/ void      setTarget(iNode tar) /*_forcebody*/;
} //_EndOfClass 

/** @brief Interface for any filter for links. */
interface iLinkFilter
{
  /*_interfunc*/ boolean meetsTheAssumptions(iLink l)/*_forcebody*/;
} //_EndOfClass

/**
* @brief Network node interface.
*        "Conn" below is a shortage from "connection".
* @note Somewhere may uses class Link not interface iLink because of efficiency!
*/
interface iNode extends iNamed
{
  /*_interfunc*/ int      numOfConn()         /*_forcebody*/;
  /*_interfunc*/ int        addConn(iLink  l) /*_forcebody*/;
  /*_interfunc*/ int        delConn(iLink  l) /*_forcebody*/;

  /*_interfunc*/ iLink      getConn(int    i) /*_forcebody*/;
  /*_interfunc*/ iLink      getConn(iNode  n) /*_forcebody*/;
  /*_interfunc*/ iLink      getConn(String k) /*_forcebody*/;
  /*_interfunc*/ iLink[]    getConns(iLinkFilter f) /*_forcebody*/;
} //_EndOfClass

/** @brief Visualisable network node. */
interface iVisNode extends iNode,iNamed,iColorizer,iPositioned
{
  /// @brief It provides default color.
  /*_interfunc*/ color     defColor() /*_forcebody*/;
} //_EndOfClass

/** @brief Visualisable network connection. */
interface  iVisLink extends iLink,iNamed,iColorizer
{
  /*_interfunc*/ color     defColor() /*_forcebody*/;
  /*_interfunc*/ iVisNode  getVisTarget() /*_forcebody*/;
} //_EndOfClass

/** @brief Any factory producing links. */
interface  iLinkFactory
{
  /*_interfunc*/ iLink  makeLink(iNode Source,iNode Target) /*_forcebody*/;
  /*_interfunc*/ iLink  makeSelfLink(iNode Self) /*_forcebody*/;     
} //_EndOfClass

//*////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS 
//*  - FUNCTIONS & CLASSES  - NETWORKS INTERFACES
//*  https://github.com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////
