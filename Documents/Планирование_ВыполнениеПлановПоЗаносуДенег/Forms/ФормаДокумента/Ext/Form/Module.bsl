﻿
#Область КомандыФормы

&НаКлиенте
Процедура КомандаРасчитать(команда)
	КомандаРасчитатьНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ПрочиеПроцедурыИФункции

&НаСервере
Процедура КомандаРасчитатьНаСервере()
	
	запрос = Новый Запрос;
	запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	#Область ТекстЗапроса
	
	запрос.Текст =
	"ВЫБРАТЬ
	|	Планирование_УстановкаПлановПоЗаносуДенегСостав.Менеджер,
	|	СРЕДНЕЕ(Планирование_УстановкаПлановПоЗаносуДенегСостав.План) КАК План
	|ПОМЕСТИТЬ ВТ_Планирование
	|ИЗ
	|	Документ.Планирование_УстановкаПлановПоЗаносуДенег.Состав КАК Планирование_УстановкаПлановПоЗаносуДенегСостав
	|ГДЕ
	|	Планирование_УстановкаПлановПоЗаносуДенегСостав.Ссылка = &СсылкаПланирование
	|
	|СГРУППИРОВАТЬ ПО
	|	Планирование_УстановкаПлановПоЗаносуДенегСостав.Менеджер
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ШкалыОценкиПорогиЗначений.Порог КАК ПорогНачало,
	|	МИНИМУМ(ШкалыОценкиПорогиЗначений1.Порог) КАК ПорогОкончание,
	|	СРЕДНЕЕ(ШкалыОценкиПорогиЗначений.Значение) КАК Значение
	|ПОМЕСТИТЬ ВТ_ШкалаОценки
	|ИЗ
	|	Справочник.ШкалыОценки.ПорогиЗначений КАК ШкалыОценкиПорогиЗначений
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ШкалыОценки.ПорогиЗначений КАК ШкалыОценкиПорогиЗначений1
	|		ПО ШкалыОценкиПорогиЗначений.Порог < ШкалыОценкиПорогиЗначений1.Порог
	|ГДЕ
	|	ШкалыОценкиПорогиЗначений.Ссылка = &СсылкаШкалаОценки
	|	И ШкалыОценкиПорогиЗначений1.Ссылка = &СсылкаШкалаОценки
	|
	|СГРУППИРОВАТЬ ПО
	|	ШкалыОценкиПорогиЗначений.Порог
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ПорогНачало,
	|	ПорогОкончание
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Планирование_ВыполнениеПлановПоЗаносуДенегБазыРасчетаЗарплаты.Менеджер КАК Менеджер,
	|	Планирование_ВыполнениеПлановПоЗаносуДенегБазыРасчетаЗарплаты.Сотрудник,
	|	Планирование_ВыполнениеПлановПоЗаносуДенегБазыРасчетаЗарплаты.БазаРасчета,
	|	Планирование_ВыполнениеПлановПоЗаносуДенегБазыРасчетаЗарплаты.Ссылка.Подразделение,
	|	Планирование_ВыполнениеПлановПоЗаносуДенегБазыРасчетаЗарплаты.Ссылка.ПоказательКПИ
	|ПОМЕСТИТЬ ВТ_БазыРасчетаЗарплаты
	|ИЗ
	|	Документ.Планирование_ВыполнениеПлановПоЗаносуДенег.БазыРасчетаЗарплаты КАК Планирование_ВыполнениеПлановПоЗаносуДенегБазыРасчетаЗарплаты
	|ГДЕ
	|	Планирование_ВыполнениеПлановПоЗаносуДенегБазыРасчетаЗарплаты.Ссылка = &Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Менеджер
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Планирование_ВыполнениеПлановПоЗаносуДенегИсходныеДанные.Менеджер,
	|	СРЕДНЕЕ(Планирование_ВыполнениеПлановПоЗаносуДенегИсходныеДанные.Факт) КАК Показатель
	|ПОМЕСТИТЬ ВТ_СгруппированныеИсходныеДанные
	|ИЗ
	|	Документ.Планирование_ВыполнениеПлановПоЗаносуДенег.ИсходныеДанные КАК Планирование_ВыполнениеПлановПоЗаносуДенегИсходныеДанные
	|ГДЕ
	|	Планирование_ВыполнениеПлановПоЗаносуДенегИсходныеДанные.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	Планирование_ВыполнениеПлановПоЗаносуДенегИсходныеДанные.Менеджер
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_СгруппированныеИсходныеДанные.Менеджер,
	|	ВТ_СгруппированныеИсходныеДанные.Показатель,
	|	ВТ_СгруппированныеИсходныеДанные.Показатель КАК Выполнение
	|ПОМЕСТИТЬ ВТ_Выполнение
	|ИЗ
	|	ВТ_СгруппированныеИсходныеДанные КАК ВТ_СгруппированныеИсходныеДанные
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Выполнение.Менеджер,
	|	ВТ_Выполнение.Показатель,
	|	ВТ_Выполнение.Выполнение,
	|	ВЫБОР
	|		КОГДА ВТ_Выполнение.Выполнение > 100
	|				И ВТ_Выполнение.Выполнение < 120
	|			ТОГДА ВТ_Выполнение.Выполнение / 100
	|		ИНАЧЕ ВТ_ШкалаОценки.Значение
	|	КОНЕЦ КАК ЗначениеОценки
	|ПОМЕСТИТЬ ВТ_АнализВыполнения
	|ИЗ
	|	ВТ_Выполнение КАК ВТ_Выполнение
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ШкалаОценки КАК ВТ_ШкалаОценки
	|		ПО ВТ_Выполнение.Выполнение >= ВТ_ШкалаОценки.ПорогНачало
	|			И ВТ_Выполнение.Выполнение < ВТ_ШкалаОценки.ПорогОкончание
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_БазыРасчетаЗарплаты.Сотрудник,
	|	СоответствиеПоказательКПИВидРасчетаСрезПоследних.ВидРасчета,
	|	СУММА(ВТ_АнализВыполнения.Выполнение * ВТ_АнализВыполнения.ЗначениеОценки / 100) КАК Результат
	|ИЗ
	|	ВТ_АнализВыполнения КАК ВТ_АнализВыполнения
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_БазыРасчетаЗарплаты КАК ВТ_БазыРасчетаЗарплаты
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеПоказательКПИВидРасчета.СрезПоследних(&ДатаСреза, ) КАК СоответствиеПоказательКПИВидРасчетаСрезПоследних
	|			ПО ВТ_БазыРасчетаЗарплаты.Подразделение = СоответствиеПоказательКПИВидРасчетаСрезПоследних.Подразделение
	|				И ВТ_БазыРасчетаЗарплаты.ПоказательКПИ = СоответствиеПоказательКПИВидРасчетаСрезПоследних.ПоказательКПИ
	|		ПО ВТ_АнализВыполнения.Менеджер = ВТ_БазыРасчетаЗарплаты.Менеджер
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_БазыРасчетаЗарплаты.Сотрудник,
	|	СоответствиеПоказательКПИВидРасчетаСрезПоследних.ВидРасчета
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_АнализВыполнения.Менеджер,
	|	ВТ_АнализВыполнения.Показатель,
	|	ВТ_АнализВыполнения.Выполнение,
	|	ВТ_АнализВыполнения.ЗначениеОценки
	|ИЗ
	|	ВТ_АнализВыполнения КАК ВТ_АнализВыполнения";
	
	#КонецОбласти
	
	запрос.УстановитьПараметр("ДатаСреза", Объект.Дата);
	запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	запрос.УстановитьПараметр("СсылкаПланирование", Объект.ДокументОснование);
	запрос.УстановитьПараметр("СсылкаШкалаОценки", Объект.ШкалаОценкиПоказателяКПИ);
	
	результатЗапроса = запрос.ВыполнитьПакет();
	
	#Область ПолучениеВременныхТаблиц
	
	запрос.Текст =
	"ВЫБРАТЬ * ИЗ ВТ_Планирование;
	|ВЫБРАТЬ * ИЗ ВТ_ШкалаОценки;
	|ВЫБРАТЬ * ИЗ ВТ_БазыРасчетаЗарплаты;
	|ВЫБРАТЬ * ИЗ ВТ_СгруппированныеИсходныеДанные;
	|ВЫБРАТЬ * ИЗ ВТ_Выполнение;
	|ВЫБРАТЬ * ИЗ ВТ_АнализВыполнения;";
	
	#КонецОбласти
	
	Объект.АнализВыполнения.Загрузить(результатЗапроса[7].Выгрузить());
	Объект.РасчетЗарплаты.Загрузить(результатЗапроса[6].Выгрузить());
	
КонецПроцедуры

#КонецОбласти