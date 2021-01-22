local UDim2 = {}

function UDim2.new(xS, xO, yS, yO)
	local metaTable = setmetatable({
			metaType = "UDim2",
			xScale = xS,
			xOffset = xO,
			yScale = yS,
			yOffset = yO,
		},
		{
			__add = function (this, other)
				if (this.metaType == "UDim2" and other.metaType == "UDim2") then
					this.xScale = this.xScale + other.xScale
					this.xOffset = this.xOffset + other.xOffset
					this.yScale = this.yScale + other.yScale
					this.yOffset = this.yOffset + other.yOffset
					return this
				else
					error("Both data types must be UDim2")
				end
			end,
			__sub = function (this, other)
				if (this.metaType == "UDim2" and other.metaType == "UDim2") then
					this.xScale = this.xScale - other.xScale
					this.xOffset = this.xOffset - other.xOffset
					this.yScale = this.yScale - other.yScale
					this.yOffset = this.yOffset - other.yOffset
					return this
				else
					error("Both data types must be UDim2")
				end
			end,
		})

		function metaTable.out()
			local V2 = {}
			V2["x"] = (metaTable.xScale * display.actualContentWidth) + metaTable.xOffset
			V2["y"] = (metaTable.yScale * display.actualContentHeight) + metaTable.yOffset
			return V2
		end

		function metaTable.lerp (goal, alpha)

		end

	return metaTable
end

function UDim2:FromOffset( xO, yO )
	return UDim2.new(0, xO, 0, yO)
end

function UDim2:FromScale( xS, yS )
	return UDim2.new(xS, 0, yS, 0)
end

return UDim2