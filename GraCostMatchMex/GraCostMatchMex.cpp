#include "mex.h" 
#include "float.h"

// Mismatch removal given putative matches
// Author: Ji Zhao
// 01/04/2017

void calcDistMatrix(float* X, float* Y, float* distMat, int numPoint)
{
	for (int i = 0; i < numPoint; i++){
		float xL_1 = X[i*2];
		float xL_2 = X[i*2 + 1];
		float yL_1 = Y[i*2];
		float yL_2 = Y[i*2 + 1];
		distMat[i * numPoint + i] = 0;
		for (int j = i + 1; j < numPoint; j++){
			float xR_1 = X[j*2];
			float xR_2 = X[j*2 + 1];
			float yR_1 = Y[j*2];
			float yR_2 = Y[j*2 + 1];

			float d1 = xL_1 - xR_1;
			float d2 = xL_2 - xR_2;
			distMat[i * numPoint + j] = d1*d1 + d2*d2;

			d1 = yL_1 - yR_1;
			d2 = yL_2 - yR_2;
			distMat[j * numPoint + i] = d1*d1 + d2*d2;
		}
	}
}

void find_K_Smallest(float* distVec, int num_valid, int K, int* neighbors)
{
	for (int i = 0; i < K; i++){
		float minValue = FLT_MAX;
		int minIndex = -1;
		for (int j = 0; j < num_valid; j++){
			float curValue = distVec[j];
			if (curValue < minValue){
				minValue = curValue;
				minIndex = j;
			}
		}
		neighbors[i] = minIndex;
		distVec[minIndex] = FLT_MAX;
	}
}

void GraCostMatch(float* X, float* Y, float lambda1, int numNeigh1,
	float lambda2, int numNeigh2, int numPoint, double* Prob)
{
	float* distMat = new float[numPoint*numPoint];
	float* distVecX = new float[numPoint];
	float* distVecY = new float[numPoint];
	int* neighborX = new int[numPoint];
	int* neighborY = new int[numPoint];
	bool* p = new bool[numPoint];
	bool* p_old = new bool[numPoint];
	int numNeighCands;
	int numNeigh;
	float lambda;

	calcDistMatrix(X, Y, distMat, numPoint);
	for (int i = 0; i < numPoint; i++){
		p[i] = true;
		p_old[i] = true;
	}
	numNeighCands = numPoint;

	for (int iter = 0; iter < 2; iter++){
		switch (iter){
		case 0:
			lambda = lambda1;
			numNeigh = numNeigh1;
			break;
		case 1:
			lambda = lambda2;
			numNeigh = numNeigh2;
			break;
		default:
			lambda = 4.0f;
			numNeigh = 8;
		}
		if (numNeighCands < numNeigh+1){
			continue;
		}

		numNeighCands = 0;
		for (int i = 0; i < numPoint; i++){
			int num_valid = 0;
			for (int j = 0; j < numPoint; j++){
				int idx_min = (i < j) ? i : j;
				int idx_max = (i > j) ? i : j;
				int id1 = idx_min * numPoint + idx_max;
				int id2 = idx_max * numPoint + idx_min;

				if (p_old[j] && i!=j){
					distVecX[num_valid] = distMat[id1];
					distVecY[num_valid] = distMat[id2];
					num_valid++;
				}
			}
			
			find_K_Smallest(distVecX, num_valid, numNeigh, neighborX);
			find_K_Smallest(distVecY, num_valid, numNeigh, neighborY);

			int cost = 0;
			for (int m = 0; m < numNeigh; m++){
				int tmp = neighborX[m];
				bool isMember = false;
				for (int n = 0; n < numNeigh; n++){
					if (neighborY[n] == tmp){
						isMember = true;
						break;
					}
				}
				if (!isMember)
					cost++;
			}
			cost *= 2;

			if (cost <= lambda){
				p[i] = true;
				numNeighCands++;
			}
			else{
				p[i] = false;
			}

		}
		for (int i = 0; i < numPoint; i++)
			p_old[i] = p[i];

	}

	for (int i = 0; i < numPoint; i++){
		if (p[i])
			Prob[i] = 1.0f;
		else
			Prob[i] = 0.0f;
	}

	delete[] distMat;
	delete[] distVecX;
	delete[] distVecY;
	delete[] neighborX;
	delete[] neighborY;
	delete[] p;
	delete[] p_old;
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) 
{
	/*nlhs：num of output para
		plhs：output para
		nrhs：num of input para
		prhs：input para */ 
	double *X;
	double *Y;
	double *Prob;
	float lambda1, lambda2;
	int numNeigh1, numNeigh2;
	int M, N, numPoint;

	X = (double *)mxGetData(prhs[0]);
	Y = (double *)mxGetData(prhs[1]);
	lambda1 = static_cast<float>(mxGetScalar(prhs[2]));
	numNeigh1 = static_cast<int>(mxGetScalar(prhs[3]));
	lambda2 = static_cast<float>(mxGetScalar(prhs[4]));
	numNeigh2 = static_cast<int>(mxGetScalar(prhs[5]));
	
	M = static_cast<int>(mxGetM(prhs[0]));
	N = static_cast<int>(mxGetN(prhs[0]));
	if (M==2){
		numPoint = N;
	}
	else if (N==2){
		numPoint = M;
	}

	float* new_X = new float[numPoint*2];
	float* new_Y = new float[numPoint*2];
	if (M==2){
		for (int i = 0; i < M*N; i++){
			new_X[i] = static_cast<float>(X[i]);
			new_Y[i] = static_cast<float>(Y[i]);
		}
	}
	else if (N==2){
		for (int i = 0; i < M; i++){
			new_X[i*2] = static_cast<float>(X[i]);
			new_X[i*2+1] = static_cast<float>(X[i+M]);
			new_Y[i*2] = static_cast<float>(Y[i]);
			new_Y[i*2+1] = static_cast<float>(Y[i+M]);
		}
	}

	plhs[0] = mxCreateDoubleMatrix(1, numPoint,mxREAL);
	Prob = mxGetPr(plhs[0]);
	GraCostMatch(new_X, new_Y, lambda1, numNeigh1, lambda2, numNeigh2, numPoint, Prob);
	delete[] new_X;
	delete[] new_Y;
}
