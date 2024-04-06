#!/usr/bin/env lua

local config = {
    openai_api_key = os.getenv("OPENAI_API_KEY"),
    openai_api_endpoint = os.getenv("OPENAI_API_BASE") .. "/chat/completions",
    -- optional curl parameters (for proxy, etc.)
    -- curl_params = { "--proxy", "http://X.X.X.X:XXXX" }
    curl_params = {},

    -- chat user prompt prefix
    chat_user_prefix = "🗨:",
    -- chat assistant prompt prefix (static string or a table {static, template})
    -- first string has to be static, second string can contain template {{agent}}
    -- just a static string is legacy and the [{{agent}}] element is added automatically
    -- if you really want just a static string, make it a table with one element { "🤖:" }
    chat_assistant_prefix = { "🤖:", "[{{agent}}]" },
    -- chat topic generation prompt
    chat_topic_gen_prompt = "Summarize the topic of our conversation above"
        .. " in two or three words. Respond only with those words.",
    -- chat topic model (string with model name or table with model name and parameters)
    chat_topic_gen_model = "gpt-3.5-turbo",
    -- explicitly confirm deletion of a chat file
    chat_confirm_delete = false,
    -- conceal model parameters in chat
    chat_conceal_model_params = true,
    -- local shortcuts bound to the chat buffer
    -- (be careful to choose something which will work across specified modes)
    chat_shortcut_respond = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g><C-g>" },
    chat_shortcut_delete = { modes = { "n", "i", "v", "x" }, shortcut = "<C-g>d" },
    chat_shortcut_stop = { modes = { "n", "i", "v", "x" }, shortcut = "<c-g>s" },
    chat_shortcut_new = { modes = { "n", "i", "v", "x" }, shortcut = "<c-g>n" },
    -- default search term when using :GpChatFinder
    chat_finder_pattern = "",
    -- if true, finished ChatResponder won't move the cursor to the end of the buffer
    chat_free_cursor = true,

    -- how to display GpChatToggle or GpContext: popup / split / vsplit / tabnew
    toggle_target = "popup",

    -- styling for chatfinder
    -- border can be "single", "double", "rounded", "solid", "shadow", "none"
    style_chat_finder_border = "single",
    -- margins are number of characters or lines
    style_chat_finder_margin_bottom = 8,
    style_chat_finder_margin_left = 1,
    style_chat_finder_margin_right = 2,
    style_chat_finder_margin_top = 2,
    -- how wide should the preview be, number between 0.0 and 1.0
    style_chat_finder_preview_ratio = 0.5,

    -- styling for popup
    -- border can be "single", "double", "rounded", "solid", "shadow", "none"
    style_popup_border = "single",
    -- margins are number of characters or lines
    style_popup_margin_bottom = 8,
    style_popup_margin_left = 1,
    style_popup_margin_right = 2,
    style_popup_margin_top = 2,
    style_popup_max_width = 160,

    -- command config and templates bellow are used by commands like GpRewrite, GpEnew, etc.
    -- command prompt prefix for asking user for input (supports {{agent}} template variable)
    command_prompt_prefix_template = "🤖 {{agent}} ~ ",
    -- auto select command response (easier chaining of commands)
    -- if false it also frees up the buffer cursor for further editing elsewhere
    command_auto_select_response = true,

    -- templates
    template_selection = "I have the following from {{filename}}:"
        .. "\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}",
    template_rewrite = "I have the following from {{filename}}:"
        .. "\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}"
        .. "\n\nRespond exclusively with the snippet that should replace the selection above.",
    template_append = "I have the following from {{filename}}:"
        .. "\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}"
        .. "\n\nRespond exclusively with the snippet that should be appended after the selection above.",
    template_prepend = "I have the following from {{filename}}:"
        .. "\n\n```{{filetype}}\n{{selection}}\n```\n\n{{command}}"
        .. "\n\nRespond exclusively with the snippet that should be prepended before the selection above.",
    template_command = "{{command}}",

}
require("gp").setup(config)

local function keymapOptions(desc)
    return {
        noremap = true,
        silent = true,
        nowait = true,
        desc = "GPT prompt " .. desc,
    }
end

local keyset = vim.keymap.set
-- Chat commands
keyset({ "n" }, "<c-bar>", "<cmd>GpChatNew<cr>", keymapOptions("New Chat"))
keyset({ "n" }, "<bar>", "<cmd>GpChatToggle<cr>", keymapOptions("Toggle Chat"))
keyset({ "n", "i" }, "<C-g>f", "<cmd>GpChatFinder<cr>", keymapOptions("Chat Finder"))

keyset("v", "<c-bar>", ":<C-u>'<,'>GpChatNew<cr>", keymapOptions("Visual Chat New"))
keyset("v", "<bar>", ":<C-u>'<,'>GpChatToggle<cr>", keymapOptions("Visual Toggle Chat"))
keyset("v", "<C-g>p", ":<C-u>'<,'>GpChatPaste<cr>", keymapOptions("Visual Chat Paste"))

-- Prompt commands
keyset({ "n", "i" }, "<C-g>r", "<cmd>GpRewrite<cr>", keymapOptions("Inline Rewrite"))
keyset({ "n", "i" }, "<C-g>a", "<cmd>GpAppend<cr>", keymapOptions("Append (after)"))
keyset({ "n", "i" }, "<C-g>b", "<cmd>GpPrepend<cr>", keymapOptions("Prepend (before)"))

keyset("v", "<C-g>r", ":<C-u>'<,'>GpRewrite<cr>", keymapOptions("Visual Rewrite"))
keyset("v", "<C-g>a", ":<C-u>'<,'>GpAppend<cr>", keymapOptions("Visual Append (after)"))
keyset("v", "<C-g>b", ":<C-u>'<,'>GpPrepend<cr>", keymapOptions("Visual Prepend (before)"))
keyset("v", "<C-g>i", ":<C-u>'<,'>GpImplement<cr>", keymapOptions("Implement selection"))

keyset({ "n", "i" }, "<C-g>x", "<cmd>GpContext<cr>", keymapOptions("Toggle Context"))
keyset("v", "<C-g>x", ":<C-u>'<,'>GpContext<cr>", keymapOptions("Visual Toggle Context"))

keyset({ "n", "i", "v", "x" }, "<C-g>s", "<cmd>GpStop<cr>", keymapOptions("Stop"))
