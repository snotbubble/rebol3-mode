;;; rebol3-mode.el

;; mode for Rebol3: https://github.com/Oldes/Rebol3
;; by c.p.brown 2020~2023
;; acknowledgments above relevant code below
;;
;; do not use this mode, it is a derrived work for my own use,
;; and may contain elisp errors, has missing words, and definitely fights with emacs

;; colors cycle down the list, from red to red
;; originally made for a red-mode, blue colors were used for View and Draw,
;; left them spare, just in case...
;;
;; hex     face             approx. color
;; #FF4D4D control......... brown1, red (css)
;; #E65C73 specialstring... indianred2
;; #CC5C81 series.......... palevioletred3
;; #CC5C95 logic........... hotpink3
;; #BF609F modifiers....... hotpink3
;; #A6624B
;; #9966CC constants....... mediumpurple3
;; #7F6CD9 datatypes....... mediumpurple3
;; #6C7ED9                  --++
;; #527BCC                    || blue reserved for
;; #3992BF                    || ui, draw
;; #3EB2B3                  --++
;; #3EB38C context........ mediumseagreen
;; #3EB365 comment........ mediumseagreen
;; #3FB33E
;; #599C36 help........... olivegreen
;; #89B336 datetime....... olivedrab
;; #B3B22D system......... mustard
;; #BF8C26 io............. goldenrod
;; #CC7B29
;; #D9662B comparison..... chocolate
;; #E64D2E math........... brown2

(defvar rebol3 nil "Support for the Rebol3 programming language, <https://github.com/Oldes/Rebol3>")

;; face definition based on this tutorial by Xah Lee:
;; http://xahlee.info/emacs/emacs/elisp_syntax_coloring.html

(defvar rebol3-comparison-face 'rebol3-comparison-face)
(defvar rebol3-constants-face 'rebol3-constants-face)
(defvar rebol3-context-face 'rebol3-context-face)
(defvar rebol3-control-face 'rebol3-control-face)
(defvar rebol3-datatypes-face 'rebol3-datatypes-face)
(defvar rebol3-datetime-face 'rebol3-datetime-face)
(defvar rebol3-help-face 'rebol3-help-face)
(defvar rebol3-io-face 'rebol3-io-face)
(defvar rebol3-logic-face 'rebol3-logic-face)
(defvar rebol3-math-face 'rebol3-math-face)
(defvar rebol3-modifiers-face 'rebol3-modifiers-face)
(defvar rebol3-series-face 'rebol3-series-face)
(defvar rebol3-specialstring-face 'rebol3-specialstring-face)
(defvar rebol3-system-face 'rebol3-system-face)
(defvar rebol3-var-face 'rebol3-var-face)

(defface rebol3-comparison-face '((t (:foreground "#D9662B" :weight bold))) "comparison" :group 'rebol3-mode)
(defface rebol3-constants-face '((t (:foreground "#9966CC" :weight bold))) "constants" :group 'rebol3-mode)
(defface rebol3-context-face '((t (:foreground "#3EB38C" :weight bold))) "context" :group 'rebol3-mode)
(defface rebol3-control-face '((t (:foreground "#FF4D4D" :weight bold))) "control" :group 'rebol3-mode)
(defface rebol3-datatypes-face '((t (:foreground "#7F6CD9" :weight bold))) "datatypes" :group 'rebol3-mode)
(defface rebol3-datetime-face '((t (:foreground "#89B336" :weight bold))) "datetime" :group 'rebol3-mode)
(defface rebol3-help-face '((t (:foreground "#599C36" :weight bold))) "help" :group 'rebol3-mode)
(defface rebol3-io-face '((t (:foreground "#BF8C26" :weight bold))) "io" :group 'rebol3-mode)
(defface rebol3-logic-face '((t (:foreground "#CC5C95" :weight bold))) "logic" :group 'rebol3-mode)
(defface rebol3-math-face '((t (:foreground "#E64D2E" :weight bold))) "math" :group 'rebol3-mode)
(defface rebol3-modifiers-face '((t (:foreground "#BF609F" :weight bold))) "modifiers" :group 'rebol3-mode)
(defface rebol3-series-face '((t (:foreground "#CC5C81" :weight bold))) "series" :group 'rebol3-mode)
(defface rebol3-specialstring-face '((t (:foreground "#E65C73" :weight bold))) "specialstring" :group 'rebol3-mode)
(defface rebol3-system-face '((t (:foreground "#B3B22D" :weight bold))) "system" :group 'rebol3-mode)
(defface rebol3-var-face '((t (:foreground "#B35147" :weight bold))) "user variables" :group 'rebol3-mode)

(defconst rebol3-comparison-words 
	'(
		"all"
		"and"
		"and~"
		"any"
		"end"
		"equal?"
		"even?"
		"greater-or-equal?"
		"greater?"
		"lesser-or-equal?"
		"lesser?"
		"negative?"
		"not"
		"not-equal?"
		"odd?"
		"or"
		"or~"
		"positive?"
		"same?"
		"sign?"
		"some"
		"strict-equal?"
		"xor"
		"xor?"
		"zero?"
	)
)
(defconst rebol3-control-words
	'(
		"attempt"
		"break"
		"case"
		"catch"
		"compose"
		"continue"
		"disarm"
		"dispatch"
		"do"
		"does"
		"either"
		"else"
		"exit"
		"for"
		"forall"
		"foreach"
		"forever"
		"forskip"
		"func"
		"function"
		"halt"
		"has"
		"if"
		"launch"
		"loop"
		"next"
		"opt"
		"quit"
		"reduce"
		"remove-each"
		"repeat"
		"return"
		"switch"
		"throw"
		"try"
		"unless"
		"until"
		"while"
	)
)
(defconst rebol3-system-words 
	'(
		"bitsets"
		"browse"
		"call"
		"catalog"
		"component?"
		"link?"
		"numeric"
		"protect"
		"protect-system"
		"recycle"
		"system"
		"unprotect"
		"upgrade"
	)
)
(defconst rebol3-io-words 
	'(
		"ask"
		"change-dir"
		"close"
		"confirm"
		"connected?"
		"delete"
		"dispatch"
		"echo"
		"exists?"
		"get-modes"
		"info?"
		"input"
		"input?"
		"list-dir"
		"make-dir"
		"modified?"
		"open"
		"query"
		"read"
		"read-io"
		"rename"
		"resend"
		"save"
		"script?"
		"secure"
		"send"
		"set-modes"
		"set-net"
		"size?"
		"to-local-file"
		"to-rebol-file"
		"update"
		"wait"
		"what-dir"
		"write"
		"write-io"
	)
)
(defconst rebol3-math-words 
	'(
		"abs"
		"absolute"
		"acos"
		"add"
		"arccosine"
		"arcsine"
		"arctangent"
		"complement"
		"cosine"
		"divide"
		"exp"
		"log-10"
		"log-2"
		"log-e"
		"max"
		"maximum"
		"maximum-of"
		"min"
		"minimum"
		"multiply"
		"negate"
		"power"
		"random"
		"remainder"
		"round"
		"sine"
		"square-root"
		"subtract"
		"tangent"
	)
)
(defconst rebol3-specialstring-words 
	'(
		"build-tag"
		"checksum"
		"clean-path"
		"compress"
		"debase"
		"decode-cgi"
		"decompress"
		"dehex"
		"detab"
		"dirize"
		"enbase"
		"entab"
		"form"
		"format"
		"import-email"
		"lowercase"
		"mold"
		"pad"
		"parse-xml"
		"quote"
		"reform"
		"rejoin"
		"remold"
		"reword"
		"split"
		"split-path"
		"suffix"
		"thru"
		"to"
		"trim"
		"uppercase"
	)
)
(defconst rebol3-datatypes-words 
	'(
		"binary"
		"bitset"
		"block"
		"char"
		"charset"
		"construct"
		"date"
		"decimal"
		"email"
		"file"
		"get-word"
		"hash"
		"hex"
		"idate"
		"image"
		"integer"
		"issue"
		"list"
		"lit-path"
		"lit-word"
		"logic"
		"money"
		"pair"
		"paren"
		"path"
		"port"
		"refinement"
		"set-path"
		"set-word"
		"string"
		"tag"
		"time"
		"tuple"
		"url"
		"word"
	)
)
(defconst rebol3-context-words 
	'(
		"alias" 
		"bind" 
		"context" 
		"get" 
		"in" 
		"needs"
		"set" 
		"unset" 
		"use" 
		"value?" 
	)
)
(defconst rebol3-datetime-words 
	'(
		"date" 
		"day" 
		"hour" 
		"minute" 
		"month" 
		"now" 
		"precise" 
		"second"
		"time" 
		"weekday" 
		"year" 
	)
)
(defconst rebol3-help-words 
	'(
		"about"
		"comment"
		"dump-face"
		"dump-obj"
		"help"
		"license"
		"prin"
		"print"
		"probe"
		"source"
		"trace"
		"usage"
		"what"
	)
)
(defconst rebol3-modifiers-words 
	'(
		"all"
		"compare"
		"deep"
		"escape"
		"filter"
		"first"
		"last"
		"left"
		"lines"
		"new"
		"off"
		"only"
		"output"
		"right"
		"with"
	)
)
(defconst rebol3-logic-words 
	'(
		"any-block?"
		"any-function?"
		"any-string?"
		"any-type?"
		"any-word?"
		"as-pair"
		"binary?"
		"bitset?"
		"block?"
		"char?"
		"datatype?"
		"date?"
		"decimal?"
		"dir?"
		"dump-obj"
		"email?"
		"empty?"
		"error?"
		"event?"
		"false"
		"file?"
		"found?"
		"function?"
		"get-word?"
		"hash?"
		"head?"
		"image?"
		"integer?"
		"issue?"
		"library?"
		"list?"
		"lit-path?"
		"lit-word?"
		"logic?"
		"money?"
		"native?"
		"none"
		"none?"
		"number?"
		"object?"
		"op?"
		"pair?"
		"paren?"
		"path?"
		"port?"
		"refinement?"
		"routine?"
		"series?"
		"set-path?"
		"set-word?"
		"string?"
		"struct?"
		"suffix?"
		"tag?"
		"tail?"
		"time?"
		"true"
		"tuple?"
		"type?"
		"unset?"
		"url?"
		"word?"
	)
)
(defconst rebol3-series-words 
	'(
		"alter"
		"append"
		"array"
		"at"
		"back"
		"change"
		"clear"
		"collect"
		"copy"
		"difference"
		"exclude"
		"extract"
		"find"
		"found?"
		"free"
		"head"
		"index?"
		"insert"
		"intersect"
		"join"
		"keep"
		"length?"
		"maximum-of"
		"minimum-of"
		"offset?"
		"parse"
		"pick"
		"poke"
		"remove"
		"remove-each"
		"repend"
		"replace"
		"reverse"
		"select"
		"skip"
		"sort"
		"switch"
		"tail"
		"take"
		"union"
		"unique"
	)
)
(defconst rebol3-constants-words 
	'(
		"black"
		"blue"
		"cyan"
		"green"
		"magenta"
		"red"
		"white"
		"yellow"
	)
)
(defconst rebol3-font-lock-keywords
	(list
		`(,(regexp-opt rebol3-control-words 'words) . rebol3-control-face)
		`(,(regexp-opt rebol3-constants-words 'words) . rebol3-constants-face)
		`(,(regexp-opt rebol3-system-words 'words) . rebol3-system-face)
		`(,(regexp-opt rebol3-context-words 'words) . rebol3-context-face)
		`(,(regexp-opt rebol3-comparison-words 'words) . rebol3-comparison-face)
		`(,(regexp-opt rebol3-datetime-words 'words) . rebol3-datetime-face)
		`(,(regexp-opt rebol3-modifiers-words 'words) . rebol3-modifiers-face)
		`(,(regexp-opt rebol3-io-words 'words) . rebol3-io-face)
		`(,(regexp-opt rebol3-math-words 'words) . rebol3-math-face)
		`(,(regexp-opt rebol3-specialstring-words 'words) . rebol3-specialstring-face)
		`(,(regexp-opt rebol3-series-words 'words) . rebol3-series-face)
		`(,(regexp-opt rebol3-datatypes-words 'words) . rebol3-datatypes-face)
		`(,(regexp-opt rebol3-logic-words 'words) . rebol3-logic-face)
		`(,(regexp-opt rebol3-help-words 'words) . rebol3-help-face)
	)
)

;; syntax table partly based on rebol.el, made by:
;;     1998: jrm <bitdiddle@hotmail.com>
;;     ????: Marcus Petersson <d4marcus@dtek.chalmers.se>
;;     1999: Jeff Kreis <jeff@rebol.com>
;;     2001: Sterling Newton <sterling@rebol.com>
;; http://www.rebol.com/tools/rebol.el

(defconst rebol3-mode-syntax-table
	(let 
		(
			(i 0)
			(table (make-syntax-table))
		)
		(while 
			(< i 256)
			(modify-syntax-entry i "_" table)
			(setq i (1+ i))
		)
		(setq i ?0)
		(while 
			(<= i ?9)
			(modify-syntax-entry i "w" table)
			(setq i (1+ i))
		)
		(setq i ?A)
		(while 
			(<= i ?Z)
			(modify-syntax-entry i "w" table)
			(setq i (1+ i))
		)
		(setq i ?a)
		(while 
			(<= i ?z)
			(modify-syntax-entry i "w" table)
			(setq i (1+ i))
		)
		(modify-syntax-entry ?\n ">" table)
		(modify-syntax-entry ?\[ "(]" table)
		(modify-syntax-entry ?\] ")[" table)
		(modify-syntax-entry ?\( "()" table)
		(modify-syntax-entry ?\) ")(" table)
		(modify-syntax-entry ?\; "<" table)
		(modify-syntax-entry ?< "(>" table)
		(modify-syntax-entry ?> ")<" table)
		(modify-syntax-entry ?\" "\"" table)
		(modify-syntax-entry ?{ "|" table)
		(modify-syntax-entry ?} "|" table)
		(modify-syntax-entry ?' "_p" table)
		(modify-syntax-entry ?` "_p" table)
		(modify-syntax-entry ?^ "\\" table)
		(modify-syntax-entry ?? "w" table)
		table
	)
)

(defvar rebol3-mode-hook nil "hook for rebol3-mode")

;;;###autiload
(defun rebol3-mode ()
	"Major mode for editing Rebol3 code"
	(kill-all-local-variables)
	(setq-local indent-tabs-mode 'only)
	;(setq-local c-indent 4)
	;(setq-local tab-width 4)
	;(setq-local tab-stop-list (number-sequence 4 120 4))
	;(setq-local electric-indent-mode -1)
	(setq mode-name "rebol3" major-mode 'rebol3-mode)
	(setq-local comment-start ";")
	(set-syntax-table rebol3-mode-syntax-table)
	(setq-local font-lock-defaults '(rebol3-font-lock-keywords))
	(run-hooks 'rebol3-mode-hook)
)

(provide 'rebol3-mode)
