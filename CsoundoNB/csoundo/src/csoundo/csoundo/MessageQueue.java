/**
 * A Csound interface library for Processing.
 *
 * (c) 2010
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General
 * Public License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA  02111-1307  USA
 * 
 * @author	Jacob Joaquin, Rory Walsh, Conor Robotham
 * @modified	10/01/2012
 * @version	0.2.1
 */


package csoundo;

import java.util.*; 

/**
 * This class is for saving messages to a queue
 * so they can be sent to and from Csound in a thread safe manner
 */
public class MessageQueue {
        int numberOfTablesToRetreive;
	private Vector<ChannelMessage> channelMessageQueue;
        private Vector<TableMessage> tableMessageQueue;
	
	
	public MessageQueue(){
            channelMessageQueue = new Vector<ChannelMessage>();
            tableMessageQueue = new Vector<TableMessage>();
	} 
	
	public void addMessageToChannelQueue(String _chan, double _val){
		channelMessageQueue.addElement(new ChannelMessage(_chan, _val));
	}
	
	public void addMessageToTableQueue(int _tableNumber, int _index, double _amp){
		tableMessageQueue.addElement(new TableMessage(_tableNumber, _index, _amp));
	}
	
        public void fillArrayWithTablePoints(int table, float[] array){
            
        }
        
	public ChannelMessage getMessageFromChannelQueue(int index){
		return channelMessageQueue.get(index);
	}

	public TableMessage getMessageFromTableQueue(int index){
		return tableMessageQueue.get(index);
	}        
        
	public int getNumberOfMessagesInChannelQueue(){
		return channelMessageQueue.size();
	}

	public int getNumberOfMessagesInTableQueue(){
		return tableMessageQueue.size();
	}        
        
	public void flushMessagesFromChannelQueue(){
		channelMessageQueue.removeAllElements();
	}
        
	public void flushMessagesFromTableQueue(){
		tableMessageQueue.removeAllElements();
	}        
}

