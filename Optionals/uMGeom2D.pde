/// @file uMGeom2D.pde
/// Some 2D Geometry calculations: nearestPoints and so on.
/// @date 2023.02.28 (Last modification)
//*///////////////////////////////////////////////////////////

/// @note Required uPair &
///       Required pointxy from uGraphix.

/// Nearest points of two polygons.
/// @param listA - first polygon as a list of points
/// @param listB - second polygon as a list of points
Pair<pointxy,pointxy> nearestPoints(final pointxy[] listA,
                                    final pointxy[] listB )
{                                                         
                                    assert(listA.length>0);
                                    assert(listB.length>0);
  float mindist=MAX_FLOAT;
  int   minA=-1;
  int   minB=-1;
  for(int i=0;i<listA.length;i++)
    for(int j=0;j<listB.length;j++) //Pętla nadmiarowa (?)
    {
      float x2=(listA[i].x-listB[j].x)*(listA[i].x-listB[j].x);
      float y2=(listA[i].y-listB[j].y)*(listA[i].y-listB[j].y);
      
      if(x2+y2 < mindist)
      {
        mindist=x2+y2;
        minA=i; minB=j;
      }
    }
    
  return new Pair<pointxy,pointxy>(listA[minA],listB[minB]);
}

//*////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS 
//*  - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
//*////////////////////////////////////////////////////////////////////////////
