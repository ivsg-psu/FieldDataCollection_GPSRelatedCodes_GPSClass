

<!--
The following template is based on:
Best-README-Template
Search for this, and you will find!
>
<!-- PROJECT LOGO -->
<br />
<p align="center">
  <!-- <a href="https://github.com/ivsg-psu/FeatureExtraction_Association_PointToPointAssociation">
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a> -->

  <h2 align="center"> FieldDataCollection_GPSRelatedCodes_GPSClass
  </h2>

<img src=".\Images\test_GPSclass.png" >

  <p align="center">
    The purpose of this code is to support conversions among coordinate systems commonly used for GPS data. These include: East-North-Up (ENU), Latitude-Longitude-Altitude (LLA), and Earth-Centered-Earth-Fixed (ECEF) systems.  Note that UTM coordinates are not yet supported.
    <br />
    <a href="https://github.com/ivsg-psu/FeatureExtraction_Association_PointToPointAssociation"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/ivsg-psu/FeatureExtraction_Association_PointToPointAssociation/tree/main/Documents">View Demo</a>
    ·
    <a href="https://github.com/ivsg-psu/FeatureExtraction_Association_PointToPointAssociation/issues">Report Bug</a>
    ·
    <a href="https://github.com/ivsg-psu/FeatureExtraction_Association_PointToPointAssociation/issues">Request Feature</a>
  </p>
</p>



<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary><h2 style="display: inline-block">Table of Contents</h2></summary>
  <ol>
    <li>
      <a href="#about-the-project">About the Project</a>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="structure">Repo Structure</a>
	    <ul>
	    <li><a href="#directories">Top-Level Directories</li>
	    <li><a href="#dependencies">Dependencies</li>
	    <li><a href="#functions">Functions</li>
	    </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
	    <ul>
	    <li><a href="#examples">Examples</li>
	    </ul>
    <li><a href="#comparing-coordinate-system-conversion-algorithms">Comparing coordinate system conversion algorithms</a></li>
	    <ul>
	    <li><a href="#lla-to-ecef">LLA to ECEF</li>
      <li><a href="#lla-to-enu">LLA to ENU</li>
      <li><a href="#enu-to-ecef">ENU to ECEF</li>
      <li><a href="#enu-to-lla">ENU to LLA</li>
      <li><a href="#ecef-to-enu">ECEF to ENU</li>
      <li><a href="#ecef-to-lla">ECEF to LLA</li>
	    </ul>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

<!--[![Product Name Screen Shot][product-screenshot]](https://example.com)-->

For nearly every project within the Intelligent Vehicles and Systems Group (IVSG), GPS data is a key means of obtaining measurements. Such data is usually reported in Latitude Longitude Altitude (LLA) coordiantes to position the measurement relative to the Earth's sphere. However, the use of LLA data is difficult: the numbers produced by GPS are not intuitive to human understanding, the required precision in measurement - often 6 decimals or more - makes data entry difficult to process on single-precision variables, the number lengths make data prone to error and difficult to spot errors, and the coordinate sytem itself is not isometric ("length preserving"). For example, a degree of latitude - due to the original definition of the meter as 1/10,000,000th the distance from the equator to the north pole - always corresponds to (10^7/90) or approximately 111,111 meters. However, a degree of longitude is this distance ONLY around the equator. At the north pole, a degree of longitude corresonds to zero meters. Thus, longitude degrees change in "length" by a factor of 100,000! 

As well, different tool sets use different coordinate systems. For example:

* Traffic simulation tools (SUMO for example) tend to use UTM coordinates

* 3D modeling simulation tools (CARLA, for example) tend to use ENU coordinates

* Mapping systems tend to use LLA coordinates

Thus, there is a need for better data representations and coordinate systems. But each coordinate system encounters challenges, particularly because the representation of roadways typically assumes a "flat" surface. Thus, as the scale of a local area becomes large enough, the errors between a flat approximation versus a spherical approximation begin to grow and can become so pronounced that data begin to disagree depending on the origin used for the flat representation. When operating vehicles over a "large" area, for example tens to hundreds of kilometers, these errors can be so large that one cannot tell, on the "edge" of a mapped region, which lane or which road a vehicle is operating in - even though the so-called precision of the GPS measurement is reporting centimeter-level accuracy.

This "GPSclass" code assists in performing large the coordinate systems for GPS data, including East-North-Up (ENU), Latitude-Longitude-Altitude (LLA) and Earth-Centered-Earth-Fixed (ECEF) systems. 

NOTE: a companion repository, https://github.com/ivsg-psu/TrafficSimulators_WideAreaCoordinateSystems , reviews the above issues, showing calculations for different transformation sequences, and reveals that particular transformation sequences generate less error than others. 
   

<!-- GETTING STARTED -->
## Getting Started

To get a local copy up and running follow these simple steps.

### Installation

1.  It's recommended to run MATLAB 2020b or higher. 

2. Clone the repo
   ```sh
   git clone https://https://github.com/ivsg-psu/FieldDataCollection_GPSRelatedCodes_GPSClass
   ```
3. Run the main code in the root of the folder (script_test_GPSclass.m).
4. Confirm it works! If the code works, the script should run without errors. This script produces paths formed by GPS coordinates on the Penn State Test Track.

## Repo structure
<!-- STRUCTURE OF THE REPO -->
### Directories
The following are the top level directories within the repository:
<ul>
	<li>/Documents folder: Descriptions of the functionality and usage of the various MATLAB functions and scripts in the repository.</li>
	<li>/Functions folder: The majority of the code for the point and patch association functionalities are implemented in this directory. All functions as well as test scripts are provided.</li>
  <li>/Data folder: Storage of data.</li>
  <li>/Images folder: Sample images generated by the functions in this class.</li>
</ul>

### Dependencies

No dependencies needed for this class. 

<!-- FUNCTION DEFINITIONS -->
### Functions
**Basic Support Functions**
<ul>
	<li>
    fcn_GPS_checkInputsToFunctions.m : Checks the variable types commonly used in the GPS class to ensure that they are correctly formed.
    <br>
  </li> 
    

</ul>

**Core Functions**
<ul>
	<li>
    fcn_GPS_enu2lla.m : transforms a path(s) in ENU coordinate system to Geodetic coordinate system.
    <br>
    <img src=".\Images\enu2lla.png" width="400" height="300">
  </li>	
	<li>
    fcn_GPS_enu2xyz.m : transforms a path(s) in ENU coordinate system to ECEF coordinate system. 
    <br>
    <img src=".\Images\enu2xyz.png" width="400" height="300">
  </li>	
	<li>
    fcn_GPS_lla2enu.m: transforms a path(s) in Geodetic coordinate system to ENU coordinate system.
    <br>
    <img src=".\Images\lla2enu.png" width="400" height="300">
  </li>	
	<li>
    fcn_GPS_lla2xyz.m : transforms a path(s) in Geodetic coordinate system to ECEF coordinate system. 
    <br>
    <img src=".\Images\lla2xyz.png" width="400" height="300">
    </li>	
	<li>
    fcn_GPS_xyz2enu.m : transforms a path(s) in ECEF coordinate system to ENU coordinate system. 
    <br>
    <img src=".\Images\xyz2enu.png"  width="400" height="300">
  </li>	
	<li>
    fcn_GPS_xyz2lla.m : transforms a path(s) in ECEF coordinate system to Geodetic coordinate system. 
    <br>
    <img src=".\Images\xyz2lla.png"  width="400" height="300">
  </li>	
</ul>
Each of the functions has an associated test script, using the convention

```sh
script_test_fcn_fcnname
```
where fcnname is the function name as listed above.

As well, each of the functions includes a well-documented header that explains inputs and outputs. These are supported by MATLAB's help style so that one can type:

```sh
help fcn_fcnname
```
for any function to view function details.

## Comparing coordinate system conversion algorithms
This section lists comparison of the coordinate conversion algorithms for LLA, ENU and ECEF, from the GPS class, standalone code, and MATLAB built-in code.

The script script_test_fcn_compareCSConcersion.m is used to generate all the plots in this section. 

### LLA to ECEF

The following functions are used: 

- gpsObj.WGSLLA2XYZ (GPS class)
- fcn_GPS_lla2xyz (Satya)
- lla2ecef (MATLAB)

The results are below:
<ul>
	<li>
    <img src=".\Images\lla2xyz-Difference between GPS class and MATLAB built-in.png" width="640" height="350">
    <img src=".\Images\lla2xyz-Difference between Satya and MATLAB built-in.png" width="640" height="350">
    <img src=".\Images\lla2xyz-Difference between GPS class and Satya.png" width="640" height="350">
</ul>

### LLA to ENU
The following functions are used: 

- gpsObj.WGSLLA2ENU (GPS class)
- fcn_GPS_lla2enu (Satya)
- lla2enu (MATLAB)

The results are below:
<ul>
	<li>
    <img src=".\Images\lla2enu-Difference between GPS class and MATLAB built-in.png" width="640" height="350">
    <img src=".\Images\lla2enu-Difference between Satya and MATLAB built-in.png" width="640" height="350">
    <img src=".\Images\lla2enu-Difference between GPS class and Satya.png" width="640" height="350">

</ul>

### ENU to ECEF
The following functions are used: 

- gpsObj.ENU2WGSXYZ (GPS class)
- fcn_GPS_enu2xyz (Satya)
- enu2ecef (MATLAB)

The results are below:
<ul>
	<li>
    <img src=".\Images\enu2xyz-Difference between GPS class and MATLAB built-in.png" width="640" height="350">
    <img src=".\Images\enu2xyz-Difference between Satya and MATLAB built-in.png" width="640" height="350">
    <img src=".\Images\enu2xyz-Difference between GPS class and Satya.png" width="640" height="350">
</ul>

### ENU to LLA
The following functions are used: 

- gpsObj.ENU2WGSLLA (GPS class)
- fcn_GPS_enu2lla (Satya)
- enu2lla (MATLAB)

The results are below:
<ul>
	<li>
    <img src=".\Images\enu2lla-Difference between GPS class and MATLAB built-in.png" width="640" height="350">
    <img src=".\Images\enu2lla-Difference between Satya and MATLAB built-in.png" width="640" height="350">
    <img src=".\Images\enu2lla-Difference between GPS class and Satya.png" width="640" height="350">
</ul>

### ECEF to ENU
The following functions are used: 

- gpsObj.WGSXYZ2ENU (GPS class)
- fcn_GPS_xyz2enu (Satya)
- ecef2enu (MATLAB)

The results are below:
<ul>
	<li>
    <img src=".\Images\xyz2enu-Difference between GPS class and MATLAB built-in.png" width="640" height="350">
    <img src=".\Images\xyz2enu-Difference between Satya and MATLAB built-in.png" width="640" height="350">
    <img src=".\Images\xyz2enu-Difference between GPS class and Satya.png" width="640" height="350">
</ul>

### ECEF to LLA
The following functions are used: 

- gpsObj.WGSXYZ2LLA (GPS class)
- fcn_GPS_xyz2lla (Satya)
- ecef2lla (MATLAB)

The results are below:
<ul>
	<li>
    <img src=".\Images\xyz2lla-Difference between GPS class and MATLAB built-in.png" width="640" height="350">
    <img src=".\Images\xyz2lla-Difference between Satya and MATLAB built-in.png" width="640" height="350">
    <img src=".\Images\xyz2lla-Difference between GPS class and Satya.png" width="640" height="350">
</ul>





<!-- USAGE EXAMPLES -->
## Usage
<!-- Use this space to show useful examples of how a project can be used.
Additional screenshots, code examples and demos work well in this space. You may
also link to more resources. -->

### Examples

1. Run the main script to set up the workspace and demonstrate main outputs, including the figures included here:

   ```sh
   script_test_fcn_GPS_xyz2lla.m
   ```
    This exercises the main function of this code: fcn_GPS_xyz2lla.m

For more examples, please refer to the [Documentation](https://github.com/ivsg-psu/FeatureExtraction_Association_PointToPointAssociation/tree/main/Documents)

<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE` for more information.


## Major release versions
This code is still in development (alpha testing)


<!-- CONTACT -->
## Contact
Sean Brennan - sbrennan@psu.edu

Project Link: [https://github.com/ivsg-psu/FieldDataCollection_GPSRelatedCodes_GPSClass](https://github.com/ivsg-psu/FieldDataCollection_GPSRelatedCodes_GPSClass)



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/ivsg-psu/FeatureExtraction_Association_PointToPointAssociation.svg?style=for-the-badge
[contributors-url]: https://github.com/ivsg-psu/FeatureExtraction_Association_PointToPointAssociation/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/ivsg-psu/FeatureExtraction_Association_PointToPointAssociation.svg?style=for-the-badge
[forks-url]: https://github.com/ivsg-psu/FeatureExtraction_Association_PointToPointAssociation/network/members
[stars-shield]: https://img.shields.io/github/stars/ivsg-psu/FeatureExtraction_Association_PointToPointAssociation.svg?style=for-the-badge
[stars-url]: https://github.com/ivsg-psu/FeatureExtraction_Association_PointToPointAssociation/stargazers
[issues-shield]: https://img.shields.io/github/issues/ivsg-psu/reFeatureExtraction_Association_PointToPointAssociationpo.svg?style=for-the-badge
[issues-url]: https://github.com/ivsg-psu/FeatureExtraction_Association_PointToPointAssociation/issues
[license-shield]: https://img.shields.io/github/license/ivsg-psu/FeatureExtraction_Association_PointToPointAssociation.svg?style=for-the-badge
[license-url]: https://github.com/ivsg-psu/FeatureExtraction_Association_PointToPointAssociation/blob/master/LICENSE.txt








