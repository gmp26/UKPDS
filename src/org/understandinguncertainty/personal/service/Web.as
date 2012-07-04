/*
Copyright University of Cambridge. All rights reserved
*/
package org.understandinguncertainty.personal.service
{
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.controls.Alert;
	
	public class Web
	{
		public static function getURL(url:String, window:String = null):void
		{
			var req:URLRequest = new URLRequest(url);
			try
			{
				navigateToURL(req, window);
			}
			catch (e:Error)
			{
				Alert.show(e.message, "Failed to connect", Alert.OK);
			}
		}
	}
}