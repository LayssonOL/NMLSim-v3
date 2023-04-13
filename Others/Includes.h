#ifndef INCLUDES_H
#define INCLUDES_H

#include <vector>
#include <string>
#include <stdlib.h>
#include <cstdlib>
#include <iostream>
#include <fstream>
#include <algorithm>
#include <tgmath.h>
#include <unordered_map>
#include <map>
#include <string>
#include <thread>
#include <set>

using namespace std;

enum magnetType{
	INPUT,
	OUTPUT,
	REGULAR,
	CROSS
};

enum simulationType{
	INVALIDTYPE,
	THIAGO,
	LLG
};

enum simulationExecution{
	INVALIDSIMULATION,
	DIRECT,
	PROGRAMMED,
	EXAUSTIVE,
	VERBOSE,
	REPETITIVE
};

enum propertyType{
	CIRCUIT,
	PHASE,
	ZONE,
	COMPONENTS,
	DESIGN
};

#endif
