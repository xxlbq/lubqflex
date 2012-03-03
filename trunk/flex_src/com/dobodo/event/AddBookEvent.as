package com.dobodo.event
{
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.dobodo.vo.BookVO;
	public class AddBookEvent extends CairngormEvent
	{
		public var bookVO:BookVO;
		public static const EVENT_ADD_BOOK:String ="addBook";
		
		
		public function AddBookEvent(bookVO:BookVO){
			
     		 super(AddBookEvent.EVENT_ADD_BOOK);
       		 this.bookVO = bookVO;
  		 }
	}
}