import os
import sys
import matplotlib.pyplot as plt
import math
import matplotlib.ticker as mticker


X = [*range(0,20001,1250)]
X[0] = X[0] +1 

#del X[11]
print(X)
print(len(X))

f_enabled = open("result_of_mig_enabled.txt",r)
lists_ = f_enabled.readlines()
enabled_Y = []
for element in lists_:
    enabled_Y.append(round(element,2))

f_disabled = open("result_of_mig_disabled.txt",r) 
lists = f_disabled.readlines()
disabled_Y = []
for element in lists:
    disabled_Y.append(round(element,2))

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
plt.grid()
plt.show()

