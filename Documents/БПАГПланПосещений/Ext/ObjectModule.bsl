﻿
#Область ОбработчикиСобытий

Процедура ПередЗаписью(отказ, режимЗаписи, режимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Подразделение.Пустая() Тогда
		
		ТекстСообщения = НСтр("ru = 'Запись невозможна без заполнения Подразделения.'");
		ПроверкаДанныхКлиентСервер.СообщитьОбОшибке(отказ, текстСообщения, ЭтотОбъект, "Подразделение");
		
	КонецЕсли;

КонецПроцедуры

Процедура ПриКопировании(объектКопирования)
	
	ЗаполнениеОбъектовСервер.ЗаполнитьДанныеСкопированногоДокумента(ЭтотОбъект, объектКопирования);
	
КонецПроцедуры

Процедура ОбработкаПроведения(отказ, режимПроведения)
	
	Движения.ГрафикиПосещенийТорговымиПредставителями.Записывать = Истина;
	
	запрос = Новый Запрос;
	
	#Область ТекстЗапроса
	
	запрос.Текст =
	"ВЫБРАТЬ
	|	БПАГПланПосещенийДни.Ссылка.Дата КАК Период,
	|	БПАГПланПосещенийДни.Ссылка.Подразделение,
	|	БПАГПланПосещенийДни.Ссылка.Агент.Менеджер КАК ТорговыйПредставитель,
	|	БПАГПланПосещенийДни.Контрагент КАК ТорговаяТочка,
	|	ВЫБОР
	|		КОГДА БПАГПланПосещенийДни.Д1 = 1
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Д1,
	|	ВЫБОР
	|		КОГДА БПАГПланПосещенийДни.Д2 = 1
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Д2,
	|	ВЫБОР
	|		КОГДА БПАГПланПосещенийДни.Д3 = 1
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Д3,
	|	ВЫБОР
	|		КОГДА БПАГПланПосещенийДни.Д4 = 1
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Д4,
	|	ВЫБОР
	|		КОГДА БПАГПланПосещенийДни.Д5 = 1
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Д5,
	|	ВЫБОР
	|		КОГДА БПАГПланПосещенийДни.Д6 = 1
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Д6,
	|	ВЫБОР
	|		КОГДА БПАГПланПосещенийДни.Д7 = 1
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Д7,
	|	ИСТИНА КАК Актуально
	|ИЗ
	|	Документ.БПАГПланПосещений.Дни КАК БПАГПланПосещенийДни
	|ГДЕ
	|	БПАГПланПосещенийДни.Ссылка = &Ссылка";
	
	#КонецОбласти
	
	запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Движения.ГрафикиПосещенийТорговымиПредставителями.Загрузить(запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(отказ, проверяемыеРеквизиты)
	
	проверяемыеРеквизиты.Добавить("Дни.Контрагент");
	
	ОбработкаТабличныхЧастейСервер.ПроверитьДублиСтрокТабличнойЧасти(отказ, ЭтотОбъект, "Дни", Новый Структура("Контрагент", "Контрагент"));

КонецПроцедуры

#КонецОбласти