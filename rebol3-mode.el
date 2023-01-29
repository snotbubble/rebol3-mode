;;; reebol3-mode.el -*- coding: utf-8; lexical-binding: t; -*-

;; modified from sample in this article:
;; How to Write a Emacs Major Mode for Syntax Coloring By Xah Lee. 2008-11-30
;; http://www.ergoemacs.org/emacs/elisp_syntax_coloring.html

;; faces for this mode - cpb 2301
;; colors cycle down the list, from red to red, except for uservars
;;
;; #FF4D4D - control......... red
;; #E65C73 - specialstring
;; #CC5C81 - series
;; #CC5C95 - logic
;; #BF609F - modifiers
;; #A6624B - uservars....... brown (disabled for now; regex issues)
;; #9966CC - constants...... purple
;; #7F6CD9 - datatypes
;; #6C7ED9 - viewobj........ blue
;; #527BCC - viewcmd
;; #3992BF
;; #3EB2B3 - viewprop....... cyan
;; #3EB38C - context
;; #3EB365 - comment........ forest-green
;; #3FB33E
;; #599C36 - help........... green
;; #89B336 - datetime....... olive
;; #B3B22D - system
;; #BF8C26 - io............. yellow
;; #CC7B29 - events
;; #D9662B - comparison
;; #E64D2E - math

(defvar rebol3-system-word 'rebol3-system-word)
(defface rebol3-system-word '((t (:foreground "#B3B22D" :weight bold)))
	"system"
	:group 'rebol3-mode)

(defvar rebol3-io-word 'rebol3-io-word)
(defface rebol3-io-word '((t (:foreground "#BF8C26" :weight bold)))
	"io"
	:group 'rebol3-mode)

(defvar rebol3-events-word 'rebol3-events-word)
(defface rebol3-events-word '((t (:foreground "#CC7B29" :weight bold)))
	"events"
	:group 'rebol3-mode)

(defvar rebol3-comparison-word 'rebol3-comparison-word)
(defface rebol3-comparison-word '((t (:foreground "#D9662B" :weight bold)))
	"comparison"
	:group 'rebol3-mode)

(defvar rebol3-math-word 'rebol3-math-word)
(defface rebol3-math-word '((t (:foreground "#E64D2E" :weight bold)))
	"math"
	:group 'rebol3-mode)

(defvar rebol3-control-word 'rebol3-control-word)
(defface rebol3-control-word '((t (:foreground "#FF4D4D" :weight bold)))
	"control"
	:group 'rebol3-mode)

(defvar rebol3-specialstring-word 'rebol3-specialstring-word)
(defface rebol3-specialstring-word '((t (:foreground "#E65C73" :weight bold)))
	"specialstring"
	:group 'rebol3-mode)

(defvar rebol3-series-word 'rebol3-series-word)
(defface rebol3-series-word '((t (:foreground "#CC5C81" :weight bold)))
	"series"
	:group 'rebol3-mode)

(defvar rebol3-logic-word 'rebol3-logic-word)
(defface rebol3-logic-word '((t (:foreground "#CC5C95" :weight bold)))
	"logic"
	:group 'rebol3-mode)

(defvar rebol3-modifiers-word 'rebol3-modifiers-word)
(defface rebol3-modifiers-word '((t (:foreground "#BF609F" :weight bold)))
	"modifiers"
	:group 'rebol3-mode)

(defvar rebol3-var-word 'rebol3-var-word)
(defface rebol3-var-word '((t (:foreground "#B35147" :weight bold)))
	"user variables"
	:group 'rebol3-mode)

(defvar rebol3-constants-word 'rebol3-constants-word)
(defface rebol3-constants-word '((t (:foreground "#9966CC" :weight bold)))
	"constants"
	:group 'rebol3-mode)

(defvar rebol3-datatypes-word 'rebol3-datatypes-word)
(defface rebol3-datatypes-word '((t (:foreground "#7F6CD9" :weight bold)))
	"datatypes"
	:group 'rebol3-mode)

(defvar rebol3-viewobj-word 'rebol3-viewobj-word)
(defface rebol3-viewobj-word '((t (:foreground "#6C7ED9" :weight bold)))
	"viewobj"
	:group 'rebol3-mode)

(defvar rebol3-drawobj-word 'rebol3-drawobj-word)
(defface rebol3-drawobj-word '((t (:foreground "#6C7ED9" :weight bold)))
	"drawobj"
	:group 'rebol3-mode)

(defvar rebol3-viewcmd-word 'rebol3-viewcmd-word)
(defface rebol3-viewcmd-word '((t (:foreground "#527BCC" :weight bold)))
	"viewcmd"
	:group 'rebol3-mode)

(defvar rebol3-drawcmd-word 'rebol3-drawcmd-word)
(defface rebol3-drawcmd-word '((t (:foreground "#527BCC" :weight bold)))
	"drawcmd"
	:group 'rebol3-mode)

(defvar rebol3-viewprp-word 'rebol3-viewprp-word)
(defface rebol3-viewprp-word '((t (:foreground "#3EB2B3" :weight bold)))
	"viewprp"
	:group 'rebol3-mode)

(defvar rebol3-drawprp-word 'rebol3-drawprp-word)
(defface rebol3-drawprp-word '((t (:foreground "#3EB2B3" :weight bold)))
	"drawprp"
	:group 'rebol3-mode)

(defvar rebol3-context-word 'rebol3-context-word)
(defface rebol3-context-word '((t (:foreground "#3EB38C" :weight bold)))
	"context"
	:group 'rebol3-mode)

(defvar rebol3-comment-word 'rebol3-comment-word)
(defface rebol3-comment-word '((t (:foreground "#3EB365" :weight bold)))
	"modifiers"
	:group 'rebol3-mode)

(defvar rebol3-help-word 'rebol3-help-word)
(defface rebol3-help-word '((t (:foreground "#599C36" :weight bold)))
	"help"
	:group 'rebol3-mode)

(defvar rebol3-datetime-word 'rebol3-datetime-word)
(defface rebol3-datetime-word '((t (:foreground "#89B336" :weight bold)))
	"datetime"
	:group 'rebol3-mode)


;; override fonts, this is applies to all buffers, envestigate a local option
(set-face-foreground 'font-lock-string-face "#3EB365")
(set-face-foreground 'font-lock-comment-face "#4E736D")
(set-face-foreground 'default "#86B5BF")

;; create the list for font-lock.
;; each category of keyword is given a particular face 
(
	setq rebol3-font-lock-keywords (
		let* (
			;; define several category of keywords
			;;
			;; red/rebol words sourced from http://www.rebol.org/view-script.r?script=code-colorizer.r
			;; by David Oliva 2009
			(x-comparison '("all" "and" "and~" "any" "equal?" "even?" "greater-or-equal?" "greater?" "lesser-or-equal?" "lesser?" "negative?" "not" "not-equal?" "odd?" "or" "or~" "positive?" "same?" "sign?" "strict-equal?" "xor" "xor?" "zero?" ))
			(x-context '("alias" "bind" "context" "get" "in" "set" "unset" "use" "value?" "needs"))
			(x-control '("Red" "opt" "attempt" "break" "case" "catch" "compose" "disarm" "dispatch" "does" "either" "else" "exit" "forall" "foreach" "for" "forever" "forskip" "func" "function" "halt" "has" "if" "launch" "loop" "next" "quit" "reduce" "remove-each" "repeat" "return" "switch" "throw" "try" "unless" "until" "while" "do" ))
			(x-help '("prin" "print" "about" "comment" "dump-face" "dump-obj" "help" "license" "probe" "source" "trace" "usage" "what"))
			(x-logic '("found?" "true" "false" "none" "any-block?" "any-function?" "any-string?" "any-type?" "any-word?" "as-pair" "binary?" "bitset?" "block?" "char?" "datatype?" "date?" "decimal?" "dir?" "dump-obj" "email?" "empty?" "error?" "event?" "file?" "function?" "get-word?" "head?" "hash?" "image?" "integer?" "issue?" "library?" "list?" "lit-path?" "lit-word?" "logic?" "money?" "native?" "none?" "number?" "object?" "op?" "pair?" "paren?" "path?" "port?" "refinement?" "routine?" "series?" "set-path?" "set-word?" "string?" "struct?" "suffix?" "tag?" "tail?" "time?" "tuple?" "type?" "unset?" "url?" "word?"))
			(x-datatypes '("to-binary" "to-bitset" "to-block" "to-char" "to-date" "to-decimal" "to-email" "to-file" "to-get-word" "to-hash" "to-hex" "to-idate" "to-image" "to-integer" "to-issue" "to-list" "to-lit-path" "to-lit-word" "to-logic" "to-money" "to-pair" "to-paren" "to-path" "to-refinement" "to-set-path" "to-set-word" "to-string" "to-tag" "to-time" "to-tuple" "to-url" "to-word" "construct" "deep-reactor" "reactor"))
			(x-math '("abs" "absolute" "add" "arccosine" "acos" "arcsine" "arctangent" "complement" "cosine" "divide" "exp" "log-10" "log-2" "log-e" "maximum-of" "maximum" "max"  "min" "minimum" "multiply" "negate" "power" "random" "remainder" "round" "sine" "square-root" "subtract" "tangent"))
			(x-io '("ask" "change-dir" "close" "confirm" "connected?" "delete" "dispatch" "echo" "exists\\s\\?" "get-modes" "info?" "input" "input?" "list-dir" "make-dir" "modified?" "open"  "query" "read" "read-io" "rename" "resend" "save" "script?" "secure" "send" "set-modes" "set-net" "size?" "to-local-file" "to-rebol-file" "update" "wait" "what-dir" "write-io" "write" ))
			(x-series '("alter" "append" "array" "at" "back" "change" "clear" "collect" "copy" "difference" "exclude" "extract" "find" "first" "found?" "free" "head" "index?" "insert" "intersect" "join" "keep" "last" "length?" "maximum-of" "minimum-of" "offset?" "parse" "pick" "poke" "remove" "remove-each" "repend" "replace" "reverse" "select" "skip" "sort" "switch" "tail" "union" "unique"))
			(x-specialstring '("build-tag" "checksum" "clean-path" "compress" "debase" "decode-cgi" "decompress" "dehex" "detab" "dirize" "enbase" "entab" "form" "import-email" "lowercase" "mold" "parse-xml" "pad" "quote" "reform" "rejoin" "remold" "split-path" "suffix" "trim" "uppercase" "to" "thru"))
			(x-system '("browse" "call" "component?" "link?" "protect" "protect-system" "recycle" "unprotect" "upgrade"))
			(x-datetime '("now" "date" "time" "precise" "weekday" "month" "year" "second"))
			(x-viewcmd '("across" "alert" "as-pair" "below" "brightness?" "caret-to-offset" "center-face" "choose" "clear-fields" "do-events" "flash" "focus" "hide-popup" "hide" "in-window?" "inform" "link?" "load-image" "make-face" "offset-to-caret" "request-color" "request" "request-date" "request-download" "request-file" "request-list" "request-pass" "request-text" "return" "show-popup" "show" "size-text" "span?" "stylize" "unfocus" "unview" "viewed?" "within?"))
			(x-viewobj '("panel" "font" "area" "check" "face" "tab-panel" "button" "image" "field" "drop-list" "drop-down" "text-list" "text" "slider" "layout" "view"))
			(x-viewprp '("all-over" "anti-alias" "text" "offset" "size" "x" "y" "data" "extra" "options" "flags" "color" "font-size" "font-weight" "font-name" "font-style" "font-color" "selected" "pane" "tight" "loose" "bold" "picked" "parent" "transparent"))
			(x-constants '("black" "red" "white" "green" "papaya" "blue"))
			(x-events '("event" "on-change" "on-enter" "on-menu" "on-down" "on-up" "on-resizing" "react" "on-drag" "on-mid-down" "on-mid-up" "on-wheel" "on-over"))
			(x-drawcmd '("draw"))
			(x-drawobj '("box" "line" "circle" "arc" "pen" "fill-pen"))
			(x-modifiers '("compare" "with" "left" "right" "only" "off" "deep" "output" "filter"))
			;; generate regex string for each category of keywords
			;; suffixed words 1st, as they contain many duplicates
			(x-logic-regexp (regexp-opt x-logic 'words))
			;; hyphenated words, may contain duplicates
			(x-datatypes-regexp (regexp-opt x-datatypes 'words))
			(x-viewprp-regexp (regexp-opt x-viewprp 'words))
			(x-events-regexp (regexp-opt x-events 'words))
			;; special exception
			(x-comparison-regexp (regexp-opt x-comparison 'words))
			;; may contain the odd hyphen or suffix, but mostly pure
			(x-context-regexp (regexp-opt x-context 'words))
			(x-io-regexp (regexp-opt x-io 'words))
			(x-system-regexp (regexp-opt x-system 'words))
			(x-help-regexp (regexp-opt x-help 'words))
			(x-math-regexp (regexp-opt x-math 'words))
			(x-specialstring-regexp (regexp-opt x-specialstring 'words))
			(x-viewobj-regexp (regexp-opt x-viewobj 'words))
			(x-control-regexp (regexp-opt x-control 'words))
			;; 'pure' words; no hyphens, suffixes etc.
			(x-viewcmd-regexp (regexp-opt x-viewcmd 'words))
			(x-datetime-regexp (regexp-opt x-datetime 'words))
			(x-series-regexp (regexp-opt x-series 'words))
			(x-constants-regexp (regexp-opt x-constants 'words))
			(x-drawcmd-regexp (regexp-opt x-drawcmd 'words))
			(x-drawobj-regexp (regexp-opt x-drawobj 'words))
			(x-modifiers-regexp (regexp-opt x-modifiers 'words))
		)
		`(
			;; suffixed
			(,"[A-Za-z]+\\?+" . rebol3-logic-word)
			(,x-logic-regexp . rebol3-logic-word) 
			;; hyphenated
			(,x-datatypes-regexp . rebol3-datatypes-word) 
			(,x-viewprp-regexp . rebol3-viewprp-word) 
			(,x-events-regexp . rebol3-events-word)
			;; special exception
			(,x-comparison-regexp . rebol3-comparison-word)
			;; some suffixes or hyphens
			(,x-context-regexp . rebol3-context-word) 
			(,x-io-regexp . rebol3-io-word) 
			(,x-system-regexp . rebol3-system-word) 
			(,x-help-regexp . rebol3-help-word)
			(,x-math-regexp . rebol3-math-word) 
			(,x-specialstring-regexp . rebol3-specialstring-word) 
			(,x-viewobj-regexp . rebol3-viewobj-word) 
			(,x-control-regexp . rebol3-control-word)
			;; pure
			(,x-viewcmd-regexp . rebol3-viewcmd-word) 
			(,x-datetime-regexp . rebol3-datetime-word) 
			(,x-series-regexp . rebol3-series-word) 
			(,x-constants-regexp . rebol3-constants-word) 
			(,x-drawcmd-regexp . rebol3-drawcmd-word) 
			(,x-drawobj-regexp . rebol3-drawobj-word) 
			(,x-modifiers-regexp . rebol3-modifiers-word)
			;; note: order above matters, because once colored, that part won't change.
			;; in general, put longer words first
		)
	)
)

;;;###autoload
(
	define-derived-mode rebol3-mode lisp-mode "rebol3 mode"
	"Major mode for editing Rebol3…"
	;; code for syntax highlighting
	(
		setq font-lock-defaults '(
			(
				rebol3-font-lock-keywords
			)
		)
	)
)

;; add the mode to the `features' list
(provide 'rebol3-mode)

;;; rebol3-mode.el ends here
