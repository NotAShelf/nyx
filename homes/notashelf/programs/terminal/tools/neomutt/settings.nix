{config}: {
  settings = {
    # if the given mail doesn't have an explicit charset, assume an old
    # and Windows-y compatible charset as fallback
    assumed_charset = "iso-8859-1";

    # use gpgme for cryptography
    crypt_use_gpgme = "yes";

    # use PKA to find keys via DNS records and possibly check whether an email
    # address is controlled by who it says it is
    crypt_use_pka = "yes";

    # always try to verify signatures
    crypt_verify_sig = "yes";

    # ask to purge messages marked for delete when closing/syncing a box, with
    # the default to do so
    delete = "ask-yes";

    # when editing outgoing mail, allow editing the headers too
    edit_headers = "yes";

    # the format to use for subjects when forwarding messages
    forward_format = "\"Fwd: %s\"";

    # save 10_000 lines of string buffer history per category
    history = "10000";

    # save history to a file in neomutt's directory
    history_file = "${config.xdg.configHome}/neomutt/history";

    # when connecting via IMAP, add all subscribed folders from the server
    imap_check_subscribed = "yes";

    # keep IMAP connections alive with a keepalive every 5 minutes
    imap_keepalive = "300";

    # use a smaller IMAP pipeline to play nice with servers like GMail
    imap_pipeline_depth = "5";

    # check for new mail every minute
    mail_check = "60";

    # the path to the mailcap file
    mailcap_path = "${config.home.homeDirectory}/.mailcap";

    # use Maildir-style mailboxes
    mbox_type = "Maildir";

    # scroll menus and such by a single line, rather than a whole page
    menu_scroll = "yes";

    # show five lines of context when moving between pages in the pager
    pager_context = "5";

    # the format for the pager status line.
    pager_format = "\" %C - %[%H:%M] %.20v, %s%* %?H? [%H] ?\"";

    # when in the mail pager, show 10 lines of the index above the current
    # message
    pager_index_lines = "10";

    # don't move to the next message when reaching the bottom of a message
    pager_stop = "yes";

    # reply to mail using the same address the original was sent to
    reverse_name = "yes";

    # send all mail as UTF-8
    send_charset = "utf-8";

    # sort the mailboxes in the sidebar by mailbox path
    sidebar_sort_method = "path";

    # sort by last message date if messages are in the same thread
    sort_aux = "last-date-received";

    # separate matching spam headers with this separator
    spam_separator = ", ";

    # only group messages as a thread by the In-Reply-To or References headers
    # rather than matching subject names
    strict_threads = "yes";

    # search messages against their decoded contents
    thorough_search = "yes";

    # pad blank lines at the bottom of the screen with tildes
    tilde = "yes";
  };
}
