;; Shell command key:
;; (xbindkey key "foo-bar-command [args]")
;; (xbindkey '(modifier* key) "foo-bar-command [args]")
;;
;; Scheme function key:
;; (xbindkey-function key function-name-or-lambda-function)
;; (xbindkey-function '(modifier* key) function-name-or-lambda-function)
;;
;; Other functions:
;; (remove-xbindkey key)
;; (run-command "foo-bar-command [args]")
;; (grab-all-keys)
;; (ungrab-all-keys)
;; (remove-all-keys)
;; (debug)

(define (bindkeys command . keys)
  (let ((bind-func (if (string? command)
                       xbindkey
                       xbindkey-function)))
    (for-each (lambda (key) (bind-func key command))
              keys)))

(define (session? . allowed-sessions)
  (let ((session (getenv "SESSION")))
    (and session
         (member session
                 allowed-sessions))))

(unless (session? "emacs")
  (bindkeys "alacritty"
            '(mod4 space))

  (bindkeys "emacsclient -c -a ''"
            '(mod4 e))
  (bindkeys "emacs"
            '(mod4 control e)))

(bindkeys "zsh -c 'if (( $(light) < 9 )); then light -S 10; else light -A 10; fi'"
          'XF86MonBrightnessUp)
(bindkeys "zsh -c 'if (( $(light) > 10 )); then light -U 10; else light -S 1; fi'"
          'XF86MonBrightnessDown)
(bindkeys "light -S 100"
          '(mod4 XF86MonBrightnessUp))
(bindkeys "light -S 1"
          '(mod4 XF86MonBrightnessDown))
(bindkeys "notify-send `light`"
          '(mod4 control XF86MonBrightnessUp))

(bindkeys "compton-invert -Asr"
          '(mod4 Prior))
(bindkeys "compton-invert -Dsr"
          '(mod4 Next))

(bindkeys "rox"
          '(mod4 control grave))

(bindkeys "kvm-switch"
          'Scroll_Lock)

(unless (session? "xmonad")
  (bindkeys "firefox -P default --private-window"
            '(mod4 control shift o)))

(bindkeys "dmenu_run -f -l 16"
          '(mod4 r))

(bindkeys "firefox-vanilla"
          '(mod4 mod5 control shift o))

(let ((i3lock "i3lock -c 222222 --show-failed-attempts"))
  (bindkeys i3lock
            '(release XF86ScreenSaver)
            '(release control shift mod4 l))
  (unless (session? "stumpwm")
    (bindkeys i3lock
              '(release shift mod4 l))))

(bindkeys "mpc-rand"
          '(mod4 shift mod5 m))
(bindkeys "pamixer -t"
          'XF86AudioMute)
(bindkeys "amixer set Capture toggle | grep -o '\\[on\\]\\|\\[off\\]' | head -n1 | xargs notify-send"
          'XF86AudioMicMute
          '(shift XF86AudioMute))
(bindkeys "pamixer -d 3"
          'XF86AudioLowerVolume)
(bindkeys "pamixer -i 3"
          'XF86AudioRaiseVolume)
(bindkeys "media-prev"
          '(mod4 control comma)
          'XF86AudioPrev)
(bindkeys "media-next"
          '(mod4 control period)
          'XF86AudioNext)
(bindkeys "media-seek-backward"
          'XF86AudioRewind)
(bindkeys "media-seek-forward"
          'XF86AudioForward)
(bindkeys "media-stop"
          '(mod4 control slash)
          'XF86AudioStop)
(bindkeys "media-toggle"
          '(mod4 grave)
          '(mod4 slash)
          'XF86AudioPlay
          "c:208"
          "c:209")
(bindkeys "mpcauth toggle"
          '(mod4 XF86AudioPlay))

(unless (session? "xmonad")
  (bindkeys "alacritty --class IRC --title IRC -e irc"
            '(mod4 F10))
  (bindkeys "alacritty --class IRC --title 'IRC (mosh)' -e irc --mosh"
            '(mod4 control F10)))

(bindkeys "pkill -HUP xbindkeys"
          '(mod4 mod5 shift r))

(bindkeys "keepassxc"
          '(mod4 shift y))
(bindkeys "yubi-oath"
          '(mod4 y))

(bindkeys "dmenu_translate -g"
          '(mod4 backslash))
(bindkeys "dmenu_translate -g -f pl -t en"
          '(mod4 shift backslash))
(bindkeys "zsh -c 'urxvt -e less -R =(trans en:pl \\\"`xsel -o`\\\")'"
          '(mod4 control backslash))

(bindkeys "maim -u -s | pngquant - | xclip -i -selection clipboard -t image/png"
          '(release Print))
(bindkeys "scrot-upload"
          '(release mod4 Print))
(bindkeys "scrot -s"
          '(release control Print))
(bindkeys "scrot -s --exec 'mtpaint $f; rm -f $f'"
          '(release mod5 Print))

(bindkeys "clipboard-actions"
          '(mod4 v))

(bindkeys "xset r rate 300 30"
          '(mod4 Insert))

(bindkeys "compton-trans -c -o -20"
          '(mod4 control minus))
(bindkeys "compton-trans -c -o +20"
          '(mod4 control equal))

(bindkeys "redshift -O 3700"
          '(mod4 mod1 shift Down)
          '(mod4 mod1 shift Right))
(bindkeys "redshift -x"
          '(mod4 shift Left)
          '(mod4 mod1 shift Left))
(bindkeys "redshift -P -o"
          '(mod4 shift Down))
(bindkeys "redshift-toggle"
          '(mod4 control space))
(bindkeys "redshift -O 4500"
          '(mod4 shift Right))
