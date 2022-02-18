local cmd = {"ngserver", "--stdio", "--tsProbeLocations", vim.fn.getcwd() .. "/node_modules" , "--ngProbeLocations", vim.fn.getcwd() .. "/node_modules"}
return {
  cmd = cmd,
  on_new_config = function(new_config,new_root_dir)
    new_config.cmd = cmd
  end,
}
