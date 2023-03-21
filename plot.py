import os
import sys
import matplotlib.pyplot as plt
import math
import matplotlib.ticker as mticker


X = [*range(0,20001,1250)]
X[0] = X[0] +1 

print(X)



enabled_Y = [0.96,1.005,1.272,1.809,2.603,3.733,5.291,7.054,9.191,12.317,15.438,23.513,28.933,34.760,41.154,48.105]

disabled_Y = []

plt.figure(figsize=(8,6))
plt.plot(X,enabled_Y,label='GDR Enabled', color='blueviolet')
plt.plot(X,disabled_Y,label='GDR Disabled',color='forestgreen')
plt.legend()
plt.gca().spines['right'].set_visible(False) #오른쪽 테두리 제거
plt.gca().spines['top'].set_visible(False) #위 테두리 제거
plt.gca().yaxis.set_major_formatter(mticker.FuncFormatter(lambda x, p: format(int(x), ',')))
plt.title("Cryptanalysis System")
plt.ylabel("\nProgram Execution Time (s)")
plt.xlabel("Size of Column (N) on Square Matrix")
plt.xticks(enabled_X,rotation=45)
plt.savefig(homedir+'forplot/plot/'+filepath.split('/')[1]+'.png')


