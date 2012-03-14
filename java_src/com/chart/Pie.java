package com.chart;

import java.awt.Color;
import java.awt.geom.Arc2D;
import java.awt.geom.Area;
import java.awt.geom.GeneralPath;
import java.awt.geom.Point2D;


class Pie {
    private Arc2D arc;
    private Area frontWall;
    private Area leftWall;
    private Area rightWall;
    private Color color;
    private int shadowDepth;
    private Pie selectedPie;
    private Point2D labelPosition;
//    private double shiftDis = 8; // 被选中的饼图在他的中线上移动的距离
    private double shiftDis = 80; // 被选中的饼图在他的中线上移动的距离
    private double value;
  
    public Pie(Arc2D arc, Color color, int shadowDepth, double value) {
        this.arc = arc;
        this.color = color;
        this.value = value;
        this.shadowDepth = shadowDepth;
  
        Arc2D arcBottom = new Arc2D.Double(arc.getX(), arc.getY() + shadowDepth, arc.getWidth(),
            arc.getHeight() + 0, arc.getAngleStart(), arc.getAngleExtent(), Arc2D.CHORD);
        Point2D[] topPs = getPointsOfArc(arc);
        Point2D[] bottomPs = getPointsOfArc(arcBottom);
  
        // Front wall
        GeneralPath font = new GeneralPath();
        font.moveTo(topPs[1].getX(), topPs[1].getY());
        font.lineTo(topPs[2].getX(), topPs[2].getY());
        font.lineTo(bottomPs[2].getX(), bottomPs[2].getY());
        font.lineTo(bottomPs[1].getX(), bottomPs[1].getY());
        font.closePath();
        this.frontWall = new Area(arcBottom);
        this.frontWall.add(new Area(font));
  
        // Left wall
        GeneralPath left = new GeneralPath();
        left.moveTo(topPs[0].getX(), topPs[0].getY());
        left.lineTo(topPs[1].getX(), topPs[1].getY());
        left.lineTo(bottomPs[1].getX(), bottomPs[1].getY());
        left.lineTo(topPs[0].getX(), topPs[0].getY());
        left.closePath();
        this.leftWall = new Area(left);
  
        // Right wall
        GeneralPath right = new GeneralPath();
        right.moveTo(topPs[0].getX(), topPs[0].getY());
        right.lineTo(topPs[2].getX(), topPs[2].getY());
        right.lineTo(bottomPs[2].getX(), bottomPs[2].getY());
        right.lineTo(topPs[0].getX(), topPs[0].getY());
        right.closePath();
        this.rightWall = new Area(right);
  
        // Label position: 四分之三处
        Point2D c = getArcCenter();
        Point2D m = getChordCenter();
  
        double x = ((m.getX() + c.getX()) / 2 + m.getX()) / 2;
        double y = ((m.getY() + c.getY()) / 2 + m.getY()) / 2;
        labelPosition = new Point2D.Double(x, y);
    }
  
    // 取得Arc上的三个点，在对Arc: center, left, right.
    public static Point2D[] getPointsOfArc(Arc2D arc) {
        Point2D[] points = new Point2D[3];
        Point2D center = new Point2D.Double(arc.getCenterX(), arc.getCenterY());
        Point2D left = new Point2D.Double(arc.getStartPoint().getX(), arc.getStartPoint().getY());
        Point2D right = new Point2D.Double(arc.getEndPoint().getX(), arc.getEndPoint().getY());
        points[0] = center;
        points[1] = left;
        points[2] = right;
  
        return points;
    }
  
    public Pie getSelectedPie() {
        if (selectedPie == null) {
            selectedPie = createSeletecdPie();
        }
  
        return selectedPie;
    }
  
    private Pie createSeletecdPie() {
        // 沿中线方向移动5个单位
        Point2D[] ps = getPointsOfArc(arc);
        Point2D c = ps[0];
        Point2D m = new Point2D.Double((ps[1].getX() + ps[2].getX()) / 2,
            (ps[1].getY() + ps[2].getY()) / 2);
        double dis = Math.sqrt((m.getX() - c.getX()) * (m.getX() - c.getX())
                + (m.getY() - c.getY()) * (m.getY() - c.getY()));
  
        double deltaX = shiftDis * (m.getX() - c.getX()) / dis;
        double deltaY = shiftDis * (m.getY() - c.getY()) / dis;
  
        Arc2D shiftArc = (Arc2D) arc.clone();
        shiftArc
            .setFrame(arc.getX() + deltaX, arc.getY() + deltaY, arc.getWidth(), arc.getHeight());
  
        return new Pie(shiftArc, color, shadowDepth, value);
    }
  
    public Arc2D getArc() {
        return arc;
    }
  
    public void setArc(Arc2D arc) {
        this.arc = arc;
    }
  
    public Area getFrontWall() {
        return frontWall;
    }
  
    public void setFrontWall(Area frontWall) {
        this.frontWall = frontWall;
    }
  
    public Area getLeftWall() {
        return leftWall;
    }
  
    public void setLeftWall(Area leftWall) {
        this.leftWall = leftWall;
    }
  
    public Area getRightWall() {
        return rightWall;
    }
  
    public void setRightWall(Area rightWall) {
        this.rightWall = rightWall;
    }
  
    public Color getColor() {
        return color;
    }
  
    public void setColor(Color color) {
        this.color = color;
    }
  
    public Point2D getLabelPosition() {
        return labelPosition;
    }
  
    public void setLabelPosition(Point2D labelPosition) {
        this.labelPosition = labelPosition;
    }
  
    public double getValue() {
        return value;
    }
  
    public void setValue(double value) {
        this.value = value;
    }
  
    public Point2D getChordCenter() {
        Point2D[] ps = getPointsOfArc(arc);
        Point2D m = new Point2D.Double((ps[1].getX() + ps[2].getX()) / 2,
            (ps[1].getY() + ps[2].getY()) / 2);
  
        return m;
    }
  
    public Point2D getArcCenter() {
        Point2D[] ps = getPointsOfArc(arc);
        return ps[0];
    }
} 
