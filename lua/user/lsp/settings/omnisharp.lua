M = {
	settings = {
        cs = { }
    }
}

local cmd = { "/home/nikolai/code/omnisharp/run", "--languageserver" , "--hostPID", tostring(vim.fn.getpid()) }
M.cmd = cmd
return M

