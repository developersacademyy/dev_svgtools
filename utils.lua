vectors = {}
cache = {}
types = {
    triangle = 3,
    diamond = 4,
    pentagon = 5,
    hexagon = 6
}

createVector = function(w, h, data)
    local svg = svgCreate(w, h, data)
    return {
        svg = svg,
        xml = svgGetDocumentXML(svg),
        element = xmlFindChild(svgGetDocumentXML(svg), 'polygon', 0)
    }
end

createPolygon = function(id, type, w, h, stroke)
    if not (id and types[type] and w and h) then return end
    if vectors[id] then return vectors[id] end

    stroke = stroke or 2
    local r = math.min(w, h) / 2
    local points = {}
    
    for i = 0, types[type] - 1 do
        local ang = i * (2 * math.pi / types[type]) - (math.pi / 2)
        local px = (r - stroke/2) * math.cos(ang) + (w + stroke*2)/2
        local py = (r - stroke/2) * math.sin(ang) + (h + stroke*2)/2
        points[#points + 1] = string.format('%.2f,%.2f', px, py)
    end

    local svg = createVector(w, h, string.format([[
        <svg width='%d' height='%d' xmlns="http://www.w3.org/2000/svg">
        <polygon points='%s' fill='none' stroke='#FFF' stroke-width='%d' 
        stroke-dasharray='%f' stroke-linecap='round' vector-effect='non-scaling-stroke'/>
        </svg>
    ]], w + stroke*2, h + stroke*2, table.concat(points, ' '), stroke, 2*math.pi*r))

    vectors[id] = {type = type, svg = svg, w = w, h = h, perimetro = 2*math.pi*r}
    return vectors[id]
end

updatePolygon = function(id, value)
    local v = vectors[id]
    if not v then return end
    
    if not cache[id] then cache[id] = {false, value, getTickCount()} end
    
    if cache[id][2] ~= value then
        if not cache[id][1] then
            cache[id][1], cache[id][3] = true, getTickCount()
        end
        
        local prog = (getTickCount() - cache[id][3]) / 8000
        local targetValue = math.min(value, 100)
        cache[id][2] = interpolateBetween(cache[id][2], 0, 0, targetValue, 0, 0, prog, 'OutQuad')
        
        if prog > 1 then cache[id][1], cache[id][3] = false, nil end
        
        local elm = xmlFindChild(v.svg.xml, 'polygon', 0)
        if elm then
            local adjustedValue = cache[id][2]
            adjustedValue = adjustedValue * (v.type == 'triangle' and 0.8 or v.type == 'diamond' and 0.85 or v.type == 'pentagon' and 0.9 or v.type == 'hexagon' and 0.95 or 1)
            xmlNodeSetAttribute(elm, 'stroke-dashoffset', v.perimetro - (v.perimetro/100 * adjustedValue))
            svgSetDocumentXML(v.svg.svg, v.svg.xml)
        end
    elseif cache[id][1] then
        cache[id][1] = false
    end
end

drawPolygon = function(id, x, y, color, rotX, rotY, rotZ, postGUI)
    local data = vectors[id]
    if not (data and x and y) then return end
    
    dxDrawImage(x, y, data.w, data.h, data.svg.svg, rotX or 0, rotY or 0, rotZ or 0, color or 0xFFFFFFFF, postGUI or false)
end
