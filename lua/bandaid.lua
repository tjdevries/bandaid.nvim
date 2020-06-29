package.loaded['bandaid'] = nil

local bandaid = {}

bandaid.str_to_semver = function(patch_str)
  if string.sub(patch_str, 1, 1) == 'v' then
    patch_str = string.sub(patch_str, 2)
  end

  local patch_list = vim.split(patch_str, ".", true)

  return {
    major = tonumber(patch_list[1]),
    minor = tonumber(patch_list[2]),
    patch = tonumber(patch_list[3]),
  }
end

bandaid.semver_to_str = function(semver)
  return string.format('v%s.%s.%04d', semver.major, semver.minor, semver.patch)
end

bandaid.decrement_semver_patch = function(semver)
  local copy = vim.deepcopy(semver)
  copy.patch = copy.patch - 1

  return copy
end

bandaid.open_github_diff = function(patch_str)
  local current_semver = bandaid.str_to_semver(patch_str)
  local previous_semver = bandaid.decrement_semver_patch(current_semver)

  local url = string.format(
    'https://github.com/vim/vim/compare/%s...%s',
    bandaid.semver_to_str(previous_semver),
    bandaid.semver_to_str(current_semver)
  )

  print('Opening...', url)
  vim.fn.system(string.format('xdg-open %s', url))
end

bandaid.open_github_diff_line = function()
  local line = vim.fn.getline('.')
  local patch_str = string.sub(line, string.find(line, 'v%d*.%d*.%d*'))
  bandaid.open_github_diff(patch_str)
end

return bandaid
