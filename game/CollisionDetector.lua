CollisionDetector = {}
CollisionDetector.__index = CollisionDetector

function CollisionDetector:create(game)
    local collisionDetector = {}
    setmetatable(collisionDetector, CollisionDetector)

    self.game             = game
    self.trackablePlayers = {}
    self.trackableFields  = {}
    self.trackableBorders = {}

    return collisionDetector
end

function CollisionDetector:update()
    for _, player in pairs(self.trackablePlayers) do
        -- distinct player boid to convex parts
        local npps = {}
        for i = 1, #player.hitboxes do
            npps[i] = player:getNormals(i)
        end

        if (self:fieldsCollisionCheckOnPlayer(player, npps) or self:bordersCollisionCheckOnPlayer(player, npps)) then
            -- gimmick condition
        end
    end
end

function CollisionDetector:trackPlayer(player)
    -- Will require such fields, as: hitboxes (reference to vertices), getVertice(n) with absolute positioning including angle calculations.
    -- Now also requires .size and .k for optimization purposes (basically, it needs to know maximum possible boid deviation by x (location.x +- size * k))
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

function CollisionDetector:bordersCollisionCheckOnPlayer(player, npps)
    for _, border in pairs(self.trackableBorders) do
        local col = true
        
        local px = border[2].x - border[1].x
        local py = border[2].y - border[1].y
        local borderNormal = Vector:create(-py, px)

        for k = 1, #player.hitboxes do
            local npp = npps[k]

            local p = player:getMinMaxProj(k, borderNormal)
            local q = {math.min(dotProduct(Vector:create(border[1].x, border[1].y), borderNormal), dotProduct(Vector:create(border[2].x, border[2].y), borderNormal)),
                       math.max(dotProduct(Vector:create(border[1].x, border[1].y), borderNormal), dotProduct(Vector:create(border[2].x, border[2].y), borderNormal))}
            if ((p[2] < q[1]) or (q[2] < p[1])) then
                col = false
                break
            end
            
            for _, v in pairs(npp) do
                local p = player:getMinMaxProj(k, v)
                local q = {math.min(dotProduct(Vector:create(border[1].x, border[1].y), v), dotProduct(Vector:create(border[2].x, border[2].y), v)),
                            math.max(dotProduct(Vector:create(border[1].x, border[1].y), v), dotProduct(Vector:create(border[2].x, border[2].y), v))}
                if ((p[2] < q[1]) or (q[2] < p[1])) then
                    col = false
                    break
                end
            end

            if (col) then
                self.game:onCollision(player, {"border", k, border})
                return true
            end
        end
    end
end

function CollisionDetector:fieldsCollisionCheckOnPlayer(player, npps)
    for _, field in pairs(self.trackableFields) do
        -- cycling through all pipe pairs, starting from field.curr
        for i = 1, field.count do
            local index = (i + field.curr - 2) % field.count + 1
            -- fast checking
            if     (field.pipes[index][1] - math.max(field.pipeEndWidth, field.pipeWidth) * 0.5 >  player.size * player.k + player.location.x) then
                return false
            end
            if not (field.pipes[index][1] + math.max(field.pipeEndWidth, field.pipeWidth) * 0.5 < -player.size * player.k + player.location.x) then
                -- now cycling through all parts of given pipe pair (2 for lower, 2 for upper)
                for j = 1, #field.pipe do
                    local npf = field:getNormals(index, j)
                    -- now cycling thourgh distinct convex part of player
                    for k = 1, #player.hitboxes do
                        col = true
                        local npp = npps[k]

                        for _, np in pairs({npp, npf}) do
                            for _, v in pairs(np) do
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
                            self.game:onCollision(player, {"pipe", k, field, index, j})
                            return true
                        end
                    end
                end
            end
        end
    end

    return false
end