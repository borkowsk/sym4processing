/// ANSI terminal ESC directives. "uScreen.pde" (alias "uANSI.pde").
/// Code sequences that change the text display color.
/// @date 2025-03-17 (last modification) 
//*/////////////////////////////////////////////////////////////////////

/// @defgroup Terminal colors
/// @{

/// @details   
///     ANSI-compliant terminals have a rich pool of escape sequences starting
///     with the ESC character (\033 is an octal representation of ESC).
///     They allow you to control colors and other properties of the terminal.
///
/// ## Resources:
///
/// *   Base: "https://en.wikipedia.org/wiki/ANSI_escape_code"
/// *   Discussions: "https://stackoverflow.com/questions/2616906/how-do-i-output-coloured-text-to-a-linux-terminal"
///
/// ## In C++:
///
/// *   You can use "https://github.com/fengwang/colorize", but it looks like it has a lot of work to do "at run time".
/// *   The fmt library ("https://github.com/fmtlib/fmt") is also great, but it is too extensive for this application at the moment.
///
///     Created: 2023-05-25 by W.Borkowski
///
/// @note Processing IDE console is not ANSI compatible, at least in version 3.x!!!


String COLOR7="\033[37m"; ///< GRAY? BLACK?
String COLOR6="\033[36m"; ///< CYAN
String COLOR5="\033[35m"; ///< MAGENTA
String COLOR4="\033[34m"; ///< BLUE
String COLOR3="\033[33m"; ///< YELLOW
String COLOR2="\033[32m"; ///< GREEN
String COLOR1="\033[31m"; ///< RED
String COLOR0="\033[30m"; ///< DARK
String COLFIL=COLOR4;     ///< FILL IN BLUE
String COLERR="\033[31m"; ///< RED
String ERCOLO="\033[31m"; ///< RED
String NOCOLO="\033[0m";  ///< Default
String NORMCO="\033[0m";  ///< Back to default(s)?


/// @brief Make color string empty, when terminal color not needed or not works.
/// @note  Processing IDE console is not ANSI compatible, at least in version 3.x.
void cleanColors() ///< GLOBAL!
{
   COLOR1=COLOR2=COLOR3=COLOR4=COLOR5=COLOR6=COLOR7="";
   COLFIL="";
   ERCOLO=COLERR="";
   NOCOLO=NORMCO="";
}


//*/////////////////////////////////////////////////////////////////////////////
//*  -> "https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI" 
//*   - OPTIONAL TOOLS: FUNCTIONS & CLASSES
//*  -> "https://github.com/borkowsk/sym4processing"
/// @}
//*/////////////////////////////////////////////////////////////////////////////
