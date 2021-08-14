for _,v in ipairs(script.Parent.Systems:GetChildren()) do
    if v.ClassName == "ModuleScript" then
        require(v)
    end
end