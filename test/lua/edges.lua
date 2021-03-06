--TODO: check if you can use lua type boolean instead of strings and pass that back to osm2pgsql
--with the hopes that they will become strings once they get back to c++ and then just work in
--postgres

highway = {
["motorway"] =          {["auto_forward"] = "true",  ["pedestrian"] = "false",  ["bike_forward"] = "false"},
["motorway_link"] =     {["auto_forward"] = "true",  ["pedestrian"] = "false",  ["bike_forward"] = "false"},
["trunk"] =             {["auto_forward"] = "true",  ["pedestrian"] = "true",   ["bike_forward"] = "true"},
["trunk_link"] =        {["auto_forward"] = "true",  ["pedestrian"] = "true",   ["bike_forward"] = "true"},
["primary"] =           {["auto_forward"] = "true",  ["pedestrian"] = "true",   ["bike_forward"] = "true"},
["primary_link"] =      {["auto_forward"] = "true",  ["pedestrian"] = "true",   ["bike_forward"] = "true"},
["secondary"] =         {["auto_forward"] = "true",  ["pedestrian"] = "true",   ["bike_forward"] = "true"},
["secondary_link"] =    {["auto_forward"] = "true",  ["pedestrian"] = "true",   ["bike_forward"] = "true"},
["residential"] =       {["auto_forward"] = "true",  ["pedestrian"] = "true",   ["bike_forward"] = "true"},
["residential_link"] =  {["auto_forward"] = "true",  ["pedestrian"] = "true",   ["bike_forward"] = "true"},
["service"] =           {["auto_forward"] = "true",  ["pedestrian"] = "true",   ["bike_forward"] = "true"},
["tertiary"] =          {["auto_forward"] = "true",  ["pedestrian"] = "true",   ["bike_forward"] = "true"},
["tertiary_link"] =     {["auto_forward"] = "true",  ["pedestrian"] = "true",   ["bike_forward"] = "true"},
["road"] =              {["auto_forward"] = "true",  ["pedestrian"] = "true",   ["bike_forward"] = "true"},
["track"] =             {["auto_forward"] = "true",  ["pedestrian"] = "true",   ["bike_forward"] = "true"},
["unclassified"] =      {["auto_forward"] = "true",  ["pedestrian"] = "true",   ["bike_forward"] = "true"},
["undefined"] =         {["auto_forward"] = "false", ["pedestrian"] = "false",  ["bike_forward"] = "false"},
["unknown"] =           {["auto_forward"] = "false", ["pedestrian"] = "false",  ["bike_forward"] = "false"},
["living_street"] =     {["auto_forward"] = "true",  ["pedestrian"] = "true",   ["bike_forward"] = "true"},
["footway"] =           {["auto_forward"] = "false", ["pedestrian"] = "true",   ["bike_forward"] = "false"},
["pedestrian"] =        {["auto_forward"] = "false", ["pedestrian"] = "true",   ["bike_forward"] = "false"},
["steps"] =             {["auto_forward"] = "false", ["pedestrian"] = "true",   ["bike_forward"] = "true"},
["bridleway"] =         {["auto_forward"] = "false", ["pedestrian"] = "false",  ["bike_forward"] = "false"},
["construction"] =      {["auto_forward"] = "false", ["pedestrian"] = "false",  ["bike_forward"] = "false"},
["cycleway"] =          {["auto_forward"] = "false", ["pedestrian"] = "false",  ["bike_forward"] = "true"},
["path"] =              {["auto_forward"] = "false", ["pedestrian"] = "true",   ["bike_forward"] = "true"},
["bus_guideway"] =      {["auto_forward"] = "false", ["pedestrian"] = "false",  ["bike_forward"] = "false"}
}

road_class = {
["motorway"] = 0, 
["motorway_link"] = 0,
["trunk"] = 1,
["trunk_link"] = 1,
["primary"] = 2,
["primary_link"] = 2,
["secondary"] = 2,
["secondary_link"] = 2,
["tertiary"] = 3, 
["tertiary_link"] = 3, 
["unclassified"] = 3, 
["residential"] = 4, 
["residential_link"] = 4, 
["service"] = 5, 
["track"] = 6
}

default_speed = {
[0] = 105,
[1] = 90,
[2] = 75,
[3] = 60,
[4] = 40,
[5] = 40,
[6] = 20,
[7] = 30
}

access = {
["no"] = "false",
["official"] = "false",
["private"] = "false",
["destination"] = "false",
["yes"] = "true",
["permissive"] = "true",
["agricultural"] = "false",
["customers"] = "true"
}

private = {
["private"] = "true"
}

no_thru_traffic = {
["destination"] = "true",
["customers"] = "true"
}

use = {
["parking_aisle"] = 3,
["driveway"] = 4,
["alley"] = 5,
["emergency_access"] = 6,
["drive-through"] = 7
}

motor_vehicle = {
["no"] = "false",
["yes"] = "true",
["agricultural"] = "false",
["destination"] = "false",
["private"] = "false",
["forestry"] = "false",
["designated"] = "true",
["permissive"] = "true"
}

foot = {
["no"] = "false",
["yes"] = "true",
["designated"] = "true",
["permissive"] = "true",
["crossing"] = "true"
}

bicycle = {
["yes"] = "true",
["designated"] = "true",
["dismount"] = "true",
["no"] = "false",
["lane"] = "true",
["track"] = "true",
["shared"] = "true",
["shared_lane"] = "true",
["sidepath"] = "true",
["share_busway"] = "true",
["none"] = "false"
}

bike_reverse = {
["opposite"] = "true",
["opposite_lane"] = "true",
["opposite_track"] = "true"
}

oneway = {
["-1"] = "false",
["yes"] = "true",
["true"] = "true",
["1"] = "true"
}

bridge = {
["yes"] = "true",
["no"] = "false",
["1"] = "true"
}

surface = {
["asphalt"] = "false",
["paved"] = "false",
["concrete"] = "false",
["cobblestone"] = "false",
["cobblestone:flattened"] = "false"
}

--TODO: building_passage is for ped only
tunnel = {
["yes"] = "true",
["no"] = "false",
["1"] = "true",
["building_passage"] = "true"
}

--TODO: snowmobile might not really be passable for much other than ped..
toll = {
["yes"] = "true",
["no"] = "false",
["true"] = "true",
["false"] = "false",
["1"] = "true",
["snowmobile"] = "true"
}

--convert the numeric (non negative) number portion at the beginning of the string
function numeric_prefix(num_str)
  --not a string
  if num_str == nil then
    return nil
  end

  --find where the numbers stop
  local index = 0
  for c in num_str:gmatch"." do
    if tonumber(c) == nil then
      break
    end
    index = index + 1
  end

  --there weren't any numbers
  if index == 0 then
    return nil
  end

  --convert number portion of string to actual numeric type
  return tonumber(num_str:sub(0, index))
end

--normalize a speed value
function normalize_speed(speed)
  --grab the number prefix
  local num = numeric_prefix(speed)

  --check if the rest of the string ends in "mph" convert to kph
  if num and speed:sub(-3) == "mph" then
    num = num * 1.609344
  end

  return num
end

--returns 1 if you should filter this way 0 otherwise
function filter_tags_generic(kv)
  --figure out what basic type of road it is
  local forward = highway[kv["highway"]]
  local ferry = kv["route"] == "ferry"
  if forward then
    for k,v in pairs(forward) do
      kv[k] = v
    end
  else
    --if its a ferry and these tags dont show up we want to set them to true 
    local default_val = tostring(ferry)
    
    --check for auto_forward overrides
    kv["auto_forward"] = motor_vehicle[kv["motor_vehicle"]] or motor_vehicle[kv["motorcar"]] or default_val

    --check for ped overrides
    kv["pedestrian"] = foot[kv["foot"]] or foot[kv["pedestrian"]] or default_val

    --check for bike_forward overrides
    kv["bike_forward"] = bicycle[kv["bicycle"]] or bicycle[kv["cycleway"]] or default_val
  end

  --service=driveway means all are routable
  if kv["service"] == "driveway" and kv["access"] == nil then
    kv["auto_forward"] = "true"
    kv["pedestrian"] = "true"
    kv["bike_forward"] = "true"
  end

  --check the oneway-ness and traversability against the direction of the geom
  kv["bike_backward"] = bike_reverse[kv["cycleway"]] or "false"
  local oneway_norm = oneway[kv["oneway"]]
  if kv["junction"] == "roundabout" then
    oneway_norm = "true"
    kv["roundabout"] = "true"
  else
    kv["roundabout"] = "false"
  end
  kv["oneway"] = oneway_norm
  if oneway_norm == "true" then
    kv["auto_backward"] = "false"
    kv["bike_backward"] = "false"
  elseif oneway_norm == nil then
    kv["auto_backward"] = kv["auto_forward"]
    if kv["bike_backward"] == "false" then
      kv["bike_backward"] = kv["bike_forward"]
    end
  end

  --if none of the modes were set we are done looking at this junker
  if kv["auto_forward"] == "false" and kv["bike_forward"] == "false" and kv["auto_backward"] == "false" and kv["bike_backward"] == "false" and kv["pedestrian"] == "false" then
    return 1
  end

  --set a few flags
  local road_class = road_class[kv["highway"]]

  if kv["highway"] == nil and ferry then
    road_class = 2 --TODO:  can we weight based on ferry types?
  elseif kv["highway"] == nil and kv["railway"] then
    road_class = 2 --TODO:  can we weight based on rail types?    
  elseif road_class == nil then
    road_class = 7
  end 
  
  kv["road_class"] = road_class

  kv["default_speed"] = default_speed[kv["road_class"]]

  local use = use[kv["service"]]

  if kv["highway"] == "steps" then
    use = 7 --steps/stairs
  elseif kv["highway"] == nil then 
    use = 0
  elseif kv["highway"] then
    --favor bicycles
    if kv["highway"] == "cycleway" then
        use = 1
    elseif kv["pedestrian"] == "false" and kv["auto_forward"] == "false" and kv["auto_backward"] == "false" and (kv["bike_forward"] == "true" or kv["bike_backward"] == "true") then
       use = 1
    --favor pedestrians
    elseif kv["highway"] == "footway" or kv["highway"] == "pedestrian" then 
       use = 2
    elseif kv["pedestrian"] == "true" and kv["auto_forward"] == "false" and kv["auto_backward"] == "false" and kv["bike_forward"] == "false" and kv["bike_backward"] == "false" then
       use = 2
    end
  elseif use == nil and kv["service"] then
    use = 9 --other
  else 
    use = 0 --none
  end

  kv["use"] = use

  if kv["highway"] and string.find(kv["highway"], "_link") then --*_link 
     kv["link"] = "true"  --do we need to add more?  turnlane?
  end

  kv["private"] = private[kv["access"]] or "false"
  kv["no_thru_traffic"] = no_thru_traffic[kv["access"]] or "false"
  kv["ferry"] = tostring(ferry)
  kv["rail"] = tostring(kv["auto_forward"] == "true" and kv["railway"] == rail)
  kv["name"] = kv["name"]
  kv["name:en"] = kv["name:en"]
  kv["alt_name"] = kv["alt_name"]
  kv["official_name"] = kv["official_name"]
  kv["speed"] = normalize_speed(kv["maxspeed"])
  kv["int"] = kv["int"]
  kv["int_ref"] = kv["int_ref"]

  local surface = surface[kv["surface"]]

  if surface then
     kv["surface"] = "false"  --paved
  elseif kv["surface"] then 
     kv["surface"] = "true"  --unpaved
  else 
    kv["surface"] = "false"  --default to paved.
  end 
  
  lane_count = numeric_prefix(kv["lanes"])
  if lane_count and lane_count > 10 then
    lane_count = 10
  end
  kv["lanes"] = lane_count
  kv["bridge"] = bridge[kv["bridge"]] or "false"
  kv["tunnel"] = tunnel[kv["tunnel"]] or "false"
  kv["toll"] = toll[kv["toll"]] or "false"
  kv["destination"] = kv["destination"]
  kv["destination:ref"] = kv["destination:ref"]
  kv["destination:ref:to"] = kv["destination:ref:to"]
  kv["junction:ref"] = kv["junction:ref"]

  local nref = kv["ncn_ref"]
  local rref = kv["rcn_ref"]
  local lref = kv["lcn_ref"]
  local bike_mask = 0
  if nref or kv["ncn"] == "yes" then
    bike_mask = 1
  end
  if rref or kv["rcn"] == "yes" then
    bike_mask = bit32.bor(bike_mask, 2)
  end
  if lref or kv["lcn"] == "yes" then
    bike_mask = bit32.bor(bike_mask, 4)
  end 
  kv["bike_national_ref"] = nref
  kv["bike_regional_ref"] = rref
  kv["bike_local_ref"] = lref
  kv["bike_network_mask"] = bike_mask

  return 0
end

function nodes_proc (keyvalues, nokeys)
  --we dont care about nodes at all so filter all of them
  return 1, keyvalues
end

function ways_proc (kv, nokeys)
  --if there were no tags passed in, ie keyvalues is empty
  if nokeys == 0 then
    return 1, kv, 0, 0
  end

  --does it at least have some interesting tags
  filter = filter_tags_generic(kv)

  --let the caller know if its a keeper or not and give back the  modified tags
  --also tell it whether or not its a polygon or road
  return filter, kv, 0, 0
end

function rels_proc (keyvalues, nokeys)
  --we dont care about rels at all so filter all of them
  --actually we do because it contains turn restrictions and route
  --shielding and directional information but we post process that
  --information out using the middle tables
  return 1, keyvalues
end

function rel_members_proc (keyvalues, keyvaluemembers, roles, membercount)
  --because we filter all rels we never call this function
  --because we do rel processing later we simply say that no ways are used
  --in the given relation, what would be nice is if we could push tags
  --back to the ways via keyvaluemembers, we could then avoid doing
  --post processing to get the shielding and directional highway info
  membersuperseeded = {}
  for i = 1, membercount do
    membersuperseeded[i] = 0
  end

  return 1, keyvalues, membersuperseeded, 0, 0, 0
end
