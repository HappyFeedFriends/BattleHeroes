require('BattleHeroesInit')
function Precache( context )
  PrecacheResource("particle", "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf", context)
  PrecacheResource("particle_folder", "particles/test_particle", context)
  PrecacheResource("model_folder", "particles/heroes", context)
  PrecacheResource("model", "particles/heroes/viper/viper.vmdl", context)
  PrecacheResource( "particle_folder", "particles/battle_heroes", context )
  PrecacheModel("models/heroes/viper/viper.vmdl", context)
  PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_gyrocopter.vsndevts", context)
end

function Activate()
  GameRules.GameMode = BattleHeroes()
  GameRules.GameMode:InitBattleHeroes()
end

LinkLuaModifier ("modifier_desolator_bh_debuff", "items/item_desolator", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skadi_bh_debuff", "items/item_skadi", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_hero_out_of_game", "modifiers/modifiers", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_custom_mechanics", "modifiers/modifier_custom_mechanics", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_magic_immune_bh", "modifiers/modifiers", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_true_strike_bh", "modifiers/modifiers", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_movespeed_slow_bh", "modifiers/modifiers", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_check_duel", "modifiers/modifiers", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_invulnerability_bh", "modifiers/modifiers", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_max_speed_mutation_bh", "modifiers/modifiers", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_movespeed_slow_procentage_bh", "modifiers/modifiers", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_no_invis_bh", "modifiers/modifiers", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_creep_attack_speed_bonus", "modifiers/modifiers", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier ("modifier_hearth_bh", "items/hearth_of_tarrasque", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_hearth_bh_buff", "items/hearth_of_tarrasque", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_fountain_protect_bh", "modules/fountain/fountain", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_fountain_protect_bh_aura", "modules/fountain/fountain", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_fountain_protect_bh_aura_enemy", "modules/fountain/fountain", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier ("modifier_fountain_protect_bh_enemy", "modules/fountain/fountain", LUA_MODIFIER_MOTION_NONE)