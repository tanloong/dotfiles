local map = vim.keymap.set
local ls = require("luasnip")
ls.setup({ enable_autosnippets = true })
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local conds = require("luasnip.extras.expand_conditions")

ls.add_snippets("all", {
	s({ trig = "lrq", wordTrig = false }, { t({ '"' }), i(0), t({ '"' }) }),
	s({ trig = "lri", wordTrig = false }, { t({ '["' }), i(0), t({ '"]' }) }),
	s({ trig = "lro", wordTrig = false }, { t({ '("' }), i(0), t({ '")' }) }),
}, { type = "autosnippets" })

ls.add_snippets(
	"markdown",
	{ s(",b", { t({ "___" }), i(0), t({ "___" }) }), s(",c", { t({ "`" }), i(0), t({ "`" }) }) },
	{ type = "autosnippets" }
)

ls.add_snippets("python", {
	s("b", { t({ "breakpoint()" }) }, { condition = conds.line_begin }),
	s("l", { t({ "logging.info(" }), i(0), t({ ")" }) }, { condition = conds.line_begin }),
	s("i", { t({ "import " }) }, { condition = conds.line_begin }),
	s("f", { t({ "from " }), i(1), t({ " import " }), i(2) }, { condition = conds.line_begin }),
	s("p", { t({ "print(" }), i(0), t({ ")" }) }, { condition = conds.line_begin }),
	s("fp", { t({ 'print(f"' }), i(0), t({ '")' }) }, { condition = conds.line_begin }),
	s("ifmain", { t('if __name__ == "__main__":'), t({ '', '    ' }), i(0) }, { condition = conds.line_begin }),
}, { type = "snippets" })

map({ "i" }, "<C-o>", function()
	ls.expand()
end, { silent = true })
map({ "i", "s" }, "<C-j>", function()
	ls.jump(1)
end, { silent = true })
map({ "i", "s" }, "<C-k>", function()
	ls.jump(-1)
end, { silent = true })

-- map({ "i", "s" }, "<C-y>", function()
-- 	if ls.choice_active() then
-- 		ls.change_choice(1)
-- 	end
-- end, { silent = true })
