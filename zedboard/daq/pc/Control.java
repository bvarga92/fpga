package udpscope;

public class Control{

	private Network net=null;
	private GUI gui=null;
	private int[] buf1 = new int[1024];
	private int[] buf2 = new int[1024];
	private int bufCntr=0;

	Control(){}

	public void setNetwork(Network net){
		this.net=net;
	}

	public void setGUI(GUI gui){
		this.gui=gui;
	}

	public void start(int port, String ip){
		net.start(port,ip);
	}

	public void stop(){
		net.stop();
	}

	public void addData(int[] data1, int[] data2){
		for(int i=0;i<128;i++){
			buf1[i+128*bufCntr]=data1[i];
			buf2[i+128*bufCntr]=data2[i];
		}
		if(bufCntr==7){
			bufCntr=0;
			gui.displayData(buf1,buf2);
		}
		else{
			bufCntr++;
		}
	}

}
