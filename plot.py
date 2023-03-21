import os
import sys
import matplotlib.pyplot as plt
import math
import matplotlib.ticker as mticker


X = [*range(0,20001,1250)]
X[0] = X[0] +1 

del X[11]
print(X)
print(len(X))


enabled_Y = [0.96,1.005,1.272,1.809,2.603,3.733,5.291,7.054,9.191,12.317,15.438,23.513,28.933,34.760,41.154,48.105]

disabled_Y = [0.384,0.651,1.562,3.117,5.319,8.342,12.029,16.553,21.859,28.148,35.317,52.249,63.227,74.384,87.178,100.213]

print(len(enabled_Y),len(disabled_Y))

plt.figure(figsize=(8,6))
plt.plot(X,enabled_Y,label='MIG Enabled', color='blueviolet')
plt.plot(X,disabled_Y,label='MIG Disabled',color='forestgreen')
plt.legend()
plt.gca().spines['right'].set_visible(False) #오른쪽 테두리 제거
plt.gca().spines['top'].set_visible(False) #위 테두리 제거
plt.gca().yaxis.set_major_formatter(mticker.FuncFormatter(lambda x, p: format(int(x), ',')))
plt.title("MIG Perf Test")
plt.ylabel("\nExecution Time (s)")
plt.xlabel("Size of calculated matrix (r'$4n^2$')")
plt.xticks(X,rotation=45)
plt.show()

