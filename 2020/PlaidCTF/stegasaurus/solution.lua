function swap(arr, i, j)
	local t = arr[i]
	arr[i] = arr[j]
	arr[j] = t
	return arr
end

function nextPermutation(arr)
	local k, l, t
	local n = #arr
	k = n
	
	while (k > 1 and arr[k-1] >= arr[k])
	do
		k = k - 1
	end
	if (k == 1)
	then
		return arr
	end
	k = k - 1
	l = n
	while (arr[l] <= arr[k])
	do
		l = l - 1
	end
	swap(arr, k, l)
	k = k + 1
	l = n
	while (k < l) do
		swap(arr, k, l)
		k = k + 1
		l = l - 1
	end
	return arr
end

PERMS = {}
tperm = {1, 2, 3, 4, 5, 6, 7}
for i = 1, 5001 do
	table.insert(PERMS, {table.unpack(tperm)})
	nextPermutation(tperm)
end


function Alice1 (hand)
	local sm = 0
	for i = 1, 8 do
		sm = sm + hand[i]
	end
	sm = sm % 8
	table.sort(hand)
	local chosen = hand[sm + 1]
	local ans = {}
	for i = 1, 8 do 
		if (hand[i] ~= chosen)
		then
			table.insert(ans, hand[i])
		end
	end
	local chosem_rem = chosen % 8
	local card_pos = (chosen - 1) // 8
	
	local perm_to_apply = PERMS[card_pos + 1]
	--for i = 1, card_pos do
	--	nextPermutation(ans)
	--end
	local ans2 = {}
	for i = 1,7 do
		local t = perm_to_apply[i]
		ans2[i] = ans[t]
	end
	return ans2
	--return {1, 1, 1, 1, 1, 1}
end

function tableEqual(a, b)
	local n = #a
	for i = 1, n do
		if (a[i] ~= b[i]) then
			return false
		end
	end
	return true
end

FACTORIAL = {1, 2, 6, 24, 120, 720, 5040}

function Bob1 (hand)
	local tmp = {table.unpack(hand)}
	table.sort(tmp)
	local card_pos = 0
	--while (not tableEqual(tmp, hand)) do
	--	card_pos = card_pos + 1
	--	nextPermutation(tmp)
	--end
	for i = 1, 6 do
		local les = 0
		for j = i+1, 7 do
			if hand[j] < hand[i] then
				les = les + 1
			end
		end
		card_pos = card_pos + les * FACTORIAL[7 - i]
	end
	local handSum = 0
	for i = 1, #hand do
		handSum = handSum + hand[i]
	end
	table.sort(tmp)
	local cmin = 1 + 8 * card_pos
	for i = cmin, (cmin+8 - 1) do
		local ts = (handSum + i) % 8
		local good = true
		if (ts < 7) then
			if (i >= tmp[ts + 1]) then
				good = false
			end
		end
		if (ts > 0) then
			if (i <= tmp[ts]) then
				good = false
			end
		end
		if (good) then
			return i
		end
	end
	return -1
end


function transform2(hand)
	local minp = 1
	local minpv = 0
	local csum = 0
	local v2 = {}
	for i = 1, #hand do
		v2[i] = 0
		if hand[i] == 1 then
			csum = csum + 1
		else
			csum = csum - 1
		end
		if csum < minpv then
			minpv = csum
			minp = i
		end
	end
	local i = 0
	local bt = 0
	while (i < 96 or bt > 0) do
		local p = 1 + ((minp - 1 + i) % 96)
		if i < 96 and hand[p] == 1 then
			bt = bt + 1
		else
			if v2[p] == 0 and bt > 0 then
				v2[p] = 1
				bt = bt - 1
			end
		end
		i = i + 1
	end
	return v2
end

function Alice2 (hand)
	for i = 1, #hand do
		hand[i] = hand[i] - 1
	end
	local rotated = transform2(hand)
	local res = {}
	for i = 1, #hand do
		if rotated[i] == 1 then
			table.insert(res, i)
		end
	end
	return res
	--return ans
end

function reverse(hand)
	local l = 1
	local r = #hand
	while l < r do
		swap(hand, l, r)
		l = l + 1
		r = r - 1
	end
	return hand
end

function Bob2 (hand)
	for i = 1, #hand do
		hand[i] = 1 - hand[i]
	end
	reverse(hand)
	local rotated = transform2(hand)
	reverse(rotated)
	local res = {}
	for i = 1, #hand do
		if rotated[i] == 1 then
			table.insert(res, i)
		end
	end
	--return {-1}
	return res
end

