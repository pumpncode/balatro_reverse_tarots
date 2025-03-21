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
            "when a selected {C:attention}Enhanced{} card",
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

SMODS.Joker{ --To add: info_queue for effects.
    key = 'daily_double',
    loc_txt = {
        name = "Daily Double",
        text = {
            "Doubles a different value",
            "based on the current day of the week",
            "#1#: {B:1,C:white}X2{} #2#"
        }
    },
    rarity = 3,
    cost = 8,
    atlas = "Reverse_Jokers",
    pos = {x = 3, y = 2},
    config = {
        extra = 
        {
            day = os.date("*t").wday
        }
    },
    blueprint_compat = true,
    loc_vars = function(self, info_queue, center)
        local effect = ""
        self.config.extra.day = os.date("*t").wday
        if self.config.extra.day == 1 then
            effect = "Mult"
            color = "mult"
            self.blueprint_compat = true
        elseif self.config.extra.day == 2 then
            effect = "Payout from round (max $40)"
            color = "money"
            self.blueprint_compat = true
        elseif self.config.extra.day == 3 then
            effect = "Packs appear per shop"
            color = "attention"
            self.blueprint_compat = true
        elseif self.config.extra.day == 4 then
            effect = "Consumable slots"
            color = "tarot"
            self.blueprint_compat = false
        elseif self.config.extra.day == 5 then
            effect = "levels per planet card"
            color = "planet"
            self.blueprint_compat = false
        elseif self.config.extra.day == 6 then
            effect = "chance for cards to have editions"
            color = "dark_edition"
            self.blueprint_compat = false
        else
            effect = "Chips"
            color = "chips"
            self.blueprint_compat = true
        end
        info_queue[#info_queue+1] = { set = 'Other', key = 'daily_description' }
        return {vars = { os.date("%A"), effect, colours = {G.ARGS.LOC_COLOURS[color]}}}
    end,
    add_to_deck = function(self, card, from_debuff)
        update_daily_double()
        if G.GAME.day == 3 then
            local mod = 2 ^ (#find_joker("j_reverse_daily_double") + 1)
            SMODS.change_booster_limit(mod)
        elseif G.GAME.day == 4 then
            G.consumeables.config.card_limit = G.consumeables.config.card_limit * 2
        elseif G.GAME.day == 6 then
            G.GAME.edition_rate = G.GAME.edition_rate * 2
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        update_daily_double()
        if G.GAME.day == 3 then
            local mod = - 2 ^ (#find_joker("j_reverse_daily_double") + 1)
            SMODS.change_booster_limit(mod)
        elseif G.GAME.day == 4 then
            G.consumeables.config.card_limit = G.consumeables.config.card_limit / 2
        elseif G.GAME.day == 6 then
            G.GAME.edition_rate = G.GAME.edition_rate / 2
        end
    end,
    calculate = function(self,card,context)
        update_daily_double()
        if context.joker_main then
            if G.GAME.day == 1 then
                return {x_mult = 2}
            elseif G.GAME.day == 7 then
                return {x_chips = 2}
            end
        end
    end,
    update = function(self, card, card_table, other_card)
        --update_daily_double()
    end
}

function update_daily_double()
    local current_day = os.date("*t").wday
    if G.GAME.day ~= current_day and G.GAME.day then
        if G.GAME.day == 3 then
            local mod = - 2 ^ (#find_joker("j_reverse_daily_double") + 1) + 2
            SMODS.change_booster_limit(mod)
        elseif G.GAME.day == 4 then
            G.consumeables.config.card_limit = G.consumeables.config.card_limit / 2 ^ (#find_joker("j_reverse_daily_double"))
        elseif G.GAME.day == 6 then
            G.GAME.edition_rate = G.GAME.edition_rate / 2 ^ (#find_joker("j_reverse_daily_double"))
        end
        if current_day == 3 then
            local mod = 2 ^ (#find_joker("j_reverse_daily_double") + 1)
            SMODS.change_booster_limit(mod)
        elseif current_day == 4 then
            G.consumeables.config.card_limit = G.consumeables.config.card_limit * 2 ^ (#find_joker("j_reverse_daily_double"))
        elseif current_day == 6 then
            G.GAME.edition_rate = G.GAME.edition_rate * 2 ^ (#find_joker("j_reverse_daily_double"))
        end
    end
    G.GAME.day = current_day
end

SMODS.Joker{
    key = 'negative',
    loc_txt = {
        name = "Negative",
        text={
            "First played {C:attention}face",
            "card gives {X:chips,C:white} X#1# {} Chips",
            "when scored",
        },
    },
    rarity = 1,
    cost = 5,
    atlas = "Reverse_Jokers",
    pos = {x = 4, y = 4},
    config = {
        extra = {
            value = 2
        }
    },
    blueprint_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {2}}
    end,
    calculate = function(self,card,context)
        if context.individual then
            if context.cardarea == G.play then
                local first_face = nil
                for i = 1, #context.scoring_hand do
                    if context.scoring_hand[i]:is_face() then first_face = context.scoring_hand[i]; break end
                end
                if context.other_card == first_face then
                    return {
                        x_chips = 2,
                        colour = G.C.RED,
                        card = card
                    }
                end
            end
        end
    end,
    load = function(self, card, card_table, other_card)
        local scale = 1
        local H = G.CARD_H
        local W = G.CARD_W
        card.T.h = H*scale/1.2*scale
        card.T.w = W*scale
    end,
    set_sprites = function(self, card, front)
        card.children.center.scale.y = card.children.center.scale.y/1.2
    end,
    set_ability = function(self, card, initial, delay_sprites)
        local H = card.T.h
        H = H/1.2
        card.T.h = H
    end,
    
}

SMODS.Joker{
    key = 'harmonic_convergence',
    loc_txt = {
        name = "Harmonic Convergence",
        text={
            "{C:green}#1# in #2#{} chance to gain",
            "{X:mult,C:white} X#3# {} Mult when hand scored,",
            "{C:green}odds{} decrease on successful trigger",
            "{C:inactive}(currently at {X:mult,C:white} X#4# {C:inactive} Mult)"
        },
    },
    rarity = 2,
    cost = 8,
    atlas = "Reverse_Jokers",
    pos = {x = 0, y = 4},
    config = {
        extra = {
            n = 1,
            gain = .25
        }
    },
    blueprint_compat = true,
    loc_vars = function(self, info_queue, center)
        return {vars = {G.GAME.probabilities.normal, center.ability.extra.n, center.ability.extra.gain, 1 + center.ability.extra.gain * (center.ability.extra.n - 1)}}
    end,
    calculate = function(self,card,context)
        if context.before and not context.blueprint then
            local convergence = pseudorandom('convergence')
            if convergence < G.GAME.probabilities.normal/card.ability.extra.n then
                card.ability.extra.n = card.ability.extra.n + 1
                return {
                    card = card,
                    message = "X" .. card.ability.extra.gain,
                    colour = G.C.RED
                }
            end
        end
        if context.joker_main then
            return {
                x_mult = 1 + card.ability.extra.gain * (card.ability.extra.n - 1)
            }
        end
    end
}

SMODS.Joker{
    key = 'nazuna',
    loc_txt = {
        name = "Nazuna",
        text={
            "This Joker gains {X:mult,C:white} X#1# {} Mult",
            "per scoring {C:attention}Enhanced card{} played,",
            "{C:attention}keeps{} card {C:attention}Enhancement",
            "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
        },
    },
    rarity = 4,
    cost = 20,
    atlas = "Reverse_Jokers",
    pos = {x = 3, y = 3},
    soul_pos = {x = 3, y = 4},
    config = {
        extra = {
            enhance_tally = 0,
            gain = .1
        }
    },
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
            local increase = 0
            if context.before then
                for k, v in ipairs(context.scoring_hand) do
                    if v.ability.name ~= "Default Base" then
                        card.ability.extra.enhance_tally =  card.ability.extra.enhance_tally + 1
                        increase = increase + 1
                    end
                end
                if next(find_joker("Midas Mask")) then
                    increase = #context.scoring_hand
                end
                if increase > 0 then
                    card.ability.extra.enhance_tally =  card.ability.extra.enhance_tally + increase
                    return {
                        card = card,
                        message = "X" .. card.ability.extra.gain * increase,
                        colour = G.C.x_mult
                    }
                end
            end
        end
    end
}