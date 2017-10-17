#!/usr/bin/env perl

sub has_mosh_ancestor {
    chomp(my @pidlist=@_);
    foreach (@pidlist) {
        next unless /^[0-9]+$/;
        $_ = `pstree -ps $_`;
        return 1 if /mosh-server/
    }
    0
}

if (!$ENV{TMUX}) { exit ! has_mosh_ancestor($$) }

chomp(my $session = `tmux display -pF "#S"`);
chomp(my @clients = `tmux list-clients -t "$session" -F "#{client_pid}"`);

exit !has_mosh_ancestor(@clients);
