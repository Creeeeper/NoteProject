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


- (NSMutableDictionary *)noteListDict {
    if (!_noteListDict) {
        _noteListDict = [NSMutableDictionary dictionary];
        MLNoteBook *noteBook = [[MLNoteBook alloc] initWithTitle:@"第一本笔记"];
        MLNoteBookGroup *noteBookGroup = [[MLNoteBookGroup alloc] initWithTitle:@"第一笔记本组"];
        MLNoteBook *noteBook1 = [[MLNoteBook alloc] initWithTitle:@"第二本笔记第二本笔记第二本笔记第二本笔记第二本笔记第二本笔记第二本笔记"];
        MLNoteBook *noteBook2 = [[MLNoteBook alloc] initWithTitle:@"第三本笔记"];
        MLNote *note1 = [[MLNote alloc] initWithTitle:@"第一笔记"];
        MLNote *note2 = [[MLNote alloc] initWithTitle:@"第二笔记"];
        note1.AttContent = [[NSAttributedString alloc] initWithString:@"哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈"];
        note2.AttContent = [[NSAttributedString alloc] initWithString:@"哈哈哈"];
        MLNoteBook *noteBook3 = [[MLNoteBook alloc] initWithTitle:@"第二本笔记"];
        [noteBook2 addNote:note1];
        [noteBook2 addNote:note2];
        [noteBookGroup addNoteBook:noteBook1];
        [noteBookGroup addNoteBook:noteBook2];
        [_noteListDict setObject:noteBook forKey:noteBook.UUID];
        [_noteListDict setObject:noteBookGroup forKey:noteBookGroup.UUID];
        [_noteListDict setObject:noteBook3 forKey:noteBook3.UUID];
    }
    return _noteListDict;
}

- (void)updateNote:(MLNote *)model complete:(void(^)(BOOL succeed))complete {
    kDISPATCH_GLOBAL_QUEUE_DEFAULT(^{
        NSMutableDictionary *dic = self.noteListDict;
        for (NSString *UUID in dic) {
            if ([dic[UUID] isKindOfClass:[MLNoteBook class]]) {
                for (NSString *sUUID in [dic[UUID] noteDict]) {
                    if ([sUUID isEqualToString:model.UUID]) {
                        [self.noteListDict[UUID] noteDict][sUUID] = model;
                        kDISPATCH_MAIN_THREAD(^{
                            complete(YES);
                        });
                        return;
                    }
                }
            } else if ([dic[UUID] isKindOfClass:[MLNoteBookGroup class]]) {
                for (NSString *sUUID in [dic[UUID] noteBookDict]) {
                    if ([sUUID isEqualToString:model.parentUUID]) {
                        for (NSString *tUUID in [[dic[UUID] noteBookDict][sUUID] noteDict]) {
                            if ([tUUID isEqualToString:model.UUID]) {
                                [[self.noteListDict[UUID] noteBookDict][sUUID] noteDict][tUUID] = model;
                                kDISPATCH_MAIN_THREAD(^{
                                    complete(YES);
                                });
                                return;
                            }
                        }
                    }
                }
            }
        }
        kDISPATCH_MAIN_THREAD(^{
            complete(NO);
        });
    });
}
- (void)updateNoteBook:(MLNoteBook *)model complete:(void(^)(BOOL succeed))complete {
    kDISPATCH_GLOBAL_QUEUE_DEFAULT(^{
        NSMutableDictionary *dic = self.noteListDict;
        for (NSString *UUID in dic) {
            if ([UUID isEqualToString:model.UUID]) {
                self.noteListDict[UUID] = model;
                kDISPATCH_MAIN_THREAD(^{
                    complete(YES);
                });
                return;
            } else if ([UUID isEqualToString:model.parentUUID]) {
                for (NSString *sUUID in [dic[UUID] noteBookDict]) {
                    if ([sUUID isEqualToString:model.UUID]) {
                        [self.noteListDict[UUID] noteBookDict][sUUID] = model;
                        kDISPATCH_MAIN_THREAD(^{
                            complete(YES);
                        });
                        return;
                    }
                }
            }
        }
        kDISPATCH_MAIN_THREAD(^{
            complete(NO);
        });
    });
}
- (void)updateNoteBookGroup:(MLNoteBookGroup *)model complete:(void(^)(BOOL succeed))complete {
    kDISPATCH_GLOBAL_QUEUE_DEFAULT(^{
        NSMutableDictionary *dic = self.noteListDict;
        for (NSString *UUID in dic) {
            if ([UUID isEqualToString:model.UUID]) {
                self.noteListDict[UUID] = model;
                kDISPATCH_MAIN_THREAD(^{
                    complete(YES);
                });
                return;
            }
        }
        kDISPATCH_MAIN_THREAD(^{
            complete(NO);
        });
    });
}

- (void)getNoteModelWithUUID:(NSString *)UUID complete:(void(^)(id model))complete {
    kDISPATCH_GLOBAL_QUEUE_DEFAULT(^{
        NSMutableDictionary *dic = self.noteListDict;
        id model;
        for (NSString *fUUID in dic) {
            if ([fUUID isEqualToString:UUID]) {
                model = dic[fUUID];
                break;
            }
            if ([dic[fUUID] isKindOfClass:[MLNoteBook class]]) {
                for (NSString *sUUID in [dic[fUUID] noteDict]) {
                    if ([sUUID isEqualToString:UUID]) {
                        model = [dic[fUUID] noteDict][sUUID];
                        break;
                    }
                }
            } else if ([dic[fUUID] isKindOfClass:[MLNoteBookGroup class]]) {
                for (NSString *sUUID in [dic[fUUID] noteBookDict]) {
                    if ([sUUID isEqualToString:UUID]) {
                        model = [dic[fUUID] noteBookDict][sUUID];
                        break;
                    }
                    for (NSString *tUUID in [[dic[fUUID] noteBookDict][sUUID] noteDict]) {
                        if ([tUUID isEqualToString:UUID]) {
                            model = [[dic[fUUID] noteBookDict][sUUID] noteDict][tUUID];
                            break;
                        }
                    }
                }
            }
        }
        kDISPATCH_MAIN_THREAD(^{
            complete(model);
        });
    });
}


@end
