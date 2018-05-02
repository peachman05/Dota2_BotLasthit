local DQN = {} -- the table representing the class, which will double as the metatable for the instances
DQN.__index = DQN -- failed table lookups on the instances should fallback to the class table, to get methods
--local table_print = require("lua/lua/table_print")

function DQN.new(num_input, num_output, hidden_layer)
	local self = setmetatable({}, DQN)

	self.num_input = num_input
	self.num_output = num_output
	self.hidden_layer = hidden_layer

	self.weight_array = {} -- 3 dimension ( layer x node x weight )
	self.bias_array = {} -- 2 dimension (layer x node)

	-- local temp_table = self.hidden_layer
	-- print(temp_table)
	-- table.insert(self.hidden_layer, 1, self.num_input)
	-- for layer = 1, #self.hidden_layer do
	-- 	self.weight_array[layer] = {}
	-- 	self.bias_array[layer] = {}
	-- end




	self.total_weight_layer = #self.weight_array

	self.epsilon = 0.1
	self.memory = {}

	return self

end


function DQN.act(self, state)
	if( RandomFloat(0, 1) < self.epsilon )then
		return RandomInt(1, self.num_output)
	else
		local input_next_layer = state
		for i = 1, (#self.weight_array - 1) do
			FC_result = self:FC(input_next_layer, self.weight_array[i], self.bias_array[i] )
			-- if FC_result
			input_next_layer = self:RELU( FC_result )
		end
		-- print(self.bias_array[#self.weight_array])
		local output = self:FC(input_next_layer, self.weight_array[#self.weight_array], self.bias_array[#self.weight_array])

		if output == nil then
			print("print nulllllllll")
			-- table_print.loop_print(input_next_layer)
		end

		-- for key,value in pairs(output) do
		-- 	print("action: "..key.." "..value)
		-- end

		local output_cal = {}
		local max_i = 1
		for i = 1, self.num_output do
			output_cal[i] = output[i]-- math.exp(fc3[i])
			-- table_print.loop_print(output_cal)
			if output_cal[i] > output_cal[max_i] then
				max_i = i
			end
		end

		action = max_i
		-- print("id output :")
		-- print(output)
		-- table_print.loop_print(output)
		return action, output
	end

end

function DQN.remember(self, mem) --  state, next_state, action, reward
	table.insert( self.memory, mem )
end

function DQN.set_weitght(self, weight_all )
	self.weight_array = weight_all
	self.num_layer = #self.weight_array
	print("num layer :"..self.num_layer)
end

function DQN.set_bias(self, bias_all )
	self.bias_array = bias_all
end

function DQN.FC(self, x, W, b)
	local y = {}
	for j = 1, #b do
		y[j] = 0
		for i = 1, #x do
			y[j] = y[j] + x[i] * W[i][j]
		end
		-- table_print.loop_print(b[j])
		y[j] = y[j] + b[j]
	end
	return y
end


function DQN.RELU(self, x)
	local y = {}
	for i = 1, #x do
		if x[i] < 0 then
			y[i] = 0
		else
			y[i] = x[i]
		end
	end
	return y
end

function DQN.shallowcopy(self, orig)
	local orig_type = type(orig)
	local copy
	if orig_type == 'table' then
		copy = {}
		for orig_key, orig_value in pairs(orig) do
			copy[orig_key] = orig_value
		end
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end


return DQN
