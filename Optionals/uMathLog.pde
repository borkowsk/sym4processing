/// Handy logarithms and around. ("uMathLog.pde")
/// @date 2024-10-21 (last modification)
//*////////////////////////////////////////////////////

/// @defgroup General math tools and functions
/// @{
//*///////////////////////////////////////////

// /// Calculates the base-10 logarithm of a number.
// float log10 (float x)  ///< @note GLOBAL
// {
//   return (log(x) / log(10));
// }

// /// Calculates the base-2 logarithm of a number. Needed also in uStatData for entropy calculation.
// float log2(float x)  ///< @note GLOBAL
// {
//   return (log(x) / log(2));
// }

/// Calculates the base-2 logarithm of a number with double precision.
double log2 (double x)   ///< @note GLOBAL
{
  return (Math.log(x) / Math.log(2)); //Math.log2(x); 
}

/// Calculates the base-10 logarithm of a number with double precision.
double log10 (double x)   ///< @note GLOBAL
{
  return  Math.log10(x);//  (Math.log(x) / Math.log(10));
}

//*/////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS 
//*  - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
/// @}
//*/////////////////////////////////////////////////////////////////////////////
