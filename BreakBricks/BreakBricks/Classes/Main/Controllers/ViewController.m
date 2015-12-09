//
//  ViewController.m
//  BreakBricks
//
//  Created by jiaguanglei on 15/12/9.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#import "ViewController.h"
#import "BrickView.h"
#import "UIView+Extension.h"
#import <QuartzCore/QuartzCore.h>
#import "ROAudioTool.h"


@interface ViewController ()
{
    CGPoint _ballVelocity;
    CGPoint _ballCenter_Original;
    CGPoint _paddleCenter_Original;
    // 挡板的水平速度
    CGFloat         _paddleVelocityX;
    CADisplayLink *_link;
    UITapGestureRecognizer *_tap;
}
 /**  砖块图片 ***/
@property (nonatomic, strong) NSArray *images;
 /**  砖块 ***/
@property (nonatomic, strong) NSMutableArray *bricks;
 /**  小球 ***/
@property (nonatomic, weak) UIImageView *ball;
/**  挡板 ***/
@property (nonatomic, weak) UIImageView *paddle;
/**  小球初始位置 ***/
//@property (nonatomic, assign) CGPoint ballCenter_Original;

@end

@implementation ViewController
#pragma mark - 懒加载
- (NSArray *)images{
    if (!_images) {
        _images = [NSArray arrayWithObjects:@"blue", @"yellow", @"red", @"green", nil];
    }
    return _images;
}

- (UIImageView *)ball{
    if (!_ball) {
        UIImageView *ball = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ball"]];
        ball.size = CGSizeMake(BALL_WIDTH, BALL_HEIGHT);
        ball.layer.cornerRadius = BALL_WIDTH * 0.5;
        ball.layer.masksToBounds = YES;
        [self.view addSubview:ball];
        _ball = ball;
        
//        _ball.image = [UIImage imageNamed:@"ball"];
    }
    return _ball;
}

- (UIImageView *)paddle{
    if (!_paddle) {
        UIImageView *paddle = [[UIImageView alloc] init];
        paddle.image = [[UIImage imageNamed:@"paddle"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10) resizingMode:UIImageResizingModeStretch];
        paddle.size = CGSizeMake(PADDLE_WIDTH, PADDLE_HEIGHT);
        paddle.layer.cornerRadius = BALL_WIDTH * 0.5;
        paddle.layer.masksToBounds = YES;
        [self.view addSubview:paddle];
        _paddle = paddle;
    }
    return _paddle;
}

- (NSMutableArray *)bricks{
    if (!_bricks) {
        _bricks = [[NSMutableArray alloc] init];
    }
    return _bricks;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"打砖块";
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeBottom | UIRectEdgeRight;
    
    
    // 1. 创建UI
    [self setupUI];
    
    // 2. 添加手势
    [self addTapGesture];
    
    // 3. 记录初始位置
    _ballCenter_Original = self.ball.center;
    _paddleCenter_Original = self.paddle.center;
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"播放音乐" style:UIBarButtonItemStylePlain target:self action:@selector(playBGMusic)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"暂停音乐" style:UIBarButtonItemStylePlain target:self action:@selector(pauseBGMusic)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor darkGrayColor]];

//    [self playBGMusic];
}

#pragma mark - 播放背景音乐
- (void)playBGMusic
{
    [[ROAudioTool playMusicWithFilename:@"background-music.caf"] setNumberOfLoops:1000];
}
- (void)pauseBGMusic
{
    [ROAudioTool pauseMusicWithFilename:@"background-music.caf"];
}

#pragma mark - 重新开始
- (void)aletWithResult:(NSString *)result
{
    UIAlertController *alet = [UIAlertController alertControllerWithTitle:result message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alet addAction:[UIAlertAction actionWithTitle:@"restart" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) { // 重新开始
        [self restart];
    }]];
    [alet addAction:[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) { // 重置
        [self resetUI];
    }]];
    [self presentViewController:alet animated:YES completion:nil];

}

// 重新开始
- (void)restart
{
    [self resetUI];
    
    // 开始
    [self start:_tap];
}
- (void)resetUI
{
    self.ball.center = _ballCenter_Original;
    self.paddle.center = _paddleCenter_Original;
    // 显示所有砖块
    for (BrickView *brick in self.bricks) {
        [brick setHidden:NO];
    }
    // 允许点击
    [_tap setEnabled:YES];
}

#pragma mark - 手势
#pragma mark - 点击手势
- (void)addTapGesture
{
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(start:)];
    [self.view addGestureRecognizer:_tap];
}
// 开始游戏
- (void)start:(UITapGestureRecognizer *)tap
{
    // 取消点击
    [tap setEnabled:NO];
    
    // 开始拖拽
    [self addPinchGesture];
    
    // 设置初始速度
    _ballVelocity = CGPointMake(0, -BALL_SPEED);
    
    // 添加监听
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(ballFrameChangeState)];
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    LogRed(@"start ----- ");
}
// 监听 小球位置
- (void)ballFrameChangeState
{
    // 小球开始move
    [self.ball setCenter:CGPointMake(self.ball.centerX + _ballVelocity.x, self.ball.centerY + _ballVelocity.y)];

    // 检测
    [self intersectWithScreen];
    
    // 与砖碰撞检测
    [self intersectWithBricks];
    
    // 挡板检测
    [self intersectWithPaddle];
}

// 屏幕挡板检测
- (void)intersectWithPaddle
{
    if(CGRectIntersectsRect(self.ball.frame, self.paddle.frame))
    {
        _ballVelocity.y = -ABS(_ballVelocity.y);
        _ballVelocity.x += _paddleVelocityX / 120;
    }
}

// 屏幕边框检测
- (void)intersectWithBricks
{
    for (BrickView *brick in self.bricks) {
        // 小球与砖块有交集 且 砖块不隐藏, 小球才进行反转
        if(CGRectIntersectsRect(self.ball.frame, brick.frame) && ![brick isHidden])
        {
            brick.hidden = YES;
            _ballVelocity.y = ABS(_ballVelocity.y);
        }
    }
    
    BOOL win = YES;
    for (BrickView *brick in self.bricks) {
        if (![brick isHidden]) {
            win = NO;
            break;
        }
    }
    // 胜利
    if(win){
        // 关闭时钟
        [_link invalidate];
        
        // 开启点击手势
//        [_tap setEnabled:YES];
        
        [self aletWithResult:@"胜利"];
    }
    
}
// 屏幕边框检测
- (void)intersectWithScreen
{
    // 顶部碰撞检测
    if (self.ball.y <= 0) {
        _ballVelocity.y = ABS(_ballVelocity.y);
    }
    // 左边框检测
    if(self.ball.x <= 0){
        _ballVelocity.x = ABS(_ballVelocity.x);
    }
    // 右边框
    if (self.ball.x >= CGRectGetMaxX(self.view.frame)) {
        _ballVelocity.x = -ABS(_ballVelocity.x);
    }
    // 底部检测
    if(CGRectGetMaxY(self.ball.frame) >= CGRectGetMaxY(self.view.frame))
    {
        LogGreen(@"你输了, 游戏结束!!!");
        
        // 关闭时钟
        [_link invalidate];
        
        // 开启用户点击
//        [_tap setEnabled:YES];
        
        [self aletWithResult:@"失败"];
    }

}

#pragma mark - 拖动手势
- (void)addPinchGesture
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panMethod:)];
//    pan.delegate = self;
    
    [self.view addGestureRecognizer:pan];
}


// 拖拽手势
- (void)panMethod:(UIPanGestureRecognizer *)pan
{
    if (UIGestureRecognizerStateChanged == pan.state) {
        CGPoint loc = [pan locationInView:self.view];
        self.paddle.centerX = loc.x;
        // 记录拖拽速度
        _paddleVelocityX = [pan velocityInView:self.view].x;
        LogRed(@"开始拖拽--- %f", _paddleVelocityX);
    }
    
    
}

#pragma mark - UI
- (void)setupUI
{
    [self setupBricks];
    
    [self setupBall];
    
    [self setupPaddle];
}
#pragma mark - 创建砖块
- (void)setupBricks
{
    CGFloat width = BV_BRICKWIDTH;
    CGFloat height = BV_BRICKHIGHT;
    for (int i = 0; i < BV_BRICKROWS * BV_BRICKCOLUMNS; i++) {
        CGFloat x = width * (i % BV_BRICKCOLUMNS);
        CGFloat y = height * (i / BV_BRICKCOLUMNS);
        UIImageView *brick = [BrickView brickWithBGImage:[UIImage imageNamed:self.images[(i / BV_BRICKCOLUMNS)]] size:CGSizeMake(BV_BRICKWIDTH, BV_BRICKHIGHT)];
        brick.frame = CGRectMake(x, y, width, height);
    
        [self.view addSubview:brick];
        [self.bricks addObject:brick];
    }

}
#pragma mark - 创建小球
- (void)setupBall
{
   _ballCenter_Original = CGPointMake(self.view.centerX, self.view.height * 0.86);
    self.ball.center = _ballCenter_Original;
}
#pragma mark - 创建挡板
- (void)setupPaddle
{
    _paddleCenter_Original = CGPointMake(self.view.centerX, CGRectGetMaxY(self.ball.frame) + PADDLE_HEIGHT * 0.5);
    self.paddle.center = _paddleCenter_Original;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
