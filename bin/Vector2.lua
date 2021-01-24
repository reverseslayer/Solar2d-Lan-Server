local Vector2 = {}

function Vector2.new(X, Y)
	local metaTable = setmetatable({
			metaType = "Vector2",
			x = X,
			y = Y,
		},
		{
			__add = function (this, other)
				if (this.metaType == "Vector2" and other.metaType == "Vector2") then
					this.x = this.x + other.x
					this.y = this.y + other.y
					return this
				else
					error("Both data types must be Vector2")
				end
			end,
			__sub = function (this, other)
				if (this.metaType == "Vector2" and other.metaType == "Vector2") then
					this.x = this.x - other.x
					this.y = this.y - other.y
					return this
				else
					error("Both data types must be Vector2")
				end
			end,
			__mul = function (this, other)
				if (this.metaType == "Vector2" and other.metaType == "Vector2") then
					this.x = this.x * other.x
					this.y = this.y * other.y
					return this
				elseif (this.metaType == "Vector2" and type(other) == "number") then
					this.x = this.x * other
					this.y = this.y * other
					return this
				else
					error("Both data types must be Vector2 or number")
				end
			end,
			__div = function (this, other)
				if (this.metaType == "Vector2" and type(other) == "number") then
					this.x = this.x / other.x
					this.y = this.y / other.y
					return this
				elseif (this.metaType == "Vector2" and type(other) == "number") then
					this.x = this.x / other
					this.y = this.y / other
					return this
				else
					error("Both data types must be Vector2 or number")
				end
			end,
		})

		function metaTable.Magnitude()
			return math.sqrt( metaTable["x"]^2 + metaTable["y"]^2 )
		end

		function metaTable.Unit()
			local magnitude = metaTable.Magnitude()
			local ux = metaTable["x"] / magnitude
			local uy = metaTable["y"] / magnitude
			return Vector2.new( ux, uy )
		end

		function metaTable:Lerp(goal, alpha)
			local ux = metaTable["x"] + alpha * (goal["x"] - metaTable["x"])
			local uy = metaTable["y"] + alpha * (goal["y"] - metaTable["y"])
			return Vector2.new( ux, uy )
		end

		function metaTable:Dot(other)
			return metaTable["x"] * other["x"] + metaTable["y"] * other["y"]
		end

	return metaTable
end

return Vector2