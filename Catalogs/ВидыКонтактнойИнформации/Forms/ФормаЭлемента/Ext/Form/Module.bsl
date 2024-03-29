﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТипКИАдрес   = Перечисления.ТипыКонтактнойИнформации.Адрес;
	ТипКИТелефон = Перечисления.ТипыКонтактнойИнформации.Телефон;
	ТипКИФакс    = Перечисления.ТипыКонтактнойИнформации.Факс;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПроверитьЭлементыФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи()
	
	ПроверитьЭлементыФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипПриИзменении(Элемент)
	
	ПроверитьЭлементыФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура РедактированиеТолькоВДиалогеПриИзменении(Элемент)
	
	ПроверитьЭлементыФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьЭлементыФормы()
	
	ЭтоНовый = Не ЗначениеЗаполнено(Объект.Ссылка);
	
	Если ЭтоНовый Тогда
		// для новых видов КИ установим признак "Можно изменять способ редактирования"
		Объект.МожноИзменятьСпособРедактирования = Истина;
		
	Иначе
		// для уже записанных запретим редактировать группу и тип
		Элементы.Родитель.ТолькоПросмотр = Истина;
		Элементы.Тип.ТолькоПросмотр      = Истина;
		
		// для предопределенных запретим и наименование редактировать
		Если Объект.Предопределенный Тогда
			Элементы.Наименование.ТолькоПросмотр = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не Объект.МожноИзменятьСпособРедактирования Тогда
		// Если у объекта нельзя менять способ редактирования, то сделаем недоступными оставшиеся элементы
		Элементы.РедактированиеТолькоВДиалоге.Доступность = Ложь;
		Элементы.АдресТолькоУкраинский.Доступность = Ложь;
		Возврат;
	
	КонецЕсли;
	
	ЭтоАдрес   = (Объект.Тип = ТипКИАдрес);
	ЭтоТелефон = (Объект.Тип = ТипКИТелефон);
	ЭтоФакс    = (Объект.Тип = ТипКИФакс);
	
	// Установим доступность и проверим значение поля РедактированиеТолькоВДиалоге
	Если ЭтоАдрес ИЛИ ЭтоТелефон ИЛИ ЭтоФакс Тогда
		Элементы.РедактированиеТолькоВДиалоге.Доступность = Истина;
	Иначе
		Элементы.РедактированиеТолькоВДиалоге.Доступность = Ложь;
		Если Объект.РедактированиеТолькоВДиалоге Тогда
			Объект.РедактированиеТолькоВДиалоге = Ложь;
		КонецЕсли;
	КонецЕсли;
		
	// Установим доступность и проверим значение поля РедактированиеТолькоВДиалоге
	Если ЭтоАдрес И Объект.РедактированиеТолькоВДиалоге Тогда
		Элементы.АдресТолькоУкраинский.Доступность = Истина;
	Иначе
		Элементы.АдресТолькоУкраинский.Доступность = Ложь;
		Если Объект.АдресТолькоУкраинский Тогда
			Объект.АдресТолькоУкраинский = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

