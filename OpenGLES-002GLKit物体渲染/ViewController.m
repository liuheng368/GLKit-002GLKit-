//
//  ViewController.m
//  OpenGLES-002GLKit物体渲染
//
//  Created by Henry on 2020/8/3.
//  Copyright © 2020 Henry. All rights reserved.
//

#import "ViewController.h"
#import <GLKit/GLKit.h>
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>

typedef struct {
    GLKVector3 positionCoord;   //顶点坐标
    GLKVector2 textureCoord;   //纹理坐标
    GLKVector3 normal; //法向量
}HRVertex;

@interface ViewController () <GLKViewDelegate>
{
    EAGLContext *content;
    GLKBaseEffect *effect;
    CADisplayLink *disLink;
    GLuint angle;
    GLKView *glkView;
    HRVertex *vertexs;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.上下文创建
    [self setupContent];
    
    //2.顶点创建
    [self setupVertex];
    
    //3. 效果器创建、纹理图片加载
    [self setupEffect];
    
    //4. CADisplayLink创建
    [self setupCaDisplayLink];
}

-(void)setupContent{
    content = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if(!content){return;}
    [EAGLContext setCurrentContext:content];
    
    glkView = [[GLKView alloc] initWithFrame:CGRectMake(0, 100, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height) context:content];
    glkView.delegate = self;
    self.view = glkView;
    
    glkView.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    glkView.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    //这里相当于翻转 z 轴，使正方形朝屏幕外
    glDepthRangef(1, 0);
    /*
        //默认(0, 1)正方形朝屏幕内
        glDepthRangef(0, 1);
     */
    glClearColor(0.3, 0.1, 0.7, 1.0f);
}

-(void)setupVertex{
    vertexs = malloc(sizeof(HRVertex) * 36);
    
    //正面
    vertexs[0] = (HRVertex){{-0.5, 0.5, 0.5}, {0, 1}, {0, 0, 1}};
    vertexs[1] = (HRVertex){{-0.5, -0.5, 0.5}, {0, 0}, {0, 0, 1}};
    vertexs[2] = (HRVertex){{0.5, 0.5, 0.5}, {1, 1}, {0, 0, 1}};
    vertexs[3] = (HRVertex){{-0.5, -0.5, 0.5}, {0, 0}, {0, 0, 1}};
    vertexs[4] = (HRVertex){{0.5, 0.5, 0.5}, {1, 1}, {0, 0, 1}};
    vertexs[5] = (HRVertex){{0.5, -0.5, 0.5}, {1, 0}, {0, 0, 1}};
    
    // 上面
    vertexs[6] = (HRVertex){{0.5, 0.5, 0.5}, {1, 1}, {0, 1, 0}};
    vertexs[7] = (HRVertex){{-0.5, 0.5, 0.5}, {0, 1}, {0, 1, 0}};
    vertexs[8] = (HRVertex){{0.5, 0.5, -0.5}, {1, 0}, {0, 1, 0}};
    vertexs[9] = (HRVertex){{-0.5, 0.5, 0.5}, {0, 1}, {0, 1, 0}};
    vertexs[10] = (HRVertex){{0.5, 0.5, -0.5}, {1, 0}, {0, 1, 0}};
    vertexs[11] = (HRVertex){{-0.5, 0.5, -0.5}, {0, 0}, {0, 1, 0}};
    
    // 下面
    vertexs[12] = (HRVertex){{0.5, -0.5, 0.5}, {1, 1}, {0, -1, 0}};
    vertexs[13] = (HRVertex){{-0.5, -0.5, 0.5}, {0, 1}, {0, -1, 0}};
    vertexs[14] = (HRVertex){{0.5, -0.5, -0.5}, {1, 0}, {0, -1, 0}};
    vertexs[15] = (HRVertex){{-0.5, -0.5, 0.5}, {0, 1}, {0, -1, 0}};
    vertexs[16] = (HRVertex){{0.5, -0.5, -0.5}, {1, 0}, {0, -1, 0}};
    vertexs[17] = (HRVertex){{-0.5, -0.5, -0.5}, {0, 0}, {0, -1, 0}};
    
    // 左面
    vertexs[18] = (HRVertex){{-0.5, 0.5, 0.5}, {1, 1}, {-1, 0, 0}};
    vertexs[19] = (HRVertex){{-0.5, -0.5, 0.5}, {0, 1}, {-1, 0, 0}};
    vertexs[20] = (HRVertex){{-0.5, 0.5, -0.5}, {1, 0}, {-1, 0, 0}};
    vertexs[21] = (HRVertex){{-0.5, -0.5, 0.5}, {0, 1}, {-1, 0, 0}};
    vertexs[22] = (HRVertex){{-0.5, 0.5, -0.5}, {1, 0}, {-1, 0, 0}};
    vertexs[23] = (HRVertex){{-0.5, -0.5, -0.5}, {0, 0}, {-1, 0, 0}};
    
    // 右面
    vertexs[24] = (HRVertex){{0.5, 0.5, 0.5}, {1, 1}, {1, 0, 0}};
    vertexs[25] = (HRVertex){{0.5, -0.5, 0.5}, {0, 1}, {1, 0, 0}};
    vertexs[26] = (HRVertex){{0.5, 0.5, -0.5}, {1, 0}, {1, 0, 0}};
    vertexs[27] = (HRVertex){{0.5, -0.5, 0.5}, {0, 1}, {1, 0, 0}};
    vertexs[28] = (HRVertex){{0.5, 0.5, -0.5}, {1, 0}, {1, 0, 0}};
    vertexs[29] = (HRVertex){{0.5, -0.5, -0.5}, {0, 0}, {1, 0, 0}};
    
    // 后面
    vertexs[30] = (HRVertex){{-0.5, 0.5, -0.5}, {0, 1}, {0, 0, -1}};
    vertexs[31] = (HRVertex){{-0.5, -0.5, -0.5}, {0, 0}, {0, 0, -1}};
    vertexs[32] = (HRVertex){{0.5, 0.5, -0.5}, {1, 1}, {0, 0, -1}};
    vertexs[33] = (HRVertex){{-0.5, -0.5, -0.5}, {0, 0}, {0, 0, -1}};
    vertexs[34] = (HRVertex){{0.5, 0.5, -0.5}, {1, 1}, {0, 0, -1}};
    vertexs[35] = (HRVertex){{0.5, -0.5, -0.5}, {1, 0}, {0, 0, -1}};
    
    GLuint bufferId;
    glGenBuffers(1, &bufferId);
    glBindBuffer(GL_ARRAY_BUFFER, bufferId);
    glBufferData(GL_ARRAY_BUFFER, sizeof(HRVertex) * 36, vertexs, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(HRVertex), NULL + offsetof(HRVertex, positionCoord));
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(HRVertex), NULL + offsetof(HRVertex, textureCoord));
    
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, sizeof(HRVertex), NULL + offsetof(HRVertex, normal));
}

-(void)setupEffect{
    NSString *file = [[NSBundle mainBundle] pathForResource:@"cat" ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:file];
    NSDictionary *option = @{GLKTextureLoaderOriginBottomLeft: @(YES)};
    
    GLKTextureInfo *info = [GLKTextureLoader textureWithCGImage:[image CGImage] options:option error:nil];
    
    effect = [[GLKBaseEffect alloc] init];
    effect.texture2d0.enabled = YES;
    effect.texture2d0.name = info.name;
    effect.texture2d0.target = info.target;
    
    effect.light0.enabled = YES;
    effect.light0.diffuseColor = GLKVector4Make(1, 1, 1, 1);
    effect.light0.position = GLKVector4Make(-0.5, 0.5, 5, 1);
}

-(void)setupCaDisplayLink{
    disLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
    [disLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

-(void)update{
    //1.计算旋转度数
    angle = (angle + 1) % 360;
    //2.修改baseEffect.transform.modelviewMatrix
    effect.transform.modelviewMatrix = GLKMatrix4MakeRotation(GLKMathDegreesToRadians(angle), 0.3, 0.5, 0.7);
    //3.重新渲染
    [glkView display];
}

#pragma mark - GLKViewDelegate
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);
    [effect prepareToDraw];
    
    glDrawArrays(GL_TRIANGLES, 0, 36);
}

- (void)dealloc
{
    //displayLink 失效
    [disLink invalidate];
    disLink = nil;
    
    //重置content
    if ([EAGLContext currentContext] == [(GLKView *)self.view context] ) {
        [EAGLContext setCurrentContext:nil];
    }
    
    //顶点数组重置
    if(vertexs){
        free(vertexs);
        vertexs = nil;
    }
}
@end
