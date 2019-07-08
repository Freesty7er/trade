﻿
&НаКлиенте
Процедура Печать(Команда)
	
	//ДатаОкончания = Элементы.Список.Период.ДатаОкончания;
	
	ДатаОкончания = КонецДня(ТекущаяДата());
	Родитель = Элементы.Список.Родитель;
	
	УсловияОтбора = Новый Структура("ДатаСреза", ДатаОкончания);
	ПараметрыФормы = Новый Структура("Отбор, СформироватьПриОткрытии", УсловияОтбора, Ложь);
	
	ОткрытьФорму("Отчет.СписокКонтрагентов.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьСкидок(Команда)
	
	Родитель = Элементы.Список.Родитель;
	
	ПараметрыФормы = Новый Структура("Отбор, СформироватьПриОткрытии", , Истина);
	
	ОткрытьФорму("Отчет.СписокСкидокПоКлиентам.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаПриИзменении(Элемент)
	Элементы.Список.ТекущаяСтрока = СтрокаПоиска;
КонецПроцедуры

&НаКлиенте
Процедура ПечатьБонусов(Команда)
	
	Родитель = Элементы.Список.Родитель;
	
	ПараметрыФормы = Новый Структура("Отбор, СформироватьПриОткрытии", , Истина);
	
	ОткрытьФорму("Отчет.СписокБонусовПоКлиентам.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры


