package CSCI_201;

import java.io.IOException;
import java.net.Socket;
import java.util.HashMap;
import java.util.Map;
import java.util.Vector;

import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

@ServerEndpoint(value = "/ws")
public class ServerSocket {

	private static Vector<Session> sessionVector = new Vector<Session>();
	private static HashMap<String, Session> userIDMap = new HashMap<String, Session>();
	private static Vector<ServerThread> serverThreads = new Vector<ServerThread>();
	
	@OnOpen
	public void open(Session session) {
		System.out.println("Connection made!");
		sessionVector.add(session);
		
		
		
	}
	
	@OnMessage
	public void onMessage(String message, Session session) {
		System.out.println(message);
			String [] parts = message.split(",");
			
			if (parts.length == 1)
			{
				
				userIDMap.put(parts[0], session);
				return;
			}
			try {

				for (int i=0; i<parts.length-1; i++)
				{
					
					if (userIDMap.containsKey(parts[i])) {
						
						if (userIDMap.get(parts[i]) != session) {
							userIDMap.get(parts[i]).getBasicRemote().sendText(parts[parts.length-1]);
						}
					}

				}


			} catch (IOException ioe) {
			System.out.println("ioe: " + ioe.getMessage());
			close(session);
		}
	}
	
	@OnClose
	public void close(Session session) {
		
		sessionVector.remove(session);
	}
	
	@OnError
	public void error(Throwable error) {
		System.out.println("Error!");
	}

	public void broadcast(ChatMessage cm, ServerThread serverThread) {
		
		
	}
}
