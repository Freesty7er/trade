﻿
&НаКлиенте
Процедура ОтборПодразделениеПриИзменении(Элемент)
	
	УправлениеНебольшойФирмойКлиент.ИзменитьЭлементОтбораСписка(Список, "Подразделение", ОтборПодразделение, ЗначениеЗаполнено(ОтборПодразделение));

КонецПроцедуры

&НаКлиенте
Процедура ОтборМаршрутПриИзменении(Элемент)
	
	УправлениеНебольшойФирмойКлиент.ИзменитьЭлементОтбораСписка(Список, "МаршрутРазвоза", ОтборМаршрут, ЗначениеЗаполнено(ОтборМаршрут));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборАвторПриИзменении(Элемент)
	
	УправлениеНебольшойФирмойКлиент.ИзменитьЭлементОтбораСписка(Список, "Автор", ОтборАвтор, ЗначениеЗаполнено(ОтборАвтор));
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ОтборПодразделение = Настройки.Получить("ОтборПодразделение");
	ОтборМаршрут = Настройки.Получить("ОтборМаршрут");
	ОтборАвтор = Настройки.Получить("ОтборАвтор");
	
	УправлениеНебольшойФирмойСервер.ИзменитьЭлементОтбораСписка(Список, "Подразделение", ОтборПодразделение, ЗначениеЗаполнено(ОтборПодразделение));
	УправлениеНебольшойФирмойСервер.ИзменитьЭлементОтбораСписка(Список, "МаршрутРазвоза", ОтборМаршрут, ЗначениеЗаполнено(ОтборМаршрут));
	УправлениеНебольшойФирмойСервер.ИзменитьЭлементОтбораСписка(Список, "Автор", ОтборАвтор, ЗначениеЗаполнено(ОтборАвтор));
	
КонецПроцедуры



&НаСервере
Процедура УстановитьМаршрут(Знач ДанныеДляОбработки, ЗначениеМаршрутРазвоза)
	
	//ЗначениеМаршрутРазвоза = Неопределено;
	
	Если ДанныеДляОбработки <> Неопределено Тогда
		
		Для Каждого ТекущиеДанные Из ДанныеДляОбработки Цикл
			Если ЗначениеЗаполнено(ТекущиеДанные) И (НЕ ТекущиеДанные.МаршрутРазвоза = ЗначениеМаршрутРазвоза) Тогда
				Объект = ТекущиеДанные.ПолучитьОбъект();
				Объект.МаршрутРазвоза = ЗначениеМаршрутРазвоза;
				Объект.Записать();
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьЗаявку(Команда)
	
	ЗначениеМаршрутРазвоза = ОткрытьФормуМодально("Справочник.МаршрутыРазвоза.ФормаВыбора",);
	
	Если ЗначениеМаршрутРазвоза = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМаршрут(Элементы.Список.ВыделенныеСтроки, ЗначениеМаршрутРазвоза);
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура Печать(Команда)
	
	ДатаОкончания = Элементы.список.Период.ДатаОкончания;
	Если ДатаОкончания = '0001-01-01' Тогда
		ДатаОкончания = КонецДня(ТекущаяДата());
	КонецЕсли;
	
	УсловияОтбора = Новый Структура("НачалоПериода, КонецПериода, МаршрутРазвоза", ДатаОкончания-7*24*60*60, ДатаОкончания, ОтборМаршрут);
	ПараметрыФормы = Новый Структура("Отбор, СформироватьПриОткрытии", УсловияОтбора, Истина);
	
	ОткрытьФорму("Отчет.ВедомостьПоРазвозу.ФормаОбъекта", ПараметрыФормы);
	
КонецПроцедуры
