//
//  MLNote.m
//  NoteProject
//
//  Created by liby on 2018/6/12.
//  Copyright © 2018年 liby. All rights reserved.
//

#import "MLNote.h"


@implementation MLBaseNoteModel
{
    NSString *_UUID;
    NSDate *_date;
}
- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        self.titleName = title;
        _UUID = [[NSUUID UUID] UUIDString];
        _date = [NSDate date];
    }
    return self;
}
- (NSString *)createTime {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    if (_date.isToday) {
        fmt.dateFormat = @"HH:mm";
    } else {
        fmt.dateFormat = @"yy/MM/dd";
    }
    return [fmt stringFromDate:_date];
}

@end

@implementation MLNote

@end


@implementation MLNoteBook
- (NSMutableArray <MLNote *>*)noteArr{
    if (!_noteArr) {
        _noteArr = [NSMutableArray array];
    }
    return _noteArr;
}
- (MLNote *)addNote:(MLNote *)model {
    model.parentUUID = self.UUID;
    [self.noteArr addObject:model];
    return model;
}
- (MLNote *)removeNote:(MLNote *)model {
    [self.noteArr removeObject:model];
    model.parentUUID = nil;
    return model;
}
@end


@implementation MLNoteBookGroup
- (NSMutableArray <MLNoteBook *>*)noteBookArr{
    if (!_noteBookArr) {
        _noteBookArr = [NSMutableArray array];
    }
    return _noteBookArr;
}
- (MLNoteBook *)addNoteBook:(MLNoteBook *)model {
    model.parentUUID = self.UUID;
    [self.noteBookArr addObject:model];
    return model;
    
}
- (MLNoteBook *)removeNoteBook:(MLNoteBook *)model {
    [self.noteBookArr removeObject:model];
    model.parentUUID = nil;
    return model;
}
@end




