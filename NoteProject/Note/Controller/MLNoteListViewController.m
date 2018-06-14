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
/** 笔记本标识 */
@property (nonatomic, strong) NSString *noteBookUUID;
@end

@implementation MLNoteListViewController

- (void)setNoteBook:(MLNoteBook *)noteBook {
    if (_noteBook != noteBook) {
        _noteBook = noteBook;
        self.noteBookUUID = noteBook.UUID;
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
    [[MLNotesManager sharedManager] getNoteModelWithUUID:self.noteBookUUID complete:^(id model) {
        weakSelf.noteBook = model;
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
    if (self.noteBook.noteDict.count) {
        self.emptyView.hidden = YES;
    } else {
        self.emptyView.hidden = NO;
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MLNoteListCell *cell = [tableView dequeueReusableCellWithIdentifier:MLNoteListID forIndexPath:indexPath];
    [cell setupUIWithModel:self.noteBook.noteDict.allValues[indexPath.row]];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.noteBook.noteDict.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MLNoteViewController *noteVC = [[MLNoteViewController alloc] init];
    noteVC.note = self.noteBook.noteDict.allValues[indexPath.row];
    noteVC.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:noteVC animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
