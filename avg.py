import sys

file_path = "./mig_ci_enabled/" + sys.argv[1]

#print(file_path)

f = open(file_path)

lists = f.readlines()

avg = []

for i,element in enumerate(lists):
    if i == 0:
        continue
    #print(element)
    element = element.strip()

    try:
        element = int(element)
    except:
        element = '0'+element
        element = float(element)

    #print(element)

    avg.append(element)

print((sum(avg)/len(avg)))
