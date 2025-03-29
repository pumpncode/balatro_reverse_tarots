SMODS.Challenge{
    key = "trial",
    loc_txt = {
        name = "Trial of the Sword",
    },
    rules = {
        custom = {
            {id = "no_shop_jokers"},
            {id = "reverse_sword_1"},
            {id = "reverse_sword_2"},
        },
        modifiers = {
            {
                id = "joker_slots",
                value = 1
            }
        }
    },
    jokers = {
        {
            id = "j_reverse_goddess_sword",
            eternal = true
        }
    },
    restrictions = {
        banned_cards = {
            {id = "c_judgement"},
            {id = "c_reverse_c_reverse_judgement"},
            {id = "c_wraith"},
            {id = "c_ankh"},
            {id = "c_ectoplasm"},
            {id = "c_soul"},
            {id = "v_blank"},
            {id = "v_antimatter"},
            {
                id = "p_buffoon_normal_1",
                ids = {"p_buffoon_normal_1",
                "p_buffoon_normal_2",
                "p_buffoon_jumbo_1",
                "p_buffoon_mega_1"}
            }
        },
        banned_other = {
            {
                id = "bl_final_heart",
                type = "blind"
            },
            {
                id = "bl_final_leaf",
                type = "blind"
            },
            {
                id = "bl_final_acorn",
                type = "blind"
            },
            {
                id = "bl_reverse_final_beast",
                type = "blind"
            },
        }
    }
}