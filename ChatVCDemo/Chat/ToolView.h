//
//  ToolView.h
//  ChatVCDemo
//
//  Created by Ios_Developer on 2017/12/28.
//  Copyright © 2017年 hai. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Block_SendMessage)(UITextView *chatTV);
@interface ToolView : UIView

@property (nonatomic ,copy)Block_SendMessage sendMessage;
@property (nonatomic ,strong)UITextView *chatTV;
@property (nonatomic ,assign)CGFloat chatTVHeight;

@end
