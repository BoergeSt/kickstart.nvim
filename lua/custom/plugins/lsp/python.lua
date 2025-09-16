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
      'eradicate',
      'flake8-annotations',
      'flake8-bandit',
      'flake8-boolean-trap',
      'flake8-bugbear',
      'flake8-builtins',
      'flake8-commas',
      'flake8-comprehensions',
      'flake8-datetimez',
      'flake8-executable',
      'flake8-fixme',
      'flake8-future-annotations',
      'flake8-implicit-str-concat',
      'flake8-import-conventions',
      'flake8-logger',
      'flake8-pie',
      'flake8-print',
      'flake8-pyi',
      'flake8-pytest-style',
      'flake8-quotes',
      'flake8-return',
      'flake8-simplify',
      'flake8-tidy-imports',
      'flake8-todos',
      'flake8-type-checking',
      'flake8-unused-arguments',
      'flake8-use-pathlib',
      'pydoclint',
      'python-lsp-ruff',
      'pyupgrade',
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
          ruff = {
            enabled = true,
            formatEnabled = true,
            extendSelect = {
              'A', -- flake8-builtins: Check for python builtins being used as variables or parameters
              'ANN', -- flake8-annotations: checks for presence of type annotations
              'ARG', -- flake8-unused-arguments: checks for unused function arguments.
              'B', -- flake8-bugbear: catches likely bugs and code quality issues
              'C4', -- flake8-comprehensions: helps you write better list/set/dict comprehensions
              'COM', -- flake8-commas: checks for trailing commas and proper comma usage
              'D', -- pydocstyle: check compliance with Python docstring conventions
              'DOC', -- pydoclint: check if docstrings match the function signature or function implementation.
              'DTZ', -- flake8-datetimez: Strict require strict timezone manipulation with datetime
              'E', -- pycodestyle (Error): check code agains code style conventions from pep8
              'ERA', -- eradicate: detects commented-out or dead code
              'EXE', -- flake8-executable: Checks permission and shebang related stuff
              'F', -- pyflakes: detects various errors.
              'FA', -- flake8-future-annotations: enforces using PEP 563 style future annotations
              'FBT', -- flake8-boolean-trap: Detect boolean traps.
              -- 'FIX', -- flake8-fixme: Check for FIXME, TODO and other temporary developer notes.
              'I', -- Warn on improperly formated Importls
              'ICN', -- flake8-import-conventions: opinionated plugin how certain packages should be imported or aliased.
              'ISC', -- flake8-implicit-str-concat: encourage correct string literal concatenation
              'LOG', -- flake8-logger: checks for issues using the standard library logging module
              'N', -- pep8-naming: Check against PEP 8 naming conventions
              'NPY', -- NumPy-specific-rules: some specific numpy rules
              'PD', -- pandas-vet: opinionated Pandas linting rules
              'PIE', -- flake8-pie: implements miscellaneous lints for code quality and maintainability
              'PT', -- flake8-pytest-style: checks common style issues or inconsistencies with pytest-based tests
              'PTH', -- flake8-use-pathlib: finds use of functions that can be replaced by pathlib module
              'PYI', -- flake8-pyi: linting for type annotations
              'Q', -- flake8-quotes: checks quote style
              'RET', -- flake8-return: checks return values
              'S', -- flake8-bandit: security issues like unsafe functions or weak crypto
              'SIM', -- flake8-simplify: helps you simplify your code.
              'T20', -- flake8-print: print == bad! :)
              'TC', -- flake8-type-checking: Enforce importing certain types in a TYPE_CHECKING block
              'TD', -- flake8-todos: check TODOs in the project
              'TID', -- flake8-tidy-imports: helps you write tidier imports
              'UP', -- pyupgrade: automatically upgrade syntax for newer versions of the language
              'W', -- pycodestyle (Warning): check code agains code style conventions from pep8
            },
            unsafeFixes = true,
            preview = false,
          },
        },
      },
    },
  },
}
