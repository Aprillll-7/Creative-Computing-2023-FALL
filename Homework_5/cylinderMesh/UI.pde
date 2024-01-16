/**
 * [UI description]
 * @Author   bit2atom
 * @DateTime 2022-07-29T10:10:26+0800
 */
import controlP5.*;
import peasy.*;

ControlP5 slider;
PeasyCam cam;

void UI() {
  int sliderWidth = 300;//控制条宽度
  int sliderHeight = 30;//控制条高度

  cam = new PeasyCam(this, 800);

  slider = new ControlP5(this, createFont("微软雅黑", 14));

  slider.addSlider("heightSection")//圆柱体高度细分数
    .setPosition(20, 20)
    .setSize(sliderWidth, sliderHeight)
    .setRange(1, 72)
    .setValue(36)
    ;

  slider.addSlider("laySection")//圆柱体每层扇面细分数
    .setPosition(20, 60)
    .setSize(sliderWidth, sliderHeight)
    .setRange(3, 128)
    .setValue(72)
    ;

  slider.addSlider("layerHeight")//每层高度
    .setPosition(20, 100)
    .setSize(sliderWidth, sliderHeight)
    .setRange(0, 200)
    .setValue(20)
    ;

  slider.addSlider("rotateRange")//圆柱体轴向扭曲弧度值
    .setPosition(20, 140)
    .setSize(sliderWidth, sliderHeight)
    .setRange(0, PI*8)
    .setValue(PI)
    ;

  slider.addSlider("ProbOfShowShape")//每个三角形单元的显示概率
    .setPosition(20, 180)
    .setSize(sliderWidth, sliderHeight)
    .setRange(0, 1)
    .setValue(0.75)
    ;

  slider.addSlider("ProbOfShowContourShape")//每个三角形单元绘制内轮廓的概率
    .setPosition(20, 220)
    .setSize(sliderWidth, sliderHeight)
    .setRange(0, 1)
    .setValue(0.5)
    ;

  slider.addToggle("showNormal")//显示三角形单元法线
    .setPosition(20, height-100)
    .setSize(sliderWidth/3, sliderHeight)
    .setValue(true)
    .setMode(ControlP5.SWITCH)
    ;
    
  slider.addSlider("Red")
    .setPosition(20, 260)
    .setSize(sliderWidth, sliderHeight)
    .setRange(0, 255)
    .setValue(127);

  slider.addSlider("Green")
    .setPosition(20, 300)
    .setSize(sliderWidth, sliderHeight)
    .setRange(0, 255)
    .setValue(127);

  slider.addSlider("Blue")
    .setPosition(20, 340)
    .setSize(sliderWidth, sliderHeight)
    .setRange(0, 255)
    .setValue(127);
  
   slider.addSlider("Radius")
    .setPosition(20, 380)
    .setSize(sliderWidth, sliderHeight)
    .setRange(50, 500)
    .setValue(0)
    ;

  slider.setAutoDraw(false);
}

/**
 * [showNormal description]
 * @Author   bit2atom
 * @DateTime 2022-10-20T21:18:36+0800
 * @param    {[type]}                 boolean theFlag       [toggle status: on / off]
 * @return   {[type]}                         [该toggle用于控制法线的显示]
 */
void showNormal(boolean theFlag) {
  if (theFlag==true) {
    showNormalLine = true;
  } else {
    showNormalLine = false;
  }
}

/**
 * [controlEvent description]
 * @Author   bit2atom
 * @DateTime 2022-07-29T10:09:57+0800
 * @param    {[type]}                 ControlEvent theEvent      [当对应的控件实践发生时运行相关函数（此处为setSystem()）]
 * @return   {[type]}                              [description]
 */
void controlEvent(ControlEvent theEvent) {
  if (theEvent.isFrom(slider.getController("heightSection")) ||
    theEvent.isFrom(slider.getController("laySection")) ||
    theEvent.isFrom(slider.getController("layerHeight")) ||
    theEvent.isFrom(slider.getController("rotateRange")) ||
    theEvent.isFrom(slider.getController("ProbOfShowShape")) ||
    theEvent.isFrom(slider.getController("ProbOfShowContourShape")) ||
    theEvent.isFrom(slider.getController("Red")) || 
    theEvent.isFrom(slider.getController("Green")) ||
    theEvent.isFrom(slider.getController("Blue")) ||
    theEvent.isFrom(slider.getController("Radius")))
    
      setSystem();
}
