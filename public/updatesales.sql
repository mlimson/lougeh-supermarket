create procedure updatesales(INOUT stransid integer, IN cuscode integer, IN itmcode integer, IN qty integer, IN itmcost numeric, IN invid integer DEFAULT 0)
    language plpgsql
as
$$
    BEGIN
        IF EXISTS(SELECT stransactionid FROM salestransaction WHERE stransactionid = stransId)
            THEN
                IF ((SELECT itemcode FROM salesline WHERE stransactionid = stransId) <> itmCode)
                    THEN
                        IF(((SELECT itemstock FROM inventory WHERE itemcode = itmCode)  - qty) > 0 )
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
                        IF((SELECT sqty FROM salesline WHERE stransactionid = stransId AND itemcode = itmCode) > qty)
                            THEN
                                qty = (SELECT sqty FROM salesline WHERE stransactionid = stransId AND itemcode = itmCode)-qty;
                                UPDATE salesline SET sqty = sqty+ qty WHERE stransactionid = stransId AND itemcode = itmCode;
                                UPDATE inventory SET itemstock = itemstock + qty WHERE itemcode = itmCode;
                        ELSEIF ((SELECT sqty FROM salesline WHERE stransactionid = stransId AND itemcode = itmCode) < qty)
                            THEN
                                IF (((SELECT itemstock FROM inventory WHERE itemcode = itmCode)-(qty - (SELECT sqty FROM salesline WHERE stransactionid = stransId AND itemcode = itmCode)))>0)
                                    THEN
                                        qty = qty - (SELECT sqty FROM salesline WHERE stransactionid = stransId AND itemcode = itmCode);
                                        UPDATE salesline SET sqty = sqty + qty WHERE stransactionid = stransId AND itemcode = itmCode;
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

alter procedure updatesales(inout integer, integer, integer, integer, numeric, integer) owner to postgres;

