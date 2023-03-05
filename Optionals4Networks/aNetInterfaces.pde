/// Network Only Interfaces
//*///////////////////////////////////////////

// NETWORK INTERFACES:
/////////////////////////////////////////////////////////////////////////////////

/// Network connection/link interface
/// Is iLink interface really needed?
interface iLink { 
  /*_interfunc*/ float getWeight()/*_forcbody*/;
  /*_interfunc*/ int   getTypeMarker()/*_forcbody*/;
}//EndOfClass

interface iLinkFilter
{
  /*_interfunc*/ boolean meetsTheAssumptions(iLink l)/*_forcbody*/;
}//EndOfClass

/// Network node interface
/// "Conn" below is a shortage from Connection.
interface iNode extends iNamed { 
  //using class Link not interface iLink because of efficiency!
  /*_interfunc*/ int      addConn(iLink  l)/*_forcbody*/;
  /*_interfunc*/ int      delConn(iLink  l)/*_forcbody*/;
  /*_interfunc*/ int      numOfConn()      /*_forcbody*/;
  /*_interfunc*/ iLink    getConn(int    i)/*_forcbody*/;
  /*_interfunc*/ iLink    getConn(iNode  n)/*_forcbody*/;
  /*_interfunc*/ iLink    getConn(String k)/*_forcbody*/;
  /*_interfunc*/ iLink[]  getConns(iLinkFilter f)/*_forcbody*/;
}//EndOfClass

/// Visualisable network node
interface iVisNode extends iNode,iNamed,iColorable,iPositioned {
}//EndOfClass

/// Visualisable network connection
interface  iVisLink extends iLink,iNamed,iColorable {
  /*_interfunc*/ color     defColor()/*_forcebody*/;
}//EndOfClass

//*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//*  Last modification 2022.03.16
//*  See: "https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI" - NETWORKS INTERFACES
//*///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
