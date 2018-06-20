//
//  MLNotesManager.m
//  NoteProject
//
//  Created by liby on 2018/6/14.
//  Copyright © 2018年 liby. All rights reserved.
//

#import "MLNotesManager.h"

@implementation MLNotesManager
SingletonM(InfoManager)

- (NSMutableArray *)noteListArr{
    if (!_noteListArr) {
        _noteListArr = [NSMutableArray array];
        MLNoteBook *noteBook = [[MLNoteBook alloc] initWithTitle:@"第一本笔记"];
        MLNote *note = [[MLNote alloc] initWithTitle:@"第0笔记"];
        note.AttContent = [[NSAttributedString alloc] initWithString:@"000"];
        MLNoteBookGroup *noteBookGroup = [[MLNoteBookGroup alloc] initWithTitle:@"第一笔记本组"];
        MLNoteBook *noteBook1 = [[MLNoteBook alloc] initWithTitle:@"第二本笔记第二本笔记第二本笔记第二本笔记第二本笔记第二本笔记第二本笔记"];
        MLNoteBook *noteBook2 = [[MLNoteBook alloc] initWithTitle:@"第三本笔记"];
        MLNote *note1 = [[MLNote alloc] initWithTitle:@"第一笔记"];
        MLNote *note2 = [[MLNote alloc] initWithTitle:@"第二笔记"];
        note1.AttContent = [[NSAttributedString alloc] initWithString:@"哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈"];
        note2.AttContent = [[NSAttributedString alloc] initWithString:@"哈哈哈"];
        MLNoteBook *noteBook3 = [[MLNoteBook alloc] initWithTitle:@"第二本笔记"];
        MLNoteBookGroup *noteBookGroup1 = [[MLNoteBookGroup alloc] initWithTitle:@"第二笔记本组"];
        MLNoteBook *noteBook4 = [[MLNoteBook alloc] initWithTitle:@"第四本笔记"];
        MLNoteBook *noteBook5 = [[MLNoteBook alloc] initWithTitle:@"第五本笔记第五本笔记第五本笔记第五本笔记第五本笔记第五本笔记第五本笔记"];
        [noteBook.noteArr addObject:note];
        [noteBook2.noteArr addObject:note1];
        [noteBook2.noteArr addObject:note2];
        [noteBookGroup.noteBookArr addObject:noteBook2];
        [noteBookGroup.noteBookArr addObject:noteBook1];
        [noteBookGroup1.noteBookArr addObject:noteBook4];
        [noteBookGroup1.noteBookArr addObject:noteBook5];
        [_noteListArr addObject:noteBook];
        [_noteListArr addObject:noteBookGroup];
        [_noteListArr addObject:noteBook3];
        [_noteListArr addObject:noteBookGroup1];
    }
    return _noteListArr;
}

- (MLNoteBook *)deleNoteBook {
    if (!_deleNoteBook) {
        _deleNoteBook = [[MLNoteBook alloc] initWithTitle:@"废纸篓"];
        _deleNoteBook.bookType = MLBookDele;
        // 假数据
        MLNote *note1 = [[MLNote alloc] initWithTitle:@"删除笔记1"];
        note1.AttContent = [[NSAttributedString alloc] initWithString:@"删除删除删除删除删除"];
        [_deleNoteBook.noteArr addObject:note1];
    }
    return _deleNoteBook;
}

#pragma mark - 更新
- (void)updateNoteModel:(MLNoteBaseModel *)model complete:(void(^)(BOOL succeed))complete {
    [self updateNoteModel:model fFloor:self.fFloor sFloor:self.sFloor tFloor:self.tFloor complete:complete];
}
- (void)updateNoteModel:(MLNoteBaseModel *)model fFloor:(NSNumber *)fFloor sFloor:(NSNumber *)sFloor tFloor:(NSNumber *)tFloor complete:(void(^)(BOOL succeed))complete {
    BOOL succeed = NO;
    NSInteger ffloor = fFloor.integerValue;
    NSInteger sfloor = sFloor.integerValue;
    NSInteger tfloor = tFloor.integerValue;
    if (fFloor) {
        if ([self.noteListArr[ffloor] modelType] == MLModelGroup) {
            if (tFloor && sFloor) {   // 组->书->笔记
                [[self.noteListArr[ffloor] noteBookArr][sfloor] noteArr][tfloor] = model;
                succeed = YES;
            } else if (sFloor) {           // 组->书
                [self.noteListArr[ffloor] noteBookArr][sfloor] = model;
                succeed = YES;
            } else {                            // 组
                self.noteListArr[ffloor] = model;
                succeed = YES;
            }
        } else {
            if (tFloor) {                  // 书->笔记
                [self.noteListArr[ffloor] noteArr][tfloor] = model;
                succeed = YES;
            } else {                            // 书
                self.noteListArr[ffloor] = model;
                succeed = YES;
            }
        }
    }
    complete(succeed);
}


#pragma mark - 查询
- (void)getNoteModelcomplete:(void(^)(id model))complete {
    [self getNoteModelWithfFloor:self.fFloor sFloor:self.sFloor tFloor:self.tFloor complete:complete];
}
- (void)getNoteModelWithfFloor:(NSNumber *)fFloor sFloor:(NSNumber *)sFloor tFloor:(NSNumber *)tFloor complete:(void(^)(id model))complete {
    id model;
    NSInteger ffloor = fFloor.integerValue;
    NSInteger sfloor = sFloor.integerValue;
    NSInteger tfloor = tFloor.integerValue;
    if (fFloor) {
        if ([self.noteListArr[ffloor] modelType] == MLModelGroup) {
            if (tFloor && sFloor) {   // 组->书->笔记
                model = [[self.noteListArr[ffloor] noteBookArr][sfloor] noteArr][tfloor];
            } else if (sFloor) {           // 组->书
                model = [self.noteListArr[ffloor] noteBookArr][sfloor];
            } else {                            // 组
                model = self.noteListArr[ffloor];
            }
        } else {
            if (tFloor) {                  // 书->笔记
                model = [self.noteListArr[ffloor] noteArr][tfloor];
            } else {                            // 书
                model = self.noteListArr[ffloor];
            }
        }
    }
    complete(model);
}

#pragma mark - 删除
- (void)deleteNoteModel:(MLNoteBaseModel *)model complete:(void(^)(BOOL succeed))complete{
    [self deleteNoteModel:model fFloor:self.fFloor sFloor:self.sFloor tFloor:self.tFloor complete:complete];
}
- (void)deleteNoteModel:(MLNoteBaseModel *)model fFloor:(NSNumber *)fFloor sFloor:(NSNumber *)sFloor tFloor:(NSNumber *)tFloor complete:(void(^)(BOOL succeed))complete {
    BOOL succeed = NO;
    NSInteger ffloor = fFloor.integerValue;
    NSInteger sfloor = sFloor.integerValue;
    NSInteger tfloor = tFloor.integerValue;
    if (fFloor) {
        if ([self.noteListArr[ffloor] modelType] == MLModelGroup) {
            if (tFloor && sFloor) {   // 组->书->笔记
                [[[self.noteListArr[ffloor] noteBookArr][sfloor] noteArr] removeObjectAtIndex:tfloor];
                succeed = YES;
            } else if (sFloor) {           // 组->书
                [[self.noteListArr[ffloor] noteBookArr] removeObjectAtIndex:sfloor];
                if (![self.noteListArr[ffloor] noteBookArr].count) { // 删除空组
                    [self.noteListArr removeObjectAtIndex:ffloor];
                }
                succeed = YES;
            } else {                            // 组
                [self.noteListArr removeObjectAtIndex:ffloor];
                succeed = YES;
            }
        } else {
            if (tFloor) {                  // 书->笔记
                [[self.noteListArr[ffloor] noteArr] removeObjectAtIndex:tfloor];
                succeed = YES;
            } else {                            // 书
                [self.noteListArr removeObjectAtIndex:ffloor];
                succeed = YES;
            }
        }
    }
    complete(succeed);
}

#pragma mark - 添加
- (void)insertNoteModel:(MLNoteBaseModel *)model complete:(void(^)(BOOL succeed))complete {
    [self insertNoteModel:model fFloor:self.fFloor sFloor:self.sFloor complete:complete];
}
- (void)insertNoteModel:(MLNoteBaseModel *)model fFloor:(NSNumber *)fFloor sFloor:(NSNumber *)sFloor complete:(void(^)(BOOL succeed))complete {
    BOOL succeed = NO;
    NSInteger ffloor = fFloor.integerValue;
    NSInteger sfloor = sFloor.integerValue;
    if (fFloor) {
        if ([self.noteListArr[ffloor] modelType] == MLModelGroup) {
            if (sFloor) {           // 笔记->书->组
                [[[self.noteListArr[ffloor] noteBookArr][sfloor] noteArr] addObject:model];
                succeed = YES;
            } else {                // 书->组
                [[self.noteListArr[ffloor] noteBookArr] addObject:model];
                succeed = YES;
            }
        } else {                    // 笔记->书
            [[self.noteListArr[ffloor] noteArr] addObject:model];
            succeed = YES;
        }
    } else {                        // 书/组->数据源
        [self.noteListArr addObject:model];
        succeed = YES;
    }
    complete(succeed);
}
#pragma mark - 删除笔记本
- (void)moveToWasteNoteBook:(MLNoteBook *)model fFloor:(NSNumber *)fFloor sFloor:(NSNumber *)sFloor complete:(void(^)(BOOL succeed))complete {
    __block BOOL succeed = NO;
#warning low
    __block NSInteger succeedCount = model.noteArr.count;
    for (MLNote *obj in [model.noteArr copy]) {
        [self moveToWasteNote:obj fFloor:fFloor sFloor:sFloor tFloor:@(0) complete:^(BOOL succeed) {
            if (succeed) succeedCount--;
        }];
    }
    if (!succeedCount) {
        [self deleteNoteModel:model fFloor:fFloor sFloor:sFloor tFloor:nil complete:^(BOOL isSucceed) {
            succeed = isSucceed;
        }];
    }
    complete(succeed);
}
#pragma mark - 笔记移到废纸篓
- (void)moveToWasteNote:(MLNote *)model fFloor:(NSNumber *)fFloor sFloor:(NSNumber *)sFloor tFloor:(NSNumber *)tFloor complete:(void(^)(BOOL succeed))complete {
    BOOL succeed = NO;
    NSInteger ffloor = fFloor.integerValue;
    NSInteger sfloor = sFloor.integerValue;
    NSInteger tfloor = tFloor.integerValue;
    if (fFloor && tFloor) {
        if ([self.noteListArr[ffloor] modelType] == MLModelGroup) {
            if (sFloor) {
                [[[self.noteListArr[ffloor] noteBookArr][sfloor] noteArr] removeObjectAtIndex:tfloor];
                model.parentUUID = [[self.noteListArr[ffloor] noteBookArr][sfloor] UUID];
                succeed = YES;
            }
        } else {
            [[self.noteListArr[ffloor] noteArr] removeObjectAtIndex:tfloor];
            model.parentUUID = [self.noteListArr[ffloor] UUID];
            succeed = YES;
        }
    }
    if (succeed) {
        [self.deleNoteBook.noteArr addObject:model];
    }
    complete(succeed);
}
#pragma mark - 能否删除笔记本
- (BOOL)canDeleNoteBook {
    NSInteger count = 0;
    for (MLNoteBaseModel *model in self.noteListArr) {
        if (model.modelType == MLModelBook) {
            count++;
        } else {
            count += [(MLNoteBookGroup *)model noteBookArr].count;
        }
    }
    if (count > 1) {
        return YES;
    }
    return NO;
}
#pragma mark - 能否恢复笔记到笔记本
- (BOOL)canRegainNoteToNoteBook:(MLNote *)model {
    BOOL succeed = NO;
    if (model.parentUUID) {
        for (MLNoteBaseModel *obj in self.noteListArr) {
            if (obj.modelType == MLModelGroup) {
                for (MLNoteBook *book in [(MLNoteBookGroup *)obj noteBookArr]) {
                    if ([book.UUID isEqualToString:model.parentUUID]) {
                        [book.noteArr addObject:model];
                        succeed = YES;
                    }
                }
            } else {
                if ([obj.UUID isEqualToString:model.parentUUID]) {
                    [((MLNoteBook *)obj).noteArr addObject:model];
                    succeed = YES;
                }
            }
        }
    }
    if (succeed) {
        [self.deleNoteBook.noteArr removeObject:model];
    }
    return succeed;
}
@end
