-- setlocal makeprg=pros\ --no-sentry\ --no-analytics\ build-compile-commands\ --\ EXTRA_CXXFLAGS=-fno-diagnostics-color
vim.cmd([[
	set makeprg=tmux\ select-window\ -t\ :2\ \\\;\ send-keys\ ''\ Enter\ \\\;\ send-keys\ 'cf\ %'\ Enter
]])
