; TODO: Emacs proofreading.
; TODO: Emacs/CLI MTA helyesírás tool.
; TODO: List of modes/areas where no highlights are required.
; TODO: Should highlights re-bind upon modifications or commands?
; TODO: Finalize highlights:
;    * word(part) repetitions: 4-5 char substrings...
;    * region repetitions (verbatim): wrong copy-paste.
;    * M-s r w: whole buffer (find-reperr-whole-buffer)
;    * M-s r c: continue from here (find-reperr-from-point)
;    * List of ignores for repeating words...
;    * Remove all other highlights when using repeats.
;    * Removing overlays: deletes them or hides them?
;    * Keep list of highlighted words ("known repeats") w/ faces
;      * -> use consistently?
;    * Go through word-by-word (save_excursion)
;      at each word highlight +- context.
;    * Solve how to find substricts ("stems")
;      * if a known is a substr of another, delete the bigger one.
;    * Save the regexp as attribute too and delete overlays based on that.

;; General setup and parameters.
(setq context-size 50)
(setq min-repeats 2)
(setq min-letters 4)

(setq repeat-hl-faces hi-lock-face-defaults)

(global-set-key (kbd "M-s r h") 'highlight-repeats)
(global-set-key (kbd "M-s r u") 'unhighlight-repeats)

;; The main command functions.
(defun highlight-repeats ()
  (interactive)
  (unhighlight-repeats)
  (setq begin (max (point-min) (- (window-start) context-size)))
  (setq end (min (point-max) (+ (window-end) context-size)))
  (setq curr-block (buffer-substring-no-properties begin end))
  (setq repeats (mapcar 'car (get-repeats curr-block)))
  (setq face-id 0)
  (dolist (rep repeats)
    (highlight-for-repeats
     (concat "\\<" rep "\\>")
     (nth face-id repeat-hl-faces)
     begin end)
    (setq face-id (mod (1+ face-id) (length repeat-hl-faces)))))

(defun unhighlight-repeats ()
  (interactive)
  (remove-overlays nil nil 'repeats t))

;; The implementation helper functions.
(defun highlight-for-repeats (regexp face search-start search-end)
  (let* ((no-matches t))
    (save-excursion
      (goto-char search-start)
      (while (re-search-forward regexp search-end t)
        (when no-matches (setq no-matches nil))
        (let ((overlay (make-overlay (match-beginning 0)
                                     (match-end 0))))
          (overlay-put overlay 'repeats t)
          (overlay-put overlay 'face face))
        (goto-char (match-end 0))))))

(defun count-each-word (l)
  (let ((tempList l)
        (occ 0)
        (result ()))
    (while (not (equal tempList ()))
      (setq occ (seq-count (lambda (m)
        (equal (downcase m) (downcase (car tempList)))) tempList))
      (setq result (cons (cons (downcase (car tempList))
        (cons occ ())) result))
      (setq tempList (cl-remove-if (lambda (m)
        (equal (downcase m) (downcase (car tempList)))) tempList)))
      (nreverse result)))

(defun get-repeats (str)
  (let ((filtered-inp (cl-remove-if
    (lambda (m) (< (string-width m) min-letters))
    (split-string str "[[:punct:][:digit:][:space:]\n]" t))))
  (cl-remove-if (lambda (k)
    (< (nth 1 k) min-repeats)) (count-each-word filtered-inp))))
