package com.actionscript_flash_guru.fireflash.jsProxy{
	/*
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
  
	2.) Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the 
    documentation and/or other materials provided with the distribution.
  
	3.) This code relies on adobe's core lib. (See json package.)
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
*/
	//native liba
	import flash.utils.getQualifiedClassName;
	import flash.utils.describeType;
	//import flash.utils.ByteArray;
	//import flash.utils
	
	//my libs
	import com.actionscript_flash_guru.fireflash.Consts;
	import com.actionscript_flash_guru.fireflash.jsProxy.json.JSON;
	
	public class ObjectParser {
		public static function serializeArgs(args:Array, levels:uint):String {
			var len:uint = args.length;
			var typeStr:String;
			var newArray:Object = {};
			
			for (var i:uint = 0; i < len; i++){
				if (args[i] is Array){
					newArray[i+""] = { array: _recursiveArrayCopy(args[i], levels+1, 0, false) };
				} else if (typeof(args[i]) == "object"){
					if (args[i] != null){
						//typeStr = typeof(args[i]);
						//if (typeStr == "object"){
							typeStr = getQualifiedClassName(args[i]);
						//}
						newArray[i+""] = { object:{} };
						newArray[i+""].object["("+_escapeToVarChars(typeStr)+")"] = _recurseObjectTreeFormatToObj(levels, args[i]);
					} else {
						newArray[i+""] = "null";
					}
				} else if (typeof(args[i]) == "xml"){
					newArray[i+""] = (args[i].toString());
				} else if (typeof(args[i]) == "function"){
					newArray[i+""] = "[Function]";
				} else {
					newArray[i+""] = args[i];
				}
			}
			var dummyObj:* = newArray;
			return encodeUtf( JSON.encode(newArray) );
		}
		public static function serializeObject(obj:Object, levels:uint):String {
			return encodeUtf(  JSON.encode( objCopyToSimpleObj(obj, levels) )  );
		}
		public static function serializeXml(xml:XML):String{
			//xml.ignoreWhitespace = true;
			return xml.toXMLString();
		}
		public static function deserializeObjToStr(data:String):String{
			var utfList:Array = data.split(",");
			var theString:String = String.fromCharCode.apply(ObjectParser, utfList); 
			//var encodeObjStr:String = "";
			
			return theString;
		}
		public static function deserializeArgs(data:String):Array{
			if (data == null || data.length == 0){
				return null;
			}
			var utfList:Array = data.split(",");
			var theString:String = String.fromCharCode.apply(ObjectParser, utfList);
			var argsObj:Object = {};
			var decodedObj:Object = {};
			var args:Array = [];
			var obj:Object = {};
			var type:String = "";
			var key:String = "";
			if (theString == "null"){
				return null;
			}
			try {
				decodedObj = JSON.decode(theString);
			} catch (e){
				return ["Cannot decode json data."];
			}
			//for (key in decodedObj){
				//args.push(null);
			//}
			for (key in decodedObj){
				obj = decodedObj[key]; 
				type = typeof(decodedObj[key]);
				if (type == "object"){
					if ( obj.hasOwnProperty("object") ){
						args[parseInt(key)] = obj.object;
					} else if ( obj.hasOwnProperty("array")){
						args[parseInt(key)] = (obj.array);
					}
				} else if (type == "string"){
					if (obj == "null"){
						args[parseInt(key)] = null;
					} else {
						args[parseInt(key)] = obj;
					}
				} else {
					//a number
					args[parseInt(key)] = obj;
				}
			} 
			return args;
		}
		public static function argsToIdeOutput(args:Array):String{
			var numArgs:uint;
			var argsStr:String = "";
			var newArray:Array = [];
			var len:uint;
			var j:uint;
			var type:String;
			var array:Array;
			var pattern:RegExp = /[^\\]%[s,d,i,f,o]/msg;
			
			if (args == null){
				return "null";
			}
			
			if (args[0] != null 
					&& typeof( args[0] ) == "string" 
					&& args[0].search( pattern ) != -1)
			{
				return CustomString.printf.apply(CustomString, args);
			}
			if (args.length == 0){
				return "[]";
			}
			 
			numArgs = args.length;
					for (var i:uint; i < numArgs; i++){
						if (typeof (args[i]) == "object"){
							if (args[i] == null){
								argsStr += "null";
							} else if (args[i] is Array){
								array = args[i];
								newArray = [];
								len = array.length;
								argsStr += "[";
								//remove any references to the outside array by copying over arrays and objects to a new array as a string
								
								for (j = 0; j<len; j++){
									type = typeof(array[j]);
									if (type == "string"){
										argsStr += "\""+array[j]+"\"";
									} else if (type == "object") {
										//this cannot be parsed into sub arrays if we do this it will be too processor intentse.
										if (array[j] is Array){
											argsStr += "[Array]";
										} else if (array[j] == null){
											argsStr += "null";
										} else {
											//in the IDE we don't want to parse it out any deeper than a level deep
											argsStr += array[j].toString();
										}
									} else if (type == "function"){
										argsStr += "[Function]";
									} else if (type == "xml"){
										argsStr += array[j].toString();
									} else {
										//boolean or number, has no reference so it can be left as its native type
										argsStr += array[j];
									}
									if (j+1<len){
										argsStr += ",";
									}
								}
								argsStr += "]";
							} else {
								argsStr += ObjectParser.objectToJsonString(args[i],1);
							}
						} else if (typeof (args[i]) == "function"){
							argsStr += "[Function]";
						} else if (typeof (args[i]) == "xml"){
							argsStr += args[i].toString();
						} else {
							argsStr += args[i];
						}
						if (i+1<numArgs){
							argsStr += ","+"\n";
						}
					}
					return argsStr;
		}
		public static function arrayToIdeOutput(args:Array):String{
			var numArgs:uint;
			var argsStr:String = "";
			var newArray:Array = [];
			var len:uint;
			var j:uint;
			var type:String;
			var array:Array;
			var pattern:RegExp = /[^\\]%[s,d,i,f,o]/msg;
			
			if (args == null){
				return "null";
			}
			
			if (args[0] != null 
					&& typeof( args[0] ) == "string" 
					&& args[0].search( pattern ) != -1)
			{
				return CustomString.printf.apply(CustomString, args);
			}
			if (args.length == 0){
				return "[]";
			}
			 
			numArgs = args.length;
					for (var i:uint; i < numArgs; i++){
						if (typeof (args[i]) == "object"){
							if (args[i] == null){
								argsStr += "null";
							} else if (args[i] is Array){
								array = args[i];
								newArray = [];
								len = array.length;
								argsStr += "[";
								//remove any references to the outside array by copying over arrays and objects to a new array as a string
								
								for (j = 0; j<len; j++){
									type = typeof(array[j]);
									if (type == "string"){
										argsStr += "\""+array[j]+"\"";
									} else if (type == "object") {
										//this cannot be parsed into sub arrays if we do this it will be too processor intentse.
										if (array[j] is Array){
											argsStr += "[Array]";
										} else if (array[j] == null){
											argsStr += "null";
										} else {
											//TODO: parse object into array, this would also require you to update the parser on the javascript side.
											argsStr += array[j].toString();
										}
									} else if (type == "function"){
										argsStr += "[Function]";
									} else if (type == "xml"){
										argsStr += array[j].toString();
									} else {
										//boolean or number, has no reference so it can be left as its native type
										argsStr += array[j];
									}
									if (j+1<len){
										argsStr += ",";
									}
								}
								argsStr += "]";
							} else {
								//argsStr += ObjectParser.objectToJsonString(args[i],1);
								//in the IDE we don't want to parse it out any deeper than a level deep
								argsStr += args[i].toString();
							}
						} else if (typeof (args[i]) == "function"){
							argsStr += "[Function]";
						} else if (typeof (args[i]) == "xml"){
							argsStr += args[i].toString();
						} else if (typeof (args[i]) == "string"){
							argsStr += "\""+_escapeString(args[i])+"\"";
						} else {
							argsStr += args[i];
						}
						if (i+1<numArgs){
							argsStr += ","+"\n";
						}
					}
					return argsStr;
		}
		public static function objectToJsonString(obj:Object, levels:uint):String {
			if (obj == null){
				return "";
			}
			var objectAsString:String = "";
			var className:String = getQualifiedClassName(obj);
			var objType:String = typeof(obj);
			var typeStr:String;
			 
			if (objType == "object"){
				typeStr = className;
			} else {
				typeStr = objType;
			}
			objectAsString += "{\"("+_escapeToVarChars(typeStr)+")\" : \n {\n";
			objectAsString += _recurseObjectTreeFormat(levels, obj);
			objectAsString += "\n }\n}";
			return objectAsString;
		}
		
		public static function objCopyToSimpleObj(obj:Object, levels:uint, isTyped:Boolean = true):Object {
			if (obj == null){
				return null;
			}
			var outputObject:Object = {};
			var className:String = getQualifiedClassName(obj);
			var objType:String = typeof(obj);
			var typeStr:String;
			 
			if (objType == "object"){
				typeStr = className;
			} else {
				typeStr = objType;
			}
			outputObject["("+_escapeToVarChars(typeStr)+")"] = _recurseObjectTreeFormatToObj(levels, obj, 0, isTyped);
			
			return outputObject;
		}
		private static function _recurseObjectTreeFormatToObj(levelsLimit:uint, obj:Object, levelsIn:uint = 0, isTyped:Boolean = true):*{
			if (obj == null){
				return null;
			}
			if (levelsLimit <= levelsIn){
				if (levelsLimit == 0){
					return obj.toString(); 
				} else {
					return "Max Depth of "+levelsLimit+" reached ("+obj.toString()+")";
				}
			}
			
			levelsIn++;
			var objectOutput:Object = {};
			var subObj:*;
			var thisLevelList:Array = new Array();
			var className:String;
			var typeOfSubObj:String;

			className = getQualifiedClassName(obj);
			if (typeof(obj) == "object" && className != "Object" && className != "Array" && className != "null"){
				obj = _getClassAccessors(obj);
			} 
			className = getQualifiedClassName(obj);
			if (typeof(obj) == "object" && className == "Array"){
				return _recursiveArrayCopy(obj as Array, levelsLimit, levelsIn, isTyped);
			} else {
				for (var prop in obj){
					subObj = obj[prop];
					typeOfSubObj = typeof(subObj);
					if(typeOfSubObj != "function"){
						if(typeOfSubObj == "object"){
							className = getQualifiedClassName(subObj);
							if (className == "Array"){
								objectOutput[prop+"(Array)"] = _recursiveArrayCopy(subObj as Array, levelsLimit, levelsIn, isTyped);
							} else if (className == "Object"){
								objectOutput[prop+"(Object)"] = _recurseObjectTreeFormatToObj(levelsLimit, subObj, levelsIn, isTyped);
							} else if (className != "null"){
								subObj = _getClassAccessors(subObj);
								objectOutput[prop+"("+_escapeToVarChars(className)+")"] = _recurseObjectTreeFormatToObj(levelsLimit, subObj, levelsIn, isTyped);
							} else {
								if (subObj != null){
									//this is a catch all if we missed some how the type of the object
									objectOutput[prop+"("+_escapeToVarChars(typeOfSubObj)+")"] = obj[prop].toString();
								} else {
									//here we can assume subObj is a null pointer
									objectOutput[prop+"("+_escapeToVarChars(typeOfSubObj)+")"] = null;
								}
							}
						} else if (typeOfSubObj == "string") {
							objectOutput[prop+"(String)"] = (obj[prop]);
						} else if (typeOfSubObj == "xml") {
							objectOutput[prop+"(XML)"] = (obj[prop].toString());
						} else if (typeOfSubObj == "boolean") {
							objectOutput[prop+"(Boolean)"] = obj[prop];
						} else {
							//must be a number because thats is the only possibilities left
							objectOutput[prop+"("+typeOfSubObj+")"] = obj[prop];
						}
					}
				}
			}

			return objectOutput;
		}
		private static function _recursiveArrayCopy(subObj:Array, levelsLimit:uint, levelsIn:uint = 0, isTyped:Boolean = true):*{
			var recurseOutput:Object = {};
			var objectOutput:Object = {};
			var arrayOutput:Array = [];
			var arrayLength:uint;
			var className:String;
			if (subObj == null){
				return null;
			}
			arrayLength = subObj.length;
			if (levelsLimit <= levelsIn){
				if (levelsLimit == 0){
					return subObj.toString(); 
				} else {
					return "Max Depth of "+levelsLimit+" reached ("+subObj.toString()+")";
				}
			}
			
			levelsIn++;
			for (var i:uint = 0; i < arrayLength; i++){
				if (typeof(subObj[i]) == "object"){
					className = getQualifiedClassName(subObj[i]);
					if (className == "Array"){
						if (isTyped){
							objectOutput[i+"(Array)"] = _recursiveArrayCopy(subObj[i] as Array, levelsLimit, levelsIn, isTyped);
						} else {
							arrayOutput[i] = _recursiveArrayCopy(subObj[i] as Array, levelsLimit, levelsIn, isTyped);
						}
					} else if (className == "Object"){
						if (isTyped){
							objectOutput[i+"(Object)"] = _recurseObjectTreeFormatToObj(levelsLimit, subObj[i], levelsIn, isTyped);
						} else {
							arrayOutput[i] = {"(Object)":_recurseObjectTreeFormatToObj(levelsLimit, subObj[i], levelsIn, isTyped)};
						}
					} else if (className != "null"){
						recurseOutput = _getClassAccessors(subObj[i]);
						if (isTyped){
							objectOutput[i+"("+_escapeToVarChars(className)+")"] = _recurseObjectTreeFormatToObj(levelsLimit, recurseOutput, levelsIn, isTyped);
						} else {
							arrayOutput[i] = {};
							arrayOutput[i]["("+_escapeToVarChars(className)+")"] = _recurseObjectTreeFormatToObj(levelsLimit, recurseOutput, levelsIn, isTyped);
						}
					} else {
						if (subObj[i] != null){
							//this is a catch all if we missed some how the type of the object
							if (isTyped){
								objectOutput[i+"("+_escapeToVarChars(typeof(subObj[i]))+")"] = subObj[i].toString();
							} else {
								arrayOutput[i] = subObj[i].toString();
							}
						} else {
							//here we can assume subObj is a null pointer
							if (isTyped){
								objectOutput[i+"("+_escapeToVarChars(typeof(subObj[i]))+")"] = null;
							} else {
								arrayOutput[i] = null;
							}
						}
					}
				} else if (typeof(subObj[i]) != "function"){
					if (typeof(subObj[i]) == "xml"){
						if (isTyped){
							objectOutput[i+"(XML)"] = (subObj[i].toString());
						} else {
							arrayOutput[i] = (subObj[i].toString());
						}
					} else if (typeof(subObj[i]) == "string"){
						if (isTyped){
							objectOutput[i+"(String)"] = (subObj[i]);
						} else {
							arrayOutput[i] = (subObj[i]);
						}
					} else {
						if (isTyped){
							objectOutput[i+"("+typeof(subObj[i])+")"] = subObj[i];
						} else {
							arrayOutput[i] = subObj[i];
						}
					}
				} else if (typeof(subObj[i]) == "function"){
					if (isTyped){
							objectOutput[i+"("+typeof(subObj[i])+")"] = "[function]";
						} else {
							arrayOutput[i] = "[function]";
						}
				}
			}
			if (isTyped){
				return objectOutput;
			} else {
				return arrayOutput;
			}
		}
		private static function _recurseObjectTreeFormat(levelsLimit:uint, obj:Object, levelsIn:uint = 0):String{
			if (obj == null){
				return "";
			}
			var spacesList:Array = new Array();
			spacesList[levelsIn] = "";
			var spaces:String = spacesList.join(" ");
			if (levelsLimit <= levelsIn){
				if (levelsLimit == 0){
					return spaces+"\""+obj.toString()+"\"\n"; 
				} else {
					return spaces+"\"pointerNotFollowed\" : \"Max Depth of "+levelsLimit+" reached.\"\n";
				}
			}
			
			levelsIn++;
			var objectAsString:String = "";
			var subObj:*;
			var thisLevelList:Array = new Array();
			var className:String;
			var typeOfSubObj:String;
			var recurseOutput:String;
			var arrayLength:uint;
			var i:uint;
			className = getQualifiedClassName(obj);
			if (typeof(obj) == "object" && className != "Object" && className != "Array" && className != "null"){
				obj = _getClassAccessors(obj);
			} 
			className = getQualifiedClassName(obj);
			if (typeof(obj) == "object" && className == "Array"){
				objectAsString += _recurseArrayTreeFormat(obj as Array, spaces, "", levelsLimit, levelsIn);
				return objectAsString;
			} else {
				for (var prop in obj){
					subObj = obj[prop];
					typeOfSubObj = typeof(subObj);
					if(typeOfSubObj != "function"){
						if(typeOfSubObj == "object"){
							className = getQualifiedClassName(subObj);
							if (className == "Array"){
								if (i > 0){
									objectAsString += ",";
								}
								objectAsString += spaces+" "+_recurseArrayTreeFormat(subObj as Array, spaces, prop, levelsLimit, levelsIn);
								
							} else if (className == "Object"){
								if (i == 0){
									objectAsString += spaces+" \""+prop+"(Object)\" : \n"+spaces+" {\n";
								} else {
									objectAsString += spaces+" ,\""+prop+"(Object)\" : \n"+spaces+" {\n";
								}
								// objectAsString += "\""+Consts.TYPE_TAG+"\" : \"Object\"\n";
								 objectAsString += _recurseObjectTreeFormat(levelsLimit, subObj, levelsIn);
								 objectAsString += spaces+" }\n";
							} else if (className != "null"){
								subObj = _getClassAccessors(subObj);
								if (i == 0){
									objectAsString += spaces+" \""+prop+"("+_escapeToVarChars(className)+")\" :  \n"+spaces+" {\n";
								} else {
									objectAsString += spaces+" ,\""+prop+"("+_escapeToVarChars(className)+")\" :  \n"+spaces+" {\n"; 
								}
								
								objectAsString += _recurseObjectTreeFormat(levelsLimit, subObj, levelsIn);
								objectAsString += spaces+" }\n";
								//trace("-----"+objectAsString)
							} else {
								if (subObj != null){
									//this is a catch all if we missed some how the type of the object
									if (i == 0){
										objectAsString += spaces+" \""+prop+"("+_escapeToVarChars(typeOfSubObj)+")\" : \""+obj[prop].toString()+"\"\n";
									} else {
									
										objectAsString += spaces+" ,\""+prop+"("+_escapeToVarChars(typeOfSubObj)+")\" : \""+obj[prop].toString()+"\"\n";
									}
								} else {
									//typeOfSubObj is a null pointer
									if (i == 0){
										objectAsString += spaces+" \""+prop+"("+_escapeToVarChars(typeOfSubObj)+")\" : null\n";
									} else {
										objectAsString += spaces+" ,\""+prop+"("+_escapeToVarChars(typeOfSubObj)+")\" : null\n";
									}
								}
							}
						} else if (typeOfSubObj == "string") {
							if (i == 0){
								objectAsString += spaces+" \""+prop+"(String)\" : \""+_escapeString(obj[prop])+"\"\n";
							} else {
								objectAsString += spaces+" ,\""+prop+"(String)\" : \""+_escapeString(obj[prop])+"\"\n";
							}
							//objectAsString += "\""+Consts.TYPE_TAG+"\" : \"String\"\n";
						} else if (typeOfSubObj == "xml") {
							//TODO: make XML format the same way
							//TODO: escape special JSON chars
							if (i == 0){
								objectAsString += spaces+" \""+prop+"(XML)\" : \"\n"+_escapeString(obj[prop].toString())+"\"\n";
							} else {
								objectAsString += spaces+" ,\""+prop+"(XML)\" : \"\n"+_escapeString(obj[prop].toString())+"\"\n";
							}
							//objectAsString += "\""+Consts.TYPE_TAG+"\" : \"XML\"\n";
						} else if (typeOfSubObj == "boolean") {
							if (i == 0){
								objectAsString += spaces+" \""+prop+"(Boolean)\" : \""+obj[prop]+"\"\n";
							} else {
								objectAsString += spaces+" ,\""+prop+"(Boolean)\" : \""+obj[prop]+"\"\n";
							}
							
						} else {
							//must be a number 
							if (i == 0){
								objectAsString += spaces+"\""+prop+"("+_escapeToVarChars(typeOfSubObj)+")\" : "+obj[prop]+"\n";
							} else {
							
								objectAsString += spaces+",\""+prop+"("+_escapeToVarChars(typeOfSubObj)+")\" : "+obj[prop]+"\n";
							}
						}
					}
					i++;
				}
			}

			return objectAsString;
			
		}
		private static function _recurseArrayTreeFormat(subObj:Array, spaces:String, prop:String, levelsLimit:uint, levelsIn:uint = 0):String{
			var recurseOutput:String;
			var objectAsString:String = "";
			var arrayLength:uint;
			var spacesList:Array = new Array();
			spacesList[levelsIn] = "";
			var spaces:String = spacesList.join(" ");
			arrayLength = subObj.length;
			if (arrayLength > 0){
				objectAsString += spaces+"\""+prop+"(Array)\" : [";
				for (var i:uint = 0; i < arrayLength; i++){
					if (typeof(subObj[i]) == "object"){
						if (i == 0){
							objectAsString += "{\n"+spaces;
						} else {
							objectAsString += ",{\n"+spaces;
						}
						//objectAsString += "\""+Consts.TYPE_TAG+"\" : \"Object\"\n";
						objectAsString += _recurseObjectTreeFormat(levelsLimit, subObj[i], levelsIn+1);
						objectAsString += "}";
					} else if (typeof(subObj[i]) != "function"){
						if (typeof(subObj[i]) == "xml"){
							objectAsString += _escapeString(subObj[i].toString());
						} else if (typeof(subObj[i]) == "string"){
							objectAsString += _escapeString(subObj[i]);
						} else {
							objectAsString += subObj[i];
						}
					}
				}
				objectAsString += "]\n"+spaces;
			} else {
				objectAsString += "\""+prop+"(Array)\" : []\n"+spaces;
			}
			return objectAsString;
		}
		
		private static function _escapeToVarChars(str:String):String{
			str = str.replace(/::/gm, ".");
			return str;
		}
		
		private static function _escapeString(str:String):String{
			return str.replace(/"/gm,'\\"');
			return str;
		}
		public static function encodeUtf(str:String):String {
	 		var asciiStr:String = "";
			var len:uint = str.length;

			for (var i:uint; i <len; i++){
				asciiStr += str.charCodeAt(i);
				if (i < len-1){
					asciiStr += ",";
				}
			}
			return(asciiStr);
		}
		private static function _getClassAccessors(obj:*):*{
			var xml:XML = describeType(obj);
			var xmlList:XMLList = xml.accessor;
			var xmlListLength = xmlList.length();
			var prop:String;
			var returnObj:Object = new Object();
			//trace(xmlList.toString());
			for (var i:uint; i < xmlListLength; i++){
				prop = xmlList[i].@name;
				try{
					if (prop != null){
						returnObj[prop] = obj[prop];
					}
				} catch(e:Error){
					returnObj[prop] = e.message;
				}
			}
			
			return returnObj;
		}
	}
}