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
	public class ArrayWrapper {
		
		private var _id:Array;
		
		public function ArrayWrapper(array:Array){
			
			var len:uint;
			var i:uint;
			var type:String;
			
			if (array == null){
				return;
			}
			_id = [];
			len = array.length;
			//remove any references to the outside array by copying over arrays and objects to a new array as a string
			for (i = 0; i<len; i++){
				if (array[i] != null){
					type = typeof(array[i]);
					if (type == "string"){
						_id.push(array[i]);
					} else if (type == "object") {
						//this cannot be parsed into sub arrays if we do this it will be too processor intentse.
						if (array[i] is Array){
							//TODO: parse out real object
							_id.push(array[i].toString());
						} else {
							//TODO: parse out object
							_id.push( array[i].toString() );
						}
					} else if (type == "function"){
						_id.push(array[i].toString());
					} else {
						//boolean or number, has no reference so it can be left as its native type
						_id.push(array[i]);
					} 
				} else {
					_id.push(null);
				}
			}
		}
		
		public function get id():Array{
			return _id;
		}
	}
}