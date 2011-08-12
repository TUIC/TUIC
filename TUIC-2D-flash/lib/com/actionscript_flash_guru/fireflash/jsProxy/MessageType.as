package com.actionscript_flash_guru.fireflash.jsProxy{
	//import com.actionscript_flash_guru.fireflash.jsProxy.JsProxySingleton;
	
	public class MessageType{
		
		private var _id:String;
		//general message type
		public static const MESSAGE:String = "Message";
		//message types with very different behaviours
		public static const ASSERT:String = "Assert";
		public static const XML_DIR:String = "XMLDir";
		public static const OBJECT_DIR:String = "ObjectDir";
		public static const GROUP_COLLAPSED:String = "GroupCollapsed";
		public static const GROUP:String = "Group";
		public static const GROUP_END:String = "GroupEnd";
		public static const STACK_TRACE:String = "StackTrace";
		public static const TIME:String = "Time";
		
		public function MessageType(type:String):void{
			if ( validateType(type) ){
				_id = type;
			} else {
				//JsProxySingleton.reportInternalFailure("Invalid message type: "+type);
				trace("Invalid message type: "+type);
				_id = MESSAGE;
			}
		}
		public function getId():String{
				return _id;
		}
		public static function validateType(type:String):Boolean{
			switch (type){
				case MESSAGE:
					return true;
				case ASSERT:
					return true;
				case XML_DIR:
					return true;
				case OBJECT_DIR:
					return true;
				case GROUP:
					return true;
				case GROUP_END:
					return true;
				case GROUP_COLLAPSED:
					return true;
				case STACK_TRACE:
					return true;
				case TIME:
					return true;
				default:
					return false;
			}
		}
		
	}
}