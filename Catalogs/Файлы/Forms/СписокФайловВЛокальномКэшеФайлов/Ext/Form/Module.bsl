﻿&НаКлиенте
Процедура ЗаполнитьСписокФайловВФорме()
	ФайловыеФункцииКлиент.ПроинициализироватьПутьКРабочемуКаталогу();
	ПутьКЛокальномуКэшуФайлов = ФайловыеФункцииКлиентПовтИсп.ПолучитьПерсональныеНастройкиРаботыСФайлами().ПутьКЛокальномуКэшуФайлов;
	
	СписокФайлов.Очистить();
	
	Для Каждого Строка Из СписокЗначенийФайловВРегистре Цикл
		
		ПолныйПуть = ПутьКЛокальномуКэшуФайлов + Строка.Значение.ЧастичныйПуть;
		Файл = Новый Файл(ПолныйПуть);
		Если Файл.Существует() Тогда
			НоваяСтрока = СписокФайлов.Добавить();
			
			ДатаФайлаВКеше = Строка.Значение.ДатаМодификацииУниверсальная;
			ОбщегоНазначенияКлиент.ПреобразоватьЗимнееВремяКТекущему(ДатаФайлаВКеше);
			НоваяСтрока.ДатаИзмененияФайла = ДатаФайлаВКеше;
			
			НоваяСтрока.ИмяФайла = Строка.Значение.ПолноеНаименование;
			НоваяСтрока.ИндексКартинки  = Строка.Значение.ИндексКартинки;
			НоваяСтрока.Размер = Строка.Значение.Размер;
			НоваяСтрока.Версия = Строка.Значение.Ссылка;
			НоваяСтрока.Редактирует = Строка.Значение.Редактирует;
			НоваяСтрока.НаРедактирование = НЕ Строка.Значение.НаЧтение;
		КонецЕсли;
	
	КонецЦикла; 	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ЗаполнитьСписокФайловВФорме();
КонецПроцедуры

&НаКлиенте
Процедура УдалитьПоСсылке(СсылкаДляУдаления)
	КоличествоЭлементов = СписокФайлов.Количество();
	
	Для Номер = 0 По КоличествоЭлементов - 1 Цикл
		Строка = СписокФайлов[Номер];
		Ссылка = Строка.Версия;
		Если Ссылка = СсылкаДляУдаления Тогда
			СписокФайлов.Удалить(Номер);
			Возврат;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ОсвободитьВыполнить()
	МассивСсылок = Новый Массив;
	Для Каждого Элемент Из Элементы.СписокФайлов.ВыделенныеСтроки Цикл
		ДанныеСтроки = Элементы.СписокФайлов.ДанныеСтроки(Элемент);
		Ссылка = ДанныеСтроки.Версия;
		МассивСсылок.Добавить(Ссылка);
	КонецЦикла;
	
	Для Каждого Ссылка Из МассивСсылок Цикл
		ДанныеФайла = РаботаСФайламиВызовСервера.ПолучитьДанныеФайла(Неопределено, Ссылка);
		
		// Проверяем возможность освобождения
		СтрокаОшибки = "";
		Если Не РаботаСФайламиКлиент.ВозможностьОсвободитьФайл(ДанныеФайла.Ссылка, ДанныеФайла.РедактируетТекущийПользователь, ДанныеФайла.Редактирует, СтрокаОшибки) Тогда
			Предупреждение(СтрокаОшибки);
			Продолжить;
		КонецЕсли;
		
		РаботаСФайламиКлиент.ОсвободитьФайл(ДанныеФайла.Ссылка);
	КонецЦикла;
	
	ЗаполнитьСписокФайлов();
	ЗаполнитьСписокФайловВФорме();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокФайлов()
	
	СписокФайловВРегистре = РаботаСФайламиВызовСервера.СписокФайловВРегистре();
	СписокЗначенийФайловВРегистре.Очистить();
	
	Для Каждого Строка Из СписокФайловВРегистре Цикл
		СписокЗначенийФайловВРегистре.Добавить(Строка);
	КонецЦикла; 	

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗаполнитьСписокФайлов();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКаталогФайлаВыполнить()
	Если Элементы.СписокФайлов.ТекущиеДанные <> Неопределено Тогда
		Ссылка = Элементы.СписокФайлов.ТекущиеДанные.Версия;
		ДанныеФайла = РаботаСФайламиВызовСервера.ПолучитьДанныеФайла(Неопределено, Ссылка);
		РаботаСФайламиКлиент.КаталогФайла(ДанныеФайла);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УдалитьИзЛокальногоКэшаФайлов(Команда)
	МассивСсылок = Новый Массив;
	Для Каждого НомерЦикла Из Элементы.СписокФайлов.ВыделенныеСтроки Цикл
		ДанныеСтроки = Элементы.СписокФайлов.ДанныеСтроки(НомерЦикла);
		Ссылка = ДанныеСтроки.Версия;
		Если ДанныеСтроки.НаРедактирование = Ложь Тогда // Если не занят текущим пользователем
			МассивСсылок.Добавить(Ссылка);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Ссылка Из МассивСсылок Цикл
		РаботаСФайламиКлиент.УдалитьФайлИзРабочегоКаталога(Ссылка);
		УдалитьПоСсылке(Ссылка);
	КонецЦикла;
	
	Элементы.СписокФайлов.Обновить();
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьРедактирование(Команда)
	Если Элементы.СписокФайлов.ТекущиеДанные <> Неопределено Тогда
		Ссылка = Элементы.СписокФайлов.ТекущиеДанные.Версия;
		ДанныеФайла = РаботаСФайламиВызовСервера.ПолучитьДанныеФайла(Неопределено, Ссылка);
		КомандыРаботыСФайламиКлиент.ЗакончитьРедактирование(ДанныеФайла.Ссылка, УникальныйИдентификатор);
		ЗаполнитьСписокФайлов();
		ЗаполнитьСписокФайловВФорме();
	КонецЕсли;
КонецПроцедуры
