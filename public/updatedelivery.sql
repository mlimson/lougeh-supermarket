create procedure updatedelivery(INOUT dtransid integer, IN supcode integer, IN itmcode integer, IN qty integer, IN itmcost numeric, IN invid integer DEFAULT 0)
    language plpgsql
as
$$
    BEGIN
        IF EXISTS (SELECT dtransactionid FROM deliverytransaction WHERE dtransactionid = dtransId)
            THEN
                IF ((SELECT itemcode FROM deliveryline WHERE dtransactionid = dtransId) <> itmCode)
                    THEN
                        IF((SELECT itemstock FROM inventory WHERE inventoryid = (SELECT inventoryid FROM deliveryline WHERE dtransactionid = dtransId) - qty)>0)
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
                            IF (((SELECT itemstock FROM inventory WHERE itemcode = itmCode)-((SELECT dqty FROM deliveryline WHERE dtransactionid = dtransId AND itemcode = itmCode) - qty))>0)
                                THEN
                                    qty = (SELECT dqty FROM deliveryline WHERE dtransactionid = dtransId AND itemcode = itmCode) - qty;
                                    UPDATE deliveryline SET dqty = dqty - qty WHERE dtransactionid = dtransId AND itemcode = itmCode;
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

alter procedure updatedelivery(inout integer, integer, integer, integer, numeric, integer) owner to postgres;

