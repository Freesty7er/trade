﻿
&НаКлиенте
Процедура ОбработкаКоманды(параметрКоманды, параметрыВыполненияКоманды)

	датаОкончанияСкидок = ТекущаяДата();
	подсказка = "Введите дату окончания скидок";
	частьДаты = ЧастиДаты.Дата;
	
	Если ВвестиДату(датаОкончанияСкидок, подсказка, частьДаты) Тогда
		
		УстановитьДатуОкончанияСкидокНаСервере(датаОкончанияСкидок, параметрКоманды);
		
	КонецЕсли;
			
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДатуОкончанияСкидокНаСервере(датаОкончанияСкидок, массивСсылок)
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	
	запрос = Новый Запрос;
	
	#Область ТекстЗапроса
	
	запрос.Текст =
	"ВЫБРАТЬ
	|	АвтоматическиеСкидки.Ссылка
	|ИЗ
	|	Справочник.АвтоматическиеСкидки КАК АвтоматическиеСкидки
	|ГДЕ
	|	АвтоматическиеСкидки.Ссылка В(&МассивСсылок)
	|	И АвтоматическиеСкидки.ДатаОкончанияДействияСкидки <> &ДатаОкончанияДействияСкидки
	|
	|ДЛЯ ИЗМЕНЕНИЯ
	|	Справочник.АвтоматическиеСкидки";
	
	#КонецОбласти
	
	запрос.УстановитьПараметр("МассивСсылок", массивСсылок);
	запрос.УстановитьПараметр("ДатаОкончанияДействияСкидки", датаОкончанияСкидок);
	
	выборка = запрос.Выполнить().Выбрать();
	Пока выборка.Следующий() Цикл
		
		обАвтоматическаяСкидка = выборка.Ссылка.ПолучитьОбъект();
		
		обАвтоматическаяСкидка.ДатаОкончанияДействияСкидки = датаОкончанияСкидок;
		обАвтоматическаяСкидка.ОбменДанными.Загрузка = Истина;
		обАвтоматическаяСкидка.Записать();
		
	КонецЦикла;
	
	ЗафиксироватьТранзакцию();
	
	
Конецпроцедуры
