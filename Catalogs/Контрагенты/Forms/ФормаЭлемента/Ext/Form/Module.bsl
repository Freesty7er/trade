﻿
#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.МенеджерыСрокОплаты.ТолькоПросмотр = Не РольДоступна("ИзменениеДнейОтсрочки");
	Элементы.МенеджерыМаксимальнаяСуммаКредита.ТолькоПросмотр = Не РольДоступна("ИзменениеДнейОтсрочки");
		
КонецПроцедуры

&НаКлиенте
Процедура СрокОплатыПриИзменении(Элемент)
	ОбработатьИзменениеСрокаОплатыНаСервере();	
КонецПроцедуры

&НаКлиенте
Процедура Свойство_КолвоСКУПриИзменении(Элемент)
	ОбработатьИзменениеКолвоСКУНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура КД_ТипСтандартаПрисутствияПриИзменении(Элемент)
	ОбработатьИзменениеТипаСтандартаПрисутствияНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура КД_КаналСбытаПриИзменении(Элемент)
	ОбработатьИзменениеКаналаСбытаНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура МенеджерыПриНачалеРедактирования(элемент, новаяСтрока, копирование)
	
	Если копирование Тогда
		элемент.ТекущиеДанные.ГруппаПродукта = Неопределено;
		элемент.ТекущиеДанные.Менеджер = Неопределено;
		элемент.ТекущиеДанные.ОсновнаяОрганизация = Неопределено;
		элемент.ТекущиеДанные.ИД = "";
		элемент.ТекущиеДанные.Представление = "";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ДополнительныеПроцедурыИФункции

// Устанавливает Категорию торговой точки в соответствии с параметрами
//
&НаСервере
Процедура ИзменитьКД_Категория()
	
	// "Качественная дистрибуция"
	обКонтрагент = Объект;
	
	// определимся с категорией
	ТипСтандартаПрисутствия = обКонтрагент.КД_ТипСтандартаПрисутствия;
	КолвоСКУ 				= обКонтрагент.Свойство_КолвоСКУ;
	КаналСбыта 				= обКонтрагент.КД_КаналСбыта;
	Категория				= обКонтрагент.КД_Категория;
	
	Если НЕ(Найти(Категория.Код, "000000007,000000003,000000004,000000005") = 0) Тогда
		// ХоРеКа, Файно - не меняем
	ИначеЕсли КаналСбыта.Код = "000000001" Тогда
		// "Сети локальные"
		Категория = Справочники.КД_КатегорииТТ.НайтиПоКоду("000000002");
		
	ИначеЕсли КаналСбыта.Код = "000000003" Тогда
		// "ОПТ"
		Категория = Справочники.КД_КатегорииТТ.НайтиПоКоду("000000006");
		
	ИначеЕсли КаналСбыта.Код = "000000007" Тогда
		// "Производство"
		Категория = Справочники.КД_КатегорииТТ.НайтиПоКоду("000000015");
		
	ИначеЕсли КаналСбыта.Код = "000000005" Тогда
		// "Рынок"
		Категория = Справочники.КД_КатегорииТТ.НайтиПоКоду("000000008");
		
	Иначе
		// "Линейная розница" - будем анализировать ТипСтандарта и КолвоСКУ
		Если ТипСтандартаПрисутствия.Код = "000000001" Тогда
			// Город
			Если КолвоСКУ >= 60 Тогда
				// "А"
				Категория = Справочники.КД_КатегорииТТ.НайтиПоКоду("000000009");
			ИначеЕсли (КолвоСКУ >= 30) И (КолвоСКУ < 60) Тогда
				// "В"
				Категория = Справочники.КД_КатегорииТТ.НайтиПоКоду("000000010");
			Иначе
				// "С"
				Категория = Справочники.КД_КатегорииТТ.НайтиПоКоду("000000011");
			КонецЕсли;
			
		Иначе
			// Село
			Если КолвоСКУ >= 60 Тогда
				// "А1"
				Категория = Справочники.КД_КатегорииТТ.НайтиПоКоду("000000012");
			ИначеЕсли (КолвоСКУ >= 30) И (КолвоСКУ < 60) Тогда
				// "В1"
				Категория = Справочники.КД_КатегорииТТ.НайтиПоКоду("000000013");
			Иначе
				// "С1"
				Категория = Справочники.КД_КатегорииТТ.НайтиПоКоду("000000014");
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	
	обКонтрагент.КД_Категория = Категория;
	
	
КонецПроцедуры

// Выполняет обработку данных документа при изменении реквизита "СрокОплаты"
//
&НаСервере
Процедура ОбработатьИзменениеСрокаОплатыНаСервере()
	
	Если Не РольДоступна("ИзменениеДнейОтсрочки") Тогда
		
		Если Не Объект.Ссылка.Пустая() Тогда
			
			Если Объект.СрокОплаты > Объект.Ссылка.СрокОплаты Тогда
				
				Объект.СрокОплаты = Объект.Ссылка.СрокОплаты;
				
				сообщение = Новый СообщениеПользователю;
				сообщение.Текст = НСтр("ru = 'У вас не достаточно прав для увеличения срока оплаты!'");
				сообщение.Поле = "СрокОплаты";
				сообщение.ПутьКДанным = "Объект"; 
				сообщение.КлючДанных = Объект.Ссылка;
				
				сообщение.Сообщить();
				
			КонецЕсли;
			
		ИначеЕсли Объект.СрокОплаты > 1 Тогда
			Объект.СрокОплаты = 1;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Выполняет обработку данных документа при изменении реквизита "КолвоСКУ"
//
&НаСервере
Процедура ОбработатьИзменениеКолвоСКУНаСервере()
	ИзменитьКД_Категория();	
КонецПроцедуры

// Выполняет обработку данных документа при изменении реквизита "ТипСтандартаПрисутствия"
//
&НаСервере
Процедура ОбработатьИзменениеТипаСтандартаПрисутствияНаСервере()
	ИзменитьКД_Категория();	
КонецПроцедуры

// Выполняет обработку данных документа при изменении реквизита "КаналСбыта"
//
&НаСервере
Процедура ОбработатьИзменениеКаналаСбытаНаСервере()
	ИзменитьКД_Категория();	
КонецПроцедуры

#КонецОбласти