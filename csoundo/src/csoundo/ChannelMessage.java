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
 * @author	Jacob Joaquin, Rory Walsh, Conor Dempsey
 * @modified	10/01/2012
 * @version	0.2.1
 */

package csoundo;

import csnd.*;
import java.io.*;
import java.util.*; 

/**
 * Simple class to hold channel name and value.
 */

public class ChannelMessage {
	public String channelName;
	public double channelData;
	
	public ChannelMessage(String _chan, double _val){
		channelData = _val;
		channelName = _chan;
	}
}
