//
//  MLNote.h
//  NoteProject
//
//  Created by liby on 2018/6/12.
//  Copyright © 2018年 liby. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    MLModelNote,
    MLModelBook,
    MLModelGroup,
} MLModelType;

typedef enum : NSUInteger {
    MLBookNormal,
    MLBookDele,
} MLBookType;

// 基础笔记模型
@interface MLNoteBaseModel : MLBaseModel
/** 标题 */
@property (nonatomic, strong) NSString *titleName;
/** 唯一标识 */
@property (nonatomic, strong, readonly) NSString *UUID;
/** 创建时间 */
@property (nonatomic, strong, readonly) NSDate *date;
/** 显示时间 */
@property (nonatomic, strong) NSString *createTime;
/** 类型 */
@property (nonatomic, assign) MLModelType modelType;

/** 构造方法 */
- (instancetype)initWithTitle:(NSString *)title;
@end


// 笔记
@interface MLNote : MLNoteBaseModel
/** 父标识 */
@property (nonatomic, strong) NSString *parentUUID;
/** 正文 */
@property (nonatomic, strong, readonly) NSString *content;
/** 正文(富文本) */
@property (nonatomic, strong) NSAttributedString *AttContent;
/** 图片字典 */
@property (nonatomic, strong) NSMutableDictionary *picDict;

@end


// 笔记本
@interface MLNoteBook : MLNoteBaseModel
/** 父标识 */
@property (nonatomic, strong) NSString *parentUUID;
/** 笔记数组 */
@property (nonatomic, strong) NSMutableArray *noteArr;
/** 笔记本类型 */
@property (nonatomic, assign) MLBookType bookType;
/** 是否含有笔记 */
@property (nonatomic, assign) BOOL isContainNote;

/** 添加笔记 */
//- (MLNote *)addNote:(MLNote *)model;
/** 移除笔记 */
//- (void)deleteNote:(MLNote *)model;
@end


// 笔记本组
@interface MLNoteBookGroup : MLNoteBaseModel
/** 笔记本数组 */
@property (nonatomic, strong) NSMutableArray *noteBookArr;
/** 选中状态 */
@property (nonatomic, assign) BOOL isSelect;



/** 添加笔记本 */
//- (MLNoteBook *)addNoteBook:(MLNoteBook *)model;
/** 移除笔记本 */
//- (void)deleteNoteBook:(MLNoteBook *)model;
@end






