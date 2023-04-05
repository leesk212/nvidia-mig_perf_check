import os
import sys
import matplotlib.pyplot as plt
import math
import matplotlib.ticker as mticker

X = [*range(0,40001,2500)]
X[0] = X[0] +2 

Real_X = []

for x in X:
    Real_X.append(format(x,',d'))

X_2 = [*range(0,15000,2500)]
X_2[0] = X_2[0] +2 

print(X)
print(len(X))

f_enabled = open("result_of_mig_enabled.txt",'r')
lists_ = f_enabled.readlines()
enabled_Y = []
for i,element in enumerate(lists_):
    if i == 0:
        continue
    enabled_Y.append(round(float(element),2))

f_disabled = open("result_of_mig_disabled.txt",'r')
lists = f_disabled.readlines()
disabled_Y = []
for i,element in enumerate(lists):
    if i ==0:
        continue
    disabled_Y.append(round(float(element),2))


f_ci = open("result_of_mig_ci_enabled.txt",'r') 
lists = f_ci.readlines()
ci_Y = []
for i,element in enumerate(lists):
    if i ==0:
        continue
    ci_Y.append(round(float(element),2))

print(len(enabled_Y),len(disabled_Y),len(ci_Y))

plt.figure(figsize=(8,6))
plt.plot(X,disabled_Y,label='MIG Disabled', color='forestgreen')
plt.plot(X_2,ci_Y,label='MIG Enabled, CI_Enabled')
plt.plot(X,enabled_Y,label='MIG Enabled, CI_Disabled', color='blueviolet')
plt.legend()
plt.gca().spines['right'].set_visible(False) #오른쪽 테두리 제거
plt.gca().spines['top'].set_visible(False) #위 테두리 제거
plt.gca().yaxis.set_major_formatter(mticker.FuncFormatter(lambda x, p: format(int(x), ',')))
plt.title("MIG Perf Test")
plt.ylabel("\nExecution Time (s)")
plt.xlabel("Size of the column (2n) of calculated matrix")
plt.xticks(X,Real_X,rotation=45)
plt.grid()
plt.show()

