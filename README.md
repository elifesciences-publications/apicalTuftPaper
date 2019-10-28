## About Apical Tuft Paper code repository:

This repository contains all the code and data used for the following manuscript:   
**Cell-type specific innervation of cortical pyramidal cells at their apical tufts**   
Ali Karimi\*, Jan Odenthal\*, Florian Drawitsch, Kevin M. Boergens, Moritz Helmstaedter   
\* equally contributing   

This code repository was developed at the Max Planck Insitute for brain research (2015-2019)

## How to get the code repository:
You can download the complete code repository via the Download option on top of this page (cloud icon).   
Alternatively, you can type one of the following commands in your command prompt:  
HTTPS:  
```
git clone https://gitlab.mpcdf.mpg.de/connectomics/apicaltuftpaper.git
```
SSH:  
```
git clone git@gitlab.mpcdf.mpg.de:connectomics/apicaltuftpaper.git
```
Make sure you have [git](https://git-scm.com/downloads) and installed. In addition, you need to configure your 
[SSH](https://gitlab.mpcdf.mpg.de/help/ssh/README) keys in case you do not want to use HTTPS.

You can then set your matlab working directory to this code repository and run the following command:
```
>> startup
```
This should add the necessary variables and paths to you matlab working environment and paths.

## Requirements:
This code repository is written in [MATLAB](https://www.mathworks.com/) and tested using version R2017b. 
In addition to the basic matlab installation we require the following packages to be installed as well:   
* 'Statistics and Machine Learning Toolbox'
* 'Curve Fitting Toolbox'
* 'Bioinformatics Toolbox'
* 'Parallel Computing Toolbox'
* 'MATLAB Distributed Computing Server'

## Contents
This code repository is organized into [MATLAB packages](https://www.mathworks.com/help/matlab/matlab_oop/scoping-classes-with-packages.html) (folders starting with "+")
To access the methods/scripts of within each package folder you need to use dot notation. Here's some examples:
```
>>mypackage.script
>>mypackage.mysubpackage.script
%% Example from this code repository: synapse density Fig. 1d,f
>>Figure1.DF 
```
Here's a list of the packages and folders with a short description of the contents:
* **+Figure1**: Contains scripts to generate figures used in Fig. 1 of the publication
* **+Figure2**: Same as above for Fig. 2
* **+Figure3**: Same as above for Fig. 3
* **annotationData**: contains all the skeleton and 3D annotation Data used for the analysis and surface generation, respectively.
* **+axon**: Routines used for presynaptic analysis (mostly used in Fig. 2)
* **+dendrite**: Routines used for postsynaptic analysis (Mostly Figs. 1,3)
* **+surface**: Routines used for surface generation from volumetric data
* **+util**: All the utility functionalities specific to this repository
* **+config**: configuration files for each annotation NML file type
* **@apicalTuft**: Class used for parsing the skeleton annotations and their properties. This is a subclass of the skeleton class
* **auxiliaryMethods**: Other utilities used for the analysis.
## Authors

The Apical Tuft Paper code repository was developed by
* **Ali Karimi**

With significant contributions by
* **Jan Odenthal**

under scientific supervision by
* **Moritz Helmstaedter**

Most analysis done is done on webKnossos [NML](https://docs.webknossos.org/reference/data_formats#nml) neurite skeleton files and makes use of an efficient NML parser developed by 
* **Alessandro Motta**

The Matlab class used to represent single neurite skeletons and other utility functionalities used for analysis is developed by:
* **Benedikt Staffler**
* **Alessandro Motta**
* **Florian Drawitsch**
* **Ali Karimi**
* **Kevin Boergens**

Volumetric data used to generate surfaces uses the [Webknossos-wrapper](https://github.com/scalableminds/webknossos-wrap) file format. You can visit their website for a complete list of authors.

Dirichlet-multinomial model fitting (Fig. 2b) was done using the [fastfit package](https://github.com/tminka/fastfit) developed by:

* **Thomas P. Minka**
 
## License
This project is licensed under the [MIT license](LICENSE).
Copyright (c) 2019 Department of Connectomics, Max Planck Institute for
Brain Research, D-60438 Frankfurt am Main, Germany


