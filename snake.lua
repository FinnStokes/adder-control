local viewport = require("viewport")

local M = {}

M.growth = 3

M.new = function(x, y, width, height)
  local snake = {
    x = x,
    y = y,
    width = width,
    height = height,
    dir = {x = 1, y = 0},
    growth = 0,
    body = {
      {x = (x - 2) % width, y = y},
      {x = (x - 1) % width, y = y},
      {x = x, y = y},
    },
  }

  return snake
end

M.move = function(old)
  local new = {
    x = (old.x + old.dir.x) % old.width,
    y = (old.y + old.dir.y) % old.height,
    width = old.width,
    height = old.height,
    growth = old.growth,
    dir = old.dir,
    body = {},
  }

  if new.growth > 0 then
    new.growth = new.growth - 1
    for i, p in ipairs(old.body) do
      new.body[i] = p
    end
  else
    for i, p in ipairs(old.body) do
      if i > 1 then
        new.body[i - 1] = p
      end
    end
  end

  new.body[table.getn(new.body) + 1] = {x = new.x, y = new.y}

  return new
end

M.grow = function(old)
  local new = {
    x = old.x,
    y = old.y,
    width = old.width,
    height = old.height,
    growth = M.growth,
    dir = old.dir,
    body = old.body,
  }

  return M.move(new)
end

M.turn = function(old, dir)
  local new = {
    x = old.x,
    y = old.y,
    width = old.width,
    height = old.height,
    growth = old.growth,
    dir = dir,
    body = old.body,
  }
  return new
end

M.draw = function(snake, view)
  for _, pos in ipairs(snake.body) do
    local screen_rect = viewport.to_screen(view, {
        x = pos.x / snake.width,
        y = pos.y / snake.height,
        width = 1 / snake.width,
        height = 1 / snake.height
    })
    love.graphics.rectangle("fill", screen_rect.x, screen_rect.y, screen_rect.width, screen_rect.height)
  end
end

return M
