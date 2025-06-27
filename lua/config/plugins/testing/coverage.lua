return {
  {
    "andythigpen/nvim-coverage",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = {
      "Coverage",
      "CoverageLoad",
      "CoverageShow",
      "CoverageHide",
      "CoverageToggle",
      "CoverageClear",
      "CoverageSummary",
    },
    keys = function()
      return require("config.keymaps").coverage_keys
    end,
    opts = {
      auto_reload = true,
      lcov_file = "./coverage/lcov.info",
      commands = true,
      highlights = {
        covered = { fg = "#C3E88D" },
        uncovered = { fg = "#F07178" },
      },
      signs = {
        covered = { hl = "CoverageCovered", text = "▎" },
        uncovered = { hl = "CoverageUncovered", text = "▎" },
      },
      summary = {
        min_coverage = 80.0,
      },
      lang = {
        python = {
          coverage_file = "./coverage.xml",
        },
        javascript = {
          coverage_file = "./coverage/lcov.info",
        },
        typescript = {
          coverage_file = "./coverage/lcov.info",
        },
      },
    },
  },
}
