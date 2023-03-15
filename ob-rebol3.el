;; bare minimum rebol3 ob file
;; by c.p.brown 2023
;; do not use this script, its for my own use only

(require 'ob)

(defun org-babel-execute:rebol3 (body params)
	"execute rebol3 code"
	(setq blkname (format "%s" (nth 4 (org-babel-get-src-block-info))))
	(setq tmpfile (org-babel-temp-file (format "%srebol3temp_" (file-name-directory buffer-file-name)) ".r3"))
	(setq par (mapconcat 'identity (org-babel-variable-assignments:rebol3 params) "\n"))
	(print par)
	(setq newblock
		(replace-regexp-in-string 
			"\\(REBOL[ [a-zA-Z0-9:\n\t\"]+\\)\\([]]+\\)\\([[:unibyte:]]+\\)"
			(concat "\\1]\n" par "\n\\3")
			(org-babel-expand-body:generic body params)
		)
	)
	(print newblock)
	(with-temp-file tmpfile (insert newblock))
	(org-babel-eval 
		(format "%sr3 %s && rm %s" (file-name-directory buffer-file-name) (org-babel-process-file-name tmpfile) (org-babel-process-file-name tmpfile)) "")
)

(defun org-babel-variable-assignments:rebol3 (params)
	"Return a list of rebol3 statements assigning the block's variables."
	(mapcar
		(lambda (pair)
			(cond
				((numberp (cdr pair)) (format "\n%s: %s\n" (car pair) (cdr pair)))
				((stringp (cdr pair)) (format "\n%s: {%s}\n" (car pair) (cdr pair)))
				(t "")
			)
		)
		(org-babel--get-vars params)
	)
)

(provide 'ob-rebol3)
