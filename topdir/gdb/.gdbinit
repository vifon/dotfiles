set disassembly-flavor intel

define term
  dont-repeat
  tty /dev/$arg0
  set env TERM rxvt-unicode-256color
end

set print pretty
set print array
