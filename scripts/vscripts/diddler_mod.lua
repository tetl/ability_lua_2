print("Modfile!")

local env = {}

env.OnCreated = function(buff)
  buff:GetParent():SetModelScale(1)
  buff:StartIntervalThink(0.03)
end


env.OnIntervalThink = function(buff)
  local par = buff:GetParent()
  local old = par:GetModelScale()
  set = 1
  set = RandomFloat(1.2,1.4)
  buff:GetParent():SetModelScale(set)
end

env.Data = {
  Properties = {
    GetModifierMoveSpeed_Absolute = 500,
  }
}

env.OnUnitMoved = function(buff)
end

env.OnAttack = function(buff)
end



require("custom")
diddler_mod = LuaModifier("diddler_mod", env)
