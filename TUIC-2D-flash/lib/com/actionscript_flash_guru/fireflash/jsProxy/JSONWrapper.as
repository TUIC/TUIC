package com.actionscript_flash_guru.fireflash.jsProxy{
	
	public class JSONWrapper {
		private var _id:String;
		public function JSONWrapper(id:String){
			_id = id;
		}
		public function get id():String{
			return _id;
		}
	}
}