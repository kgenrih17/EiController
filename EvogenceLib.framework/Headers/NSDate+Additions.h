
static const NSInteger DAYS_PER_WEEK = 7;
static const NSInteger HOURS_PER_DAY = 24;

static const NSInteger FIRST_WEEK_DAY = 2; // monday
static const NSInteger LAST_WEEK_DAY = 8; // sunday
static const NSInteger WEEK_DAYS_PERIOD = LAST_WEEK_DAY - FIRST_WEEK_DAY;

@interface NSDate(Additions)
+(NSTimeInterval)getGMTSeconds;
+(NSDate*)GMTNow;
+(NSDate *)ConvertToGmt:(NSDate *)_sourceDate;
+(int)ConvertSecondToGmt:(int)_sourceDate;
-(NSDate *)DateByMovingToHour:(int)_hour minute:(int)_minute second:(int)_second;
-(NSDate *)DateByMovingToBeginningOfDay;
-(NSDate *)DateByMovingToEndOfDay;
-(NSDate *)DateByMovingToBeginningOfNextDay;
-(NSDate *)DateByMovingDateToDate:(NSDate *)_date; //переносит время на текущую дату
-(int)TimeInSecondsWithoutDate;		
+(int)TimeInSecondsWithoutDateWithTimeInterval:(int)_timeInterval;

-(int)dayOfWeek;
-(int)dayOfMonth;

-(NSInteger)gmtTimeIntervalSince1970;

+(NSDate*)dateWithGmtTimeIntervalSince1970:(NSInteger)_iterval;

// Get all the date components
-(NSDateComponents*)currentCalendarDateComponents;

// Days between
-(NSInteger)daysFromDate:(NSDate*)toDateTime;

// Day of the week in month
-(NSInteger)dayOfTheWeekInMonth;

// Set hours to begin and end of day
-(NSDate*)endOfDay;
-(NSDate*)beginOfDay;
-(NSDate*)beginOfMonth;
-(NSDate*)prepareDateToByMode:(NSInteger)_mode; // MONTH = 0, WEEK = 1, DAY = 2

// Transfer the length of time in seconds
+(NSString*)getDurectionOfSeconds:(NSInteger)_seconds;

// Days lenght between dates
-(NSInteger)getDaysLenghtBetween:(NSDate*)_endDate;

// Convenience formatter
-(NSString*)stringWithDateOnly;
-(NSString*)stringWithTimeOnly;

// Compare Dates
-(BOOL)isEqualDay:(NSDate*)date;
-(BOOL)isEqualTime:(NSDate*)date;

// Simplified creation date
+(NSDate*)createFromString:(NSString*)_stringDate withFormat:(NSString*)_format;
+(NSDate*)todayDateWithHour:(NSInteger)hour min:(NSInteger)min;
+(NSDate*)tomorrowDateWithHour:(NSInteger)hour min:(NSInteger)min;
+(NSDate*)yesterdayDateWithHour:(NSInteger)hour min:(NSInteger)min;

+(NSDate*)dateWithHour:(NSInteger)hour min:(NSInteger)min inDays:(NSInteger)daysModifier;

+(NSDate*)dateWithDateString:(NSString*)dateString;
+(NSDate*)dateWithTimeString:(NSString*)timeString;

@end
