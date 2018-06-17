//
//  MLNoteListViewController.m
//  NoteProject
//
//  Created by liby on 2018/6/13.
//  Copyright © 2018年 liby. All rights reserved.
//

#import "MLNoteListViewController.h"
#import "MLNoteListCell.h"

static NSString *const MLNoteListID = @"MLNoteListCell";

@interface MLNoteListViewController () <UITableViewDelegate, UITableViewDataSource>
/** tableview */
@property (nonatomic, strong) UITableView *tableView;
/** 无笔记视图 */
@property (nonatomic, strong) UIView *emptyView;
@end

@implementation MLNoteListViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self isShowEmptyView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.noteBook.titleName;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataNotification) name:MLReloadDataNotification object:nil];
    [self setupTableView];
    [self setupEmptyView];
}
- (void)reloadDataNotification {
    __weak MLNoteListViewController *weakSelf = self;
    [self.manager getNoteModelWithfFloor:self.fFloor sFloor:self.sFloor tFloor:self.tFloor complete:^(id model) {
        weakSelf.noteBook = model;
        [weakSelf isShowEmptyView];
        [weakSelf.tableView reloadData];
    }];
}
- (void)setupTableView {
    UITableView *tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, self.view.H) style:(UITableViewStylePlain)];
    tv.delegate = self;
    tv.dataSource = self;
    tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    tv.backgroundColor = MLGrayColor(244);
    tv.contentInset = UIEdgeInsetsMake(5, 0, 5, 0);
    [self.view addSubview:tv];
    [tv registerNib:[UINib nibWithNibName:MLNoteListID bundle:nil] forCellReuseIdentifier:MLNoteListID];
    tv.estimatedRowHeight = 50;
    tv.rowHeight = UITableViewAutomaticDimension;
    self.tableView = tv;
}
- (void)setupEmptyView {
    UIView *emptyView = [[UIView alloc] initWithFrame:self.view.bounds];
    emptyView.backgroundColor = [UIColor whiteColor];
    UIImage *img = [UIImage imageNamed:@"EStates_Tumbleweed"];
    UIImageView *imgV = [[UIImageView alloc] initWithImage:img];
    imgV.size = img.size;
    imgV.center = CGPointMake(emptyView.centerX, emptyView.centerY - 40);
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imgV.frame), imgV.W, 30)];
    titleLab.centerX = emptyView.centerX;
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.textColor = MLGrayColor(165);
    titleLab.text = @"此笔记本为空";
    titleLab.font = [UIFont systemFontOfSize:17 weight:(UIFontWeightBold)];
    UILabel *subheadLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLab.frame), imgV.W, 30)];
    subheadLab.centerX = emptyView.centerX;
    subheadLab.textAlignment = NSTextAlignmentCenter;
    subheadLab.textColor = MLGrayColor(200);
    subheadLab.text = @"点击\"+\"添加一条笔记";
    subheadLab.font = [UIFont systemFontOfSize:15];
    [emptyView addSubview:titleLab];
    [emptyView addSubview:subheadLab];
    [emptyView addSubview:imgV];
    [self.view addSubview:emptyView];
    self.emptyView = emptyView;
    
    [self isShowEmptyView];
}
- (void)isShowEmptyView {
    if (self.noteBook.noteArr.count) {
        self.emptyView.hidden = YES;
    } else {
        self.emptyView.hidden = NO;
    }
    [self.tableView reloadData];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MLNoteListCell *cell = [tableView dequeueReusableCellWithIdentifier:MLNoteListID forIndexPath:indexPath];
    cell.model = self.noteBook.noteArr[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.noteBook.noteArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    self.manager.tFloor = @(indexPath.row);
    MLNoteListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    MLNoteViewController *noteVC = [[MLNoteViewController alloc] init];
    noteVC.note = cell.model;
    noteVC.fFloor = self.fFloor;
    noteVC.sFloor = self.sFloor;
    noteVC.tFloor = @(indexPath.row);
    noteVC.bookType = self.noteBook.bookType;
    noteVC.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:noteVC animated:YES];
}
#pragma mark - 编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.noteBook.bookType == MLBookDele) {
        return NO;
    }
    return YES;
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak MLNoteListViewController *weakSelf = self;
    UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleNormal) title:nil handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        MLNoteListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self.manager moveToWasteNote:cell.model fFloor:self.fFloor sFloor:self.sFloor tFloor:@(indexPath.row) complete:^(BOOL succeed) {
            if (succeed) {
                [SVProgressHUD showSuccessWithStatus:@"已移到废纸篓"];
                [weakSelf isShowEmptyView];
            } else {
                [SVProgressHUD showErrorWithStatus:@"操作失败"];
            }
        }];
    }];
    editRowAction.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SwipeToDelete"]];
    return @[editRowAction];
}

- (void)dealloc {
    self.manager.fFloor = nil;
    self.manager.sFloor = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
