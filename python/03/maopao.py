l2 = [1,3,2,6,8,1,20,3,40]

for i in range(len(l2)-1,0,-1):
    for j in range(i):
        if l2[j] > l2[j + 1]:
            tmp = l2[j]
            l2[j] = l2[j + 1]
            l2[j + 1] = tmp
print l2
