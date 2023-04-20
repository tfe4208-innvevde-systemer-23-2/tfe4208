import numpy as np

t21 = 1 
t31 = 2
t41 = 3 
t32 = 5
t42 = 4
t43 = 1
T = np.transpose([t21, t31, t41, t32, t42, t43])
T_tT = np.matmul(T, np.transpose(T))


C = 343.3 # m/s 
a = 0.075
#t21, t31, t41, t32, t42, t43 = 1
r21 = [-0.5*a, np.sqrt(3)*a/2, 0] 
r31 = [-a, 0, 0] 
r41 = [-0.5*a, a*np.sqrt(3)/6, np.sqrt(2*a/3)]
r32 = [-0.5*a, -np.sqrt(3)*a/2, 0]
r42 = [0, -np.sqrt(3)*a/3, np.sqrt(2*a/3)]
r43 = [0.5*a, np.sqrt(3)*a/6, np.sqrt(2*a/3)]
r = [np.transpose(r21),np.transpose(r31), np.transpose(r41),np.transpose(r32) , np.transpose(r42), np.transpose(r43)]
X = np.transpose(r) / C
X = np.transpose(X)
print(X)

"""
T_tX = np.matmul(np.transpose(T), X)

# Step 2 
lhs = np.dot(T_tT, X)
rhs = T_tX

x = np.linalg.solve(lhs, rhs)
"""

