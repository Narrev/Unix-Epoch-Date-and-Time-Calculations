-- Time functions 
local floor, ceil = math.floor, math.ceil

isLeapYear = function(year)
        --- Returns if integer year is a leapYear
        return year % 4 == 0 and (year % 25 ~= 0 or year % 16 == 0)
end

GetLeaps = function(year)
        --- Returns the number of Leap days in a given amount of years
	return floor(year/4) - floor(year/100) + floor(year/400)
end

CountDays = function(year)
        --- Returns the number of days in a given number of years
	return 365*year + GetLeaps(year)
end

CountDays2 = function(year)
	--- Returns the number of days in a given number of years NOT including this year's leap year
	return 365*year + GetLeaps(year - 1)	
end

local overflow = function(array, seed)
        --- Subtracts the integer values in an array from a seed until the seed cannot be subtracted from any further (aka "overflow")
	-- @param array array A table filled with integers to be subtracted from seed
	-- @param integer seed A seed that is subtracted by the values in array until it would become negative from subtraction
	-- @returns index at which the iterated value is greater than the remaining seed and remainder of seed (before subtracting final value)

	for i = 1, #array do
		if seed - array[i] <= 0 then
			return i, seed
		end
		seed = seed - array[i]
	end
end

GetYMDFromSeconds = function(seconds)
        --- Returns the Year, Month, and Days, from seconds since 1970
        -- @param number seconds The amount of seconds since January 1st, 1970
        
	-- 86400 is the number of seconds per day
	
	-- We add 1 second below because when dividing by 86400, any multiple of 86400 will return an integer
	-- which will not be rounded up by ceil (because it is an integer).
	-- In other words, if it is 12:00am, we need to go to the next day
	
        local days              = ceil((seconds + 1) / 86400) + CountDays(1970)
        
        -- Each of the following caculations gets the next bracket of years we are in
        -- It's similar to converting from base x to base 10, except the number's places are worth 400, 100, 4, 1
        local _400Years         = 400*floor(days / CountDays(400))
        local _100Years         = 100*floor(days % CountDays(400) / CountDays(100))
        local _4Years           =   4*floor(days % CountDays(400) % CountDays(100) / CountDays(4))
        
        -- Declare local variables
        local _1Years, month
        
        -- days is number days into the current year (this would be considered "ydays" in os.date) 
        _1Years, days		= overflow({366,365,365,365}, days - CountDays2(_4Years + _100Years + _400Years)) -- [0-1461]
        
        
        -- We subtract 1 because function overflow returns 1 if you are already in the correct year
	_1Years			= _1Years - 1
        
        -- Add the year brackets together, get the year
        local year		= _1Years + _4Years + _100Years + _400Years
        
        -- Now find the month and number of days into the month
        month, days	        = overflow({31,isLeapYear(year) and 29 or 28,31,30,31,30,31,31,30,31,30,31}, days)
        
	return year, month, days
end

GetTimeFromSeconds = function(seconds)
	--- Return hours, minutes, and seconds from seconds since 1970
	local hours	= floor(seconds / 3600 % 24)
	local minutes	= floor(seconds / 60 % 60)
	local seconds	= floor(seconds % 60)
	
	return hours, minutes, seconds
end
