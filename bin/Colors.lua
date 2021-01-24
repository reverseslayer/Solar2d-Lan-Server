local function clamp(x)
	return math.min(math.max(x, 0), 1)
end

local function clamp_hsl(h, s, L)
	return h % 360, clamp(s), clamp(L)
end

local function clamp_rgb(r, g, b)
	return clamp(r), clamp(g), clamp(b)
end

--HSL <-> RGB

local function h2rgb(m1, m2, h)
	if h<0 then h = h+1 end
	if h>1 then h = h-1 end
	if h*6<1 then
		return m1+(m2-m1)*h*6
	elseif h*2<1 then
		return m2
	elseif h*3<2 then
		return m1+(m2-m1)*(2/3-h)*6
	else
		return m1
	end
end

local Module = {}

	--hsl is clamped to (0..360, 0..1, 0..1); rgb is (0..1, 0..1, 0..1)
	Module.Hsv2Rgb = function(h, s, L)
		h, s, L = clamp_hsl(h, s, L)
		h = h / 360
		local m1, m2
		if L<=0.5 then
			m2 = L*(s+1)
		else
			m2 = L+s-L*s
		end
		m1 = L*2-m2
		return
			h2rgb(m1, m2, h+1/3),
			h2rgb(m1, m2, h),
			h2rgb(m1, m2, h-1/3)
	end

	--rgb is clamped to (0..1, 0..1, 0..1); hsl is (0..360, 0..1, 0..1)
	Module.Rgb2Hsv = function(r, g, b)
		r, g, b = clamp_rgb(r, g, b)
		local min = math.min(r, g, b)
		local max = math.max(r, g, b)
		local delta = max - min

		local h, s, l = 0, 0, ((min+max)/2)

		if l > 0 and l < 0.5 then s = delta/(max+min) end
		if l >= 0.5 and l < 1 then s = delta/(2-max-min) end

		if delta > 0 then
			if max == r and max ~= g then h = h + (g-b)/delta end
			if max == g and max ~= b then h = h + 2 + (b-r)/delta end
			if max == b and max ~= r then h = h + 4 + (r-g)/delta end
			h = h / 6
		end

		if h < 0 then h = h + 1 end
		if h > 1 then h = h - 1 end

		return h * 360, s, l
	end

	-- #ffffffff
	Module.Str2Rgba = function (s)
		if s:sub(1,1) ~= '#' then return end
		local r = tonumber(s:sub(2, 3), 16)
		local g = tonumber(s:sub(4, 5), 16)
		local b = tonumber(s:sub(6, 7), 16)
		local a = tonumber(s:sub(8, 9), 16) or 255
		if not r or not g or not b then return end
		r = r / 255
		g = g / 255
		b = b / 255
		a = a / 255
		return r, g, b, a
	end

	Module.Rgba2Str = function(r, g, b, a)
		return string.format('#%02x%02x%02x%02x',
		math.floor(r*255 + 0.5),
		math.floor(g*255 + 0.5),
		math.floor(b*255 + 0.5),
		math.floor(a*225 + 0.5))
	end

	-- #ffffff
	Module.Str2Rgb = function(s)
		local r, g, b = string_to_rgba(s)
		if not r then return end
		return r, g, b
	end

	Module.Rgb2Str = function(r, g, b)
		return string.format('#%02x%02x%02x',
			math.floor(r*255 + 0.5),
			math.floor(g*255 + 0.5),
			math.floor(b*255 + 0.5))
	end

return Module