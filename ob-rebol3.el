;; bare minimum rebol3 ob file
;; by c.p.brown 2023
;; do with as you please
;;
;; handles string and number (int & float) variables
;;
;; expects the rebol3 binary to be named 'r3' and saved in the same directory as the orgfile.
;; get rebol3 from https://github.com/Oldes/Rebol3/releases
;;
;; Made for encapsulated projects where stuff just has to work from the project directory,
;; regardless of wherever (and which machine) that directory is copied to... and when.
;; Temp files are saved as ./r3temp_[kbmash] and are deleted after each run, otherwise they accumulate.
;;
;; get this working by saving it to ~./emacs.d
;; then add the following indicated lines to ~./.emacs
;;
;; ->    (load-file "~/.emacs.d/ob-rebol3.el")
;;       (org-babel-do-load-languages 'org-babel-load-languages '(
;; ->        (rebol3 . t)
;;       ))
;;
;; remove by hosing the indicated lines and deleting the file

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
