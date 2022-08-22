#!/usr/bin/env python

import numpy as np
import sys
from ecef import ecef2geodetic, ecef2geodetic_point

class GPS:

	def __init__(self, reference_latitude=None, reference_longitude=None, reference_altitude=None):
		#the parameters of wgs84 
		self.a_earth = 6378137.0  #semimajor_axis
		self.flattening = 1 / 298.257223563
		self.nav_e2 = (2 - self.flattening) * self.flattening  # also e^2, the eccentricity
		#semi-minor axis b equals a*(1-flattening) = 6356752.3142m. and the first eccentricity squared e^2 = 6.69437999014*10^-3
		if reference_latitude is not None and reference_longitude is not None and reference_altitude is not None:

			self.reference_latitude = reference_latitude
			self.reference_longitude = reference_longitude
			self.reference_altitude = reference_altitude

		else:

			self.reference_latitude = 40.8623031194444
			self.reference_longitude = -77.8362636138889
			self.reference_altitude = 333.817
			print('Using default base station coordinates at LTI test track')

	def wgslla2enu(self, lat, lon, alt, reference_latitude=None, reference_longitude=None, reference_altitude=None):

		if reference_latitude is None:
			reference_latitude = self.reference_latitude
			reference_longitude = self.reference_longitude
			reference_altitude = self.reference_altitude

		x, y, z = self.wgslla2xyz(lat, lon, alt)
		east, north, up = self.WGSxyz2ENU(x, y, z, reference_latitude, reference_longitude, reference_altitude)

		return east, north, up

	def enu2wgslla(self, east, north, up, IsVector= False, reference_latitude=None, reference_longitude=None, reference_altitude=None):

		if reference_latitude is None:
			reference_latitude = self.reference_latitude
			reference_longitude = self.reference_longitude
			reference_altitude = self.reference_altitude

		x, y, z = self.enu2wgsxyz(east, north, up,reference_latitude, reference_longitude, reference_altitude)
		# lat, lon, alt = self.wgsxyz2lla( x, y, z) # this method is slow
		if IsVector == True:  # if input is an array
			lat, lon, alt = ecef2geodetic(x, y, z)
			return lat, lon, alt
		else:
			return ecef2geodetic_point(x, y, z) # this method is more than 10 times faster than wgsxyz2lla

	def wgslla2xyz(self, wlat, wlon, walt):

		slat = np.sin(np.radians(wlat))
		clat = np.cos(np.radians(wlat))
		r_n = self.a_earth / np.sqrt(1 - self.nav_e2 * slat * slat)
		x = (r_n + walt) * clat * np.cos(np.radians(wlon))
		y = (r_n + walt) * clat * np.sin(np.radians(wlon))
		z = ((r_n * (1 - self.nav_e2) + walt) * slat)

		return x, y, z

	def WGSxyz2ENU(self, x, y, z, reference_latitude=None, reference_longitude=None, reference_altitude=None):

		if reference_latitude is None:
			reference_latitude = self.reference_latitude
			reference_longitude = self.reference_longitude
			reference_altitude = self.reference_altitude

		# First, calculate the xyz of reference_latitude, reference_longitude, reference_altitude
		refx, refy, refz = self.wgslla2xyz(reference_latitude, reference_longitude, reference_altitude)

		# Difference xyz from reference point
		xyz = np.array([x, y, z])
		refxyz = np.array([[refx], [refy], [refz]])
		diffxyz = xyz - refxyz

		# Now rotate the (often short) diffxyz vector to enu frame
		c = np.cos(np.radians(90 + reference_longitude))
		s = np.sin(np.radians(90 + reference_longitude))
		R1 = np.eye((3))
		R1[0,0] = c
		R1[1,1] = c
		R1[1,0] = -s
		R1[0,1] = s

		c = np.cos(np.radians(90 - reference_latitude))
		s = np.sin(np.radians(90 - reference_latitude))
		R2 = np.eye((3))
		R2[1,1] = c
		R2[2,2] = c
		R2[1,2] = s
		R2[2,1] = -s

		R = np.dot(R2, R1)

		enu = np.dot(R, diffxyz)

		east = enu[0]
		north = enu[1]
		up = enu[2]

		return east, north, up

	def enu2wgsxyz(self, east, north, up, reference_latitude=None, reference_longitude=None, reference_altitude=None):

		if reference_latitude is None:
			reference_latitude = self.reference_latitude
			reference_longitude = self.reference_longitude
			reference_altitude = self.reference_altitude

		# First, rotate the enu vector to xyz frame
		c = np.cos(np.radians(90 + reference_longitude))
		s = np.sin(np.radians(90 + reference_longitude))
		R1 = np.eye((3))
		R1[0,0] = c
		R1[1,1] = c
		R1[1,0] = -s
		R1[0,1] = s

		c = np.cos(np.radians(90 - reference_latitude))
		s = np.sin(np.radians(90 - reference_latitude))
		R2 = np.eye((3))
		R2[1,1] = c
		R2[2,2] = c
		R2[1,2] = s
		R2[2,1] = -s

		R = np.dot(R2, R1)

		enu = np.array([east, north, up])
		diffxyz = np.dot(np.linalg.inv(R), enu)

		# Then, calculate the xyz of reference_latitude, reference_longitude, reference_altitude
		x_ref, y_ref, z_ref = self.wgslla2xyz(reference_latitude, reference_longitude, reference_altitude)

		# Add diffxyz to refxyz
		x = x_ref + diffxyz[0]
		y = y_ref + diffxyz[1]
		z = z_ref + diffxyz[2]

		return x, y, z

	'''
	 x,y,z are scalar 
	'''
	def wgsxyz2lla(self, x, y, z):

		# This dual-variable iteration seems to be 7 or 8 times faster than
		# a one-variable (in latitude only) iteration.  AKB 7/17/95

		if ((x == 0.0) and (y == 0.0)):
			wlon = 0.0
		else:
			wlon = np.degrees(np.arctan2(y, x))

		# Make initial lat and alt guesses based on spherical earth.
		rhosqrd = x * x + y * y
		rho = np.sqrt(rhosqrd)
		templat = np.arctan2(z, rho)
		tempalt = np.sqrt(rhosqrd + z * z) - self.a_earth
		rhoerror = 1000.0
		zerror = 1000.0

		# Newton's method iteration on templat and tempalt makes
		# the residuals on rho and z progressively smaller.  Loop
		# is implemented as a 'while' instead of a 'do' to simplify
		# porting to MATLAB

		while ((abs(rhoerror) > 1e-6) or (abs(zerror) > 1e-6)):

			slat = np.sin(templat)
			clat = np.cos(templat)
			q = 1 - self.nav_e2 * slat * slat
			r_n = self.a_earth / np.sqrt(q)
			drdl = r_n * self.nav_e2 * slat * clat / q  # d(r_n)/d(latitutde)

			rhoerror = (r_n + tempalt) * clat - rho
			zerror = (r_n * (1 - self.nav_e2) + tempalt) * slat - z

			#             --                               -- --      --
			#             |  drhoerror/dlat  drhoerror/dalt | |  a  b  |
			# Find Jacobian           |                     |=|        |
			#             |   dzerror/dlat    dzerror/dalt  | |  c  d  |
			#             --                               -- --      --

			aa = drdl * clat - (r_n + tempalt) * slat
			bb = clat
			cc = (1 - self.nav_e2) * (drdl * slat + r_n * clat)
			dd = slat

			#  Apply correction = inv(Jacobian)*errorvector
			invdet = 1.0 / (aa * dd - bb * cc)
			templat = templat - invdet * (dd * rhoerror - bb * zerror)
			tempalt = tempalt - invdet * (-cc * rhoerror + aa * zerror)

		wlat = np.degrees(templat)
		walt = tempalt

		return wlat, wlon, walt
	
	'''
	 x,y,z are vector
	'''
	def wgsxyz2lla_vector(self, x, y, z):

		# This dual-variable iteration seems to be 7 or 8 times faster than
		# a one-variable (in latitude only) iteration.  AKB 7/17/95


		wlon = np.degrees(np.arctan2(y, x))

		# Make initial lat and alt guesses based on spherical earth.
		rhosqrd = x * x + y * y
		rho = np.sqrt(rhosqrd)
		templat = np.arctan2(z, rho)
		tempalt = np.sqrt(rhosqrd + z * z) - self.a_earth
		rhoerror = 1000.0
		zerror = 1000.0

		# Newton's method iteration on templat and tempalt makes
		# the residuals on rho and z progressively smaller.  Loop
		# is implemented as a 'while' instead of a 'do' to simplify
		# porting to MATLAB

		while ((abs(rhoerror) > 1e-6) or (abs(zerror) > 1e-6)):

			slat = np.sin(templat)
			clat = np.cos(templat)
			q = 1 - self.nav_e2 * slat * slat
			r_n = self.a_earth / np.sqrt(q)
			drdl = r_n * self.nav_e2 * slat * clat / q  # d(r_n)/d(latitutde)

			rhoerror = (r_n + tempalt) * clat - rho
			zerror = (r_n * (1 - self.nav_e2) + tempalt) * slat - z

			#             --                               -- --      --
			#             |  drhoerror/dlat  drhoerror/dalt | |  a  b  |
			# Find Jacobian           |                     |=|        |
			#             |   dzerror/dlat    dzerror/dalt  | |  c  d  |
			#             --                               -- --      --

			aa = drdl * clat - (r_n + tempalt) * slat
			bb = clat
			cc = (1 - self.nav_e2) * (drdl * slat + r_n * clat)
			dd = slat

			#  Apply correction = inv(Jacobian)*errorvector
			invdet = 1.0 / (aa * dd - bb * cc)
			templat = templat - invdet * (dd * rhoerror - bb * zerror)
			tempalt = tempalt - invdet * (-cc * rhoerror + aa * zerror)

		wlat = np.degrees(templat)
		walt = tempalt

		return wlat, wlon, walt


def main(args):

	gps = GPS()

if __name__ == '__main__':
	main(sys.argv)
