--[[!

	@name		Dharma
	@author		Constantin Schomburg <xconstruct@gmail.com>
	@version	0.1

	@section DESCRIPTION

	Dharma is a framework for Creative Zen X-Fi 2 Applications.
	The core introduces methods for creating OOP classes and
	handles loading of additional files, including the GUI widgets.

	@section LICENSE

    Dharma: A Framework for Creative Zen X-Fi 2 Applications

    Copyright (C) 2010  Constantin Schomburg <xconstruct@gmail.com>

    This file is part of Dharma.

    Dharma is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 2 of the License, or
    (at your option) any later version.

    Dharma is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Dharma.  If not, see <http://www.gnu.org/licenses/>.
]]

--[[!
	@section Data
	Manages the permanent storage of tables in files
]]

local Data = {}
Dharma.Data = Data

local databases = {}
local DataBase = {}
DataBase.__index = DataBase

--[[!
	@fn database = Data.Get(name [, defaults])
	Load the specified data table from its file or create a new one
	@param name The name of the database
	@param defaults A table used for default values [optional]
	@return database The new data table
]]
function Data.Get(name, defaults)
	if(databases[name]) then return databases[name] end

	local db, contents
	local file = io.open(name..".data.lua", "r")
	if(file) then
		local contents = file:read("*a")
		file:close()
		db = #contents > 0 and assert(loadstring("return "..contents))() or {}
	else
		db = {}
	end
	databases[name] = db
	return defaults and setmetatable(db, defaults) or db
end

local tableToText
local noescape = {["\a"] = "a", ["\b"] = "b", ["\f"] = "f", ["\n"] = "n", ["\r"] = "r", ["\t"] = "t", ["\v"] = "v"}
local function escape(c) return "\\".. (noescape[c] or c:byte()) end

local function exportValue(v, allowTable)
	if(type(v) == "string") then
		return "'"..v:gsub("([\001-\031\128-\255])", escape):gsub("\'", "\\\'").."'"
	elseif(type(v) == "number") then
		return v
	elseif(type(v) == "boolean") then
		return tostring(v)
	elseif(allowTable and type(v) == "table") then
		return tableToText(v)
	end
end

tableToText = function(tbl)
	local text = ""
	for k,v in pairs(tbl) do
		k,v = exportValue(k), exportValue(v, true)
		if(k and v) then
			text = ("%s[%s]=%s,"):format(text, k, v)
		end
	end
	return "{"..text.."}"
end

--[[!
	@fn Data.Save(name)
	Saves the specified database into a file
	@param name The name of the database
]]
function Data.Save(name)
	if(not databases[name]) then return end

	local file = io.open(name..".data.lua", "w")
	local contents = tableToText(databases[name])
	file:write(contents)
	file:close()
end