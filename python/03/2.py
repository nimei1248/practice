# *-* coding:utf-8 *-*

statistics = {}

with open('1.txt','r') as f:
    for line in f:
        if line.strip():
            ## client access domain
            try:
                domain = line.split('の')[4]
            except IndexError,e:
                continue

            print domain
            statistics[domain] = statistics.get((domain),0) + 1

print statistics
