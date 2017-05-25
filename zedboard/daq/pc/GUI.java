package udpscope;

import java.awt.*;
import java.awt.event.*;
import java.awt.image.*;
import javax.swing.*;

public class GUI extends JFrame{

	private static final long serialVersionUID=1L;
	private static final int windowW=640;
	private static final int windowH=700;
	private static final int ch1Y=180;
	private static final int ch2Y=500;
	private static final int maxAmp=130;
	private static final String defaultIP="192.168.1.55";
	private static final String defaultPort="1234";
	
	private Control ctrl=null;
	private JTextArea taIP=null;
	private JTextArea taPort=null;
	private DrawCanvas canvas=null;
	private int[] ch1=null;
	private int[] ch2=null;
	private int trigCh=1;

	GUI(Control c){
		super("UDP Scope");
		ctrl=c;
		setSize(windowW,windowH);
		setDefaultCloseOperation(EXIT_ON_CLOSE);
		JPanel panel = new JPanel(new FlowLayout());
		JLabel label = new JLabel("IP address:");
		panel.add(label);
		taIP = new JTextArea(defaultIP);
		taIP.setPreferredSize(new Dimension(110,18));
		panel.add(taIP);
		label = new JLabel("Port:");
		panel.add(label);
		taPort = new JTextArea(defaultPort);
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
		label = new JLabel("       Trigger:");
		panel.add(label);
		String[] str={"CH1","CH2"};
		JComboBox<String> cb=new JComboBox<String>(str);
		cb.addActionListener(new ActionListener(){
			@Override
			public void actionPerformed(ActionEvent e){
				trigCh=cb.getSelectedIndex()+1;
			}
		});
		cb.setSelectedIndex(0);
		panel.add(cb);
		canvas=new DrawCanvas();
		canvas.setPreferredSize(new Dimension(windowW,windowH-50));
		Container cp=getContentPane();
		cp.setLayout(new BorderLayout());
		cp.add(canvas,BorderLayout.CENTER);
		cp.add(panel,BorderLayout.NORTH);
		pack();
		canvas.requestFocus();
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
		BufferedImage dispBuff=new BufferedImage(canvas.getWidth(),canvas.getHeight(),BufferedImage.TYPE_INT_RGB);
		Graphics2D g2dScreen=dispBuff.createGraphics();
		/* hatter */
		g2dScreen.setBackground(canvas.getBackground());
		g2dScreen.clearRect(0,0,canvas.getWidth(),canvas.getHeight());
		g2dScreen.setStroke(new BasicStroke(2.0f));
		g2dScreen.setPaint(Color.WHITE);
		g2dScreen.fillRect(0,ch1Y-maxAmp,canvas.getWidth(),2*maxAmp);
		g2dScreen.setPaint(Color.BLACK);
		g2dScreen.drawLine(0,ch1Y,canvas.getWidth(),ch1Y);
		g2dScreen.drawLine(0,ch1Y+maxAmp,canvas.getWidth(),ch1Y+maxAmp);
		g2dScreen.drawLine(0,ch1Y-maxAmp,canvas.getWidth(),ch1Y-maxAmp);
		g2dScreen.setPaint(Color.WHITE);
		g2dScreen.fillRect(0,ch2Y-maxAmp,canvas.getWidth(),2*maxAmp);
		g2dScreen.setPaint(Color.BLACK);
		g2dScreen.drawLine(0,ch2Y,canvas.getWidth(),ch2Y);
		g2dScreen.drawLine(0,ch2Y+maxAmp,canvas.getWidth(),ch2Y+maxAmp);
		g2dScreen.drawLine(0,ch2Y-maxAmp,canvas.getWidth(),ch2Y-maxAmp);
		g2dScreen.setFont(new Font("Serif",Font.PLAIN,24));
		String str="CHANNEL 1";
		int strW=g2dScreen.getFontMetrics().stringWidth(str);
		g2dScreen.drawString(str,(windowW-strW)/2,ch1Y-maxAmp-10);
		str="CHANNEL 2";
		strW=g2dScreen.getFontMetrics().stringWidth(str);
		g2dScreen.drawString(str,(windowW-strW)/2,ch2Y-maxAmp-10);
		if((ch1!=null)&&(ch2!=null)){
			/* maximumkereses, autoscale */
			int max1, max2;
			max1=Math.abs(ch1[0]);
			max2=Math.abs(ch2[0]);
			for(int i=1;i<1024;i++){
				if(Math.abs(ch1[i])>max1) max1=Math.abs(ch1[i]);
				if(Math.abs(ch2[i])>max2) max2=Math.abs(ch2[i]);
			}
			double scale=(max1>max2)?(((double)maxAmp)/max1):(((double)maxAmp)/max2);
			/* trigger */
			int trigPos=0;
			boolean found=false;
			double lim=(trigCh==1)?(0.2*max1):(0.2*max2);
			for(int i=1;i<1023;i++){
				int val=(trigCh==1)?(ch1[i]):(ch2[i]);
				if(found==false){
					if(val<-lim) found=true;
				}
				else if(val>lim){
					trigPos=i;
					break;
				}
			}
			/* jelek kirajzolasa */
			g2dScreen.setStroke(new BasicStroke(1.5f));
			for(int x=0;(x+trigPos<1023)&&(x<canvas.getWidth());x++){
				g2dScreen.setPaint(Color.RED);
				g2dScreen.drawLine(x,(int)(ch1Y-ch1[x+trigPos]*scale),x+1,(int)(ch1Y-ch1[x+trigPos+1]*scale));
				g2dScreen.setPaint(Color.BLUE);
				g2dScreen.drawLine(x,(int)(ch2Y-ch2[x+trigPos]*scale),x+1,(int)(ch2Y-ch2[x+trigPos+1]*scale));
			}
		}
		g2.drawImage(dispBuff,null,0,0);
		g2dScreen.dispose();
	}

	public void displayData(int[] data1, int[] data2){
		ch1=data1;
		ch2=data2;
		canvas.repaint();
	}

}
