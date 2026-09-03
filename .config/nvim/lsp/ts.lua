return {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "typescript" },
	root_markers = {
		{
			".git",
			".gitignore",
			".venv",
			"README.md",
      ".npmrc",
      "README.md",
      "package.json",
      "tsconfig.json",
      "vite.config.ts",
		},
	},
}
