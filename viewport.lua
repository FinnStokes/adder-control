local M = {}

M.to_screen = function(viewport, game_rect)
  local screen_rect = {
    x = viewport.x + game_rect.x * viewport.width,
    y = viewport.y + game_rect.y * viewport.height,
    width = game_rect.width * viewport.width,
    height = game_rect.height * viewport.height,
  }

  return screen_rect
end

M.to_game = function(viewport, screen_rect)
  local game_rect = {
    x = (screen_rect.x - viewport.x) / viewport.width,
    y = (screen_rect.y - viewport.y) / viewport.height,
    width = screen_rect.width / viewport.width,
    height = screen_rect.height / viewport.height,
  }

  return game_rect
end

return M
