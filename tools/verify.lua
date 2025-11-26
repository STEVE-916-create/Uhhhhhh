function verify(buf: buffer)
	local needle = 0
	local buflen = buffer.len(buf)
	local function getleft()
		return buflen - needle
	end
	local function readstring()
		print(needle, "string length expect")
		assert(getleft() >= 2)
		local len = buffer.readu16(buf, needle)
		needle += 2
		print(needle, "string of length " .. len .. " expect")
		assert(getleft() >= len)
		local val = buffer.readstring(buf, needle, len)
		needle += len
		return val
	end
	local function readsizet()
		print(needle, "int expect")
		assert(getleft() >= 4)
		local val = buffer.readu32(buf, needle)
		needle += 4
		return val
	end
	local function readfloat()
		print(needle, "float expect")
		assert(getleft() >= 4)
		local val = buffer.readf32(buf, needle)
		needle += 4
		return val
	end
	readstring()
	local nkeyframes = readsizet()
	for _ = 1, nkeyframes do
		readfloat()
		local nposes = readsizet()
		for _ = 1, nposes do
			readstring()
			readfloat()
			readstring()
			readstring()
			for _ = 1, 12 do readfloat() end
		end
	end
end

verify(buffer.fromstring("[DATAINSERTION]"))