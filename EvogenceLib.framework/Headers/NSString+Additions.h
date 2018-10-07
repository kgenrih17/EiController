//
//  NSString+Additions.h
//  Tiles
//

#import <Foundation/Foundation.h>


@interface NSString (Additions)

-(void)drawCenteredInRect:(CGRect)rect withFont:(UIFont *)font;
-(NSString*)stringBetweenString:(NSString*)start andString:(NSString*)end;

+(NSString*)valueOrEmptyString:(NSString*)_value;
+(NSString*)valueOrSpecialEmptyString:(NSString*)_value;

+(BOOL)compareStrings:(NSString*)_firstString secondString:(NSString*)_secondString;
+(NSString*)intSizeFileToString:(unsigned long long int)_sizeByte;
+(NSString*)getStringFromDate:(NSDate*)date dateFormate:(NSString*)dateFormate forLocal:(NSString*)localString;

-(NSString*)codeSpecialCharacters;
-(NSString*)decodeSpecialCharacters;

-(NSString*)md5;
+(NSString*)md5Hash:(NSString*)_concat;

-(id)json;

-(BOOL)isLink;
-(BOOL)isEmpty;

-(NSString*)valueOrNA;

-(BOOL)isValidName;
-(NSString*)getAsPhoneNumber;
-(NSString*)extractNumber;

// return in the format hh:mm
+(NSString*)convertSecondsToTime:(NSInteger)seconds byFormat:(NSString*)format;
+(NSString*)hourClockFormat:(NSInteger)seconds;

@end
