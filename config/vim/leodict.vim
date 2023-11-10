function! OpenSelectedWordInBrowser()
  let selected_word = expand("<cWORD>")
  let url = "https://dict.leo.org/german-english/" . selected_word
  silent! execute "!xdg-open " . url
endfunction

noremap <Leader>g :call OpenSelectedWordInBrowser()<CR>

