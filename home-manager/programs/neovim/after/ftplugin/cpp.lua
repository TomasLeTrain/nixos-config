vim.cmd([[
	setlocal makeprg=pros\ --no-sentry\ --no-analytics\ build-compile-commands\ --\ EXTRA_CXXFLAGS=-fno-diagnostics-color
]])
