;;; jira-post-file.el --- Attach files to Jira tickets with ease. -*- lexical-binding: t; -*-

;; Author: Nick Juszczak <njuszczak@gmail.com>
;; URL: https://github.com/juszczakn/jira-post-file
;; Version: 20150916
;; Package-Requires: ((Request.el "0.2.0") (emacs "24))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; For posting the current buffer to Jira. Requires a bit of setup, but it's
;; pretty straight forward.
;;
;; (require 'jira-post-file)
;; (setf jira-post-file:base-url "jira.mycompany.com")
;; (setf jira-post-file:username "myUsername")
;;
;; You can then call jira-post-file:current-buffer to post a file to a Jira ticket.

;;; Code:

(require 'request)

(defcustom jira-post-file:base-url nil
  "Jira base URL. Usually 'jira.<companyName>.com'"
  :group 'jira-post-file
  :type 'string)

(defcustom jira-post-file:username nil
  "Jira username."
  :group 'jira-post-file
  :type 'string)

(defconst jira-post-file:base-api-url "/rest/api/2/")

;;;###autoload
(defun jira-post-file:current-buffer (ticket)
  "Post the current buffer as a file to the given Jira ticket."
  (interactive "sEnter ticket name to post buffer to (defaults to buffer name): ")
  (let* ((cur-buf (current-buffer))
         (password (read-passwd "Jira password: "))
         (ticket-name (car (split-string (buffer-name cur-buf) "\\.")))
         (ticket-name (if (= 0 (length ticket)) ticket-name ticket))
         (jira-url (concat "https://" jira-post-file:username ":" password
                           "@" jira-post-file:base-url jira-post-file:base-api-url
                           "issue/" ticket-name "/attachments")))
    (request
     jira-url
     :type "POST"
     :headers '(("X-Atlassian-Token" . "nocheck"))
     :files `(("file" . ,cur-buf)))
    (message (concat "Successfully posted " (buffer-name cur-buf) " to " ticket-name "."))))

(provide 'jira-post-file)
