/// @file
#pragma once
/// @date 2024-10-21 (last modification)                       @author borkowsk
#ifndef HEADER_iColorMapper_INCLUDED
#define HEADER_iColorMapper_INCLUDED

/** @brief Mapping float value into color. */

/// @note Automatically extracted definition of `class`: iColorMapper
//interface
class iColorMapper: public virtual Object{
  public:

  virtual  void setMinValue(float value) =0;
  virtual  void setMaxValue(float value) =0;
  virtual  color        map(float value) =0;
} ;//_EofCl iColorMapper

/// Generated by Processing2C++ extraction Tools
#endif //HEADER_iColorMapper_INCLUDED

//MADE NOTE: /data/wb/SCC/public/Processing2C/scripts did it 2024-10-21 19:06:46 !
