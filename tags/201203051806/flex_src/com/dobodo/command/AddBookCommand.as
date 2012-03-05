package com.dobodo.command
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.dobodo.business.BookDelegate;
	import com.dobodo.event.AddBookEvent;
	import com.dobodo.model.ModelLocator;
	import com.dobodo.vo.BookVO;
	import mx.rpc.IResponder;
	import mx.controls.Alert;
	public class AddBookCommand implements ICommand, IResponder
	{ 
		private var model:ModelLocator = ModelLocator.getInstance();
		public function execute(event:CairngormEvent):void
		{
			var book:BookVO=(event as AddBookEvent).bookVO;
   			var bookDelegate:BookDelegate = new BookDelegate(this); //委托给BookDelegate处理具体
   			bookDelegate.addBook(book);
		}
		// 根据BookDelegate返回的结果进行处理    
		public function result(event:Object):void
		{
   			var book:BookVO = event.result as BookVO;
   			
   			
   				//======================		
//			var resultVo:BookVO = _result as BookVO ;
			//这里可以调用处理业务逻辑的类，比如调用远程的数据库操作类，把book插入到数据库里。
			if(book.bookName!="")
			{
				model.BookAC.addItem(book); 
   				//responder.result(book);//返回给command
			}
			else
			{
				//responder.result(null);//返回给command
			}
			
			
   			//=================
   			if(book!=null)
   			{
   				  Alert.show("增加成功！");
   			}
   			else
   			{
   				 Alert.show("增加失败！");
   			}
		}
		public function fault(event:Object):void{ }
	}
}