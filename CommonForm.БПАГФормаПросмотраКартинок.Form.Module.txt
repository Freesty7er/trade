
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("МассивФото") Тогда
		
		ЭтаФорма.АвтоЗаголовок = Ложь;
		ЭтаФорма.Заголовок = Параметры.ЗаголовокГалереи;
				
		ПолеHTMLБольшаяКартинка = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.0 Transitional//EN"">
			|<HTML>
			|<HEAD>
			|<META HTTP-EQUIV=""Content-Type"" CONTENT=""text/html; CHARSET=utf-8"">
			|</HEAD>
			|<BODY>
			|<img src=""file://" + Параметры.ТекущееФото + """ width=""100%"" /> 
			|</BODY>
			|</HTML>";
			
		СтрокаФото = "";
		МассивФото = Параметры.МассивФото;
		Для Каждого тмпФото Из МассивФото Цикл
			СтрокаФото = СтрокаФото + "<img src=""file://" + тмпФото + """ height=""100%"" hspace=3 />";
		КонецЦикла;
			
		ПолеHTMLГалерея = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.0 Transitional//EN"">
			|<HTML>
			|<HEAD>
			|<META HTTP-EQUIV=""Content-Type"" CONTENT=""text/html; CHARSET=utf-8"">
			|</HEAD>
			|<BODY><table height=""90%""><tr><td>" + СтрокаФото + "</td></tr></table>
			|</BODY>
			|</HTML>";
			
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолеГалереяПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	Попытка
		ФайлКартинки = ДанныеСобытия.Element.href;
		
		ПолеHTMLБольшаяКартинка = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.0 Transitional//EN"">
			|<HTML>
			|<HEAD>
			|<META HTTP-EQUIV=""Content-Type"" CONTENT=""text/html; CHARSET=utf-8"">
			|</HEAD>
			|<BODY>
			|<img src=""" + ФайлКартинки + """ width=""100%"" /> 
			|</BODY>
			|</HTML>";
	Исключение
	КонецПопытки;
	
КонецПроцедуры
