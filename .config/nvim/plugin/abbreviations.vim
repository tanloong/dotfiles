iabbrev teh the
iabbrev NOne None
iabbrev slef self
iabbrev udpate update
iabbrev wnat want

" Save files that require root permission
cabbrev w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!
