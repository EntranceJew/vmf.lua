local function print_r ( t )
	local print_r_cache={}
	local function sub_print_r(t,indent)
		if (print_r_cache[tostring(t)]) then
			print(indent.."*"..tostring(t))
		else
			print_r_cache[tostring(t)]=true
			if (type(t)=="table") then
				for pos,val in pairs(t) do
					if (type(val)=="table") then
						print(indent.."["..pos.."] => "..tostring(t).." {")
						sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
						print(indent..string.rep(" ",string.len(pos)+6).."}")
					elseif (type(val)=="string") then
						print(indent.."["..pos..'] => "'..val..'"')
					else
						print(indent.."["..tostring(pos).."] => "..tostring(val))
					end
				end
			else
				print(indent..tostring(t))
			end
		end
	end
	if (type(t)=="table") then
		print(tostring(t).." {")
		sub_print_r(t,"  ")
		print("}")
	else
		sub_print_r(t,"  ")
	end
	print()
end

local vmf = require('vmf')

local example = vmf.load('example.vmf')
-- show the structure of the example
print_r(example)

local materials = {}

local function findAllMaterials(t)
	for k, v in pairs(t) do
		if k == "material" then
			if materials[v] then
				materials[v] = materials[v] + 1
			else
				materials[v] = 1
			end
		end
		
		if type(v) == "table" then
			findAllMaterials(v)
		end
	end
end

findAllMaterials(example)

-- show all the materials that get used
print_r(materials)