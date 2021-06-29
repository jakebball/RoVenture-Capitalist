for _,module in ipairs(script.Parent.Modules.Systems:GetChildren()) do
    require(module)
end