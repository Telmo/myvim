"=============================================================================
" FILE: manual.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu at gmail.com>
" Last Modified: 29 Jan 2014.
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#manual#define()
  return s:source
endfunction

let s:source = {
      \ 'name' : 'manual',
      \ 'description' : 'candidates from unite sources by manual',
      \ 'action_table' : {},
      \ 'default_action' : 'narrow',
      \ 'is_listed' : 0,
      \}

function! s:source.change_candidates(args, context) "{{{
  let _ = []
  if a:context.input !~ ':'
    let _ += map(filter(values(unite#init#_sources([], a:context.input)),
            \ 'v:val.is_listed'), "{
            \ 'word' : v:val.name,
            \ 'abbr' : unite#util#truncate(v:val.name, 25) .
            \         (v:val.description != '' ? ' -- ' . v:val.description : ''),
            \ 'source__word' : v:val.name . ':',
            \ }")
    if exists('*neobundle#get_unite_sources')
      let _ += map(neobundle#get_unite_sources(), "{
            \ 'word' : v:val,
            \ 'source__word' : v:val . ':',
            \ }")
    endif
  else
    let _ += map(unite#complete#source(a:context.input,
          \ 'Unite ' . a:context.input, 0), "{
          \ 'word' : v:val,
          \ 'source__word' : v:val . ':',
          \ }")
  endif

  return _
endfunction"}}}

" Actions "{{{
let s:source.action_table.narrow = {
      \ 'description' : 'narrow source',
      \ 'is_quit' : 0,
      \ }
function! s:source.action_table.narrow.func(candidate) "{{{
  call unite#mappings#narrowing(a:candidate.source__word)
endfunction"}}}
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo
