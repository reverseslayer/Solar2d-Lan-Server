local Vector3 = {}

function Vector3.new(X, Y, Z)
	local metaTable = setmetatable({
			metaType = "Vector3",
			x = X,
			y = Y,
			z = Z,
		},
		{
			__add = function (this, other)
				if (this.metaType == "Vector3" and other.metaType == "Vector3") then
					this.x = this.x + other.x
					this.y = this.y + other.y
					this.z = this.z + other.z
					return this
				else
					error("Both data types must be Vector3")
				end
			end,
			__sub = function (this, other)
				if (this.metaType == "Vector3" and other.metaType == "Vector3") then
					this.x = this.x - other.x
					this.y = this.y - other.y
					this.z = this.z - other.z
					return this
				else
					error("Both data types must be Vector3")
				end
			end,
			__mul = function (this, other)
				if (this.metaType == "Vector3" and other.metaType == "Vector3") then
					this.x = this.x * other.x
					this.y = this.y * other.y
					this.z = this.z * other.z
					return this
				elseif (this.metaType == "Vector3" and type(other) == "number") then
					this.x = this.x * other
					this.y = this.y * other
					this.z = this.z * other
					return this
				else
					error("Both data types must be Vector3 or number")
				end
			end,
			__div = function (this, other)
				if (this.metaType == "Vector3" and type(other) == "number") then
					this.x = this.x / other.x
					this.y = this.y / other.y
					this.z = this.z / other.z
					return this
				elseif (this.metaType == "Vector3" and type(other) == "number") then
					this.x = this.x / other
					this.y = this.y / other
					this.z = this.z / other
					return this
				else
					error("Both data types must be Vector3 or number")
				end
			end,
		})

		function metaTable.Magnitude()
			return math.sqrt( metaTable["x"]^2 + metaTable["y"]^2 + metaTable["z"]^2 )
		end

		function metaTable.Unit()
			local magnitude = metaTable.Magnitude()
			local ux = metaTable["x"] / magnitude
			local uy = metaTable["y"] / magnitude
			local uz = metaTable["z"] / magnitude
			return Vector3.new( ux, uy, uz)
		end

		function metaTable:Lerp(goal, alpha)
			local ux = metaTable["x"] + alpha * (goal["x"] - metaTable["x"])
			local uy = metaTable["y"] + alpha * (goal["y"] - metaTable["y"])
			local uz = metaTable["z"] + alpha * (goal["z"] - metaTable["z"])
			return Vector3.new( ux, uy, uz)
		end

		function metaTable:Dot(other)
			return metaTable["x"] * other["x"] + metaTable["y"] * other["y"] + metaTable["z"] * other["z"]
		end

		function metaTable:Cross(other)
			local ux = metaTable["y"] * other["z"] - metaTable["z"] * other["y"]
			local uy = metaTable["z"] * other["x"] - metaTable["x"] * other["z"]
			local uz = metaTable["x"] * other["y"] - metaTable["y"] * other["x"]
			return Vector3.new( ux, uy, uz)
		end

	return metaTable
end

return Vector3