import numpy as np

t_t = [0.008064, 0.80704, -3.2*10**(-5), -0.000256, 0.000128, 0.000352]

t21 = t_t[0]
t31 = t_t[1]
t41 = t_t[2]  
t32 = t_t[3]
t42 = t_t[4]
t43 = t_t[5]

C = 343.3 # m/s 

a = 0.075
#t21, t31, t41, t32, t42, t43 = 1
r21 = [-0.5*a, np.sqrt(3)*a/2, 0] 
r31 = [-a, 0, 0] 
r41 = [-0.5*a, a*np.sqrt(3)/6, np.sqrt(2*a/3)]
r32 = [-0.5*a, -np.sqrt(3)*a/2, 0]
r42 = [0, -np.sqrt(3)*a/3, np.sqrt(2*a/3)]
r43 = [0.5*a, np.sqrt(3)*a/6, np.sqrt(2*a/3)]

# Venstre side
t = [t21, t31, t41, t32, t42, t43]
T = np.transpose(t) 

# T_inv = np.linalg.inv(T)  


r = [np.transpose(r21),np.transpose(r31), np.transpose(r41),np.transpose(r32) , np.transpose(r42), np.transpose(r43)]
X = np.transpose(r) / C
X = np.transpose(X)

# lstsq leverer en yuple som svar, så hent ut riktig r_t! (første rad)
r_t = np.linalg.lstsq(X,T, rcond = None)

r = np.transpose(r_t[0])
z_axis = np.transpose([0,0,1])
length_r = np.sqrt(np.dot(r, r))
length_z = 1

#print(r_t[0][0])

#X_inv = np.linalg.inv(X)

#r_t = X_inv @ T

#r = np.transpose(r_t)

def theta():
  return np.rad2deg(np.arccos((np.dot(r,z_axis)) / ((length_r * length_z))))

                   
def phi():
   return np.rad2deg(np.arctan2( r[0] , r[1] ))

"""
def theta():
    return np.rad2deg(np.arccos(r_t[0][2]/np.linalg.norm(r_t)))

def phi():
   return np.rad2deg(np.arctan( r_t[0][0] / r_t[0][1] ))
"""

#print("r-vec: ", r)
#print("T-vec: ", T)
print("Value of theta: ", theta())
print("Value of phi: ", phi())

