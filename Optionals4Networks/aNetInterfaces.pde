/// @file aNetInterfaces.pde
/// @date 2023.03.04 (Last modification)
/// @brief Network Only Interfaces.
//*/////////////////////////////////////////////////////////////////////////////
/// @details
///   INTERFACES:
///   ===========
///   - `interface iLink`
///   - `interface iNode`
///

/// Network connection/link interface.
/// Is iLink interface really needed?
interface iLink { 
  /*_interfunc*/ float getWeight()/*_forcbody*/;
  /*_interfunc*/ int   getTypeMarker()/*_forcbody*/;
  /*_interfunc*/ iNode getTarget()/*_forcbody*/;
  /*_interfunc*/ void  setTarget(iNode tar)/*_forcbody*/;
}//EndOfClass

/// Interface for any filter for links.
interface iLinkFilter
{
  /*_interfunc*/ boolean meetsTheAssumptions(iLink l)/*_forcbody*/;
}//EndOfClass

/// Network node interface.
/// "Conn" below is a shortage from Connection.
/// @note Somewhere may uses class Link not interface iLink because of efficiency!
interface iNode extends iNamed { 
  /*_interfunc*/ int      addConn(iLink  l)/*_forcbody*/;
  /*_interfunc*/ int      delConn(iLink  l)/*_forcbody*/;
  /*_interfunc*/ int      numOfConn()      /*_forcbody*/;
  /*_interfunc*/ iLink    getConn(int    i)/*_forcbody*/;
  /*_interfunc*/ iLink    getConn(iNode  n)/*_forcbody*/;
  /*_interfunc*/ iLink    getConn(String k)/*_forcbody*/;
  /*_interfunc*/ iLink[]  getConns(iLinkFilter f)/*_forcbody*/;
}//EndOfClass

/// Visualisable network node.
interface iVisNode extends iNode,iNamed,iColorable,iPositioned {
}//EndOfClass

/// Visualisable network connection.
interface  iVisLink extends iLink,iNamed,iColorable {
  /*_interfunc*/ color     defColor()/*_forcebody*/;
  /*_interfunc*/ iVisNode  getVisTarget()/*_forcbody*/;
}//EndOfClass

/// Any factory producing links.
interface  iLinkFactory {
  /*_interfunc*/ iLink  makeLink(iNode Source,iNode Target)/*_forcebody*/;
  /*_interfunc*/ iLink  makeSelfLink(iNode Self)/*_forcebody*/;     
}//EndOfClass

//*////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS 
//*  - FUNCTIONS & CLASSES  - NETWORKS INTERFACES
//*  https://github.com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////
