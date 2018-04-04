//
//  MessageCell.h
//  ChatVCDemo
//
//  Created by Ios_Developer on 2017/12/6.
//  Copyright © 2017年 hai. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 消息cell页面自定义
 */
@interface MessageCell : UITableViewCell

//属性变量定义
@property (nonatomic ,assign)int type;             //-----type 0 对方 1 自己
@property (nonatomic ,strong)UIImageView *headerIV;
@property (nonatomic ,strong)UILabel *nameL;
@property (nonatomic ,strong)UILabel *timeL;
@property (nonatomic ,strong)UIView *messageView;
@property (nonatomic ,strong)UILabel *messageL;

//实现方法
-(void)getMessage:(NSDictionary *)messageDic;
-(void)reframe;                                 //--------刷新messageView
-(CGFloat)getCellHeight;
@end
