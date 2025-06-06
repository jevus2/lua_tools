-- A collection of functions for frequently used operations

function mean(table)
    -- Return arithmetic mean of a table
    table_sum = sum(table)
    table_mean = table_sum / #table

    return table_mean
end

function sum(table)
    -- Return sum of the elements of an array
    local s = 0
    for i,v in ipairs(table) do
        s = s + v
    end
    return s
end

local function round(num)
    -- Return rounded value to the nearest integer
    -- of a given number and delete trailing zeros
    num = math.floor(num + 0.5)
    return num
end

local function round2(num,prec)
    -- Return rounded value to given precision 
    -- of a given number and delete trailing zeros
    num = math.floor(num / (10^prec) + 0.5)
    return num * 10^prec 
end

local function max(table)
    -- Return max value in a table
    max = table[1]
    max_index = 1
    for i, num in ipairs(table) do
        if table[i] > max then
            max = table[i]
            max_index = i
        end
    end
    return max, max_index
end

local function extreme(table)
    -- Return max absolute value in a table
    extreme = math.abs(table[1])
    extreme_index = 1
    for i, num in ipairs(table) do
        if math.abs(table[i]) > math.abs(extreme) then
            extreme = table[i]
            extreme_index = i
        end
    end
    return extreme, extreme_index
end

local function min(table)
    -- Return min value in a table
    local min = table[1]
    local min_index = 1
    for i, num in ipairs(table) do
        if table[i] < min then
            min = table[i]
            min_index = i
        end
    end
    return min, min_index
end

local function lin_interp(x_0,x_1,y_0,y_1,x)
    -- Linear interpolation
    return y_0 + (y_1 - y_0) / (x_1 - x_0) * (x - x_0)
end

local function parametric_interpolation(p1, p2, s)
    -- p1 - start point
    -- p2 - end point
    -- s - parameter [0,1]
    local res = {}
    for i, v in pairs(p1) do
        if not p2[i] then 
            msg = 'the points don\'t have the same dimension'
        else
            res[i] = v + s * (p2[i] - v)
        end
    end
    return res, msg
end

local function mov_avg(tab,width)
    -- Moving average of a table
    local width_m = math.floor(width / 2)

    -- Copy data for values at either end 
    local tab_avg = {}
    for i,v in ipairs(tab) do
        tab_avg[i] = v
    end

    if  width_m == width / 2 then
        width_p = width_m - 1
    else
        width_p = width_m
    end

    for i=1+width_m, #tab-width_p do
        local mov_sum = 0
        for j=i-width_m, i+width_p do
            mov_sum = mov_sum + tab[j]
        end
        tab_avg[i] = mov_sum / width
    end

    return tab_avg
end

local function vec_prod(vec1,vec2)
    -- Vector product of two given vectors
    local n = {}
    n[1] = vec1[2] * vec2[3] - vec1[3] * vec2[2]
    n[2] = vec1[3] * vec2[1] - vec1[1] * vec2[3]
    n[3] = vec1[1] * vec2[2] - vec1[2] * vec2[1]

    return n
end

local function factorial(number)
    -- factorial of a given number
    local factorial = 1
    while number > 1 do
        factorial = factorial * number
        number = number - 1
    end
    return factorial
end

local function self_sum(number)
    -- sum equivalent of a factorial
    -- n + n-1 + n-2 + ... + 3 + 2 + 1
    self_sum = math.ceil(number/2) * number + math.fmod(number+1,2) * number/2
    return self_sum
end

local function sleep(seconds)
    -- takes number of seconds as an input and sleeps for the given time
    local sleep_time = os.clock() + seconds
    repeat until os.clock() >= sleep_time
    return 0
end

local function scal_prod(vec1,vec2)
    -- calculates scalar product or dot product of two vectors
    local sp = vec1[1] * vec2[1] + vec1[2] * vec2[2] + vec1[3] * vec2[3] 
    return sp
end

local function vec_ang(vec1,vec2)
    -- calculates angle in between two vectors
    local sp = scal_prod(vec1,vec2)
    local l1 = scal_prod(vec1,vec1)
    local l2 = scal_prod(vec2,vec2)
    local ang = math.acos(sp/math.sqrt(l1*l2))
    return ang
end


local function bilin_interp(x, y, val, ip)
    -- bilinear interpolation
    -- x1 < x2, y1 < y2
    -- val1 @ x1y1, val2 @ x2y1, val3 @ x1y2, val4 @ x2y2
    -- ip := interpolation point (x,y)
    local mx1 = (x[2] - ip[1]) / (x[2] - x[1]) 
    local mx2 = (ip[1] - x[1]) / (x[2] - x[1])
    local my1 = (y[2] - ip[2]) / (y[2] - y[1])
    local my2 = (ip[2] - y[1]) / (y[2] - y[1])
    local res = my1 * (mx1 * val[1] + mx2 * val[2]) + my2 * (mx1 * val[3] + mx2 * val[4])
    return res
end

local function multilin_interp(x, y, val, ip)
    -- multilin interpolation for arbitrary points
    -- weighted average of the given number of points
    -- x= (x1, .. ,xn)
    -- y= (y1, .. ,yn)
    -- val= (val1, .. ,valn)
    -- d1-dn := distance from interpolation point to points 1-n
    local d = {}
    local dt = 0
    for i=1, #x do
        d[#d+1] = math.sqrt((y[i] - ip[2])^2 + (x[i] - ip[1])^2)^(-1)
        dt = dt + d[#d]
    end
    local valp = 0
    for i=1, #x do
        valp = valp + val[i] * d[i] / dt
    end
    return valp
end

local function three_point_plane(p1,p2,p3)
    -- create plane through three points
    -- returns normal vector of plane
    vec1 = {p1[1]-p2[1],p1[2]-p2[2],p1[3]-p2[3]}
    vec2 = {p3[1]-p2[1],p3[2]-p2[2],p3[3]-p2[3]}
    local n = vec_prod(vec1,vec2)
    return n
end

local function rms(table)
    -- root mean square of the elements of an array
    -- square each value first
    local sq = {}
    for i=1, #table do
        sq[i] = table[i]^2
    end
    
    -- calculate rms
    local res = math.sqrt(sum(sq) / #sq)
    return res
end

local function ellipse_circumference(a, b)
    -- Pade approximation of the circumference
    -- of an ellipse
    local h
    h = ((a - b) / (a + b))^2
    num = 135168 - 85760*h - 5568*h^2 + 3867*h^3
    den = 135168 - 119552*h + 22208*h^2 - 345*h^3

    return math.pi*(a + b) * num / den
end

local function calculate_centroid(points)
    local centroid = {}
    for key, value in pairs(points[1]) do
        centroid[key] = 1/#points * value
    end
    for i=2, #points do
        for key, value in pairs(points[i]) do
            centroid[key] = centroid[key] + 1/#points * value
        end
    end
    return centroid
end

local function compare_points(p1, p2, accuracy)
    accuracy = accuracy or 1e-12
    for key, value in pairs(p1) do
        key_exists, message = pcall(function () return assert(p2[key]) end)
        if not key_exists then return false, string.format('point 2 doesn\'t contain coordinate %s but point 1 does', key) end
        if math.abs(value - p2[key]) > accuracy then return false, string.format('coordinate %s doesn\'t match', key) end
    end

    for key, value in pairs(p2) do
        key_exists, message = pcall(function () return assert(p1[key]) end)
        if not key_exists then return false, string.format('point 1 doesn\'t contain coordinate %s but point 2 does', key) end
    end

    return true
end

local function vec_magnitude(vec)
    local mag = 0
    for key, value in pairs(vec) do
        mag = value^2 + mag
    end
    return mag^0.5
end

local function add_noise(noise_level)
    math.randomseed(os.time())
    return 1 + 2 * noise_level * (math.random() - 0.5)
end

local function cubic_polynomial(p0, p1, derivative=false)
    -- construct a cubic polynomial ax**3 + bx**2 + cx + d or it's derivative 
    -- in 2D from two points and their derivative 
    -- p0={x,y,dxdy}, p1={x,y,dxdy}
    coefficient_a = (p0.dydx + p1.dydx - 2 * (p0.y - p1.y) / (x0 - x1)) / (3 * (p0.x**2 + p1.x**2) - 2 * (p0.x**3 - p1.x**3) / (p0.x - p1.x))
    coefficient_b = (p0.dydx - p1.dydx) / (2 * (p0.x - p1.x)) - 3 / 2 * coefficient_a * (p0.x + p1.x)
    coefficient_c = p1.dydx - 3 * coefficient_a * p1.x**2 - 2 * coefficient_b * p1.x
    coefficient_d = p1.y - coefficient_a * p1.x**3 - coefficient_b * p1.x**2 - coefficient_c * p1.x

    if derivative then return function(x) return 3 * coefficient_a * x**2 + 2 * coefficient_b * x + coefficient_c end end
    return function(x) return coefficient_a * x**3 + coefficient_b * x**2 + coefficient_c * x + coefficient_d end
end

return {mean = mean, 
    sum = sum, 
    round = round, 
    round2 = round2,
    max = max, 
    extreme = extreme, 
    min = min, 
    lin_interp = lin_interp, 
    parametric_interpolation = parametric_interpolation,
    mov_avg = mov_avg, 
    vec_prod = vec_prod,
    factorial = factorial,
    self_sum = self_sum,
    sleep = sleep,
    scal_prod = scal_prod,
    vec_ang = vec_ang,
    bilin_interp = bilin_interp,
    multilin_interp = multilin_interp,
    three_point_plane = three_point_plane,
    rms = rms,
    sort_by_x = sort_by_x,
    ellipse_circumference = ellipse_circumference,
    calculate_centroid = calculate_centroid,
    compare_points = compare_points,
    vec_magnitude = vec_magnitude,
    add_noise = add_noise,
    cubic_polynomial = cubic_polynomial
    }
