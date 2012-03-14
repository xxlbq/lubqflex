package com.chart;

import java.awt.Color;
import java.awt.FontMetrics;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.RenderingHints;
import java.awt.Toolkit;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.geom.Arc2D;
import java.util.ArrayList;
import java.util.List;

import javax.swing.JFrame;
import javax.swing.JPanel;

/**  
 * 绘制3D效果的饼图  
 *
 * @author Biao  
 */  
@SuppressWarnings("serial")
public class Pies3D extends JPanel {
    // 在饼图中显示的数据
    private double[] data = { 10.72, 15.38, 3.74, 10.26, 6.56, 5.69, 10.72, 15.38, 6.15, 18.0 };
    private Color[] defaultColors; // 预定义饼图的颜色
    private Pie[] pies;
  
    private int shadowDepth = 200;
    int selectedIndex = -1; // 鼠标点击是选中的Arc, -1为没有选中
  
    public Pies3D() {
        initColors();
        initPies(data, defaultColors, shadowDepth);
  
        // 取得鼠标选中的饼图: arc
        addMouseListener(new MouseAdapter() {
            @Override  
            public void mouseClicked(MouseEvent e) {
                selectedIndex = -1;
                for (int i = 0; i < pies.length; ++i) {
                    if (pies[i].getArc().contains(e.getX(), e.getY())) {
                        selectedIndex = i;
                        break;
                    }
                }
                repaint();
            }
        });
    }
  
    private void initColors() {
        List<Color> colors = new ArrayList<Color>();
        colors.add(getColorFromHex("#FF7321"));
        colors.add(getColorFromHex("#169800"));
        colors.add(getColorFromHex("#00E500"));
        colors.add(getColorFromHex("#D0F15A"));
        colors.add(getColorFromHex("#AA6A2D"));
        colors.add(getColorFromHex("#BFDD89"));
        colors.add(getColorFromHex("#E2FF55"));
        colors.add(getColorFromHex("#D718A5"));
        colors.add(getColorFromHex("#00DBFF"));
        colors.add(getColorFromHex("#00FF00"));
        defaultColors = colors.toArray(new Color[0]);
    }
  
    public void initPies(double[] data, Color[] colors, int shadowDepth) {
        double sum = 0;
        for (double d : data) {
            sum += d;
        }
  
        // 初始化Pies
        List< Arc2D> arcList = new ArrayList< Arc2D>();
        List< Pie> pieList = new ArrayList< Pie>();
  
        double arcAngle = 0;
        int x = 50;
        int y = 50;
        int w = 380;
        int h = (int) (w * 0.618);
        int startAngle = 30;
        int sumAngle = 0;
        for (int i = 0; i < data.length; ++i) {
            arcAngle = data[i] * 360 / sum;
            if (i + 1 == data.length && sumAngle < 360) {
                arcAngle = 360 - sumAngle;
            }
  
            Arc2D.Double arc = new Arc2D.Double(x, y, w, h, startAngle, arcAngle, Arc2D.PIE);
            arcList.add(arc);
  
            Pie pie = new Pie(arc, colors[i % colors.length], shadowDepth, data[i]);
            pieList.add(pie);
  
            sumAngle += arcAngle;
            startAngle += arcAngle;
        }
        pies = pieList.toArray(new Pie[0]);
    }
  
    public static Color getColorFromHex(String hex) {
        try {
            return new Color(Integer.valueOf(hex.substring(1), 16));
        } catch (Exception e) {
            return Color.BLACK;
        }
    }
  
    @Override  
    protected void paintComponent(Graphics g) {
        super.paintComponent(g);
        Graphics2D g2d = (Graphics2D) g;
        g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
  
        showPies(g2d);
    }
  
    private void showPies(Graphics2D g2d) {
        int startIndex = 0; // 从第几个饼图开始绘制
        int endIndex = pies.length; // 要画的饼图的数量.
  
        // 一次性绘制完3D效果，然后再绘制饼图的效果比绘制饼图的同时绘制好
        for (int i = startIndex; i < endIndex; ++i) {
            if (i != selectedIndex) {
                g2d.setColor(pies[i].getColor().darker());
                g2d.fill(pies[i].getFrontWall());
            }
        }
  
        // 第一个和最后一个要特殊处理
        if (selectedIndex != startIndex) {
            g2d.setColor(pies[startIndex].getColor().darker());
            g2d.fill(pies[startIndex].getLeftWall());
        }
  
        if (selectedIndex != endIndex - 1) {
            g2d.setColor(pies[endIndex - 1].getColor().darker());
            g2d.fill(pies[endIndex - 1].getRightWall());
        }
  
        // 绘制选中的Arc前一个与后一个的墙
        if (selectedIndex != -1) {
            int previousIndex = selectedIndex > startIndex ? (selectedIndex - 1) : endIndex - 1;
            int nextIndex = (selectedIndex + 1) >= endIndex ? startIndex : (selectedIndex + 1);
  
            // 前一个画右墙
            g2d.setColor(pies[previousIndex].getColor().darker());
            g2d.fill(pies[previousIndex].getRightWall());
  
            // 后一个画左墙
            g2d.setColor(pies[nextIndex].getColor().darker());
            g2d.fill(pies[nextIndex].getLeftWall());
        }
  
        FontMetrics metrics = g2d.getFontMetrics();
        // 绘制饼图，把不需要的部分隐藏掉
        for (int i = startIndex; i < endIndex; ++i) {
            if (i != selectedIndex) {
                Pie p = pies[i];
                g2d.setColor(p.getColor());
                g2d.fill(p.getArc());
  
                String value = p.getValue() + "%";
                int w = metrics.stringWidth(value) / 2;
                g2d.setColor(Color.BLACK);
                g2d.drawString(value, (int) (p.getLabelPosition().getX() - w),
                    (int) (p.getLabelPosition().getY()));
            }
        }
  
        // 绘制被选中的饼图
        if (selectedIndex != -1) {
            Pie p = pies[selectedIndex].getSelectedPie();
            g2d.setColor(p.getColor().darker());
            g2d.fill(p.getFrontWall());
            g2d.fill(p.getLeftWall());
            g2d.fill(p.getRightWall());
  
            g2d.setColor(p.getColor());
            g2d.fill(p.getArc());
  
            String value = p.getValue() + "%";
            int w = metrics.stringWidth(value) / 2;
            g2d.setColor(Color.BLACK);
            g2d.drawString(value, (int) (p.getLabelPosition().getX() - w),
                (int) (p.getLabelPosition().getY()));
        }
    }
  
    private static void createGuiAndShow() {
        JFrame frame = new JFrame("Pie with 3D Effect");
        frame.getContentPane().add(new Pies3D());
  
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        int sw = Toolkit.getDefaultToolkit().getScreenSize().width;
        int sh = Toolkit.getDefaultToolkit().getScreenSize().height;
        int w = 500;
        int h = 400;
        int x = (sw - w) / 2;
        int y = (sh - h) / 2 - 40;
        x = x > 0 ? x : 0;
        y = y > 0 ? y : 0;
        frame.setBounds(x, y, w, h);
        frame.setVisible(true);
    }
  
    public static void main(String[] args) {
        createGuiAndShow();
    }
}  
