#include "../Others/Includes.h"
#include "../Simulator/FileReader.h"
#include "Magnet.h"
#include "LLGTensors.h"
#include <chrono>
#include <random>

#ifndef LLGMAGNET_H
#define LLGMAGNET_H

#define PI 3.1415926535897
#define mu0 4*PI*pow(10.0, -7.0) //N/A2 ->   m.kg.s-2
#define kb 1.38064852*pow(10.0, -23.0) //J/K  ->   m2.kg.s-2.K-1
#define gammamu0 mu0*1.760859644*pow(10.0, 11.0) //%m/(sA)
#define hbar 2.05457*pow(10,(-34)) //J.s/rad  -> h/2pi
#define q 1.60217662*pow(10,(-19)) // carga do eletron C

//Class for the LLG magnet engine
class LLGMagnet : public Magnet{
private:
	string id;	//ID
	double magnetization[3];	//Magnetization vector [M_x, M_y, M_z]
	std::vector<std::pair<double, std::vector<double>>> dynamicMagnetization;	//An array of Magnetization vectors [M_x, M_y, M_z] indexed by the period of time
	double initialMagnetization[3];	//Initial magnetization value
	double newMagnetization[3];	//Temporary magnetization value (the magnetization in the next time step)
	vector <Neighbor *> neighbors;	//List of neighbors
	bool fixedMagnetization;	//Fixed magnetization flag
	LLGTensors * tensorsCalculator;	//Object that compute the dipolar and demag tensors
	double volume;	//Volume of the magnet
	double nd[3][3];	//Demag tensor
	double dW [3];	//Thermal noise vector
	double xPosition, yPosition;	//Position
	double theta_she;	//Used for the spin hall effect
	double ** demagTensor;	//Demag tensor
	Magnet * mimic = NULL;	//Mimic this magnet magnetization
	bool isMimicing = false;	//Controll flag


	static double alpha;	//Gilbert's damping constant
	static double alpha_l;	//Dunno
	static double Ms;	//Saturation Magnetization
	static double temperature;	//Temperature of the system
	static double timeStep;	//time step size
	static double bulk_sha;	//Used for spin hall effect
	static double v [3];	//Dunno
	static double dt;	//time step derivated
	static double l_shm;	//Used for spin hall effect
	static double th_shm;	//Used for spin hall effect
	static bool initialized;	//Control flag
	static bool rk4Method;	//Method control flag

	//Method to initialize some constants
	void initializeConstants();
	//Computes the cross product of A and B and saves in P
	void crossProduct(double *vect_A, double *vect_B, double *cross_P);
	//Computes the f term of the magnetization
	void f_term(double * currMag, double * currSignal, double* hd, double* hc, double* i_s, double * result);
	//Method to split a string in parts
	vector<string> splitString(string str, char separator);
	//Computes the a term of the magnetization
	void a_term(double* a, double* h_eff, double* i_s, double* m);
	//Computes the b term of the magnetization
	void b_term(double* b, double* m);

public:
	//Constructor
	LLGMagnet(string id, FileReader * fReader);
	//Compute the magnetization
	void calculateMagnetization(ClockZone * zone);
	//Compute the dynamic magnetization
	void calculateDynamicMagnetization(ClockZone * zone);
	//Build the magnet from a description vector
	void buildMagnet(vector <string> descParts);
	//Returns the magnetization
	double * getMagnetization();
	//Returns the dynamic magnetization
  std::vector<std::pair<double, std::vector<double>>> getDynamicMagnetization();
	//Update the magnetization
	void updateMagnetization();
	//Add a magnet as a neigbor based on a RADIUS (misspell the variable here)
	void addNeighbor(Magnet * neighbor, double * ratio);
	//Print in the output file
	void dumpValues(ofstream * outFile);
	//Returns the ID
	string getId();
	//Set the magnetization to a predefined value
	void setMagnetization(double * magnetization);
	//Set the dynamic magnetization to a predefined value
	void setDynamicMagnetization(std::vector<std::pair<double, std::vector<double>>> const& magnetizations);
	//Reset the magnetization to its initial value
	void resetMagnetization();
	//Returns x coordinates
	double * getPx();
	//Returns y coordinates
	double * getPy();
	//Returns the thickness
	double getThickness();
	//Returns the position
	double getXPosition();
	double getYPosition();
	//Check if a magnet is a neighbor based on a RADIUS (misspell the variable here)
	bool isNeighbor(LLGMagnet * magnet, double ratio);
	//Print the header into the file
	void makeHeader(ofstream * out);
	//Returns the neighbors
	vector <Neighbor *> getNeighbors();
	//Set the mimic magnet
	void setMimic(Magnet * mimic);
};

#endif
