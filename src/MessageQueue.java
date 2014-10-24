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
 * @author	Rory Walsh
 * @modified	10/01/2012
 * @version	0.2.1
 */

package csoundo;

import csnd6.*;
import java.io.*;
import java.util.*; 

/**
 * This class is for saving messages to a queue
 * so they can be sent to and from Csound in a thread safe mannor
 */
public class MessageQueue {
	private String csd;
        int numberOfTablesToRetreive;
	private Vector<ChannelMessage> channelMessageQueue;
        private Vector<TableMessage> tableMessageQueue;
        private Vector<ChannelMessage> valueMessageQueue;
	
	
	public MessageQueue(){
            channelMessageQueue = new Vector<ChannelMessage>();
            valueMessageQueue = new Vector<ChannelMessage>();
            tableMessageQueue = new Vector<TableMessage>();
	} 
	
	public void addMessageToChannelQueue(String _chan, double _val){
		channelMessageQueue.addElement(new ChannelMessage(_chan, _val));
	}
	
	public void addMessageToTableQueue(int _tableNumber, int _index, double _amp){
		tableMessageQueue.addElement(new TableMessage(_tableNumber, _index, _amp));
	}

	public void addMessageToValueQueue(String _chan, double _val){
		valueMessageQueue.addElement(new ChannelMessage(_chan, _val));
	}   
        
        public void fillArrayWithTablePoints(int table, float[] array){
            
        }
        
        
	public ChannelMessage getMessageFromChannelQueue(int index){
		return channelMessageQueue.get(index);
	}

	public TableMessage getMessageFromTableQueue(int index){
		return tableMessageQueue.get(index);
	}        
         
	public ChannelMessage getMessageFromValueQueue(int index){
		return valueMessageQueue.get(index);
	}
        
	public int getNumberOfMessagesInQueue(String queue){
            if(queue=="channel")
		return channelMessageQueue.size();
            else if(queue=="table")
		return tableMessageQueue.size();
            else if(queue=="value")
		return valueMessageQueue.size();
            else return 0;
	}
      
	public void flushMessagesFromQueue(String queue){
            if(queue=="channel")
		channelMessageQueue.removeAllElements();
            else if(queue=="table")
		tableMessageQueue.removeAllElements();
            else if(queue=="value")
		valueMessageQueue.removeAllElements();
	}      
      
}

