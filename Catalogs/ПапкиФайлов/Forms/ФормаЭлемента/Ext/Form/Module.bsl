﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Родитель") Тогда
		Объект.Родитель = Параметры.Родитель;
	КонецЕсли;
	
	РабочийКаталог = РаботаСФайламиВызовСервера.ПолучитьРабочийКаталог(Объект.Ссылка);
	
	// Обработчик подсистемы "Свойства"
	УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, Объект, "");
	
	ОбновитьПолныйПуть();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПолныйПуть()
	
	ПапкаРодитель = Объект.Родитель;
	ПолныйПуть = "";
	Пока Не ПапкаРодитель.Пустая() Цикл
		
		ПолныйПуть = Строка(ПапкаРодитель) + "\" + ПолныйПуть;
		ПапкаРодитель = ПапкаРодитель.Родитель;
		
	КонецЦикла;
	
	ПолныйПуть = ПолныйПуть + Строка(Объект.Ссылка);
	
	Если Не ПустаяСтрока(ПолныйПуть) Тогда
		ПолныйПуть = """" + ПолныйПуть + """";
	КонецЕсли;
	
КонецПроцедуры	

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// Обработчик подсистемы "Свойства"
	Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
		ОбновитьЭлементыДополнительныхРеквизитов();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект)
	
	// Обработчик подсистемы "Свойства"
	УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура РабочийКаталогВладельцаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Объект.Ссылка.Пустая() Тогда
		Если Записать() = Ложь Тогда
			Возврат;
		КонецЕсли;	
	КонецЕсли;	
	
	ОчиститьСообщения();
	
	Каталог = "";
	Режим = РежимДиалогаВыбораФайла.ВыборКаталога;
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
	ДиалогОткрытияФайла.Каталог = РабочийКаталог;
	ДиалогОткрытияФайла.ПолноеИмяФайла = "";
	Фильтр = НСтр("ru = 'Все файлы(*.*)|*.*'");
	ДиалогОткрытияФайла.Фильтр = Фильтр;
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите каталог'");
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		
		ИмяКаталога = ДиалогОткрытияФайла.Каталог;
		ФайловыеФункцииКлиентСервер.ДобавитьСлешЕслиНужно(ИмяКаталога);
		
		// Создать каталог для файлов
		Попытка
			СоздатьКаталог(ИмяКаталога);
			ИмяКаталогаТестовое = ИмяКаталога + "ПроверкаДоступа\";
			СоздатьКаталог(ИмяКаталогаТестовое);
			УдалитьФайлы(ИмяКаталогаТестовое);
		Исключение
			// нет прав на создание каталога, или такой путь отсутствует
			
			ТекстОшибки 
				= СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Неверный путь или отсутствуют права на запись в каталог ""%1""'"),
				ИмяКаталога);
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки, , "РабочийКаталог");
			Возврат;
		КонецПопытки;
		
		РабочийКаталог = ИмяКаталога;
		РаботаСФайламиВызовСервера.СохранитьРабочийКаталог(Объект.Ссылка, РабочийКаталог);
		
	КонецЕсли;
	
	ОбновитьОтображениеДанных();
	
КонецПроцедуры

&НаКлиенте
Процедура РабочийКаталогВладельцаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	РодительСсылка = ОбщегоНазначения.ПолучитьЗначениеРеквизита(Объект.Ссылка, "Родитель");
	РабочийКаталогРодителя = РаботаСФайламиВызовСервера.ПолучитьРабочийКаталог(РодительСсылка);	
	
	РабочийКаталогЭтойПапки = РаботаСФайламиВызовСервера.ПолучитьРабочийКаталог(Объект.Ссылка);
	РабочийКаталогУнаследованный = РабочийКаталогРодителя + Объект.Наименование + "\";
	
	Если ПустаяСтрока(РабочийКаталогРодителя) Тогда
		РабочийКаталог = "";
		РаботаСФайламиВызовСервера.ОчиститьРабочийКаталог(Объект.Ссылка);
	ИначеЕсли РабочийКаталогУнаследованный <> РабочийКаталогЭтойПапки Тогда
		РабочийКаталог = РабочийКаталогУнаследованный;
		РаботаСФайламиВызовСервера.СохранитьРабочийКаталог(Объект.Ссылка, РабочийКаталог);
	КонецЕсли;
	
	ОбновитьОтображениеДанных();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	РабочийКаталог = РаботаСФайламиВызовСервера.ПолучитьРабочийКаталог(Объект.Ссылка);
КонецПроцедуры


&НаКлиенте
Процедура РодительПриИзменении(Элемент)
	
	ОбновитьПолныйПуть();
	
КонецПроцедуры


&НаКлиенте
Процедура ОткрытьСписокПапокИФайлов(Команда)
	
	ПараметрыФормы = Новый Структура("Папка", Объект.Ссылка);
	
	ОткрытьФорму("Справочник.Файлы.Форма.ХранилищеФайлов", ПараметрыФормы, ,Объект.Ссылка);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ПОДСИСТЕМЫ СВОЙСТВ

&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств()
	
	УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтаФорма, Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма, РеквизитФормыВЗначение("Объект"));
	
КонецПроцедуры

