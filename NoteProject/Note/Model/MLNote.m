//
//  MLNote.m
//  NoteProject
//
//  Created by liby on 2018/6/12.
//  Copyright © 2018年 liby. All rights reserved.
//

#import "MLNote.h"


@implementation MLNoteBaseModel
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
{
    NSString *_content;
}

- (NSString *)content {
    if (_content) {
        return _content;
    }
    return _AttContent.string;
}

- (MLModelType)modelType {
    return MLModelNote;
}

@end


@implementation MLNoteBook
- (NSMutableArray *)noteArr{
    if (!_noteArr) {
        _noteArr = [NSMutableArray array];
    }
    return _noteArr;
}
- (MLModelType)modelType {
    return MLModelBook;
}
- (BOOL)isContainNote {
    return self.noteArr.count;
}
- (MLNote *)addNote:(MLNote *)model {
//    model.parentUUID = self.UUID;
//    [self.noteArr addNoteModel:model];
    [self.noteArr addObject:model];
    return model;
}
- (void)deleteNote:(MLNote *)model {
//    NSArray *arr = self.noteArr;
//    for (NSDictionary *dic in arr) {
//        if ([dic.allKeys.firstObject isEqualToString:model.UUID]) {
//            [self.noteArr removeObject:dic];
//        }
//    }
    
}
@end


@implementation MLNoteBookGroup
- (NSMutableArray *)noteBookArr{
    if (!_noteBookArr) {
        _noteBookArr = [NSMutableArray array];
    }
    return _noteBookArr;
}
- (MLModelType)modelType {
    return MLModelGroup;
}
- (MLNoteBook *)addNoteBook:(MLNoteBook *)model {
//    model.parentUUID = self.UUID;
//    [self.noteBookArr addNoteModel:model];
    [self.noteBookArr addObject:model];
    return model;
    
}
- (void)deleteNoteBook:(MLNoteBook *)model {
//    NSArray *arr = self.noteBookArr;
//    for (NSDictionary *dic in arr) {
//        if ([dic.allKeys.firstObject isEqualToString:model.UUID]) {
//            [self.noteBookArr removeObject:dic];
//        }
//    }
}
@end




