return {
  "nvim-neotest/nvim-nio",
  { "folke/neodev.nvim", opts = {} },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
  },

  {
    "mfussenegger/nvim-dap",
    dependencies = { "leoluz/nvim-dap-go", "rcarriga/nvim-dap-ui", "mfussenegger/nvim-dap-python" },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#E60000", bold = true })
      vim.fn.sign_define("DapBreakpoint", {
        text = "●",
        texthl = "DapBreakpoint",
        linehl = "",
        numhl = "",
      })
      vim.fn.sign_define("DapBreakpointCondition", {
        text = "●",
        texthl = "DapBreakpoint",
        linehl = "",
        numhl = "",
      })
      vim.fn.sign_define("DapLogPoint", {
        text = "◆",
        texthl = "DapLogPoint",
        linehl = "",
        numhl = "",
      })
      require("dap").set_log_level("TRACE")
      require("dapui").setup()
      require("dap-go").setup()
      require("dap-python").setup("python3")
      -- gdb for Linux, lldb for OSX
      dap.adapters.gdb = {
        type = "executable",
        command = "gdb",
        args = { "-i", "dap" },
      }
      dap.adapters.lldb = {
        type = "executable",
        command = "lldb-dap",
      }
      dap.configurations.c = {
        {
          name = "lldb dap",
          type = "lldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
        },
      }

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
  },
}
