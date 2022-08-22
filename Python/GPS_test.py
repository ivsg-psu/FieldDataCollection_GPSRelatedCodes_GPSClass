
from ecef import ecef2geodetic, ecef2geodetic_point
from ellipsoid import Ellipsoid
from GPS import GPS
import time
import datetime
from pyproj import Proj, transform
from pyproj import Transformer
# https://pyproj4.github.io/pyproj/stable/api/transformer.html#pyproj-transformer
inProj = Proj(init='epsg:32710')
outProj = Proj(init='epsg:4326')
x1 = [420899.302132,420124.9925]
y1 = [4581533.07389,4581534.9696]
x2,y2 = transform(inProj,outProj,x1,y1)
print x2,y2


transformer = Transformer.from_crs("epsg:32710", "epsg:4326")
x3,y3 = transformer.transform(x1, y1)
print x3,y3
# -48.914085896984275 -124.07961273316316

gps = GPS()

x = [2259148.993, 2259502.546, 2259856.100, 2612348.830]*25000
y = [3912960.837, 3913573.210, 3914185.582, 4524720.901]*25000
z = [4488055.516, 4488762.622, 4489469.729, 5194455.190]*25000

xx = 2259148.993
yy = 3912960.837
zz = 4488055.516

xx= 2612348.830
yy = 4524720.901
zz = 5194455.190


		#total_start = time.perf_counter()
total_start = time.time()
for i in range(100000):
    lat, lon, alt = ecef2geodetic_point(xx, yy, zz)

ecef2geodetic_point_time = time.time()
print('ecef2geodetic_point time :',ecef2geodetic_point_time- total_start)


lat_v, lon_v, alt_v = ecef2geodetic(x,y,z)

ecef2geodetic_time = time.time()
print('ecef2geodetic time :',ecef2geodetic_time- ecef2geodetic_point_time)

print('No iteration:',lat, lon, alt)

for i in range(100000):
    lat_ite, lon_ite, alt_ite = gps.wgsxyz2lla(xx, yy, zz)

wgsxyz2lla_time = time.time()
print('wgsxyz2lla time :',wgsxyz2lla_time- ecef2geodetic_time)

print('With iteration:',lat_ite, lon_ite, alt_ite)
print(lat_v, lon_v, alt_v )
print(lat_v[0], lon_v[0], alt_v[0])