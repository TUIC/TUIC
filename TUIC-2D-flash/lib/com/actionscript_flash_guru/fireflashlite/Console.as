package com.actionscript_flash_guru.fireflashlite {
/*
  -start contract
  Copyright (c) 2010, Nicholas Dunbar 
  All rights reserved.
  
  original source code can be found at:
  www.actionscript-flash-guru.com

  This is a legaly binding contract. 
  By using this code you are agreeing to the following conditions in 
  sections 1-4 below and acknowledging the disclaimer.
  Redistribution and use in source and binary forms, with or without 
  modification, are permitted provided that the following conditions are
  met:

	1.) Redistributions of source code must retain the above copyright notice, 
    this list of conditions and the following disclaimer.
  
	2.) Because this code relies on Adobe's core lib,
	Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the 
    documentation and/or other materials provided with the distribution.
  
	3.) This code relies on Adobe's core lib. (See json package.)
	Neither the name of Adobe Systems Incorporated nor the names of its 
    contributors may be used to endorse or promote products derived from 
    this software without specific prior written permission.

	4.) Redistributions in binary form as an embeded flash movie in a webpage 
	are permitted without this notice, but condition 3 still remains in effect.
	
  If any part of this contract is found to be invalid the remaining 
  parts of the contract will remain in full effect.

  Disclaimer:
  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
  IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR 
  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  
  -end contract
  
  Note: Yes you can use this code to make commercial products.
*/
	//fireflash libs
	import com.actionscript_flash_guru.fireflash.Consts;
	import com.actionscript_flash_guru.fireflash.jsProxy.CustomString;
	import com.actionscript_flash_guru.fireflash.jsProxy.ObjectParser;
	import com.actionscript_flash_guru.fireflash.jsProxy.CodeTypes;
	import com.actionscript_flash_guru.fireflash.jsProxy.MessageType;
	import com.actionscript_flash_guru.fireflash.jsProxy.JSONWrapper;
	import com.actionscript_flash_guru.fireflash.jsProxy.ArrayWrapper;
	import com.actionscript_flash_guru.fireflash.jsProxy.json.*;
	
	//native libraries
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.utils.getTimer;
	import flash.external.ExternalInterface;
	
	/**
	* a logger API - class used to talk to the FireFlash Mozilla Addon which extends the Mozilla Firebug Addon
	* example of a trace "1-[log] returned correct results", the trace message is prefixed by a trace type
	*/
	
	public class Console {
		//every release we update this number to know with what version of FireFlash this Console object was released.
		public static const ADDON_VERSION:String = "1.1.1";
		//this makes sure that this Console is in the same compatible group as the add-on
		public static const COMPATIBLE_GROUP:Number = 1.1;
		//time from browser clock to make sure all logs are synchronized
		private var _startTime:Date;
		//show that traces should be send out to the IDE output panel.
		private static var _isIdeTraceEnabled = true;
		//keeps track of fps
		//private static var _fpsMeter:Fps;
		//time keeper for the time and timeEnd functions
		private static var _timeKeeper:Object = {};
		//if we are running it from an external or standalone player this is true
		private static var _isIde:Boolean = (Capabilities.playerType == "External" || Capabilities.playerType == "StandAlone");
		//number of groups we are in
		private static var _numGroups:uint;
		//number of traces that have gone into the system
		private static var _traceId:uint;
		//if the plugin is not compatible with this class an alert will be sent out but we don't want the alert firing every time so once the alert has been shown this is set to true so it wont be displayed again.
		private static var _isUserAlertedToVersionProblem:Boolean;
		
		/**
		* The easiest way to write to the console looks like this: console.log("hello world") 
		* You can pass as many arguments as you want and they will be joined together in a row, like console.log(2,4,6,8,"foo",bar).
		* You can pass an object in and the first level of the object will get shown
		* console.log can format strings in the great tradition of printf. For example, you can write console.log("%s is %d years old.", "Bob", 42).
		* @args ... any number of arguments can be passed in to the function
		*/
		public static function log(... args):void {
			if (Consts.COMPILED_AS_ENABLED){
				_traceId++;
				_logTraceInternal("log", args);
			}
		}
		/**
		* see log function. This behaves just like the log function but it changes the trace type to Level.DEBUG
		* @args ...
		*/
		public static function debug(... args):void{
			if (Consts.COMPILED_AS_ENABLED){
				_traceId++;
				_logTraceInternal("debug", args);
			}
		}
		/**
		*  see log function. This behaves just like the log function but it changes the trace type to Level.FINE
		* @args ...
		*/
		public static function info(... args):void{
			if (Consts.COMPILED_AS_ENABLED){
				_traceId++;
				_logTraceInternal("info", args);
			}
		}
		/**
		*  see log function. This behaves just like the log function but it changes the trace type to Type.WARN
		* @args ...
		*/
		public static function warn(... args):void{
			if (Consts.COMPILED_AS_ENABLED){
				_traceId++;
				_logTraceInternal("warn", args);
			}
		}
		/**
		*  see log function. This behaves just like the log function but it changes the trace type to Level.FINE
		* @args ...
		*/
		public static function error(... args):void{
			if (Consts.COMPILED_AS_ENABLED){
				_traceId++;
				_logTraceInternal("error", args);
			}
		}
		/**
		* Prints an interactive stack trace at the execution point where it is called.
		* The stack trace details the functions on the stack, (as well as the values that were passed) <--not sure if this is possible 
		*/
		public static function stackTrace():void{
			if (Consts.COMPILED_AS_ENABLED){
				var stackTrace:String;
				
				try {
					throw new Error(""); 
				} catch (e:Error){
					stackTrace = e.getStackTrace();
				}
				
				if (!_isIde){
					try{
						ExternalInterface.call("fireFlashFrame.stackTrace", ExternalInterface.objectID, stackTrace, "", 0, "Log", 1, 0, 0, CodeTypes.AS3);
					} catch(e:Error){
						//go no where
					}
				} else if (_isIdeTraceEnabled){
					_traceId++;
					stackTrace = _cleanStackTrace(stackTrace);
					
					trace(_addGroupPadding(_traceId+"-[stackTrace] "+stackTrace));
				}
			}
		}
		/**
		* Like group(), but the block is initially collapsed.
		* @args ... You can enter whatever you like the same as in log() and it will get listed at the top of the group
		*/
		public static function groupCollapsed(...  args):void{
			if (Consts.COMPILED_AS_ENABLED){
				if (!_isIde){
					try{
						ExternalInterface.call("fireFlashFrame.groupCollapsed", ExternalInterface.objectID, ObjectParser.serializeArgs(args,1), "", 0, "Log", 1, 0, 0, CodeTypes.AS3);
					} catch(e:Error){
						//do nothing
					}
				} else if (_isIdeTraceEnabled){
					_logTraceInternal("group", args);
					_numGroups++;
					
				}
			}
		}
		/**
		* Writes a message to the console and opens a nested block to indent all future messages sent to the console. 
		* @args ... You can enter whatever you like the same as in log() and it will be listed at the top of the group
		*/
		
		public static function group(... args):void{
			if (Consts.COMPILED_AS_ENABLED){
				if (!_isIde){
					try{
						ExternalInterface.call("fireFlashFrame.group", ExternalInterface.objectID, ObjectParser.serializeArgs(args,1), "", 0, "Log", 1, 0, 0, CodeTypes.AS3);
					} catch(e:Error){
						//do nothing
					}
				} else if (_isIdeTraceEnabled){
					_logTraceInternal("group", args);
					_numGroups++;
				}
			}
		}
		/**
		* Closes the most recently opened block created by a call to group() or groupCollapsed
		*/
		public static function groupEnd():void{
			if (Consts.COMPILED_AS_ENABLED){
				if (!_isIde){
					try{
						ExternalInterface.call("fireFlashFrame.groupEnd", ExternalInterface.objectID, "", 0, "Log", 1, 0, 0, CodeTypes.AS3);
					} catch(e:Error){
						//do nothing
					}
				} else if (_isIdeTraceEnabled) {
					if (_numGroups > 0){
						_numGroups--;
					}
				}
			}
		}
		
		/**
		* Prints an interactive listing of all properties of the object.
		* @objectToParse object of which to create a tree listing 
		* @numOfLevelsToRecurseInTree default is ten levels but that can be changed to more or less. This is here to prevent cycilic structures should the author of the object have insterted self references.
		* @args any number of arguments that you may want to print out
		*/
		public static function dir(objectToParse:Object, numOfLevelsToRecurseInTree:uint = 3, ... args):void{
			if (Consts.COMPILED_AS_ENABLED){
				var stackTrace:String = "";
				var currentMemoryUsage:int;
				var currentFps:int;
				var todaysDate:Date;
				
				//var dummy:String = ObjectParser.serializeArgs(args,1);
				todaysDate = new Date();
				
				if (!_isIde){
					try{
						ExternalInterface.call("fireFlashFrame.logTrace", 
												ExternalInterface.objectID, 
												todaysDate.toLocaleString(), 
												todaysDate.milliseconds, 
												"Log", 
												ObjectParser.serializeArgs(args,1), 
												1, 
												"", 
												currentMemoryUsage, 
												currentFps, 
												MessageType.OBJECT_DIR, 
												ObjectParser.serializeObject(objectToParse, numOfLevelsToRecurseInTree), 
												CodeTypes.AS3);
					} catch(e:Error){
						//do nothing
					}
				} else if (_isIdeTraceEnabled){
					_traceId++;
					_logTraceInternal("log", args);
					//TODO: add pretty printing
					trace(_addGroupPadding(_traceId+"-[Object Dir] \n"+ObjectParser.objectToJsonString(objectToParse, numOfLevelsToRecurseInTree)));
				}
			}
		}
		/**
		* Prints an interactive listing of all properties of the XML object.
		* @args ... (xml:XML, [object,...]) or or (xml:XML)
		*/
		public static function dirxml(...  args):void{
			if (Consts.COMPILED_AS_ENABLED){
				var xml:XML;
				var xmlString:String;
				var stackTrace:String;
				var currentMemoryUsage:int;
				var currentFps:int;
				var message:String = "XML:";
				var todaysDate:Date = new Date();
				var jsonArgsObj:Object = null;
				var argsString:String = "";
				
				if (args.length > 0){
					if (typeof(args[0]) == "xml"){
						xml = args.shift();
					} else if (typeof(args[0]) == "string"){
						xmlString = args.shift();
						try {
							xml = new XML(xmlString);
						} catch (e:Error){
							//then this string is not xml
							//TODO: handle error
							Console.error("Not valid XML: "+xmlString);
							return;
						}
					} else {
						//then this first param is not xml
						//TODO: handle error
						Console.error("First argument for dirxml should be an xml object or a valid xml string instead of "+args[0]);
						return;
					}
					
					if (!_isIde){
						
						if (args.length > 0){
							argsString = ObjectParser.serializeArgs(args,1);
						}
						try{
							ExternalInterface.call("fireFlashFrame.logTrace", 
													ExternalInterface.objectID, 
													todaysDate.toLocaleString(), 
													todaysDate.milliseconds, 
													"Log", 
													argsString, 
													1, 
													stackTrace, 
													currentMemoryUsage, 
													currentFps, 
													MessageType.XML_DIR, 
													ObjectParser.serializeXml(xml), 
													CodeTypes.AS3);
						} catch(e:Error){
							//do nothing
						}
					} else if (_isIdeTraceEnabled) {
						_traceId++;
						_logTraceInternal("XML", args);
						if (xmlString == null || xmlString == ""){
							xmlString = xml.toString();
						}
					 	trace(_addGroupPadding(xmlString));
					}
				}
			}
		}
		/**
		* assert(expression[, object, ...])
		* Tests that an expression is true. If not, it will write a message to the console and throw an exception.
		*/
		public static function assert(expression:Boolean, ... args):void{
			if (Consts.COMPILED_AS_ENABLED){
				var stackTrace:String = "";
				
				if (!_isIde){
					try {
						throw new Error(""); 
					} catch (e:Error){
						stackTrace = e.getStackTrace();
					} finally {
						try {
							ExternalInterface.call("fireFlashFrame.assert", expression, stackTrace, ExternalInterface.objectID, ObjectParser.serializeArgs(args,1), "", 0, "Error", 1, 0, 0, CodeTypes.AS3);
						} catch (e:Error){
							//do nothing
						}
					}
				} else if (_isIdeTraceEnabled && !expression) {
					_traceId++;
					_logTraceInternal("assert", args);
				}
			}
		}
		/**
		* Creates a new timer under the given name. Call timeEnd(name) with the same id to stop the timer and print the time elapsed.
		* @id the name of the timer that you will use later with timeEnd to stop the timer and get the result
		*/
		public static function time(id:String):void{
			if (Consts.COMPILED_AS_ENABLED){
				var currentTime:int = getTimer();
				_timeKeeper[id] = currentTime;
			}
		}
		
		/**
		* Stops a timer created by a call to time(name) and outputs the time elapsed to the console.
		* @id the name of the timer that you started with the time function
		*/
		public static function timeEnd(id:String):void{
			if (Consts.COMPILED_AS_ENABLED){
				var currentTime:int = getTimer();
				var totalTimePassed:int;
				if (_timeKeeper.hasOwnProperty(id)){
					totalTimePassed = currentTime-_timeKeeper[id]; 
				} else {
					return;
				}
				
				if (!_isIde){
					try{
						ExternalInterface.call("fireFlashFrame.timeEnd", totalTimePassed+"ms", id, ExternalInterface.objectID, 1, 0, "", 0, MessageType.TIME, CodeTypes.AS3);
					} catch(e:Error){
						//do nothing
					} finally {
						try{
							delete _timeKeeper[id];
						} catch(e:Error){
							//do nada
						}
					}
				} else if (_isIdeTraceEnabled) {
					_traceId++;
					trace(_addGroupPadding("")+_traceId+"-[time]"+id+" : "+totalTimePassed+"ms");
				}
			}
		}
		
		/**
		* disables tracing all console traces in the IDE output window
		* normally the trace is only viewable by using the omni logger UI but if IDE traces are enabled then it shows up in the IDE output as well
		*/
		public static function disableIdeTrace():void{
			if (Consts.COMPILED_AS_ENABLED){
				_isIdeTraceEnabled = false;
			}
		}
		
		/////////////////////////////////////////private/////////////////////////////////
		private static function _logTraceInternal(methodName:String, args:Array):void{
			if (Consts.COMPILED_AS_ENABLED){
				var stackTrace:String = "";
				var currentMemoryUsage:int;
				var currentFps:uint;
				var argsStr:String = "";
				var todaysDate:Date;
				var printfStr:String;
				var pattern:RegExp;
				_checkVersionNumber();
				if (methodName == "error"){
					try {
						throw new Error(""); 
					} catch (e:Error){
						stackTrace = e.getStackTrace();
					}
				}
				//TODO: take advantage of the whole feature set of CustomString.printf
				if (_isIde &&  typeof(args[0]) == "string"){
					pattern = /[^\\]%[s,d,i,f,o]/msg;
					printfStr = String(args[0]).replace(pattern,"");
					if (printfStr != args[0]){
						argsStr = CustomString.printf.apply(Console, args);
					}
				}
				if (argsStr == ""){
					argsStr = ObjectParser.argsToIdeOutput(args);
				}
				todaysDate = new Date();
				if (!_isIde){
					try{
						ExternalInterface.call("fireFlashFrame.logTrace", 
												ExternalInterface.objectID, 
												todaysDate.toLocaleString(), 
												todaysDate.milliseconds, 
												methodName, 
												ObjectParser.serializeArgs(args,1), 
												1, 
												stackTrace, 
												currentMemoryUsage, 
												currentFps, 
												MessageType.MESSAGE, 
												"", 
												CodeTypes.AS3);
						
					} catch(e:Error){
						//do nothing
					}
				} else if (_isIdeTraceEnabled){
					
					stackTrace = _cleanStackTrace(stackTrace);
					
					if (methodName == "assert"){
						trace(_addGroupPadding(_traceId+"-[Assertion Failure] "+argsStr));
						trace(_addGroupPadding(_addGroupPadding(stackTrace)));
					} else if (methodName == "error"){
						trace(_addGroupPadding(_traceId+"-["+methodName+"] "+argsStr));
						trace(_addGroupPadding(_addGroupPadding(stackTrace)));
					} else if (methodName == "group"){
						trace(_addGroupPadding("["+methodName+"] "+argsStr));
					} else {
						trace(_addGroupPadding(_traceId+"-["+methodName+"] "+argsStr));
					}
				}
			}
		}
		private static function _cleanStackTrace(stackTrace:String):String{
			var removeTop:RegExp;
			removeTop = /^.*actionscript_flash_guru\.(fireflash|fireflashlite)::Console.*?\(\).*?at\s/msi;
			//TODO: add group indentions at each newline
			return stackTrace.replace(removeTop,"");
		}
		private static function _addGroupPadding(str:String):String{
			//TODO: make this more efficient
			var spacesList:Array = new Array();
			spacesList[_numGroups] = "";
			var padding:String = spacesList.join(" ");
			
			/*var padding:String = "";
			for (var k:uint = 0; k < _numGroups; k++){
				padding += "  ";
			}*/
			str = str.replace(/[\n\r\f]/msg, "\n"+padding);
			
			return padding+str;
		}
		private static function _checkVersionNumber():void{
			var fireFlashFrameVersion:Number;
			var stringResult:String;
			if (!_isIde && !_isUserAlertedToVersionProblem){
					try{
						stringResult = ExternalInterface.call("fireFlashFrame.getVersion")+""; 
						if (stringResult != "NaN" && stringResult != "undefined" && stringResult != "null" && stringResult != null){
							fireFlashFrameVersion = parseFloat(stringResult);
							if (fireFlashFrameVersion+"" != "NaN"){
									if (fireFlashFrameVersion != COMPATIBLE_GROUP){
										//only let them know if there is a compatability issue, new releases of the add-on does not necessarily mean that you have to update the AS3 Library.
										ExternalInterface.call("alert","Incompatibility! The Console ActionScript Library in "+ExternalInterface.objectID+".swf was released with FireFlash version "+ADDON_VERSION+" you are using FireFlash version "+ExternalInterface.call("fireFlashFrame.getAddonVersion")+" Please update at http://www.tinyurl.com/fireflash It is recommended that you follow FireFlash on Twitter to be notified of updates in the future at http://www.twitter.com/fireflashupdate");
									}
									_isUserAlertedToVersionProblem = true;
							}
							
						}
					} catch(e:Error){
						//do nothing
						// no external interface exists so the plug ing must not exist so we don't display this information.
					}
				}
		}
	}
}