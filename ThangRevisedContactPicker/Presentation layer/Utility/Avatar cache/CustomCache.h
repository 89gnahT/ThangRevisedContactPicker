//
//  CustomCache.h
//  ThangRevisedContactPicker
//
//  Created by Thang on 11/7/2019.
//  Copyright © 2019 ThangNVH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomCache : NSCache

+(instancetype)sharedInstance;

-(UIImage *)getImageWithID:(NSString *)identifier;

-(void)setImage:(UIImage *)label withIdentifier:(NSString*)identifier;

@end

NS_ASSUME_NONNULL_END
