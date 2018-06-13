//
//  NSDate+GetTimeStamp.h
//  NoteProject
//
//  Created by liby on 2018/6/12.
//  Copyright © 2018年 liby. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    PropertyTypeNote,
    PropertyTypeBook,
    PropertyTypeGroup,
} PropertyType;

@interface NSDate (GetTimeStamp)
+ (NSString *)getSingleIDWith:(PropertyType)type;
@end
