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

import processing.core.*;

import csnd6.*;
import java.io.*;
import java.util.*; 


public class CallbackWrapper extends CsoundCallbackWrapper{
    public Csound csound;
    public MessageQueue messageQueue;
    public Csoundo csoundoObject;

    
    public CallbackWrapper(Csound csnd){
        super(csnd);
        //System.out.print(this.getClass().getSuperclass().getName()+"\n");
        csound = csnd;
        messageQueue = new MessageQueue();
    }
    
    
    public void OutputValueCallback(String _chan, double _val) {
        csoundoObject.outValueCallbackFunction(_chan, _val);            
        messageQueue.addMessageToValueQueue(_chan, _val);
    }
    

    
    public void setCsoundoObj(Csoundo obj){
        csoundoObject = obj;
    }    
    
    public void SetMessageCallback() {
        //System.out.print("messagecallback");
    }
    
    public int YieldCallback()
    {
    //update Csound channels
    for(int i=0;i<messageQueue.getNumberOfMessagesInQueue("channel");i++)
    csound.SetChannel(messageQueue.getMessageFromChannelQueue(i).channelName, 
                      messageQueue.getMessageFromChannelQueue(i).channelData);

    //update Csound table values
    for(int i=0;i<messageQueue.getNumberOfMessagesInQueue("table");i++)
    csound.TableSet(messageQueue.getMessageFromTableQueue(i).tableNumber, 
                    messageQueue.getMessageFromTableQueue(i).xVal,
                    messageQueue.getMessageFromTableQueue(i).yVal);
    
    //flush messages from queues
    messageQueue.flushMessagesFromQueue("channel");
    messageQueue.flushMessagesFromQueue("table");
    return 1;
    }

    
    
    
}
