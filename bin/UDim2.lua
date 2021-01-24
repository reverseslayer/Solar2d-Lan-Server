local UDim2 = {}

function UDim2.new(xS, xO, yS, yO)
	
	local mt = {
		metaType = "UDim2",
		_xS = xS,
		_xO = xO,
		_yS = yS,
		_yO = yO,
		x = (xS * display.actualContentWidth) + xO,
		y = (yS * display.actualContentHeight) + yO,
	}

	function mt.lerp (goal, alpha)
		local uxS = mt["_xS"] + alpha * (goal["_xS"] - metaTable["_xS"])
		local uxO = mt["_xO"] + alpha * (goal["_xO"] - metaTable["_xO"])
		local uyS = mt["_yS"] + alpha * (goal["_yS"] - metaTable["_yS"])
		local uyO = mt["_yO"] + alpha * (goal["_yO"] - metaTable["_yO"])
		return UDim2.new( uxS, uxO, uyS, uyO )
	end

	local ft = {
		__add = function (this, other)
			if (this.metaType == "UDim2" and other.metaType == "UDim2") then
				this._xS = this._xS + other._xS
				this._xO = this._xO + other._xO
				this._yS = this._yS + other._yS
				this._yO = this._yO + other._yO
				this.x = (this._xS * display.actualContentWidth) + this._xO
				this.y = (this._yS * display.actualContentHeight) + this._yO
				return this
			else
				error("Both data types must be UDim2")
			end
		end,
		__sub = function (this, other)
			if (this.metaType == "UDim2" and other.metaType == "UDim2") then
				this._xS = this._xS - other._xS
				this._xO = this._xO - other._xO
				this._yS = this._yS - other._yS
				this._yO = this._yO - other._yO
				this.x = (this._xS * display.actualContentWidth) + this._xO
				this.y = (this._yS * display.actualContentHeight) + this._yO
				return this
			else
				error("Both data types must be UDim2")
			end
		end,
		__newindex = function(table, key, value)
			if key == "xScale" then
				_xS = value
			elseif key == "xOffset" then
				_xO = value
			elseif key == "yScale" then
				_yS = value
			elseif key == "yOffset" then
				_yO = value
			end
			mt.x = (mt._xS * display.actualContentWidth) + mt._xO
			mt.y = (mt._yS * display.actualContentHeight) + mt._yO
		end
	}

	return setmetatable(mt, ft)
end

function UDim2:FromOffset( xO, yO )
	return UDim2.new(0, xO, 0, yO)
end

function UDim2:FromScale( xS, yS )
	return UDim2.new(xS, 0, yS, 0)
end

return UDim2