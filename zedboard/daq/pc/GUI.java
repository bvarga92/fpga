package udpscope;

import java.awt.event.*;
import java.awt.image.*;
import java.awt.*;
import javax.swing.*;

public class GUI extends JFrame{

	private static final long serialVersionUID=1L;
	private Control ctrl=null;
	private JTextArea taIP=null;
	private JTextArea taPort=null;
	private DrawCanvas canvas=null;
	private int[] ch1 = new int[1024];
	private int[] ch2 = new int[1024];
	private int bufcntr=0;

	GUI(Control c){
		super("UDP Scope");
		ctrl=c;
		setSize(640,700);
		setDefaultCloseOperation(EXIT_ON_CLOSE);
		JPanel panel = new JPanel(new FlowLayout());
		JLabel label = new JLabel("IP:");
		panel.add(label);
		taIP = new JTextArea("192.168.1.55");
		taIP.setPreferredSize(new Dimension(110,18));
		panel.add(taIP);
		label = new JLabel("Port:");
		panel.add(label);
		taPort = new JTextArea("1234");
		taPort.setPreferredSize(new Dimension(50,18));
		panel.add(taPort);
		JButton btn = new JButton("Start");
		btn.addActionListener(new ActionListener(){
			@Override
			public void actionPerformed(ActionEvent e){
				int port=Integer.parseInt(taPort.getText());
				ctrl.start(port,taIP.getText());
			}
		});
		panel.add(btn);
		btn = new JButton("Stop");
		btn.addActionListener(new ActionListener(){
			@Override
			public void actionPerformed(ActionEvent e){
				ctrl.stop();
			}
		});
		panel.add(btn);
		canvas=new DrawCanvas();
		canvas.setPreferredSize(new Dimension(640,650));
		Container cp=getContentPane();
		cp.setLayout(new BorderLayout());
		cp.add(canvas,BorderLayout.CENTER);
		cp.add(panel,BorderLayout.NORTH);
		pack();
		setResizable(false);
		setVisible(true);
	}
	
	private class DrawCanvas extends JPanel{
		private static final long serialVersionUID=1L;
		@Override
		public void paintComponent(Graphics g){
			super.paintComponent(g);
			Graphics2D g2=(Graphics2D)g;
			draw(g2);
		}
	}

	private void draw(Graphics2D g2){
		if((ch1==null)||(ch2==null)) return;
		/* feher hatter + a ket alapvonal */
		BufferedImage dispBuff=new BufferedImage(canvas.getWidth(),canvas.getHeight(),BufferedImage.TYPE_INT_RGB);
		Graphics2D g2dScreen=dispBuff.createGraphics();
		g2dScreen.setBackground(Color.WHITE);
		g2dScreen.clearRect(0,0,canvas.getWidth(),canvas.getHeight());
		g2dScreen.setStroke(new BasicStroke(2));
		g2dScreen.setPaint(Color.BLACK);
		g2dScreen.drawLine(0,180,canvas.getWidth(),180);
		g2dScreen.drawLine(0,480,canvas.getWidth(),480);
		/* maximumkereses */
		int max1, max2;
		max1=ch1[0];
		max2=ch2[0];
		for(int i=0;i<1024;i++){
			if((ch1[i]>max1)||(-ch1[i]>max1)) max1=ch1[i];
			if((ch2[i]>max1)||(-ch2[i]>max1)) max2=ch2[i];
		}
		double scale=((max1>max2)?(1.0/max1):(1.0/max2))*120;
		/* trigger */
		int trigPos=0;
		for(int i=1;i<1023;i++)
			if(ch1[i]<0.2*max1 && ch1[i]>-0.2*max1)
				if(ch1[i-1]<ch1[i] && ch1[i+1]>ch1[i]){
					trigPos=i;
					break;
				}
		/* kirajzolas */
		for(int x=0;(x+trigPos<1023)&&(x<canvas.getWidth());x++){
			g2dScreen.setPaint(Color.RED);
			g2dScreen.drawLine(x,(int)(180-ch1[x+trigPos]*scale),x+1,(int)(180-ch1[x+trigPos+1]*scale));
			g2dScreen.setPaint(Color.BLUE);
			g2dScreen.drawLine(x,(int)(480-ch2[x+trigPos]*scale),x+1,(int)(480-ch2[x+trigPos+1]*scale));
		}
		g2.drawImage(dispBuff,null,0,0);
		g2dScreen.dispose();
	}

	public void displayData(int[] data1, int[] data2){
		for(int i=0;i<128;i++){
			ch1[i+128*bufcntr]=data1[i];
			ch2[i+128*bufcntr]=data2[i];
		}
		if(bufcntr==7){
			bufcntr=0;
			canvas.repaint();
		}
		else{
			bufcntr++;
		}
	}
	
}
