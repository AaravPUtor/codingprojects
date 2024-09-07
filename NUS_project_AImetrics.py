import matplotlib.pyplot as plt
import numpy as np

# Mileage
x1 = np.array([0, 4, 8, 12, 16, 20, 24, 28, 32])

# Tire tread depth
y1 = np.array([394.33, 329.50, 291.00, 255.17, 229.33, 204.83, 179.00, 163.83, 150.33])

Xtranspose = np.array([np.ones(9),x1])
X=Xtranspose.transpose()
Y=y1.transpose()
Z = np.matmul(Xtranspose,X)
Zinverse=np.linalg.inv(Z)
Z2=np.matmul(Zinverse,Xtranspose)
Z3=np.matmul(Z2,Y)

#created prediction 1 for y = mx+c
c = Z3[0]
m = Z3[1]
yprediction_1=m*x1+c

print("3a): ""y=",m,"x+",c)

#take the first 8 elements
x2 = x1[0:8]
y2 = y1[0:8]

Xtranspose = np.array([np.ones(8),x2])
X=Xtranspose.transpose()
Y=y2.transpose()
Z = np.matmul(Xtranspose,X)
Zinverse=np.linalg.inv(Z)
Z2=np.matmul(Zinverse,Xtranspose)
Z3=np.matmul(Z2,Y)
c = Z3[0]
m = Z3[1]
yprediction_2=m*x2+c

print("3b): According to the graph plotted, the best line of fit for the first prediction does not effectively map the data since it fails to intercept or equally distribute plots as seen on the grap (blue line)")
print("3c): y =",m,"x+",c)

y9=m*x1[8]+c
q=(y9-y1[8])**2
print("The predicted y9 is:",y9,"\n", "The true y9 is:", y1[8], "\n", "Squared test error:",q)



fig, ax = plt.subplots(1, 1, figsize=(6, 3))
ax.plot(x1, y1, 'bo')
ax.plot(x1, yprediction_1, 'b')
ax.plot(x2, yprediction_2, 'r')
plt.xlabel("x")
plt.ylabel("y")
plt.grid()
plt.show()

print(u'\u2500' * 110)
