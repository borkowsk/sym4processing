//Automagically generated file. @date 2024-10-11 16:48:39 
//Dont edit\!
#pragma once
#ifndef LOCAL_H
#define LOCAL_H



//All classes but not templates from Processing files
class Agent; typedef Processing::ptr<Agent> pAgent; //
class PairOfInt; typedef Processing::ptr<PairOfInt> pPairOfInt; //
class World; typedef Processing::ptr<World> pWorld; //

//All global finals (consts) from Processing files

//All global variables from Processing files
extern	String 		modelName;	// ->  Name of the model is used for log files.
extern	int 		side;	// ->  side of "world" main table.
extern	float 		density;	// ->  initial density of agents.
extern	pWorld 		TheWorld;	// ->  Main "chessboard". It will be initialised inside 'setup()'
extern	int 		EMPTYGRAY;	// ->  Shade of gray for background of "chessboard".
extern	int 		cwidth;	// ->  requested size of cells.
extern	int 		cstroke;	// ->  border of cells.
extern	int 		STATUSHEIGH;	// ->  height of status bar.
extern	int 		STEPSperVIS;	// ->  how many model steps beetwen visualisations. 
extern	int 		FRAMEFREQ;	// ->  how many model steps per second.
extern	bool 		WITH_VIDEO;	// ->  Make a movie?
extern	bool 		simulationRun;	// ->  Start/stop flag.
extern	int 		StepCounter;	// ->  Counter of real simulation steps.
extern	PrintWriter 		outstat;         // ->  Handle to the text file with the record of model statistics
extern	float 		meanDummy;	// ->  average value for the dummy field.
extern	int   		liveCount;	// ->  number of living agents.
extern	int 		searchedX;	// ->  The horizontal coordinate of the mouse cursor.
extern	int 		searchedY;	// ->  The vertical coordinate of the mouse cursor.
extern	bool 		Clicked;	// ->  Was there a click too?
extern	int 		selectedX;	// ->  Converted into "world" indices, the agent's horizontal coordinate.
extern	int 		selectedY;	// ->  Converted into "world" indices, the agent's vertical coordinate.
extern	pAgent 		selected;	// ->  Most recently selected agent.
extern	String 		copyrightNote;	// ->  Change it to your copyright. Best in setup().

//All global arrays from Processing files

//All global matrices from Processing files

//All global functions from Processing files
void 	writeStatusLine();  // => Must be predeclared!
void 	initializeAgents(smatrix<pAgent> agents);  // => GLOBAL!
void 	initializeAgents(sarray<pAgent> agents);  // => GLOBAL!
void  	dummyChangeAgents(smatrix<pAgent> agents);  // => GLOBAL!
void  	dummyChangeAgents(sarray<pAgent> agents);  // => GLOBAL!
void  	changeAgents(smatrix<pAgent> agents);  // => GLOBAL!
void  	changeAgents(sarray<pAgent> agents);  // => GLOBAL!
void 	initializeModel(pWorld world);  // => GLOBAL!
void 	visualizeModel(pWorld world);  // => GLOBAL!
void 	modelStep(pWorld world);  // => GLOBAL!
void 	initializeStats();  // => GLOBAL!
void 	doStatistics(pWorld world);  // => GLOBAL!
void 	doStatisticsOnAgents(sarray<pAgent> agents);  // => GLOBAL!
void 	doStatisticsOnAgents(smatrix<pAgent> agents);  // => GLOBAL!
void 	visualizeAgents(smatrix<pAgent> agents);  // => GLOBAL!
void 	visualizeAgents(sarray<pAgent> agents);  // => GLOBAL!
pPairOfInt 	findCell(smatrix<pAgent> agents);  // => Must be predeclared!
void 	initVideoExport(Processing::pApplet parent, String Name,int Frames);  // => @note GLOBAL dummy in C++
void 	FirstVideoFrame();  // => @note GLOBAL dummy in C++
void 	NextVideoFrame();  // => @note GLOBAL dummy in C++
void 	CloseVideo();  // => @note GLOBAL dummy in C++
#endif
