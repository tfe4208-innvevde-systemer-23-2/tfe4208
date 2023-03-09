import numpy as np

# Rett over 
t_t = [0.00176, 0.162912, -32.*(10**(-5)), 0.001792, 0.001792, 0.0]

# Ish 45 grader phi og 30 grader theta

#t_t = [0.003968, 0.004224, 0.0, 0.000352, -3.2*10**(-5), 0.073728] 

# Ish 45 grader phi, -110 grader theta
#t_t = [0.008064, 0.80704, -3.2*10**(-5), -0.000256, 0.000128, 0.000352]

t21 = t_t[0]
t31 = t_t[1]
t41 = t_t[2]  
t32 = t_t[3]
t42 = t_t[4]
t43 = t_t[5]

C = 343.3 # m/s 

a = 0.075  #cm
#t21, t31, t41, t32, t42, t43 = 1
r21 = [-0.5*a, np.sqrt(3)*a/2, 0] 
r31 = [-a, 0, 0] 
r41 = [-0.5*a, a*np.sqrt(3)/6, np.sqrt(2*a/3)]
r32 = [-0.5*a, -np.sqrt(3)*a/2, 0]
r42 = [0, -np.sqrt(3)*a/3, np.sqrt(2*a/3)]
r43 = [0.5*a, np.sqrt(3)*a/6, np.sqrt(2*a/3)]


r = [np.transpose(r21),np.transpose(r31), np.transpose(r41),np.transpose(r32) , np.transpose(r42), np.transpose(r43)]
X = np.transpose(r) / C


t = [t21, t31, t41, t32, t42, t43]
T = np.transpose(t)

#r = np.empty(3, dtype=object)
r = np.divide(T, X)
r = np.transpose(r)

def theta():
    return np.rad2deg(np.arccos(r[2]/np.linalg.norm(r)))

def phi():
   return np.rad2deg(np.arctan( r[0] / r[1] ))


print("r-vec: ", r)
print("T-vec: ", T)
print("Value of theta: ", theta())
print("Value of phi: ", phi())
