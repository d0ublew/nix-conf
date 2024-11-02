local inside_tmux = vim.fn.exists("$TMUX") == 1

if inside_tmux then
  vim.cmd([[
    let g:clipboard = {
                \   'name': 'myClipboard',
                \   'copy': {
                \      '+': ['tmux', 'load-buffer', '-'],
                \      '*': ['tmux', 'load-buffer', '-'],
                \    },
                \   'paste': {
                \      '+': ['tmux', 'save-buffer', '-'],
                \      '*': ['tmux', 'save-buffer', '-'],
                \   },
                \   'cache_enabled': 1,
                \ }
    ]])
elseif vim.fn.executable("clip.exe") == 1 then
  vim.cmd([[
    let g:clipboard = {
                \   'name': 'WslClipboard',
                \   'copy': {
                \      '+': 'clip.exe',
                \      '*': 'clip.exe',
                \    },
                \   'paste': {
                \      '+': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
                \      '*': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
                \   },
                \   'cache_enabled': 0,
                \ }
	]])
elseif vim.fn.executable("xclip") == 1 then
  vim.cmd([[
    let g:clipboard = {
                \   'name': 'xclip',
                \   'copy': {
                \      '+': 'xclip -sel clip',
                \      '*': 'xclip -sel clip',
                \    },
                \   'paste': {
                \      '+': 'xclip -o -sel clip',
                \      '*': 'xclip -o -sel clip',
                \   },
                \   'cache_enabled': 1,
                \ }
	]])
elseif vim.fn.executable("pbcopy") == 1 then
  vim.cmd([[
    let g:clipboard = {
                \   'name': 'pbcopy',
                \   'copy': {
                \      '+': 'pbcopy',
                \      '*': 'pbcopy',
                \    },
                \   'paste': {
                \      '+': 'pbpaste',
                \      '*': 'pbpaste',
                \   },
                \   'cache_enabled': 1,
                \ }
	]])
end
