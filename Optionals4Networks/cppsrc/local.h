//Automagically generated file. @date 2024-10-21 21:30:14 
//Dont edit\!
#pragma once
#ifndef LOCAL_H
#define LOCAL_H



//All classes but not templates from Processing files
/*abstract*/class Colorable; typedef Processing::ptr<Colorable> pColorable; // extends Named implements iColorizer {
/*abstract*/class LinkFactory; typedef Processing::ptr<LinkFactory> pLinkFactory; // implements iLinkFactory {
/*abstract*/class LinkFilter; typedef Processing::ptr<LinkFilter> pLinkFilter; // implements iLinkFilter {
/*abstract*/class Named; typedef Processing::ptr<Named> pNamed; // implements iNamed {    
/*abstract*/class Node; typedef Processing::ptr<Node> pNode; // extends Positioned implements iNode {
/*abstract*/class Positioned; typedef Processing::ptr<Positioned> pPositioned; // extends Colorable implements iPositioned {
/*interface*/class i2DDataSample; typedef Processing::ptr<i2DDataSample> pi2DDataSample; // extends iFloatValues2IndexedContainer, /*_pvi*/ i2IndexedFloatConsiderer, /*_pvi*/ iFloatRange, /*_pvi*/ iOptionsSet {
/*interface*/class i2IndexedFloatConsiderer; typedef Processing::ptr<i2IndexedFloatConsiderer> pi2IndexedFloatConsiderer; //
/*interface*/class iAgent; typedef Processing::ptr<iAgent> piAgent; // extends iNamed, /*_pvi*/ iDescribable
/*interface*/class iBasicStatistics; typedef Processing::ptr<iBasicStatistics> piBasicStatistics; //
/*interface*/class iColor; typedef Processing::ptr<iColor> piColor; //
/*interface*/class iColorMapper; typedef Processing::ptr<iColorMapper> piColorMapper; //
/*interface*/class iColorizer; typedef Processing::ptr<iColorizer> piColorizer; //
/*interface*/class iDataSample; typedef Processing::ptr<iDataSample> piDataSample; // extends iFloatValuesIndexedContainer, /*_pvi*/ iFloatConsiderer, /*_pvi*/ iFloatRange, /*_pvi*/ iOptionsSet
/*interface*/class iDescribable; typedef Processing::ptr<iDescribable> piDescribable; //
/*interface*/class iFlag; typedef Processing::ptr<iFlag> piFlag; //
/*interface*/class iFloatConsiderer; typedef Processing::ptr<iFloatConsiderer> piFloatConsiderer; //
/*interface*/class iFloatFunction1D; typedef Processing::ptr<iFloatFunction1D> piFloatFunction1D; //
/*interface*/class iFloatFunction2D; typedef Processing::ptr<iFloatFunction2D> piFloatFunction2D; //
/*interface*/class iFloatPair; typedef Processing::ptr<iFloatPair> piFloatPair; //
/*interface*/class iFloatPoint2D; typedef Processing::ptr<iFloatPoint2D> piFloatPoint2D; //
/*interface*/class iFloatPoint3D; typedef Processing::ptr<iFloatPoint3D> piFloatPoint3D; // extends iFloatPoint2D
/*interface*/class iFloatPoint4D; typedef Processing::ptr<iFloatPoint4D> piFloatPoint4D; // extends iFloatPoint3D
/*interface*/class iFloatRange; typedef Processing::ptr<iFloatRange> piFloatRange; // extends iFloatConsiderer
/*interface*/class iFloatRangeWithValue; typedef Processing::ptr<iFloatRangeWithValue> piFloatRangeWithValue; // extends iFloatRange, /*_pvi*/ iFloatValue
/*interface*/class iFloatRangesWithValueContainer; typedef Processing::ptr<iFloatRangesWithValueContainer> piFloatRangesWithValueContainer; // extends iResettable
/*interface*/class iFloatValue; typedef Processing::ptr<iFloatValue> piFloatValue; //
/*interface*/class iFloatValues2IndexedContainer; typedef Processing::ptr<iFloatValues2IndexedContainer> piFloatValues2IndexedContainer; // extends iResettable
/*interface*/class iFloatValuesIndexedContainer; typedef Processing::ptr<iFloatValuesIndexedContainer> piFloatValuesIndexedContainer; // extends iResettable
/*interface*/class iFreqStatistics; typedef Processing::ptr<iFreqStatistics> piFreqStatistics; //
/*interface*/class iIndexedFloatConsiderer; typedef Processing::ptr<iIndexedFloatConsiderer> piIndexedFloatConsiderer; //
/*interface*/class iIntPair; typedef Processing::ptr<iIntPair> piIntPair; //
/*interface*/class iIntValue; typedef Processing::ptr<iIntValue> piIntValue; //
/*interface*/class iLink; typedef Processing::ptr<iLink> piLink; //
/*interface*/class iLinkFactory; typedef Processing::ptr<iLinkFactory> piLinkFactory; //
/*interface*/class iLinkFilter; typedef Processing::ptr<iLinkFilter> piLinkFilter; //
/*interface*/class iModelTimer; typedef Processing::ptr<iModelTimer> piModelTimer; //
/*interface*/class iNamed; typedef Processing::ptr<iNamed> piNamed; //
/*interface*/class iNode; typedef Processing::ptr<iNode> piNode; // extends iNamed
/*interface*/class iOptionsSet; typedef Processing::ptr<iOptionsSet> piOptionsSet; //
/*interface*/class iPositioned; typedef Processing::ptr<iPositioned> piPositioned; // extends iFloatPoint3D
/*interface*/class iRangeWithValueConsiderer; typedef Processing::ptr<iRangeWithValueConsiderer> piRangeWithValueConsiderer; //
/*interface*/class iRangesDataSample; typedef Processing::ptr<iRangesDataSample> piRangesDataSample; // extends iFloatRangesWithValueContainer, /*_pvi*/ iRangeWithValueConsiderer
/*interface*/class iResettable; typedef Processing::ptr<iResettable> piResettable; //
/*interface*/class iVisLink; typedef Processing::ptr<iVisLink> piVisLink; // extends iLink,iNamed,iColorizer
/*interface*/class iVisNode; typedef Processing::ptr<iVisNode> piVisNode; // extends iNode,iNamed,iColorizer,iPositioned
class AbsHighPassFilter; typedef Processing::ptr<AbsHighPassFilter> pAbsHighPassFilter; // extends LinkFilter
class AbsLowPassFilter; typedef Processing::ptr<AbsLowPassFilter> pAbsLowPassFilter; // extends LinkFilter
class AllLinks; typedef Processing::ptr<AllLinks> pAllLinks; // extends LinkFilter
class AndFilter; typedef Processing::ptr<AndFilter> pAndFilter; // extends LinkFilter
class BasicLinkFactory; typedef Processing::ptr<BasicLinkFactory> pBasicLinkFactory; // extends LinkFactory
class HighPassFilter; typedef Processing::ptr<HighPassFilter> pHighPassFilter; // extends LinkFilter
class Link; typedef Processing::ptr<Link> pLink; // extends Colorable implements iLink,iVisLink,Comparable<Link> {
class LowPassFilter; typedef Processing::ptr<LowPassFilter> pLowPassFilter; // extends LinkFilter
class NodeAsList; typedef Processing::ptr<NodeAsList> pNodeAsList; // extends Node implements iVisNode {
class NodeAsMap; typedef Processing::ptr<NodeAsMap> pNodeAsMap; // extends Node implements iVisNode { 
class OrFilter; typedef Processing::ptr<OrFilter> pOrFilter; // extends LinkFilter
class TypeAndAbsHighPassFilter; typedef Processing::ptr<TypeAndAbsHighPassFilter> pTypeAndAbsHighPassFilter; // extends LinkFilter
class TypeFilter; typedef Processing::ptr<TypeFilter> pTypeFilter; // extends LinkFilter
class Visual2DNodeAsList; typedef Processing::ptr<Visual2DNodeAsList> pVisual2DNodeAsList; // extends NodeAsList implements iVisNode
class Visual2DNodeAsMap; typedef Processing::ptr<Visual2DNodeAsMap> pVisual2DNodeAsMap; // extends NodeAsMap implements iVisNode
class pointXY; typedef Processing::ptr<pointXY> ppointXY; //
class randomWeightLinkFactory; typedef Processing::ptr<randomWeightLinkFactory> prandomWeightLinkFactory; // implements iLinkFactory
class settings_bar3d; typedef Processing::ptr<settings_bar3d> psettings_bar3d; //

//All global finals (consts) from Processing files
static 	const int	DEBUG_LEVEL=0;		// -> General DEBUG level.
static 	const int	NET_DEBUG=1;		// -> DEBUG level for network.
static 	const int	LINK_INTENSITY=128;   // -> For network visualisation.
static 	const float  MAX_LINK_WEIGHT=1.0;  // -> Also for network visualisation.
static 	const int	MASK_BITS=0xffffffff; // -> Redefine, when smaller width is required.

//All global variables from Processing files
extern	float 		BALDHEAD_MUN_ANGLE;	// ->  Baldhead drawing GLOBAL parameter.
extern	float 		BALDHEAD_NOSE_DIVIDER;	// ->  Baldhead drawing GLOBAL parameter.
extern	float 		BALDHEAD_NOSE_RADIUS;	// ->  Baldhead nose-length as ratio of maximal R
extern	float 		BALDHEAD_EARS_DIVIDER;	// ->  Baldhead drawing GLOBAL parameter.
extern	float 		BALDHEAD_EYES_RADIUS;	// ->  Baldhead eyes size as ratio of maximal R
extern	float 		BALDHEAD_PUPIL_RADIUS;	// ->  Baldhead pupil size as ratio of maximal R
extern	color 		BALDHEAD_EYES_COLOR;	// ->  Baldhead drawing GLOBAL parameter.
extern	float 		BALDHEAD_PUPIL_DIV;	// ->  Baldhead drawing GLOBAL parameter.
extern	int   		BALDHEAD_HAIRS_DENS;	// ->  Baldhead - How many hairs
extern	float 		BALDHEAD_HAIRS_START;	// ->  Range 0..0.5
extern	float 		BALDHEAD_HAIRS_END;	// ->  Range BALDHEAD_HAIRS_START..0.99
extern	color 		BALDHEAD_HAIRS_COLOR;	// ->  As you wish. It is used in `stroke()` function.
extern	float 		def_arrow_size;	// ->  Default size of arrows heads
extern	float 		def_arrow_theta;	// -> 3.6651914291881
extern	psettings_bar3d 		bar_3D_settings;	// ->  Default settings of bar3d
extern	float 		linksXSpread;	// ->  how far is target point of link of type 1, from center of the cell.
extern	int   		linksCounter;	// ->  number od=f links visualised last time.

//All global arrays from Processing files
extern	sarray<pVisual2DNodeAsList>  AllNodes;    // ->  Nodes have to be visualisable!!!
extern	sarray<ppointXY> bar_3D_romb ;	// ->  @note Global namespace!

//All global matrices from Processing files

// _extern marked clauses
extern const pAllLinks allLinks; // =>  Wymuszenie globalnej deklaracji zapowiadającej w Processing2C++

//All global functions from Processing files
void 	makeRingNet(sarray<piNode> nodes,piLinkFactory linkFact,int neighborhood);  // => Global namespace.
void 	makeTorusNet(sarray<piNode> nodes,piLinkFactory links,int neighborhood);  // => Global namespace.
void 	makeTorusNet(smatrix<piNode> nodes,piLinkFactory linkFact,int neighborhood);  // => Global namespace.
void 	rewireLinksRandomly(sarray<piNode> nodes,float probability, bool reciprocal);  // => Global namespace.
void 	rewireLinksRandomly(smatrix<piNode> nodes,float probability, bool reciprocal);  // => Global namespace.
void 	makeSmWorldNet(sarray<piNode> nodes,piLinkFactory links,int neighborhood,float probability, bool reciprocal);  // => Global namespace.
void 	makeSmWorldNet(smatrix<piNode> nodes,piLinkFactory links,int neighborhood,float probability, bool reciprocal);  // => Global namespace.
void 	makeImSmWorldNet(smatrix<piNode> nodes,piLinkFactory links,int neighborhood,float probability, bool reciprocal);  // => Global namespace.
void 	makeImSmWorldNet(sarray<piNode> nodes,piLinkFactory links,int neighborhood,float probability, bool reciprocal);  // => Global namespace.
void 	makeScaleFree(sarray<piNode> nodes,piLinkFactory linkFact,int sizeOfFirstCluster,int numberOfNewLinkPerNode, bool reciprocal);  // => Global namespace.
void 	makeFullNet(sarray<piNode> nodes,piLinkFactory linkFact);  // => Global namespace.
void 	makeFullNet(smatrix<piNode> nodes,piLinkFactory linkFact);  // => Global namespace.
void 	makeRandomNet(sarray<piNode> nodes,piLinkFactory linkFact,float probability, bool reciprocal);  // => Global namespace.
void 	makeOrphansAdoption(sarray<piNode> nodes,piLinkFactory linkFact, bool reciprocal);  // => Global namespace.
void 	makeRandomNet(smatrix<piNode> nodes,piLinkFactory linkFact,float probability, bool reciprocal);  // => Global namespace.
void 	baldhead_hor(float x,float y,float r,float direction);  // => @note Global namespace!
void 	agave_ver(float x,float y,float visual_size,float num_of_leafs);  // => @note Global namespace!
void 	agave_hor(float x,float y,float visual_size,float num_of_leafs);  // => @note Global namespace!
void 	gas_bottle_droid_ver(float x,float y,float visual_size,float direction);  // => @note Global namespace!
void 	arrow(float x1,float y1,float x2,float y2);  // => @note Global namespace!
void 	arrow_d(int x1,int y1,int x2,int y2,float size,float theta);  // => @note Global namespace!
void 	surround(int x1,int y1,int x2,int y2);  // => @note Global namespace!.
void 	cross(float x,float y,float cross_width);  // => @note Global namespace!
void 	cross(int x,int y,int cross_width);  // => @note Global namespace!
void 	regular_poly(float x, float y, float radius, int nPoints);  // => @note Global namespace!
void 	polygon(sarray<ppointXY> lst/*+1*/);  // => @note Global namespace!
void 	polygon(sarray<ppointXY> lst/*+1*/,int N);  // => @note Global namespace!
void 	bar3dRGB(float x,float y,float h,int R,int G,int B,int Shad);  // => @note Global namespace!
void 	visualiseWeightScale(pLink lnk,float defX,float defY,float width,float hei,float textYoffset);  // => @NOTE GLOBAL!
void 	visualiseLinks1D(sarray<piVisNode> nodes,pLinkFilter filter,float defX,float defY,float cellSide,bool intMode);  // => @note Global namespace.
void 	visualiseLinks2D(sarray<piVisNode> nodes,pLinkFilter filter,float defX,float defY,float cellSide,bool intMode);  // => @note Global namespace.
void 	visualiseLinks(smatrix<piVisNode> nodes,pLinkFilter filter,float defX,float defY,float cellSide,bool intMode);  // => @note Global namespace.
#endif
