#!/bin/env python3

a = []


K = 4
N = K * 3

def format_bin(v,n):
	return str.rjust(bin(v)[2:], n, '0')
	
def arr_to_bitset(v, n):
	t = 0
	for i in v:
		t |= (1 << i)
	return t

def arr_from_bitset(v, n):
	return [i for i in range(n) if (v & (1 << i)) !=0]
	
def format_arr(v, n):
	return format_bin(arr_to_bitset(v, n), n)
	
def gen_foo(n, k):
	if n == 0:
		if k == 0:
			return [0]
		else:
			return []
	ans = []
	if k > 0:
		s1 = gen_foo(n-1, k-1)
		ans += [(1<<(n-1)) | v for v in s1]	
	ans += gen_foo(n-1, k)
	return ans
	

#a = gen_foo(N, K)

c = Combinations(N, K)
csmall = Combinations(K*2, K)

csmall_len = len(csmall.list())

MASK_MAX = (1 << N)-1

def next_c1(cm):
	r = c.rank(cm)
	r = r % csmall_len
	
	left = list(range(N))
	for v in cm:
		left.remove(v)
	cs2 = Combinations(left, K)
	res = cs2.unrank(r)
	return res


def g1(n):
	if n == 0:
		return [0]
	a = g1(n-1)
	b = a.copy()[::-1]
	return a + [(1 << (n-1)) + v for v in b]


#arr = g1(6)
#arr = [v for v in arr if v.popcount() == 2]
#for v in arr:
#	print(format_bin(v, 6))

#exit(1)

def next_c2(cm, o=0):
	#r = c.rank(cm) + o
	r = arr_to_bitset(cm, N) + o #c.rank(cm) + o
	r = r % csmall_len
	
	left = range(N)
	left = list(left)
	for v in cm:
		left.remove(v)
	cs2 = Combinations(left, K)
	res = cs2.unrank(r)
	return res

def next_c(cm, o=0):
	#r = c.rank(cm) + o
	#	r = arr_to_bitset(cm, N) + o #c.rank(cm) + o
	#r = r % csmall_len
	v = arr_to_bitset(cm, N)
	minp = 0
	minpv = 0
	bt = 0
	for i in range(N):
		if v & (1 << i):
			bt +=1
		else:
			bt -= 1
		if bt < minpv:
			minpv = bt
			minp = i
			
	v2 = 0
	i = 0
	bt = 0
	while i < N or bt > 0:
		p = ((minp + i) % N)
		if i < N and (v & (1 << p)):
			bt += 1
		elif (v2 & (1 << p)) == 0 and bt > 0:
			bt -= 1
			v2 |= (1 << p)
		i += 1
	if v2.popcount() != K:
		raise "bad count"
	if (v & v2) > 0:
		raise "overlap"
	return arr_from_bitset(v2, N)
	
	

def prev_c(cm, o=0):
	def rev(v):
		return [N - 1 - a for a in v]
	return sorted(rev(next_c(rev(cm))))

count_big = len(c.list())
#print(f"cbig {count_big}")



def foo(ai):
	i = 0
	seen = set()
	while i < 20:
		print(f"{format_arr(ai, N)} {i} {c.rank(ai)}")
		i += 1
		if tuple(ai) in seen:
			break
		seen.add(tuple(ai))
		ai = next_c(ai)
	
#for i in range(count_big):
#	foo(c.unrank(i))
#	print("-------")

def is_perfect(k):
	mpc = {}
	for i in range(count_big):
		a = c.unrank(i)
		nextv = next_c(a)
		next_id = c.rank(nextv)
		mpc[next_id] = mpc.get(next_id, 0)+1
	it = list(mpc.items())
	if len(it) != count_big:
		return False
	for index,count in it:
		if count != 1:
			return False
	return True

#for off in range(70):
#	if is_perfect(off):
#		print(f"goooood {off}")
#	else:
#		print("b")
		
def print_dot():
	print("digraph {")
	for i in range(count_big):
		a = c.unrank(i)
		nextv = next_c(a)
		prevv = prev_c(nextv)
		if a != prevv:
			print(f"bad {a}, {prevv}")
			break
		next_id = c.rank(nextv)
		print(f"{i} -> {next_id}")

	print("}")

print_dot()
