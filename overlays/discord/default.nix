{
let
    discordOverlay = self: super: {
        discord = super.discord.override { withOpenASAR = true; };
    };
    in
    [ discordOverlay ];
}