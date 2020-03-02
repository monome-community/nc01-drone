--     _/_
--   /  /  \
--   |   --  /
--  \/_/  /
--
-- wrlds
-- @andrew
--
-- E1 volume
-- E2 brightness
-- E3 density
-- K2 evolve
-- K3 change worlds

samples = { "bc", "dd", "eb" }
slew = 0.2

collection1 = {
  { rate = 1.0, start = 3.73, len = 2.22, sample = 2, },
  { rate = 2.0, start = 8.7, len = 3.16, sample = 2, },
  { rate = 1.0, start = 21.29, len = 1.78, sample = 2, },
  { rate = 1.0, start = 24.39, len = 1.78, sample = 2, },
  { rate = 2.0, start = 28.86, len = 1.1, sample = 2, },
  { rate = 1.0, start = 30.32, len = 1.1, sample = 2, },
  { rate = 1.0, start = 31.47, len = 1.1, sample = 2, },
  { rate = 2.0, start = 31.47, len = 1.1, sample = 2, },
  { rate = 1.0, start = 32.62, len = 1.1, sample = 2, },
  { rate = 2.0, start = 32.55, len = 0.86000000000002, sample = 2, },
  { rate = 1.0, start = 32.55, len = 0.86000000000002, sample = 2, },
  { rate = 2.0, start = 38.91, len = 2.41, sample = 2, },
  { rate = 1.0, start = 41.77, len = 5.57, sample = 2, },
  { rate = 2.0, start = 46.96, len = 5.25, sample = 2, },
  { rate = 1.0, start = 47.64, len = 1.19, sample = 2, },
  { rate = 1.0, start = 54.31, len = 3.49, sample = 2, },
  { rate = 2.0, start = 59.28, len = 6.3300000000001, sample = 2, },
  { rate = 0.5, start = 66.090000000001, len = 5.5900000000001, sample = 2, },
  { rate = 1.0, start = 82.350000000002, len = 7.8100000000001, sample = 2, },
  { rate = 1.0, start = 100.91, len = 6.6800000000001, sample = 2, },
  { rate = 1.0, start = 103.69, len = 3.8100000000001, sample = 2, },
  { rate = 1.0, start = 111.17000000001, len = 4.9000000000001, sample = 2, },
  { rate = 1.0, start = 119.18000000001, len = 5.8500000000001, sample = 2, },
  { rate = 2.0, start = 119.18000000001, len = 5.8500000000001, sample = 2, },
  { rate = 1.0, start = 128.32000000001, len = 0.38000000000008, sample = 2, },
  { rate = 1.0, start = 133.67000000001, len = 0.010000000000083, sample = 2, },
  { rate = 1.0, start = 126.24000000001, len = 0.010000000000083, sample = 2, },
  { rate = 1.0, start = 125.49000000001, len = 0.010000000000083, sample = 2, },
  { rate = 1.0, start = 121.79000000001, len = 0.010000000000083, sample = 2, },
  { rate = 1.0, start = 113.14000000001, len = 0.010000000000083, sample = 2, },
  { rate = 1.0, start = 111.99000000001, len = 0.010000000000083, sample = 2, },
  { rate = 1.0, start = 112.12000000001, len = 0.18000000000008, sample = 2, },
  { rate = 2.0, start = 89.460000000004, len = 0.37000000000008, sample = 2, },
  { rate = 2.0, start = 83.210000000004, len = 0.32000000000008, sample = 2, },
  { rate = 1.0, start = 80.950000000004, len = 0.60000000000008, sample = 2, },
  { rate = 2.0, start = 80.710000000003, len = 0.60000000000008, sample = 2, },
  { rate = 1.0, start = 80.710000000003, len = 0.60000000000008, sample = 2, },
  { rate = 1.0, start = 78.970000000003, len = 0.73000000000008, sample = 2, },
  { rate = 1.0, start = 75.100000000003, len = 1.3200000000001, sample = 2, },
  { rate = 2.0, start = 72.180000000002, len = 1.3200000000001, sample = 2, },
  { rate = 2.0, start = 69.780000000002, len = 1.3200000000001, sample = 2, },
  { rate = 1.0, start = 68.680000000002, len = 1.4300000000001, sample = 2, },
  { rate = 1.0, start = 68.360000000002, len = 1.1800000000001, sample = 2, },
  { rate = 1.0, start = 68.360000000002, len = 1.1800000000001, sample = 2, },
  { rate = 1.0, start = 53.170000000002, len = 1.1700000000001, sample = 2, },
  { rate = 2.0, start = 47.860000000002, len = 1.3200000000001, sample = 2, },
  { rate = 1.0, start = 46.490000000002, len = 0.92000000000008, sample = 2, },
  { rate = 1.0, start = 45.480000000002, len = 0.92000000000008, sample = 2, },
  { rate = 1.0, start = 40.820000000002, len = 0.20000000000008, sample = 2, },
  { rate = 2.0, start = 31.150000000002, len = 1.6700000000001, sample = 2, },
  { rate = 1.0, start = 31.150000000002, len = 1.6700000000001, sample = 2, },
  { rate = 1.0, start = 29.510000000002, len = 1.6700000000001, sample = 2, },
  { rate = 2.0, start = 26.310000000002, len = 1.9800000000001, sample = 2, },
  { rate = 1.0, start = 22.800000000002, len = 1.9800000000001, sample = 2, },
  { rate = 1.0, start = 20.420000000002, len = 1.9800000000001, sample = 2, },
  { rate = 2.0, start = 18.360000000002, len = 0.44000000000008, sample = 2, },
  { rate = 2.0, start = 8.1300000000017, len = 0.42000000000008, sample = 2, },
  { rate = 1.0, start = 5.1600000000017, len = 0.42000000000008, sample = 2, },
  { rate = 2.0, start = 5.1600000000017, len = 0.42000000000008, sample = 2, },
  { rate = 1.0, start = 0.29000000000168, len = 0.42000000000008, sample = 2, },
  { rate = 1.0, start = 0.29000000000168, len = 0.42000000000008, sample = 2, },
}

collection2 = {
  { rate = 0.25, start = 0.59, len = 12.64, sample = 1, },
  { rate = 0.25, start = 5.01, len = 23.03, sample = 1, },
  { rate = 0.25, start = 5.01, len = 23.03, sample = 1, },
  { rate = 0.5, start = 9.46, len = 8.8499999999998, sample = 1, },
  { rate = 0.25, start = 9.46, len = 8.8499999999998, sample = 1, },
  { rate = 0.5, start = 107.94, len = 1.3699999999998, sample = 1, },
  { rate = 0.5, start = 108.91, len = 2.2299999999998, sample = 1, },
  { rate = 0.25, start = 111.62, len = 3.8799999999998, sample = 1, },
  { rate = 0.5, start = 118.37, len = 1.4099999999998, sample = 1, },
  { rate = 0.5, start = 110.92, len = 1.1799999999998, sample = 1, },
  { rate = 0.5, start = 150.11, len = 3.2899999999998, sample = 1, },
  { rate = 0.5, start = 152.95, len = 5.0699999999998, sample = 1, },
  { rate = 0.5, start = 156.94000000001, len = 6.8399999999998, sample = 1, },
  { rate = 0.25, start = 156.17000000001, len = 7.2199999999998, sample = 1, },
}

collection3 = {
  { rate = 1.0, start = 26.55, len = 0.21999999999977, sample = 1, },
  { rate = 0.5, start = 26.55, len = 0.22999999999977, sample = 1, },
  { rate = 1.0, start = 26.4, len = 1.0599999999998, sample = 1, },
  { rate = 1.0, start = 27.87, len = 2.4099999999998, sample = 1, },
  { rate = 1.0, start = 33.27, len = 2.4099999999998, sample = 1, },
  { rate = 1.0, start = 35.14, len = 1.3599999999998, sample = 1, },
  { rate = 1.0, start = 34.5, len = 0.039999999999769, sample = 1, },
  { rate = 1.0, start = 32.69, len = 0.039999999999769, sample = 1, },
  { rate = 0.5, start = 31.61, len = 0.53999999999977, sample = 1, },
  { rate = 1.0, start = 31.07, len = 0.53999999999977, sample = 1, },
  { rate = 0.5, start = 30.52, len = 0.53999999999977, sample = 1, },
  { rate = 1.0, start = 30.65, len = 0.53999999999977, sample = 1, },
  { rate = 1.0, start = 30.87, len = 0.53999999999977, sample = 1, },
  { rate = 1.0, start = 30.9, len = 0.53999999999977, sample = 1, },
  { rate = 1.0, start = 29.44, len = 0.53999999999977, sample = 1, },
  { rate = 1.0, start = 30.71, len = 0.53999999999977, sample = 1, },
  { rate = 1.0, start = 31.66, len = 1.1299999999998, sample = 1, },
  { rate = 1.0, start = 31.27, len = 1.1299999999998, sample = 1, },
  { rate = 0.5, start = 37.75, len = 0.68999999999977, sample = 1, },
  { rate = 0.5, start = 38.41, len = 0.85999999999977, sample = 1, },
  { rate = 0.5, start = 39.8, len = 0.85999999999977, sample = 1, },
  { rate = 0.25, start = 42.45, len = 0.85999999999977, sample = 1, },
  { rate = 0.5, start = 44.75, len = 0.25999999999977, sample = 1, },
  { rate = 0.5, start = 49.78, len = 0.25999999999977, sample = 1, },
  { rate = 1.0, start = 49.78, len = 0.25999999999977, sample = 1, },
  { rate = 0.5, start = 55.05, len = 0.25999999999977, sample = 1, },
  { rate = 0.5, start = 56.38, len = 0.25999999999977, sample = 1, },
  { rate = 0.5, start = 56.38, len = 0.25999999999977, sample = 1, },
  { rate = 0.5, start = 56.51, len = 0.25999999999977, sample = 1, },
  { rate = 0.5, start = 56.95, len = 0.25999999999977, sample = 1, },
  { rate = 0.5, start = 60.09, len = 0.25999999999977, sample = 1, },
  { rate = 0.5, start = 65.45, len = 0.25999999999977, sample = 1, },
  { rate = 0.5, start = 66.05, len = 0.25999999999977, sample = 1, },
  { rate = 0.5, start = 67.63, len = 0.25999999999977, sample = 1, },
  { rate = 0.5, start = 73.040000000001, len = 0.25999999999977, sample = 1, },
  { rate = 0.5, start = 76.140000000001, len = 0.25999999999977, sample = 1, },
  { rate = 0.5, start = 82.560000000002, len = 0.18999999999977, sample = 1, },
  { rate = 0.5, start = 83.720000000002, len = 0.18999999999977, sample = 1, },
  { rate = 0.5, start = 82.940000000002, len = 0.18999999999977, sample = 1, },
  { rate = 0.5, start = 89.030000000003, len = 0.18999999999977, sample = 1, },
  { rate = 0.5, start = 87.600000000002, len = 0.17999999999977, sample = 1, },
  { rate = 0.5, start = 89.990000000003, len = 1.4099999999998, sample = 1, },
  { rate = 0.5, start = 93.500000000003, len = 1.4099999999998, sample = 1, },
  { rate = 0.5, start = 92.180000000003, len = 2.3799999999998, sample = 1, },
  { rate = 1.0, start = 93.850000000003, len = 0.88999999999977, sample = 1, },
  { rate = 1.0, start = 98.430000000003, len = 1.5199999999998, sample = 1, },
}

collection4 = {
  { rate = 0.25, start = 114.44, len = 1.9899999999998, sample = 1, },
  { rate = 0.25, start = 115.59, len = 1.7599999999998, sample = 1, },
  { rate = 0.5, start = 123.05000000001, len = 1.0499999999998, sample = 1, },
  { rate = 0.5, start = 124.98000000001, len = 0.22999999999977, sample = 1, },
  { rate = 0.5, start = 128.05000000001, len = 0.42999999999978, sample = 1, },
  { rate = 0.5, start = 131.71000000001, len = 0.15999999999977, sample = 1, },
  { rate = 0.5, start = 131.03000000001, len = 0.15999999999977, sample = 1, },
  { rate = 0.5, start = 130.85000000001, len = 0.15999999999977, sample = 1, },
  { rate = 0.5, start = 130.82, len = 0.15999999999977, sample = 1, },
  { rate = 0.5, start = 131.19, len = 0.30999999999977, sample = 1, },
  { rate = 0.5, start = 133.85000000001, len = 0.30999999999977, sample = 1, },
  { rate = 0.5, start = 137.49, len = -0.15000000000023, sample = 1, },
  { rate = 0.5, start = 140.08000000001, len = 0.66999999999978, sample = 1, },
  { rate = 0.5, start = 140.13000000001, len = -0.010000000000225, sample = 1, },
  { rate = 0.5, start = 146.25000000001, len = 0.30999999999977, sample = 1, },
}

collection5 = {
  { rate = 1.0, start = 38.03, len = 1.4399999999995, sample = 3, },
  { rate = 1.0, start = 40.39, len = -0.080000000000477, sample = 3, },
  { rate = 1.0, start = 41.6, len = 0.39999999999952, sample = 3, },
  { rate = 1.0, start = 42.16, len = 0.23999999999952, sample = 3, },
  { rate = 1.0, start = 42.31, len = 0.38999999999952, sample = 3, },
  { rate = 1.0, start = 46.72, len = 0.31999999999952, sample = 3, },
  { rate = 1.0, start = 47.67, len = 0.31999999999952, sample = 3, },
  { rate = 1.0, start = 48.84, len = 0.30999999999952, sample = 3, },
  { rate = 1.0, start = 47.34, len = 0.40999999999952, sample = 3, },
  { rate = 1.0, start = 48.8, len = 0.079999999999523, sample = 3, },
  { rate = 1.0, start = 50.48, len = 1.0499999999995, sample = 3, },
  { rate = 1.0, start = 54.63, len = 2.2099999999995, sample = 3, },
  { rate = 1.0, start = 57.08, len = 1.1399999999995, sample = 3, },
  { rate = 1.0, start = 62.01, len = 0.33999999999953, sample = 3, },
  { rate = 1.0, start = 64.25, len = -0.43000000000047, sample = 3, },
  { rate = 1.0, start = 64.05, len = -0.43000000000047, sample = 3, },
  { rate = 1.0, start = 66.12, len = -0.51000000000047, sample = 3, },
  { rate = 1.0, start = 68.28, len = 0.81999999999953, sample = 3, },
  { rate = 1.0, start = 73.540000000001, len = 0.55999999999953, sample = 3, },
}

collection6 = {
  { rate = 1.0, start = 183.39, len = 1.8599999999994, sample = 3, },
  { rate = 1.0, start = 182.21, len = 1.1999999999994, sample = 3, },
  { rate = 0.5, start = 181.85, len = 1.6299999999994, sample = 3, },
  { rate = 1.0, start = 182.25, len = 0.58999999999945, sample = 3, },
  { rate = 1.0, start = 182.08, len = 0.70999999999945, sample = 3, },
  { rate = 1.0, start = 182.69, len = 0.60999999999945, sample = 3, },
  { rate = 1.0, start = 182.69, len = 0.60999999999945, sample = 3, },
  { rate = 0.5, start = 181.55, len = 0.91999999999945, sample = 3, },
  { rate = 0.5, start = 183.17, len = 1.1799999999994, sample = 3, },
  { rate = 2.0, start = 181.72, len = 1.9899999999994, sample = 3, },
  { rate = 2.0, start = 181.8, len = 0.64999999999945, sample = 3, },
  { rate = 2.0, start = 182.39, len = 0.80999999999945, sample = 3, },
  { rate = 2.0, start = 181.71, len = 1.1799999999994, sample = 3, },
  { rate = 1.0, start = 182.94, len = 2.2899999999995, sample = 3, },
  { rate = 1.0, start = 181.81, len = 2.0499999999995, sample = 3, },
  { rate = 1.0, start = 182.26, len = 2.0399999999995, sample = 3, },
  { rate = 2.0, start = 212.82, len = 0.63999999999947, sample = 3, },
  { rate = 2.0, start = 214.33, len = 0.46999999999947, sample = 3, },
  { rate = 2.0, start = 214.92, len = 0.24999999999947, sample = 3, },
  { rate = 2.0, start = 215.8, len = 1.1399999999995, sample = 3, },
  { rate = 1.0, start = 214.88, len = 0.45999999999947, sample = 3, },
  { rate = 2.0, start = 214.21, len = 0.54999999999947, sample = 3, },
  { rate = 1.0, start = 211.87, len = 0.29999999999947, sample = 3, },
  { rate = 2.0, start = 212.47, len = 0.93999999999947, sample = 3, },
  { rate = 2.0, start = 214.31, len = 0.44999999999947, sample = 3, },
}

collection1_1 = {}
collection1_2 = {}

for i,v in ipairs(collection1) do
  if v.rate <= 1 then
    table.insert(collection1_1, v)
  else
    table.insert(collection1_2, v)
  end
end

collection2_1 = {}
collection2_2 = {}

for i,v in ipairs(collection2) do
  if v.rate < 0.5 then
    table.insert(collection2_1, v)
  else
    table.insert(collection2_2, v)
  end
end

collection3_1 = {}
collection3_2 = {}

for i,v in ipairs(collection3) do
  if v.rate <= 0.5 then
    table.insert(collection3_1, v)
  else
    table.insert(collection3_2, v)
  end
end

collection6_1 = {}
collection6_2 = {}

for i,v in ipairs(collection6) do
  if v.rate <= 1 then
    table.insert(collection6_1, v)
  else
    table.insert(collection6_2, v)
  end
end

function grand() 
    -- u = 1 - math.random()
    -- v = 1 - math.random()
    -- return math.sqrt( -2.0 * math.log( u ) ) * math.cos( 2.0 * math.pi * v )
    
  local D = 3
  x = 0
  for i=1,D do
    x = x + math.random()
  end
  return x*2 - D
end



function sploosh() -- make some new pasta
  local spag = {}
  local size = math.random(100) + 20
  offset = {
    origin = 0,
    volume = 0,
    pan = 0,
    slew = 0,
    brightness = 0,
    probability = 0,
    rate = 0
  }
  
  for i = 1, size do
    spag[i] = {}
    
    for k,v in pairs(offset) do
      spag[i][k] = grand()
    end
  end
  
  return spag
end

voice = {
  n = 1,
  collection = {},
  origin = 1,
  volume = 1,
  pan = 0,
  brightness = 1,
  density = 0,
  changer = {},
  slew = 0.2,
  rate = 0.2,
  spaghetti = {},
  rate_mult = 1,
  samp_offset = 0,
  buffer = 1
}

function voice:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  
  o.offset = {
    origin = 0,
    volume = 0,
    pan = 0,
    brightness = 0,
    slew = 0,
    rate = 0
  }
  
  return o
end

location = 1

function changer1(index, wrld, vc)
  local i = 1
  
  scalefactor = {
    origin = 3,
    volume = 0.1,
    pan = 0.1,
    brightness = 0.1,
    slew = 0.1,
    rate = 0.2
  }
  
  return function()
    if location == index then
      local spaghetto = vc.spaghetti[(i % #vc.spaghetti) + 1]
      
      if math.abs(spaghetto.probability / 3) < vc.density then
        for k,v in pairs(vc.offset) do
          vc.offset[k] = spaghetto[k] * scalefactor[k] * (0.5 + vc.density / 2)
        end
        
      else
        vc.offset = {
          origin = 0,
          volume = 0,
          pan = 0,
          brightness = 0,
          slew = 0,
          rate = 0
        }
      end
      
      i = (i < #vc.spaghetti) and i + 1 or 1
      
      upd8(wrld)
    end
  end
end

wrlds = {
  {
    voice:new{ 
      n = 1,
      collection = collection1_1,
      rate_mult = 1,
      volume = 0.7
    },
    voice:new{ 
      n = 2,
      collection = collection1_2,
      volume = 0.15
    },
    voice:new{ 
      n = 3,
      collection = collection1_1,
      rate_mult = 0.5,
      volume = 0.3
    },
    voice:new{ 
      n = 4,
      collection = collection2,
      rate_mult = 0.5,
      volume = 0.01,
      brightness = 0.5,
      buffer = 2
    },
  },
  {
    voice:new{ 
      n = 1,
      collection = collection3_1,
      rate_mult = 1,
      volume = 0.4
    },
    voice:new{ 
      n = 2,
      collection = collection3_2,
      volume = 0.4,
      rate_mult = 0.5
    },
    voice:new{ 
      n = 1,
      collection = collection2_1,
      rate_mult = 1,
      volume = 0.4
    },
    -- voice:new{ 
    --   n = 1,
    --   collection = collection4,
    --   rate_mult = 1,
    --   volume = 0.2
    -- },
  },
  {
    voice:new{ 
      n = 1,
      collection = collection5,
      rate_mult = 0.5
    },
    voice:new{ 
      n = 2,
      collection = collection6_1,
      volume = 1
    },
    voice:new{ 
      n = 3,
      collection = collection6_2,
      volume = 1
    },
    voice:new{ 
      n = 4,
      collection = collection2,
      rate_mult = 0.5,
      volume = 0.01,
      brightness = 0.5,
      buffer = 2
    }
  }
}

wrlds[1][1].changer = metro.init(changer1(1, wrlds[1], wrlds[1][1]), 0.7)
wrlds[1][2].changer = metro.init(changer1(1, wrlds[1], wrlds[1][2]), 0.15)
wrlds[1][3].changer = metro.init(changer1(1, wrlds[1], wrlds[1][3]), 1)
wrlds[1][4].changer = metro.init(changer1(1, wrlds[1], wrlds[1][4]), 2)

wrlds[2][1].changer = metro.init(changer1(2, wrlds[2], wrlds[2][1]), 0.5)
wrlds[2][2].changer = metro.init(changer1(2, wrlds[2], wrlds[2][2]), 0.3)
wrlds[2][3].changer = metro.init(changer1(2, wrlds[2], wrlds[2][3]), 1)
-- wrlds[2][4].changer = metro.init(changer1(2, wrlds[2], wrlds[2][4]), 0.3)

wrlds[3][1].changer = metro.init(changer1(3, wrlds[3], wrlds[3][1]), 1.2)
wrlds[3][2].changer = metro.init(changer1(3, wrlds[3], wrlds[3][2]), 0.7)
wrlds[3][3].changer = metro.init(changer1(3, wrlds[3], wrlds[3][3]), 0.5)
wrlds[3][4].changer = metro.init(changer1(3, wrlds[3], wrlds[3][4]), 2)

function evolve(wrld)
  for i, v in ipairs(wrld) do
    v.origin = math.random(#v.collection)
    v.pan = (math.random()) - 1
    v.spaghetti = sploosh()
  end
end

function upd8(wrld)
  for i, v in ipairs(wrld) do
    local index = v.collection[(math.floor(v.origin + v.offset.origin) % #v.collection) + 1]
    
    softcut.rate(v.n, index.rate * v.rate_mult)
    softcut.loop_start(v.n, v.samp_offset + index.start)
    softcut.loop_end(v.n, v.samp_offset + index.start + index.len)
    
    softcut.rate_slew_time(v.n, math.abs(v.slew + v.offset.slew))
     softcut.rate_slew_time(v.n, v.buffer)
    
    if #wrld > 1 then
      if i == 1 then
        softcut.pan(v.n, util.clamp(-1,1,v.pan + v.offset.pan) / 2 - 0.5)
      elseif i == 2 then
        softcut.pan(v.n, util.clamp(-1,1,v.pan + v.offset.pan) / 2 + 0.5)
      end
    else
      softcut.pan(v.n, util.clamp(-1,1,v.pan + v.offset.pan))
    end
    
    softcut.buffer(v.n, v.buffer)
    
    softcut.post_filter_fc(v.n, math.abs(util.linexp(0, 1, 1, 15000, v.brightness - math.abs(v.offset.brightness))))
    softcut.level(v.n, math.abs(v.volume + v.offset.volume))
    
    v.changer.time = math.abs(v.rate + v.offset.rate)
  end
end

function loadsamp(wrld)
    sample = wrld[1].collection[wrld[1].origin].sample
  
    local file = _path.code .. "nc01-drone/lib/" .. samples[sample] .. ".wav"
    softcut.buffer_read_mono(file,0,0,-1,1,1)
    
    local file = _path.code .. "nc01-drone/lib/" .. samples[1] .. ".wav"
    softcut.buffer_read_mono(file,0,0,-1,1, 2)
end

function init()
  for i,wrld in ipairs(wrlds) do
    for j, voice in ipairs(wrld) do
      local n = voice.n
      
      softcut.enable(n,1)
      softcut.buffer(n,1)
      softcut.level(n,1.0)
      softcut.loop(n,1)
      softcut.position(n,1)
      softcut.play(n,1)
      softcut.rate_slew_time(n, slew)
      
      softcut.post_filter_rq(n, 0.4)
      softcut.post_filter_dry(n, 0)
      softcut.post_filter_lp(n, 1)
      
      voice.changer:start()
      voice.spaghetti = sploosh()
    end
    
    evolve(wrld)
  end
  
  local wrld = wrlds[location]
  
  evolve(wrld)
  upd8(wrld)
  loadsamp(wrld)
end

function enc(n, d)
  if n == 1 then
    for i, v in ipairs(wrlds[location]) do
      v.volume = v.volume >= 0 and v.volume + (d * 0.01) or 0
    end
  elseif n == 2 then
    for i, v in ipairs(wrlds[location]) do
      v.brightness = v.brightness >= 0 and util.clamp(0,1,v.brightness + (d * 0.01)) or 0
    end
  elseif n == 3 then
   for i, v in ipairs(wrlds[location]) do
      v.density = v.density >= 0 and util.clamp(0,1,v.density + (d * 0.01)) or 0
    end
  end
  
  upd8(wrlds[location])
end

keydown = { 0, 0, 0 }

function key(n, z)
  if z == 1 then
    if n == 2 then
      evolve(wrlds[location])
    elseif n == 3 then
      location = (location % #wrlds) + 1
      
      upd8(wrlds[location])
      loadsamp(wrlds[location])
    end  
  end
  
  keydown[n] = z
  
  upd8(wrlds[location])
end

rotation = 0
step = math.pi * 2 / 100

sep = 8
function redraw()
  screen.clear()
  local v = wrlds[location][1]
    
  screen.level(15)
  screen.move(4, sep)
  screen.text("wrld " .. tostring(location))
  
  screen.level(keydown[2] * 12 + 4)
  screen.move(4, sep * 2)
  screen.text("evolve")
  
  screen.level(16)
  for i,w in ipairs({ "volume", "brightness", "density" }) do
    screen.move(4, (i + 3) * sep)
    screen.text(w .. " " .. tostring(v[w]))
  end
  
  local of = v.offset
  
  local things = {of.origin, of.volume, of.pan, of.slew, of.brightness, of.rate }
  local r = 26
  local o = { 100, 22 }
  
  screen.level(10)
  for i,v in ipairs(things) do
    
    local nr = r * (things[i] + 0.7)
    local x1 = math.cos(((i + rotation) / 6) * 2 * math.pi) * nr + o[1]
    local y1 = math.sin(((i + 0.2) / 6) * 2 * math.pi) * (nr - 2) + o[2]
    
    
    local nr = r * (things[(i % 6) + 1] + 0.7)
    local x2 = math.cos(((i + 1 + rotation) / 6) * 2 * math.pi) * nr + o[1]
    local y2 = math.sin(((i + 1 + rotation) / 6) * 2 * math.pi) * (nr - 2) + o[2]
    
    if location == 1 then
      screen.move(x1, y1)
      screen.line(x2, y2)
      step =  math.pi * 2 / 100 / 2
    elseif location == 2 then 
      screen.arc(x1,y1,nr,x2,y2)
      step =  - math.pi * 2 / 80 / 6
    elseif location == 3 then 
      screen.curve(y1, x1, (x1 + x2) / 2, (y1 + y2) / 2, x2, y2)
      step =  math.pi * 2 / 50 / 3
    end
    
    screen.stroke()
  end
  
  rotation = rotation + step
  
  screen.update()
end

re = metro.init(function() redraw() end,  1/60)
re:start()
