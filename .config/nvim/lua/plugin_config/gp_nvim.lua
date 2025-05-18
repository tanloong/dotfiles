#!/usr/bin/env lua

local config = {
  providers = {
    chatanywhere = {
      secret = os.getenv "CHATANYWHERE_API_KEY",
      endpoint = os.getenv "CHATANYWHERE_API_BASE" .. "/chat/completions",
    },
    zhipu = {
      secret = os.getenv "ZHIPU_API_KEY",
      endpoint = os.getenv "ZHIPU_API_BASE" .. "/chat/completions",
    },
   ollama = {
      endpoint = "http://localhost:11434/v1/chat/completions",
    },
    github = {
      secret = os.getenv "GITHUB_TOKEN",
      endpoint = "https://models.github.ai/inference/chat/completions",
    },
  },
  agents = {
    {
      provider = "ollama",
      name = "llama2-uncensored:latest(ollama)",
      chat = true,
      command = true,
      -- string with model name or table with model name and parameters
      model = { model = "llama2-uncensored:latest", temperature = 1, top_p = 1 },
      system_prompt = [[you are useful]],
    },
    {
      provider = "zhipu",
      name = "glm-4-flash",
      chat = true,
      command = true,
      -- string with model name or table with model name and parameters
      model = { model = "glm-4-flash", temperature = 1, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = [[你是全世界最先进的人工智能助手]],
    },
    {
      provider = "chatanywhere",
      name = "deepseek-v3(chatanywhere)",
      chat = true,
      command = true,
      -- string with model name or table with model name and parameters
      model = { model = "deepseek-v3", temperature = 1.1, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = "",
    },
    {
      provider = "chatanywhere",
      name = "deepseek-r1(chatanywhere)",
      chat = true,
      command = true,
      -- string with model name or table with model name and parameters
      model = { model = "deepseek-r1", temperature = 1.1, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = "",
    },
    {
      provider = "chatanywhere",
      name = "gpt-4.1-mini(chatanywhere)",
      chat = true,
      command = true,
      -- string with model name or table with model name and parameters
      model = { model = "gpt-4.1-mini", temperature = 1.1, top_p = 1 },
      -- system prompt (use this to specify the persona/role of the AI)
      system_prompt = "你是一个有用的AI",
    },
    {
      provider = "chatanywhere",
      name = "gpt-4.1-nano(chatanywhere)",
      chat = true,
      command = true,
      model = { model = "gpt-4.1-nano", temperature = 1.1, top_p = 1 },
      system_prompt = "你是一个有用的AI",
    },
    {
      provider = "chatanywhere",
      name = "gpt-4o-mini(chatanywhere)",
      chat = true,
      command = true,
      model = { model = "gpt-4o-mini", temperature = 1.1, top_p = 1 },
      system_prompt = "你是一个有用的AI",
    },
    {
      provider = "github",
      name = "deepseek-v3-0324(github)",
      chat = true,
      command = true,
      model = { model = "deepseek/DeepSeek-V3-0324", temperature = 1.1, top_p = 1 },
      system_prompt = "You are helpful",
    },
    {
      provider = "github",
      name = "gpt-4.1-mini(github)",
      chat = true,
      command = true,
      model = { model = "openai/gpt-4.1-mini", temperature = 1.1, top_p = 1 },
      system_prompt = "You are helpful",
    },
    {
      provider = "github",
      name = "gpt-4.1(github)",
      chat = true,
      command = true,
      model = { model = "openai/gpt-4.1", temperature = 1.1, top_p = 1 },
      system_prompt = "You are helpful",
    },
  },
  -- optional curl parameters (for proxy, etc.)
  -- curl_params = { "--proxy", "http://X.X.X.X:XXXX" }
  curl_params = {},
  chat_template = require "gp.defaults".short_chat_template,
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
  -- chat_topic_gen_model = "mixtral-8x7b-32768",
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


  hooks = {
    InspectPlugin = function(plugin, params)
      local bufnr = vim.api.nvim_create_buf(false, true)
      local copy = vim.deepcopy(plugin)
      local key = copy.config.openai_api_key
      copy.config.openai_api_key = key:sub(1, 3) .. string.rep("*", #key - 6) .. key:sub(-3)
      local plugin_info = string.format("Plugin structure:\n%s", vim.inspect(copy))
      local params_info = string.format("Command params:\n%s", vim.inspect(params))
      local lines = vim.split(plugin_info .. "\n" .. params_info, "\n")
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
      vim.api.nvim_win_set_buf(0, bufnr)
    end,

    -- GpImplement rewrites the provided selection/range based on comments in it
    Implement = function(gp, params)
      local template = "Having following from {{filename}}:\n\n"
          .. "```{{filetype}}\n{{selection}}\n```\n\n"
          .. "Please rewrite this according to the contained instructions."
          .. "\n\nRespond exclusively with the snippet that should replace the selection above."

      local agent = gp.get_command_agent()
      gp.info("Implementing selection with agent: " .. agent.name)

      gp.Prompt(
        params,
        gp.Target.rewrite,
        nil, -- command will run directly without any prompting for user input
        agent.model,
        template,
        agent.system_prompt
      )
    end,


    -- your own functions can go here, see README for more examples like
    -- :GpExplain, :GpUnitTests.., :GpTranslator etc.

    -- -- example of making :%GpChatNew a dedicated command which
    -- -- opens new chat with the entire current buffer as a context
    -- BufferChatNew = function(gp, _)
    -- 	-- call GpChatNew command in range mode on whole buffer
    -- 	vim.api.nvim_command("%" .. gp.config.cmd_prefix .. "ChatNew")
    -- end,

    -- :GpTranslator
    Translator = function(gp, params)
      local chat_system_prompt =
      "Act as a Translator, translate between English and Chinese. Your response should contain only the translation text."
      gp.cmd.ChatNew(params, chat_system_prompt)
      -- -- you can also create a chat with a specific fixed agent like this:
      -- local agent = gp.get_chat_agent("ChatGPT4o")
      -- gp.cmd.ChatNew(params, chat_system_prompt, agent)
    end,
    -- :GpProofread
    Proofread = function(gp, params)
      local agent = gp.get_command_agent()
      local chat_system_prompt =
      "I want you act as a proofreader. I will provide you texts and I would like you to review them for any spelling, grammar, or punctuation errors. Once you have finished reviewing the text, provide me with any necessary corrections or suggestions for improve the text."
      gp.cmd.ChatNew(params, agent.model, chat_system_prompt)
    end,
    -- :GpUnitTests
    UnitTests = function(gp, params)
      local template = "I have the following code from {{filename}}:\n\n"
          .. "```{{filetype}}\n{{selection}}\n```\n\n"
          .. "Please respond by writing table driven unit tests for the code above."
      local agent = gp.get_command_agent()
      gp.Prompt(params, gp.Target.enew, nil, agent.model, template, agent.system_prompt)
    end,

    -- :GpExplain
    Explain = function(gp, params)
      local template = "I have the following code from {{filename}}:\n\n"
          .. "```{{filetype}}\n{{selection}}\n```\n\n"
          .. "Please respond by explaining the code above."
      local agent = gp.get_chat_agent()
      gp.Prompt(params, gp.Target.popup, nil, agent.model, template, agent.system_prompt)
    end,
  },
  zindex = 49,
}
require "gp".setup(config)


local keyset = vim.keymap.set
local function keymapOptions(desc)
  return {
    noremap = true,
    silent = true,
    nowait = true,
    desc = "GPT prompt " .. desc,
  }
end

-- Chat commands
keyset({ "n" }, "<c-bar>", "<cmd>GpChatNew<cr>", keymapOptions "New Chat")
keyset({ "n" }, "<bar>", "<cmd>GpChatToggle<cr>", keymapOptions "Toggle Chat")
keyset({ "n", "i" }, "<C-g>f", "<cmd>GpChatFinder<cr>", keymapOptions "Chat Finder")

keyset("v", "<c-bar>", ":<C-u>'<,'>GpChatNew<cr>", keymapOptions "Visual Chat New")
keyset("v", "<bar>", ":<C-u>'<,'>GpChatToggle<cr>", keymapOptions "Visual Toggle Chat")
keyset("v", "<C-g>p", ":<C-u>'<,'>GpChatPaste<cr>", keymapOptions "Visual Chat Paste")

-- Prompt commands
keyset({ "n", "i" }, "<C-g>r", "<cmd>GpRewrite<cr>", keymapOptions "Inline Rewrite")
keyset({ "n", "i" }, "<C-g>a", "<cmd>GpAppend<cr>", keymapOptions "Append (after)")
keyset({ "n", "i" }, "<C-g>b", "<cmd>GpPrepend<cr>", keymapOptions "Prepend (before)")
keyset("v", "<C-g>r", ":<C-u>'<,'>GpRewrite<cr>", keymapOptions "Visual Rewrite")
keyset("v", "<C-g>a", ":<C-u>'<,'>GpAppend<cr>", keymapOptions "Visual Append (after)")
keyset("v", "<C-g>b", ":<C-u>'<,'>GpPrepend<cr>", keymapOptions "Visual Prepend (before)")
keyset("v", "<C-g>i", ":<C-u>'<,'>GpImplement<cr>", keymapOptions "Implement selection")

keyset({ "n", "i" }, "<C-g>x", "<cmd>GpContext<cr>", keymapOptions "Toggle Context")
keyset("v", "<C-g>x", ":<C-u>'<,'>GpContext<cr>", keymapOptions "Visual Toggle Context")

keyset({ "n", "i", "v", "x" }, "<C-g>s", "<cmd>GpStop<cr>", keymapOptions "Stop")
