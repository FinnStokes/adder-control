local viewport = require("viewport")

local M = {}

M.max = 3
M.up = {x = 0, y = -1}
M.down = {x = 0, y = 1}
M.left = {x = -1, y = 0}
M.right = {x = 1, y = 0}

local key = function(dir)
  return tostring(dir.x) .. "," .. tostring(dir.y)
end

M.new = function()
  local control = {}

  control[key(M.up)] = M.max
  control[key(M.down)] = M.max
  control[key(M.left)] = M.max
  control[key(M.right)] = M.max

  return control
end

M.available = function(control, dir)
  return control[key(dir)] > 0
end

M.consume = function(old, dir)
  local new = {}

  for k, v in pairs(old) do
    new[k] = v
  end

  new[key(dir)] = new[key(dir)] - 1

  return new
end

M.restore = function(old)
  local new = {}

  for k, v in pairs(old) do
    if v < M.max then
      new[k] = v + 1
    else
      new[k] = M.max
    end
  end

  return new
end

M.draw = function(view, control)
  local x = 1.3
  local y = 0.5
  for _, dir in ipairs({M.up, M.down, M.left, M.right}) do
    local centre = 0.15
    local icon = 0.15
    local gap_frac = 0.2
    local width = icon / (M.max + gap_frac * (M.max - 1))
    local gap = gap_frac * width

    for val = 1,M.max do
      if control[key(dir)] >= val then
        local local_rect = {x = centre / 2 + (M.max - val) * (width + gap), width = width,
                            y = -icon / 2, height = icon}
        local game_rect = {
            x = x + local_rect.x * dir.x - local_rect.y * dir.y,
            y = y + local_rect.y * dir.x + local_rect.x * dir.y,
            width = local_rect.width * dir.x - local_rect.height * dir.y,
            height = local_rect.height * dir.x + local_rect.width * dir.y,
        }
        local screen_rect = viewport.to_screen(view, game_rect)
        love.graphics.rectangle("fill", screen_rect.x, screen_rect.y, screen_rect.width, screen_rect.height)
      end
    end
  end
end

return M
