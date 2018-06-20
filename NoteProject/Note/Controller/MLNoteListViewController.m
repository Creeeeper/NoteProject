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
/** 进入编辑状态cell的index */
@property (strong, nonatomic) NSIndexPath *editingIndexPath;
@end

@implementation MLNoteListViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self isShowEmptyView];
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (self.editingIndexPath) {
        [self configSwipeButtons];
    }
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
    UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:(UITableViewRowActionStyleNormal) title:nil handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self deleteSwipeAction:indexPath];
    }];
    editRowAction.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    return @[editRowAction];
}
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath  API_AVAILABLE(ios(11.0)){
    //删除
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:nil handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        completionHandler (YES);
        [self deleteSwipeAction:indexPath];
    }];
    deleteRowAction.backgroundColor = [UIColor colorWithWhite:1 alpha:0];

    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction]];
    // 禁止一滑到底
    config.performsFirstActionWithFullSwipe = NO;
    return config;
}
- (void)deleteSwipeAction:(NSIndexPath *)indexPath {
    MLNoteListCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self.manager moveToWasteNote:cell.model fFloor:self.fFloor sFloor:self.sFloor tFloor:@(indexPath.row) complete:^(BOOL succeed) {
        if (succeed) {
            [SVProgressHUD showSuccessWithStatus:@"已移到废纸篓"];
            [self isShowEmptyView];
        } else {
            [SVProgressHUD showErrorWithStatus:@"操作失败"];
        }
    }];
}
#pragma mark - 自定义编辑按钮
- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    self.editingIndexPath = indexPath;
    [self.view setNeedsLayout];
}
- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    self.editingIndexPath = nil;
}
- (void)configSwipeButtons
{
    // 获取选项按钮的reference
    if (@available(iOS 11.0, *)) {
        // iOS 11层级 (Xcode 9编译): UITableView -> UISwipeActionPullView
        for (UIView *subview in self.tableView.subviews) {
            if ([subview isKindOfClass:NSClassFromString(@"UISwipeActionPullView")] && [subview.subviews count] >= 1) {
                // 和iOS 10的按钮顺序相反
                UIButton *deleteButton = subview.subviews[0];
                //                UIButton *readButton = subview.subviews[0];
                
                [self configDeleteButton:deleteButton];
                //                [self configReadButton:readButton];
            }
        }
    } else {
        // iOS 8-10层级: UITableView -> UITableViewCell -> UITableViewCellDeleteConfirmationView
        MLNoteListCell *tableCell = [self.tableView cellForRowAtIndexPath:self.editingIndexPath];
        for (UIView *subview in tableCell.subviews) {
            if ([subview isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")] && [subview.subviews count] >= 1) {
                UIButton *deleteButton = subview.subviews[0];
                //                UIButton *readButton = subview.subviews[1];
                
                [self configDeleteButton:deleteButton];
                //                [self configReadButton:readButton];
            }
        }
    }
}
- (void)configDeleteButton:(UIButton*)deleteButton
{
    if (deleteButton)
    {
        //        [deleteButton.titleLabel setFont:[UIFont fontWithName:@"SFUIText-Regular" size:12.0]];
        //        [deleteButton setTitleColor:[[ColorUtil instance] colorWithHexString:@"D0021B"] forState:UIControlStateNormal];
        [deleteButton setImage:[UIImage imageNamed:@"SwipeToDelete"] forState:UIControlStateNormal];
        //        [deleteButton setBackgroundColor:[UIColor clearColor]];
        // 调整按钮上图片和文字的相对位置（该方法的实现在下面）
        //        [self centerImageAndTextOnButton:deleteButton];
    }
}

- (void)configReadButton:(UIButton*)readButton
{
    if (readButton)
    {
        //        [readButton.titleLabel setFont:[UIFont fontWithName:@"SFUIText-Regular" size:12.0]];
        //        [readButton setTitleColor:[[ColorUtil instance] colorWithHexString:@"4A90E2"] forState:UIControlStateNormal];
        // 根据当前状态选择不同图片
        //        BOOL isRead = [[NotificationManager instance] read:self.editingIndexPath.row];
        //        UIImage *readButtonImage = [UIImage imageNamed: isRead ? @"Mark_as_unread_icon_.png" : @"Mark_as_read_icon_.png"];
        //        [readButton setImage:readButtonImage forState:UIControlStateNormal];
        
        //        [readButton setBackgroundColor:[[ColorUtil instance] colorWithHexString:@"E5E8E8"]];
        // 调整按钮上图片和文字的相对位置（该方法的实现在下面）
        //        [self centerImageAndTextOnButton:readButton];
    }
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
