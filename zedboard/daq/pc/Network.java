package udpscope;

import java.io.IOException;
import java.net.DatagramSocket;
import java.net.DatagramPacket;
import java.net.InetAddress;

public class Network{

	private Control ctrl=null;
	private DatagramSocket socket=null;
	private volatile byte[] recvBuffer=null;
	private boolean started=false;
	private InetAddress ip;
	private int port;

	Network(Control c){
		ctrl=c;
	}

	private class UDPThread implements Runnable{ 
		public void run(){
			int[] data1 = new int[128];
			int[] data2 = new int[128];
			try{
				while(true){
					recvBuffer = new byte[1024];
					DatagramPacket recvPacket = new DatagramPacket(recvBuffer,recvBuffer.length);
					socket.receive(recvPacket);
					//System.out.println("Received "+recvPacket.getLength()+" byte(s) of data.");
					for(int i=0;i<128;i++){
						data1[i]=((recvBuffer[(i<<3)+3]&0xFF)<<24)|((recvBuffer[(i<<3)+2]&0xFF)<<16)|((recvBuffer[(i<<3)+1]&0xFF)<<8)|(recvBuffer[(i<<3)+0]&0xFF);
						data2[i]=((recvBuffer[(i<<3)+7]&0xFF)<<24)|((recvBuffer[(i<<3)+6]&0xFF)<<16)|((recvBuffer[(i<<3)+5]&0xFF)<<8)|(recvBuffer[(i<<3)+4]&0xFF);
					}
					ctrl.addData(data1,data2);
				}
			}
			catch(IOException e){
				if(started){ //ha started==false, akkor azert vagyunk itt, mert a receive() visszatert a close() hivasa miatt
					System.out.println(e);
					System.exit(0);
				}
			}
			
		}
	}

	public void start(int port, String ip){
		if(started){
			System.out.println("Already started.");
			return;
		}
		started=true;
		try{
			socket=new DatagramSocket();
			this.ip=InetAddress.getByName(ip);
			this.port=port;
			Thread thr = new Thread(new UDPThread());
			thr.start();
			byte b[]={0};
			DatagramPacket outPacket = new DatagramPacket(b,1,this.ip,this.port);
			socket.send(outPacket);
		}
		catch(IOException e){
			System.out.println(e);
			System.exit(0);
		}

		System.out.println("Started at port " + socket.getLocalPort() + ".");
	}

	public void stop(){
		if(!started){
			System.out.println("Not started.");
			return;
		}
		started=false;
		try{
			byte b[]={1};
			DatagramPacket outPacket = new DatagramPacket(b,1,ip,port);
			socket.send(outPacket);
		}
		catch(IOException e){
			System.out.println(e);
			System.exit(0);
		}
		socket.close();
		socket=null;
		System.out.println("Stopped.");
	}

}
