//
//  MLNoteBookListViewController.m
//  NoteProject
//
//  Created by liby on 2018/6/12.
//  Copyright © 2018年 liby. All rights reserved.
//

#import "MLNoteBookListViewController.h"
#import "MLNoteListViewController.h"
#import "MLNoteBookListCell.h"


static NSString *const MLNoteBookListID = @"MLNoteBookListCell";

@interface MLNoteBookListViewController () <UITableViewDelegate, UITableViewDataSource>
/** tableview */
@property (nonatomic, strong) UITableView *tableView;
/** 笔记本数组 */
@property (nonatomic, strong) NSMutableArray *noteListArr;
@end

@implementation MLNoteBookListViewController

- (NSMutableArray *)noteListArr{
    if (!_noteListArr) {
        _noteListArr = [NSMutableArray array];
        MLNoteBook *noteBook = [[MLNoteBook alloc] initWithTitle:@"第一本笔记"];
        MLNoteBookGroup *noteBookGroup = [[MLNoteBookGroup alloc] initWithTitle:@"第一笔记本组"];
        MLNoteBook *noteBook1 = [[MLNoteBook alloc] initWithTitle:@"第二本笔记第二本笔记第二本笔记第二本笔记第二本笔记第二本笔记第二本笔记"];
        MLNoteBook *noteBook2 = [[MLNoteBook alloc] initWithTitle:@"第三本笔记"];
        MLNote *note1 = [[MLNote alloc] initWithTitle:@"第一笔记"];
        MLNote *note2 = [[MLNote alloc] initWithTitle:@"第二笔记"];
        note1.content = @"哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈";
        note2.content = @"哈哈哈";
        [noteBook2 addNote:note1];
        [noteBook2 addNote:note2];
        [noteBookGroup addNoteBook:noteBook1];
        [noteBookGroup addNoteBook:noteBook2];
        [_noteListArr addObject:noteBook];
        [_noteListArr addObject:noteBookGroup];
        [_noteListArr addObject:noteBook];
    }
    return _noteListArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
}

- (void)setupTableView {
    UITableView *tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, self.view.H) style:(UITableViewStylePlain)];
    tv.delegate = self;
    tv.dataSource = self;
    tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tv];
    [tv registerNib:[UINib nibWithNibName:MLNoteBookListID bundle:nil] forCellReuseIdentifier:MLNoteBookListID];
    
    self.tableView = tv;
}

#pragma mark - 区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.noteListArr.count;
}
#pragma mark - 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.noteListArr[section] isKindOfClass:[NSArray class]]) {
        NSInteger count = [self.noteListArr[section] count];
        return count;
    }
    return 1;
}
#pragma mark - cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MLNoteBookListCell *cell = [tableView dequeueReusableCellWithIdentifier:MLNoteBookListID forIndexPath:indexPath];
    if ([self.noteListArr[indexPath.section] isKindOfClass:[NSArray class]]) {
        [cell setupUIWithModel:self.noteListArr[indexPath.section] [indexPath.row]];
    } else {
        [cell setupUIWithModel:self.noteListArr[indexPath.section]];
    }
    return cell;
}
#pragma mark - 行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
#pragma mark - 点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MLNoteBookListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([self.noteListArr[indexPath.section] isKindOfClass:[MLNoteBookGroup class]]) {
        cell.caretDownBtn.selected = !cell.caretDownBtn.selected;
        NSInteger index = indexPath.section + 1;
        if (cell.caretDownBtn.selected) {
            [UIView animateWithDuration:0.25 animations:^{
                cell.caretDownBtn.transform = CGAffineTransformMakeRotation(180.1 * M_PI/180.0);
            }];
            MLNoteBookGroup *temp = self.noteListArr[indexPath.section];
            [self.noteListArr insertObject:temp.noteBookArr atIndex:index];
            [self.tableView insertSections:[[NSIndexSet alloc] initWithIndex:index] withRowAnimation:UITableViewRowAnimationBottom];
        } else {
            [UIView animateWithDuration:0.25 animations:^{
                cell.caretDownBtn.transform = CGAffineTransformIdentity;
            }];
            [self.noteListArr removeObjectAtIndex:index];
            [self.tableView deleteSections:[[NSIndexSet alloc] initWithIndex:index] withRowAnimation:(UITableViewRowAnimationTop)];
        }
    } else if ([self.noteListArr[indexPath.section] isKindOfClass:[MLNoteBook class]]) {
        [self pushNoteListVCWithBook:self.noteListArr[indexPath.section]];
    } else if ([self.noteListArr[indexPath.section] isKindOfClass:[NSArray class]]) {
        [self pushNoteListVCWithBook:self.noteListArr[indexPath.section][indexPath.row]];
    }
}
- (void)pushNoteListVCWithBook:(MLNoteBook *)model {
    MLNoteListViewController *noteListVC = [[MLNoteListViewController alloc] init];
    noteListVC.noteBook = model;
    [self.navigationController pushViewController:noteListVC animated:YES];
}
@end
