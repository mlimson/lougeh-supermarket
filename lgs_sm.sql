CREATE VIEW SupplierData AS SELECT DISTINCT
    Suppliers.SupplierCode, Suppliers.CompanyName, SA.SStreet, SA.SCity, SA.SCountry, SC.ContactNumber
FROM
    Suppliers
        LEFT JOIN SupplierAddress SA on Suppliers.SupplierCode = SA.SupplierCode
        LEFT JOIN SupplierContact SC on SA.SAddressId = SC.SAddressId
GROUP BY
    Suppliers.SupplierCode, Suppliers.CompanyName, SA.SStreet, SA.SCity, SA.SCountry, SC.ContactNumber
ORDER BY Suppliers.SupplierCode;

CREATE VIEW CustomerData AS SELECT DISTINCT
    Customers.CustomerCode, Customers.FirstName, Customers.LastName, CA.CStreet, CA.CCity, CA.CCountry, CC.CContactNumber
FROM
    Customers
        LEFT JOIN CustomerAddress CA on Customers.CustomerCode = CA.CustomerCode
        LEFT JOIN CustomerContact CC on CA.CAddressId = CC.CAddressId
GROUP BY
    Customers.CustomerCode, Customers.FirstName, Customers.LastName, CA.CStreet, CA.CCity, CA.CCountry, CC.CContactNumber
ORDER BY Customers.CustomerCode;

CREATE VIEW ItemData AS SELECT DISTINCT
    IT.ItemCode, IT.ItemDescription, IT.ItemBarcode, U.uomid, U.Description, IT.itemprice
    FROM item IT
        LEFT JOIN ItemUom IU on IT.ItemCode = IU.ItemCode
        LEFT JOIN Inventory I on IU.UniqueID = I.ItemUomId
        LEFT JOIN Uom U on IU.UomId = U.UomId
ORDER BY IT.ItemCode;

CREATE VIEW Top_Five_Item_Sold AS SELECT I.ItemCode, I.ItemDescription, SUM(SL.SQty) AS "Total Quantity"
    FROM SalesLine SL LEFT JOIN Item I on SL.ItemCode = I.ItemCode
GROUP BY I.ItemCode, I.ItemDescription, SL.SQty
ORDER BY "Total Quantity" DESC LIMIT 5;

CREATE OR REPLACE VIEW InventoryStatus AS
    SELECT i.itemcode, i.itembarcode, i.itemdescription, iv.itemstock, CAST(AVG(d.itemcost) AS DECIMAL(10,2)) AS AverageCost, CAST(AVG(s.saleprice) AS DECIMAL(10,2)) AS AveragePrice
    FROM inventory iv
        INNER JOIN item i ON iv.itemcode = i.itemcode
        INNER JOIN public.deliveryline d on i.itemcode = d.itemcode
        INNER JOIN public.salesline s on i.itemcode = s.itemcode
    GROUP BY i.itemcode, i.itembarcode, i.itemdescription, iv.itemstock;

CREATE OR REPLACE VIEW Delivered_Items AS SELECT DT.dtransactionid, I.ItemCode, I.ItemDescription, DL.dqty, DL.ItemCost, DT.TimeStamp
    FROM deliverytransaction DT
        LEFT JOIN DeliveryLine DL on DT.DTransactionId = DL.DTransactionId
        LEFT JOIN Item I on DL.ItemCode = I.ItemCode
ORDER BY  DT.timestamp;

CREATE OR REPLACE VIEW Sold_Items AS SELECT ST.stransactionid, ST.customercode, I.ItemCode, I. ItemDescription, SL.sqty, SL.saleprice, ST.TimeStamp
    FROM SalesTransaction ST
        LEFT JOIN SalesLine SL on ST.STransactionId = SL.STransactionId
        LEFT JOIN Item I on SL.ItemCode = I.ItemCode;

CREATE VIEW InventoryData AS SELECT iv.itemcode, i.itemdescription, i.itembarcode, iv.itemstock
FROM inventory iv INNER JOIN public.item i on iv.itemcode = i.itemcode WHERE iv.itemstock > 0;

CREATE OR REPLACE PROCEDURE addSupplier(
    name varchar,
    street varchar(255),
    city varchar(255),
    country varchar(255),
    contact varchar(15),
    supCode inout integer = 0,
    addressId inout integer = 0
)
LANGUAGE plpgsql AS
$$
    BEGIN
        INSERT INTO Suppliers (CompanyName, TimeStamp) VALUES (name, current_timestamp)
        RETURNING (SELECT currval('suppliers_suppliercode_seq')) INTO supCode;

        INSERT INTO SupplierAddress (SupplierCode, SStreet, SCity, SCountry) VALUES (supCode, street, city, country)
        RETURNING (SELECT currval('supplieraddress_saddressid_seq')) INTO addressId;

        INSERT INTO SupplierContact (SAddressId, ContactNumber)VALUES (addressId, contact);
        COMMIT;
    END
$$;
CALL addsupplier(name := null, street := null, city :=null , country :=null , contact :=null);
CREATE OR REPLACE PROCEDURE updateSupplier(
    supCode inout integer,
    name varchar(255),
    street varchar(255),
    city varchar(255),
    country varchar(255),
    contact varchar(15),
    addressId inout integer=0
)
LANGUAGE plpgsql AS
$$
    BEGIN
        IF EXISTS(SELECT SupplierCode FROM suppliers WHERE suppliercode=supCode)
            THEN
                UPDATE Suppliers SET CompanyName=name WHERE SupplierCode = supCode AND CompanyName <> name;
                UPDATE SupplierAddress SET SStreet=street WHERE SupplierCode = supCode AND SStreet<>street;
                UPDATE SupplierAddress SET SCity=city WHERE SupplierCode = supCode AND SCity<>city;
                UPDATE SupplierAddress SET SCountry=country WHERE SupplierCode = supCode AND SCountry<>country;
                addressId = (SELECT SAddressId FROM SupplierAddress WHERE SupplierCode=supCode);
                UPDATE SupplierContact SET ContactNumber=contact WHERE SAddressId=addressId AND ContactNumber<>contact;
            ELSE RAISE 'Supplier does not exists.';
        END IF;
        COMMIT;
    END
$$;
CALL updatesupplier(supCode := , name := 'Myles', street := '6th Street', city := 'Cebu City', country := 'Phil', contact := '+639886541234');
CREATE OR REPLACE PROCEDURE deleteSupplier(
    supCode inout integer,
    addressId inout integer=0
)
LANGUAGE plpgsql AS
$$
    BEGIN
        IF EXISTS(SELECT SupplierCode FROM suppliers WHERE suppliercode=supCode)
            THEN
                IF NOT EXISTS(SELECT SupplierCode FROM deliverytransaction WHERE suppliercode=supCode)
                    THEN
                        addressId = (SELECT SAddressId FROM SupplierAddress WHERE SupplierCode=supCode);
                        DELETE FROM SupplierContact WHERE SAddressId = addressId;
                        DELETE FROM SupplierAddress WHERE SupplierCode = supCode;
                        DELETE FROM Suppliers WHERE SupplierCode = supCode;
                    ELSE RAISE 'Cannot delete supplier with transactions.';
                end if;
            ELSE RAISE 'Supplier does not exists.';
        END IF;
        COMMIT;
    END
$$;
CALL deleteSupplier(supCode :=1000);

CREATE OR REPLACE PROCEDURE addCustomer(
    fname varchar(255),
    lname varchar(255),
    street varchar(255),
    city varchar(255),
    country varchar(255),
    contact varchar(15),
    addressId inout integer = 0,
    cusCode inout integer = 0
)
LANGUAGE plpgsql AS
$$
    BEGIN
        INSERT INTO Customers (FirstName, lastname, TimeStamp) VALUES (fname, lname, current_timestamp)
        RETURNING (SELECT currval('customers_customercode_seq')) INTO cusCode;

        INSERT INTO CustomerAddress (CustomerCode, CStreet, CCity, CCountry) VALUES (cusCode, street, city, country)
        RETURNING (SELECT currval('customeraddress_caddressid_seq')) INTO addressId;

        INSERT INTO CustomerContact (CAddressId, CContactNumber)VALUES (addressId, contact);

        COMMIT;
    END
$$;
CALL addCustomer(fname := _, lname := _, street := _, city := _, country := _, contact := _);
CREATE OR REPLACE PROCEDURE updateCustomer(
    cusCode inout integer,
    first varchar(255),
    last varchar(255),
    street varchar(255),
    city varchar(255),
    country varchar(255),
    contact varchar(15)
)
LANGUAGE plpgsql AS
$$
    BEGIN
        UPDATE Customers SET FirstName=first WHERE CustomerCode = cusCode AND FirstName <> first;
        UPDATE Customers SET LastName=last WHERE CustomerCode = cusCode AND LastName <> last;
        UPDATE CustomerAddress SET CStreet=street WHERE CustomerCode = cusCode AND CStreet <> street;
        UPDATE CustomerAddress SET CCity=city WHERE CustomerCode = cusCode AND CCity <> city;
        UPDATE CustomerAddress SET CCountry=country WHERE CustomerCode = cusCode AND CCountry <> country;
        UPDATE CustomerContact SET CContactNumber=contact WHERE CAddressId = (SELECT CAddressId FROM CustomerAddress WHERE CustomerCode = cusCode) AND CContactNumber<>contact;
        COMMIT;
    END
$$;
CALL updatecustomer(cusCode := _, first := _, last := _, street := _, city := _, country := _, contact := _);
CREATE OR REPLACE PROCEDURE deleteCustomer(
    cusCode inout integer,
    addressId inout integer=0
)
LANGUAGE plpgsql AS
$$
    BEGIN
        IF EXISTS(SELECT CustomerCode FROM customers WHERE customercode=cusCode)
            THEN
                IF NOT EXISTS(SELECT customercode FROM salestransaction WHERE customercode=cusCode)
                    THEN
                        addressId = (SELECT CAddressId FROM CustomerAddress WHERE CustomerCode=cusCode);
                        DELETE FROM CustomerContact WHERE CAddressId = addressId;
                        DELETE FROM CustomerAddress WHERE CustomerCode = cusCode;
                        DELETE FROM Customers WHERE CustomerCode = cusCode;
                    ELSE RAISE 'Cannot delete customer with transactions.';
                end if;
            ELSE RAISE 'Customer does not exists.';
        END IF;
        COMMIT;
    END
$$;
CALL deletecustomer(cusCode := );

CREATE OR REPLACE PROCEDURE addItem(
    itmBarcode char(13),
    itmDescription varchar(255),
    itmUom integer,
    itmPrice numeric(10,2),
    itmUomId integer = 0,
    itmCode inout integer = 0
)
LANGUAGE plpgsql AS
$$
    BEGIN
        INSERT INTO Item (itembarcode, itemdescription, itemprice) VALUES (itmBarcode, itmDescription, itmPrice)
        RETURNING (SELECT currval('item_itemcode_seq')) INTO itmCode;

        INSERT INTO itemuom (itemcode, uomid) VALUES (itmCode, itmUom)
        RETURNING (SELECT currval('itemuom_uniqueid_seq')) INTO itmUomId;

        INSERT INTO inventory (itemcode, itemuomid, itemstock) VALUES (itmCode, itmUomId, 0);
        COMMIT;
    END
$$;
CALL addItem(itmBarcode := _, itmDescription := _, itmUom := _, itmPrice := _, itmUomId := _, itmCode := _, itmbarcode := _, itmdescription := _, itmuom := _, itmprice := _);
CREATE OR REPLACE PROCEDURE updateItem(
    itmCode inout integer,
    itmDescription varchar(255),
    itmBarcode char(13),
    itmUom integer,
    itmPrice numeric(10,2)
)
LANGUAGE plpgsql AS
$$
    BEGIN
        UPDATE item SET itemdescription = itmDescription WHERE itemcode = itmCode AND itemdescription <> itmDescription;
        UPDATE item SET itembarcode = itmBarcode WHERE itemcode = itmCode AND itembarcode <> itmBarcode;
        UPDATE item SET itemprice = itmPrice WHERE itemcode = itmCode AND itemprice <> itmPrice;
        UPDATE itemuom SET uomid = itmUom WHERE itemcode = itmCode AND uomid <> itmUom;
        COMMIT;
    END
$$;
CALL updateItem(itmCode := _, itmDescription := _, itmBarcode := _, itmUom := _, itmPrice := _, itmcode := _, itmdescription := _, itmbarcode := _, itmuom := _, itmprice := _);
CREATE OR REPLACE PROCEDURE deleteItem(
    itmCode inout integer
)
LANGUAGE plpgsql AS
$$
    BEGIN
        IF EXISTS(SELECT itemcode FROM item WHERE itemcode = itmCode)
            THEN
               IF NOT EXISTS(SELECT itemcode FROM deliveryline WHERE itemcode = itmCode)
                    THEN
                        IF NOT EXISTS(SELECT itemcode FROM salesline WHERE itemcode = itmCode)
                                THEN
                                    DELETE FROM inventory WHERE itemcode = itmCode;
                                    DELETE FROM itemuom WHERE itemcode = itmCode;
                                    DELETE FROM item WHERE itemcode = itmCode;
                                ELSE
                                    RAISE 'Item used in sales transactions.';
                        END IF;
                    ELSE
                        RAISE 'Item used in delivery transactions.';
                END IF;
            ELSE
                RAISE 'Item does not exists.';
        END IF;
        COMMIT;
    END
$$;
CALL deleteitem(itmCode := 2013);

CREATE OR REPLACE PROCEDURE addDelivery(
    supCode integer,
    itmCode integer,
    qty integer,
    itmCost numeric(10,2),
    dtransId inout integer = 0,
    invId inout integer = 0
)
LANGUAGE plpgsql AS
$$
    BEGIN
        INSERT INTO deliverytransaction (suppliercode, timestamp) VALUES (supCode, current_timestamp)
        RETURNING (SELECT currval('deliverytransaction_dtransactionid_seq')) INTO dtransId;
        UPDATE inventory SET itemstock = itemstock + qty WHERE itemcode = itmCode;
        invId = (SELECT inventoryid FROM inventory WHERE itemcode = itmCode);
        INSERT INTO deliveryline (dtransactionid, inventoryid, itemcode, dqty, itemcost) VALUES (dtransId, invId, itmCode, qty, itmCost);
        COMMIT;
    END
$$;
CALL addDelivery(supCode := 1004, itmCode := 2006, qty := 3, itmCost := 99.16);

CREATE OR REPLACE PROCEDURE updateDelivery(
    dtransId inout integer,
    supCode integer,
    itmCode integer,
    qty integer,
    itmCost numeric(10,2),
    invId integer = 0
)
LANGUAGE plpgsql AS
$$
    BEGIN
        IF EXISTS (SELECT dtransactionid FROM deliverytransaction WHERE dtransactionid = dtransId)
            THEN
                IF ((SELECT itemcode FROM deliveryline WHERE dtransactionid = dtransId) <> itmCode)
                    THEN
                        IF((SELECT itemstock FROM inventory WHERE inventoryid = (SELECT inventoryid FROM deliveryline WHERE dtransactionid = dtransId) - qty)>=0)
                            THEN
                                UPDATE inventory SET itemstock = itemstock - qty WHERE inventoryid = (SELECT inventoryid FROM deliveryline WHERE dtransactionid = dtransId);
                                UPDATE inventory SET itemstock = itemstock + qty WHERE itemcode = itmCode
                                    RETURNING (SELECT inventoryid FROM inventory WHERE itemcode = itmCode) INTO invId;
                                UPDATE deliveryline SET inventoryid = invId WHERE dtransactionid = dtransId;
                                UPDATE deliveryline SET itemcode = itmCode WHERE dtransactionid = dtransId;
                            ELSE RAISE 'Updating item code will result in a negative inventory.';
                        END IF;
                END IF;
                IF((SELECT dqty FROM deliveryline WHERE dtransactionid = dtransId AND itemcode = itmCode) <> qty)
                    THEN
                        IF((SELECT dqty FROM deliveryline WHERE dtransactionid = dtransId AND itemcode = itmCode) < qty)
                        THEN
                                    qty = qty-(SELECT dqty FROM deliveryline WHERE dtransactionid = dtransId AND itemcode = itmCode);
                                    UPDATE deliveryline SET dqty = dqty+ qty WHERE dtransactionid = dtransId AND itemcode = itmCode;
                                    UPDATE inventory SET itemstock = itemstock + qty WHERE itemcode = itmCode;
                        ELSEIF ((SELECT dqty FROM deliveryline WHERE dtransactionid = dtransId AND itemcode = itmCode) > qty)
                        THEN
                            IF (((SELECT itemstock FROM inventory WHERE itemcode = itmCode)-((SELECT dqty FROM deliveryline WHERE dtransactionid = dtransId) - qty))>=0)
                                THEN
                                    qty = (SELECT dqty FROM deliveryline WHERE dtransactionid = dtransId) - qty;
                                    UPDATE deliveryline SET dqty = dqty - qty WHERE dtransactionid = dtransId;
                                    UPDATE inventory SET itemstock = itemstock - qty WHERE itemcode = itmCode;
                                ELSE RAISE 'Updating the quantity will result in a negative inventory.';
                            END IF;
                    END IF;
                END IF;
            ELSE RAISE 'Transaction does not exists.';
        END IF;
        UPDATE deliverytransaction SET suppliercode = supCode WHERE dtransactionid = dtransId AND suppliercode <> supCode;
        UPDATE deliveryline SET itemcost = itmCost WHERE dtransactionid = dtransId AND itemcost <> itmCost;
        COMMIT;
    END
$$;
CALL updateDelivery(dtransId := 35, supCode := 1014, itmCode := 2001, qty := 51, itmCost := 23.00);
CREATE OR REPLACE PROCEDURE deleteDelivery(
    dTransId inout integer,
    itmCode integer = 0,
    qty integer = 0
)
LANGUAGE plpgsql AS
$$
    BEGIN
        IF EXISTS (SELECT dtransactionid FROM deliverytransaction WHERE dtransactionid = dTransId)
            THEN
                qty = (SELECT dqty FROM deliveryline WHERE dtransactionid = dTransId);
                itmCode = (SELECT itemcode FROM deliveryline WHERE dtransactionid = dTransId);
                IF (((SELECT itemstock FROM inventory WHERE itemcode = itmCode)-qty) >= 0)
                    THEN
                        UPDATE inventory SET itemstock = itemstock - qty WHERE itemcode = itmCode;
                        DELETE FROM deliveryline WHERE dtransactionid = dTransId;
                        DELETE FROM deliverytransaction WHERE dtransactionid = dTransId;
                    ELSE RAISE 'Deleting delivery will result to a negative inventory.';
                END IF;
            ELSE RAISE 'Delivery transaction does not exists.';
        END IF;
        COMMIT;
    END
$$;
CALL deleteDelivery(dTransId := 7);

CREATE OR REPLACE PROCEDURE addSales(
    cusCode integer,
    itmCode integer,
    qty integer,
    itmCost numeric(10,2),
    stransId inout integer = 0,
    invId inout integer = 0
)
LANGUAGE plpgsql AS
$$
    BEGIN
        IF((SELECT itemstock FROM inventory WHERE itemcode=itmCode) >= qty)
        THEN
            INSERT INTO salestransaction (customercode, timestamp) VALUES (cusCode, current_timestamp)
            RETURNING (SELECT currval('salestransaction_stransactionid_seq')) INTO stransId;
            UPDATE inventory SET itemstock = itemstock - qty WHERE itemcode = itmCode;
            invId = (SELECT inventoryid FROM inventory WHERE itemcode = itmCode);
            INSERT INTO salesline (stransactionid, inventoryid, itemcode, sqty, saleprice) VALUES (stransId, invId, itmCode, qty, itmCost);
        ELSE
            RAISE 'Not enough quantity in inventory.';
        END IF;
        COMMIT;
    END
$$;
CALL addSales(cusCode := 3014, itmCode := 2006, qty := 1, itmCost := 250.00);
CREATE OR REPLACE PROCEDURE deleteSales(
    sTransId inout integer,
    itmCode integer = 0,
    qty integer = 0
)
LANGUAGE plpgsql AS
$$
    BEGIN
        IF EXISTS (SELECT stransactionid FROM salestransaction WHERE stransactionid = sTransId)
            THEN
                qty = (SELECT sqty FROM salesline WHERE stransactionid = sTransId);
                itmCode = (SELECT itemcode FROM salesline WHERE stransactionid = sTransId);
                UPDATE inventory SET itemstock = itemstock + qty WHERE itemcode = itmCode;
                DELETE FROM salesline WHERE stransactionid = sTransId;
                DELETE FROM salestransaction WHERE stransactionid = sTransId;
            ELSE
                RAISE 'Transaction not found.';
        END IF;
        COMMIT;
    END
$$;
CALL deleteSales(11);
CREATE OR REPLACE PROCEDURE updateSales(
    stransId inout integer,
    cusCode integer,
    itmCode integer,
    qty integer,
    itmCost numeric(10,2),
    invId integer = 0
)
LANGUAGE plpgsql AS
$$
    BEGIN
        IF EXISTS(SELECT stransactionid FROM salestransaction WHERE stransactionid = stransId)
            THEN
                IF ((SELECT itemcode FROM salesline WHERE stransactionid = stransId) <> itmCode)
                    THEN
                        IF(((SELECT itemstock FROM inventory WHERE itemcode = itmCode)  - qty) >= 0 )
                            THEN
                                UPDATE inventory SET itemstock = itemstock + qty WHERE inventoryid = (SELECT inventoryid FROM salesline WHERE stransactionid = stransId);
                                UPDATE inventory SET itemstock = itemstock - qty WHERE itemcode = itmCode
                                    RETURNING (SELECT inventoryid FROM inventory WHERE itemcode = itmCode) INTO invId;
                                UPDATE salesline SET inventoryid = invId WHERE stransactionid = stransId;
                                UPDATE salesline SET itemcode = itmCode WHERE stransactionid = stransId;
                            ELSE RAISE 'Updating item code will result in a negative inventory.';
                        END IF;
                END IF;
                IF((SELECT sqty FROM salesline WHERE stransactionid = stransId AND itemcode = itmCode) <> qty)
                    THEN
                        IF((SELECT sqty FROM salesline WHERE stransactionid = stransId) > qty)
                            THEN
                                qty = (SELECT sqty FROM salesline WHERE stransactionid = stransId)-qty;
                                UPDATE salesline SET sqty = sqty - qty WHERE stransactionid = stransId;
                                UPDATE inventory SET itemstock = itemstock + qty WHERE itemcode = itmCode;
                        ELSEIF ((SELECT sqty FROM salesline WHERE stransactionid = stransId) < qty)
                            THEN
                                IF (((SELECT itemstock FROM inventory WHERE itemcode = itmCode)-(qty - (SELECT sqty FROM salesline WHERE stransactionid = stransId))) >= 0)
                                    THEN
                                        qty = qty - (SELECT sqty FROM salesline WHERE stransactionid = stransId);
                                        UPDATE salesline SET sqty = sqty + qty WHERE stransactionid = stransId;
                                        UPDATE inventory SET itemstock = itemstock - qty WHERE itemcode = itmCode;
                                    ELSE RAISE 'Updating the quantity will result in a negative inventory.';
                                END IF;
                        END IF;
                END IF;
            ELSE RAISE 'Transaction does not exists.';
        END IF;
        UPDATE salestransaction SET customercode = cusCode WHERE stransactionid = stransId AND customercode <> cusCode;
        UPDATE salesline SET saleprice = itmCost WHERE stransactionid = stransId AND saleprice <> itmCost;
        COMMIT;
    END
$$;
CALL updateSales(stransId :=20, cusCode := 3005, itmCode := 2006, qty := 4, itmCost := 140.10);

CREATE OR REPLACE addUom()