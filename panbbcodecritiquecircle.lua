-- panbbcodeCritiqueCircle - BBCode writer for pandoc
-- Copyright (C) 2017 robwhitaker
-- Based on:
--     panbbcodeVBulletin, Copyright (C) 2015 Kerbas_ad_astra
--     panbbcode, Copyright (C) 2014 Jens Oliver John < dev ! 2ion ! de >
-- Licensed under the GNU General Public License v3 or later.
-- Written for Lua 5.{1,2}

-- PRIVATE

local function enclose(t, s, p)
	if p then
		return string.format("[%s=%s]%s[/%s]", t, p, s, t)
	else
		return string.format("[%s]%s[/%s]", t, s, t)
	end
end

-- PUBLIC

local cache_notes = {}

function Doc( body, meta, vars )
	local buf = {}
	local function _(e)
		table.insert(buf, e)
	end
	if meta['title'] and meta['title'] ~= "" then
		_(meta['title'])
	end
	_(body)
	if #cache_notes > 0 then
		_("--")
		for i,n in ipairs(cache_notes) do
			_(string.format("[%d] %s", i, n))
		end
	end
	return table.concat(buf, '\n')
end

function Str(s)
	return s
end

function Space()
	return ' '
end

function LineBreak()
	return '\n'
end

function Emph(s)
	return enclose('i', s)
end

function Strong(s)
	return enclose('b', s)
end

function Subscript(s)
	return s
end

function Superscript(s)
	return s
end

function SmallCaps(s)
	return s
end

function Strikeout(s)
	return enclose('y', s)
end

function Link(s, src, title)
	return enclose('url', s, src)
end

function Image(s, src, title)
	return ''
end

function CaptionedImage(src, attr, title)
	return ''
end

function Code(s, attr)
	return enclose('quote', s)
end

function InlineMath(s)
	return s
end

function DisplayMath(s)
	return s
end

function Note(s)
	table.insert(cache_notes, s)
	return string.format("[%d]", #cache_notes)
end

function Span(s, attr)
	return s
end

function Plain(s)
	return s
end

function Para(s)
	return s
end

function Header(level, s, attr)
	return "[c]<h" .. level .. ">" .. s .. "</h" .. level .. ">[/c]"
end

function BlockQuote(s)
	local a, t = s:match('@([%w]+): (.+)')
	if a then
		return enclose('quote', '\n' .. t or "Unknown" .. '\n', a)
	else
		return enclose('quote', '\n' .. s .. '\n')
	end
end

function Cite(s)
	return s
end

function Blocksep(s)
	return "\n"
end

function HorizontalRule(s)
	return '<hr/>'
end

function CodeBlock(s, attr)
	return enclose('quote', '\n' .. s .. '\n')
end

local function makelist(items, ltype)
	local buf = ""
	local index = 1
	for _,e in ipairs(items) do
		if index > 1 then
			buf = buf .. '\n'
		end
		if ltype == '1' then
			buf = buf .. string.format('%d. %s', index, e)
		else 
			buf = buf .. string.format('%s %s', ltype, e)
		end
		index = index + 1
	end
	return buf
end

function BulletList(items)
	return makelist(items, '*')
end

function OrderedList(items)
	return makelist(items, '1')
end

function DefinitionList(items)
	local buf = ""
	local function mkdef(k,v)
		return string.format("%s: %s\n", enclose('b', k), v)
	end
	for _,e in ipairs(items) do
		for k,v in pairs(items) do
			buf = buf .. mkdef(k,v)
		end
	end
	return buf
end

function html_align(align)
	return ""
end

function Table(cap, align, widths, headers, rows)
	return ''
end

function Div(s, attr)
	return s
end

function DoubleQuoted(s)
	return '“' .. s .. '”'
end

function SingleQuoted(s)
	return "‘" .. s .. "’"
end

-- boilerplate

local meta = {}
meta.__index =
	function(_, key)
		io.stderr:write(string.format("WARNING: Undefined function '%s'\n",key))
		return function() return "" end
	end
setmetatable(_G, meta)
