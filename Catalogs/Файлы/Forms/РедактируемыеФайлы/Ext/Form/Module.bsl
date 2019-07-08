﻿
// Обработка события Выбор у списка 
//
&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	РаботаСФайламиКлиент.ОткрытьФайл(
		РаботаСФайламиВызовСервера.ПолучитьДанныеФайлаДляОткрытия(ВыбраннаяСтрока, Неопределено, УникальныйИдентификатор)); 
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Пользователь = ОбщегоНазначения.ТекущийПользователь();
	СписокФайлов.Параметры.УстановитьЗначениеПараметра("Редактирует", Пользователь);
	
	ПоказыватьКолонкуРазмер = РаботаСФайламиВызовСервера.ПолучитьПоказыватьКолонкуРазмер();
	Если ПоказыватьКолонкуРазмер = Ложь Тогда
		Элементы.ТекущаяВерсияРазмер.Видимость = Ложь;
	КонецЕсли;
				   
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
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
		Элементы.Список.ТекущиеДанные.Редактирует,
		Элементы.Список.ТекущиеДанные.Автор);
		
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

&НаКлиенте
Процедура УстановитьДоступностьКомманд(Доступность)
	Элементы.ЗакончитьРедактирование.Доступность = Доступность;
	Элементы.СписокКонтекстноеМеню.ПодчиненныеЭлементы.КонтекстноеМенюСписокЗакончитьРедактирование.Доступность = Доступность;
	
	Элементы.ОткрытьФайл.Доступность = Доступность;
	Элементы.СписокКонтекстноеМеню.ПодчиненныеЭлементы.КонтекстноеМенюСписокОткрытьФайл.Доступность = Доступность;
	
	Элементы.Изменить.Доступность = Доступность;
	
	Элементы.СписокКонтекстноеМеню.ПодчиненныеЭлементы.КонтекстноеМенюСписокСохранитьИзменения.Доступность = Доступность;
	Элементы.СписокКонтекстноеМеню.ПодчиненныеЭлементы.КонтекстноеМенюСписокОткрытьКаталогФайла.Доступность = Доступность;
	Элементы.СписокКонтекстноеМеню.ПодчиненныеЭлементы.КонтекстноеМенюСписокСохранитьКак.Доступность = Доступность;
	Элементы.СписокКонтекстноеМеню.ПодчиненныеЭлементы.КонтекстноеМенюСписокОсвободить.Доступность = Доступность;
	Элементы.СписокКонтекстноеМеню.ПодчиненныеЭлементы.КонтекстноеМенюСписокОбновитьИзФайлаНаДиске.Доступность = Доступность;
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда
		УстановитьДоступностьКомманд(Ложь);
	Иначе
		УстановитьДоступностьКомманд(Истина);
	КонецЕсли;	
	                                       	
КонецПроцедуры
