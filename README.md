# config
```
(load-file "~/.emacs.d/rebol3-mode.el")
(require 'rebol3-mode)
(add-to-list 'auto-mode-alist '("\\.r3\\'" . rebol3-mode))
(add-to-list 'magic-mode-alist '("REBOL [ ]" . rebol3-mode) )
(load-file "~/.emacs.d/ob-rebol3.el")
```
more config to enable tabs
```
(add-hook 'rebol3-mode-hook
	(lambda ()
		(setq indent-tabs-mode t)
		(setq c-indent 4)
		(setq tab-width 4)
		(local-set-key (kbd "<tab>") 'my-insert-tab-char)
		(local-set-key (kbd "TAB") 'my-insert-tab-char)
	)
)
(setq org-src-preserve-indentation t)
```
# note
- highlighter is pretty crude, lacks `^` escaping for example
- `call` needs to be `call [ "process" "args" ]` on linux
- built for portable projects, where the rebol3 binary is saved as `r3` in the same location as the org-file
- given the above, temp scripts are run from the same location and deleted
