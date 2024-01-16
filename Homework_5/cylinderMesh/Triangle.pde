/*
* @Author: bit2atom | SJTU-ChinaGold DesignIntelligence
* @Date:   2022-10-20 21:13:48
* @brief:  
* @Last Modified by:   lymanzhang
* @Last Modified time: 2022-10-20 21:23:05
* @E-mail: zhanglliqun@gmail.com
* @detail: 
*/
class Triangle {
  PVector[] triVertex;//三角形三个点向量
  PVector[] contourVertex;//三角形三个内轮廓向量
  float contourRatio = 0.25;//内轮廓宽度比例：值越小内轮廓宽度越大，中间孔洞越小
  PVector center;//三角形中心点向量
  PVector normal;//三角形法线向量
  boolean drawShape;//是否绘制三角形
  boolean drawContour;//是否绘制三角形内轮廓
  color triangleColor;//三角形颜色
  
  //构造函数
  Triangle(PVector p1, PVector p2, PVector p3) {
    triVertex = new PVector[3];
    contourVertex = new PVector[triVertex.length];
    triVertex[0] = p1;
    triVertex[1] = p2;
    triVertex[2] = p3;
    center = ct();
    normal = calcuNormal();
    contourVertex = contour();
  }
  
  void setColor(int r, int g, int b) {
    triangleColor = color(r, g, b);
  }
  
  void run() {
    if (drawShape) {
      if (drawContour) {
        drawTriangleContour();//绘制三角形内轮廓
      } else {
        drawTriangle();//绘制三角形
      }
      if (showNormalLine) {
        displayNormal();//绘制法线
      }
    }
  }

  /**
   * [calcuNormal description]
   * @Author   bit2atom
   * @DateTime 2022-10-20T21:22:23+0800
   * @return   {[PVector]}                 [计算三角形法线向量]
   */
  PVector calcuNormal() {
    PVector p1p2 = PVector.sub(triVertex[1], triVertex[0]);
    PVector p1p3 = PVector.sub(triVertex[2], triVertex[0]);
    PVector norm = p1p2.cross(p1p3);
    return norm;
  }

  /**
   * [contour description]
   * @Author   bit2atom
   * @DateTime 2022-10-20T21:22:29+0800
   * @return   {[PVector[]]}                 [计算三角形三个内轮廓向量值]
   *         #
   *       # # #
   *      #  #   #
   *     #   #     #
   *    #   #  #    #
   *   #   #     #    #
   *  #   # # # # #     #
   * # #             #    #
   * # # # # # # # # # # # #
   */
   PVector[] contour() {
      PVector[] ctmp = new PVector[contourVertex.length];
      for (int i = 0; i < triVertex.length; i ++) {
        PVector tmp = PVector.sub(triVertex[i], center);
        float len = tmp.mag();
        len *= contourRatio;
        tmp.normalize();
        tmp.setMag(len);
        tmp.add(center);
        ctmp[i] = new PVector(tmp.x, tmp.y, tmp.z);
      }
      return ctmp;
    }


  /**
   * [drawTriangleContour description]
   * @Author   bit2atom
   * @DateTime 2022-10-20T21:22:35+0800
   * @return   {[void]}                 [绘制三角形内轮廓：三个四边形]
   */
  void drawTriangleContour() {
    noFill(); // No fill for contour
    stroke(triangleColor);
    strokeWeight(1);

    for (int i = 0; i < 3; i ++) {
      beginShape(QUAD);
      vertex(triVertex[i].x, triVertex[i].y, triVertex[i].z);
      vertex(contourVertex[i].x, contourVertex[i].y, contourVertex[i].z);
      vertex(contourVertex[(i+1)%3].x, contourVertex[(i+1)%3].y, contourVertex[(i+1)%3].z);
      vertex(triVertex[(i+1)%3].x, triVertex[(i+1)%3].y, triVertex[(i+1)%3].z);
      endShape();
    }
  }

  /**
   * [drawTriangle description]
   * @Author   bit2atom
   * @DateTime 2022-10-20T21:22:48+0800
   * @return   {[void]}                 [绘制三角形]
   */
  void drawTriangle() {
    fill(triangleColor);
    stroke(0);
    strokeWeight(1);
    fill(255);
    for (int i = 0; i < triVertex.length; i ++) {
      vertex(triVertex[i].x, triVertex[i].y, triVertex[i].z);
    }
    endShape();
  }

  /**
   * [ct description]
   * @Author   bit2atom
   * @DateTime 2022-10-20T21:22:54+0800
   * @return   {[PVector]}                 [计算三角形中心点向量]
   */
  PVector ct() {
    float cx = 0;
    float cy = 0;
    float cz = 0;

    for (int i = 0; i < triVertex.length; i ++) {
      cx += triVertex[i].x;
      cy += triVertex[i].y;
      cz += triVertex[i].z;
    }

    cx /= 3.0;
    cy /= 3.0;
    cz /= 3.0;
    PVector cv = new PVector(cx, cy, cz);

    return cv;
  }

  /**
   * [displayNormal description]
   * @Author   bit2atom
   * @DateTime 2022-10-20T21:23:02+0800
   * @return   {[void]}                 [绘制三角形法线]
   */
  void displayNormal() {
    PVector nm = new PVector(normal.x, normal.y, normal.z);
    nm.normalize();//法线向量归一化
    nm.setMag(10);//设置法线长度为10
    nm.add(center);
    stroke(0);
    strokeWeight(3);
    point(center.x, center.y, center.z);//三角形中心点
    stroke(200, 0, 200);
    strokeWeight(1);
    line(center.x, center.y, center.z, nm.x, nm.y, nm.z);//从三角形中心点向发现顶点绘制一条直线
  }
}
