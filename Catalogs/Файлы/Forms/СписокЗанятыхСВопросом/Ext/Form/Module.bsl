﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СообщениеВопрос = Параметры.СообщениеВопрос;
	СообщениеЗаголовок = Параметры.СообщениеЗаголовок;
	Заголовок = Параметры.Заголовок;
	
	Если ЗначениеЗаполнено(Параметры.ВладелецФайла) Тогда 
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			СписокФайлов.Отбор, "ВладелецФайла", Параметры.ВладелецФайла);
	КонецЕсли;
		
	Если ЗначениеЗаполнено(Параметры.Редактирует) Тогда 
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
			СписокФайлов.Отбор, "Редактирует", Параметры.Редактирует);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	РаботаСФайламиКлиент.ОткрытьФайл(
		РаботаСФайламиВызовСервера.ПолучитьДанныеФайлаДляОткрытия(ВыбраннаяСтрока, Неопределено, УникальныйИдентификатор)); 
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗаконченоРедактирование" Тогда
		Элементы.Список.Обновить(); 
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьРедактирование(Команда)
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	РедактируетТекущийПользователь = Истина;	
	КомандыРаботыСФайламиКлиент.ЗакончитьРедактирование(
		Элементы.Список.ТекущаяСтрока,
		УникальныйИдентификатор,
		Элементы.Список.ТекущиеДанные.ХранитьВерсии,
		РедактируетТекущийПользователь,
		Элементы.Список.ТекущиеДанные.Редактирует);
		
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФайл(Команда)
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ПолучитьДанныеФайлаДляОткрытия(Элементы.Список.ТекущаяСтрока, Неопределено, УникальныйИдентификатор);
	КомандыРаботыСФайламиКлиент.Открыть(ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура Освободить(Команда)
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	РедактируетТекущийПользователь = Истина;
	КомандыРаботыСФайламиКлиент.ОсвободитьФайл(
		Элементы.Список.ТекущаяСтрока,
		Элементы.Список.ТекущиеДанные.ХранитьВерсии,
		РедактируетТекущийПользователь,
		Элементы.Список.ТекущиеДанные.Редактирует);
		
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИзменения(Команда)
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	КомандыРаботыСФайламиКлиент.ОпубликоватьФайл(
		Элементы.Список.ТекущаяСтрока, 
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКаталогФайла(Команда)
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ПолучитьДанныеФайлаДляОткрытия(
		Элементы.Список.ТекущаяСтрока, Неопределено, УникальныйИдентификатор);
	
	КомандыРаботыСФайламиКлиент.ОткрытьКаталогФайла(ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ПолучитьДанныеФайлаДляСохранения(
		Элементы.Список.ТекущаяСтрока, 
		Неопределено, 
		УникальныйИдентификатор);
	
	КомандыРаботыСФайламиКлиент.СохранитьКак(ДанныеФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИзФайлаНаДиске(Команда)
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиВызовСервера.ПолучитьДанныеФайлаИРабочийКаталог(Элементы.Список.ТекущаяСтрока);
	КомандыРаботыСФайламиКлиент.ОбновитьИзФайлаНаДиске(ДанныеФайла, УникальныйИдентификатор);
КонецПроцедуры
