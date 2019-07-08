﻿Процедура ВключениеСМСИнформирования(Знач массивИнформационныхКарт) Экспорт
	
	запрос = Новый Запрос;
	
	#Область ТекстЗапроса
	
	запрос.Текст =
	"ВЫБРАТЬ
	|	ИнформационныеКарты.Ссылка,
	|	НЕ ИнформационныеКарты.СМС_Информирование КАК СМС_Информирование
	|ИЗ
	|	Справочник.ИнформационныеКарты КАК ИнформационныеКарты
	|ГДЕ
	|	ИнформационныеКарты.Ссылка В(&МассивСсылок)
	|
	|ДЛЯ ИЗМЕНЕНИЯ
	|	Справочник.ИнформационныеКарты";
	
	#КонецОбласти
	
	запрос.УстановитьПараметр("МассивСсылок", массивИнформационныхКарт);
	
	НачатьТранзакцию();
	
	результатЗапроса = запрос.Выполнить();
	
	выборка = результатЗапроса.Выбрать();
	Пока выборка.Следующий() Цикл
		
		информационнаяКартаОбъект = выборка.Ссылка.ПолучитьОбъект();
		информационнаяКартаОбъект.СМС_Информирование = выборка.СМС_Информирование;
		
		информационнаяКартаОбъект.ОбменДанными.Загрузка = Истина;
		
		информационнаяКартаОбъект.Записать();
		
	КонецЦикла;
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры