CollisionDetector = {}
CollisionDetector.__index = CollisionDetector

function CollisionDetector:create()
    local collisionDetector = {}
    setmetatable(collisionDetector, CollisionDetector)

    return collisionDetector
end

function CollisionDetector:update()
    
end

function CollisionDetector:trackPlayer()

end

function CollisionDetector:trackObstacles()

end