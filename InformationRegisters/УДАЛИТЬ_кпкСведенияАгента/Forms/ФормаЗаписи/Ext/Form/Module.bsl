﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//Вставить содержимое обработчика
	
	РежимВыгрузкиКонтрагентов = Константы.кпкРежимВыгрузкиКонтрагентов.Получить();
	Элементы.Страницы.ПодчиненныеЭлементы.СписокДоговоров.Видимость = Ложь;
	Элементы.Страницы.ПодчиненныеЭлементы.СписокКонтрагентов.Видимость = Ложь;
	
	УстановитьЗначениеИдентификатора();
	
	Если РежимВыгрузкиКонтрагентов = 1 или РежимВыгрузкиКонтрагентов = 4 Тогда // Выгрузка клиентов по договорам
		
		Элементы.Страницы.ПодчиненныеЭлементы.СписокДоговоров.Видимость = Истина;
		
		ТекстЗапроса = "ВЫБРАТЬ
		|	кпкДоговораАгентов.Договор.Владелец КАК Контрагент,
		|	кпкДоговораАгентов.Договор
		|ИЗ
		|	Справочник.кпкДоговораАгентов КАК кпкДоговораАгентов
		|ГДЕ
		|	кпкДоговораАгентов.Владелец = &Агент
		|УПОРЯДОЧИТЬ ПО
		|	кпкДоговораАгентов.Договор.Владелец.Наименование
		|ИТОГИ ПО
		|	Контрагент";
		
		//ЗагрузитьДеревоДоговоров(ТекстЗапроса);
		
	ИначеЕсли РежимВыгрузкиКонтрагентов = 2 Тогда // По списку контрагентов
		
		Элементы.Страницы.ПодчиненныеЭлементы.СписокКонтрагентов.Видимость = Истина;
		
		ТабКонтрагентов = РегистрыСведений.кпкСведенияАгента.Получить(Новый Структура("Объект", Запись.Объект)).СписокКонтрагентов.Получить();
		
		Если Не ТабКонтрагентов = Неопределено Тогда
			Для Каждого ТекСтрока Из ТабКонтрагентов Цикл
				НоваяСтрока 		   = ТаблицаКонтрагентов.Добавить();
				НоваяСтрока.Контрагент = ТекСтрока.Контрагент;			
			КонецЦикла;
		КонецЕсли; 
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныеНастройки(Команда)
	
	Если НЕ ЗначениеЗаполнено(Запись.Объект) Тогда
    	Предупреждение("Не выбран агент",10);
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
    	Предупреждение("Сведения агента не записаны.",10);
		Возврат;
	КонецЕсли;
	
	СтруктураДополнительныеНастройки = Новый Структура;
	СтруктураДополнительныеНастройки.Вставить("Агент",Запись.Объект);
	
	ФормаДопНастроек  = ПолучитьФорму("Обработка.кпкНастройкаАгентПлюс.Форма", СтруктураДополнительныеНастройки);

	ФормаДопНастроек.Открыть();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Хранилище = Новый ХранилищеЗначения(ТаблицаКонтрагентов.Выгрузить());
	ТекущийОбъект.СписокКонтрагентов = Хранилище;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьЗначениеИдентификатора()
	
	Если ЗначениеЗаполнено(Запись.КПК.Идентификатор) Тогда
		ЗначениеИдентификатора = Запись.КПК.Идентификатор;
	Иначе
		ЗначениеИдентификатора = "<Идентификатор не указан>";		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КПКПриИзменении(Элемент)
	
	УстановитьЗначениеИдентификатора();	
	
КонецПроцедуры

&НаКлиенте
Процедура ПодборКонтрагентов(Команда)
	
	ВладелецФормы = Элементы.ТаблицаКонтрагентов;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимВыбора", Истина);
	ПараметрыФормы.Вставить("ЗакрыватьПриВыборе", Ложь);
	
	ОткрытьФормуМодально("Справочник.Контрагенты.ФормаВыбора", ПараметрыФормы, ВладелецФормы);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьКонтрагентов(Команда)
	
	Если ТаблицаКонтрагентов.Количество() > 0 Тогда
		Ответ = Вопрос("Таблица контрагентов будет полностью очищена. Вы хотите продолжить?", РежимДиалогаВопрос.ДаНет, 10);
		Если Ответ = КодВозвратаДиалога.Да Тогда
			ТаблицаКонтрагентов.Очистить();	
			Модифицированность = Истина;
		КонецЕсли;
	КонецЕсли; 	
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаКонтрагентовОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;

	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.Контрагенты") Тогда
		
		Если ТаблицаКонтрагентов.НайтиСтроки(Новый Структура("Контрагент", ВыбранноеЗначение)).Количество() = 0 Тогда
			СтрокаТаблицаКонтрагентов = ТаблицаКонтрагентов.Добавить();
			СтрокаТаблицаКонтрагентов.Контрагент = ВыбранноеЗначение;	
			Модифицированность = Истина;
		Иначе
			Предупреждение(НСтр("ru = 'Контрагент уже присутствует в списке'"));
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаКонтрагентовПриИзменении(Элемент)
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура КПКОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
	
КонецПроцедуры
