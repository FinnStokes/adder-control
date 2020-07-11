local snake = require("snake")
local viewport = require("viewport")

local M = {}

local apple_allowed = function(apple, state)
  for i, pos in ipairs(state.snake.body) do
    if pos.x == apple.x and pos.y == apple.y then
      return false
    end
  end

  if state.snake.x + state.snake.dir.x == apple.x and state.snake.y + state.snake.dir.y == apple.y then
    return false
  end

  return true
end

local new_apple = function(state)
  local apple = {x = math.random(0, state.width - 1), y = math.random(0, state.height - 1)}
  while not apple_allowed(apple, state) do
      apple = {x = math.random(0, state.width - 1), y = math.random(0, state.height - 1)}
  end
  return apple
end

M.new = function(width, height)
  local game = {
    speed = 1 / 0.5,
    time = 0,
    state = {
      width = width,
      height = height,
      step = 0,
      snake = snake.new(math.floor(width / 2), math.floor(height / 2), width, height),
      apple = nil,
      game_over = false,
      score = 0,
      old = nil,
    },
  }

  game.state.apple = new_apple(game.state)

  return game
end

local step = function(old)
  local new = {
    width = old.width,
    height = old.height,
    step = old.step + 1,
    snake = snake.move(old.snake),
    apple = old.apple,
    game_over = old.game_over,
    score = old.score,
    old = old,
  }

  if new.snake.x == new.apple.x and new.snake.y == new.apple.y then
    new.snake = snake.grow(old.snake)
    new.apple = new_apple(new)
    new.score = new.score + 1
  end

  for i, pos in ipairs(new.snake.body) do
    if pos.x == new.snake.x and pos.y == new.snake.y and i < table.getn(new.snake.body) then
      new.score = old.score
      new.game_over = true
      return new
    end
  end

  return new
end

M.update = function(old, dt)
  local new = {
    speed = old.speed,
    time = old.time + dt * old.speed,
    state = old.state,
  }

  while new.time > 1 do
    new = {
      speed = new.speed,
      time = new.time - 1,
      state = step(new.state),
    }
  end

  return new
end

M.input = function(old, dir)
  local new = old

  if dir.x ~= old.state.snake.dir.x and dir.y ~= old.state.snake.dir.y then
    new = {
      speed = old.speed,
      time = old.time,
      state = {
        width = old.state.width,
        height = old.state.height,
        step = old.state.step,
        snake = snake.turn(old.state.snake, dir),
        apple = old.state.apple,
        game_over = old.game_over,
        score = old.state.score,
        old = old.state.old,
      }
    }
  end

  return new
end

M.draw = function(game, view)
  local screen_rect = viewport.to_screen(view, {x = 0, y = 0, width = 1, height = 1})
  love.graphics.rectangle("line", screen_rect.x, screen_rect.y, screen_rect.width, screen_rect.height)
  if not game.state.game_over then
    snake.draw(game.state.snake, view)
    screen_rect = viewport.to_screen(view, {x = game.state.apple.x / game.state.width, y = game.state.apple.y / game.state.height, width = 1 / game.state.width, height = 1 / game.state.height})
    love.graphics.ellipse("fill", screen_rect.x + screen_rect.width / 2, screen_rect.y + screen_rect.height / 2, screen_rect.width / 2, screen_rect.height / 2)
  end
end

return M
