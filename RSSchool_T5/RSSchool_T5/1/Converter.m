#import "Converter.h"

// Do not change
NSString *KeyPhoneNumber = @"phoneNumber";
NSString *KeyCountry = @"country";

 
@implementation PNConverter
- (NSDictionary*)converToPhoneNumberNextString:(NSString*)string {
    
    NSString *countryName = @"";
    NSString *countryCode = @"";
    NSString *convertredPhone = @"";
    if (string.length != 0) {
        NSArray *data = [PNConverter getCountryByPhoneNumber: string];
        countryName = data[0];
        countryCode = data[1];
        convertredPhone = [PNConverter convertPhone: string withCountryCode: countryCode];
    }
    
    return @{KeyPhoneNumber: convertredPhone,
             KeyCountry: countryName};
}


+ (NSArray*) getCountryByPhoneNumber: (NSString*)string {
    
    NSDictionary *countryKey = @{ @"" : @"",
                                  @"7" : @"RU",
                                  @"373" : @"MD",
                                  @"374" : @"AM",
                                  @"375" : @"BY",
                                  @"380" : @"UA",
                                  @"992" : @"TJ",
                                  @"993" : @"TM",
                                  @"994" : @"AZ",
                                  @"996" : @"KG",
                                  @"998" : @"UZ",
                                 
    };
    NSString *res = @"";
    NSString *countryCodeSubstring = [string substringToIndex: 1];
    NSString *resCode = @"";
    if ([countryKey.allKeys containsObject: countryCodeSubstring]) {
        res = countryKey[countryCodeSubstring];
        resCode = countryCodeSubstring;
    }
    if (string.length >= 3) {
        countryCodeSubstring = [string substringToIndex: 3];
        res = [countryKey.allKeys containsObject: countryCodeSubstring]? countryKey[countryCodeSubstring] : res;
        resCode = [countryKey.allKeys containsObject: countryCodeSubstring]? countryCodeSubstring : resCode;
    }
    if (string.length >= 2) {
        if ([res isEqualToString: @"RU"] && [[string substringToIndex: 2] isEqualToString: @"77"]) {
            res = @"KZ";
        }
    }
    if (![countryKey.allKeys containsObject: countryCodeSubstring]) {
        countryCodeSubstring = @"";
    }
    return @[res, resCode];
}


+ (NSString*) convertPhone:(NSString*) number withCountryCode:(NSString*) code{
    
    //NSString *nubberCopy = number.copy;
    NSString *res = number;
    if (number.length > 14 || [code isEqualToString: @""] ) {
        if (![[res substringToIndex:1] isEqualToString: @"+"]) {
            res = [@"+" stringByAppendingString: [res substringToIndex: MIN(12, number.length)]];
        }
        else
        {
            res = [res substringToIndex: MIN(13, number.length)];
        }
        
        return res;
    }
    
    NSDictionary *countryNeedestPhoneLength = @{
                                  @"7" : @10,
                                  @"373" : @8,
                                  @"374" : @8,
                                  @"375" : @9,
                                  @"380" : @9,
                                  @"992" : @9,
                                  @"993" : @8,
                                  @"994" : @9,
                                  @"996" : @9,
                                  @"998" : @9
    };
    
    NSInteger phoneLendth = [countryNeedestPhoneLength[code] integerValue];
    if (number.length > code.length) {
        number = [number substringFromIndex: code.length];
        res = [code stringByAppendingString: @" ("];
        NSInteger opLength = phoneLendth == 10? 3 : 2;
        opLength = MIN(number.length, opLength);
        NSString *operator = [number substringToIndex: opLength];
        number = [number substringFromIndex: opLength];
        res = [@"+" stringByAppendingString: [res stringByAppendingString:operator] ];
        res = (opLength >= 2 && number.length > 0) ? [res stringByAppendingString:@")"] : res;
        res = number.length > 0 ? [res stringByAppendingString:@" "] : res;
        res = [res stringByAppendingString: [number substringToIndex:MIN(3, number.length)]];
        if (number.length > 3) {
            number = [number substringFromIndex: 3];
            NSInteger secondPart = phoneLendth == 8? 3 : 2;
            res = [[res stringByAppendingString:@"-"] stringByAppendingString: [number substringToIndex: MIN(number.length, secondPart)]];
            number = [number substringFromIndex:MIN(number.length, secondPart)];
            if (number.length != 0 && phoneLendth != 8) {
                number = [number substringToIndex: MIN(2, number.length)];
                res = [[res stringByAppendingString:@"-"] stringByAppendingString: number];
            }
        }
        
        return res;
    }
    
    return [@"+" stringByAppendingString: res];
}


@end
