﻿#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(отказ, стандартнаяОбработка)
	
	Элементы.Менеджер.СписокВыбора.ЗагрузитьЗначения(ПолучитьСписокВыбораМенеджераНаСервере());
	
	КаталогОбмена = БПАГ.БПАГПолучитьНастройку("1СКаталогОбмена");
	
	Если Не Объект.Ссылка.Пустая() Тогда
	
		HTMLПросмотр = БПАГ.ПолучитьHTMLМерчандайзинга(Объект.Ссылка, каталогОбмена);
	
	КонецЕсли;
	
	
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	Элементы.Менеджер.СписокВыбора.ЗагрузитьЗначения(ПолучитьСписокВыбораМенеджераНаСервере());
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоСтандарту(Команда)
	ЗаполнитьПоСтандартуНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПолеПросмотрПриНажатии(элемент, данныеСобытия, стандартнаяОбработка)
	
	Если Не Объект.Ссылка.Пустая() Тогда
		
		Попытка
			файлКартинки = данныеСобытия.Element.href;
			кодТовара = данныеСобытия.Element.alt;
		Исключение
			Возврат;
		КонецПопытки;
		
		Если Лев(файлКартинки, СтрДлина("file://")) = "file://" Тогда
			
			файлКартинки = Сред(файлКартинки, СтрДлина("file://") + 1);
			
			массивФото = БПАГ.ПолучитьМассивКартинокМерчандайзинга(Объект.Ссылка, КодТовара, КаталогОбмена);
			
			структураПараметров = Новый Структура;
			структураПараметров.Вставить("ТекущееФото", файлКартинки);
			структураПараметров.Вставить("МассивФото", массивФото);
			структураПараметров.Вставить("ЗаголовокГалереи", БПАГ.ПолучитьЗаголовокГалереиКартинок(кодТовара));

			ОткрытьФорму("ОбщаяФорма.БПАГФормаПросмотраКартинок", структураПараметров);
			
		КонецЕсли;
		
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти 

#Область ДействияКоманд

&НаКлиенте
Процедура КомандаОткрытьПодборПоСтандарту(Команда)
	ОткрытьПодборНоменклатуры(Элементы.СоставНоменклатура);
КонецПроцедуры	

#КонецОбласти 

#Область ДополнительныеПроцедурыИФункции

&НаСервере
Функция ПолучитьСписокВыбораМенеджераНаСервере()
	
	результат = Новый Массив;
	
	Если Объект.КД_ТорговаяТочка.Пустая() Тогда
		
		результат.Добавить(Справочники.Менеджеры.БезМенеджера);
		Возврат результат;
	Иначе
		Возврат Объект.КД_ТорговаяТочка.ПолучитьОбъект().ПолучитьСписокМенеджеров();
	КонецЕсли;
	
КонецФункции	// ПолучитьСписокВыбораМенеджераНаСервере()

&НаСервере
Процедура ЗаполнитьПоСтандартуНаСервере()
	
	Если Объект.Контрагент.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.Подразделение.Пустая() Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	запрос = Новый Запрос;
	
	#Область ТекстЗапроса
	
	запрос.Текст =
	"";
		
	#КонецОбласти 
	
	запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
	запрос.УстановитьПараметр("ТорговаяТочка", Объект.КД_ТорговаяТочка);
	запрос.УстановитьПараметр("ГруппаПродукта", Объект.КД_ГруппаПродукта);
	
	результатЗапроса = запрос.Выполнить();
	
	Объект.Состав.Загрузить(результатЗапроса.Выгрузить());
	
КонецПроцедуры

#КонецОбласти

#Область ПодборИПеретаскивание

// Открывает подбор номенклатуры в табличную часть документа.
//
// Параметры
//  ПолеТаблицы  - ПолеФормы - Поле таблицы формы, содержащее данные, получаемые подбором.
//
&НаКлиенте
Процедура ОткрытьПодборНоменклатуры(полеТаблицы)

	параметрыПодбора = Новый Структура;
	параметрыПодбора.Вставить("ИмяФормы", "ОбщаяФорма.ФормаПодбораНоменклатурыСтандартПрисутствия");
	параметрыПодбора.Вставить("ПолеТаблицы", полеТаблицы);
	
	дополнительныеПараметрыФормы = Новый Структура;
	дополнительныеПараметрыФормы.Вставить("Контрагент", Объект.КД_ТорговаяТочка);
	дополнительныеПараметрыФормы.Вставить("ГруппаПродукта", Объект.КД_ГруппаПродукта);
	дополнительныеПараметрыФормы.Вставить("ДатаСтандарта", Объект.Дата);
	дополнительныеПараметрыФормы.Вставить("Подразделение", Объект.Подразделение);
	
	параметрыПодбора.Вставить("ДополнительныеПараметрыФормы", дополнительныеПараметрыФормы);
	
	ПодборИПеретаскивание.ОткрытьПодбор(параметрыПодбора);

КонецПроцедуры // ОткрытьПодборНоменклатуры()


	
#КонецОбласти 