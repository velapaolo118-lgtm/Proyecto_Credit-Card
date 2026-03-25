CREATE TABLE CreditCardTransactions (
    [Time] VARCHAR(100),
    V1 VARCHAR(100),
    V2 VARCHAR(100),
    V3 VARCHAR(100),
    V4 VARCHAR(100),
    V5 VARCHAR(100),
    V6 VARCHAR(100),
    V7 VARCHAR(100),
    V8 VARCHAR(100),
    V9 VARCHAR(100),
    V10 VARCHAR(100),
    V11 VARCHAR(100),
    V12 VARCHAR(100),
    V13 VARCHAR(100),
    V14 VARCHAR(100),
    V15 VARCHAR(100),
    V16 VARCHAR(100),
    V17 VARCHAR(100),
    V18 VARCHAR(100),
    V19 VARCHAR(100),
    V20 VARCHAR(100),
    V21 VARCHAR(100),
    V22 VARCHAR(100),
    V23 VARCHAR(100),
    V24 VARCHAR(100),
    V25 VARCHAR(100),
    V26 VARCHAR(100),
    V27 VARCHAR(100),
    V28 VARCHAR(100),
    Amount VARCHAR(100),
    Class VARCHAR(100)
);
GO


BULK INSERT CreditCardTransactions
FROM 'C:\VISUAL E.C\base.DATA\creditcard.csv' -- <-- Cambia esto por tu ruta real
WITH (
    FORMAT = 'CSV',
    FIRSTROW = 2,           -- Omitimos la fila de encabezados
    FIELDTERMINATOR = ',',  -- Coma como separador
    ROWTERMINATOR = '\n',   -- Salto de línea estándar
   ----- ENCODING = 'UTF-8',     -- Evita problemas con caracteres especiales
    TABLOCK                 -- Optimiza la carga bloqueando la tabla
);