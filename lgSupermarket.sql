CREATE TABLE Suppliers (
    SupplierCode SERIAL PRIMARY KEY,
    CompanyName varchar(50),
    TimeStamp timestamp
);

ALTER SEQUENCE suppliers_suppliercode_seq RESTART WITH 1000;

CREATE TABLE SupplierAddress (
    SAddressId SERIAL PRIMARY KEY,
    SupplierCode int REFERENCES Suppliers(SupplierCode),
    SStreet varchar (50),
    SCity varchar(50),
    SCountry varchar(50)
);

CREATE TABLE SupplierContact (
    SContactID SERIAL PRIMARY KEY,
    SAddressId int REFERENCES SupplierAddress(SAddressId),
    ContactNumber varchar(15)
);

CREATE TABLE DeliveryTransaction (
    DTransactionId SERIAL PRIMARY KEY ,
    SupplierCode int REFERENCES Suppliers(SupplierCode),
    TimeStamp timestamp
);

CREATE TABLE Uom (
    UomId SERIAL PRIMARY KEY,
    Description varchar(50)
);

CREATE TABLE Item (
    ItemCode SERIAL PRIMARY KEY,
    ItemBarcode char(13),
    ItemDescription varchar(50),
    ItemPrice decimal(10,2)
);

ALTER SEQUENCE item_itemcode_seq RESTART WITH 2000;

CREATE TABLE ItemUom (
    UniqueID SERIAL PRIMARY KEY,
    ItemCode integer REFERENCES Item(itemcode),
    UomId integer REFERENCES  Uom(UomId)
);

CREATE TABLE Inventory (
    InventoryId SERIAL PRIMARY KEY,
    ItemCode integer REFERENCES Item(ItemCode),
    ItemUomId integer REFERENCES ItemUom(UniqueID),
    ItemStock integer
);

CREATE TABLE DeliveryLine (
    DLineId SERIAL PRIMARY KEY,
    DTransactionId int REFERENCES DeliveryTransaction(DTransactionId),
    InventoryId int REFERENCES Inventory(InventoryId),
    ItemCode int REFERENCES Item(ItemCode),
    DQty int,
    ItemCost decimal(10,2)
);

CREATE TABLE Customers (
    CustomerCode SERIAL PRIMARY KEY,
    FirstName varchar(50),
    LastName varchar(50),
    TimeStamp timestamp
);

ALTER SEQUENCE customers_customercode_seq RESTART WITH 3000;

CREATE TABLE CustomerAddress (
    CAddressId SERIAL PRIMARY KEY,
    CustomerCode int REFERENCES Customers(CustomerCode),
    CStreet varchar (50),
    CCity varchar(50),
    CCountry varchar(50)
);

CREATE TABLE CustomerContact (
    ContactID SERIAL PRIMARY KEY,
    CAddressId int REFERENCES CustomerAddress(CAddressId),
    CContactNumber varchar(15)
);

CREATE TABLE SalesTransaction (
    STransactionId SERIAL PRIMARY KEY ,
    CustomerCode int REFERENCES Customers(CustomerCode),
    TimeStamp timestamp
);

CREATE TABLE SalesLine (
    SLineId SERIAL PRIMARY KEY,
    STransactionId int REFERENCES SalesTransaction(STransactionId),
    InventoryId int REFERENCES Inventory(InventoryId),
    ItemCode int REFERENCES Item(ItemCode),
    SQty int,
    ItemPrice decimal(10,2)
);

ALTER TABLE SalesLine DROP COLUMN ItemPrice;

ALTER TABLE Item ADD COLUMN ItemPrice decimal(10,2);

SELECT * FROM Item;
INSERT INTO Uom (Description) VALUES ('PIECE'), ('PACK'), ('BOX'), ('BAG'), ('CAN'), ('FOOT'), ('JUG'), ('HEAD'), ('DRUM'), ('REAM');
INSERT INTO Item (ItemBarcode, ItemDescription, ItemPrice)
VALUES
    ('4800049720114', 'Natures Spring Drinking Water 500ML', 15.00), ('4808885197503', 'Jergens Ultra Healing 50ML', 67.00),
    ('4809015850503', 'Ethyl Alcohol Kahamis 500ML', 87.35), ('4800049720121', 'Natures Spring Drinking Water 1000ML', 25.00),
    ('0191001099988','Jergens Ultra Healing 500ML',368.20), ('8809707253014','Innisfree Jeju Life Perfumed Hand Cream 30ML',290.00),
    ('8809707258741','Eden Selected Red Wine Vinegar 473ml',264.45), ('0954124510001','Idahoan Loaded Baked Mashed Potatoes 113.4g',149.45),
    ('0954124510151','Idahoan Roasted Garlic Mashed Potatoes 113.4g', 149.45), ('0413310592750','Goya Organics Tri-Color Quinoa 340g', 459.95),
    ('4800361000239','Nestle Koko krunch Duo Banana 330g', 203.85);

INSERT INTO ItemUom (ItemCode, UomId)
VALUES (2000, 1), (2002, 1),(2001, 1),(2003, 1),(2004, 1),(2005, 1),(2006, 1),(2007, 2),(2008, 2),(2009, 3), (2010, 3);

INSERT INTO Inventory (ItemCode, ItemUomId, ItemStock)
VALUES
    (2000, 1, 50), (2002,2, 10), (2001, 3, 12), (2003, 4, 18), (2004, 5, 20),
    (2005, 6, 1),(2006, 7, 4), (2007, 8, 3), (2008, 9, 2), (2009, 10, 5), (2010, 11, 5);

INSERT INTO Suppliers (CompanyName, TimeStamp)
VALUES
    ('Iris Inc.', current_timestamp), ('Jihara Group', current_timestamp),
    ('Beybiko Inc', current_timestamp), ('Brivilas', current_timestamp), ('NeyFlix', current_timestamp), ('Desni', current_timestamp),
    ('Dia G', current_timestamp), ('Lampinig Corp.', current_timestamp), ('Bee Haynd', current_timestamp), ('Bak Dor', current_timestamp);

INSERT INTO SupplierAddress (SupplierCode, SStreet, SCity, SCountry)
VALUES (1000, 'Sampaguita St.', 'General Santos City', 'Philippines'),
    (1000, 'Quimpo Boulevard', 'Davao City', 'Philippines'),(1001,'Colon Street','Cebu City', 'Philippines'),
    (1002, 'Aparente Street', 'General Santos City', 'Philippines'), (1003, 'Bolton Street', 'Davao City', 'Philippines'),
    (1004, 'Sanciangko Street', 'Cebu City', 'Philippines'), (1005, 'Camia', 'General Santos City', 'Philippines'),
    (1006, 'Artiaga Street', 'Davao City', 'Philippines'), (1007, 'Magallanes Street', 'Cebu City', 'Philippines'),
    (1008, 'Aparente Street', 'General Santos City', 'Philippines'), (1009, 'Palma Gil Street', 'Davao City', 'Philippines');

INSERT INTO SupplierContact (SAddressId, ContactNumber)
VALUES
    (1, '835539193'), (2, '821554121'), (4, '+639189654123'), (5, '+639179865321'), (6, '+639178786632'),
    (7, '+630915632100'), (8, '+639156321564'), (9, '+639145632121'),(10, '+639778963215'),(11, '+639556321023');

INSERT INTO DeliveryTransaction (SupplierCode, TimeStamp)
VALUES
    (1000, current_timestamp), (1001, current_timestamp),
    (1002, current_timestamp), (1003, current_timestamp), (1004, current_timestamp), (1005, current_timestamp),
    (1006, current_timestamp), (1007, current_timestamp), (1008, current_timestamp), (1009, current_timestamp);

INSERT INTO DeliveryLine (DTransactionId, InventoryId, ItemCode, DQty, ItemCost)
VALUES
    (1, 5, 2000, 50, 10.00), (1, 6, 2002, 5, 82.35), (2, 5, 2002, 5, 82.35),
    (3, 7, 2001, 12, 62.00), (4, 8, 2003, 18, 20.00), (5, 9, 2004, 20, 363.20), (6, 10, 2005, 1, 285.00),
    (7, 11, 2006, 4, 259.45), (8, 12, 2007, 3, 144.45), (9, 13, 2008, 2, 144.45), (10, 14, 2009, 5, 454.95);

INSERT INTO Customers (FirstName, LastName, TimeStamp)
VALUES
    ('Ai', 'Jane', current_timestamp), ('Hara', 'Ji', current_timestamp), ('Jane', 'Innis', current_timestamp),
    ('Ris', 'Neja', current_timestamp), ('Ra', 'Jiha', current_timestamp), ('Elli', 'Fant', current_timestamp),
    ('Janine', 'Ortega', current_timestamp), ('Raja', 'Huhu', current_timestamp), ('Lady', 'Jaja', current_timestamp),
    ('Jeika', 'Soco', current_timestamp);

INSERT INTO CustomerAddress (CustomerCode, CStreet, CCity, CCountry)
VALUES
    (3000, 'Sampaguita Street', 'General Santos City', 'Philippines'), (3001, 'Yumang Street', 'General Santos City', 'Philippines'),
    (3002, 'J.Catolico Street', 'General Santos City', 'Philippines'),
    (3003, 'Dadiangas North', 'General Santos City', 'Philippines'), (3004, 'Yumang Street', 'General Santos City', 'Philippines'),
    (3005, 'Leon Llido Street', 'General Santos City', 'Philippines'), (3006, 'Dadiangas North', 'General Santos City', 'Philippines'),
    (3007, 'J.Catolico Street', 'General Santos City', 'Philippines'), (3008, 'Leon Llido Street', 'General Santos City', 'Philippines'),
    (3009, 'Leon Llido Street', 'General Santos City', 'Philippines');

INSERT INTO CustomerContact (CAddressId, CContactNumber)
VALUES
    (1, '+639179964312'), (2, '+639157854441'), (3, '+639779521555'), (5, '+639379967894'), (6, '+639957850032'),
    (7, '+639579527777'), (8, '+639119965644'), (9, '+639167899461'), (10, '+6391795233125'), (4, '+639371111874');

INSERT INTO SalesTransaction (CustomerCode, TimeStamp)
VALUES
    (3000, current_timestamp), (3002, current_timestamp), (3001, current_timestamp), (3003, current_timestamp), (3004, current_timestamp),
    (3005, current_timestamp), (3006, current_timestamp), (3007, current_timestamp), (3008, current_timestamp), (3009, current_timestamp);

INSERT INTO SalesLine (STransactionId, InventoryId, ItemCode, SQty, SalePrice)
VALUES
    (1, 5, 2000, 10, 15.00), (2, 5, 2000, 10, 15.00), (3, 6, 2002, 1, 87.35), (4, 7, 2001, 1, 67.00), (5, 8, 2003, 1, 25.00),
    (6, 9, 2004, 1, 368.20), (7, 10, 2005, 1, 290.00), (8, 11, 2006, 1, 264.45), (9, 12, 2007, 1, 149.45), (10, 13, 2008, 1, 149.45);

UPDATE SalesLine  SET InventoryId = 13 WHERE slineid=18;

SELECT * FROM SupplierContact WHERE SAddressId IN (1,2);

DELETE FROM SupplierContact WHERE scontactid= 5;

SELECT DISTINCT
    Suppliers.SupplierCode, Suppliers.CompanyName, SA.SStreet, SA.SCity, SA.SCountry, SC.ContactNumber
FROM
    Suppliers
        LEFT JOIN SupplierAddress SA on Suppliers.SupplierCode = SA.SupplierCode
        LEFT JOIN SupplierContact SC on SA.SAddressId = SC.SAddressId
WHERE
    Suppliers.SupplierCode = 1000
GROUP BY
    Suppliers.SupplierCode, Suppliers.CompanyName, SA.SStreet, SA.SCity, SA.SCountry, SC.ContactNumber;
