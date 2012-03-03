package com.dobodo.business
{
	import com.dobodo.model.*;
	import com.dobodo.service.DelegateEnums;
	import com.dobodo.vo.BaseParam;
	import com.dobodo.vo.BookVO;
	
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.remoting.RemoteObject;
	public class BookDelegate
	{
		private var model:ModelLocator = ModelLocator.getInstance();
		private var responder:IResponder;
		private var service:RemoteObject;
		
		private var _result:AsyncToken;
		
		public function BookDelegate(responder:IResponder)
		{
   			this.responder = responder;
   			this.service = new RemoteObject();
   			this.service.destination = DelegateEnums.ADD_BOOK_DELEGATE;
		}
		
		public function addBook(vo:BaseParam):void
		{
			
			
			_result = service.insertBook(vo);
//			_result = service.test();

			_result.addResponder(this.responder);
		}

		
		
		
		
		
//			public function addBook(bookVO:BookVO):void
//		{
//			//这里可以调用处理业务逻辑的类，比如调用远程的数据库操作类，把book插入到数据库里。
//			if(bookVO.bookName!="")
//			{
//				model.BookAC.addItem(bookVO); 
//   				responder.result(bookVO);//返回给command
//			}
//			else
//			{
//				responder.result(null);//返回给command
//			}
//		}
	}
}