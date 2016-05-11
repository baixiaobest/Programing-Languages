'''
Scripting language:

- today any dynamically typed programming languages
- python javascript perl php

- features:
	- easy manipulation of text data (regular expression matching)
	- easy interaction with the system (files, processes, etc.)
	- convenient syntax for lots of common operations

- disadvantages:
	- dynamically typed
	- kitchen sink approach
		- functional core
		- objects
		- imperative

- key point
	- the core of Python is MOCaml

'''

s = '34'
list(s)
tuple(s)

# referencing and copying
l = [1,2,3]
l2 = l     #l2 is referencing l

l2 = list(l) #l2 is a copy of l

def prodList(l):
	result = 1
	for i in l:
		result *= i
	return result


# map
f = (lambda x: x+1)

map(f,[1,2,3,4,5])

map(lambda x:x+1, [1,2,3,4,5])

# pattern matching
l = [(1,2),(3,4),(5,6)]
for (x,y) in l:
	print (x+y)

# reduce
reduce(lambda x,y: x+y, [1,2,3,4,5])

# comprehension
map(lambda x:x+1, l)
[x+1 for x in l]


# filter
map(lambda x:x+1, filter(lambda x: x>3, l))

[x+1 for x in l if x>3]

# cross product
l1 = [1,2,3]
l2 = [4,5,6]
[(x,y) for x in l1 for y in l2]


# dictionary
r = {"name": "myrect", "width": 3.1, "height": 2.4}
r["name"] = "baixiao"

# given a list of ints, make a dictionary mapping each element to its frequency

def frequency(l):
	d = {}
	for i in l:
		if i in d:
			d[i] += 1
		else:
			d[i] = 1
	return d

frequency([1,2,3,1,4,2,4,4,3,5])






