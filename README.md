

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
    The purpose of this code is to do conversions among coordinate systems for GPS data, including East-North-Up (ENU), Latitude-Longitude-Altitude (LLA) and Earth-Centered-Earth-Fixed (ECEF) systems.  
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
	    <li><a href="#definition-of-endpoints">Definition of Endpoints</li>
	    </ul>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

<!--[![Product Name Screen Shot][product-screenshot]](https://example.com)-->

The most common location of our testing is the Larson Test Track, and we regularly use “laps around the track” as replicates, hence the name of the library. And when not on the test track and on public roads, data often needs to be segmented from one keypoint to another. For example, it is a common task to seek a subset of path data that resides only from one intersection to the next. While one could segment this data during data collection by simply stopping the vehicle recordings at each segment, it is impractical and dangerous to stop data collection at each and every possible intersection or feature point. Rather, vehicle or robot data is often collected by repeated driving of an area over/over without stopping. So, the final data set may contain many replicates of the area of interest. 

This "Laps" code assists in breaking recorded path data into paths by defining specific start and end locations, for example from intersection "A" to stop sign "B". Specifically, the purpose of this code is to break data into "laps", e.g. segments of data that are defined by a clear start condition and end condition. The code finds when a given path meets the "start" condition, then meets the "end" condition, and returns every portion of the path that is inside both conditions. There are many advanced features as well including the ability to define excursion points, the number of points that must be within a condition for it to activate, and the ability to extract the portions of the paths before and after each lap, in addition to the data for each lap.

* Inputs: 
    * either a "traversals" type, as explained in the Path library, or a path of XY points in N x 2 format
    * the start, end, and optional excursions can be entered as either a line segment or a point and radius.  
* Outputs
    * Separate arrays of XY points, or of indices for the lap, with one array for each lap
    * The function also can return the points that were not used for laps, e.g. the points before the first start and after the last end

<!-- GETTING STARTED -->
## Getting Started

To get a local copy up and running follow these simple steps.

### Installation

1.  Make sure to run MATLAB 2020b or higher. Why? The "digitspattern" command used in the DebugTools utilities was released late 2020 and this is used heavily in the Debug routines. If debugging is shut off, then earlier MATLAB versions will likely work, and this has been tested back to 2018 releases.

2. Clone the repo
   ```sh
   git clone https://https://github.com/ivsg-psu/FieldDataCollection_GPSRelatedCodes_GPSClass
   ```
3. Run the main code in the root of the folder (script_test_GPSclass.m).
4. Confirm it works! Run script_demo_Laps. If the code works, the script should run without errors. This script produces paths formed by GPS coordinates on the Penn State Test Track.


<!-- STRUCTURE OF THE REPO -->
### Directories
The following are the top level directories within the repository:
<ul>
	<li>/Documents folder: Descriptions of the functionality and usage of the various MATLAB functions and scripts in the repository.</li>
	<li>/Functions folder: The majority of the code for the point and patch association functionalities are implemented in this directory. All functions as well as test scripts are provided.</li>
	<!-- <li>/Utilities folder: Dependencies that are utilized but not implemented in this repository are placed in the Utilities directory. These can be single files but are most often folders containing other cloned repositories.</li> -->
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
    <img src=".\Images\enu2lla_1.png" width="400" height="300">
  </li>	
	<li>
    fcn_GPS_enu2xyz.m : transforms a path(s) in ENU coordinate system to ECEF coordinate system. 
    <br>
    <img src=".\Images\fcn_Laps_breakDataIntoLapIndices.png" alt="fcn_Laps_breakDataIntoLapIndices picture" width="600" height="300">
  </li>	
	<li>
    fcn_GPS_lla2enu.m: transforms a path(s) in Geodetic coordinate system to ENU coordinate system.
    <br>
    <img src=".\Images\fcn_Laps_breakDataIntoLapIndices.png" alt="fcn_Laps_breakDataIntoLapIndices picture" width="600" height="300">
  </li>	
	<li>
    fcn_GPS_lla2xyz.m : transforms a path(s) in Geodetic coordinate system to ECEF coordinate system. 
    <br>
    <img src=".\Images\fcn_Laps_findSegmentZoneStartStop.png" alt="fcn_Laps_findSegmentZoneStartStop picture" width="400" height="300">
    </li>	
	<li>
    fcn_GPS_xyz2enu.m : transforms a path(s) in ECEF coordinate system to ENU coordinate system. 
    <br>
    <img src=".\Images\fcn_Laps_findPointZoneStartStopAndMinimum.png" alt="fcn_Laps_findPointZoneStartStopAndMinimum picture" width="400" height="300">
  </li>	
	<li>
    fcn_GPS_xyz2lla.m : transforms a path(s) in ECEF coordinate system to Geodetic coordinate system. 
    <br>
    <img src=".\Images\fcn_Laps_findPointZoneStartStopAndMinimum.png" alt="fcn_Laps_findPointZoneStartStopAndMinimum picture" width="400" height="300">
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








