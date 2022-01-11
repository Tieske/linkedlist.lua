unused_args     = false
redefined       = false
max_line_length = false

globals = {
    "ngx",
}

not_globals = {
    "string.len",
    "table.getn",
}

include_files = {
  "**/*.lua",
  "*.rockspec",
  ".busted",
  ".luacheckrc",
  --".luacov",
}

files["spec/**/*.lua"] = {
    std = "+busted",
}

exclude_files = {
    -- Travis Lua environment
    "here/*.lua",
    "here/**/*.lua",
    -- GH Actions Lua Environment
    ".lua",
    ".luarocks",
    ".install",
}

