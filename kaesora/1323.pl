sub EVENT_SPAWN {
    # Set a tighter proximity range (1 unit around the bones)
    quest::set_proximity($x - 1, $x + 1, $y - 1, $y + 1, $z - 1, $z + 1);
}

sub EVENT_ENTER {
    # When a player enters the proximity, show the emote.
    quest::emote("You sense these bones should not be disturbed.");
}

sub EVENT_ITEM {
    my $char_id = $client->CharacterID();  # Get the character's unique ID
    my $flag = "$char_id-bones_31710_flag";  # Unique flag for this NPC and item
    my $cooldown_key = "$char_id-bones_31710_hail_cd";  # A unique cooldown key
    my $trigger_item = 31710;
    my $cooldown_time = 300;  # 5-minute cooldown in seconds
    my $current_time = time();  # Current time in seconds

    # Check if the player handed in the correct item (31710)
    if (plugin::check_handin(\%itemcount, $trigger_item => 1)) {
        # Check if the player has already handed in the item
        if (quest::get_data($flag)) {
            plugin::Whisper("You have already disturbed these bones and cannot do so again just yet.");
        } else {
            # Set the flag indicating the player has completed the hand-in
            quest::set_data($flag, 1);
            quest::set_data($cooldown_key, $current_time);  # Start cooldown

            # The bones glow and shake violently.
            quest::say("The bones begin to glow brighter and shake violently.");

            # Spawn Atrebe Sathir (NPCID 1324) at the current location of the bones (NPCID 1323)
            quest::spawn2(1324, 0, 0, $x, $y, $z, $h);

            # Depop the bones after Atrebe Sathir has spawned
            quest::depop();
        }
    }
    else {
        # Return items if not the correct one
        plugin::return_items(\%itemcount);
    }
}

sub EVENT_SAY {
    my $char_id = $client->CharacterID();  # Get the character's unique ID
    my $flag = "$char_id-bones_31710_flag";  # The flag for the item hand-in
    my $cooldown_key = "$char_id-bones_31710_hail_cd";  # A unique cooldown key
    my $cooldown_time = 600;  # 10-minute cooldown in seconds
    my $current_time = time();  # Current time in seconds

    if ($text =~ /hail/i) {
        # Check if the player has completed the initial hand-in
        if (quest::get_data($flag)) {
            # Get the last hail time
            my $last_hail_time = quest::get_data($cooldown_key);

            if (!$last_hail_time || ($current_time - $last_hail_time) > $cooldown_time) {
                # Update the hail time to the current time
                quest::set_data($cooldown_key, $current_time);

                # Spawn Atrebe Sathir (NPCID 1324) at the current location
                quest::spawn2(1324, 0, 0, $x, $y, $z, $h);

                plugin::Whisper("The bones shudder violently, and a dark presence emerges...");
            } else {
                # Cooldown is still active, notify the player
                my $remaining_time = $cooldown_time - ($current_time - $last_hail_time);
                my $minutes = int($remaining_time / 60);
                my $seconds = $remaining_time % 60;
                plugin::Whisper("You must wait $minutes minutes and $seconds seconds before you can disturb these bones again.");
            }
        } else {
            plugin::Whisper("You must first disturb the bones by handing in the correct item before I can assist you.");
        }
    }
}
