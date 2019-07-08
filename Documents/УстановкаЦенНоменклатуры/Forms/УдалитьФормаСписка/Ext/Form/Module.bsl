﻿
&НаКлиенте
Процедура ОтборПодразделениеПриИзменении(Элемент)
	
	УправлениеНебольшойФирмойКлиент.ИзменитьЭлементОтбораСписка(Список, "Подразделение", ОтборПодразделение, ЗначениеЗаполнено(ОтборПодразделение));

КонецПроцедуры


&НаКлиенте
Процедура ОтборАвторПриИзменении(Элемент)
	
	УправлениеНебольшойФирмойКлиент.ИзменитьЭлементОтбораСписка(Список, "Автор", ОтборАвтор, ЗначениеЗаполнено(ОтборАвтор));
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ОтборПодразделение = Настройки.Получить("ОтборПодразделение");
	ОтборКонтрагент = Настройки.Получить("ОтборКонтрагент");
	ОтборАвтор = Настройки.Получить("ОтборАвтор");
	
	УправлениеНебольшойФирмойСервер.ИзменитьЭлементОтбораСписка(Список, "Подразделение", ОтборПодразделение, ЗначениеЗаполнено(ОтборПодразделение));
	УправлениеНебольшойФирмойСервер.ИзменитьЭлементОтбораСписка(Список, "Контрагент", ОтборКонтрагент, ЗначениеЗаполнено(ОтборКонтрагент));
	УправлениеНебольшойФирмойСервер.ИзменитьЭлементОтбораСписка(Список, "Автор", ОтборАвтор, ЗначениеЗаполнено(ОтборАвтор));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборНоменклатурнаяГруппаПриИзменении(Элемент)
	
	УправлениеНебольшойФирмойКлиент.ИзменитьЭлементОтбораСписка(Список, "НоменклатурнаяГруппа", ОтборНоменклатурнаяГруппа, ЗначениеЗаполнено(ОтборНоменклатурнаяГруппа));
	
КонецПроцедуры
