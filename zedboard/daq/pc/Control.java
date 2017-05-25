package udpscope;

public class Control{

	private Network net=null;
	private GUI gui=null;

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
	
	public void displayData(int[] data1, int[] data2){
		gui.displayData(data1,data2);
	}

}
