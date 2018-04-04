//
//  MessageVC.m
//  ChatVCDemo
//
//  Created by Ios_Developer on 2017/12/5.
//  Copyright © 2017年 hai. All rights reserved.
//

#import "MessageVC.h"
#import "MessageCell.h"
#import "Masonry.h"
#import "ToolView.h"

//--------------------------- 宏定义参数 、建议项目使用时，放在pch中 ----------------------------------
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
/*
 定义安全区域到顶部／底部高度
 */
#define SafeAreaTopHeight (SCREEN_WIDTH == 812.0 ? 88 : 64)
#define SafeAreaBottomHeight (SCREEN_HEIGHT == 812.0 ? 34 : 0)

//高度系数:(821x 667 8和6)
#define HeightCoefficient (SCREEN_HEIGHT == 812.0 ? 667.0/667.0 : SCREEN_HEIGHT/667.0)

//宽度系数：(821x 667 8和6)
#define WidthCoefficient (SCREEN_WIDTH == 375.0 ? 375.0/375.0 : SCREEN_WIDTH/375.0)
//-----------------------------------------------------------------------------------------------

@interface MessageVC ()<UITableViewDelegate,UITableViewDataSource>
{
    //键盘高度
    CGFloat _keyboardHigh;
    
    BOOL _needScroolBottom;// 判断是否需要滑动到底部
    CGFloat _oldOffset;//scrollview的上一次的偏移量
}

/*
 定义属性及变量
 */
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *footerView;
@property (nonatomic ,strong)ToolView *toolView;

@property(nonatomic,strong)NSMutableArray *dataSource;//请求数据
@property(nonatomic,strong)NSMutableDictionary *cellHeight;//cell 高
@end

@implementation MessageVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"聊天消息";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _keyboardHigh = 0;
    _dataSource = [NSMutableArray new];
    _cellHeight = [NSMutableDictionary new];
    _needScroolBottom = YES;
    
    //加载footerView
    [self loadFooterView];
    
    //加载tableView
    [self loadTableView];
    [_tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    //键盘弹跳通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //请求数据
    [self downLoad];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
#pragma mark  ===== loadSubViews =====
-(ToolView *)toolView
{
    if (!_toolView)
    {
        _toolView = [[ToolView alloc] init];
        __weak typeof(self) weakSelf = self;
        _toolView.sendMessage = ^(UITextView *chatTV) {
            
            [weakSelf sendMessageAction:chatTV];
        };
    }
    return _toolView;
}
-(void)loadFooterView
{
    if (!_footerView)
    {
        CGFloat footerViewHeight = 60*HeightCoefficient;
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - footerViewHeight - SafeAreaBottomHeight, SCREEN_WIDTH, footerViewHeight)];
        _footerView.backgroundColor = [UIColor grayColor];
        [self.view addSubview:_footerView];
        
        /*
         toolView
         */
        [_footerView addSubview:self.toolView];
        [_toolView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.equalTo(_toolView);
            make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        [_toolView addObserver:self forKeyPath:@"chatTVHeight" options:NSKeyValueObservingOptionNew context:nil];
    }
}
-(void)loadTableView
{
    if (!_tableView)
    {
        //        self.automaticallyAdjustsScrollViewInsets = NO;
#ifdef __IPHONE_11_0
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
#else
        self.automaticallyAdjustsScrollViewInsets = NO;
#endif
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10*HeightCoefficient)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:244/255.0 blue:239/255.0 alpha:1];
        [self.view addSubview:self.tableView];
        
        __weak typeof(self) weakSelf = self;
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(weakSelf.view.mas_left);
            make.top.equalTo(weakSelf.view.mas_top).offset(10*HeightCoefficient);
            make.width.mas_equalTo(weakSelf.view.mas_width);
            make.bottom.equalTo(_footerView.mas_top);
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyBoard:)];
        [_tableView addGestureRecognizer:tap];
    }
}
#pragma mark  ===== request =====
-(void)downLoad
{
    //请求数据 此处暂时写入加数据处理
    
    //type 0 对方 1 自己 /headerImg 头像 /name
    _dataSource = @[@{@"type":@"0",@"headerImg":@"",@"name":@"鹏鹏鹏",@"time":@"2017-12-06 14:49",@"mess":@"hello,are you ok?"},@{@"type":@"1",@"headerImg":@"",@"name":@"海",@"time":@"2017-12-06 14:49",@"mess":@"I'm fine ，how about you?"},@{@"type":@"0",@"headerImg":@"",@"name":@"鹏鹏鹏",@"time":@"2017-12-06 14:49",@"mess":@"lajfldjflasd;gjasdl;kfjdakl;sfjalks;fjals;dgjakl;sdjfakl;sgjakl;sdjfal;fjaklsjgakl;sdjfa;lkgja;lksfdj;lkfja;lgajf;fasdfkjakjfaklgjalsk;fja;ldfjkals;gja;lkdfjkal;gja;lfjd;"},@{@"type":@"1",@"headerImg":@"",@"name":@"海",@"time":@"2017-12-06 14:49",@"mess":@"唯有工作，能使俺快乐。"},@{@"type":@"1",@"headerImg":@"",@"name":@"海",@"time":@"2017-12-06 14:49",@"mess":@"大嘎嘎历史上的咖啡机阿里的风景啊了；即咖喱的咖啡机阿里；框架噶；了的咖啡机阿奎罗；是风景啊了；发动机啊；理发店"}].mutableCopy;
    
    [UIView animateWithDuration:0.25f animations:^{
        
        [_tableView reloadData];
        
    } completion:^(BOOL finished) {
        
        //滑动到底部
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0]  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }];
}
#pragma mark  ===== action  =====
-(void)hiddenKeyBoard:(id)sender
{
    [_toolView.chatTV resignFirstResponder];
}
-(void)sendMessageAction:(UITextView *)chatTV
{
    //发送消息，调用发送消息接口；请求成功后，调用download方法重新加载数据并刷新tableview
    
    //此处对假数据进行处理 修改数据源并刷新tableview；
    if (chatTV.text.length > 0)
    {
        [self.dataSource addObject:@{@"type":@"1",@"headerImg":@"",@"name":@"海",@"time":@"2017-12-06 14:49",@"mess":chatTV.text}];
        
        [_footerView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(60*HeightCoefficient);
        }];
        
        [_tableView reloadData];
        _needScroolBottom = YES;//必须加在reloadData之后
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //滑动到底部
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0]  atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            chatTV.text = nil;
        });
    }
}

#pragma mark
#pragma mark =====  tableview delegate/dataSource  =====
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_cellHeight[indexPath] floatValue] < 100*HeightCoefficient ? 100*HeightCoefficient : [_cellHeight[indexPath] floatValue];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"message_cell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell)
    {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithRed:245/255.0 green:244/255.0 blue:239/255.0 alpha:1];
    }
    //fuzhi
    cell.type = [self.dataSource[indexPath.row][@"type"] intValue];
    [cell getMessage:self.dataSource[indexPath.row]];
    
    //reframe
    [cell reframe];
    [_cellHeight setObject:@([cell getCellHeight]) forKey:indexPath];
    
    return cell;
}
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        //end of loading
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (_needScroolBottom == YES)
            {
                [UIView animateWithDuration:0.25f animations:^{
                    
                    //滑动到底部
//                    if (_tableView.contentSize.height > _tableView.frame.size.height)
//                    {
//                        CGPoint offset = CGPointMake(0, _tableView.contentSize.height - _tableView.frame.size.height);
//                        [_tableView setContentOffset:offset animated:YES];
//                    }
                    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0]  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                }];
            }
        });
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_tableView == scrollView && _oldOffset  && _tableView.contentOffset.y < _oldOffset)
    {
        _needScroolBottom = NO;
    }
    
    _oldOffset = scrollView.contentOffset.y;//将当前位移变成缓存位移
}
#pragma mark  ===== notificaiton method  =====
-(void)keyboardShow:(NSNotification *)sender
{
    NSValue * value = sender.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect rect;
    [value getValue:&rect];
    _keyboardHigh = CGRectGetHeight(rect);
    [UIView animateWithDuration:0.25f animations:^{
        
        [_footerView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.view);
            make.bottom.equalTo(self.view).offset(-_keyboardHigh);
            make.width.mas_equalTo(_footerView.frame.size.width);
            make.height.mas_equalTo(_footerView.frame.size.height);
        }];
        
        __weak typeof(self) weakSelf = self;
        [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(weakSelf.view.mas_left);
            make.top.equalTo(weakSelf.view.mas_top).offset(10);
            make.width.mas_equalTo(weakSelf.view.mas_width);
            make.bottom.equalTo(_footerView.mas_top);
        }];
    }];
}
-(void)keyboardDidShow:(NSNotificationCenter *)sender
{
    [UIView animateWithDuration:0.25f animations:^{
        
        //滑动到底部
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0]  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }];
    _needScroolBottom = YES;
}
-(void)keyboardHide:(NSNotification *)sender
{
    _keyboardHigh = 0;
    [UIView animateWithDuration:0.25f animations:^{
        
        [_footerView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.view.mas_left);
            make.bottom.equalTo(self.view.mas_bottom).offset(-SafeAreaBottomHeight);
            make.width.mas_equalTo(_footerView.frame.size.width);
            make.height.mas_equalTo(_footerView.frame.size.height);
        }];
        
        __weak typeof(self) weakSelf = self;
        [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(weakSelf.view.mas_left);
            make.top.equalTo(weakSelf.view.mas_top).offset(10*HeightCoefficient);
            make.width.mas_equalTo(weakSelf.view.mas_width);
            make.bottom.equalTo(_footerView.mas_top);
        }];
        
    }];
}
-(void)keyboardDidHide:(NSNotificationCenter *)sender
{
    [UIView animateWithDuration:0.25f animations:^{
        
        //滑动到底部
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0]  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }];
    _needScroolBottom = YES;
}
#pragma mark  ===== kvo  =====
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"])
    {
//        CGSize contentSize = (CGSize)[[change valueForKey:NSKeyValueChangeNewKey] CGSizeValue];
//        if (contentSize.height > self.tableView.frame.size.height)
//        {
//            CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
//            [self.tableView setContentOffset:offset animated:YES];
//            NSLog(@"～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～～contentSize:%@,tableView.height:%f,offset:%@",NSStringFromCGSize(contentSize),self.tableView.frame.size.height,NSStringFromCGPoint(offset));
//        }
    }
    else
    {
        CGFloat chatHeight = (CGFloat)[[change valueForKey:NSKeyValueChangeNewKey] floatValue];
        
        //reframe toolView and FooterView
        [_footerView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(chatHeight + 14*HeightCoefficient);
        }];
        
        __weak typeof(self) weakSelf = self;
        [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(weakSelf.view.mas_left);
            make.top.equalTo(weakSelf.view.mas_top).offset(10*HeightCoefficient);
            make.width.mas_equalTo(weakSelf.view.mas_width);
            make.bottom.equalTo(_footerView.mas_top);
        }];
        
//        //滑动到底部
//        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0]  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
   
}
#pragma mark  ===== dealloc  =====
- (void)dealloc
{
    [_toolView removeObserver:self forKeyPath:@"chatTVHeight"];
    [_tableView removeObserver:self forKeyPath:@"contentSize"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
