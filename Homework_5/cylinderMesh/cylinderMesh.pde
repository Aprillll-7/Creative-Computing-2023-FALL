/*
* @Author: bit2atom | SJTU-ChinaGold DesignIntelligence
 * @Date:   2022-07-29 09:27:56
 * @brief:
 * @Last Modified by:   lymanzhang
 * @Last Modified time: 2022-10-20 21:21:53
 * @E-mail: zhanglliqun@gmail.com
 * @detail:
 */

ArrayList<Triangle> triangles;

PVector[][] vp;

int heightSection = 36;//圆柱体高度细分数
int laySection = 72;//圆柱体每层扇面细分数
float Radius = 200;//圆柱体半径
float layerHeight = 20;//每层高度
int Red = 0;
int Green = 0;
int Blue = 0; //控制三角形单元的颜色
float rotateRange = PI;//圆柱体轴向扭曲弧度值

boolean showNormalLine;//是否显示法线

float ProbOfShowShape = 0.75;//每个三角形单元的显示概率
float ProbOfShowContourShape = 0.5;//每个三角形单元绘制内轮廓的概率

void setup() {
  size(1200, 1200, P3D);
  surface.setLocation(50, 50);
  
  UI();
  setSystem();
}

/**
 * [setSystem description]
 * @Author   bit2atom
 * @DateTime 2022-10-20T21:20:42+0800
 */
void setSystem() {
  initiateModelData();//初始化构成圆柱体的空间向量数组
  buildMesh(vp);//基于空间向量数组创建三角形对象

  for (Triangle t : triangles) {
    if (random(1)<ProbOfShowShape) {//如果该随机值满足该概率条件
      t.drawShape = true;
      if (random(1)<ProbOfShowContourShape){//如果该随机值满足该概率条件
        t.drawContour = true;
      }  
    }
  }
}

void draw() {
  background(102);

  lights();

  for (Triangle t : triangles) {//遍历所有的三角形
    t.setColor(Red, Green, Blue);
    t.run();
  }

  /**
   * 此处cam.beginHUD()及cam.endHUD()用于实现slider对象不受camera行为的影响，始终显示在视口指定的位置
   */
  cam.beginHUD();
  slider.draw();
  cam.endHUD();

  /**
   * [if description]
   * @Author   bit2atom
   * @DateTime 2022-10-20T21:21:19+0800
   * @param    {[type]}                 (mouseX<360 &&            mouseY< 260) || (mouseX<150 && mouseY > height-150) [description]
   * @return   {[type]}                             [此处的代码用于实现当操作交互滑块的时候，不引起视窗行为的变化]
   */
  if ((mouseX<360 && mouseY< 260) || (mouseX<150 && mouseY > height-150)) {//此限定区域为滑块所在位置
    cam.setActive(false);
  } else {
    cam.setActive(true);
  }
}

/**
 * [initiateData description]
 * @Author   bit2atom
 * @DateTime 2022-07-29T10:10:10+0800
 * @return   {[void]}                 [初始化构成圆柱体的空间向量数组]
 */
void initiateModelData() {
  vp= new PVector[heightSection][laySection];//生成一个heightSection X laySection的网格，并未网格上的每个点（向量）赋值
  for (int i = 0; i < vp.length; i ++) {
    float angSection = TWO_PI / vp[0].length;//每一层圆面切分为扇面后每个扇面的角的值
    float sectionPhaseAngle = rotateRange / vp.length;//圆柱体整体扭曲角分配到每层的相位值
    for (int j = 0; j < vp[0].length; j ++) {
      float xx = Radius * cos(angSection * j + sectionPhaseAngle * i);
      float yy = Radius * sin(angSection * j + sectionPhaseAngle * i);
      float zz = layerHeight * i;//每一层的z值随层数线上叠加
      vp[i][j] = new PVector(xx, yy, zz);
    }
  }
}

/**
 * [buildModel description]
 * @Author   bit2atom
 * @DateTime 2022-07-29T10:10:04+0800
 * @param    {[type]}                 PVector[][] model         [空间向量数组]
 * @return   {[void]}                             [基于空间向量数组创建三角形对象]
 * p1                  p2
 * #####################
 * #                   #
 * #               #   #
 * #     t1     #      #
 * #         #         #     t1: p1 -> p3 -> p2
 * #      #            #     t2: p2 -> p3 -> p4
 * #  #        t2      #
 * #                   #
 * #####################
 * p3                  p4
 */
void buildMesh(PVector[][] model) {
  triangles = new ArrayList<Triangle>();

  for (int i = 0; i < model.length - 1; i++) {
    for (int j = 0; j < model[0].length; j++) {
      // Generate a random color (you can replace this with your color logic)

      PVector p1 = new PVector(model[i][j].x, model[i][j].y, model[i][j].z);
      PVector p2 = new PVector(model[i + 1][j].x, model[i + 1][j].y, model[i + 1][j].z);
      PVector p3 = new PVector(model[i][(j + 1) % model[0].length].x, model[i][(j + 1) % model[0].length].y, model[i][(j + 1) % model[0].length].z);
      PVector p4 = new PVector(model[i + 1][(j + 1) % model[0].length].x, model[i + 1][(j + 1) % model[0].length].y, model[i + 1][(j + 1) % model[0].length].z);

      triangles.add(new Triangle(p1, p3, p2));
      triangles.add(new Triangle(p2, p3, p4));
    }
  }
}
