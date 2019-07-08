﻿&НаСервере
Функция ВыполнитьРегистрациюИзмененийВПланеОбмена(массивДокументов)
	
	результат = 0;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Для индекс=1 По массивДокументов.Количество() Цикл
		
		источник = массивДокументов[индекс-1].Ссылка;
		
		Если ТипЗнч(источник) = Тип("ДокументСсылка.КпкЗаявка") Тогда
			
			Если источник.Проведен Тогда
				
				узел = ПланыОбмена.ОбменСМуравьинойЛогистикой.НайтиПоРеквизиту("Подразделение", источник.Подразделение);
				
				// регистрация с заполненным маршрутом выполняется только в режиме отладки
				// ИнтервалВыгрузки = -1, означает что выгрузка отключена
				Если  (ЗначениеЗаполнено(источник.МаршрутРазвоза) И Не узел.РежимОтладки И Не источник.МаршрутРазвоза = Справочники.МаршрутыРазвоза.ПустойМаршрут) Или узел.Пустая() Или узел.ИнтервалВыгрузки = -1 Тогда
					Продолжить;
				КонецЕсли;
				
				
				ПланыОбмена.ЗарегистрироватьИзменения(узел, источник);
				
				результат = результат + 1;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат результат;
	
КонецФункции	// ВыполнитьРегистрациюИзмененийВПланеОбмена()

&НаКлиенте
Процедура ОбработкаКоманды(параметрКоманды, параметрыВыполненияКоманды)
	
	Если ТипЗнч(параметрКоманды) = Тип("Массив") Тогда
		
		результат = ВыполнитьРегистрациюИзмененийВПланеОбмена(параметрКоманды);
		
		ПоказатьПредупреждение(, СтрШаблон("Зарегистрировано %1 объектов", результат));
		
	КонецЕсли;

КонецПроцедуры

