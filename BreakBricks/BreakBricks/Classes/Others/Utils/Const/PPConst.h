#import <Foundation/Foundation.h>


#define BV_BRICKCOLUMNS 4
#define BV_BRICKROWS    4
#define BV_BRICKWIDTH (PP_SCREEN_WIDTH / BV_BRICKCOLUMNS)
#define BV_BRICKHIGHT 30

#define BALL_WIDTH 20
#define BALL_HEIGHT BALL_WIDTH
#define BALL_SPEED 10

#define PADDLE_WIDTH 350
#define PADDLE_HEIGHT 20



/**
 *  3. 获取屏幕宽度
 */
#define PP_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define PP_SCREEN_HIGHT [UIScreen mainScreen].bounds.size.height
#define PP_SCREEN_SIZE [UIScreen mainScreen].bounds.size
#define PP_SCREEN_RECT [UIScreen mainScreen].bounds


/**
 *  4. weakSelf
 */
#define WS(weakSelf)  __weak typeof(self)weakSelf = self


// ---------------------------- 打印日志  ----------------------------------
// 自定义log
#ifdef DEBUG
#define PPLog(FORMAT, ...) fprintf(stderr,"\n%s %d\n %s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
//#define PPLog(...) NSLog(@"%s %@",__func__, [NSString stringWithFormat:__VA_ARGS__])

#else
#define PPLog(FORMAT, ...)

#endif


// 打印返回responsedata
#define PPLogData(obj,content) \
if(SADEBUG) \
{ \
NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:0 error:nil]; \
NSString *string = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]; \
NSLog(@"%@----->%@",content,string); \
}


#define XCODE_COLORS_ESCAPE @"\033["
#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;"
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;"
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"

/**  不同等级的Log，也可开关，当前已开  */
#define LOG_LEVEL_Warn
#define LOG_LEVEL_INFO
#define LOG_LEVEL_ERROR
//如需关闭，就将你需要关闭的宏定义注销那么该种形式的Log将不显示或者以默认颜色显示
#ifdef LOG_LEVEL_ERROR
#define KKLogError(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"fg255,0,0;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#else
#define KKLogError(...) //NSLog(__VA_ARGS__)
#endif


// 设置输出颜色 --  需要安装Xcode colors 插件 https://github.com/robbiehanson/XcodeColors
#define XCODE_COLORS_ESCAPE @"\033["
#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color
#define LogBlue(frmt, ...) PPLog((XCODE_COLORS_ESCAPE @"fg0,0,255;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogRed(frmt, ...) PPLog((XCODE_COLORS_ESCAPE @"fg255,0,0;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogBlack(frmt, ...) PPLog((XCODE_COLORS_ESCAPE @"fg0,0,0;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogBrown(frmt, ...) PPLog((XCODE_COLORS_ESCAPE @"fg153,102,51;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogCyan(frmt, ...) PPLog((XCODE_COLORS_ESCAPE @"fg0,255,255;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogGreen(frmt, ...) PPLog((XCODE_COLORS_ESCAPE @"fg0,255,0;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogMagenta(frmt, ...) PPLog((XCODE_COLORS_ESCAPE @"fg255,0,255;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogOrange(frmt, ...) PPLog((XCODE_COLORS_ESCAPE @"fg255,127,0;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogPurple(frmt, ...) PPLog((XCODE_COLORS_ESCAPE @"fg127,0,127;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogYellow(frmt, ...) PPLog((XCODE_COLORS_ESCAPE @"fg255,255,0;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define LogWhite(frmt, ...) PPLog((XCODE_COLORS_ESCAPE @"fg255,255,255;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)


