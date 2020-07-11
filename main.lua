game = require("game")

function love.load()
  state = game.new(16, 16)
end

function love.update(dt)
  state = game.update(state, dt)
end

function love.keypressed(key)
  if key == 'w' or key == 'up' then
    state = game.input(state, {x = 0, y = -1})
  elseif key == 'a' or key == 'left' then
    state = game.input(state, {x = -1, y = 0})
  elseif key == 's' or key == 'down' then
    state = game.input(state, {x = 0, y = 1})
  elseif key == 'd' or key == 'right' then
    state = game.input(state, {x = 1, y = 0})
  end
end

function love.draw()
  game.draw(state, {x = 0, y = 0, width = 400, height = 400})
end
