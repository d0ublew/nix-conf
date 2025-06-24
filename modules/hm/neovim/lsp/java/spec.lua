local env = {
  HOME = vim.uv.os_homedir(),
  XDG_CACHE_HOME = os.getenv("XDG_CACHE_HOME"),
  JDTLS_JVM_ARGS = os.getenv("JDTLS_JVM_ARGS"),
}

local function get_cache_dir()
  return env.XDG_CACHE_HOME and env.XDG_CACHE_HOME or env.HOME .. "/.cache"
end

local function get_jdtls_cache_dir()
  return get_cache_dir() .. "/jdtls"
end

local function get_jdtls_config_dir()
  return get_jdtls_cache_dir() .. "/config"
end

local function get_jdtls_workspace_dir()
  local curr_path = vim.api.nvim_buf_get_name(0)
  if curr_path == nil or curr_path == "" then
    curr_path = vim.fn.getcwd()
  else
    curr_path = vim.fn.fnamemodify(curr_path, ":p:h")
  end

  local root_dir = vim.fs.find(
    { "build.gradle", "build.gradle.kts", "settings.gradle", "settings.gradle.kts", ".gradlew", ".git", "mvnw" },
    { upward = true, stop = env.HOME, path = curr_path }
  )
  local project_name = ""
  if #root_dir == 0 then
    project_name = string.gsub(curr_path, "/", "%%")
  else
    project_name = string.gsub(vim.fn.fnamemodify(root_dir[1], ":p:h"), "/", "%%")
  end

  return get_jdtls_cache_dir() .. "/workspace/" .. project_name
end

local function get_jdtls_jvm_args()
  local args = {}
  for a in string.gmatch((env.JDTLS_JVM_ARGS or ""), "%S+") do
    local arg = string.format("--jvm-arg=%s", a)
    table.insert(args, arg)
  end
  return unpack(args)
end

return {
  servers = {
    {
      name = "jdtls",
      config = {
        cmd = {
          "jdtls",
          "-configuration",
          get_jdtls_config_dir(),
          "-data",
          get_jdtls_workspace_dir(),
          get_jdtls_jvm_args(),
        },
        init_options = {
          workspace = get_jdtls_workspace_dir(),
          jvm_args = {},
          os_config = nil,
          settings = {
            java = {
              implementationsCodeLens = { enabled = true },
              imports = {
                gradle = {
                  enabled = true,
                  wrapper = {
                    enabled = true,
                    checksums = {
                      {
                        sha256 = "7d3a4ac4de1c32b59bc6a4eb8ecb8e612ccd0cf1ae1e99f66902da64df296172",
                        allowed = true,
                      },
                    },
                  },
                },
              },
            },
          },
        },
      },
    },
  },
  formatters = {
    {
      name = "google-java-format",
    },
  },
}
