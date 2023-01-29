;; bare minimum rebol3 ob file
;; by c.p.brown 2023
;; do with as you please
;;
;; handles string and number (int & float) variables
;; not tested with multiline srings yet
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
;;
;; for (incomplete) syntax highlighting grab rebol3-mode.el from http://www.github.com/snotbubble/reeebmode
;; its just a copy of red-mode so needs some work...

(require 'ob)

(defun org-babel-execute:rebol3 (body params)
    "execute rebol3 code"
    (setq tmpfile (org-babel-temp-file (format "%sr3temp_" (file-name-directory buffer-file-name))))
    (with-temp-file tmpfile (insert (concat "REBOL [ ]\n" (org-babel-variable-assignments:rebol3 params) (org-babel-expand-body:generic body params) )))
    (org-babel-eval (format "%sr3 %s && rm %s" (file-name-directory buffer-file-name) (org-babel-process-file-name tmpfile) (org-babel-process-file-name tmpfile)) "")
)

(defun org-babel-variable-assignments:rebol3 (params)
  "Return a list of rebol3 statements assigning the block's variables."
    (replace-regexp-in-string "^ |[()]+" "" (format "%s" 
        (mapcar
            (lambda (pair)
                (cond
                    ((numberp (cdr pair)) (format "%s: %s" (car pair) (cdr pair)))
                    ((stringp (cdr pair)) (format "%s: {%s}" (car pair) (cdr pair)))
                    (t "")
                )
            )
            (org-babel--get-vars params)
        )
    ))
)

(provide 'ob-rebol3)
