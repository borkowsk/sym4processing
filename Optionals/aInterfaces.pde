/// @file
/// @brief Common INTERFACES like iNamed, iDescribable, iColorable, iPositioned ("aInterfaces.pde")
/// @date 2024-08-08 (last modification)                       @author borkowsk
/// @details ...
//*////////////////////////////////////////////////////////////////////////////////////////////////

//* USE /*_interfunc*/ &  /*_forcebody*/ for interchangeable function 
//* if you need translate the code into C++ (--> Processing2C )

// Generally usable interfaces:
//*////////////////////////////

/** @brief Interface forces getter for single float */
interface iValue {
  /*_interfunc*/ float     get() /*_forcebody*/;
} //_EofCl

/** @brief Interface forces getters for X & Y */
interface iPoint2D {
  /*_interfunc*/ float     getX() /*_forcebody*/;
  /*_interfunc*/ float     getY() /*_forcebody*/;
} //_EofCl

/** @brief Interface forces getters for X & Y & Z */
interface iPoint3D extends iPoint2D {
 /*_interfunc*/ float      getZ() /*_forcebody*/;
} //_EofCl

/** @brief Interface for any true referable class usable as a flag or switch.
*   @details Neither the type `Boolean` nor `boolean` can
*            in Processing and JAVA be passed by reference!
*            Hence the need for user types that can work like this.  */
interface iFlag {
  /*_interfunc*/ boolean   isEnabled() /*_forcebody*/;
} //_EofCl

/** @brief It forces name of an object available as `String` (planty of usage). */
interface iNamed {
  /*_interfunc*/ String    getName() /*_forcebody*/;
  /*_interfunc*/ String       name() /*_forcebody*/;
} //_EofCl

/** @brief Any object which have description as (maybe) long, multi line string. */
interface iDescribable { 
  /*_interfunc*/ String    getDescription() /*_forcebody*/;
  /*_interfunc*/ String       description() /*_forcebody*/;
} //_EofCl

/** @brief Any object which can go back to initial state without additional parameters */
interface iResetable {
  /*_interfunc*/ void reset() /*_forcebody*/;
} //_EofCl

/** @brief Any simulation agent */
interface iAgent extends iNamed,iDescribable {
} //_EofCl

/// VISUALISATION INTERFACES:
//*//////////////////////////

/** @brief Forcing remembering full color inside object */
interface iColor {
  /*_interfunc*/ void   setColor(color fullColor) /*_forcebody*/;
  /*_interfunc*/ color  getColor() /*_forcebody*/;
} //_EofCl iColor

/** @brief Forcing `applyFill` & `applyStroke` methods for visualisation */
interface iColorable { //TODO iColoriser
  /*_interfunc*/ void   applyFill(float intensity) /*_forcebody*/;
  /*_interfunc*/ void applyStroke(float intensity) /*_forcebody*/;
} //_EofCl iColorable

/** @brief Mapping float value into color. */
interface iColorMapper {
  /*_interfunc*/ color map(float value) /*_forcebody*/; 
} //_EofCl iColorMapper

/** @brief Forcing `posX()` & `posY()` & `posZ()` methods for visualisation and mapping */ 
interface iPositioned extends iPoint3D {              
  /*_interfunc*/ float    posX() /*_forcebody*/;
  /*_interfunc*/ float    posY() /*_forcebody*/;
  /*_interfunc*/ float    posZ() /*_forcebody*/;
} //_EofCl iPositioned

/// SPECIFICLY FOR MATH INTERFACES:
//*////////////////////////////////

//final float INF_NOT_EXIST=Float.MAX_VALUE;  ///< Missing value marker

/** @brief Any range spanned from `Min` to `Max` */
interface iRange {
  /*_interfunc*/ void      consider(float value) /*_forcebody*/; //!< It takes another value and updates range if needed.
  /*_interfunc*/ float       getMin() /*_forcebody*/; //MIN_RANGE_VALUE?
  /*_interfunc*/ float       getMax() /*_forcebody*/; //MAX_RANGE_VALUE?
} //_EofCl

/** @brief Ane range with associated value, e.g. MARKED RANGE */
interface iRangeWithValue extends iRange,iValue {
} //_EofCl

/** @brief A function of two values in the form of a class - a functor */
interface iFunction2D {
  /*_interfunc*/ float     calculate(float X,float Y) /*_forcebody*/;
  /*_interfunc*/ float        getMin() /*_forcebody*/; //!< MIN_RANGE_VALUE?
  /*_interfunc*/ float        getMax() /*_forcebody*/; //!< Always must be different!
} //_EofCl

/** @brief Any linear (indexed) container of floats */  
interface iValuesContainer extends iResetable {
  /*_interfunc*/ void       consider(float value) /*_forcebody*/; //!< It takes and use another value! May remember it or not!
  /*_interfunc*/ int   numOfElements() /*_forcebody*/; //!< Series length. Together with empty cells, i.e. == INVALID_INDEX.
  /*_interfunc*/ int            size() /*_forcebody*/; //!< Series length. Together with empty cells, i.e. == INVALID_INDEX.
  /*_interfunc*/ float  getElementAt(int index) /*_forcebody*/; //!< Value at particular index. May return INF_NOT_EXIST.
  /*_interfunc*/ float           get(int index) /*_forcebody*/; //!< Value at particular index. May return INF_NOT_EXIST.
  /*_interfunc*/ void      replaceAt(int index,float value) /*_forcebody*/;
} //_EofCl

/** @brief Any linear (indexed) container of Range(s) */
interface iRangesContainer extends iResetable {
  /*_interfunc*/ void                 consider(iRangeWithValue range) /*_forcebody*/; //!< It takes and use another range.
  /*_interfunc*/ int             numOfElements() /*_forcebody*/; //!< Container size. Together with empty cells, i.e. == INVALID_INDEX.
  /*_interfunc*/ int                      size() /*_forcebody*/; //!< Container size. Together with empty cells, i.e. == INVALID_INDEX.
  /*_interfunc*/ iRangeWithValue  getElementAt(int index) /*_forcebody*/; //!< Value at particular index. May return null.
  /*_interfunc*/ iRangeWithValue           get(int index) /*_forcebody*/; //!< Value at particular index. May return null.
  /*_interfunc*/ void                replaceAt(int index,iRangeWithValue range) /*_forcebody*/;
} //_EofCl

/** @brief A linear sample of data with min...max statics and set of options */
interface iDataSample extends iValuesContainer,iRange {
  /*_interfunc*/ boolean    isOption(int mask) /*_forcebody*/; //!< It checks the options according to masks.
  /*_interfunc*/ int        whereMin() /*_forcebody*/;
  /*_interfunc*/ int        whereMax() /*_forcebody*/;
} //_EofCl

interface iBasicStatistics {
  /*_interfunc*/ float       getMean() /*_forcebody*/; //!< Access to the current average.
  /*_interfunc*/ float   getHarmMean() /*_forcebody*/; //!< Calculation of current harmonic mean
  /*_interfunc*/ float   getQuadMean() /*_forcebody*/; //!< Calculation of current mean square
 
  /// @brief Calculation of current average with arbitrary powers.
  /// @note  It can be both a fraction and a number greater than 2, e.g. 1/3 or 3.
  /*_interfunc*/ float    getPowMean(float power) /*_forcebody*/; //!< @param 'power' is the given averaging power.
  
  /// @brief Calculation of standard deviation.
  /*_interfunc*/ float     getStdDev() /*_forcebody*/;
   
  /// @brief Calculates the median of the entire data series.
  /// @note  Requires copying and sorting,
  ///        so it can be very computationally expensive.
  /*_interfunc*/ float     getMedian() /*_forcebody*/;  
  
  /// @brief It calculates "Gini coefficient".
  /// @details Difference algorithm from "https://en.wikipedia.org/wiki/Gini_coefficient"
  /// @note It requires copying to the table because there may be missing values in the list.
  /*_interfunc*/ float getGiniCoefficient() /*_forcebody*/;
  
} //_EofCl

//*/////////////////////////////////////////////////////////////////////////////
//*  -> "https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI" 
//*   - OPTIONAL TOOLS: FUNCTIONS & CLASSES
//*  -> "https://github.com/borkowsk/sym4processing"
//*/////////////////////////////////////////////////////////////////////////////
