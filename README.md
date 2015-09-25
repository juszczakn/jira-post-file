# jira-post-file
Attach files to Jira tickets with ease.

## Install
After cloning the project to, ie `~/.emacs.d/manual-packages`, put the following in
your .emacs or init.el

    (add-to-list 'load-path "~/.emacs.d/manual-packages/jira-post-file")
    (require 'jira-post-file)

## Use
The only public function exposed is `jira-post-file:current-buffer`. The function
prompts you for required input (Jira ticket number and password).
