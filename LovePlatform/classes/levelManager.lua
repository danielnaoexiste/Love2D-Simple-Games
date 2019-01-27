Level = Object:extend();

function Level:new(level)
    local objects = level.layers[1].objects;
    for i = 1, #objects do
        local obj = objects[i];
        world:add(obj, obj.x, obj.y, obj.width, obj.height);
    end
end

function Level:draw(level) 
    local objects = level.layers[1].objects;
    love.graphics.setColor(0,.13,1);
    for i = 1, #objects do
        local obj = objects[i]
        love.graphics.rectangle("line", obj.x, obj.y, obj.width, obj.height);
    end
end
