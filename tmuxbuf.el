;;; tmuxbuf.el --- Emacs Interface to Tmux buffers

;; Copyright (C) 2022 Todd Short

;; Author: Todd Short <todd.m.short@ Leo Shidai Liu <shidai.liu@gmail.com>
;; Keywords: convenience, tools
;; Created: 2022-02-23

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; This code provides an Emacs interface to tmux buffers.

;;; Code:

(setq tmux-copy-process nil)
(defun tmux-copy (text)
  (if (not (getenv "TMUX"))
      nil
    (setq tmux-copy-process (make-process :name "tmux"
                                          :buffer nil
                                          :command '("tmux" "load-buffer" "-b" "emacs" "-")
                                          :connection-type 'pipe))
    (process-send-string tmux-copy-process text)
    (process-send-eof tmux-copy-process)))

(defun tmux-paste ()
  (if (not (getenv "TMUX"))
      nil
    (shell-command-to-string "tmux show-buffer -b emacs")))
  
;;;###autoload
(defun turn-on-tmux-buffer ()
  (interactive)
  (setq interprogram-cut-function 'tmux-copy)
  (setq interprogram-paste-function 'tmux-paste))

;;;###autoload
(defun turn-off-tmux-buffer ()
  (interactive)
  (setq interprogram-cut-function nil)
  (setq interprogram-paste-function nil))

(provide 'tmuxbuf)
;;; tmuxbuf.el ends here
