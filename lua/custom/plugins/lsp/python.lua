local function log_to_file(msg)
  local logfile = vim.fn.stdpath 'data' .. '/mason_pylsp.log'
  local f = io.open(logfile, 'a') -- "a" = append
  if f then
    local timestamp = os.date '%Y-%m-%d %H:%M:%S'
    f:write(string.format('[%s] %s\n', timestamp, msg))
    f:close()
  else
    -- fallback: print if the file can't be opened
    print('Failed to open log file:', logfile)
  end
end

local function install_pylsp_plugins(pkg)
  log_to_file('install pylsp plugins called with pgk ' .. pkg.name)
  if pkg.name ~= 'python-lsp-server' then
    return
  end

  local venv = vim.fn.stdpath 'data' .. '/mason/packages/python-lsp-server/venv'
  local Job = require 'plenary.job'
  Job:new({
    command = venv .. '/bin/pip',
    args = {
      'install',
      '-U',
      '--disable-pip-version-check',
      'python-lsp-ruff',
    },
    cwd = venv,
    env = { VIRTUAL_ENV = venv },
    on_exit = function()
      log_to_file 'finished pip install job'
      vim.schedule(function()
        vim.notify 'Finished installing additional pylsp modules.'
      end)
    end,
    on_stdout = function(_, data)
      if data then
        log_to_file('[STDOUT] ' .. data)
      end
    end,
    on_stderr = function(_, data)
      if data then
        log_to_file('[STDERR] ' .. data)
      end
    end,
    on_start = function()
      log_to_file 'started pip install job'
      vim.schedule(function()
        vim.notify 'Installing additional pylsp modules...'
      end)
    end,
  }):sync()
  vim.cmd 'LspRestart'
end

require('mason-registry'):on('package:install:success', install_pylsp_plugins)

return {
  pylsp = {
    settings = {
      pylsp = {
        plugins = {
          autopep8 = { enabled = false },
          flake8 = { enabled = false },
          mccabe = { enabled = false },
          pycodestyle = { enabled = false },
          pydocstyle = { enabled = false },
          pyflakes = { enabled = false },
          pylint = { enabled = false },
          yapf = { enabled = false },
          ruff = { enabled = true },
        },
      },
    },
  },
}
