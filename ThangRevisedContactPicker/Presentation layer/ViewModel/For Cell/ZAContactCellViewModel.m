//
//  ZAContactCellViewModel.m
//  ThangRevisedContactPicker
//
//  Created by Thang on 10/7/2019.
//  Copyright © 2019 ThangNVH. All rights reserved.
//

#import "ZAContactCellViewModel.h"

@implementation ZAContactCellViewModel

- (instancetype)initWithContactPickerModel:(ZAContactModel *)model{
    self = [super init];
    if (self){
        _identifier  = model.identifier;
        _fullName    = [self generateFullNameWithZAContactModel:model];
        _nameInitial = [self generateInitialWithZAContactModel:model];
        _labelColor  = [self generateLabelColorWithNameInital:_nameInitial fullName:_fullName];
        //
    }
    return self;
}

- (NSString *)generateFullNameWithZAContactModel:(ZAContactModel*)model{
    NSString *firstName  = (model.firstName  == nil) ? @"" : model.firstName;
    NSString *middleName = (model.middleName == nil) ? @"" : model.middleName;
    NSString *lastName   = (model.lastName   == nil) ? @"" : model.lastName;
    NSString *nameSuffix = (model.nameSuffix == nil) ? @"" : model.nameSuffix;
    NSMutableString *tempFullName = [[NSMutableString alloc]init];
    if (([firstName isEqual:@""])&&([lastName isEqual:@""])&&([middleName isEqual:@""])&&([nameSuffix isEqual:@""])){
        //tempFullName = (NSMutableString *)model.phoneNumber;
        //tempFullName = (NSMutableString *)@"No Name";
        return model.phoneNumber;
    } else {
        tempFullName = [[NSMutableString alloc]initWithFormat:@"%@ %@ %@ %@",firstName,middleName,lastName,nameSuffix];
    }
    return [self reFormatString:tempFullName];
}

- (NSString*)generateInitialWithZAContactModel:(ZAContactModel*)model{
    NSString* firstName = (model.firstName == nil) ? @"" : model.firstName;
    NSString* lastName  = (model.lastName  == nil) ? @"" : model.lastName;
    if((![firstName isEqual: @""])&&(![lastName isEqual: @""])){
        return [NSString stringWithFormat:@"%c%c",[firstName characterAtIndex:0],[lastName characterAtIndex:0]];
    }
    if(([firstName isEqual: @""])&&(![lastName isEqual: @""])){
        return [NSString stringWithFormat:@"%c",[lastName characterAtIndex:0]];
    }
    if((![firstName isEqual: @""])&&([lastName isEqual: @""])){
        return [NSString stringWithFormat:@"%c",[firstName characterAtIndex:0]];
    }
    return @"#";
}

-(UIColor*)generateLabelColorWithNameInital:(NSString*)nameInitial fullName:(NSString*)fullName{
    char firstChar,secondChar;
    if([nameInitial length]==1){
        firstChar = [nameInitial characterAtIndex:0];
    } else {
        firstChar = [nameInitial characterAtIndex:1];
    }
    if([fullName length]==0){
        secondChar = 'N';
    } else {
        secondChar = [fullName characterAtIndex:0];
    }
    float red = (firstChar*3 + secondChar*275) %256 /255.0;
    float green = (firstChar * secondChar) % 256 / 255.0;
    float blue = (firstChar % secondChar * 2019) % 256 / 255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:0.5];
}


-(NSString*)reFormatString:(NSString*)string{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"  +" options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *regExString = [regex stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, [string length]) withTemplate:@" "];;
    if ([regExString characterAtIndex:0]==' '){
        return [regExString substringWithRange:NSMakeRange(1, [regExString length]-1)];
    }
    return regExString;
}

@end
