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


import csnd.*;


public class CallbackWrapper extends CsoundCallbackWrapper{
    public Csound csound;
    public MessageQueue messageQueue;

    
    public CallbackWrapper(Csound csnd){
        super(csnd);
        //System.out.print(this.getClass().getSuperclass().getName()+"\n");
        csound = csnd;
        messageQueue = new MessageQueue();
    }
   
    
    @Override
    public int YieldCallback()
    {
    //update Csound channels
    for(int i=0;i<messageQueue.getNumberOfMessagesInChannelQueue();i++) {
            csound.SetChannel(messageQueue.getMessageFromChannelQueue(i).channelName, 
                              messageQueue.getMessageFromChannelQueue(i).channelData);
        }

    //update Csound table values
    for(int i=0;i<messageQueue.getNumberOfMessagesInTableQueue();i++) {
            csound.TableSet(messageQueue.getMessageFromTableQueue(i).tableNumber, 
                            messageQueue.getMessageFromTableQueue(i).xVal,
                            messageQueue.getMessageFromTableQueue(i).yVal);
        }

    //csound.TableGet(1, 1);
    
    //flush messages from queues
    messageQueue.flushMessagesFromTableQueue();
    messageQueue.flushMessagesFromChannelQueue();
    return 1;
    }

    
    
    
}
