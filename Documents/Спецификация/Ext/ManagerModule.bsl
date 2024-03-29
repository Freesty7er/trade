﻿
Функция ПечатьСпецификацияТабличныйДокумент(массивОбъектов, объектыПечати, имяМакета, коллекцияПечатныхФорм)
	
	табличныйДокумент = Новый ТабличныйДокумент;
	
	табличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_Спецификация";
	
	запрос = Новый Запрос;
	
	#Область ТекстЗапроса
	
	запрос.Текст = 
	"ВЫБРАТЬ
	|	МАКСИМУМ(ШтрихкодыНоменклатуры.Штрихкод) КАК Штрихкод,
	|	ШтрихкодыНоменклатуры.Номенклатура
	|ПОМЕСТИТЬ вт_НоменклатураШтрихКоды
	|ИЗ
	|	РегистрСведений.ШтрихкодыНоменклатуры КАК ШтрихкодыНоменклатуры
	|ГДЕ
	|	ШтрихкодыНоменклатуры.Номенклатура В
	|			(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|				СпецификацияСостав.Номенклатура
	|			ИЗ
	|				Документ.Спецификация.Состав КАК СпецификацияСостав
	|			ГДЕ
	|				СпецификацияСостав.Ссылка = &Спецификация)
	|
	|СГРУППИРОВАТЬ ПО
	|	ШтрихкодыНоменклатуры.Номенклатура
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СпецификацияСостав.Ссылка.Организация.ПолнНаименование КАК Поставщик,
	|	СпецификацияСостав.Ссылка.Договор,
	|	СпецификацияСостав.Ссылка КАК Спецификация,
	|	СпецификацияСостав.Номенклатура.БухгалтерскийКод КАК Код,
	|	НЕОПРЕДЕЛЕНО КАК ТорговаяМарка,
	|	СпецификацияСостав.Номенклатура.Родитель.Поставщик КАК Производитель,
	|	СпецификацияСостав.Номенклатура.СрокХранения КАК СрокХранения,
	|	СпецификацияСостав.Номенклатура.ПолнНаим КАК Наименование,
	|	вт_НоменклатураШтрихКоды.Штрихкод,
	|	СпецификацияСостав.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	СпецификацияСостав.Номенклатура.Вес КАК ВесЕдиницы,
	|	СпецификацияСостав.Номенклатура.БПАГКратностьУпаковки КАК КоличествоВУпаковке,
	|	СпецификацияСостав.Цена
	|ИЗ
	|	Документ.Спецификация.Состав КАК СпецификацияСостав
	|		ЛЕВОЕ СОЕДИНЕНИЕ вт_НоменклатураШтрихКоды КАК вт_НоменклатураШтрихКоды
	|		ПО СпецификацияСостав.Номенклатура = вт_НоменклатураШтрихКоды.Номенклатура
	|ГДЕ
	|	СпецификацияСостав.Ссылка = &Спецификация";
	
	#КонецОбласти
	
	запрос.УстановитьПараметр("Спецификация", массивОбъектов[0]);
	
	результат = запрос.Выполнить();
	
	Если Не результат.Пустой() Тогда
		
		шапкаЗаполнена = Ложь;
		подвалЗаполнен = Ложь;
		
		макет = ПолучитьМакет("Спецификация");
		
		областьШапка = макет.ПолучитьОбласть("шапка");
		
		областьПодвал = макет.ПолучитьОбласть("подвал");
		
		выборка = результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока выборка.Следующий() Цикл
			
			Если Не шапкаЗаполнена Тогда
				
				областьШапка.Параметры.ПоставщикШапка = выборка.Поставщик;
				областьШапка.Параметры.ДоговорПоставки = "к договору поставки №" + выборка.Договор.НомерДоговора + " от " + Формат(выборка.Договор.ДатаДоговора, "ДФ=dd.MM.yyyy") + " г.";
				областьШапка.Параметры.СпецификацияДата = "от " + Формат(выборка.Спецификация.Дата, "ДФ=dd.MM.yyy") + "г.";
				
				табличныйДокумент.Вывести(областьШапка);
				
				шапкаЗаполнена = Истина;
				
			КонецЕсли;
			
			Если Не подвалЗаполнен Тогда
				
				областьПодвал.Параметры.ПоставщикПодвал = "Поставщик:" + Символы.ПС + выборка.Поставщик;
				
				подвалЗаполнен = Истина;
				
			КонецЕсли;
			
			областьСтрока = макет.ПолучитьОбласть("строка");
			
			областьСтрока.Параметры.Заполнить(выборка);
			
			табличныйДокумент.Вывести(областьСтрока);
			
		КонецЦикла;
		
		табличныйДокумент.Вывести(областьПодвал);
		
	КонецЕсли;
	
	новыйПечатнаяФорма = КоллекцияПечатныхФорм.Получить(0);
	новыйПечатнаяФорма.ИмяМакета = "Спецификация";
	новыйПечатнаяФорма.ИмяВРЕГ = "СПЕЦИФИКАЦИЯ";
	новыйПечатнаяФорма.СинонимМакета = "Спецификация";
	новыйПечатнаяФорма.ТабличныйДокумент = табличныйДокумент;
	новыйПечатнаяФорма.Экземпляров = 1;
	
	Возврат табличныйДокумент;
	
КонецФункции

Процедура Печать(массивОбъектов, параметрыПечати, коллекцияПечатныхФорм, объектыПечати, параметрыВывода) Экспорт
	УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(коллекцияПечатныхФорм, "Спецификация", "Спецификация", ПечатьСпецификацияТабличныйДокумент(массивОбъектов, объектыПечати, "Спецификация", коллекцияПечатныхФорм));
КонецПроцедуры