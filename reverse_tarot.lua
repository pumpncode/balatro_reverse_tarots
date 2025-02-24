SMODS.Atlas{
    key = 'Reverse_Jokers',
    path = 'Reverse_Jokers.png',
    px = 71,
    py = 95
}

SMODS.Atlas{
    key = "Reverse_Tarots",
    path = "Reverse_Tarots.png",
    px = 71,
    py = 95
}

SMODS.Atlas{
    key = "New_Enhance",
    path = "Enhancers.png",
    px = 71,
    py = 95
}

SMODS.Atlas{
    key = "New_Sticker",
    path = "stickers.png",
    px = 71,
    py = 95
}

SMODS.Atlas{
    key = "Reverse_Bosses",
    path = "reverse_bosses.png",
    atlas_table = 'ANIMATION_ATLAS',
    frames = 21,
    px = 34,
    py = 34
}

SMODS.Sticker{
    key = "ephemeral",
    atlas = "New_Sticker",
    pos = {x = 4, y = 2},
    badge_colour = HEX "1ad141",
    loc_txt = {
        label = "Ephemeral",
        name = "Ephemeral",
        text = {
            "Debuffed after",
            "{C:attention}#1#{} rounds",
            "Has no sell value",
            "{C:inactive}({}{C:attention}#2#{}{C:inactive} remaining)"
        }
    },
    default_compat = true,
    sets = {
        Joker = true
    },
    config = {
        extra = {
            total_turns = 3,
            turns_remaining = 3
        }
    },
    rate = 0,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability[self.key].extra.total_turns, center.ability[self.key].extra.turns_remaining}}
    end,
    apply = function(self, card, val)
        card.ability[self.key] = val and copy_table(self.config)
        card.base_cost = 0
        return
    end,
    calculate = function(self, card, context)
        card.extra_value = 0
        card.sell_cost = 0
        card.base_cost = 0
        card:set_cost()
        if card.ability[self.key].extra.turns_remaining > 0 and context.end_of_round and context.main_eval then
            card.ability[self.key].extra.turns_remaining = card.ability[self.key].extra.turns_remaining - 1
            --print(card.ability[self.key].extra.turns_remaining)
        end
        if card.ability[self.key].extra.turns_remaining <= 0 then
            SMODS.debuff_card(card, true, self)
        end
    end
}

SMODS.Enhancement{
    key = "held_bonus",
    atlas = "New_Enhance",
    pos = {x = 2, y = 5},
    loc_txt={
        name="Held Bonus Card",
        text = {
            "{C:chips}+#1#{} Chips",
                "while this card",
                "stays in hand",
        }
    },
    config = {
        extra = {
            chips = 40
        }
    },
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.chips}}
    end,
    calculate = function(self,card,context)
        if context.main_scoring and context.cardarea == G.hand then
            return { chips = card.ability.extra.chips}
        end
    end
}

SMODS.Enhancement{
    key = "held_mult",
    atlas = "New_Enhance",
    pos = {x = 1, y = 5},
    loc_txt={
        name="Held Mult Card",
        text = {
            "{C:mult}+#1#{} Mult",
                "while this card",
                "stays in hand",
        }
    },
    config = {
        extra = {
            mult = 6
        }
    },
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.mult}}
    end,
    calculate = function(self,card,context)
        if context.main_scoring and context.cardarea == G.hand then
            return { mult = card.ability.extra.mult}
        end
    end
}

SMODS.Enhancement{
    key = "omnirank",
    atlas = "New_Enhance",
    pos = {x = 3, y = 5},
    loc_txt={
        name="Omnirank Card",
        text = {
            "Can be used",
            "as any rank",
            "for its suit"
        }
    },
    config = {
        extra = {suit = "(suit)"}
    },
    replace_base_card = true,
    set_sprites = function(self, card, front)
        if card.base then
            card.children.center.atlas = G.ASSET_ATLAS['reverse_New_Enhance']
            if card.base.suit == "Hearts" then
                card.children.center:set_sprite_pos({x = 3, y = 5})
            elseif card.base.suit == "Clubs" then
                card.children.center:set_sprite_pos({x = 4, y = 5})
            elseif card.base.suit == "Diamonds" then
                card.children.center:set_sprite_pos({x = 5, y = 5})
            elseif card.base.suit == "Spades" then
                card.children.center:set_sprite_pos({x = 6, y = 5})
            end
        end
    end,
    update = function(self, card, dt)
        if card.base then
            card.children.center.atlas = G.ASSET_ATLAS['reverse_New_Enhance']
            if card.base.suit == "Hearts" then
                card.children.center:set_sprite_pos({x = 3, y = 5})
            elseif card.base.suit == "Clubs" then
                card.children.center:set_sprite_pos({x = 4, y = 5})
            elseif card.base.suit == "Diamonds" then
                card.children.center:set_sprite_pos({x = 5, y = 5})
            elseif card.base.suit == "Spades" then
                card.children.center:set_sprite_pos({x = 6, y = 5})
            end
        end
    end
}

SMODS.Enhancement{
    key = "crystal",
    atlas = "New_Enhance",
    pos = {x = 1, y = 6},
    loc_txt={
        name="Crystal Card",
        text = {
            "{X:chips,C:white} X#1# {} Chips",
            "{C:green}#2# in #3#{} chance to",
            "destroy card",
        }
    },
    shatters = true,
    config = {
        extra = {
            x_chips = 2,
            shatter_prob = 4
        }
    },
    loc_vars = function(self, info_queue, center)
        return {
            vars = {
                center.ability.extra.x_chips,
                G.GAME.probabilities.normal,
                center.ability.extra.shatter_prob
            }
        }
    end,
    calculate = function(self,card,context)
        if context.main_scoring and context.cardarea == G.play then
            return { x_chips = card.ability.extra.x_chips}
        end
        if context.destroy_card and context.cardarea == G.play and pseudorandom('crystal') < G.GAME.probabilities.normal/4 then
            return {remove = true}
        end
    end
}

SMODS.Enhancement{
    key = "copper",
    atlas = "New_Enhance",
    pos = {x = 0, y = 6},
    loc_txt={
        name="Copper Card",
        text = {
            "{X:chips,C:white}X#1#{} Chips",
                "while this card",
                "stays in hand",
        }
    },
    config = {
        extra = {
            x_chips = 1.5
        }
    },
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.x_chips}}
    end,
    calculate = function(self,card,context)
        if context.main_scoring and context.cardarea == G.hand then
            return {x_chips = card.ability.extra.x_chips}
        end
    end
}

SMODS.Enhancement{
    key = "marble",
    atlas = "New_Enhance",
    pos = {x = 0, y = 7},
    loc_txt={
        name="Marble Card",
        text = {
            "{C:mult}+#1#{} Mult",
            "no rank or suit",
        }
    },
    config = {
        extra = {
            mult = 10
        }
    },
    replace_base_card = true,
    no_rank = true,
    no_suit = true,
    always_scores = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.mult}}
    end,
    calculate = function(self,card,context)
        if context.main_scoring and context.cardarea == G.play then
            return { mult = card.ability.extra.mult}
        end
    end
}

SMODS.Enhancement{
    key = "pyrite",
    atlas = "New_Enhance",
    pos = {x = 2, y = 6},
    loc_txt={
        name="Pyrite Card",
        text = {
            "{C:mult}+#1#{} Mult",
            "when {C:attention}played",
            "{C:money}-$#2#{} if this",
            "card is held in hand",
            "at end of round",
        }
    },
    config = {
        extra = {
            mult = 6,
            p_dollars = 2
        }
    },
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.mult, center.ability.extra.p_dollars}}
    end,
    calculate = function(self,card,context)
        if context.main_scoring and context.cardarea == G.play then
            return { mult = card.ability.extra.mult}
        elseif context.playing_card_end_of_round and context.cardarea == G.hand then
            return { dollars = -card.ability.extra.p_dollars}
        end
    end
}

SMODS.Enhancement{
    key = "counterfeit",
    atlas = "New_Enhance",
    pos = {x = 0, y = 5},
    loc_txt={
        name="Counterfeit Card",
        text = {
            "{C:green}#1# in #3#{} chance",
            "to win {C:money}$#2#{}",
            "{C:green}#1# in #5#{} chance",
            "for {C:mult}+#4#{} Mult"
        }
    },
    config = {
        extra = {
            p_dollars = "6",
            money_prob = "5",
            mult = "60",
            mult_prob = "15"
        }
    },
    loc_vars = function(self, info_queue, center)
        return {vars = {
                G.GAME.probabilities.normal,
                center.ability.extra.p_dollars,
                center.ability.extra.money_prob,
                center.ability.extra.mult,
                center.ability.extra.mult_prob
            }
        }
    end,
    calculate = function(self,card,context)
        if context.main_scoring and context.cardarea == G.play then
            card.counterfeit_trigger = false
            counterfeit_val = pseudorandom('counterfeit_both')
            if counterfeit_val < G.GAME.probabilities.normal * G.GAME.probabilities.normal/75 then
                card.counterfeit_trigger = true
                return{
                    mult = 60,
                    dollars = 6
                }
            elseif counterfeit_val < G.GAME.probabilities.normal/15 then
                card.counterfeit_trigger = true
                return{
                    mult = 60
                }
            elseif counterfeit_val < (G.GAME.probabilities.normal/5 + G.GAME.probabilities.normal/15 - G.GAME.probabilities.normal * G.GAME.probabilities.normal/75) then
                card.counterfeit_trigger = true
                return{
                    dollars = 6
                }
            end
        end
    end
}

SMODS.Enhancement{
    key = "secondary_heart",
    atlas = "New_Enhance",
    pos = {x = 3, y = 6},
    loc_txt={
        name="Secondary Heart",
        text = {
            "This card also counts",
            "as a {C:hearts}Heart"
        }
    }
}

SMODS.Enhancement{
    key = "secondary_club",
    atlas = "New_Enhance",
    pos = {x = 4, y = 6},
    loc_txt={
        name="Secondary Club",
        text = {
            "This card also counts",
            "as a {C:clubs}Club"
        }
    }
}

SMODS.Enhancement{
    key = "secondary_diamond",
    atlas = "New_Enhance",
    pos = {x = 5, y = 6},
    loc_txt={
        name="Secondary Diamond",
        text = {
            "This card also counts",
            "as a {C:diamonds}Diamond"
        }
    }
}

SMODS.Enhancement{
    key = "secondary_spade",
    atlas = "New_Enhance",
    pos = {x = 6, y = 6},
    loc_txt={
        name="Secondary Spade",
        text = {
            "This card also counts",
            "as a {C:spades}Spade"
        }
    }
}

SMODS.Consumable{
    key = "c_reverse_fool",
    set = "Tarot",
    atlas = "Reverse_Tarots",
    pos = {x = 9, y = 2},
    loc_txt = {
        name = 'The Fool?',
        text = {
            "Creates {C:attention}inverted{} version of last",
            "{C:tarot}Tarot{}, or regular {C:planet}Planet{} card",
            "used during this run",
            "{s:0.8,C:tarot}The Fool(?){s:0.8} excluded",
            "{C:attention}Created card: #1#{}"
        }
    },
    loc_vars = function(self, info_queue, center)
        local fool_c = G.GAME.last_tarot_planet and G.P_CENTERS[G.GAME.last_tarot_planet] or nil
        local last_tarot_planet = fool_c and localize{type = 'name_text', key = fool_c.key, set = fool_c.set} or localize('k_none')
        local colour = (not fool_c or fool_c.name == 'The Fool') and G.C.RED or G.C.GREEN
        local new_card = nil
        main_end = {
            {n=G.UIT.C, config={align = "bm", padding = 0.02}, nodes={
                {n=G.UIT.C, config={align = "m", colour = colour, r = 0.05, padding = 0.05}, nodes={
                    {n=G.UIT.T, config={text = ' '..last_tarot_planet..' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.3, shadow = true}},
                }}
            }}
        }
        if not (not fool_c or fool_c.name == 'The Fool' or fool_c.name == 'c_reverse_c_reverse_fool') then
            local words = {}
            for w in fool_c.key:gmatch("([^_]+)") do
                table.insert(words, w) 
            end
            local final_word = words[#words]
            if final_word == "priestess" then
                final_word = "high_priestess"
            elseif final_word == "fortune" then
                final_word = "wheel_of_fortune"
            elseif final_word == "man" then
                final_word = "hanged_man"
            end
            if fool_c.loc_txt then --if the current card is a reverse tarot
                new_card = G.P_CENTERS["c_" .. final_word]
            elseif fool_c.set ~= "Planet" then
                new_card = G.P_CENTERS["c_reverse_c_reverse_" .. final_word]
            end
            info_queue[#info_queue+1] = new_card
        end
        if new_card then
            if new_card.loc_txt then
                return {vars = {new_card.loc_txt.name}}
            else
                return {vars = {new_card.name}}
            end
        end
    end,
    can_use = function(self, card)
        local fool_c = G.GAME.last_tarot_planet and G.P_CENTERS[G.GAME.last_tarot_planet] or nil
        local last_tarot_planet = fool_c and localize{type = 'name_text', key = fool_c.key, set = fool_c.set} or localize('k_none')
        local colour = (not fool_c or fool_c.name == 'The Fool') and G.C.RED or G.C.GREEN
        main_end = {
            {n=G.UIT.C, config={align = "bm", padding = 0.02}, nodes={
                {n=G.UIT.C, config={align = "m", colour = colour, r = 0.05, padding = 0.05}, nodes={
                    {n=G.UIT.T, config={text = ' '..last_tarot_planet..' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.3, shadow = true}},
                }}
            }}
        }
        if not (not fool_c or fool_c.name == 'The Fool') then
            return true
        end
    end,
    in_pool = function(self, args)
        return G.GAME.dollars < 20
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            if G.consumeables.config.card_limit > #G.consumeables.cards then
                play_sound('timpani')
                local fool_c = G.GAME.last_tarot_planet and G.P_CENTERS[G.GAME.last_tarot_planet] or nil
                local words = {}
                for w in fool_c.key:gmatch("([^_]+)") do
                    table.insert(words, w) 
                end
                local final_word = words[#words]
                if final_word == "priestess" then
                    final_word = "high_priestess"
                elseif final_word == "fortune" then
                    final_word = "wheel_of_fortune"
                elseif final_word == "man" then
                    final_word = "hanged_man"
                end
                if fool_c.loc_txt then -- if the most recently used card was a Reverse Tarot
                    local card = create_card('Tarot_Planet', G.consumeables, nil, nil, nil, nil, "c_" .. final_word, 'fool')
                    card:add_to_deck()
                    G.consumeables:emplace(card)
                elseif fool_c.set ~= "Planet" then
                    local card = create_card('Tarot_Planet', G.consumeables, nil, nil, nil, nil, "c_reverse_c_reverse_" .. final_word, 'fool')
                    card:add_to_deck()
                    G.consumeables:emplace(card)    
                else
                    local card = create_card('Tarot_Planet', G.consumeables, nil, nil, nil, nil, G.GAME.last_tarot_planet, 'fool')
                    card:add_to_deck()
                    G.consumeables:emplace(card)
                end
            end
            return true end }))
        delay(0.6)
    end
}

SMODS.Consumable{
    key = "c_reverse_magician",
    set = "Tarot",
    atlas = "Reverse_Tarots",
    pos = {x = 8, y = 2},
    loc_txt = {
        name = "The Magician?",
        text = {
            "Enhances {C:attention}#1#{}",
                    "selected cards to",
                    "{C:attention}#2#s"
        }
    },
    config = { context =
        {
            mod_conv = 'Counterfeit Card',
            max_highlighted = 2
        }
    },
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.m_reverse_counterfeit
        return {vars = {center.ability.context.max_highlighted, center.ability.context.mod_conv}}
    end,
    can_use = function(self, card)
        if G and G.hand then
            if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= 2 then
                return true
            end
        end
    end,
    use = function(self, card, area, copier)
        play_sound('tarot1')
        for i = 1, #G.hand.highlighted do --flips cards
            local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip();
                    play_sound('card1', percent);
                    G.hand.highlighted[i]:juice_up(0.3, 0.3);
                    return true
                end
            }))
        end
        delay(0.5)
        for i = 1, #G.hand.highlighted do --enhances cards
            local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                     G.hand.highlighted[i]:set_ability("m_reverse_counterfeit");
                     G.hand.highlighted[i]:juice_up(0.3, 0.3);
                     return true
                end
            }))
        end
        for i = 1, #G.hand.highlighted do --unflips cards
            local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                     G.hand.highlighted[i]:flip();
                     play_sound('tarot2', percent, 0.6);
                     G.hand.highlighted[i]:juice_up(0.3, 0.3);
                     return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all();
            return true
        end })) --unselects cards
        delay(0.5)
    end
}

SMODS.Consumable{
    key = "c_reverse_high_priestess",
    set = "Tarot",
    atlas = "Reverse_Tarots",
    pos = {x = 7, y = 2},
    loc_txt = {
        name = "The High Priestess?",
        text = {
            "Creates #1# {C:planet}Planet{}",
                    "card for your",
                    "{:attention}highest levelled hand{}:",
                    "{C:planet}#2#{}"
        }
    },
    config = { context =
        {
            number_planets = 1
        }
    },
    loc_vars = function(self, info_queue, center)
        local highest_level = 0
        local highest_hand = 'High Card'
        for k, v in pairs(G.GAME.hands) do
            if G.GAME.hands[k].level >= highest_level then
                highest_hand = k
                highest_level = G.GAME.hands[k].level
            end
        end
        local planet_name = nil
        for k, v in pairs(G.P_CENTERS) do
            if G.P_CENTERS[k].config then
                if G.P_CENTERS[k].config.hand_type then
                    if G.P_CENTERS[k].config.hand_type == highest_hand then
                        planet_name = k
                    end
                end
            end
        end
        info_queue[#info_queue+1] = G.P_CENTERS[planet_name]
        return {vars = {center.ability.context.number_planets, highest_hand}}
    end,
    can_use = function(self, card) --Fix this condition???
        if #G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables then
            return true
        end
    end,
    use = function(self, card, area, copier)
        local highest_level = 0
        local highest_hand = 'High Card'
        for k, v in pairs(G.GAME.hands) do
            if G.GAME.hands[k].level >= highest_level then
                highest_hand = k
                highest_level = G.GAME.hands[k].level
            end
        end
        local planet_name = nil
        for k, v in pairs(G.P_CENTERS) do
            if G.P_CENTERS[k].config then
                if G.P_CENTERS[k].config.hand_type then
                    if G.P_CENTERS[k].config.hand_type == highest_hand then
                        planet_name = k
                    end
                end
            end
        end
        local card = create_card('Tarot_Planet', G.consumeables, nil, nil, nil, nil, planet_name, 'pri')
        card:add_to_deck()
        G.consumeables:emplace(card)
    end
}

SMODS.Consumable{
    key = "c_reverse_empress",
    set = "Tarot",
    atlas = "Reverse_Tarots",
    pos = {x = 6, y = 2},
    loc_txt = {
        name = "The Empress?",
        text = {
            "Enhances {C:attention}#1#{}",
                "selected cards to",
                "{C:attention}#2#s"
        }
    },
    config = { context =
        {
            mod_conv = 'Held Mult Card',
            max_highlighted = 2
        }
    },
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.m_reverse_held_mult
        return {vars = {center.ability.context.max_highlighted, center.ability.context.mod_conv}}
    end,
    can_use = function(self, card)
        if G and G.hand then
            if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= 2 then
                return true
            end
        end
    end,
    use = function(self, card, area, copier)
        play_sound('tarot1')
        for i = 1, #G.hand.highlighted do --flips cards
            local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip();
                    play_sound('card1', percent);
                    G.hand.highlighted[i]:juice_up(0.3, 0.3);
                    return true
                end
            }))
        end
        delay(0.5)
        for i = 1, #G.hand.highlighted do --enhances cards
            local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                     G.hand.highlighted[i]:set_ability("m_reverse_held_mult");
                     G.hand.highlighted[i]:juice_up(0.3, 0.3);
                     return true
                end
            }))
        end
        for i = 1, #G.hand.highlighted do --unflips cards
            local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                     G.hand.highlighted[i]:flip();
                     play_sound('tarot2', percent, 0.6);
                     G.hand.highlighted[i]:juice_up(0.3, 0.3);
                     return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all();
            return true
        end })) --unselects cards
        delay(0.5)
    end
}

SMODS.Consumable{
    key = "c_reverse_emperor",
    set = "Tarot",
    atlas = "Reverse_Tarots",
    pos = {x = 5, y = 2},
    loc_txt = {
        name = "The Emperor?",
        text = {
            "Creates up to {C:attention}#1#",
            "random {C:tarot}Reverse Tarot{} cards",
            "{C:inactive}(Must have room){}",
        }
    },
    config = { context =
        {
            number_cards = 2
        }
    },
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.context.number_cards}}
    end,
    can_use = function(self, card) --Fix this condition???
        if #G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables then
            return true
        end
    end,
    use = function(self, card, area, copier)
        --see .toml for injection
        for i = 1, math.min(card.ability.context.number_cards, G.consumeables.config.card_limit - #G.consumeables.cards) do
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                if G.consumeables.config.card_limit > #G.consumeables.cards then
                    play_sound('timpani')
                    local card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, nil, 'remp')
                    card:add_to_deck()
                    G.consumeables:emplace(card)
                end
                return true end }))
        end
        delay(0.6)
    end
}

SMODS.Consumable{
    key = "c_reverse_heirophant",
    set = "Tarot",
    atlas = "Reverse_Tarots",
    pos = {x = 4, y = 2},
    loc_txt = {
        name = "The Heirophant?",
        text = {
            "Enhances {C:attention}#1#{}",
                "selected cards to",
                "{C:attention}#2#s"
        }
    },
    config = { context =
        {
            mod_conv = 'Held Bonus Card',
            max_highlighted = 2
        }
    },
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.m_reverse_held_bonus
        return {vars = {center.ability.context.max_highlighted, center.ability.context.mod_conv}}
    end,
    can_use = function(self, card)
        if G and G.hand then
            if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= 2 then
                return true
            end
        end
    end,
    use = function(self, card, area, copier)
        play_sound('tarot1')
        for i = 1, #G.hand.highlighted do --flips cards
            local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip();
                    play_sound('card1', percent);
                    G.hand.highlighted[i]:juice_up(0.3, 0.3);
                    return true
                end
            }))
        end
        delay(0.5)
        for i = 1, #G.hand.highlighted do --enhances cards
            local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                     G.hand.highlighted[i]:set_ability("m_reverse_held_bonus");
                     G.hand.highlighted[i]:juice_up(0.3, 0.3);
                     return true
                end
            }))
        end
        for i = 1, #G.hand.highlighted do --unflips cards
            local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                     G.hand.highlighted[i]:flip();
                     play_sound('tarot2', percent, 0.6);
                     G.hand.highlighted[i]:juice_up(0.3, 0.3);
                     return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all();
            return true
        end })) --unselects cards
        delay(0.5)
    end
}

SMODS.Consumable{
    key = "c_reverse_lovers",
    set = "Tarot",
    atlas = "Reverse_Tarots",
    pos = {x = 3, y = 2},
    loc_txt = {
        name = "The Lovers?",
        text = {
            "Enhances {C:attention}#1#{}",
                "selected card to a",
                "{C:attention}#2#{}"
        }
    },
    config = { context =
        {
            mod_conv = 'Omnirank Card',
            max_highlighted = 1
        }
    },
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.m_reverse_omnirank
        return {vars = {center.ability.context.max_highlighted, center.ability.context.mod_conv}}
    end,
    can_use = function(self, card)
        if G and G.hand then
            if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= 1 then
                return true
            end
        end
    end,
    use = function(self, card, area, copier)
        play_sound('tarot1')
        for i = 1, #G.hand.highlighted do --flips cards
            local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip();
                    play_sound('card1', percent);
                    G.hand.highlighted[i]:juice_up(0.3, 0.3);
                    return true
                end
            }))
        end
        delay(0.5)
        for i = 1, #G.hand.highlighted do --enhances cards
            local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:set_ability("m_reverse_omnirank")
                    G.hand.highlighted[i]:juice_up(0.3, 0.3);
                    return true
                end
            }))
        end
        for i = 1, #G.hand.highlighted do --unflips cards
            local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                     G.hand.highlighted[i]:flip();
                     play_sound('tarot2', percent, 0.6);
                     G.hand.highlighted[i]:juice_up(0.3, 0.3);
                     return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all();
            return true
        end })) --unselects cards
        delay(0.5)
    end
}

SMODS.Consumable{
    key = "c_reverse_chariot",
    set = "Tarot",
    atlas = "Reverse_Tarots",
    pos = {x = 2, y = 2},
    loc_txt = {
        name = "The Chariot?",
        text = {
            "Enhances {C:attention}#1#{}",
                "selected card to a",
                "{C:attention}#2#{}"
        }
    },
    config = { context =
        {
            mod_conv = 'Copper Card',
            max_highlighted = 1
        }
    },
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.m_reverse_copper
        return {vars = {center.ability.context.max_highlighted, center.ability.context.mod_conv}}
    end,
    can_use = function(self, card)
        if G and G.hand then
            if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= 1 then
                return true
            end
        end
    end,
    use = function(self, card, area, copier)
        play_sound('tarot1')
        for i = 1, #G.hand.highlighted do --flips cards
            local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip();
                    play_sound('card1', percent);
                    G.hand.highlighted[i]:juice_up(0.3, 0.3);
                    return true
                end
            }))
        end
        delay(0.5)
        for i = 1, #G.hand.highlighted do --enhances cards
            local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                     G.hand.highlighted[i]:set_ability("m_reverse_copper");
                     G.hand.highlighted[i]:juice_up(0.3, 0.3);
                     return true
                end
            }))
        end
        for i = 1, #G.hand.highlighted do --unflips cards
            local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                     G.hand.highlighted[i]:flip();
                     play_sound('tarot2', percent, 0.6);
                     G.hand.highlighted[i]:juice_up(0.3, 0.3);
                     return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all();
            return true
        end })) --unselects cards
        delay(0.5)
    end
}

SMODS.Consumable{
    key = "c_reverse_justice",
    set = "Tarot",
    atlas = "Reverse_Tarots",
    pos = {x = 1, y = 2},
    loc_txt = {
        name = "Justice?",
        text = {
            "Enhances {C:attention}#1#{}",
                "selected card to a",
                "{C:attention}#2#{}"
        }
    },
    config = { context =
        {
            mod_conv = 'Crystal Card',
            max_highlighted = 1
        }
    },
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.m_reverse_crystal
        return {vars = {center.ability.context.max_highlighted, center.ability.context.mod_conv}}
    end,
    can_use = function(self, card)
        if G and G.hand then
            if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= 1 then
                return true
            end
        end
    end,
    use = function(self, card, area, copier)
        play_sound('tarot1')
        for i = 1, #G.hand.highlighted do --flips cards
            local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip();
                    play_sound('card1', percent);
                    G.hand.highlighted[i]:juice_up(0.3, 0.3);
                    return true
                end
            }))
        end
        delay(0.5)
        for i = 1, #G.hand.highlighted do --enhances cards
            local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                     G.hand.highlighted[i]:set_ability("m_reverse_crystal");
                     G.hand.highlighted[i]:juice_up(0.3, 0.3);
                     return true
                end
            }))
        end
        for i = 1, #G.hand.highlighted do --unflips cards
            local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                     G.hand.highlighted[i]:flip();
                     play_sound('tarot2', percent, 0.6);
                     G.hand.highlighted[i]:juice_up(0.3, 0.3);
                     return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all();
            return true
        end })) --unselects cards
        delay(0.5)
    end
}

SMODS.Consumable{
    key = "c_reverse_hermit",
    set = "Tarot",
    atlas = "Reverse_Tarots",
    pos = {x = 0, y = 2},
    loc_txt = {
        name = "The Hermit?",
        text = {
            "Sets money equal",
            "to {C:money}$#1#{}"
        }
    },
    config = { context =
        {
            dollars = 20
        }
    },
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.context.dollars}}
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        ease_dollars(-G.GAME.dollars + 20, true)
    end
}

SMODS.Consumable{
    key = "c_reverse_wheel_of_fortune",
    set = "Tarot",
    atlas = "Reverse_Tarots",
    pos = {x = 9, y = 1},
    loc_txt = {
        name = "Wheel of Fortune?",
        text = {
            "{C:green}#1# in #2#{} chance to add",
            "Add {C:dark_edition}Foil{}, {C:dark_edition}Holographic{},",
                "or {C:dark_edition}Polychrome{} effect to",
                "{C:attention}1{} random card in hand",
        }
    },
    config = { context =
        {
            edition_odds = 4
        }
    },
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.e_foil
        info_queue[#info_queue+1] = G.P_CENTERS.e_holo
        info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome
        return {vars = { G.GAME.probabilities.normal, center.ability.context.edition_odds}}
    end,
    can_use = function(self, card)
        if G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.PLANET_PACK and #G.hand.cards > 1 then
            return true
        end
    end,
    use = function(self, card, area, copier)
        if pseudorandom('rwheel') < G.GAME.probabilities.normal/4 then
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                local temp_pool = {}
                for k, v in pairs(G.hand.cards) do
                    if (not v.edition) then
                        table.insert(temp_pool, v)
                    end
                end
                local eligible_card = pseudorandom_element(temp_pool, pseudoseed("Wheel of Fortune?"))
                local edition = poll_edition('wheel_of_fortune', nil, true, true)
                eligible_card:set_edition(edition, true)
                card:juice_up(0.3, 0.5)
            return true end }))
        else
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
                attention_text({
                    text = localize('k_nope_ex'),
                    scale = 1.3, 
                    hold = 1.4,
                    major = used_tarot,
                    backdrop_colour = G.C.SECONDARY_SET.Tarot,
                    align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and 'tm' or 'cm',
                    offset = {x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and -0.2 or 0},
                    silent = true
                    })
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
                        play_sound('tarot2', 0.76, 0.4);return true end}))
                    play_sound('tarot2', 1, 0.4)
            return true end }))
        end
    end
}

SMODS.Consumable{
    key = "c_reverse_strength",
    set = "Tarot",
    atlas = "Reverse_Tarots",
    pos = {x = 8, y = 1},
    loc_txt = {
        name = "Strength?",
        text = {
            "Decreases rank of",
            "up to {C:attention}#1#{} selected",
            "cards by {C:attention}1",
        }
    },
    config = { context =
        {
            max_highlighted = 2
        }
    },
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.context.max_highlighted}}
    end,
    can_use = function(self, card)
        if G and G.hand then
            if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= 2 then
                return true
            end
        end
    end,
    use = function(self, card, area, copier)
        play_sound('tarot1')
        for i = 1, #G.hand.highlighted do --flips cards
            local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip();
                    play_sound('card1', percent);
                    G.hand.highlighted[i]:juice_up(0.3, 0.3);
                    return true
                end
            }))
        end
        delay(0.5)
        for i = 1, #G.hand.highlighted do --enhances cards
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                local card = G.hand.highlighted[i]
                local suit_prefix = string.sub(card.base.suit, 1, 1)..'_'
                local rank_suffix = card.base.id == 2 and 14 or card.base.id - 1
                if rank_suffix < 10 then rank_suffix = tostring(rank_suffix)
                elseif rank_suffix == 10 then rank_suffix = 'T'
                elseif rank_suffix == 11 then rank_suffix = 'J'
                elseif rank_suffix == 12 then rank_suffix = 'Q'
                elseif rank_suffix == 13 then rank_suffix = 'K'
                elseif rank_suffix == 14 then rank_suffix = 'A'
                end
                card:set_base(G.P_CARDS[suit_prefix..rank_suffix])
            return true end }))
        end
        for i = 1, #G.hand.highlighted do --unflips cards
            local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                     G.hand.highlighted[i]:flip();
                     play_sound('tarot2', percent, 0.6);
                     G.hand.highlighted[i]:juice_up(0.3, 0.3);
                     return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all();
            return true
        end })) --unselects cards
        delay(0.5)
    end
}

SMODS.Consumable{
    key = "c_reverse_hanged_man",
    set = "Tarot",
    atlas = "Reverse_Tarots",
    pos = {x = 7, y = 1},
    loc_txt = {
        name = "The Hanged Man?",
        text = {
            "Create {C:attention}#1#{} random",
            "{C:attention}Enhanced card{}",
            "added to your hand",
        }
    },
    config = { context =
        {
            number_cards = 1
        }
    },
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.context.number_cards}}
    end,
    can_use = function(self, card)
        if G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.PLANET_PACK and #G.hand.cards > 1 then
            return true
        end
    end,
    use = function(self, card, area, copier)
        local _suit, _rank = nil, nil
        _rank = pseudorandom_element({'2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A'}, pseudoseed('reverse_hanged_man_create'))
        _suit = pseudorandom_element({'S','H','D','C'}, pseudoseed('reverse_hanged_man_create'))
        _suit = _suit or 'S'; _rank = _rank or 'A'
        local cen_pool = {}
        for k, v in pairs(G.P_CENTER_POOLS["Enhanced"]) do
            if v.key ~= 'm_stone' then 
                cen_pool[#cen_pool+1] = v
            end
        end
        create_playing_card({front = G.P_CARDS[_suit..'_'.._rank], center = pseudorandom_element(cen_pool, pseudoseed('spe_card'))}, G.hand, nil, i ~= 1, {G.C.SECONDARY_SET.Spectral})
        playing_card_joker_effects(new_cards)
    end
}

SMODS.Consumable{
    key = "c_reverse_death",
    set = "Tarot",
    atlas = "Reverse_Tarots",
    pos = {x = 6, y = 1},
    loc_txt = {
        name = "Death?",
        text = {
            "Select {C:attention}#1#{} cards,",
            "convert the {C:attention}right{} card",
            "into the {C:attention}left{} card",
            "{C:inactive}(Drag to rearrange)",
        }
    },
    config = { context =
        {
            max_highlighted = 2
        }
    },
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.context.max_highlighted}}
    end,
    can_use = function(self, card)
        if G and G.hand then
            if #G.hand.highlighted ~= 0 and #G.hand.highlighted == 2 then
                return true
            end
        end
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            play_sound('tarot1')
            return true end }))
        for i=1, #G.hand.highlighted do
            local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('card1', percent);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
        end
        delay(0.2)
        local leftmost = G.hand.highlighted[2]
        for i=1, #G.hand.highlighted do if G.hand.highlighted[i].T.x < leftmost.T.x then leftmost = G.hand.highlighted[i] end end
        for i=1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function()
                if G.hand.highlighted[i] ~= leftmost then
                    copy_card(leftmost, G.hand.highlighted[i])
                end
            return true end }))
        end
        for i = 1, #G.hand.highlighted do --unflips cards
            local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                     G.hand.highlighted[i]:flip();
                     play_sound('tarot2', percent, 0.6);
                     G.hand.highlighted[i]:juice_up(0.3, 0.3);
                     return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all();
            return true
        end })) --unselects cards
        delay(0.5)
    end
}

SMODS.Consumable{
    key = "c_reverse_temperance",
    set = "Tarot",
    atlas = "Reverse_Tarots",
    pos = {x = 5, y = 1},
    loc_txt = {
        name = "Temperance?",
        text = {
            "Gives the total sell",
            "value of all current",
            "{C:attention}Playing cards{} in hand {C:inactive}(Max of {C:money}$#1#{C:inactive})",
            "{C:inactive}(Currently {C:money}$#2#{C:inactive})",
        }
    },
    config = { context =
        {
            max_money = 50
        }
    },
    loc_vars = function(self, info_queue, center)
        local money = 0
        for i = 1, #G.hand.cards do
            if G.hand.cards[i].ability.set then
                money = money + G.hand.cards[i].sell_cost
                if G.hand.cards[i].edition then
                    money = money + 1
                end
                if G.hand.cards[i].label ~= "Base Card" then
                    money = money + 1
                end
                if G.hand.cards[i].ability.seal then
                    money = money + 1
                end
            end
        end
        money = math.min(money, 50)
        if G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.PLANET_PACK and #G.hand.cards > 1 then
            return {vars = {center.ability.context.max_money, money}}
        else
            return {vars = {center.ability.context.max_money, 0}}
        end
    end,
    can_use = function(self, card)
        if G.STATE == G.STATES.SELECTING_HAND or G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.PLANET_PACK and #G.hand.cards > 1 then
            return true
        end
    end,
    use = function(self, card, area, copier)
        local money = 0
        for i = 1, #G.hand.cards do
            if G.hand.cards[i].ability.set then
                money = money + G.hand.cards[i].sell_cost
                if G.hand.cards[i].edition then
                    money = money + 1
                end
                if G.hand.cards[i].label ~= "Base Card" then
                    money = money + 1
                end
                if G.hand.cards[i].ability.seal then
                    money = money + 1
                end
            end
        end
        money = math.min(money, 50)
        ease_dollars(money, true)
    end
}

SMODS.Consumable{
    key = "c_reverse_devil",
    set = "Tarot",
    atlas = "Reverse_Tarots",
    pos = {x = 4, y = 1},
    loc_txt = {
        name = "The Devil?",
        text = {
            "Enhances {C:attention}#1#{}",
                "selected card to a",
                "{C:attention}#2#{}"
        }
    },
    config = { context =
        {
            mod_conv = 'Pyrite Card',
            max_highlighted = 1
        }
    },
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.m_reverse_pyrite
        return {vars = {center.ability.context.max_highlighted, center.ability.context.mod_conv}}
    end,
    can_use = function(self, card)
        if G and G.hand then
            if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= 1 then
                return true
            end
        end
    end,
    use = function(self, card, area, copier)
        play_sound('tarot1')
        for i = 1, #G.hand.highlighted do --flips cards
            local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip();
                    play_sound('card1', percent);
                    G.hand.highlighted[i]:juice_up(0.3, 0.3);
                    return true
                end
            }))
        end
        delay(0.5)
        for i = 1, #G.hand.highlighted do --enhances cards
            local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                     G.hand.highlighted[i]:set_ability("m_reverse_pyrite");
                     G.hand.highlighted[i]:juice_up(0.3, 0.3);
                     return true
                end
            }))
        end
        for i = 1, #G.hand.highlighted do --unflips cards
            local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                     G.hand.highlighted[i]:flip();
                     play_sound('tarot2', percent, 0.6);
                     G.hand.highlighted[i]:juice_up(0.3, 0.3);
                     return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all();
            return true
        end })) --unselects cards
        delay(0.5)
    end
}

SMODS.Consumable{
    key = "c_reverse_tower",
    set = "Tarot",
    atlas = "Reverse_Tarots",
    pos = {x = 3, y = 1},
    loc_txt = {
        name = "The Tower?",
        text = {
            "Enhances {C:attention}#1#{}",
                "selected card to a",
                "{C:attention}#2#{}"
        }
    },
    config = { context =
        {
            mod_conv = 'Marble Card',
            max_highlighted = 1
        }
    },
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.m_reverse_marble
        return {vars = {center.ability.context.max_highlighted, center.ability.context.mod_conv}}
    end,
    can_use = function(self, card)
        if G and G.hand then
            if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= 1 then
                return true
            end
        end
    end,
    use = function(self, card, area, copier)
        play_sound('tarot1')
        for i = 1, #G.hand.highlighted do --flips cards
            local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip();
                    play_sound('card1', percent);
                    G.hand.highlighted[i]:juice_up(0.3, 0.3);
                    return true
                end
            }))
        end
        delay(0.5)
        for i = 1, #G.hand.highlighted do --enhances cards
            local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                     G.hand.highlighted[i]:set_ability("m_reverse_marble");
                     G.hand.highlighted[i]:juice_up(0.3, 0.3);
                     return true
                end
            }))
        end
        for i = 1, #G.hand.highlighted do --unflips cards
            local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                     G.hand.highlighted[i]:flip();
                     play_sound('tarot2', percent, 0.6);
                     G.hand.highlighted[i]:juice_up(0.3, 0.3);
                     return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all();
            return true
        end })) --unselects cards
        delay(0.5)
    end
}

SMODS.Consumable{
    key = "c_reverse_star",
    set = "Tarot",
    atlas = "Reverse_Tarots",
    pos = {x = 2, y = 1},
    loc_txt = {
        name = "The Star?",
        text = {
            "Enhances {C:attention}#1#{}",
                    "selected cards to",
                    "{C:attention}#2#s"
        }
    },
    config = { context =
        {
            mod_conv = 'Secondary Diamond',
            max_highlighted = 2
        }
    },
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.m_reverse_secondary_diamond
        return {vars = {center.ability.context.max_highlighted, center.ability.context.mod_conv}}
    end,
    can_use = function(self, card)
        if G and G.hand then
            if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= 2 then
                return true
            end
        end
    end,
    use = function(self, card, area, copier)
        play_sound('tarot1')
        for i = 1, #G.hand.highlighted do --flips cards
            local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip();
                    play_sound('card1', percent);
                    G.hand.highlighted[i]:juice_up(0.3, 0.3);
                    return true
                end
            }))
        end
        delay(0.5)
        for i = 1, #G.hand.highlighted do --enhances cards
            local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                     G.hand.highlighted[i]:set_ability("m_reverse_secondary_diamond");
                     G.hand.highlighted[i]:juice_up(0.3, 0.3);
                     return true
                end
            }))
        end
        for i = 1, #G.hand.highlighted do --unflips cards
            local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                     G.hand.highlighted[i]:flip();
                     play_sound('tarot2', percent, 0.6);
                     G.hand.highlighted[i]:juice_up(0.3, 0.3);
                     return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all();
            return true
        end })) --unselects cards
        delay(0.5)
    end
}

SMODS.Consumable{
    key = "c_reverse_moon",
    set = "Tarot",
    atlas = "Reverse_Tarots",
    pos = {x = 1, y = 1},
    loc_txt = {
        name = "The Moon?",
        text = {
            "Enhances {C:attention}#1#{}",
                    "selected cards to",
                    "{C:attention}#2#s"
        }
    },
    config = { context =
        {
            mod_conv = 'Secondary Club',
            max_highlighted = 2
        }
    },
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.m_reverse_secondary_club
        return {vars = {center.ability.context.max_highlighted, center.ability.context.mod_conv}}
    end,
    can_use = function(self, card)
        if G and G.hand then
            if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= 2 then
                return true
            end
        end
    end,
    use = function(self, card, area, copier)
        play_sound('tarot1')
        for i = 1, #G.hand.highlighted do --flips cards
            local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip();
                    play_sound('card1', percent);
                    G.hand.highlighted[i]:juice_up(0.3, 0.3);
                    return true
                end
            }))
        end
        delay(0.5)
        for i = 1, #G.hand.highlighted do --enhances cards
            local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                     G.hand.highlighted[i]:set_ability("m_reverse_secondary_club");
                     G.hand.highlighted[i]:juice_up(0.3, 0.3);
                     return true
                end
            }))
        end
        for i = 1, #G.hand.highlighted do --unflips cards
            local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                     G.hand.highlighted[i]:flip();
                     play_sound('tarot2', percent, 0.6);
                     G.hand.highlighted[i]:juice_up(0.3, 0.3);
                     return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all();
            return true
        end })) --unselects cards
        delay(0.5)
    end
}

SMODS.Consumable{
    key = "c_reverse_sun",
    set = "Tarot",
    atlas = "Reverse_Tarots",
    pos = {x = 0, y = 1},
    loc_txt = {
        name = "The Sun?",
        text = {
            "Enhances {C:attention}#1#{}",
                    "selected cards to",
                    "{C:attention}#2#s"
        }
    },
    config = { context =
        {
            mod_conv = 'Secondary Heart',
            max_highlighted = 2
        }
    },
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.m_reverse_secondary_heart
        return {vars = {center.ability.context.max_highlighted, center.ability.context.mod_conv}}
    end,
    can_use = function(self, card)
        if G and G.hand then
            if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= 2 then
                return true
            end
        end
    end,
    use = function(self, card, area, copier)
        play_sound('tarot1')
        for i = 1, #G.hand.highlighted do --flips cards
            local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip();
                    play_sound('card1', percent);
                    G.hand.highlighted[i]:juice_up(0.3, 0.3);
                    return true
                end
            }))
        end
        delay(0.5)
        for i = 1, #G.hand.highlighted do --enhances cards
            local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                     G.hand.highlighted[i]:set_ability("m_reverse_secondary_heart");
                     G.hand.highlighted[i]:juice_up(0.3, 0.3);
                     return true
                end
            }))
        end
        for i = 1, #G.hand.highlighted do --unflips cards
            local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                     G.hand.highlighted[i]:flip();
                     play_sound('tarot2', percent, 0.6);
                     G.hand.highlighted[i]:juice_up(0.3, 0.3);
                     return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all();
            return true
        end })) --unselects cards
        delay(0.5)
    end
}

SMODS.Consumable{
    key = "c_reverse_judgement",
    set = "Tarot",
    atlas = "Reverse_Tarots",
    pos = {x = 9, y = 0},
    loc_txt = {
        name = "Judgement?",
        text = {
            "Creates a random {C:dark_edition}Negative",
            "{C:attention}Joker{} card",
            "{C:inactive}(Is always {}{C:attention}Ephemeral{}{C:inactive})",
        }
    },
    config = { context ={}},
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.e_negative
        info_queue[#info_queue+1] = {set = "Other", key = "reverse_ephemeral", specific_vars = {}}
        return {}
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        local new_card = nil
        if pseudorandom('legendary') < 0.01 then
            new_card = SMODS.create_card({area = G.jokers, set = "Joker", edition = 'e_negative', legendary = true})
        else
            new_card = SMODS.create_card({area = G.jokers, set = "Joker", edition = 'e_negative'})
        end
        SMODS.Stickers.reverse_ephemeral:apply(new_card, true)
        new_card:add_to_deck()
        G.jokers:emplace(new_card)
        --[[
        local new_card = create_card('Joker', G.jokers, nil, nil, nil, nil, nil)
        new_card:set_edition('e_negative')
        new_card:add_to_deck()
        G.jokers:emplace(new_card)
        ]]
    end
}

SMODS.Consumable{
    key = "c_reverse_world",
    set = "Tarot",
    atlas = "Reverse_Tarots",
    pos = {x = 8, y = 0},
    loc_txt = {
        name = "The World?",
        text = {
            "Enhances {C:attention}#1#{}",
                    "selected cards to",
                    "{C:attention}#2#s"
        }
    },
    config = { context =
        {
            mod_conv = 'Secondary Spade',
            max_highlighted = 2
        }
    },
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.m_reverse_secondary_spade
        return {vars = {center.ability.context.max_highlighted, center.ability.context.mod_conv}}
    end,
    can_use = function(self, card)
        if G and G.hand then
            if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= 2 then
                return true
            end
        end
    end,
    use = function(self, card, area, copier)
        play_sound('tarot1')
        for i = 1, #G.hand.highlighted do --flips cards
            local percent = 1.15 - (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    G.hand.highlighted[i]:flip();
                    play_sound('card1', percent);
                    G.hand.highlighted[i]:juice_up(0.3, 0.3);
                    return true
                end
            }))
        end
        delay(0.5)
        for i = 1, #G.hand.highlighted do --enhances cards
            local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                     G.hand.highlighted[i]:set_ability("m_reverse_secondary_spade");
                     G.hand.highlighted[i]:juice_up(0.3, 0.3);
                     return true
                end
            }))
        end
        for i = 1, #G.hand.highlighted do --unflips cards
            local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                     G.hand.highlighted[i]:flip();
                     play_sound('tarot2', percent, 0.6);
                     G.hand.highlighted[i]:juice_up(0.3, 0.3);
                     return true
                end
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all();
            return true
        end })) --unselects cards
        delay(0.5)
    end
}

SMODS.Joker{
    key = 'Rekoj',
    loc_txt = {
        name = 'Rekoj',
        text = {
            '{X:mult,C:white}#1#{} Mult'
        }
    },
    rarity = 1,
    cost = 1,
    atlas = "Reverse_Jokers",
    pos = {x = 0, y = 0},
    config = {extra = {mult = -4}},
    blueprint_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.mult}}
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            return {
                card = card,
                mult_mod = card.ability.extra.mult,
                message = "" .. card.ability.extra.mult,
                colour = G.C.Mult
            }
        end
    end
}

SMODS.Joker{
    key = 'crystal_joker',
    loc_txt = {
        name = 'Crystal Joker',
        text = {
            "This Joker gains {X:chips,C:white} X#1# {} Chips",
                    "for every {C:attention}Crystal{} card",
                    "that is destroyed",
                    "{C:inactive}(Currently {X:chips,C:white} X#2# {C:inactive} Chips)"
        },
        unlock = {
            "Have at least {E:1,C:attention}5",
            "{E:1,C:attention}Crystal Cards{} in",
            "your deck",
        }
    },
    rarity = 2,
    cost = 6,
    atlas = "Reverse_Jokers",
    pos = {x = 2, y = 0},
    unlock_condition = {type = 'modify_deck', extra = {count = 5, enhancement = 'm_reverse_crystal'}},
    enhancement_gate = 'm_reverse_crystal',
    unlocked = false,
    config = {
            x_chips = 1,
            gain = 0.75
    },
    blueprint_compat = true,
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.m_reverse_crystal
        return {vars = {center.ability.gain, center.ability.x_chips}}
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            return {
                x_chips = card.ability.x_chips
            }
        elseif context.cards_destroyed and not context.blueprint then
            local glasses = 0
                for k, v in ipairs(context.glass_shattered) do
                    if v.shattered and SMODS.has_enhancement(v, 'm_reverse_crystal') then
                        glasses = glasses + 1
                    end
                end
                if glasses > 0 then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            card.ability.x_chips = card.ability.x_chips + card.ability.gain*glasses
                          return true
                        end
                      }))
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.x_chips + card.ability.gain*glasses}}})
                    return true
                end
              }))
                end
        elseif context.remove_playing_cards and not context.blueprint then
            local glass_cards = 0
            for k, val in ipairs(context.removed) do
                if val.shattered and SMODS.has_enhancement(val, 'm_reverse_crystal') then glass_cards = glass_cards + 1 end
            end
            if glass_cards > 0 then 
                G.E_MANAGER:add_event(Event({
                    func = function()
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card.ability.x_chips = card.ability.x_chips + card.ability.gain*glass_cards
                    return true
                    end
                }))
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_xmult', vars = {card.ability.x_chips + card.ability.gain*glass_cards}}})
                return true
                    end
                }))                    return nil, true
            end
        elseif context.using_consumeable then
            if not context.blueprint and context.consumeable.ability.name == 'The Hanged Man' then
                local shattered_glass = 0
                    for k, val in ipairs(G.hand.highlighted) do
                        if SMODS.has_enhancement(val, 'm_reverse_crystal') then shattered_glass = shattered_glass + 1 end
                    end
                    if shattered_glass > 0 then
                        card.ability.x_chips = card.ability.x_chips + card.ability.gain*shattered_glass
                        G.E_MANAGER:add_event(Event({
                            func = function() card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_xmult',vars={card.ability.x_chips}}}); return true
                            end}))
                    end
            end
        end
    end
}

SMODS.Joker{
    key = 'copper_joker',
    loc_txt = {
        name = 'Copper Joker',
        text = {
            "Gives {X:chips,C:white} X#1# {} Chips",
            "for each {C:attention}Copper{} card",
            "in your {C:attention}full deck",
            "{C:inactive}(Currently {X:chips,C:white} X#2# {C:inactive} Chips)",
        }
    },
    atlas = "Reverse_Jokers",
    pos = {x = 1, y = 0},
    config = {
        extra = {
            copper_tally = 0,
            gain = .2
        }
    },
    rarity = 2,
    cost = 7,
    enhancement_gate = 'm_reverse_copper',
    blueprint_compat = true,
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.m_reverse_copper
        return {vars = {center.ability.extra.gain,  1 + center.ability.extra.gain*center.ability.extra.copper_tally}}
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            return {
                x_chips = 1 + card.ability.extra.gain*card.ability.extra.copper_tally
            }
        end
    end,
    update = function(self, card, dt)
        card.ability.extra.copper_tally = 0
        if G.playing_cards then
            for k, v in pairs(G.playing_cards) do
                if SMODS.has_enhancement(v, 'm_reverse_copper') then card.ability.extra.copper_tally = card.ability.extra.copper_tally+1 end
            end
        end
    end
}

SMODS.Joker{
    key = 'sculptor',
    loc_txt = {
        name = 'Sculptor',
        text = {
            "Adds one {C:attention}Marble{} card",
            "to deck when",
            "{C:attention}Blind{} is selected",
        }
    },
    rarity = 2,
    cost = 6,
    atlas = "Reverse_Jokers",
    pos = {x = 0, y = 1},
    config = {},
    blueprint_compat = true,
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.m_reverse_marble
        return
    end,
    calculate = function(self,card,context)
        if context.setting_blind and not self.debuff then
            if not (context.blueprint_card or card).getting_sliced then
                G.E_MANAGER:add_event(Event({
                func = function() 
                    local front = pseudorandom_element(G.P_CARDS, pseudoseed('marb_fr'))
                    G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                    local acard = Card(G.play.T.x + G.play.T.w/2, G.play.T.y, G.CARD_W, G.CARD_H, front, G.P_CENTERS.m_reverse_marble, {playing_card = G.playing_card})
                    card:start_materialize({G.C.SECONDARY_SET.Enhanced})
                    G.play:emplace(acard)
                    table.insert(G.playing_cards, acard)
                    return true
                end}))
            G.E_MANAGER:add_event(Event({
                func = function() 
                    G.deck.config.card_limit = G.deck.config.card_limit + 1
                    return true
                end}))
                draw_card(G.play,G.deck, 90,'up', nil)  

                playing_card_joker_effects({true})
                return nil, true
            end
        end
    end
}

SMODS.Joker{
    key = 'marbled_joker',
    loc_txt = {
        name = 'Marbled Joker',
        text = {
            "Gives {C:mult}+#1#{} Mult for",
                    "each {C:attention}Marble{} card",
                    "in your {C:attention}full deck",
                    "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)"
        }
    },
    rarity = 2,
    cost = 6,
    atlas = "Reverse_Jokers",
    pos = {x = 1, y = 1},
    config = {
        extra = {
            marble_tally = 0,
            gain = 5
        }
    },
    blueprint_compat = true,
    enhancement_gate = 'm_reverse_marble',
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.m_reverse_marble
        return {vars = {center.ability.extra.gain, center.ability.extra.gain*center.ability.extra.marble_tally}}
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            return {
                mult = card.ability.extra.gain*card.ability.extra.marble_tally
            }
        end
    end,
    update = function(self, card, dt)
        card.ability.extra.marble_tally = 0
        if G.playing_cards then
            for k, v in pairs(G.playing_cards) do
                if SMODS.has_enhancement(v, 'm_reverse_marble') then card.ability.extra.marble_tally = card.ability.extra.marble_tally + 1 end
            end
        end
    end
}

SMODS.Joker{
    key = 'omni_joker',
    loc_txt = {
        name = 'Omni-Joker',
        text = {
            "Each {C:attention}Omnirank{} card in",
            "played hand gives",
            "{X:chips,C:white}X#1#{} Chips when scored",
        }
    },
    rarity = 2,
    cost = 6,
    atlas = "Reverse_Jokers",
    pos = {x = 2, y = 1},
    config = {extra = {x_chips = 1.5}},
    blueprint_compat = true,
    enhancement_gate = 'm_reverse_omnirank',
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.m_reverse_omnirank
        return {vars = {center.ability.extra.x_chips}}
    end,
    calculate = function(self,card,context)
        if context.individual and context.cardarea == G.play then
            if is_omnirank(context.other_card) then
                return {
                    x_chips = card.ability.extra.x_chips,
                    card = card
                }
            end
        end
    end
}

SMODS.Joker{
    key = 'wild_joker',
    loc_txt = {
        name = 'Wild Joker',
        text = {
            "Gives {X:mult,C:white} X#1# {} Mult",
            "for each {C:attention}multisuited{} card",
            "in your {C:attention}full deck",
            "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
        }
    },
    atlas = "Reverse_Jokers",
    pos = {x = 0, y = 2},
    config = {
        extra = {
            suit_tally = 0,
            gain = .1
        }
    },
    rarity = 2,
    cost = 6,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.gain,  1 + center.ability.extra.gain*center.ability.extra.suit_tally}}
    end,
    in_pool = function(self, args)
        for _, v in ipairs(G.playing_cards) do
            if SMODS.has_enhancement(v, 'm_wild') or v:has_secondary_suit() then
                return true
            end
        end
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            return {
                x_mult = 1 + card.ability.extra.gain*card.ability.extra.suit_tally
            }
        end
    end,
    update = function(self, card, dt)
        card.ability.extra.suit_tally = 0
        if G.playing_cards then
            for k, v in pairs(G.playing_cards) do
                if SMODS.has_enhancement(v, 'm_wild') or v:has_secondary_suit() then card.ability.extra.suit_tally = card.ability.extra.suit_tally + 1 end
            end
        end
    end
}

SMODS.Joker{
    key = 'counterfeit_bill',
    loc_txt = {
        name = 'Counterfeit Bill',
        text = {
            "This Joker earns {C:money}$#1#{} at end of",
            "round and gains {C:money}$#2#{}",
            "every time a {C:attention}Counterfeit{} card",
            "{C:green}successfully{} triggers",
        }
    },
    atlas = "Reverse_Jokers",
    pos = {x = 4, y = 1},
    config = {
        extra = {
            current_money = 5,
            gain = 1
        }
    },
    rarity = 2,
    cost = 6,
    enhancement_gate = 'm_reverse_counterfeit',
    blueprint_compat = true,
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.m_reverse_counterfeit
        return {vars = {center.ability.extra.current_money,  center.ability.extra.gain}}
    end,
    calculate = function(self,card,context)
        if context.end_of_round and context.cardarea == G.jokers then
            return {
                dollars = card.ability.extra.current_money
            }
        end
        if context.individual and context.cardarea == G.play then
            if context.other_card.counterfeit_trigger and not context.blueprint then
                card.ability.extra.current_money = card.ability.extra.current_money + card.ability.extra.gain
                return {
                    card = card,
                    message = "+$" .. card.ability.extra.gain,
                    colour = G.C.money
                }
            end
        end
    end
}

SMODS.Joker{
    key = 'fools_gold',
    loc_txt = {
        name = "Fool's Gold",
        text = {
            "{C:attention}Pyrite{} cards",
            "Now {C:attention}earn{} {C:money}$#1#{}",
            "while it stays",
            "in your hand"
        },
        unlock = {
            "Play a 5 card hand",
            "that contains only",
            "{C:attention,E:1}Pyrite{} cards",
        }
    },
    atlas = "Reverse_Jokers",
    pos = {x = 3, y = 0},
    config = {
        extra = {
            earned = 4
        }
    },
    rarity = 1,
    cost = 5,
    enhancement_gate = 'm_reverse_pyrite',
    unlock_condition = {type = 'hand_contents', enhancement_gate = 'm_reverse_pyrite'},
    unlocked = false,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, center)
        info_queue[#info_queue+1] = G.P_CENTERS.m_reverse_pyrite
        return {vars = {center.ability.extra.earned}}
    end,
    calculate = function(self,card,context)
        if context.individual and context.cardarea == G.hand then
            if SMODS.has_enhancement(context.other_card, 'm_reverse_pyrite') then
                return {dollars = card.ability.extra.earned}
            end
        end
    end
}

SMODS.Joker{
    key = 'rewrite',
    loc_txt = {
        name = "Rewrite",
        text = {
            "This Joker gains {X:mult,C:white}X#1#{} Mult",
            "when an {C:attention}Enhanced{} card",
            "is {C:attention}Enhanced{} again",
            "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
        }
    },
    atlas = "Reverse_Jokers",
    pos = {x = 3, y = 1},
    config = {
        extra = {
            enhance_tally = 0,
            gain = .1
        }
    },
    rarity = 2,
    cost = 7,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.gain, 1 + center.ability.extra.gain*center.ability.extra.enhance_tally}}
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            return {
                x_mult = 1 + card.ability.extra.gain*card.ability.extra.enhance_tally
            }
        end
        if not context.blueprint then
            local overwrite = 0
            if context.using_consumeable then
                for k, v in ipairs(G.hand.highlighted) do
                    if v.ability.name ~= "Default Base" then
                        card.ability.extra.enhance_tally =  card.ability.extra.enhance_tally + 1
                        overwrite = overwrite + 1
                    end
                end
            end
            if context.before and next(find_joker("Midas Mask")) then
                --INSERT MIDAS MASK CONDITION
                local midas = #find_joker("Midas Mask")
                for k, v in ipairs(context.scoring_hand) do
                    local already_enhanced = 1
                    if v:is_face() then
                        if v.ability.name ~= "Default Base" then
                            already_enhanced = 0
                        end
                        card.ability.extra.enhance_tally =  card.ability.extra.enhance_tally + midas - already_enhanced
                        overwrite = overwrite + midas - already_enhanced
                    end
                end
            end
            if overwrite > 0 then
                return {
                    card = card,
                    message = "X" .. card.ability.extra.gain * overwrite,
                    colour = G.C.x_mult
                }
            end
        end
    end
}

SMODS.Joker{
    key = 'cartomancer?',
    loc_txt = {
        name = "Cartomancer?",
        text = {
            "Create a {C:tarot}Reverse Tarot{} card",
            "when {C:attention}Blind{} is selected",
            "{C:inactive}(Must have room)",
        }
    },
    rarity = 2,
    cost = 6,
    atlas = "Reverse_Jokers",
    pos = {x = 4, y = 0},
    config = {},
    blueprint_compat = true,
    loc_vars = function(self, info_queue, center)
        return
    end,
    calculate = function(self,card,context)
        if context.setting_blind and not card.getting_sliced then
            if not (context.blueprint_card or self).getting_sliced and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        G.E_MANAGER:add_event(Event({
                            func = function() 
                                local card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, nil, 'rcar')
                                card:add_to_deck()
                                G.consumeables:emplace(card)
                                G.GAME.consumeable_buffer = 0
                                return true
                            end}))                    
                        return true
                    end)}))
                return {
                    card = card,
                    message = "+1 Tarot",
                    colour = G.C.PURPLE
                    }          
            end
        end
    end
}

SMODS.Joker{
    key = 'card_reading',
    loc_txt = {
        name = "Card Reading",
        text = {
            "Create a {C:purple}Reverse Tarot{} card",
                    "if hand is played",
                    "with money over the",
                    "{C:money}interest cap ($#1#)"
        }
    },
    rarity = 3,
    cost = 8,
    atlas = "Reverse_Jokers",
    pos = {x = 1, y = 2},
    soul_pos = {x = 0, y = 3},
    config = {},
    blueprint_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {G.GAME.interest_cap or 25}}
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                if G.GAME.dollars >= G.GAME.interest_cap then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        trigger = 'before',
                        delay = 0.0,
                        func = (function()
                                local card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, nil, 'rvag')
                                card:add_to_deck()
                                G.consumeables:emplace(card)
                                G.GAME.consumeable_buffer = 0
                            return true
                        end)}))
                        return {
                            card = card,
                            message = "+1 Tarot",
                            colour = G.C.PURPLE
                        }
                end
            end
        end
    end
}

SMODS.Joker{
    key = 'd6',
    loc_txt = {
        name = "The D6",
        text = {
            "Gives a random amount",
            "of {X:mult,C:white}XMult",
            "between 1 and 6"
        }
    },
    rarity = 3,
    cost = 8,
    atlas = "Reverse_Jokers",
    pos = {x = 1, y = 2},
    soul_pos = {x = 1, y = 3},
    config = {},
    blueprint_compat = true,
    loc_vars = function(self, info_queue, center)
        return
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            return {x_mult = math.floor(pseudorandom('D6')*6) + 1}
        end
    end
}

SMODS.Joker{
    key = 'dead_cat',
    loc_txt = {
        name = "Dead Cat",
        text = {
            "Prevents Death",
            "up to 9 times",
            "if chips scored",
            "are at least {C:attention}50%",
            "of required chips",
            "sets hands per round to 1",
            "{S:1.1,C:red,E:2}#1# remaining{}",
        }
    },
    rarity = 3,
    cost = 10,
    atlas = "Reverse_Jokers",
    pos = {x = 1, y = 2},
    soul_pos = {x = 2, y = 3},
    config = {
        extra = {
            lives = 9
        }
    },
    blueprint_compat = false,
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.lives}}
    end,
    calculate = function(self,card,context)
        if context.first_hand_drawn then
            ease_hands_played(-G.GAME.current_round.hands_left + 1)
            return {
                message = "Final Hand!",
                colour = G.C.RED
            }
        end
        if context.end_of_round and not context.blueprint and context.main_eval then
            if G.GAME.chips/G.GAME.blind.chips >= 0.5 and G.GAME.chips < G.GAME.blind.chips then
                card.ability.extra.lives = card.ability.extra.lives - 1
                if card.ability.extra.lives <= 0 then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.hand_text_area.blind_chips:juice_up()
                            G.hand_text_area.game_chips:juice_up()
                            play_sound('tarot1')
                            card:start_dissolve()
                            return true
                        end
                    })) 
                end
                return {
                    message = localize('k_saved_ex'),
                    saved = true,
                    colour = G.C.RED
                }
            end
        end
    end
}

SMODS.Joker{
    key = 'double_or_nothing',
    loc_txt = {
        name = "Double or Nothing",
        text = {
            "Starts at {X:mult,C:white}X#1#{{} Mult",
            "{C:green}#2# in 2{} chance to",
            "{C:attention}double{} its {X:mult,C:white}XMult{} for each",
            "hand played {C:attention}this round",
            "{C:inactive}(currently at {X:mult,C:white}X#3#{C:inactive} Mult)"
        }
    },
    rarity = 3,
    cost = 8,
    atlas = "Reverse_Jokers",
    pos = {x = 2, y = 2},
    config = {
        extra = {
            gain = 2,
            base = 1
        }
    },
    blueprint_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {1, G.GAME.probabilities.normal, center.ability.extra.base}}
    end,
    calculate = function(self,card,context)
        if context.before and not context.blueprint then
            if pseudorandom('double') <= G.GAME.probabilities.normal/2 then
                card.ability.extra.base = card.ability.extra.base*card.ability.extra.gain
                return {
                    message = "X2 Mult",
                    colour = G.C.RED
                }
            end
        elseif context.joker_main then
            return {x_mult = card.ability.extra.base}
        elseif context.end_of_round and not context.blueprint and context.main_eval then
            card.ability.extra.base = 1
            return {
                message = localize('k_reset'),
                colour = G.C.RED
            }
        end
    end
}

SMODS.Blind{
    key = "left_hand",
    atlas = "Reverse_Bosses",
    pos = {x = 0, y = 0},
    loc_txt = {
        name = "The Left Hand",
        text = {
            "Debuffs the effects",
            "of all cards",
            "{C:attention}held in hand"
        }
    },
    dollars = 5,
    mult = 2,
    discovered = false,
    boss = {min = 1},
    boss_colour = HEX('28ADB5'),
    loc_vars = function(self, info_queue, center)
        return
    end,
    set_blind = function(self)
        for _, v in ipairs(G.playing_cards) do
            v:set_debuff(true)
        end
        return
    end,
    press_play = function(self)
        for _, v in ipairs(G.hand.highlighted) do
            v:set_debuff(false)
        end
        return
    end,
    disable_self = function(self)
        for _, v in ipairs(G.playing_cards) do
            v:set_debuff(false)
        end
        return
    end,
    defeat_self = function(self)
        for _, v in ipairs(G.playing_cards) do
            v:set_debuff(false)
        end
        return
    end,
    recalc_debuff = function(self, card, from_blind)
        return card.debuff
    end
}

SMODS.Blind{
    key = "right_hand",
    atlas = "Reverse_Bosses",
    pos = {x = 0, y = 1},
    loc_txt = {
        name = "The Right Hand",
        text = {
            "Debuffs the effects",
            "of all cards",
            "{C:attention}in scoring hand"
        }
    },
    dollars = 5,
    mult = 2,
    discovered = false,
    boss = {min = 2},
    boss_colour = HEX('C71FC7'),
    loc_vars = function(self, info_queue, center)
        return
    end,
    press_play = function(self)
        if not self.disabled then
            for _, v in ipairs(G.hand.highlighted) do
                v:set_debuff(true)
            end
        end
        return
    end,
    disable_self = function(self)
        self.disabled = true
        return
    end,
    defeat_self = function(self)
        for _, v in ipairs(G.playing_cards) do
            v:set_debuff(false)
        end
        return
    end,
    recalc_debuff = function(self, card, from_blind)
        return card.debuff
    end
}

function is_rank(card, ranks)
    if SMODS.has_no_rank(card) and not card.vampired then return false end
    if is_omnirank(card) then return true end
    for _, value in ipairs(ranks) do
        if card.base.id == value then return true end
    end
    return false
end

function is_omnirank(card)
    if card.ability.name and not card.debuff then
        return card.ability.name == 'm_reverse_omnirank'
    end
    return false
end

function evaluate_poker_hand_wrapper(hand)
    local omni = {}
    local best_hand = nil
    for i=1, #hand, 1 do
        words = {}
        if hand[i].ability.name then
            for w in hand[i].ability.name:gmatch("([^_]+)") do
                table.insert(words, w) 
            end
            if words[#words] == 'omnirank' then
                table.insert(omni, i)
            end
        end
    end
    if #omni > 0 then
        --print(tprint(hand[1].ability))
        return get_best_omnihand(omni, hand, best_hand, 1)
    else
        --print(tprint(hand[1].ability))
        return evaluate_poker_hand(hand)
    end
end

function get_best_omnihand(omni, hand, best_hand, iteration)
    if #omni <=3 then
        local current_card = omni[iteration]
        for i=2, 14, 1 do
            hand[current_card].base.id = i
            local current_hand = {}
            if #omni > iteration then
                current_hand = get_best_omnihand(omni, hand, best_hand, iteration + 1)
            else
                for j = 1, #hand, 1 do
                end
                --if new_straight(hand) then print("Straight!") end
                current_hand = evaluate_poker_hand(hand)
            end
            best_hand = compare_hand(current_hand, best_hand)
        end
    elseif #omni == #hand and #omni == 4 then --if 4 cards played, no need to check for anything less than 4oaK
        --print("4 played, 4 hand size")
        if next(get_flush(hand)) then --if there is a flush, then it must be a straight flush (accounts for 4 fingers in get_flush())
            --print("straight flush")
            for i = 2, 5, 1 do
                hand[i-1].base.id = i
                --print(hand[i-1].base.id)
            end
            best_hand = evaluate_poker_hand(hand)
        else
            --print("4oaK")
            for i = 1, 4, 1 do
                hand[i].base.id = 1
            end
            best_hand = evaluate_poker_hand(hand)
        end
    else -- if 5 or more cards played (5oaK or Flush 5)
        --print("5oaK")
        correct_value = 1
        for j=1, #hand, 1 do
            if not is_omnirank(hand[j]) then
                correct_value = hand[j].base.id
            end
        end
        for j=1, #hand, 1 do
            if is_omnirank(hand[j]) then
                hand[j].base.id = correct_value
            end
        end
        current_hand = evaluate_poker_hand(hand)
        best_hand = compare_hand(current_hand, best_hand)
    end
    return best_hand
end

function compare_hand(current_hand, best_hand)
    if best_hand then
        for _, v in ipairs(G.handlist) do
            if next(current_hand[v]) then return current_hand
            elseif next(best_hand[v])then return best_hand end 
        end
    else
        return current_hand
    end
end

function copy(obj, seen)
    if type(obj) ~= 'table' then return obj end
    if seen and seen[obj] then return seen[obj] end
    local s = seen or {}
    local res = setmetatable({}, getmetatable(obj))
    s[obj] = res
    for k, v in pairs(obj) do res[copy(k, s)] = copy(v, s) end
    return res
end

-- eval evaluate_poker_hand_wrapper(G.hand.highlighted, 1)

function new_straight(hand)
    local ace_high = {}
    local ace_low = {}
    local all_hands = {}
    length = next(SMODS.find_card('j_four_fingers')) and 4 or 5
    can_skip = next(SMODS.find_card('j_shortcut')) and 2 or 1
    if #hand >= length then
        for i=1, #hand, 1 do
            table.insert(ace_high, hand[i].base.id)
        end
        table.sort(ace_high)
        if ace_high[#ace_high] == 14 then
            for i=1, #hand, 1 do
                if hand[i].base.id == 14 then
                    table.insert(ace_low, 1)
                else
                    table.insert(ace_low, hand[i].base.id)
                end
            end
        end
        table.sort(ace_low)
        table.insert(all_hands, ace_high)
        if ace_low then table.insert(all_hands, ace_low) end
        for i=1, #all_hands, 1 do
            local cards_in_straight = {}
            for j=1, #hand-1, 1 do
                if (all_hands[i][j] == all_hands[i][j+1] or all_hands[i][j+1] - all_hands[i][j] > can_skip) and #cards_in_straight < length then
                    cards_in_straight = {all_hands[i][j+1]}
                elseif not (all_hands[i][j] == all_hands[i][j+1] or all_hands[i][j+1] - all_hands[i][j] > can_skip) then
                    if #cards_in_straight == 0 then
                        table.insert(cards_in_straight, all_hands[i][j])
                        table.insert(cards_in_straight, all_hands[i][j+1])
                    else
                        table.insert(cards_in_straight, all_hands[i][j+1])
                    end
                end
            end
            if #cards_in_straight >= length then
                final_cards = {}
                for index, value in ipairs(cards_in_straight) do
                    print(value)
                    for k=1, #hand, 1 do
                        if hand[k].base.id == value then
                            table.insert(final_cards, hand[k])
                            break
                        end
                    end
                end
                print(final_cards)
                return final_cards
            end
        end
    end
    return {}
end

--[[
target = "functions/misc_functions.lua"
pattern = '''function get_straight(hand)'''
position = "at"
payload = '''function old_straight(hand)'''
match_indent = true
times = 1
]]