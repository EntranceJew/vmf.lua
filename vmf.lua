local vmf = {}

local function trim_both(s)
	return s:match "^%s*(.-)%s*$"
end

local function split(str, sep)
	local sep, fields = sep or ":", {}
	local pattern = string.format("([^%s]+)", sep)
	str:gsub(pattern, function(c) fields[#fields+1] = c end)
	return fields
end

local function splitComment(str)
	local res = {str:find("(//)")}
	if not res[1] then
		return str, ""
	else
		return str:sub(0,res[1]-1), str:sub(res[2]+1)
	end
end

-- this isn't perfect, but also this format is weird
-- and I make the rules
local function getQuotedTokens(str)
	local res
	local tokens = {}
	
	while str:find("\"") do
		res = {str:find("\"([^\"]+)\"")}
		table.insert(tokens, str:sub(res[1]+1, res[2]-1))
		str = str:sub(res[2]+2)
	end
	
	return unpack(tokens)
end

function vmf.load(filename)
	-- the vmf, as a lua table
	local t = {__root__ = {}}
	-- how deep the parser is into an object
	-- last key passed
	local last_key = "__root__"
	-- key stack
	local keys = {"__root__"}
	-- current table
	local ct = t["__root__"]
	-- the current read line, trimmed of whitespace
	local tline
	-- if the line contains a comment, split it to 'before' and 'after'
	local comment
	-- process keys for structs
	local token_key, token_value
	-- key index
	local keydex
	
	-- master identifier loop
	for line in love.filesystem.lines(filename) do
		keydex = 0
		
		-- trim the line
		tline = trim_both(line)
		-- ensure we have a comment
		tline, comment = splitComment(tline)
		-- re-trim the beginning of the line
		tline = trim_both(tline)
		
		if tline then
			-- only if we have lines
			if tline:find("^\"") then
				-- line begins with quotes, we found tokens
				token_key, token_value = getQuotedTokens(tline)
				ct[token_key] = token_value
				print("found tokens", token_key, token_value)
			elseif tline:find("^{") then
				-- line begins with brace, enter structure
				-- increase depth and note the key
				table.insert(keys, last_key)
				print("entering struct for", last_key)
				if last_key == 'visgroup' then
					print_r( t )
				end
				
				-- if this key has no other records, make room for records of this type
				-- e.g. 'versioninfo'
				-- t = { __root__ = { versioninfo = {} } }
				if not ct then
					print("help")
				end
				
				if not ct[last_key] then
					-- testing for first-of-name
					print("christened value", last_key)
					ct[last_key] = {}
				end
				
				-- enter to per-record-level access
				ct = ct[last_key]
				
				-- make a new record, leave a trail
				ct[#ct] = {}
				last_key = #ct
				print("entering struct for", last_key)
				table.insert(keys, last_key)
				ct = ct[last_key]
				--[[
				-- create an entry for this instance
				table.insert(ct[last_key], {})
				
				-- advance into the freshly inserted element
				ct = ct[last_key][ #ct[last_key] ]
				]]
			elseif tline:find("^}") then
				-- line ends with brace, exit structure
				-- decrease depth and unset the key
				print("exiting struct for", last_key)
				keys[#keys] = nil
				last_key = keys[#keys]
				print("now in", last_key)
				print("exiting struct for", last_key)
				keys[#keys] = nil
				last_key = keys[#keys]
				print("now in", last_key)
				
				-- rewalk the dom to get back to where we should be
				ct = t
				for i=1, #keys do
					ct = ct[keys[i]]
					last_key = keys[i]
				end
				print("verifying", last_key)
			else
				-- plaintext key, likely the start of a structure
				last_key = tline
				print("found key", last_key)
			end
		end
	end
	
	return t
end

return vmf