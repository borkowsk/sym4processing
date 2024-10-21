# This file was made automagically. Do not edit!
#! @date 2024-10-21 19:06:46 (translation timemark)
cmake_minimum_required(VERSION 3.5)
set( CMAKE_VERBOSE_MAKEFILE off )

project( Optionals4Networks_M )
set( VERSION_NUM 0.22j ) #MUST BE NUMERIC 

IF (WIN32)
  # set stuff for windows
  message( ${PROJECT_NAME} ": MS Windows platform assumed.\n\tInside C/C++ code automatic _MSC_VER variable will be used!" )
  #set( WINDOWS_ONLY_SRC  "" )
ELSE()
  # set stuff for other systems
  message( ${PROJECT_NAME} ": Linux/unix platform assumed." )
  #set( X_ONLY_SRC  "" )
ENDIF()

set( SRCPATH  "./" )
set( PROC2C   "/data/wb/SCC/public/Processing2C" )
set( SYMSHELL "/data/wb/SCC/public/SymShellLight" )
set( WBRTM    "" )

set( MYLIBS   "/lib" )

# THESE LINES BELOW COULD BE UNCOMMENTED WHEN LIBRARIES SEEMS TO BE NOT COMPILED.
#add_subdirectory( "${SYMSHELL}"
#                  "${SYMSHELL}" )
#add_subdirectory( "${PROC2C}/lib/"
#                  "${PROC2C}/lib/" )

add_definitions( -DVERSION_NUM=${VERSION_NUM} ) # -DMULTITR -DDEF_MAXTHREADS=16 

include_directories(  "${SRCPATH}" "${PROC2C}/lib/include" "${SYMSHELL}" "${WBRTM}/INCLUDE" )

set(  SRCCODESLIST 
	"AbsHighPassFilter_class.pde.hpp"
	"AbsLowPassFilter_class.pde.hpp"
	"aInterfaces.pde.cpp"
	"AllLinks_class.pde.hpp"
	"AndFilter_class.pde.hpp"
	"aNetInterfaces.pde.cpp"
	"aNetwork.pde.cpp"
	"basicLinkFactory_class.pde.hpp"
	"Colorable_class.pde.hpp"
	"HighPassFilter_class.pde.hpp"
	"i2DDataSample_class.pde.hpp"
	"i2IndexedFloatConsiderer_class.pde.hpp"
	"iAgent_class.pde.hpp"
	"iBasicStatistics_class.pde.hpp"
	"iColorable_class.pde.hpp"
	"iColor_class.pde.hpp"
	"iColorMapper_class.pde.hpp"
	"iDataSample_class.pde.hpp"
	"iDescribable_class.pde.hpp"
	"iFlag_class.pde.hpp"
	"iFloatConsiderer_class.pde.hpp"
	"iFloatFunction1D_class.pde.hpp"
	"iFloatFunction2D_class.pde.hpp"
	"iFloatPair_class.pde.hpp"
	"iFloatPoint2D_class.pde.hpp"
	"iFloatPoint3D_class.pde.hpp"
	"iFloatPoint4D_class.pde.hpp"
	"iFloatRange_class.pde.hpp"
	"iFloatRangesWithValueContainer_class.pde.hpp"
	"iFloatRangeWithValue_class.pde.hpp"
	"iFloatValue_class.pde.hpp"
	"iFloatValues2IndexedContainer_class.pde.hpp"
	"iFloatValuesIndexedContainer_class.pde.hpp"
	"iFreqStatistics_class.pde.hpp"
	"iIndexedFloatConsiderer_class.pde.hpp"
	"iIntPair_class.pde.hpp"
	"iIntValue_class.pde.hpp"
	"iLink_class.pde.hpp"
	"iLinkFactory_class.pde.hpp"
	"iLinkFilter_class.pde.hpp"
	"iModelTimer_class.pde.hpp"
	"iNamed_class.pde.hpp"
	"iNode_class.pde.hpp"
	"iOptionsSet_class.pde.hpp"
	"iPositioned_class.pde.hpp"
	"iRangesDataSample_class.pde.hpp"
	"iRangeWithValueConsiderer_class.pde.hpp"
	"iResetable_class.pde.hpp"
	"iVisLink_class.pde.hpp"
	"iVisNode_class.pde.hpp"
	"Link_class.pde.hpp"
	"LinkFactory_class.pde.hpp"
	"LinkFilter_class.pde.hpp"
	"LowPassFilter_class.pde.hpp"
	"Named_class.pde.hpp"
	"NodeAsList_class.pde.hpp"
	"NodeAsMap_class.pde.hpp"
	"Node_class.pde.hpp"
	"Optionals4Networks.pde.cpp"
	"OrFilter_class.pde.hpp"
	"pointxy_class.pde.hpp"
	"Positioned_class.pde.hpp"
	"randomWeightLinkFactory_class.pde.hpp"
	"settings_bar3d_class.pde.hpp"
	"TypeAndAbsHighPassFilter_class.pde.hpp"
	"TypeFilter_class.pde.hpp"
	"uFigures.pde.cpp"
	"uGraphix.pde.cpp"
	"uNetVisual.pde.cpp"
	"uNLinkFactories.pde.cpp"
	"uNLinkFilters.pde.cpp"
	"Visual2DNodeAsList_class.pde.hpp"
	"Visual2DNodeAsMap_class.pde.hpp"
        )
        
add_executable("${PROJECT_NAME}_${VERSION_NUM}_x11"
               "${SRCCODESLIST}"
              )

add_executable("${PROJECT_NAME}_${VERSION_NUM}_svg"
               "${SRCCODESLIST}"
              )

target_compile_options( "${PROJECT_NAME}_${VERSION_NUM}_x11" PRIVATE "${CMAKE_CXX_FLAGS}" "-w" "-std=c++14" "-pthread" )
target_link_libraries( "${PROJECT_NAME}_${VERSION_NUM}_x11"  
     "-L${PROC2C}/lib"
     "-L${SYMSHELL}"
     wbprocess wbsyshLight X11 Xpm
     ${CMAKE_THREAD_LIBS_INIT}
     pthread
     rt
     )

target_compile_options( "${PROJECT_NAME}_${VERSION_NUM}_svg" PRIVATE "${CMAKE_CXX_FLAGS}" "-w" "-std=c++14" "-pthread" "-O3" )
target_link_libraries( "${PROJECT_NAME}_${VERSION_NUM}_svg"  
     "-L${PROC2C}/lib"
     "-L${SYMSHELL}"
     wbprocess wbsyshLightSVG
     ${CMAKE_THREAD_LIBS_INIT}
     pthread
     rt
     )

