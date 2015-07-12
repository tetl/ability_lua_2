
--Functions passed (caster, target)
--
if not GameRules then 
  require("vars")
  GameRules = {}
  lab_test = true
end

GameRules.lua_ability = {}

local IsCastEvent = 0
local IsPassthrough = 1
local IsClientSafe = 2

local NO_CLIENT_CODE = false
local CLIENT_CODE = true

local function CastData(ability, b, c, d, e, f, g, h, i, j, k)
  local caster = ability:GetCaster()
  local target = caster and caster:GetCursorCastTarget() or caster:GetCursorPosition()
  return {ability, caster, target, b, c, d, e, f, g, h, i, j, k}
end

local function Passthrough(a,b,c,d,e,f,g,h,i,j,k) -- should see if {...} is safe to use
  return {a,b,c,d,e,f,g,h,i,j,k}
end

local AbilityCalls = {
ProcsMagicStick = {Passthrough, true},
GetManaCost = {Passthrough, true},
OnProjectileHit_ExtraData = {Passthrough, true},
GetCastRange = {Passthrough, true},
GetBehavior = {Passthrough, true},
OnAbilityPhaseStart = {Passthrough, false},
CastFilterResultLocation = {Passthrough, true},
GetAssociatedPrimaryAbilities = {Passthrough, true},
CastFilterResult = {Passthrough, true},
OnUpgrade = {Passthrough, false},
OnStolen = {Passthrough, true},
GetConceptRecipientType = {Passthrough, true},
GetChannelAnimation = {Passthrough, true},
IsHiddenAbilityCastable = {Passthrough, true},
GetCustomCastErrorTarget = {Passthrough, true},
OnSpellStart = {CastData, false},
GetCooldown = {Passthrough, true},
IsStealable = {Passthrough, true},
OnProjectileHit = {Passthrough, false},
OnUnStolen = {Passthrough, true},
GetGoldCost = {Passthrough, true},
OnHeroDiedNearby = {Passthrough, true},
OnHeroCalculateStatBonus = {Passthrough, true},
OnProjectileThink_ExtraData = {Passthrough, true},
SpeakTrigger = {Passthrough, true},
OnToggle = {Passthrough, false},
GetCustomCastErrorLocation = {Passthrough, true},
GetPlaybackRateOverride = {Passthrough, true},
GetCastAnimation = {Passthrough, true},
OnOwnerSpawned = {Passthrough, false},
OnAbilityPhaseInterrupted = {Passthrough, false},
GetChannelTime = {Passthrough, true},
GetIntrinsicModifierName = {Passthrough, true},
OnItemEquipped = {Passthrough, true},
IsHiddenWhenStolen = {Passthrough, true},
OnInventoryContentsChanged = {Passthrough, true},
OnHeroLevelUp = {Passthrough, false},
OnChannelFinish = {Passthrough, false},
OnChannelThink = {Passthrough, false},
IsRefreshable = {Passthrough, true},
CastFilterResultTarget = {Passthrough, true},
OnOwnerDied = {Passthrough, false},
GetChannelledManaCostPerSecond = {Passthrough, true},
OnProjectileThink = {Passthrough, false},
GetAssociatedSecondaryAbilities = {Passthrough, true},
GetCustomCastError = {Passthrough, true},
}

local ModifierCalls = {
IsPurgeException = {Passthrough, true},
GetTexture = {Passthrough, true},
IsAura = {Passthrough, true},
IsHidden = {Passthrough, true},
StatusEffectPriority = {Passthrough, true},
GetAuraRadius = {Passthrough, true},
OnRefresh = {Passthrough, true},
OnIntervalThink = {Passthrough, true},
DestroyOnExpire = {Passthrough, true},
OnDestroy = {Passthrough, true},
GetAuraEntityReject = {Passthrough, true},
OnCreated = {Passthrough, false},
GetAuraSearchFlags = {Passthrough, true},
GetAttributes = {Passthrough, true},
HeroEffectPriority = {Passthrough, true},
IsStunDebuff = {Passthrough, true},
IsPurgable = {Passthrough, true},
RemoveOnDeath = {Passthrough, true},
GetEffectAttachType = {Passthrough, true},
IsDebuff = {Passthrough, true},
IsAuraActiveOnDeath = {Passthrough, true},
GetAuraSearchType = {Passthrough, true},
GetStatusEffectName = {Passthrough, true},
GetAuraSearchTeam = {Passthrough, true},
GetModifierAura = {Passthrough, true},
AllowIllusionDuplicate = {Passthrough, true},
GetHeroEffectName = {Passthrough, true},
GetEffectName = {Passthrough, true},
}

local propertymap = {
 OnAbilityEndChannel = MODIFIER_EVENT_ON_ABILITY_END_CHANNEL, 
 OnAbilityExecuted = MODIFIER_EVENT_ON_ABILITY_EXECUTED, 
 OnAbilityFullyCast = MODIFIER_EVENT_ON_ABILITY_FULLY_CAST, 
 OnAbilityStart = MODIFIER_EVENT_ON_ABILITY_START, 
 OnAttack = MODIFIER_EVENT_ON_ATTACK, 
 OnAttacked = MODIFIER_EVENT_ON_ATTACKED, 
 OnAttackAllied = MODIFIER_EVENT_ON_ATTACK_ALLIED, 
 OnAttackFail = MODIFIER_EVENT_ON_ATTACK_FAIL, 
 OnAttackLanded = MODIFIER_EVENT_ON_ATTACK_LANDED, 
 OnAttackRecord = MODIFIER_EVENT_ON_ATTACK_RECORD, 
 OnAttackStart = MODIFIER_EVENT_ON_ATTACK_START, 
 OnBreakInvisibility = MODIFIER_EVENT_ON_BREAK_INVISIBILITY, 
 OnBuildingKilled = MODIFIER_EVENT_ON_BUILDING_KILLED, 
 OnDeath = MODIFIER_EVENT_ON_DEATH, 
 OnDominated = MODIFIER_EVENT_ON_DOMINATED, 
 OnHealthGained = MODIFIER_EVENT_ON_HEALTH_GAINED, 
 OnHealReceived = MODIFIER_EVENT_ON_HEAL_RECEIVED, 
 OnHeroKilled = MODIFIER_EVENT_ON_HERO_KILLED, 
 OnManaGained = MODIFIER_EVENT_ON_MANA_GAINED, 
 OnModelChanged = MODIFIER_EVENT_ON_MODEL_CHANGED, 
--MODIFIER_EVENT_ON_ORB_EFFECT = 117
 OnOrder = MODIFIER_EVENT_ON_ORDER, 
--MODIFIER_EVENT_ON_PROCESS_UPGRADE = 113
 OnProjectileDodge = MODIFIER_EVENT_ON_PROJECTILE_DODGE, 
--MODIFIER_EVENT_ON_REFRESH = 114
 OnRespawn = MODIFIER_EVENT_ON_RESPAWN, 
 OnSetLocation = MODIFIER_EVENT_ON_SET_LOCATION, 
 OnSpentMana = MODIFIER_EVENT_ON_SPENT_MANA, 
 OnStateChanged = MODIFIER_EVENT_ON_STATE_CHANGED, 
 OnTakeDamage = MODIFIER_EVENT_ON_TAKEDAMAGE, 
 OnTakeDamageKillCredit = MODIFIER_EVENT_ON_TAKEDAMAGE_KILLCREDIT, 
 OnTeleported = MODIFIER_EVENT_ON_TELEPORTED, 
 OnTeleporting = MODIFIER_EVENT_ON_TELEPORTING, 
 OnUnitMoved = MODIFIER_EVENT_ON_UNIT_MOVED, 
--MODIFIER_FUNCTION_INVALID = 255
--MODIFIER_FUNCTION_LAST = 147
 GetModifierAbilityLayout = MODIFIER_PROPERTY_ABILITY_LAYOUT, 
 GetAbsoluteNoDamageMagical = MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL, 
 GetAbsoluteNoDamagePhysical = MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL, 
 GetAbsoluteNoDamagePure = MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE, 
 GetAbsorbSpell = MODIFIER_PROPERTY_ABSORB_SPELL, 
 GetModifierAttackSpeedBonus_Constant = MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT, 
 GetModifierAttackSpeedBonus_Constant_PowerTreads = MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT_POWER_TREADS, 
 GetModifierAttackSpeedBonus_Constant_Secondary = MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT_SECONDARY, 
 GetModifierAttackPointConstant = MODIFIER_PROPERTY_ATTACK_POINT_CONSTANT, 
 GetModifierAttackRangeBonus = MODIFIER_PROPERTY_ATTACK_RANGE_BONUS, 
 GetModifierAvoidDamage = MODIFIER_PROPERTY_AVOID_DAMAGE, 
 GetModifierAvoidSpell = MODIFIER_PROPERTY_AVOID_SPELL, 
 GetModifierBaseAttack_BonusDamage = MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE, 
 GetModifierBaseDamageOutgoing_Percentage = MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE, 
 GetModifierBaseDamageOutgoing_PercentageUnique = MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE_UNIQUE, 
 GetModifierBaseAttackTimeConstant = MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT, 
 GetModifierBaseRegen = MODIFIER_PROPERTY_BASE_MANA_REGEN, 
 GetBonusDayVision = MODIFIER_PROPERTY_BONUS_DAY_VISION, 
 GetBonusNightVision = MODIFIER_PROPERTY_BONUS_NIGHT_VISION, 
 GetBonusNightVisionUnique = MODIFIER_PROPERTY_BONUS_NIGHT_VISION_UNIQUE, 
 GetBonusVisionPercentage = MODIFIER_PROPERTY_BONUS_VISION_PERCENTAGE, 
 GetModifierBountyCreepMultiplier = MODIFIER_PROPERTY_BOUNTY_CREEP_MULTIPLIER, 
 GetModifierBountyOtherMultiplier = MODIFIER_PROPERTY_BOUNTY_OTHER_MULTIPLIER, 
 GetModifierPercentageCasttime = MODIFIER_PROPERTY_CASTTIME_PERCENTAGE, 
 GetModifierChangeAbilityValue = MODIFIER_PROPERTY_CHANGE_ABILITY_VALUE, 
 GetModifierPercentageCooldown = MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE, 
 GetModifierCooldownReduction_Constant = MODIFIER_PROPERTY_COOLDOWN_REDUCTION_CONSTANT, 
 GetModifierDamageOutgoing_Percentage = MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE, 
 GetModifierDamageOutgoing_Percentage_Illusion = MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE_ILLUSION, 
 GetModifierConstantDeathGoldCost = MODIFIER_PROPERTY_DEATHGOLDCOST, 
 GetDisableAutoAttack = MODIFIER_PROPERTY_DISABLE_AUTOATTACK, 
 GetDisableHealing = MODIFIER_PROPERTY_DISABLE_HEALING, 
 GetModifierDisableTurning = MODIFIER_PROPERTY_DISABLE_TURNING, 
 GetModifierEvasion_Constant = MODIFIER_PROPERTY_EVASION_CONSTANT, 
 GetModifierExtraHealthBonus = MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS, 
 GetModifierExtraHealthPercentage = MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE, 
 GetModifierExtraManaBonus = MODIFIER_PROPERTY_EXTRA_MANA_BONUS, 
 GetModifierExtraStrengthBonus = MODIFIER_PROPERTY_EXTRA_STRENGTH_BONUS, 
 GetFixedDayVision = MODIFIER_PROPERTY_FIXED_DAY_VISION, 
 GetFixedNightVision = MODIFIER_PROPERTY_FIXED_NIGHT_VISION, 
 GetForceDrawOnMinimap = MODIFIER_PROPERTY_FORCE_DRAW_MINIMAP, 
 GetModifierHealthBonus = MODIFIER_PROPERTY_HEALTH_BONUS, 
 GetModifierConstantHealthRegen = MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT, 
 GetModifierHealthRegenPercentage = MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE, 
 GetModifierIgnoreCastAngle = MODIFIER_PROPERTY_IGNORE_CAST_ANGLE, 
 GetModifierIllusionLabel = MODIFIER_PROPERTY_ILLUSION_LABEL, 
 GetModifierIncomingDamage_Percentage = MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE, 
 GetModifierIncomingPhysicalDamage_Percentage = MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE, 
 GetModifierIncomingSpellDamageConstant = MODIFIER_PROPERTY_INCOMING_SPELL_DAMAGE_CONSTANT, 
 GetModifierInvisibilityLevel = MODIFIER_PROPERTY_INVISIBILITY_LEVEL, 
 GetIsIllusion = MODIFIER_PROPERTY_IS_ILLUSION, 
 GetModifierScepter = MODIFIER_PROPERTY_IS_SCEPTER, 
 GetUnitLifetimeFraction = MODIFIER_PROPERTY_LIFETIME_FRACTION, 
 GetModifierMagicalResistanceBonus = MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS, 
 GetModifierMagicalResistanceDecrepifyUnique = MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DECREPIFY_UNIQUE, 
 GetModifierMagicalResistanceItemUnique = MODIFIER_PROPERTY_MAGICAL_RESISTANCE_ITEM_UNIQUE, 
 GetModifierPercentageManacost = MODIFIER_PROPERTY_MANACOST_PERCENTAGE, 
 GetModifierManaBonus = MODIFIER_PROPERTY_MANA_BONUS, 
 GetModifierConstantManaRegen = MODIFIER_PROPERTY_MANA_REGEN_CONSTANT, 
 GetModifierConstantManaRegenUnique = MODIFIER_PROPERTY_MANA_REGEN_CONSTANT_UNIQUE, 
 GetModifierPercentageManaRegen = MODIFIER_PROPERTY_MANA_REGEN_PERCENTAGE, 
 GetModifierTotalPercentageManaRegen = MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE, 
 GetMinHealth = MODIFIER_PROPERTY_MIN_HEALTH, 
 GetModifierMiss_Percentage = MODIFIER_PROPERTY_MISS_PERCENTAGE, 
 GetModifierModelChange = MODIFIER_PROPERTY_MODEL_CHANGE, 
 GetModifierModelScale = MODIFIER_PROPERTY_MODEL_SCALE, 
 GetModifierMoveSpeed_Absolute = MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE, 
 GetModifierMoveSpeed_AbsoluteMin = MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN, 
 GetModifierMoveSpeedOverride = MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE, 
 GetModifierMoveSpeedBonus_Constant = MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT, 
 GetModifierMoveSpeedBonus_Percentage = MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE, 
 GetModifierMoveSpeedBonus_Percentage_Unique = MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE_UNIQUE, 
 GetModifierMoveSpeedBonus_Special_Boots = MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE, 
 GetModifierMoveSpeed_Limit = MODIFIER_PROPERTY_MOVESPEED_LIMIT, 
 GetModifierMoveSpeed_Max = MODIFIER_PROPERTY_MOVESPEED_MAX, 
 GetOverrideAnimation = MODIFIER_PROPERTY_OVERRIDE_ANIMATION, 
 GetOverrideAnimationRate = MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE, 
 GetOverrideAnimationWeight = MODIFIER_PROPERTY_OVERRIDE_ANIMATION_WEIGHT, 
 GetOverrideAttackMagical = MODIFIER_PROPERTY_OVERRIDE_ATTACK_MAGICAL, 
 GetModifierPersistentInvisibility = MODIFIER_PROPERTY_PERSISTENT_INVISIBILITY, 
 GetModifierPhysicalArmorBonus = MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS, 
 GetModifierPhysicalArmorBonusIllusions = MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_ILLUSIONS, 
 GetModifierPhysicalArmorBonusUnique = MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE, 
 GetModifierPhysicalArmorBonusUniqueActive = MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE_ACTIVE, 
 GetModifierPhysical_ConstantBlock = MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK, 
 GetModifierPreAttack_BonusDamage = MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE, 
 GetModifierPreAttack_BonusDamagePostCrit = MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE_POST_CRIT, 
 GetModifierPreAttack_CriticalStrike = MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE, 
 GetModifierPreAttack = MODIFIER_PROPERTY_PRE_ATTACK, 
 GetModifierProcAttack_BonusDamage_Magical = MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_MAGICAL, 
 GetModifierProcAttack_BonusDamage_Physical = MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL, 
 GetModifierProcAttack_BonusDamage_Pure = MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE, 
 GetModifierProcAttack_Feedback = MODIFIER_PROPERTY_PROCATTACK_FEEDBACK, 
 GetModifierProjectileSpeedBonus = MODIFIER_PROPERTY_PROJECTILE_SPEED_BONUS, 
 GetModifierProvidesFOWVision = MODIFIER_PROPERTY_PROVIDES_FOW_POSITION, 
 GetReflectSpell = MODIFIER_PROPERTY_REFLECT_SPELL, 
 ReincarnateTime = MODIFIER_PROPERTY_REINCARNATION, 
 GetModifierConstantRespawnTime = MODIFIER_PROPERTY_RESPAWNTIME, 
 GetModifierPercentageRespawnTime = MODIFIER_PROPERTY_RESPAWNTIME_PERCENTAGE, 
 GetModifierStackingRespawnTime = MODIFIER_PROPERTY_RESPAWNTIME_STACKING, 
 GetModifierSpellsRequireHP = MODIFIER_PROPERTY_SPELLS_REQUIRE_HP, 
 GetModifierBonusStats_Agility = MODIFIER_PROPERTY_STATS_AGILITY_BONUS, 
 GetModifierBonusStats_Intellect = MODIFIER_PROPERTY_STATS_INTELLECT_BONUS, 
 GetModifierBonusStats_Strength = MODIFIER_PROPERTY_STATS_STRENGTH_BONUS, 
 GetModifierSuperIllusion = MODIFIER_PROPERTY_SUPER_ILLUSION, 
 OnTooltip = MODIFIER_PROPERTY_TOOLTIP, 
 GetModifierTotalDamageOutgoing_Percentage = MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE, 
 GetModifierTotal_ConstantBlock = MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK, 
 GetModifierPhysical_ConstantBlockUnavoidablePreArmor = MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK_UNAVOIDABLE_PRE_ARMOR, 
 GetActivityTranslationModifiers = MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS, 
 GetAttackSound = MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND, 
 GetModifierTurnRate_Percentage = MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE, 
 GetModifierUnitStatsNeedsRefresh = MODIFIER_PROPERTY_UNIT_STATS_NEEDS_REFRESH, 
}

local function insideout(table)
  local ret = {}
  for k,v in pairs(table) do
    ret[v] = k
  end
  return ret
end

local propertyidmap = insideout(propertymap)

local function HandleCheckState(env, valve, config)
  local statemap = config.States
  if not statemap then return valve end
  valve.CheckState = function(ability)
    local states = {}
    for k,v in pairs(statemap) do
     states[k] = (type(v) ~= "function") and v or v()
    end
    return states
  end
  return valve
end

local function HandleDeclarations(env, valve, config)
  local constants = config.Properties
  local all = {}
  for function_name, id in pairs(propertymap) do
    local fun = env[function_name]
    if fun then
      valve[function_name] = fun
      all[#all+1] = id
    end
  end

  if not constants then 
    valve.DeclareFunctions = function()
     return all
    end
    return valve 
  end

  for function_name, data in pairs(constants) do
    local id = propertymap[function_name]
    all[#all+1] = id
    valve[function_name] = function(...) 
      local res = (type(data) ~= "function") and data or data(...) 
      return res
    end
  end
  
  valve.DeclareFunctions = function()
    for k,v in pairs(all) do print(k,":",v) end
    return all
  end

  return valve
end

local function LuaThing(env, config, funcs) 
  local valve_config = {}
  for function_name,data_for_function in pairs(funcs) do
    --print(function_name)
    local configed = config[function_name]
    if not configed then
      local fun = env[function_name]
      if fun then
        local arg_filter, client_safe = data_for_function[1], data_for_function[2]
        valve_config[function_name] = function(...) 
            local am_server = IsServer()
            if client_safe or am_server then
              return fun(unpack(arg_filter(...))) 
            else  
              local client_fun = env[function_name .. "_Client"]
              if client_fun then
                return client_fun(unpack(Passthrough(...))) 
              end
            end
          end
        end
      else valve_config[function_name] = function(...) 
        return type(configed ~= "function") and configed or configed(...) 
      end 
      end
    end
  return valve_config
end

local function tableblit(target, source)
  for k,v in pairs(source) do
    target[k] = v
  end
end

function LuaAbility(name, env)
  local config = env.Data
  local valve = LuaThing(env, config, AbilityCalls)
  local stashed = GameRules.lua_ability[name]
  if stashed then tableblit(stashed, valve) 
  else GameRules.lua_ability[name] = valve
  end
  return valve
end

function LuaModifier(name, env)
  local config = env.Data
  valve = LuaThing(env, config, ModifierCalls)  
  valve = HandleCheckState(env, valve, config)
  valve = HandleDeclarations(env, valve, config)
  local stashed = GameRules.lua_ability[name]
  if stashed then tableblit(stashed, valve) 
  else GameRules.lua_ability[name] = valve
  end
  return valve
end

--basic tests

if lab_test then
  function IsServer() return true end

  local fake_guy = {
    GetCursorCastTarget = function(self) return self end,
    GetClassname = function() return "Guy" end
  }
  local fake_abil = {
    GetCaster = function(self) return fake_guy end,
    GetClassname = function() return "Blast" end
  }

  local test = {}
  test.OnSpellStart = function(ability, caster, target)
   print("Server OSS!")
   print("Got", ability, caster, target )
   print(ability:GetClassname(), caster:GetClassname(), target:GetClassname())
  end
  test.OnSpellStart_Client = function(a,b,c) print("Client OSS!", a, b, c) end
  test.GetBehavior = function(a,b,c) print("Get Behavior!", a, b, c) end
  test.Data = {
    GetCooldown = "Bob"
  }

  valve = LuaAbility("test", test)
  print("Done making")
  for k,v in pairs(valve) do print(k,":",v) end
  valve.OnSpellStart(fake_abil)
  valve.GetBehavior(fake_abil)
  IsServer = function() return false end
  valve.OnSpellStart(fake_abil)
  valve.GetBehavior(fake_abil)
  print(valve.GetCooldown(fake_abil))
  print("Done")

  IsServer = function() return true end
  
  local fake_mod = {}

  local test_mod = {}
  test_mod.OnCreated = function(mod)
    print("Server mod!")
    print(mod)  
  end
  test_mod.OnCreated_Client = function(mod)
    print("Client mod!")
  end
  local function statefunc() print("HEY"); return false end
  test_mod.Data = {}
  test_mod.Data.States = {
    [4] = true,
    [5] = statefunc
  }
  test_mod.Data.Properties = {
    [9] = 5
  }
  test_mod.GetMinHealth = function(mod)
    print("GMH")
    return 900
  end
  local valve_mod = LuaModifier("test_mod", test_mod) 
  valve_mod.OnCreated(test_mod)
  print("States:")
  for k,v in pairs(valve_mod.CheckState()) do
    print(k,":",v)
  end
  print("Props:")
  for k,v in pairs(valve_mod.DeclareFunctions()) do
    print(k,":",v)
  end
  print(valve_mod.GetModifierPersistentInvisibility())
end


