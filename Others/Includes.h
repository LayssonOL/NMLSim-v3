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
#include <fmt/format.h>
#include <fmt/ranges.h>
#include <fmt/core.h>
#include <map>
#include <iomanip>
#include <string>

#define FMTPRINT(x, y) fmt::print(" {} => {}\n", x, y);
#define LOG(x) fmt::print(" {} \n", x);

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
	DYNAMIC,
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
