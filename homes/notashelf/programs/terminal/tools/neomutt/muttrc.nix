{
  config = ''
    # vim: filetype=muttrc
    # -- general -----------------------------------------------------------
    # from <https://gideonwolfe.com/posts/workflow/neomutt/intro>


    # set editor to neovim
    set editor = "nvim"

    set my_name = "NotAShelf"
    set imap_check_subscribed

    # set preffered view modes
    auto_view text/html text/calendar application/ics # view html automatically
    alternative_order text/html text/plain text/enriched text/*

    # main options
    set envelope_from
    set edit_headers                     # show headers when composing
    set fast_reply                       # skip to compose when replying
    set askcc                            # ask for CC:
    set fcc_attach                       # save attachments with the body
    set forward_format = "Fwd: %s"       # format of subject when forwarding
    set forward_decode                   # decode when forwarding
    set attribution = "On %d, %n wrote:" # format of quoting header
    set reply_to                         # reply to Reply to: field
    set reverse_name                     # reply as whomever it was to
    set include                          # include message in replies
    set forward_quote                    # include message in forwards
    set text_flowed
    unset sig_dashes                     # no dashes before sig
    unset mime_forward                   # forward attachments as part of body
    unset help                           # No help bar at the top of index

    # set status_on_top                    # Status bar on top of index
    set tmpdir = ~/Programs/neomutt/temp # where to keep temp files

    unset confirmappend      # don't ask, just do!
    set quit                 # don't ask, just do!!
    unset mark_old           # read/new is good enough for me
    set beep_new             # bell on new mails
    set pipe_decode          # strip headers and eval mimes when piping
    set thorough_search      # strip headers and eval mimes before searching
    set timeout = 0

    # status bar, date format, finding stuff etc.
    set status_chars = " *%A"
    set status_format = "[ Folder: %f ] [%r%m messages%?n? (%n new)?%?d? (%d to delete)?%?t? (%t tagged)? ]%>─%?p?( %p postponed )?"
    set date_format = "%d.%m.%Y %H:%M"
    set sort = threads
    set sort_aux = reverse-last-date-received
    set uncollapse_jump
    set sort_re
    set reply_regexp = "^(([Rr][Ee]?(\[[0-9]+\])?: *)?(\[[^]]+\] *)?)*"
    set quote_regexp = "^( {0,4}[>|:#%]| {0,4}[a-z0-9]+[>|]+)+"
    set send_charset = "utf-8:iso-8859-1:us-ascii"
    set charset = "utf-8"
    set arrow_cursor = "no" # Change `color indicator` depending

    # Pager View Options
    set pager_index_lines = 10  # Shows 10 lines of index when pager is active
    set pager_context = 3
    set pager_stop
    set menu_scroll
    set tilde
    unset markers

    set mailcap_path = ~/.config/neomutt/mailcap
    set header_cache = "~/.cache/mutt"
    set message_cachedir = "~/.cache/mutt"

    set query_command = "khard email --parsable --search-in-source-files '%s'"
  '';
}
