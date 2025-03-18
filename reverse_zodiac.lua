SMODS.UndiscoveredSprite {
    key = "Zodiac",
    atlas = "Reverse_Tarots",
    pos = {x = 0, y = 0} 
}

SMODS.ConsumableType {
    key = "Zodiac",
    primary_colour = HEX("C61CBB"),
    secondary_colour = HEX("96108D"),
    loc_txt = {
        name = "Zodiac",
        collection = "Zodiac Cards"
    },
    collection_rows = {7, 6},
    shop_rate = 0,
    default = "c_reverse_aquarius",
}

SMODS.PokerHand {
    key = "parity",
    mult = 2,
    chips = 25,
    l_mult = 2,
    l_chips = 25,
    visible = true,
    above_hand = "Two Pair",
    example = {
        {'D_T', true},
        {'C_8', true},
        {'C_6', true},
        {'S_2', true},
        {'H_2', true}
    },
    loc_txt = {
        name = "Parity",
        description = {
            "Play five cards that are either all even or all odd",
            "(excludes face cards)"
        }
    },
    loc_vars = function(self, info_queue, center)
        --print(center.ability.name)
    end,
    evaluate = function(parts, hand)
        if #hand == 5 then
            local parity = hand[1].base.id % 2
            if hand[1].base.id == 14 then parity = 1 end
            for i=1, #hand, 1 do
                if hand[i]:is_face() or SMODS.has_enhancement(hand[i], "m_stone") or SMODS.has_enhancement(hand[i], "m_reverse_marble") then
                    return {}
                elseif hand[i].base.id % 2 ~= parity and not (hand[i].base.id == 14 and parity == 1) then
                    return {}
                end
            end
            return {hand}
        end
        return {}
    end
}

SMODS.Consumable{
    key = "janus",
    set = "Planet",
    atlas = "Reverse_Tarots",
    pos = {x = 1, y = 0},
    loc_txt = {
        name = "Janus",
        text={
            "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
            "{C:attention}#2#",
            "{C:mult}+#3#{} Mult and",
            "{C:chips}+#4#{} chips",
        },
    },
    config = {hand_type = 'reverse_parity'},
    loc_vars = function(self, info_queue, center)
        return {
            vars = {
                G.GAME.hands["reverse_parity"].level,
                "Parity",
                G.GAME.hands["reverse_parity"].mult,
                G.GAME.hands["reverse_parity"].chips,
                colours = {(G.GAME.hands["reverse_parity"].level == 1 and G.C.UI.TEXT_DARK or G.C.HAND_LEVELS[math.min(7, G.GAME.hands["reverse_parity"].level)])}
            }
        }
    end,
    can_use = function(self, card)
        return true
    end,
}

SMODS.Consumable{
    key = "aquarius",
    set = "Zodiac",
    atlas = "Reverse_Tarots",
    pos = {x = 0, y = 3},
    soul_pos = {x = 0, y = 4},
    loc_txt = {
        name = "Aquarius",
        text = {
            "Adds one copy of",
            "selected card to hand"
        }
    },
    config = { context =
        {
            number_cards = 1
        }
    },
    loc_vars = function(self, info_queue, center)
        --print(center.ability.name)
    end,
    can_use = function(self, card)
        if G and G.hand then
            if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= 1 then
                return true
            end
        end
    end,
    use = function(self, card, area, copier)
    end
}

SMODS.Consumable{
    key = "pisces",
    set = "Zodiac",
    atlas = "Reverse_Tarots",
    pos = {x = 1, y = 3},
    soul_pos = {x = 1, y = 4},
    loc_txt = {
        name = "Pisces",
        text = {
            "Adds one copy of",
            "selected card to hand"
        }
    },
    config = { context =
        {
            number_cards = 1
        }
    },
    loc_vars = function(self, info_queue, center)
        --print(center.ability.name)
    end,
    can_use = function(self, card)
        if G and G.hand then
            if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= 1 then
                return true
            end
        end
    end,
    use = function(self, card, area, copier)
    end
}

SMODS.Consumable{
    key = "aries",
    set = "Zodiac",
    atlas = "Reverse_Tarots",
    pos = {x = 2, y = 3},
    soul_pos = {x = 2, y = 4},
    loc_txt = {
        name = "Aries",
        text = {
            "Adds one copy of",
            "selected card to hand"
        }
    },
    config = { context =
        {
            number_cards = 1
        }
    },
    loc_vars = function(self, info_queue, center)
        --print(center.ability.name)
    end,
    can_use = function(self, card)
        if G and G.hand then
            if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= 1 then
                return true
            end
        end
    end,
    use = function(self, card, area, copier)
    end
}

SMODS.Consumable{
    key = "taurus",
    set = "Zodiac",
    atlas = "Reverse_Tarots",
    pos = {x = 3, y = 3},
    soul_pos = {x = 3, y = 4},
    loc_txt = {
        name = "Taurus",
        text = {
            "Adds one copy of",
            "selected card to hand"
        }
    },
    config = { context =
        {
            number_cards = 1
        }
    },
    loc_vars = function(self, info_queue, center)
        --print(center.ability.name)
    end,
    can_use = function(self, card)
        if G and G.hand then
            if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= 1 then
                return true
            end
        end
    end,
    use = function(self, card, area, copier)
    end
}

SMODS.Consumable{
    key = "gemini",
    set = "Zodiac",
    atlas = "Reverse_Tarots",
    pos = {x = 4, y = 3},
    soul_pos = {x = 4, y = 4},
    loc_txt = {
        name = "Gemini",
        text = {
            "Adds one copy of",
            "selected card to hand"
        }
    },
    config = { context =
        {
            number_cards = 1
        }
    },
    loc_vars = function(self, info_queue, center)
        --print(center.ability.name)
    end,
    can_use = function(self, card)
        if G and G.hand then
            if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= 1 then
                return true
            end
        end
    end,
    use = function(self, card, area, copier)
    end
}

SMODS.Consumable{
    key = "cancer",
    set = "Zodiac",
    atlas = "Reverse_Tarots",
    pos = {x = 5, y = 3},
    soul_pos = {x = 5, y = 4},
    loc_txt = {
        name = "Cancer",
        text = {
            "Adds one copy of",
            "selected card to hand"
        }
    },
    config = { context =
        {
            number_cards = 1
        }
    },
    loc_vars = function(self, info_queue, center)
        --print(center.ability.name)
    end,
    can_use = function(self, card)
        if G and G.hand then
            if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= 1 then
                return true
            end
        end
    end,
    use = function(self, card, area, copier)
    end
}

SMODS.Consumable{
    key = "leo",
    set = "Zodiac",
    atlas = "Reverse_Tarots",
    pos = {x = 6, y = 3},
    soul_pos = {x = 6, y = 4},
    loc_txt = {
        name = "Leo",
        text = {
            "Adds one copy of",
            "selected card to hand"
        }
    },
    config = { context =
        {
            number_cards = 1
        }
    },
    loc_vars = function(self, info_queue, center)
        --print(center.ability.name)
    end,
    can_use = function(self, card)
        if G and G.hand then
            if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= 1 then
                return true
            end
        end
    end,
    use = function(self, card, area, copier)
    end
}

SMODS.Consumable{
    key = "virgo",
    set = "Zodiac",
    atlas = "Reverse_Tarots",
    pos = {x = 7, y = 3},
    soul_pos = {x = 7, y = 4},
    loc_txt = {
        name = "Virgo",
        text = {
            "Adds one copy of",
            "selected card to hand"
        }
    },
    config = { context =
        {
            number_cards = 1
        }
    },
    loc_vars = function(self, info_queue, center)
        --print(center.ability.name)
    end,
    can_use = function(self, card)
        if G and G.hand then
            if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= 1 then
                return true
            end
        end
    end,
    use = function(self, card, area, copier)
    end
}

SMODS.Consumable{
    key = "libra",
    set = "Zodiac",
    atlas = "Reverse_Tarots",
    pos = {x = 8, y = 3},
    soul_pos = {x = 8, y = 4},
    loc_txt = {
        name = "Libra",
        text = {
            "Adds one copy of",
            "selected card to hand"
        }
    },
    config = { context =
        {
            number_cards = 1
        }
    },
    loc_vars = function(self, info_queue, center)
        --print(center.ability.name)
    end,
    can_use = function(self, card)
        if G and G.hand then
            if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= 1 then
                return true
            end
        end
    end,
    use = function(self, card, area, copier)
    end
}

SMODS.Consumable{
    key = "scorpio",
    set = "Zodiac",
    atlas = "Reverse_Tarots",
    pos = {x = 9, y = 3},
    soul_pos = {x = 9, y = 4},
    loc_txt = {
        name = "Scorpio",
        text = {
            "Adds one copy of",
            "selected card to hand"
        }
    },
    config = { context =
        {
            number_cards = 1
        }
    },
    loc_vars = function(self, info_queue, center)
        --print(center.ability.name)
    end,
    can_use = function(self, card)
        if G and G.hand then
            if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= 1 then
                return true
            end
        end
    end,
    use = function(self, card, area, copier)
    end
}

SMODS.Consumable{
    key = "sagittarius",
    set = "Zodiac",
    atlas = "Reverse_Tarots",
    pos = {x = 10, y = 3},
    soul_pos = {x = 10, y = 4},
    loc_txt = {
        name = "Sagittarius",
        text = {
            "Adds one copy of",
            "selected card to hand"
        }
    },
    config = { context =
        {
            number_cards = 1
        }
    },
    loc_vars = function(self, info_queue, center)
        --print(center.ability.name)
    end,
    can_use = function(self, card)
        if G and G.hand then
            if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= 1 then
                return true
            end
        end
    end,
    use = function(self, card, area, copier)
    end
}

SMODS.Consumable{
    key = "capricorn",
    set = "Zodiac",
    atlas = "Reverse_Tarots",
    pos = {x = 11, y = 3},
    soul_pos = {x = 11, y = 4},
    loc_txt = {
        name = "Capricorn",
        text = {
            "Adds one copy of",
            "selected card to hand"
        }
    },
    config = { context =
        {
            number_cards = 1
        }
    },
    loc_vars = function(self, info_queue, center)
        --print(center.ability.name)
    end,
    can_use = function(self, card)
        if G and G.hand then
            if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= 1 then
                return true
            end
        end
    end,
    use = function(self, card, area, copier)
    end
}

SMODS.Consumable{
    key = "ophiuchus",
    set = "Zodiac",
    atlas = "Reverse_Tarots",
    pos = {x = 12, y = 3},
    soul_pos = {x = 12, y = 4},
    loc_txt = {
        name = "Ophiuchus",
        text = {
            "Adds one copy of",
            "selected card to hand"
        }
    },
    config = { context =
        {
            number_cards = 1
        }
    },
    loc_vars = function(self, info_queue, center)
        --print(center.ability.name)
    end,
    can_use = function(self, card)
        if G and G.hand then
            if #G.hand.highlighted ~= 0 and #G.hand.highlighted <= 1 then
                return true
            end
        end
    end,
    use = function(self, card, area, copier)
    end
}