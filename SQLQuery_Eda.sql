------Proyecto: Deteccion de Fraude en Tarjetas de Credito 

PROYECTO: Analisis y Deteccion de Anomalias Financieras
RUBRO: tecnologia financiera / Seguridad Financiera
OBJETIVO: Identificar patrones de riesgo en transacciones anonimizadas.

/*MISION DEL PROYECTO:
Transformar datos masivos de transacciones bancarias en informacion estructurada 
y accionable, permitiendo la deteccion temprana de anomalias financieras para 
minimizar el impacto economico del fraude y proteger al usuario.
*/

USE BD_BANCO;
GO
;
SELECT *
from CreditCard_Final

--  primeras 5 Preguntas Basicas


-- 1.Cual es el monto total de dinero movido en todas las transacciones?
-- 2.Cual es el promedio de gasto de un cliente en una transaccion normal (No Fraude)?
-- 3.Cual es el promedio de gasto cuando ocurre un fraude?
-- 4.Cuales fueron los 3 montos de fraude mas altos registrados? 
-- 5.Resumen de Seguridad_ Impacto del fraude vs transacciones normales

                               -----soluciones-------

-- 1.Cual es el monto total de dinero movido en todas las transacciones?

SELECT SUM(Amount) AS Volumen_Total_Dinero 
FROM CreditCard_Final;

-- 2.Cual es el promedio de gasto de un cliente en una transaccion normal (No Fraude)?

SELECT AVG(Amount) AS Promedio_Transaccion_Normal 
FROM CreditCard_Final 
WHERE Class = '0';

-- 3.Cual es el promedio de gasto cuando ocurre un fraude?

SELECT AVG(Amount) AS Promedio_Transaccion_Fraude 
FROM CreditCard_Final 
WHERE Class = 1;

-- 4.Cuales fueron los 3 montos de fraude mas altos registrados

SELECT TOP 3 
Time,Amount AS Monto_Fraude_Alto, Class
FROM CreditCard_Final 
WHERE Class = 1
ORDER BY Amount DESC;

-- 5.Impacto del fraude vs transacciones normales

SELECT Class,COUNT(*) AS Total_Transacciones,
SUM(Amount) AS Dinero_Total,
AVG(Amount) AS Gasto_Promedio
FROM CreditCard_Final 
GROUP BY Class;

        --------- BLOQUE 2: ANALISIS INTERMEDIO - TEMPORALIDAD Y COMPORTAMIENTO------------

-- 6. En que momento del dia (segundos) se concentra la mayor cantidad de fraude? 
-- 7. Cual es el monto maximo robado en una sola transaccion durante la "Hora Pico" de fraude?
-- 8. Existe diferencia significativa entre el monto minimo de un fraude vs una transaccion normal?
-- 9. Cuantos fraudes superan el promedio de gasto normal "88.29"?
--    Cuanto dinero representan esos montos de fraudes de alto impacto?
-- 10.Cual es el porcentaje de dinero perdido por fraude respecto al volumen total movido?

                               -----soluciones-------

-- 6. En que momento del dia (segundos) se concentra la mayor cantidad de fraude? 
--    1ero_Agrupamos por rangos de 1 hora aprox: 3600 segundos

SELECT (Time / 3600) AS Hora_Del_Dia, COUNT(*) AS Cantidad_Fraudes
FROM CreditCard_Final 
WHERE Class = 1
GROUP BY (Time / 3600)
ORDER BY Cantidad_Fraudes DESC;

-- 7. Cual es el monto maximo robado en una sola transaccion durante la "Hora Pico" de fraude?

SELECT FLOOR(Time / 3600) AS Hora_Exacta, 
COUNT(*) AS Total_Fraudes,
MAX(Amount) AS Robo_Mas_Caro_De_Esta_Hora
FROM CreditCard_Final
WHERE Class = 1
GROUP BY FLOOR(Time / 3600)
ORDER BY Total_Fraudes DESC;

-- 8. Existe diferencia significativa entre el monto minimo de un fraude vs una transaccion normal?

SELECT Class, MIN(Amount) AS Monto_Minimo_Real
FROM CreditCard_Final
WHERE Amount > 0  -- Esto quita las verificaciones de $0
GROUP BY Class;

-- 9. Cuantos fraudes superan el promedio de gasto normal "88.29"?

SELECT COUNT(*) AS Fraudes_De_Alto_Impacto
FROM CreditCard_Final
WHERE Class = 1 AND Amount > 88.29;
--Cuanto dinero representan esos montos de fraudes de alto impacto?
SELECT SUM(Amount) AS Perdida_Total_Alto_Impacto
FROM CreditCard_Final
WHERE Class = 1 AND Amount > 88.29;

-- 10.Cual es el porcentaje de dinero perdido por fraude respecto al volumen total movido?

SELECT (SUM(CASE WHEN Class = 1 
THEN Amount ELSE 0 END) / SUM(Amount)) * 100 AS Porcentaje_Perdida_Economica
FROM CreditCard_Final;

       ----------- BLOQUE 3: NIVEL AVANZADO - PATRONES Y CONCENTRACIoN------------

-- 11. Cual es la perdida total de dinero por fraude comparada con el total de dinero procesado?
-- 12. Existen fraudes con montos de "Cero" y cuantos son respecto al total de fraudes?

                               -----soluciones-------

-- 11. Cual es la perdida total de dinero por fraude comparada con el total de dinero procesado?

SELECT 
SUM(CASE WHEN Class = 1 THEN Amount ELSE 0 END) AS Perdida_Total_Fraude,
SUM(CASE WHEN Class = 0 THEN Amount ELSE 0 END) AS Volumen_Normal_Total
FROM CreditCard_Final;

-- 12. Existen fraudes con montos de "Cero" y cuantos son respecto al total de fraudes?

SELECT 
    COUNT(*) AS Cantidad_Fraudes_Cero
FROM CreditCard_Final 
WHERE Class = 1 AND Amount = 0;

