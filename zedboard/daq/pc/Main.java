package udpscope;

public class Main{

	public static void main(String[] args){
		Control c = new Control();
		Network n = new Network(c);
		GUI g = new GUI(c);
		c.setGUI(g);
		c.setNetwork(n);
	}

}
