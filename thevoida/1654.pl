sub EVENT_SAY {
    if ($text=~/hail/i) {
        #$client->Message(15, "Hunt Master says, 'Greetings, hunter! I am the Hunt Master. If you bring me hunting trophies, like rare beast remains, I will reward you with Hunter Credits. These credits can be used to purchase powerful items that I carry. Keep your eyes open—new trophies and rewards arrive often!'");
        quest::popup("Hunt Master", "Greetings, hunter!<br><br>I am the <b>Hunt Master</b>. Bring me rare hunting trophies and I will reward you with <b>Hunter Credits</b>.<br><br>You can spend these credits on powerful items I carry. Be sure to check in often—new items and trade-ins are added regularly!");
    }
}

sub EVENT_ITEM {
    if (plugin::check_handin(\%itemcount, 33209 => 1)) {
        my $credits = quest::ChooseRandom(5..10);
        $client->Message(15, "You receive $credits Hunter Credits.");
        quest::summonitem(33208, $credits);
        quest::removeitem(33209, 1);
    }
    elsif (plugin::check_handin(\%itemcount, 39594 => 1)) {
        my $credits = quest::ChooseRandom(11..25);
        $client->Message(15, "You receive $credits Hunter Credits.");
        quest::summonitem(33208, $credits);
        quest::removeitem(39594, 1);
    }
    elsif (plugin::check_handin(\%itemcount, 39596 => 1)) {
        my $credits = quest::ChooseRandom(26..35);
        $client->Message(15, "You receive $credits Hunter Credits.");
        quest::summonitem(33208, $credits);
        quest::removeitem(39596, 1);
    }
    elsif (plugin::check_handin(\%itemcount, 39623 => 1)) {
        my $credits = quest::ChooseRandom(36..45);
        $client->Message(15, "You receive $credits Hunter Credits.");
        quest::summonitem(33208, $credits);
        quest::removeitem(39623, 1);
    }
    else {
        plugin::return_items(\%itemcount);
    }
}