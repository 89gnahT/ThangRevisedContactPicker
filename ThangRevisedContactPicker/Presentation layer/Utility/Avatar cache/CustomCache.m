//
//  CustomCache.m
//  ThangRevisedContactPicker
//
//  Created by Thang on 11/7/2019.
//  Copyright © 2019 ThangNVH. All rights reserved.
//

#import "CustomCache.h"

@interface CustomCache()

@property (nonatomic) NSCache *cacheStore;

@end


@implementation CustomCache

+ (instancetype)sharedInstance {
    static CustomCache *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cacheStore = [[NSCache alloc] init];
    }
    return self;
}

- (UIImage *)getImageWithID:(NSString *)identifier {
   // NSLog(@"%@",[self.cacheStore objectForKey:identifier]);
    return [self.cacheStore objectForKey:identifier];
}

- (void)setImage:(UIImage *)image withIdentifier:(NSString *)identifier {
    [self.cacheStore setObject:image forKey:identifier];
    //NSLog(@"cache set %@",[self.cacheStore objectForKey:identifier] );
}

@end
