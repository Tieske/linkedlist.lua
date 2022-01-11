local package_name = "linkedlist"
local package_version = "scm"
local rockspec_revision = "1"
local github_account_name = "Tieske"
local github_repo_name = package_name..".lua"
local git_checkout = package_version == "dev" and "main" or package_version


package = package_name
version = package_version .. "-" .. rockspec_revision

source = {
   url = "git://github.com/"..github_account_name.."/"..github_repo_name..".git",
   branch = git_checkout
}

description = {
   summary = "Linked list for Lua",
   detailed = [[
      Straightforward linked-list implementations for Lua.
   ]],
   license = "MIT",
   homepage = "https://github.com/"..github_account_name.."/"..github_repo_name
}

dependencies = {
}

build = {
   type = "builtin",
   modules = {
      ["linkedlist.single"] = "src/linkedlist/single.lua",
      ["linkedlist.double"] = "src/linkedlist/double.lua",
   },
   copy_directories = {
      "docs",
   },
}
