local config = {
    ['Monday'] = 'Alptramun',
    ['Tuesday'] = 'Izcandar_the_Banished',
    ['Friday'] = 'Malofur_Mangrinder',
    ['Thursday'] = 'Maxxenius',
    ['Wednesday'] = 'Malofur_Mangrinder',
    ['Saturday'] = 'Plagueroot',
    ['Sunday'] = 'Izcandar_the_Banished'
}

local spawnByDay = true

local dreamcourts1 = GlobalEvent("DreamCourts1")
function dreamcourts1.onStartup()
    if spawnByDay then
        print('>> [dream courts] loaded: ' .. config[os.date("%A")])
        Game.loadMap('data/world/world_changes/quest/the_dream_courts/' .. config[os.date("%A")] ..'.otbm')
    else
         print('>> dream courts boss: not boss today')
    end
    return true
end
dreamcourts1:register()