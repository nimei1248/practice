lists = [1,2,3,2,12,3,1,3,21,2,2,3,4111,22,3333,444,111,4,6,777,65555,45,33,45]

def bubble_sort(lists):
    count = len(lists)
    for i in range(0, count):
        for j in range(i + 1, count):
            if lists[i] > lists[j]:
                lists[i], lists[j] = lists[j], lists[i]
    return lists
print bubble_sort(lists)
