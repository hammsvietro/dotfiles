" bufferline
nnoremap <silent><Tab> :BufferLineCycleNext<CR>
nnoremap <silent><S-Tab> :BufferLineCyclePrev<CR>
nnoremap <silent><leader>x :bd<CR> :bprevious<CR>
nnoremap <silent> gb :BufferLinePick<CR>


" coc setting
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gw <Plug>(coc-rename)


" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <leader>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <leader>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <leader>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <leader>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <leader>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <Leader>J <Plug>(coc-diagnostic-next)
" Do default action for previous item.
nnoremap <silent> <Leader>K <Plug>(coc-diagnostic-prev)
" Do default action for next item.
nnoremap <silent> <Leader>j <Plug>(coc-diagnostic-next-error)
" Do default action for previous item.
nnoremap <silent> <Leader>k <Plug>(coc-diagnostic-prev-error)
" Resume latest coc list.
nnoremap <silent><nowait> <leader>p  :<C-u>CocListResume<CR>
" Open atuocomplete

inoremap <silent><expr> <c-space> coc#refresh()
inoremap <silent><expr> <c-Space> coc#refresh()
inoremap <silent><expr> <C-@> coc#refresh()

nnoremap <silent> <leader>K :call <SID>show_documentation()<CR>
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1):
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

nnoremap <silent>Y y$

" telescope
nnoremap <leader>ff <cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files prompt_prefix=🔍<cr>
nnoremap <leader>fg <cmd>Telescope live_grep find_command=rg,--ignore,--hidden,--files prompt_prefix=🔍<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fr <cmd>Telescope resume<cr>


" nvim tree
nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>c

" window moving

" move to left split
nnoremap <silent><C-h> <C-w>h
" move to right split
nnoremap <silent><C-l> <C-w>l
" move to bottom split
nnoremap <silent><C-j> <C-w>j
" move to top split
nnoremap <silent><C-k> <C-w>k

" vim toggleterm
autocmd TermEnter term://*toggleterm#*
      \ tnoremap <silent><A-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>

nnoremap <silent><A-t> <Cmd>exe v:count1 . "ToggleTerm"<CR>
inoremap <silent><A-t> <Esc><Cmd>exe v:count1 . "ToggleTerm"<CR>
