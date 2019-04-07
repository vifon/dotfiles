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
  (bindkeys "sh -c 'exec urxvtcd || exec urxvt'"
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
  (bindkeys "firefox"
            '(mod4 control shift o)))

(bindkeys "/usr/bin/octave --force-gui -q"
          'XF86Calculator)
(bindkeys "urxvtcd -e sh -c '/usr/bin/locate \"\" | fzf | tr -d \"\\n\" | xsel -i'"
          'XF86Search)
(bindkeys "eject /dev/sr0"
          'XF86Eject)
(bindkeys "slock"
          '(release XF86ScreenSaver)
          '(release control shift mod4 l)
          '(release shift mod4 l))
(bindkeys "mpc-rand"
          '(mod4 shift mod5 m))
(bindkeys "amixer -D pulse set Master Playback Switch toggle &> /dev/null && sleep 0.1 && killall -USR1 i3status"
          'XF86AudioMute)
(bindkeys "amixer set Speaker toggle &> /dev/null && sleep 0.1 && killall -USR1 i3status"
          '(mod1 XF86AudioMute))
(bindkeys "amixer set Capture toggle | grep -o '\\[on\\]\\|\\[off\\]' | head -n1 | xargs notify-send"
          'XF86AudioMicMute)
(bindkeys "amixer -D pulse set Master 5%- && killall -USR1 i3status"
          'XF86AudioLowerVolume)
(bindkeys "amixer -D pulse set Master 5%+ && killall -USR1 i3status"
          'XF86AudioRaiseVolume)
(bindkeys "media-prev"
          '(mod4 control comma)
          'XF86AudioPrev)
(bindkeys "media-next"
          '(mod4 control period)
          'XF86AudioNext)
(bindkeys "media-stop"
          '(mod4 control slash)
          'XF86AudioStop)
(bindkeys "media-toggle"
          '(mod4 grave)
          '(mod4 slash)
          'XF86AudioPlay
          "c:208"
          "c:209")

(bindkeys "urxvtcd -title IRC -e wbd"
          '(mod4 F10))
(bindkeys "urxvtcd -title 'IRC [mosh]' -e wbd --mosh"
          '(mod4 control F10))

(bindkeys "dmenu_launcher"
          '(mod4 y))

(bindkeys "dmenu_translate -g"
          '(mod4 backslash))
(bindkeys "dmenu_translate -g -f pl -t en"
          '(mod4 shift backslash))
(bindkeys "zsh -c 'urxvt -e less -R =(trans en:pl \\\"`xsel -o`\\\")'"
          '(mod4 control backslash))

(bindkeys "scrot-upload"
          '(release Print))
(bindkeys "scrot-upload 1"
          '(release mod4 Print))
(bindkeys "scrot -s"
          '(release control Print))
(bindkeys "scrot -s --exec 'mtpaint $f; rm -f $f'"
          '(release mod5 Print))

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
(bindkeys "redshift -o"
          '(mod4 shift Down)
          '(mod4 control space))
(bindkeys "redshift -O 4500"
          '(mod4 shift Right))
