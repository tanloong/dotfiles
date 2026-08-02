#!/usr/bin/env lua

return {
	cmd = { "tsgo", "--lsp", "--stdio" },
	filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
	root_markers = {
		{
			"package.json",
			"tsconfig.json",
			"jsconfig.json",
			".git",
			".gitignore",
			"README.md",
		},
	},
}
