
isLeapYear = function(year)
        --- Returns if integer year is a leapYear
        return year % 4 == 0 and (year % 25 ~= 0 or year % 16 == 0)
end

GetLeaps = function(year)
        --- Returns the number of LeapYears in a given amount of years
	return math.floor(year/4) - math.floor(year/100) + math.floor(year/400)
end

CountDays = function(year)
        --- Returns the number of days in a given number of years
	return 365*year + GetLeaps(year)
end

GetYearFromSeconds = function(seconds)
        --- Returns the Year from seconds
        -- 86400 is the number of seconds per day
        
        local year, month
        local overflow = function(array, seed)
                --- This subtracts seed from the values in array and
                -- @return the index of the value it overflowed over and the remainder of seed
		for i = 1, #array do
			if seed - array[i] <= 0 then
				return i, seed
			end
			seed = seed - array[i]
		end
	end
        local ceil, floor       = math.floor, math.ceil
        local days              = ceil(seconds / 86400) + CountDays(1970)
        
        local _400Years         = 400*floor(days / CountDays(400))
        local _100Years         = 100*floor(days % CountDays(400) / CountDays(100))
        local _4Years           =   4*floor(days % CountDays(400) % CountDays(100) / CountDays(4))
        
        year, days              = overflow({366,365,365,365}, days - CountDays(_4Years + _100Years + _400Years)) -- [0-1461]
        -- days is number days into the year
        year                    = year + _4Years + _100Years + _400Years - 1
        month, days	        = overflow({31,isLeapYear(year) and 29 or 28,31,30,31,30,31,31,30,31,30,31}, days)
        
	
	return year, month, days
end
