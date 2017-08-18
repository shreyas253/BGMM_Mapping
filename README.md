# BGMM_Mapping

INTRODUCTION
------------
This toolbox uses Bayesian Gaussian mixture models (BGMM) for mapping/regression. It is the Bayesian extension of the typically used GMM mapping learned with Expectation maximization[1]. Inference is performed using Variational Inference[2].

This also forms the source code related to our work 

1.	Ana Ramirez Lopez, Shreyas Seshadri, Lauri Juvela, Okko Räsänen and Paavo Alku: "Speaking style conversion from normal to Lombard speech using a glottal vocoder and Bayesian GMMs", accepted for publication in Proc. Interspeech 2017, Stockholm, Sweden.

This algorithm is described in  [VBGMM_mapping](VBGMM_mapping.pdf).

Comments/questions are welcome! Please contact: shreyas.seshadri@aalto.fi

Last updated: 18.8.2017


LICENSE
-------

Copyright (C) 2016 Shreyas Seshadri, Aalto University

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

The source code must be referenced when used in a published work.

FILES AND FUNCTIONS
-------------------
runBgmm.m: 
Script to run the toy data 

bayesianGMM.m:
function that returns conditional posterior predictive for a VB-GMM

multTPdf.m:
return probablities for mutivariate student t

multTmm_prediction.m:
Function to do get predicted target based on the posterior predictive distribution.

VB_gmms.m:
Main function that performs the variational inference of the Bayesian mixture models 

updateR.m:
Function to do the E-step in the variational inference algorithm

postUpdate.m:
Function to do the M-step in the variational inference algorithm

freeEnergyCalc.m:
Function to calculate the free energy of the variational distribution

wishartEntropy.m:
Function that calculates the entropy of the Wishart distribution

reorderFE.m:
Function to reorder the clusters in descending order of the cluster occupancy. Used for the non-parametric weight priors.

logdet.m:
Function to calculate the calculate the log determinant of x

logNormalize.m:
Function to normalize the values given in log scale

structMerge.m:
Function to merge the objects in 2 or 3 structures

d2_c_0.5_N2500_k10.mat :
toy data


REFERENCES
---------
[1] Y. Stylianou, O . Cappé, and E. Moulines, “Continuous probabilistic transform for voice conversion,” IEEE Trans. on Speech and Audio Processing, vol. 6, no. 2, pp. 131–142, 1998 

[2] C. M. Bishop, Pattern recognition and machine learning. Springer, 2006.
