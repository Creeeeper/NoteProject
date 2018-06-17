//
//  MLNotesManager.h
//  NoteProject
//
//  Created by liby on 2018/6/14.
//  Copyright © 2018年 liby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface MLNotesManager : NSObject
SingletonH(MLNotesManager)

/* ---------------------------------------------------- */

/**
 笔记本字典
 @key       UUID
 @value     笔记模型
 */
//@property (nonatomic, strong) NSMutableDictionary *noteListDict;

/**
 笔记本数组
 */
@property (nonatomic, strong) NSMutableArray *noteListArr;

/**
 废纸篓
 */
@property (nonatomic, strong) MLNoteBook *deleNoteBook;

/**
 一维
 */
@property (nonatomic, strong) NSNumber *fFloor;

/**
 二维
 */
@property (nonatomic, strong) NSNumber *sFloor;

/**
 三维
 */
@property (nonatomic, strong) NSNumber *tFloor;

/* ---------------------------------------------------- */



/** 更新笔记 */
//- (void)updateNote:(MLNote *)model complete:(void(^)(BOOL succeed))complete;
/** 更新笔记本 */
//- (void)updateNoteBook:(MLNoteBook *)model complete:(void(^)(BOOL succeed))complete;
/** 更新笔记本组 */
//- (void)updateNoteBookGroup:(MLNoteBookGroup *)model complete:(void(^)(BOOL succeed))complete;
/** 查询 */
//- (void)getNoteModelWithUUID:(NSString *)UUID complete:(void(^)(id model))complete;


/**
 更新

 @param model 模型
 @param complete 成功回调
 */
- (void)updateNoteModel:(MLNoteBaseModel *)model complete:(void(^)(BOOL succeed))complete;
- (void)updateNoteModel:(MLNoteBaseModel *)model fFloor:(NSNumber *)fFloor sFloor:(NSNumber *)sFloor tFloor:(NSNumber *)tFloor complete:(void(^)(BOOL succeed))complete;

/**
 查询

 @param complete 模型回调
 */
- (void)getNoteModelcomplete:(void(^)(id model))complete;
- (void)getNoteModelWithfFloor:(NSNumber *)fFloor sFloor:(NSNumber *)sFloor tFloor:(NSNumber *)tFloor complete:(void(^)(id model))complete;

/**
 删除

 @param model 模型
 @param complete 成功回调
 */
- (void)deleteNoteModel:(MLNoteBaseModel *)model complete:(void(^)(BOOL succeed))complete;
- (void)deleteNoteModel:(MLNoteBaseModel *)model fFloor:(NSNumber *)fFloor sFloor:(NSNumber *)sFloor tFloor:(NSNumber *)tFloor complete:(void(^)(BOOL succeed))complete;

/**
 添加(无需第三维度)

 @param model 模型
 @param complete 成功回调
 */
- (void)insertNoteModel:(MLNoteBaseModel *)model complete:(void(^)(BOOL succeed))complete;
- (void)insertNoteModel:(MLNoteBaseModel *)model fFloor:(NSNumber *)fFloor sFloor:(NSNumber *)sFloor complete:(void(^)(BOOL succeed))complete;


/**
 删除笔记本

 @param model 模型
 @param complete 成功回调
 */
- (void)moveToWasteNoteBook:(MLNoteBook *)model fFloor:(NSNumber *)fFloor sFloor:(NSNumber *)sFloor complete:(void(^)(BOOL succeed))complete;

/**
 笔记移到废纸篓

 @param model 模型
 @param complete 成功回调
 */
- (void)moveToWasteNote:(MLNote *)model fFloor:(NSNumber *)fFloor sFloor:(NSNumber *)sFloor tFloor:(NSNumber *)tFloor complete:(void(^)(BOOL succeed))complete;

/**
 能否删除笔记本

 @return 回调
 */
- (BOOL)canDeleNoteBook;

/**
 能否恢复笔记到笔记本

 @param model 笔记
 @return 回调
 */
- (BOOL)canRegainNoteToNoteBook:(MLNote *)model;
@end
