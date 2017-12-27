//
//  MessageVC.m
//  DHSeller
//
//  Created by Ios_Developer on 2017/12/5.
//  Copyright © 2017年 panzhow. All rights reserved.
//

#import "MessageVC.h"
#import "MessageCell.h"
#import "Masonry.h"

/*
 定义安全区域到顶部／底部高度
 */
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define SafeAreaTopHeight (SCREEN_WIDTH == 812.0 ? 88 : 64)
#define SafeAreaBottomHeight (SCREEN_HEIGHT == 812.0 ? 34 : 0)

@interface MessageVC ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
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
@property(nonatomic,strong)UITextView *chatTV;

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
    [self resignAllFirstResponder];
}
#pragma mark  ===== loadSubViews =====
-(void)loadFooterView
{
    if (!_footerView)
    {
        CGFloat footerViewHeight = 60;
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - footerViewHeight - SafeAreaBottomHeight, SCREEN_WIDTH, footerViewHeight)];
        _footerView.backgroundColor = [UIColor grayColor];
        [self.view addSubview:_footerView];
        
        /*
         输入框tf
         发送按钮 sentBtn
         */
        
        //tf
        CGFloat tvWith = _footerView.frame.size.width - 30 - 60 - 10, tvHeight = 40;
        UIColor *tvColor = [UIColor colorWithRed:57/255.0 green:54/255.0 blue:43/255.0 alpha:1];
        UITextView *tv = [[UITextView alloc] initWithFrame:CGRectZero];
        tv.delegate = self;
        tv.scrollEnabled = YES;
        tv.layer.cornerRadius = 10;
        tv.layer.masksToBounds = YES;
        tv.keyboardType = UIKeyboardTypeDefault;
        tv.returnKeyType = UIReturnKeyDone;
        tv.backgroundColor = [UIColor whiteColor];
        tv.font = [UIFont systemFontOfSize:14];
        tv.textColor = tvColor;
        [_footerView addSubview:tv];
        
        [tv mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_footerView).offset(15);
            make.top.equalTo(_footerView).offset(10);
            make.width.mas_equalTo(tvWith);
            make.height.mas_equalTo(tvHeight);
        }];
        
        _chatTV = tv;
        
        //sentBtn
        CGFloat sentBtnWith = 60, sentBtnHeight = 40;
        UIColor *sentBtnColor = [UIColor colorWithRed:125/255.0 green:207/255.0 blue:247/255.0 alpha:1];
        UIButton * sentBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        sentBtn.backgroundColor = sentBtnColor;
        [sentBtn setTitle:@"发送" forState:UIControlStateNormal];
        [sentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sentBtn.layer.cornerRadius = 10;
        sentBtn.layer.masksToBounds = YES;
        [sentBtn addTarget:self action:@selector(sendMessageAction:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:sentBtn];
        
        [sentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(_footerView).offset(- 15);
            make.top.equalTo(_footerView).offset(10);
            make.width.mas_equalTo(sentBtnWith);
            make.height.mas_equalTo(sentBtnHeight);
        }];
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
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:244/255.0 blue:239/255.0 alpha:1];
        [self.view addSubview:self.tableView];
        
        __weak typeof(self) weakSelf = self;
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(weakSelf.view.mas_left);
            make.top.equalTo(weakSelf.view.mas_top).offset(10);
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
-(void)resignAllFirstResponder//注销第一响应者
{
    if(self.chatTV.isFirstResponder) [self.chatTV resignFirstResponder];
}
-(void)hiddenKeyBoard:(id)sender
{
    [self resignAllFirstResponder];
}
-(void)sendMessageAction:(id)sender
{
    //发送消息，调用发送消息接口；请求成功后，调用download方法重新加载数据并刷新tableview
    
    //此处对假数据进行处理 修改数据源并刷新tableview；
    if (_chatTV.text.length > 0)
    {
        [self.dataSource addObject:@{@"type":@"1",@"headerImg":@"",@"name":@"海",@"time":@"2017-12-06 14:49",@"mess":_chatTV.text}];
        
        [_tableView reloadData];
        
        [UIView animateWithDuration:0.25f animations:^{
            
        } completion:^(BOOL finished) {
            
            [self reframeFooterView:60 AndChatView:40];
            //滑动到底部
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0]  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            _chatTV.text = nil;
        }];
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
    return [_cellHeight[indexPath] floatValue] < 100 ? 100 : [_cellHeight[indexPath] floatValue];
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
            make.top.equalTo(weakSelf.view.mas_top).offset(10);
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
}
#pragma  mark --tv delegate method
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"] && textView.returnKeyType != UIReturnKeyDefault)
    {
        NSLog(@"回车");
        //发送消息
        [self sendMessageAction:nil];
        return NO;
    }
    
    if (textView == _chatTV)
    {
        NSString * str = [textView.text stringByReplacingCharactersInRange:range withString:text];
        
        NSAttributedString *attrStr = [[NSAttributedString  alloc] initWithString:str];
        NSRange range = NSMakeRange(0, attrStr.length);
        NSMutableDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range].mutableCopy;
        NSDictionary *dic1 = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
        [dic addEntriesFromDictionary:dic1];
        CGFloat h = [str boundingRectWithSize:CGSizeMake(_chatTV.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size.height + 20;
        h = h > 20 * 5 ? 20 * 5 : h;
        h = h < 40 ? 40 : h;
        //reframe
        [self reframeFooterView:(h + 20) AndChatView:h];
    }
    
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self resignAllFirstResponder];
    
    [self reframeFooterView:60 AndChatView:40];
}
#pragma  mark  ===== tools =====
-(void)reframeFooterView:(CGFloat)footerH AndChatView:(CGFloat)chatH
{
    
    [_footerView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(footerH);
    }];
    
    [_chatTV mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(chatH);
    }];
    
    __weak typeof(self) weakSelf = self;
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(weakSelf.view.mas_left);
        make.top.equalTo(weakSelf.view.mas_top).offset(10);
        make.width.mas_equalTo(weakSelf.view.mas_width);
        make.bottom.equalTo(_footerView.mas_top);
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25f animations:^{
            
            //滑动到底部
            [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0]  atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            
        }];
    });
}

#pragma mark  ===== dealloc  =====
- (void)dealloc
{
    [self resignAllFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
