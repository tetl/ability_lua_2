
LinkLuaModifier("diddler_mod", LUA_MODIFIER_MOTION_NONE)

local env = {}

env.OnSpellStart = function(ability, caster, target)
  SendToServerConsole("script_reload_code diddler_mod.lua")
  SendToServerConsole("cl_script_reload_code diddler_mod.lua")
  print(caster)
  print(caster:GetClassname())
  caster:AddNewModifier(caster, nil, "diddler_mod", {})
end


env.Data = {
  GetBehavior = DOTA_ABILITY_BEHAVIOR_NO_TARGET,
  GetCooldown = 0,
  GetManaCost = 40
}

require("custom")

diddler = LuaAbility("diddler", env)

