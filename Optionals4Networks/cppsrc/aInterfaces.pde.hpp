/// Common INTERFACES like `iNamed`, iDescribable, iColorable, iPositioned. ("aInterfaces.pde")
/// @date 2024-10-21 (last modification)                       @author borkowsk
/// @note General interfaces for "optional" modules could be typically just linked from "Optionals/"
//*/////////////////////////////////////////////////////////////////////////////////////////////////

//* USE virtual  &  =0 for interchangeable function 
//* if you need translate the code into C++ (--> Processing2C )

/// @defgroup Generally usable interfaces
/// @{
//*//////////////////////////////////////
  
/** @brief Interface forces getter for single int. */
//interface
class iIntValue: public virtual Object{
  public:
  virtual  int                  get() =0;
} ;//_EofCl  
  
/** @brief Interface forces getter for single float. */
//interface
class iFloatValue: public virtual Object{
  public:
  virtual  float                get() =0;
} ;//_EofCl

//interface
class iIntPair: public virtual Object{
  public:
  virtual  int                 get1() =0;
  virtual  int                 get2() =0;
} ;//_EofCl

//interface
class iFloatPair: public virtual Object{
  public:
  virtual  float               get1() =0;
  virtual  float               get2() =0;
} ;//_EofCl

/** @brief Interface forces getters for X & Y ... */
//interface
class iFloatPoint2D: public virtual Object{
  public:
  virtual  float               getX() =0;
  virtual  float               getY() =0;
} ;//_EofCl

/** @brief Interface forces getter for Z and also what is derived from base class. */

//_endOfSuperClass; // Now will change of superclass!
//Base class is now:
#define _superclass _
//_derivedClass:iFloatPoint3D

//interface
class iFloatPoint3D : public virtual  iFloatPoint2D , public virtual Object{
  public:
 virtual  float                getZ() =0;
} ;//_EofCl

/** @brief Interface forces getters for T ("time") and also what is derived from base class. */

//_endOfSuperClass; // Now will change of superclass!
//Base class is now:
#define _superclass _
//_derivedClass:iFloatPoint4D

//interface
class iFloatPoint4D : public virtual  iFloatPoint3D , public virtual Object{
  public:
 virtual  float                getT() =0;
} ;//_EofCl

/** @brief Interface for any true referable class usable as a flag or switch.
*   @details Neither the type `Boolean` nor `boolean` can
*            in Processing and JAVA be passed by reference!
*            Hence the need for user types that can work like this->  */
//interface
class iFlag: public virtual Object{
  public:
  virtual  bool           isEnabled() =0;
} ;//_EofCl

/** @brief interface to set of flag identified by binary masks */
//interface
class iOptionsSet: public virtual Object{
  public:
  virtual  bool      isOption(int mask) =0; //!< It checks the options according to masks.
} ;//_EofCl

/** @brief It forces name of an object available as `String` (planty of usage). */
//interface
class iNamed: public virtual Object{
  public:
  virtual  String           getName() =0;
  virtual  String              name() =0;
} ;//_EofCl

/** @brief Any object which have description as (maybe) long, multi line string. */
//interface
class iDescribable: public virtual Object{
  public:
  virtual  String    getDescription() =0;
  virtual  String       description() =0;
} ;//_EofCl

/** @brief Any object which can go back to initial state without additional parameters */
//interface
class iResettable: public virtual Object{
  public:
  virtual  void               reset() =0;
} ;//_EofCl

/** @brief Any simulation agent */

//_endOfSuperClass; // Now will change of superclass!
//Base class is now:
#define _superclass _
//_derivedClass:iAgent

//interface
class iAgent : public virtual  iNamed, public virtual  iDescribable , public virtual Object{
  public:
  /// Derived methods:
  ///  *  `_interfunc String           getName() =0;`
  ///  *  `_interfunc String              name() =0;`
  ///  *  `_interfunc String    getDescription() =0;`
  ///  *  `_interfunc String       description() =0;`
  virtual  int        getIntAttribute(String attrName ) =0;
  virtual  float    getFloatAttribute(String attrName ) =0;
  virtual  String  getStringAttribute(String attrName ) =0;
  virtual  String      printableState() =0;
} ;//_EofCl

/** @brief Model time measuring interface */
//interface
class iModelTimer: public virtual Object{
  public:
  virtual  float                getCurrentStep() =0; //!< On some models the step number may sometimes increase by fractions!
  virtual  float                getCurrentTime() =0; //!< Step count and simulated time may not be in a straight relationship.
  virtual  float                getLastStepTime() =0;
  virtual  float                getMeanStepTime() =0;
} ;//_EofCl

// VISUALISATION INTERFACES:
//*//////////////////////////

/** @brief Forcing remembering full color inside object. */
//interface
class iColor: public virtual Object{
  public:
  virtual  void   setColor(color fullColor) =0;
  virtual  color  getColor() =0;
} ;//_EofCl iColor

/** @brief Forcing `applyFill` & `applyStroke` methods for visualisation. */
//interface
class iColorizer: public virtual Object{
  public:
  virtual  void   applyFill(float intensity) =0;
  virtual  void applyStroke(float intensity) =0;
} ;//_EofCl iColorable

/** @brief Mapping float value into color. */
//interface
class iColorMapper: public virtual Object{
  public:
  virtual  void setMinValue(float value) =0;
  virtual  void setMaxValue(float value) =0;
  virtual  color        map(float value) =0;
} ;//_EofCl iColorMapper

/** @brief Forcing `posX()` & `posY()` & `posZ()` methods for visualisation and mapping. */ 

//_endOfSuperClass; // Now will change of superclass!
//Base class is now:
#define _superclass _
//_derivedClass:iPositioned

//interface
class iPositioned : public virtual  iFloatPoint3D , public virtual Object{
  public:
  virtual  float       posX() =0;
  virtual  float       posY() =0;
  virtual  float       posZ() =0;
} ;//_EofCl iPositioned

// SPECIFIC FOR MATH INTERFACES:
//*/////////////////////////////

//const float INF_NOT_EXIST=FLT_MAX;  ///< Missing value marker

/** @brief A function of one value in the form of a class - a functor. */
//interface
class iFloatFunction1D: public virtual Object{
  public:
  virtual  float     calculate(float X) =0;
  virtual  float        getMin() =0; //!< MIN_RANGE_VALUE?
  virtual  float        getMax() =0; //!< Always must be different!
} ;//_EofCl

/** @brief A function of two values in the form of a class - a functor. */
//interface
class iFloatFunction2D: public virtual Object{
  public:
  virtual  float     calculate(float X,float Y) =0;
  virtual  float        getMin() =0; //!< MIN_RANGE_VALUE?
  virtual  float        getMax() =0; //!< Always must be different!
} ;//_EofCl

/** @brief Interface of any class witch can take a float value for any processing. */
//interface
class iFloatConsiderer: public virtual Object{
  public:
    virtual  void     consider(float value) =0; //!< It takes another value and updates results.
}  ;//_EofCl

/** @brief Interface of any class witch can take a float value connected with int label for any processing. */
//interface
class iIndexedFloatConsiderer: public virtual Object{
  public:
   virtual  void      consider(int label,float value) =0; //!< It takes another pair and updates results.
}  ;//_EofCl

/** @brief Interface of any class witch can take a float value connected with int label for any processing. */
//interface
class i2IndexedFloatConsiderer: public virtual Object{
  public:
   virtual  void      consider(int label1,int label2,float value) =0; //!< It takes another triplet and updates results.
}  ;//_EofCl

/** @brief Any range spanned from `Min` to `Max`. */

//_endOfSuperClass; // Now will change of superclass!
//Base class is now:
#define _superclass _
//_derivedClass:iFloatRange

//interface
class iFloatRange : public virtual  iFloatConsiderer , public virtual Object{
  public:
///  *  `_interfunc void      consider(float value) =0;` -- Derived: It takes another value and updates range if needed.
  virtual  float       getMin() =0; //MIN_RANGE_VALUE?
  virtual  float       getMax() =0; //MAX_RANGE_VALUE?
} ;//_EofCl

/** @brief Ane range with associated value, e->g->MARKED RANGE. */

//_endOfSuperClass; // Now will change of superclass!
//Base class is now:
#define _superclass _
//_derivedClass:iFloatRangeWithValue

//interface
class iFloatRangeWithValue : public virtual  iFloatRange, public virtual  iFloatValue , public virtual Object{
  public:
  /// Derived methods:
  ///  *  `_interfunc void      consider(float value) =0;` //!< It takes another value and updates range if needed.
  ///  *  `_interfunc float       getMin() =0; -- MIN_RANGE_VALUE?`
  ///  *  `_interfunc float       getMax() =0; -- MAX_RANGE_VALUE?`
  virtual  float          get() =0; //!< value related to the range
} ;//_EofCl

/** @brief Any linear (indexed) container of floats. */  

//_endOfSuperClass; // Now will change of superclass!
//Base class is now:
#define _superclass _
//_derivedClass:iFloatValuesIndexedContainer

//interface
class iFloatValuesIndexedContainer : public virtual  iResettable , public virtual Object{
  public:
  virtual  int   numOfElements() =0; //!< Series length->Together with empty cells, i->e. == INVALID_INDEX.
  virtual  int            size() =0; //!< Series length->Together with empty cells, i->e. == INVALID_INDEX.
  virtual  float  getElementAt(int index) =0; //!< Value at particular index->May return INF_NOT_EXIST.
  virtual  float           get(int index) =0; //!< Value at particular index->May return INF_NOT_EXIST.
  virtual  void      replaceAt(int index,float value) =0;
} ;//_EofCl

/** @brief Any rectangular (2*int indexed) container of floats. */

//_endOfSuperClass; // Now will change of superclass!
//Base class is now:
#define _superclass _
//_derivedClass:iFloatValues2IndexedContainer

//interface
class iFloatValues2IndexedContainer : public virtual  iResettable , public virtual Object{
  public:
  ///  *  `_interfunc int   numOfElements() =0;` -- Series length=whole size->Together with empty cells, i->e. == INVALID_INDEX.
  ///  *  `_interfunc int            size() =0;` -- Series length=whole size->Together with empty cells, i->e. == INVALID_INDEX.
  ///  *  `_interfunc float  getElementAt(int index) =0;` -- Value at particular index->May return INF_NOT_EXIST.
  ///  *  `_interfunc float           get(int index) =0;` -- Value at particular index->May return INF_NOT_EXIST.
  virtual  int       numOfRows() =0; //!< Number of rows in such a virtual matrix
  virtual  int            rows() =0; //!< Number of rows in such a virtual matrix
  virtual  int    numOfColumns() =0; //!< Number of columns in such a virtual matrix
  virtual  int         columns() =0; //!< Number of columns in such a virtual matrix
  virtual  float  getElementAt(int indexR,int indexC) =0; //!< Value at particular index->May return INF_NOT_EXIST.
  virtual  float           get(int indexR,int indexC) =0; //!< Value at particular index->May return INF_NOT_EXIST.
  virtual  void      replaceAt(int indexR,int indexC,float value) =0;
} ;//_EofCl

/** @brief Interface of a linear sample of data with min...max statics and set of options. */

//_endOfSuperClass; // Now will change of superclass!
//Base class is now:
#define _superclass _
//_derivedClass:iDataSample

//interface
class iDataSample : public virtual  iFloatValuesIndexedContainer, public virtual  iFloatConsiderer, public virtual  iFloatRange, public virtual  iOptionsSet , public virtual Object{
  public:
  ///   *  `_interfunc void      consider(float value) =0;` -- It takes another value and updates range if needed.
  virtual  int        whereMin() =0; //!< ADDED
  virtual  int        whereMax() =0; //!< ADDED
} ;//_EofCl

/** @brief Interface of 2D sample of data (ex. 2D histogram data, map of simulation cells etc... ). */

//_endOfSuperClass; // Now will change of superclass!
//Base class is now:
#define _superclass _
//_derivedClass:i2DDataSample

//interface
class i2DDataSample  : public virtual  iFloatValues2IndexedContainer, public virtual  i2IndexedFloatConsiderer, public virtual  iFloatRange, public virtual  iOptionsSet , public virtual Object{
  public:
  virtual  piIntPair   whereMin() =0; //!< ADDED
  virtual  piIntPair   whereMax() =0; //!< ADDED
  virtual  void       consider(int indexR,int indexC,float value) =0; //!< It takes another triplet and updates results.
} ;//_EofCl

/** @brief Interface for any linear (indexed) container of Range(s). */

//_endOfSuperClass; // Now will change of superclass!
//Base class is now:
#define _superclass _
//_derivedClass:iFloatRangesWithValueContainer

//interface
class iFloatRangesWithValueContainer : public virtual  iResettable , public virtual Object{
  public:
  virtual  int                  numOfElements() =0; //!< Container size->Together with empty cells, i->e. == INVALID_INDEX.
  virtual  int                           size() =0; //!< Container size->Together with empty cells, i->e. == INVALID_INDEX.
  virtual  piFloatRangeWithValue  getElementAt(int index) =0; //!< Value at particular index->May return nullptr.
  virtual  piFloatRangeWithValue           get(int index) =0; //!< Value at particular index->May return nullptr.
  virtual  void                     replaceAt(int index,piFloatRangeWithValue range) =0;
} ;//_EofCl

/** @brief Interface of any class witch can take a `rangeWithValue` for any processing */
//interface
class iRangeWithValueConsiderer: public virtual Object{
  public:
virtual  void         consider(piFloatRangeWithValue range) =0; //!< It takes and use another range.
} ;//_EofCl

/** @brief Interface for sample of ranges data. */

//_endOfSuperClass; // Now will change of superclass!
//Base class is now:
#define _superclass _
//_derivedClass:iRangesDataSample

//interface
class iRangesDataSample : public virtual  iFloatRangesWithValueContainer, public virtual  iRangeWithValueConsiderer , public virtual Object{
  public:
  ///*  `_interfunc void                 consider(piFloatRangeWithValue range) =0;` -- Derived: It takes and use another range.
  virtual  int       whereMin() =0; //!< ADDED
  virtual  int       whereMax() =0; //!< ADDED

} ;//_EofCl

/** Statistics of raw data samples. */
//interface
class iBasicStatistics: public virtual Object{
  public:
  virtual  float       getMean() =0; //!< Access to the current average.
  virtual  float   getHarmMean() =0; //!< Calculation of current harmonic mean.
  virtual  float   getQuadMean() =0; //!< Calculation of current mean square.
 
  /// @brief Calculation of current average with arbitrary powers.
  /// @note  It can be both a fraction and a number greater than 2, e->g. 1/3 or 3.
  virtual  float    getPowMean(float power) =0; //!< @param 'power' is the given averaging power.
  
  /// @brief Calculation of standard deviation.
  virtual  float     getStdDev() =0;
   
  /// @brief Calculates the median of the entire data series.
  /// @note  Requires copying and sorting,
  ///        so it can be very computationally expensive.
  virtual  float     getMedian() =0;  
    
} ;//_EofCl

/** Statistics for counters data sets. */
//interface
class iFreqStatistics: public virtual Object{
  public:
  /// @brief It calculates "Gini coefficient".
  /// @details Difference algorithm from "https://en->wikipedia.org/wiki/Gini_coefficient"
  /// @note It requires copying to the table because there may be missing values in the list.
  virtual  float getGiniCoefficient() =0;
  
    
  /// @details In information theory, the entropy of a random variable is the average level of 
  ///         "information", "surprise", or "uncertainty" inherent to the variable's possible outcomes.
  ///         See: https://en->wikipedia->org/wiki/Entropy_(information_theory)
  virtual  float getShannonEntropy() =0;
} ;//_EofCl

//*/////////////////////////////////////////////////////////////////////////////
//*  -> "https://www->researchgate.net/profile/WOJCIECH_BORKOWSKI" 
//*   - OPTIONAL TOOLS: FUNCTIONS & CLASSES
//*  -> "https://github.com/borkowsk/sym4processing"
/// @}
//*/////////////////////////////////////////////////////////////////////////////
//MADE NOTE: /data/wb/SCC/public/Processing2C/scripts did it 2024-10-21 21:30:14 !

