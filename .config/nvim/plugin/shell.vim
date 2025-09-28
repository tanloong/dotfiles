if has("win32")
  let &shell = executable('pwsh') ? 'pwsh -NoLogo' : 'powershell -NoLogo'
  let &shellcmdflag = '-NoLogo -NonInteractive -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues[''Out-File:Encoding'']=''utf8'';$PSStyle.OutputRendering=''plaintext'';Remove-Alias -Force -ErrorAction SilentlyContinue tee;'
  let &shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
  let &shellpipe  = '2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode'
  set shellquote= shellxquote=
  nnoremap go <Cmd>silent!!opout.bat "%"<CR>
else
  nnoremap go <Cmd>silent!!opout "%"<CR>
endif
