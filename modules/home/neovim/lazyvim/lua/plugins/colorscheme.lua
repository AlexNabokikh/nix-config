-- Stock Catppuccin Mocha with Adwaita's dark surface (#1d1d20) matching Alacritty.
local function darken(hex, amount)
  local out = {}
  for _, i in ipairs({ 2, 4, 6 }) do
    out[#out + 1] = string.format("%02x", math.floor(tonumber(hex:sub(i, i + 1), 16) * (1 - amount) + 0.5))
  end
  return "#" .. table.concat(out)
end

return {
  "catppuccin/nvim",
  name = "catppuccin",
  opts = function(_, opts)
    local base = "#1d1d20"

    opts.flavour = "mocha"
    opts.color_overrides = {
      mocha = {
        base = base,
        -- Mocha's mantle and crust sit ~20% and ~42% darker than its base.
        mantle = darken(base, 0.2),
        crust = darken(base, 0.42),
      },
    }

    return opts
  end,
}
