CollisionDetector = {}
CollisionDetector.__index = CollisionDetector

function CollisionDetector:create(onCollision)
    local collisionDetector = {}
    setmetatable(collisionDetector, CollisionDetector)

    self.onCollision      = onCollision
    self.trackablePlayers = {}
    self.trackableFields  = {}
    self.trackableBorders = {}

    return collisionDetector
end

function CollisionDetector:update()
    for _, player in pairs(self.trackablePlayers) do
        if (self:fieldsCollisionCheckOnPlayer(player) or self:bordersCollisionCheckOnPlayer(player)) then
            -- gimmick condition
        end
    end
end

function CollisionDetector:trackPlayer(player)
    -- Will require such fields, as: hitboxes (reference to vertices), getVertice(n) with absolute positioning including angle calculations.
    self.trackablePlayers[#self.trackablePlayers + 1] = player
end

function CollisionDetector:trackField(field)
    -- For now it's really just for a specific field.lua class.
    self.trackableFields[#self.trackableFields + 1] = field
end

function CollisionDetector:trackBorder(border)
    -- Border must be a table of two vectors, e.g. {Vector:create(0, 0), Vector:create(1, 1)}
    self.trackableBorders[#self.trackableBorders + 1] = border
end

function CollisionDetector:bordersCollisionCheckOnPlayer(player)
    return false
end

function CollisionDetector:fieldsCollisionCheckOnPlayer(player)
    -- distinct player boid to convex parts
    local npps = {}
    for i = 1, #player.hitboxes do
        npps[i] = player:getNormals(i)
    end

    for _, field in pairs(self.trackableFields) do
        -- cycling through all pipe pairs, starting from field.curr
        for i = 1, field.count do
            local index = (i + field.curr - 2) % field.count + 1
            -- now cycling through all parts of given pipe pair (2 for lower, 2 for upper)
            for j = 1, #field.pipe do
                local npf = field:getNormals(index, j)
                col = true
                -- now cycling thourgh distinct convex part of player
                for k = 1, #player.hitboxes do
                    local npp = npps[k]

                    for k1, np in pairs({npp, npf}) do
                        for k2, v in pairs(np) do
                            local p = player:getMinMaxProj(k, v)
                            local q = field:getMinMaxProj(index, j, v)

                            if ((p[2] < q[1]) or (q[2] < p[1])) then
                                col = false
                                break
                            end
                        end
                        if (not col) then
                            break
                        end
                    end

                    if (col) then
                        onCollision(player, field, index, j)
                        return true
                    end
                end
            end
        end
    end

    return false
end