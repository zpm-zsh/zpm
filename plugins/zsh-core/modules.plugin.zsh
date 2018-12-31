#!/usr/bin/env zsh

setopt braceccl
setopt interactive_comments
setopt nohup
setopt nobeep
setopt numericglobsort
setopt nocaseglob
setopt nocheckjobs
setopt multios              # Write to multiple descriptors.
setopt extendedglob        # Use extended globbing syntax.
unsetopt clobber            # Do not overwrite existing files with > and >>.
# Use >! and >>! to bypass.
