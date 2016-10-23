--[[
--
--    Outfit defines for the equipping script
--
-- This contains defines to help simplify the addition of new outfits for
--  different ships.
--]]



--[[
-- @brief Merges tables together
--]]
function table_merge( t, ... )
   args = {...}
   for ak, av in ipairs( args ) do
      for k,v in ipairs(av) do
         t[ #t+1 ] = v
      end
   end
   return t
end


--[[
-- Forward mounts - civilians
--]]
function equip_defaultForwardLow ()
   return { "Light Ion Gun", "Laser Cannon MK1", "Mass Driver" }
end
function equip_defaultForwardMed ()
   return { "Ion Gun", "Laser Cannon MK2" }
end
function equip_defaultForwardHigh ()
   return { "Ion Gun", "Laser Cannon MK3" }
end
function equip_defaultForward ()
   return {equip_defaultForwardLow(),equip_defaultForwardMed(),equip_defaultForwardHigh()}
end

--[[
-- Forward mounts - military
--]]
function equip_defaultForwardMilLow ()
   return { "Ion Gun", "Laser Cannon MK2", "Mass Driver" }
end
function equip_defaultForwardMilMed ()
   return { "Ion Gun", "Laser Cannon MK3", "Upgraded Mass Driver" }
end
function equip_defaultForwardMilHigh ()
   return { "Laser Cannon MK3", "Superior Mass Driver" }
end
function equip_defaultForwardMil ()
   return {equip_defaultForwardMilLow(),equip_defaultForwardMilMed(),equip_defaultForwardMilHigh()}
end


--[[
-- Forward mounts - pirates
-- Uses also barbarian and Imperial weapons
--]]
function equip_defaultForwardPiratesLow ()
   return { "Laser Cannon MK2", "Laser Cannon MK3", "Mass Driver", "Light EMP Gun" }
end
function equip_defaultForwardPiratesMed ()
   return { "Plasma Blaster MK3", "Upgraded Mass Driver", "EMP Gun" }
end
function equip_defaultForwardPiratesHigh ()
   return { "Plasma Cannon MK2", "Powerful EMP Gun", "Heavy Shredder" }
end
function equip_defaultForwardPirates ()
   return {equip_defaultForwardPiratesLow(),equip_defaultForwardPiratesMed(),equip_defaultForwardPiratesHigh()}
end


--[[
-- Turret mounts - civilian
--]]
function equip_defaultTurretLow ()
   return { "Laser Turret MK1" }
end
function equip_defaultTurretMed ()
   return { "Laser Turret MK2", "Ion Turret", "Mass Driver Turret" }
end
function equip_defaultTurretHigh ()
   return { "Laser Turret MK3", "Upgraded Mass Driver Turret" }
end
function equip_defaultTurrets()
   return {equip_defaultTurretLow(),equip_defaultTurretMed(),equip_defaultTurretHigh()}
end


--[[
-- Turret mounts - military
--]]
function equip_defaultTurretMilLow ()
   return { "Laser Turret MK2", "Ion Turret", "Mass Driver Turret" }
end
function equip_defaultTurretMilMed ()
   return { "Laser Turret MK3", "Upgraded Mass Driver Turret", "Turreted Javelin Tubes" }
end
function equip_defaultTurretMilHigh ()
   return { "Laser Turret MK3", "Upgraded Mass Driver Turret", "Turreted Javelin Tubes" }
end
function equip_defaultTurretsMil()
   return {equip_defaultTurretMilLow(),equip_defaultTurretMilMed(),equip_defaultTurretMilHigh()}
end

--[[
-- Turret mounts - pirates
--]]
function equip_defaultTurretPiratesLow ()
   return { "Laser Turret MK3", "Mass Driver Turret", "Light EMP Turret" }
end
function equip_defaultTurretPiratesMed ()
   return { "Plasma Cannon Turret", "Upgraded Mass Driver Turret", "Turreted Javelin Tubes", "EMP Turret" }
end
function equip_defaultTurretPiratesHigh ()
   return { "Plasma Cannon Turret", "Heavy Shredder Turret", "Turreted Javelin Tubes", "Powerful EMP Turret" }
end
function equip_defaultTurretsPirates()
   return {equip_defaultTurretPiratesLow(),equip_defaultTurretPiratesMed(),equip_defaultTurretPiratesHigh()}
end



--[[
-- Secondary weapons
--]]
function equip_defaultSecondaryLow ()
   return { "Javelin Tube" }
end
function equip_defaultSecondaryMed ()
   return { "Javelin Tube", "Hunter Launcher" }
end
function equip_defaultSecondaryHigh ()
   return { "Hunter Launcher", "Upgraded Hunter Launcher" }
end
function equip_defaultSecondary()
   return {equip_defaultSecondaryLow(),equip_defaultSecondaryMed(),equip_defaultSecondaryHigh()}
end


--[[
-- Secondary weapons - pirates
--]]
function equip_defaultSecondaryPiratesLow ()
   return { "Javelin Tube" }
end
function equip_defaultSecondaryPiratesMed ()
   return { "Javelin Tube", "Hunter Launcher", "EMP Grenade Launcher" }
end
function equip_defaultSecondaryPiratesHigh ()
   return { "Hunter Launcher", "Upgraded Hunter Launcher", "EMP Grenade Launcher" }
end
function equip_defaultSecondaryPirates()
   return {equip_defaultSecondaryPiratesLow(),equip_defaultSecondaryPiratesMed(),equip_defaultSecondaryPiratesHigh()}
end





--[[
-- Forward mounts - Imperial Navy
--]]
function equip_defaultForwardEmpireLow ()
   return { "Plasma Blaster MK1", "Plasma Blaster MK2" }
end
function equip_defaultForwardEmpireMed ()
   return { "Plasma Blaster MK3", "Plasma Cannon MK1", "Plasma Cannon MK2" }
end
function equip_defaultForwardEmpireHigh ()
   return { "Ram Beam", "Plasma Cannon MK3" }
end
function equip_defaultForwardEmpire ()
   return {equip_defaultForwardEmpireLow(),equip_defaultForwardEmpireMed(),equip_defaultForwardEmpireHigh()}
end

--[[
-- Turret mounts - Imperial Navy
--]]
function equip_defaultTurretEmpireLow ()
   return { "Plasma Turret" }
end
function equip_defaultTurretEmpireMed ()
   return { "Plasma Cannon Turret" }
end
function equip_defaultTurretEmpireHigh ()
   return { "Beam Turret", "Turreted Marara Launcher", "Heavy Plasma Turret" }
end
function equip_defaultTurretsEmpire()
   return {equip_defaultTurretEmpireLow(),equip_defaultTurretEmpireMed(),equip_defaultTurretEmpireHigh()}
end


--[[
-- Secondary weapons - Imperial Navy
--]]
function equip_defaultSecondaryEmpireLow ()
   return { "Marara Light Launcher" }
end
function equip_defaultSecondaryEmpireMed ()
   return { "Marara Launcher", "Light Narval Torpedo Tube" }
end
function equip_defaultSecondaryEmpireHigh ()
   return { "Marara Launcher", "Narval Torpedo Tube" }
end
function equip_defaultSecondaryEmpire()
   return {equip_defaultSecondaryEmpireLow(),equip_defaultSecondaryEmpireMed(),equip_defaultSecondaryEmpireHigh()}
end



--[[
-- Forward mounts - Royal Ixum Navy
--]]
function equip_defaultForwardRoyalIxumLow ()
   return { "Ixum Laser Cannon MK1", "Ixum Laser Cannon MK2" }
end
function equip_defaultForwardRoyalIxumMed ()
   return { "Ixum Laser Cannon MK3" }
end
function equip_defaultForwardRoyalIxumHigh ()
   return { "Ixum Laser Cannon MK3" }
end
function equip_defaultForwardRoyalIxum ()
   return {equip_defaultForwardRoyalIxumLow(),equip_defaultForwardRoyalIxumMed(),equip_defaultForwardRoyalIxumHigh()}
end

--[[
-- Turret mounts - Royal Ixum Navy
--]]
function equip_defaultTurretRoyalIxumLow ()
   return { "Ixum Laser Turret MK1" }
end
function equip_defaultTurretRoyalIxumMed ()
   return { "Ixum Laser Turret MK2" }
end
function equip_defaultTurretRoyalIxumHigh ()
   return { "Ixum Laser Turret MK3" }
end
function equip_defaultTurretsRoyalIxum()
   return {equip_defaultTurretRoyalIxumLow(),equip_defaultTurretRoyalIxumMed(),equip_defaultTurretRoyalIxumHigh()}
end


--[[
-- Secondary weapons - Royal Ixum Navy
--]]
function equip_defaultSecondaryRoyalIxumLow ()
   return { "Hunter Launcher" }
end
function equip_defaultSecondaryRoyalIxumMed ()
   return { "Hunter Launcher", "Upgraded Hunter Launcher" }
end
function equip_defaultSecondaryRoyalIxumHigh ()
   return { "Upgraded Hunter Launcher" }
end
function equip_defaultSecondaryRoyalIxum()
   return {equip_defaultSecondaryRoyalIxumLow(),equip_defaultSecondaryRoyalIxumMed(),equip_defaultSecondaryRoyalIxumHigh()}
end




--[[
-- Forward mounts - Ardar Navy
--]]
function equip_defaultForwardArdarLow ()
   return { "Ion Cannon I", "Neutron Disruptor", "Improved Neutron Disruptor" }
end
function equip_defaultForwardArdarMed ()
   return { "Ion Cannon II", "Ion Cannon III", "Heavy Neutron Disruptor" }
end
function equip_defaultForwardArdarHigh ()
   return { "Ion Cannon III", "Heavy Neutron Disruptor"  }
end
function equip_defaultForwardArdar ()
   return {equip_defaultForwardArdarLow(),equip_defaultForwardArdarMed(),equip_defaultForwardArdarHigh()}
end

--[[
-- Turret mounts - Ardar Navy
--]]
function equip_defaultTurretArdarLow ()
   return { "Laser Turret MK3"  }
end
function equip_defaultTurretArdarMed ()
   return { "Ion Cannon Turret", "Turreted Neutron Disruptor"  }
end
function equip_defaultTurretArdarHigh ()
   return { "Heavy Ion Cannon Turret", "Turreted Heavy Neutron Disruptor"  }
end
function equip_defaultTurretsArdar()
   return {equip_defaultTurretArdarLow(),equip_defaultTurretArdarMed(),equip_defaultTurretArdarHigh()}
end


--[[
-- Secondary weapons - Ardar Navy
--]]
function equip_defaultSecondaryArdarLow ()
   return {  "Upgraded Hunter Launcher" }
end
function equip_defaultSecondaryArdarMed ()
   return { "Breakshield Lance", "Telchan Torpedo Tube", "Yrioch Launcher"  }
end
function equip_defaultSecondaryArdarHigh ()
   return { "Shattershield Lance", "Telchan Heavy Tube", "Yrioch Heavy Launcher"  }
end
function equip_defaultSecondaryArdar()
   return {equip_defaultSecondaryArdarLow(),equip_defaultSecondaryArdarMed(),equip_defaultSecondaryArdarHigh()}
end




--[[
-- Forward mounts - Holy Flame Navy
--]]
function equip_defaultForwardHolyFlameLow ()
   return { "Holy Flame Storm" }
end
function equip_defaultForwdarHolyFlameMed ()
   return { "Holy Flame Hurricane" }
end
function equip_defaultForwdarHolyFlameHigh ()
   return { "Holy Flame Hurricane"  }
end
function equip_defaultForwardHolyFlame ()
   return {equip_defaultForwardHolyFlameLow(),equip_defaultForwdarHolyFlameMed(),equip_defaultForwdarHolyFlameHigh()}
end

--[[
-- Turret mounts - Holy Flame Navy
--]]
function equip_defaultTurretHolyFlameLow ()
   return { "Laser Turret MK3"  }
end
function equip_defaultTurretHolyFlameMed ()
   return { "Turreted Hurricane"  }
end
function equip_defaultTurretHolyFlameHigh ()
   return { "Turreted Hurricane"  }
end
function equip_defaultTurretsHolyFlame()
   return {equip_defaultTurretHolyFlameLow(),equip_defaultTurretHolyFlameMed(),equip_defaultTurretHolyFlameHigh()}
end


--[[
-- Secondary weapons - Holy Flame Navy
--]]
function equip_defaultSecondaryHolyFlameLow ()
   return {  "Javelin Tube", "Hunter Launcher" }
end
function equip_defaultSecondaryHolyFlameMed ()
   return {  "Upgraded Hunter Launcher" }
end
function equip_defaultSecondaryHolyFlameHigh ()
   return { "Upgraded Hunter Launcher"  }
end
function equip_defaultSecondaryHolyFlame()
   return {equip_defaultSecondaryHolyFlameLow(),equip_defaultSecondaryHolyFlameMed(),equip_defaultSecondaryHolyFlameHigh()}
end






--[[
-- Forward mounts - Betelgeuse Navy
--]]
function equip_defaultForwardBetelgeuseLow ()
   return { "Railgun", "Laser Cannon MK2" }
end
function equip_defaultForwdarBetelgeuseMed ()
   return { "Medium Railgun", "Laser Cannon MK3" }
end
function equip_defaultForwdarBetelgeuseHigh ()
   return { "Heavy Railgun"  }
end
function equip_defaultForwardBetelgeuse ()
   return {equip_defaultForwardBetelgeuseLow(),equip_defaultForwdarBetelgeuseMed(),equip_defaultForwdarBetelgeuseHigh()}
end

--[[
-- Turret mounts - Betelgeuse Navy
--]]
function equip_defaultTurretBetelgeuseLow ()
   return { "Turreted Railgun" }
end
function equip_defaultTurretBetelgeuseMed ()
   return { "Turreted Medium Railgun"  }
end
function equip_defaultTurretBetelgeuseHigh ()
   return { "Turreted Heavy Railgun"  }
end
function equip_defaultTurretsBetelgeuse()
   return {equip_defaultTurretBetelgeuseLow(),equip_defaultTurretBetelgeuseMed(),equip_defaultTurretBetelgeuseHigh()}
end


--[[
-- Secondary weapons - Betelgeuse Navy
--]]
function equip_defaultSecondaryBetelgeuseLow ()
   return { "Javelin Tube", "Hunter Launcher"  }
end
function equip_defaultSecondaryBetelgeuseMed ()
   return { "Squalo Tube"  }
end
function equip_defaultSecondaryBetelgeuseHigh ()
   return { "Squalo Tube"  }
end
function equip_defaultSecondaryBetelgeuse()
   return {equip_defaultSecondaryBetelgeuseLow(),equip_defaultSecondaryBetelgeuseMed(),equip_defaultSecondaryBetelgeuseHigh()}
end



--[[
-- Forward mounts - Barbarians 
--]]
function equip_defaultForwardBarbariansLow ()
   return { "Shredder" }
end
function equip_defaultForwardBarbariansMed ()
   return { "Improved Shredder" }
end
function equip_defaultForwardBarbariansHigh ()
   return { "Heavy Shredder"  }
end
function equip_defaultForwardBarbarians ()
   return {equip_defaultForwardBarbariansLow(),equip_defaultForwardBarbariansMed(),equip_defaultForwardBarbariansHigh()}
end

--[[
-- Turret mounts - Barbarians
--]]
function equip_defaultTurretBarbariansLow ()
   return { "Mass Driver Turret"  }
end
function equip_defaultTurretBarbariansMed ()
   return { "Improved Shredder Turret"  }
end
function equip_defaultTurretBarbariansHigh ()
   return { "Heavy Shredder Turret"  }
end
function equip_defaultTurretsBarbarians()
   return {equip_defaultTurretBarbariansLow(),equip_defaultTurretBarbariansMed(),equip_defaultTurretBarbariansHigh()}
end


--[[
-- Secondary weapons - Barbarians
--]]
function equip_defaultSecondaryBarbariansLow ()
   return { "Javelin Tube"  }
end
function equip_defaultSecondaryBarbariansMed ()
   return { "Hunter Launcher"   }
end
function equip_defaultSecondaryBarbariansHigh ()
   return { "Upgraded Hunter Launcher"   }
end
function equip_defaultSecondaryBarbarians()
   return {equip_defaultSecondaryBarbariansLow(),equip_defaultSecondaryBarbariansMed(),equip_defaultSecondaryBarbariansHigh()}
end



--[[
-- Utility slots
--]]
function equip_defaultUtilitiesLow ()
   return { "Generic Afterburner", "Generic Jammer", "Reactor Class I", "Small Shield Regenerator" }
end
function equip_defaultUtilitiesMed ()
   return { "Improved Generic Afterburner", "Generic Jammer", "Emergency Shield Booster", "Reactor Class II", "Small Shield Regenerator" }
end
function equip_defaultUtilitiesHigh ()
   return { "Improved Generic Afterburner", "Generic Jammer", "Emergency Shield Booster", "Reactor Class III", "Medium Shield Regenerator" }
end
function equip_defaultUtilities ()
   return {equip_defaultUtilitiesLow(),equip_defaultUtilitiesMed(),equip_defaultUtilitiesHigh()}
end

--[[
-- Utility slots - pirates
--]]
function equip_defaultUtilitiesPiratesLow ()
   return { "Generic Afterburner", "Generic Jammer", "Reactor Class I", "Small Shield Regenerator", "Reverse Thrusters" }
end
function equip_defaultUtilitiesPiratesMed ()
   return { "Improved Generic Afterburner", "Generic Jammer", "Emergency Shield Booster", "Reactor Class II", "Small Shield Regenerator", "Combat Droids", "Reverse Thrusters" }
end
function equip_defaultUtilitiesPiratesHigh ()
   return { "Improved Generic Afterburner", "Generic Jammer", "Emergency Shield Booster", "Reactor Class III", "Medium Shield Regenerator", "Combat Droids", "Reverse Thrusters" }
end
function equip_defaultUtilitiesPirates ()
   return {equip_defaultUtilitiesPiratesLow(),equip_defaultUtilitiesPiratesMed(),equip_defaultUtilitiesPiratesHigh()}
end

--[[
-- Utility slots - Imperial Navy
--]]
function equip_defaultUtilitiesEmpireLow ()
   return { "Improved Generic Afterburner", "Generic Jammer", "Reactor Class I", "Small Shield Regenerator", "Terran Shield Booster" }
end
function equip_defaultUtilitiesEmpireMed ()
   return { "Improved Generic Afterburner", "Terran Navy Jammer", "Emergency Shield Booster", "Reactor Class II", "Small Shield Regenerator", "Marine Small Arms", "Advanced Terran Scrambler", "Terran Medium Shield Booster" }
end
function equip_defaultUtilitiesEmpireHigh ()
   return { "Terran Hellburner", "Terran Navy Jammer", "Emergency Shield Booster", "Anti-Matter Reactor", "Medium Shield Regenerator", "Armour Repair Equipment", "Marine Small Arms", "Advanced Terran Scrambler", "Terran Navy Heavy Shield Booster" }
end
function equip_defaultUtilitiesEmpire ()
   return {equip_defaultUtilitiesEmpireLow(),equip_defaultUtilitiesEmpireMed(),equip_defaultUtilitiesEmpireHigh()}
end

--[[
-- Utility slots - Ardar
--]]
function equip_defaultUtilitiesArdarLow ()
   return { "Ardar Jammer", "Reactor Class I", "Small Shield Regenerator", "Ardar Hellburner" }
end
function equip_defaultUtilitiesArdarMed ()
   return { "Ardar Hellburner", "Ardar Jammer", "Emergency Shield Booster", "Reactor Class II", "Small Shield Regenerator", "Armour Repair Droids", "Ardar Navy Scrambler", "Ardar Medium Shield Booster" }
end
function equip_defaultUtilitiesArdarHigh ()
   return { "Ardar Hellburner", "Ardar Jammer", "Emergency Shield Booster", "Naval Fusion Reactor", "Medium Shield Regenerator", "Armour Repair Droids", "Ardar Shock Troops" , "Ardar Navy Scrambler", "Ardar Medium Shield Booster"}
end
function equip_defaultUtilitiesArdar ()
   return {equip_defaultUtilitiesArdarLow(),equip_defaultUtilitiesArdarMed(),equip_defaultUtilitiesArdarHigh()}
end


--[[
-- Utility slots - Betelgeuse
--]]
function equip_defaultUtilitiesBetelgeuseLow ()
   return { "Generic Afterburner", "Betelgian Jammer", "Reactor Class I", "Small Shield Regenerator", "Betelgian Scrambler" }
end
function equip_defaultUtilitiesBetelgeuseMed ()
   return { "Improved Generic Afterburner", "Betelgian Jammer", "Emergency Shield Booster", "Reactor Class II", "Small Shield Regenerator", "Betelgian Scrambler" }
end
function equip_defaultUtilitiesBetelgeuseHigh ()
   return { "Improved Generic Afterburner", "Betelgian Jammer", "Emergency Shield Booster", "Reactor Class III", "Medium Shield Regenerator", "Betelgian Scrambler" }
end
function equip_defaultUtilitiesBetelgeuse ()
   return {equip_defaultUtilitiesBetelgeuseLow(),equip_defaultUtilitiesBetelgeuseMed(),equip_defaultUtilitiesBetelgeuseHigh()}
end


--[[
-- Structure slots
--]]
function equip_defaultStructuresLow ()
   return { "Small Composite Plating", "Light Battery", "Shield Capacitor", "Solar Panel" }
end
function equip_defaultStructuresMed ()
   return { "Composite Plating", "Medium Battery", "Shield Capacitor II" }
end
function equip_defaultStructuresHigh ()
   return { "Large Composite Plating", "Large Battery", "Shield Capacitor III" }
end
function equip_defaultStructures ()
   return {equip_defaultStructuresLow(),equip_defaultStructuresMed(),equip_defaultStructuresHigh()}
end


--[[
-- Structure slots - Merchants
--]]
function equip_defaultStructuresMerchantLow ()
   return { "Light Battery", "Shield Capacitor", "Solar Panel", "Cargo Pod", "Cargo Pod", "Fuel Pod", "Fuel Pod" }
end
function equip_defaultStructuresMerchantMed ()
   return { "Medium Battery", "Shield Capacitor II", "Solar Panel Array", "Medium Cargo Pod", "Medium Cargo Pod", "Medium Fuel Pod", "Medium Fuel Pod" }
end
function equip_defaultStructuresMerchantHigh ()
   return { "Large Battery", "Shield Capacitor III", "Concentrated Solar Panels", "Large Cargo Pod", "Large Cargo Pod", "Large Fuel Pod", "Large Fuel Pod" }
end
function equip_defaultStructuresMerchant ()
   return {equip_defaultStructuresMerchantLow(),equip_defaultStructuresMerchantMed(),equip_defaultStructuresMerchantHigh()}
end

--[[
-- Structure slots - pirates
--]]
function equip_defaultStructuresPiratesLow ()
   return { "Small Composite Plating", "Light Battery", "Shield Capacitor", "Power Regulation Override", "Makeshift Steering Thrusters" }
end
function equip_defaultStructuresPiratesMed ()
   return { "Steel Plating", "Medium Battery", "Shield Capacitor II", "Power Regulation Override" }
end
function equip_defaultStructuresPiratesHigh ()
   return { "Large Steel Plating", "Large Battery", "Shield Capacitor III", "Power Regulation Override" }
end
function equip_defaultStructuresPirates ()
   return {equip_defaultStructuresPiratesLow(),equip_defaultStructuresPiratesMed(),equip_defaultStructuresPiratesHigh()}
end


--[[
-- Structure slots - Empire
--]]
function equip_defaultStructuresEmpireLow ()
   return { "Small Composite Plating", "Terran Light Battery", "Shield Capacitor", "Engine Reroute", "Steering Thrusters" }
end
function equip_defaultStructuresEmpireMed ()
   return { "Terran Navy Plating", "Terran Medium Battery", "Shield Capacitor II", "Forward Shock Absorbers", "Engine Reroute", "Reworked Energy Lines", "Steering Thrusters" }
end
function equip_defaultStructuresEmpireHigh ()
   return { "Large Terran Navy Plating", "Large Battery", "Terran Navy Shield Capacitor", "Forward Shock Absorbers", "Engine Reroute", "Reworked Energy Lines", "Steering Thrusters", "Integrated Targeting Array" }
end
function equip_defaultStructuresEmpire ()
   return {equip_defaultStructuresEmpireLow(),equip_defaultStructuresEmpireMed(),equip_defaultStructuresEmpireHigh()}
end

--[[
-- Structure slots - Ardar
--]]
function equip_defaultStructuresArdarLow ()
   return { "Small Composite Plating", "Light Battery", "Shield Capacitor", "Solar Panel" }
end
function equip_defaultStructuresArdarMed ()
   return { "Self-Repairing Plating", "Medium Battery", "Shield Capacitor II", "Forward Stabilised Mount", "Improved Trajectory Stabilizer", "Improved Power Regulator" }
end
function equip_defaultStructuresArdarHigh ()
   return { "Large Self-Repairing Plating", "Ardar Large Battery", "Ardar Navy Shield Capacitor", "Forward Stabilised Mount", "Improved Trajectory Stabilizer", "Improved Power Regulator" }
end
function equip_defaultStructuresArdar ()
   return {equip_defaultStructuresLow(),equip_defaultStructuresMed(),equip_defaultStructuresHigh()}
end


--[[
-- Structure slots - Betelgeuse
--]]
function equip_defaultStructuresBetelgeuseLow ()
   return { "Small Composite Plating", "Exploration Battery", "Shield Capacitor", "Solar Panel", "Betelgian Engine Rework" }
end
function equip_defaultStructuresBetelgeuseMed ()
   return { "Composite Plating", "Medium Exploration Battery", "Shield Capacitor II", "Solar Panel Array", "Betelgian Engine Rework", "Improved Turret Refrigeration Cycle" }
end
function equip_defaultStructuresBetelgeuseHigh ()
   return { "Large Composite Plating", "Large Exploration Battery", "Shield Capacitor III", "Concentrated Solar Panels", "Betelgian Engine Rework", "Improved Turret Refrigeration Cycle" }
end
function equip_defaultStructuresBetelgeuse ()
   return {equip_defaultStructuresBetelgeuseLow(),equip_defaultStructuresBetelgeuseMed(),equip_defaultStructuresBetelgeuseHigh()}
end



--[[
-- Structure slots - Betelgeuse Merchants
--]]
function equip_defaultStructuresBetelgeuseMerchantLow ()
   return { "Exploration Battery", "Shield Capacitor", "Solar Panel", "Betelgian Engine Rework", "Cargo Pod", "Cargo Pod", "Fuel Pod", "Fuel Pod" }
end
function equip_defaultStructuresBetelgeuseMerchantMed ()
   return { "Medium Exploration Battery", "Shield Capacitor II", "Solar Panel Array", "Betelgian Engine Rework", "Medium Trade Pod", "Medium Trade Pod", "Medium Extended Fuel Pod", "Medium Extended Fuel Pod" }
end
function equip_defaultStructuresBetelgeuseMerchantHigh ()
   return { "Large Exploration Battery", "Shield Capacitor III", "Concentrated Solar Panels", "Betelgian Engine Rework", "Large Trade Pod", "Large Trade Pod", "Large Extended Fuel Pod", "Large Extended Fuel Pod" }
end
function equip_defaultStructuresBetelgeuseMerchant ()
   return {equip_defaultStructuresBetelgeuseMerchantLow(),equip_defaultStructuresBetelgeuseMerchantMed(),equip_defaultStructuresBetelgeuseMerchantHigh()}
end
