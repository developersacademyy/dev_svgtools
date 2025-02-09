svgtools = {}
svgtools.vectors = {}
svgtools.cache = {}
svgtools.types = {
    triangle = 3,
    diamond = 4,
    pentagon = 5,
    hexagon = 6
}

svgtools.createVector = function(w, h, data)
    local svg = svgCreate(w, h, data)
    return {
        svg = svg,
        xml = svgGetDocumentXML(svg),
        element = xmlFindChild(svgGetDocumentXML(svg), 'polygon', 0) or xmlFindChild(svgGetDocumentXML(svg), 'circle', 0)
    }
end

svgtools.createPolygon = function(id, type, w, h, stroke)
    if not (id and svgtools.types[type] and w and h) then return end
    if svgtools.vectors[id] then return svgtools.vectors[id] end

    stroke = stroke or 2
    local r = math.min(w, h) / 2
    local points = {}
    
    for i = 0, svgtools.types[type] - 1 do
        local ang = i * (2 * math.pi / svgtools.types[type]) - (math.pi / 2)
        local px = (r - stroke/2) * math.cos(ang) + (w + stroke*2)/2
        local py = (r - stroke/2) * math.sin(ang) + (h + stroke*2)/2
        points[#points + 1] = string.format('%.2f,%.2f', px, py)
    end

    local svg = svgtools.createVector(w, h, string.format([[
        <svg width='%d' height='%d' xmlns="http://www.w3.org/2000/svg">
        <polygon points='%s' fill='none' stroke='#FFF' stroke-width='%d' 
        stroke-dasharray='%f' stroke-linecap='round' vector-effect='non-scaling-stroke'/>
        </svg>
    ]], w + stroke*2, h + stroke*2, table.concat(points, ' '), stroke, 2*math.pi*r))

    svgtools.vectors[id] = {type = type, svg = svg, w = w, h = h, perimetro = 2*math.pi*r}
    return svgtools.vectors[id]
end

svgtools.createCircle = function(id, w, h, stroke)
    if not (id and w and h) then return end
    if svgtools.vectors[id] then return svgtools.vectors[id] end

    stroke = stroke or 2
    local r = math.min(w, h) / 2
    
    local svg = svgtools.createVector(w, h, string.format([[
        <svg width='%d' height='%d' xmlns="http://www.w3.org/2000/svg">
        <circle cx='%d' cy='%d' r='%d' fill='none' stroke='#FFF' stroke-width='%d'
        stroke-dasharray='%f' stroke-linecap='round' vector-effect='non-scaling-stroke'/>
        </svg>
    ]], w + stroke*3, h + stroke*3, (w + stroke*3)/2, (h + stroke*3)/2, r - stroke, stroke, 2*math.pi*r))

    svgtools.vectors[id] = {type = 'circle', svg = svg, w = w, h = h, perimetro = 2*math.pi*r}
    return svgtools.vectors[id]
end

svgtools.updateVector = function(id, valor)
    local v = svgtools.vectors[id]
    if not v then return end
    
    if not svgtools.cache[id] then svgtools.cache[id] = {false, valor, getTickCount()} end
    
    if svgtools.cache[id][2] ~= valor then
        if not svgtools.cache[id][1] then
            svgtools.cache[id][1], svgtools.cache[id][3] = true, getTickCount()
        end
        
        local prog = (getTickCount() - svgtools.cache[id][3]) / 8000
        svgtools.cache[id][2] = interpolateBetween(svgtools.cache[id][2], 0, 0, valor, 0, 0, prog, 'OutQuad')
        
        if prog > 1 then svgtools.cache[id][1], svgtools.cache[id][3] = false, nil end
        
        local elm = xmlFindChild(v.svg.xml, v.type == 'circle' and 'circle' or 'polygon', 0)
        if elm then
            xmlNodeSetAttribute(elm, 'stroke-dashoffset', v.perimetro - (v.perimetro/100 * svgtools.cache[id][2]))
            svgSetDocumentXML(v.svg.svg, v.svg.xml)
        end
    elseif svgtools.cache[id][1] then
        svgtools.cache[id][1] = false
    end
end

svgtools.drawVector = function(id, x, y, cor, rx, ry, rz, post)
    local v = svgtools.vectors[id]
    if not (v and x and y) then return end
    
    dxSetBlendMode('add')
    dxDrawImage(x, y, v.w, v.h, v.svg.svg, rx or 0, ry or 0, rz or 0, cor or 0xFFFFFFFF, post or false)
    dxSetBlendMode('modulate_add')
end

return svgtools
