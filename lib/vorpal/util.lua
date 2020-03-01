-- @param tab: a table
-- @param fn: function taking keys and values of tab
-- @return: new table with tab's keys mapped to function results
function tab_map (tab, fn)
   local t = {}
   for k,v in pairs(tab) do
      t[k] = fn(k,v)
   end
   return t
end

-- @param m: an integer
-- @param n: an integer
-- @return: greatest common divisor
function gcd ( m, n )
    while n ~= 0 do
        local q = m
        m = n
        n = q % n
    end
    return m
end

-- @param m: an integer
-- @param n: an integer
-- @return: least common multiple
function lcm ( m, n )
    return ( m ~= 0 and n ~= 0 ) and m * n / gcd( m, n ) or 0
end
