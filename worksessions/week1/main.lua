local agentdata = {
	x = 150,
	y = 150,
	radius = 10,
	vX = love.math.random(-100, 100),
	vY = love.math.random(-100, 100),
	speed = 150,
}

local width, height = love.graphics.getDimensions( );
local proximity = 100;
local maxNeighbors = 5;

local agents = {}

function love.load()
	for i = 1, 100 do
		table.insert(agents, {
			radius = 10,
			x = love.math.random(agentdata.radius, width - agentdata.radius),
			y = love.math.random(agentdata.radius, height - agentdata.radius),
			vX = love.math.random(-100, 100),
			vY = love.math.random(-100, 100),
			a = 0,
			speed = 150,
			crowded = false,
		})
	end
end


local cohesion_behavior = function(agent, neighbors)
	local averageX = 0;
	local averageY = 0;

	for i, neighbor in ipairs(neighbors) do
		averageX = averageX + neighbor.x
		averageY = averageY + neighbor.y
	end

	averageX = averageX / #neighbors;
	averageY = averageY / #neighbors;

	agent.vX = (averageX - agent.x);
	agent.vY = (averageY - agent.y);
end

local seperation_behavior = function(agent, neighbors)
	local averageX = 0;
	local averageY = 0;

	for i, neighbor in ipairs(neighbors) do
		averageX = averageX + neighbor.x
		averageY = averageY + neighbor.y
	end

	averageX = averageX / #neighbors;
	averageY = averageY / #neighbors;

	agent.vX = (agent.x - averageX);
	agent.vY = (agent.y - averageY);
end

local crowded_behavior = function(agent, neighbors)
	if(#neighbors >= maxNeighbors) then
		agent.crowded = true
		seperation_behavior(agent, neighbors);
	end
end

function love.update(dt)

	for i, agent in ipairs(agents) do
		local neighbors = {};
		agent.crowded = false;
		agent.x = (agent.x + (agent.vX * dt)) % width;
		agent.y = (agent.y + (agent.vY * dt)) % height;

		local numClose = 0;

		for j, other in ipairs(agents) do
			if(i ~= j) or (other ~= agent) then

				local dist = math.sqrt((other.x - agent.x)^2 + (other.y - agent.y)^2)

				if(dist < proximity) then
					--print("found other agent");
					table.insert(neighbors, other);
				end
			end
		end

		crowded_behavior(agent, neighbors);
	end
end

function love. draw()


	for i, agent in ipairs(agents) do
		--love.graphics.setColor(1, 0, 0);
		--love.graphics.circle("line", agent.x, agent.y, proximity);

		if(agent.crowded == false) then
			love.graphics.setColor(1, 1, 1);
			love.graphics.circle("fill", agent.x, agent.y, agent.radius);
		end

		if(agent.crowded == true) then
			love.graphics.setColor(1, 0, 0);
			love.graphics.circle("fill", agent.x, agent.y, agent.radius)
		end
	end
end

