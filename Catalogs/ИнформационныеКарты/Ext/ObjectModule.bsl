﻿
#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(отказ, проверяемыеРеквизиты)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЭтоГруппа Тогда
		
		Если Не Ссылка.Пустая() И Ссылка = Реферал Тогда
			
			отказ = Истина;
			
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru = 'Карта не может быть рефералом для самой себя.'");
			Сообщение.Поле = "Реферал";
			Сообщение.УстановитьДанные(ЭтотОбъект);
			Сообщение.Сообщить();
			
		КонецЕсли; 
		
		Если Не ПустаяСтрока(КодКарты) Тогда
			
			УстановитьПривилегированныйРежим(Истина);
			
			// Проверим уникальность кода карты.
			запрос = Новый Запрос;
			
			#Область ТекстЗапроса
			
			запрос.Текст =
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	ИнформационныеКарты.Ссылка
			|ИЗ
			|	Справочник.ИнформационныеКарты КАК ИнформационныеКарты
			|ГДЕ
			|	ИнформационныеКарты.Ссылка <> &ИнформационнаяКарта
			|	И ИнформационныеКарты.КодКарты = &КодКарты
			|	И НЕ ИнформационныеКарты.ПометкаУдаления";
			
			#КонецОбласти 
			
			запрос.УстановитьПараметр("ИнформационнаяКарта", Ссылка);
			запрос.УстановитьПараметр("КодКарты", КодКарты);
			
			Если Не запрос.Выполнить().Пустой() Тогда
				
				отказ = Истина;
				
				текстСообщения = НСтр("ru = 'Информационная карта с кодом карты [КодКарты] уже существует. Введите другое значение.'");
				текстСообщения = СтрЗаменить(ТекстСообщения, "[КодКарты]", КодКарты);
				
				сообщение = Новый СообщениеПользователю;
				сообщение.Текст = текстСообщения;
				сообщение.Поле = "КодКарты";
				сообщение.УстановитьДанные(ЭтотОбъект);
				сообщение.Сообщить();
				
			КонецЕсли; 
			
			УстановитьПривилегированныйРежим(Ложь);
			
		КонецЕсли; 
	
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриКопировании(объектКопирования)
	
	Если Не ЭтоГруппа Тогда
		КодКарты = Неопределено;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПередЗаписью(отказ)
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли; 
	
	Если НЕ ЗначениеЗаполнено(ВладелецКарты) Тогда
		ОбщегоНазначения.СообщитьОбОшибке("Владелец карты должен быть заполнен", отказ);
		Возврат;
	КонецЕсли;
	
	Если Не Отказ Тогда
		ДополнительныеСвойства.Вставить("ВыгружатьНаПОС", Ссылка.Р_ВыгружатьНаПОС);
	КонецЕсли
	
КонецПроцедуры

Процедура ПриЗаписи(отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	// регистрация изменений для всех узлов ... "ПланыОбмена.Р_POS"
	выборка = ПланыОбмена.Р_POS.Выбрать();
	Пока выборка.Следующий() Цикл
		Если выборка.Ссылка = ПланыОбмена.Р_POS.ЭтотУзел() Тогда
			Продолжить;
		КонецЕсли;
		
		ПланыОбмена.ЗарегистрироватьИзменения(выборка.Ссылка, Ссылка);
		
	КонецЦикла;

КонецПроцедуры

#КонецОбласти