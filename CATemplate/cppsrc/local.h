//Automagically generated file. @date 2024-10-20 19:47:09 
//Dont edit\!
#pragma once
#ifndef LOCAL_H
#define LOCAL_H



//All classes but not templates from Processing files
class PairOfInt; typedef Processing::ptr<PairOfInt> pPairOfInt; //
class World; typedef Processing::ptr<World> pWorld; //

//All global finals (consts) from Processing files

//All global variables from Processing files
extern	int 		StepCounter;	// ->  Global variable for caunting real simulation steps.
extern	String   		modelName;	// ->  Name of the model is used for log files
extern	int      		side;	// ->  side of "world" main table
extern	float    		density;	// ->  initial density of live cells
extern	bool  		synchronicMode;	// ->  if false, then Monte Carlo mode is used
extern	pWorld 		TheWorld;	// -> Main table will be initialised inside setup()
extern	int 		cwidth;	// ->  requested size of cell
extern	int 		STATUSHEIGH;	// ->  height of status bar
extern	int 		STEPSperVIS;	// ->  how many model steps beetwen visualisations 
extern	int 		FRAMEFREQ;	// ->  how many model steps per second
extern	bool 		WITH_VIDEO;	// ->  Need the application make a movie?
extern	bool 		simulationRun;	// ->  Start/stop flag
extern	PrintWriter 		outstat; // ->  Handle to the text file with the record of model statistics.
extern	float 		meanDummy;	// ->  the average of the non-zero cell values
extern	int   		liveCount;	// ->  number of non-zero cells
extern	int 		searchedX;	// ->  The horizontal coordinate of the mouse cursor.
extern	int 		searchedY;	// ->  The vertical coordinate of the mouse cursor.
extern	bool 		Clicked;	// ->  Was there a click too?
extern	int 		selectedX;	// ->  Converted into "world" indices, the agent's horizontal coordinate.
extern	int 		selectedY;	// ->  Converted into "world" indices, the agent's vertical coordinate.
extern	String 		copyrightNote;	// ->  Change it to your copyright. Best in setup().

//All global arrays from Processing files

//All global matrices from Processing files

//All global functions from Processing files
void 	initializeModel(pWorld world);  // => GLOBAL!
void 	visualizeModel(pWorld world);  // => GLOBAL!
void 	exampleChange(pWorld world);  // => GLOBAL!
void 	realChange(pWorld world);  // => GLOBAL!
void 	modelStep(pWorld world);  // => GLOBAL!
void 	initializeCells(smatrix<int> cells);  // => GLOBAL!
void 	initializeCells(sarray<int> cells);  // => GLOBAL!
void 	synchChangeCellsModulo(smatrix<int> cells,smatrix<int> newcells);  // => GLOBAL!
void 	synchChangeCellsModulo(sarray<int> cells,sarray<int> newcells);  // => GLOBAL!
void  	asyncChangeCellsModulo(smatrix<int> cells);  // => GLOBAL!
void  	asyncChangeCellsModulo(sarray<int> cells);  // => GLOBAL!
void 	writeStatusLine();  // => Must be predeclared for C++
void 	initializeStats();  // => GLOBAL!
void 	doStatistics(pWorld world);  // => GLOBAL!
void 	doStatisticsOnCells(sarray<int> cells);  // => GLOBAL!
void 	doStatisticsOnCells(smatrix<int> cells);  // => GLOBAL!
void 	visualizeCells(smatrix<int> cells);  // => GLOBAL!
void 	visualizeCells(sarray<int> cells);  // => GLOBAL!
pPairOfInt 	findCell(smatrix<int> cells);  // => GLOBAL!
void 	initVideoExport(Processing::pApplet parent, String Name,int Frames);  // => @note GLOBAL dummy in C++
void 	FirstVideoFrame();  // => @note GLOBAL dummy in C++
void 	NextVideoFrame();  // => @note GLOBAL dummy in C++
void 	CloseVideo();  // => @note GLOBAL dummy in C++
#endif
