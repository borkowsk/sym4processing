/// @file
/// @brief Common INTERFACES like `iNamed`, iDescribable, iColorable, iPositioned ("aInterfaces.pde")
/// @date 2024-09-26 (last modification)                       @author borkowsk
/// @note General interfaces for "optional" modules could be typically just linked from "Optionals/"
//*/////////////////////////////////////////////////////////////////////////////////////////////////

//* USE /*_interfunc*/ &  /*_forcebody*/ for interchangeable function 
//* if you need translate the code into C++ (--> Processing2C )

/// @defgroup Generally usable interfaces
/// @{
//*//////////////////////////////////////
  
/** @brief Interface forces getter for single int. */
interface iIntValue {
  /*_interfunc*/ int                  get() /*_forcebody*/;
} //_EofCl  
  
/** @brief Interface forces getter for single float. */
interface iFloatValue {
  /*_interfunc*/ float                get() /*_forcebody*/;
} //_EofCl

interface iIntPair {
  /*_interfunc*/ int                 get1() /*_forcebody*/;
  /*_interfunc*/ int                 get2() /*_forcebody*/;
} //_EofCl

interface iFloatPair {
  /*_interfunc*/ float               get1() /*_forcebody*/;
  /*_interfunc*/ float               get2() /*_forcebody*/;
} //_EofCl

/** @brief Interface forces getters for X & Y ... */
interface iFloatPoint2D {
  /*_interfunc*/ float               getX() /*_forcebody*/;
  /*_interfunc*/ float               getY() /*_forcebody*/;
} //_EofCl

/** @brief Interface forces getter for Z and also what is derived from base class. */
interface iFloatPoint3D extends iFloatPoint2D {
 /*_interfunc*/ float                getZ() /*_forcebody*/;
} //_EofCl

/** @brief Interface forces getters for T ("time") and also what is derived from base class. */
interface iFloatPoint4D extends iFloatPoint3D {
 /*_interfunc*/ float                getT() /*_forcebody*/;
} //_EofCl

/** @brief Interface for any true referable class usable as a flag or switch.
*   @details Neither the type `Boolean` nor `boolean` can
*            in Processing and JAVA be passed by reference!
*            Hence the need for user types that can work like this.  */
interface iFlag {
  /*_interfunc*/ boolean        isEnabled() /*_forcebody*/;
} //_EofCl

/** @brief interface to set of flag identified by binary masks */
interface iOptionsSet {
  /*_interfunc*/ boolean   isOption(int mask) /*_forcebody*/; //!< It checks the options according to masks.
} //_EofCl

/** @brief It forces name of an object available as `String` (planty of usage). */
interface iNamed {
  /*_interfunc*/ String           getName() /*_forcebody*/;
  /*_interfunc*/ String              name() /*_forcebody*/;
} //_EofCl

/** @brief Any object which have description as (maybe) long, multi line string. */
interface iDescribable { 
  /*_interfunc*/ String    getDescription() /*_forcebody*/;
  /*_interfunc*/ String       description() /*_forcebody*/;
} //_EofCl

/** @brief Any object which can go back to initial state without additional parameters */
interface iResetable {
  /*_interfunc*/ void               reset() /*_forcebody*/;
} //_EofCl

/** @brief Any simulation agent */
interface iAgent extends iNamed, /*_pvi*/ iDescribable {
  /// Derived methods:
  ///  *  `_interfunc String           getName() /*_forcebody*/;`
  ///  *  `_interfunc String              name() /*_forcebody*/;`
  ///  *  `_interfunc String    getDescription() /*_forcebody*/;`
  ///  *  `_interfunc String       description() /*_forcebody*/;`
  /*_interfunc*/ int        getIntAttribute(String attrName ) /*_forcebody*/;
  /*_interfunc*/ float    getFloatAttribute(String attrName ) /*_forcebody*/;
  /*_interfunc*/ String  getStringAttribute(String attrName ) /*_forcebody*/;
} //_EofCl

/** @brief Model time measuring interface */
interface iModelTimer {
  /*_interfunc*/ float                getCurrentStep() /*_forcebody*/; //!< On some models the step number may sometimes increase by fractions!
  /*_interfunc*/ float                getCurrentTime() /*_forcebody*/; //!< Step count and simulated time may not be in a straight relationship.
  /*_interfunc*/ float                getLastStepTime() /*_forcebody*/;
  /*_interfunc*/ float                getMeanStepTime() /*_forcebody*/;
} //_EofCl

// VISUALISATION INTERFACES:
//*//////////////////////////

/** @brief Forcing remembering full color inside object. */
interface iColor {
  /*_interfunc*/ void   setColor(color fullColor) /*_forcebody*/;
  /*_interfunc*/ color  getColor() /*_forcebody*/;
} //_EofCl iColor

/** @brief Forcing `applyFill` & `applyStroke` methods for visualisation. */
interface iColorable { //TODO iColoriser
  /*_interfunc*/ void   applyFill(float intensity) /*_forcebody*/;
  /*_interfunc*/ void applyStroke(float intensity) /*_forcebody*/;
} //_EofCl iColorable

/** @brief Mapping float value into color. */
interface iColorMapper {
  /*_interfunc*/ void setMinValue(float value) /*_forcebody*/;
  /*_interfunc*/ void setMaxValue(float value) /*_forcebody*/;
  /*_interfunc*/ color        map(float value) /*_forcebody*/;
} //_EofCl iColorMapper

/** @brief Forcing `posX()` & `posY()` & `posZ()` methods for visualisation and mapping. */ 
interface iPositioned extends iFloatPoint3D {              
  /*_interfunc*/ float       posX() /*_forcebody*/;
  /*_interfunc*/ float       posY() /*_forcebody*/;
  /*_interfunc*/ float       posZ() /*_forcebody*/;
} //_EofCl iPositioned

// SPECIFICLY FOR MATH INTERFACES:
//*///////////////////////////////

//final float INF_NOT_EXIST=Float.MAX_VALUE;  ///< Missing value marker

/** @brief A function of one value in the form of a class - a functor. */
interface iFloatFunction1D {
  /*_interfunc*/ float     calculate(float X) /*_forcebody*/;
  /*_interfunc*/ float        getMin() /*_forcebody*/; //!< MIN_RANGE_VALUE?
  /*_interfunc*/ float        getMax() /*_forcebody*/; //!< Always must be different!
} //_EofCl

/** @brief A function of two values in the form of a class - a functor. */
interface iFloatFunction2D {
  /*_interfunc*/ float     calculate(float X,float Y) /*_forcebody*/;
  /*_interfunc*/ float        getMin() /*_forcebody*/; //!< MIN_RANGE_VALUE?
  /*_interfunc*/ float        getMax() /*_forcebody*/; //!< Always must be different!
} //_EofCl

/** @brief Interface of any class witch can take a float value for any processing. */
interface iFloatConsiderer {
    /*_interfunc*/ void     consider(float value) /*_forcebody*/; //!< It takes another value and updates results.
}  //_EofCl

/** @brief Interface of any class witch can take a float value connected with int label for any processing. */
interface iIndexedFloatConsiderer {
   /*_interfunc*/ void      consider(int label,float value) /*_forcebody*/; //!< It takes another pair and updates results.
}  //_EofCl

/** @brief Interface of any class witch can take a float value connected with int label for any processing. */
interface i2IndexedFloatConsiderer {
   /*_interfunc*/ void      consider(int label1,int label2,float value) /*_forcebody*/; //!< It takes another triplet and updates results.
}  //_EofCl

/** @brief Any range spanned from `Min` to `Max`. */
interface iFloatRange extends iFloatConsiderer {
///  *  `_interfunc void      consider(float value) /*_forcebody*/;` -- Derived: It takes another value and updates range if needed.
  /*_interfunc*/ float       getMin() /*_forcebody*/; //MIN_RANGE_VALUE?
  /*_interfunc*/ float       getMax() /*_forcebody*/; //MAX_RANGE_VALUE?
} //_EofCl

/** @brief Ane range with associated value, e.g. MARKED RANGE. */
interface iFloatRangeWithValue extends iFloatRange, /*_pvi*/ iFloatValue {
  /// Derived methods:
  ///  *  `_interfunc void      consider(float value) /*_forcebody*/;` //!< It takes another value and updates range if needed.
  ///  *  `_interfunc float       getMin() /*_forcebody*/; -- MIN_RANGE_VALUE?`
  ///  *  `_interfunc float       getMax() /*_forcebody*/; -- MAX_RANGE_VALUE?`
  /*_interfunc*/ float          get() /*_forcebody*/; //!< value releated to the range
} //_EofCl

/** @brief Any linear (indexed) container of floats. */  
interface iFloatValuesIndexedContainer extends iResetable {
  /*_interfunc*/ int   numOfElements() /*_forcebody*/; //!< Series length. Together with empty cells, i.e. == INVALID_INDEX.
  /*_interfunc*/ int            size() /*_forcebody*/; //!< Series length. Together with empty cells, i.e. == INVALID_INDEX.
  /*_interfunc*/ float  getElementAt(int index) /*_forcebody*/; //!< Value at particular index. May return INF_NOT_EXIST.
  /*_interfunc*/ float           get(int index) /*_forcebody*/; //!< Value at particular index. May return INF_NOT_EXIST.
  /*_interfunc*/ void      replaceAt(int index,float value) /*_forcebody*/;
} //_EofCl

/** @brief Any recangular (2*int indexed) container of floats. */  
interface iFloatValues2IndexedContainer extends iResetable {
  ///  *  `_interfunc int   numOfElements() /*_forcebody*/;` -- Series length=whole size. Together with empty cells, i.e. == INVALID_INDEX.
  ///  *  `_interfunc int            size() /*_forcebody*/;` -- Series length=whole size. Together with empty cells, i.e. == INVALID_INDEX.
  ///  *  `_interfunc float  getElementAt(int index) /*_forcebody*/;` -- Value at particular index. May return INF_NOT_EXIST.
  ///  *  `_interfunc float           get(int index) /*_forcebody*/;` -- Value at particular index. May return INF_NOT_EXIST.
  /*_interfunc*/ int       numOfRows() /*_forcebody*/; //!< Number of rows in such a virtual matrix
  /*_interfunc*/ int            rows() /*_forcebody*/; //!< Number of rows in such a virtual matrix
  /*_interfunc*/ int    numOfColumns() /*_forcebody*/; //!< Number of columns in such a virtual matrix
  /*_interfunc*/ int         columns() /*_forcebody*/; //!< Number of columns in such a virtual matrix
  /*_interfunc*/ float  getElementAt(int indexR,int indexC) /*_forcebody*/; //!< Value at particular index. May return INF_NOT_EXIST.
  /*_interfunc*/ float           get(int indexR,int indexC) /*_forcebody*/; //!< Value at particular index. May return INF_NOT_EXIST.
  /*_interfunc*/ void      replaceAt(int indexR,int indexC,float value) /*_forcebody*/;
} //_EofCl

/** @brief Interface of a linear sample of data with min...max statics and set of options. */
interface iDataSample extends iFloatValuesIndexedContainer, /*_pvi*/ iFloatConsiderer, /*_pvi*/ iFloatRange, /*_pvi*/ iOptionsSet {
  ///   *  `_interfunc void      consider(float value) /*_forcebody*/;` -- It takes another value and updates range if needed.
  /*_interfunc*/ int        whereMin() /*_forcebody*/; //!< ADDED
  /*_interfunc*/ int        whereMax() /*_forcebody*/; //!< ADDED
} //_EofCl

/** @brief Interface of 2D sample of data (ex. 2D histogram data, map of simulation cells etc... ). */
interface i2DDataSample  extends iFloatValues2IndexedContainer, /*_pvi*/ i2IndexedFloatConsiderer, /*_pvi*/ iFloatRange, /*_pvi*/ iOptionsSet {
  /*_interfunc*/ iIntPair   whereMin() /*_forcebody*/; //!< ADDED
  /*_interfunc*/ iIntPair   whereMax() /*_forcebody*/; //!< ADDED
  /*_interfunc*/ void       consider(int indexR,int indexC,float value) /*_forcebody*/; //!< It takes another triplet and updates results.
} //_EofCl

/** @brief Interface for any linear (indexed) container of Range(s). */
interface iFloatRangesWithValueContainer extends iResetable {
  /*_interfunc*/ int                  numOfElements() /*_forcebody*/; //!< Container size. Together with empty cells, i.e. == INVALID_INDEX.
  /*_interfunc*/ int                           size() /*_forcebody*/; //!< Container size. Together with empty cells, i.e. == INVALID_INDEX.
  /*_interfunc*/ iFloatRangeWithValue  getElementAt(int index) /*_forcebody*/; //!< Value at particular index. May return null.
  /*_interfunc*/ iFloatRangeWithValue           get(int index) /*_forcebody*/; //!< Value at particular index. May return null.
  /*_interfunc*/ void                     replaceAt(int index,iFloatRangeWithValue range) /*_forcebody*/;
} //_EofCl

/** @brief Interface of any class witch can take a `rangeWithValue` for any processing */
interface iRangeWithValueConsiderer {
/*_interfunc*/ void         consider(iFloatRangeWithValue range) /*_forcebody*/; //!< It takes and use another range.
} //_EofCl

/** @brief Interface for sample of ranges data. */
interface iRangesDataSample extends iFloatRangesWithValueContainer, /*_pvi*/ iRangeWithValueConsiderer {
  ///*  `_interfunc void                 consider(iFloatRangeWithValue range) /*_forcebody*/;` -- Derived: It takes and use another range.
  /*_interfunc*/ int       whereMin() /*_forcebody*/; //!< ADDED
  /*_interfunc*/ int       whereMax() /*_forcebody*/; //!< ADDED

} //_EofCl

/** Statistics of raw data samples. */
interface iBasicStatistics {
  /*_interfunc*/ float       getMean() /*_forcebody*/; //!< Access to the current average.
  /*_interfunc*/ float   getHarmMean() /*_forcebody*/; //!< Calculation of current harmonic mean.
  /*_interfunc*/ float   getQuadMean() /*_forcebody*/; //!< Calculation of current mean square.
 
  /// @brief Calculation of current average with arbitrary powers.
  /// @note  It can be both a fraction and a number greater than 2, e.g. 1/3 or 3.
  /*_interfunc*/ float    getPowMean(float power) /*_forcebody*/; //!< @param 'power' is the given averaging power.
  
  /// @brief Calculation of standard deviation.
  /*_interfunc*/ float     getStdDev() /*_forcebody*/;
   
  /// @brief Calculates the median of the entire data series.
  /// @note  Requires copying and sorting,
  ///        so it can be very computationally expensive.
  /*_interfunc*/ float     getMedian() /*_forcebody*/;  
    
} //_EofCl

/** Statistics for counters data sets. */
interface iFreqStatistics {
  /// @brief It calculates "Gini coefficient".
  /// @details Difference algorithm from "https://en.wikipedia.org/wiki/Gini_coefficient"
  /// @note It requires copying to the table because there may be missing values in the list.
  /*_interfunc*/ float getGiniCoefficient() /*_forcebody*/;
  
    
  /// @details In information theory, the entropy of a random variable is the average level of 
  ///         "information", "surprise", or "uncertainty" inherent to the variable's possible outcomes.
  ///         See: https://en.wikipedia.org/wiki/Entropy_(information_theory)
  /*_interfunc*/ float getShannonEntropy() /*_forcebody*/;
} //_EofCl

//*/////////////////////////////////////////////////////////////////////////////
//*  -> "https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI" 
//*   - OPTIONAL TOOLS: FUNCTIONS & CLASSES
//*  -> "https://github.com/borkowsk/sym4processing"
/// @}
//*/////////////////////////////////////////////////////////////////////////////
