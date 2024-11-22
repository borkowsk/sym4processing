/// Example of the function that allows to construct the window menu in the setup. ( "rtmMenu.pde" )
/// @note Unfortunately, this breaks the calculation of the built-in variable `height` in Processing!
/// @date 2024-11-22 (Last modification)
/// @note This file shoud be COPIED into the project directory and modified when needed.
//-//////////////////////////////////////////////////////////////////////////////////////////////////

/// @defgroup Generally usable classes & functions
/// @{
//-///////////////////////////////////////////////

import java.awt.MenuBar;
import java.awt.Menu;
import java.awt.MenuItem;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import processing.awt.PSurfaceAWT;

MenuBar myMenu;  ///< Handle to menu. 
               
/// A function that constructs an example menu.
/// Processig does not see the height of MenuBar added to Window!
void setupMenu() ///< Configure menu
{
  myMenu = new MenuBar();
  
  Menu fileMenu = new Menu("File");
  myMenu.add(fileMenu);
  
  MenuItem closeItem=new MenuItem("Close");
  closeItem.addActionListener(new ActionListener() {
        public void actionPerformed(ActionEvent ev) {
                exit(); //Local exit function
            }
          } 
        );
  fileMenu.add(closeItem);
  
  PSurfaceAWT awtSurface = (PSurfaceAWT)surface;
  PSurfaceAWT.SmoothCanvas smoothCanvas = (PSurfaceAWT.SmoothCanvas)awtSurface.getNative();
  smoothCanvas.getFrame().setMenuBar(myMenu);
}

//*/////////////////////////////////////////////////////////////////////////////
//*  https://www.researchgate.net/profile/WOJCIECH_BORKOWSKI - OPTIONAL TOOLS 
//*  - FUNCTIONS & CLASSES
//*  https://github.com/borkowsk/sym4processing
/// @}
//*/////////////////////////////////////////////////////////////////////////////

 
