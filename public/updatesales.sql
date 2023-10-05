create procedure updatesales(IN cuscode integer, IN itmcode integer, IN qty integer, IN itmcost numeric, INOUT stransid integer, IN invid integer DEFAULT 0)
    language plpgsql
as
$$
    BEGIN
        UPDATE salestransaction SET customercode = cusCode WHERE stransactionid = stransId AND salestransaction.customercode <> cusCode;
        UPDATE salesline SET saleprice = itmCost WHERE stransactionid = stransId AND salesline.saleprice <> itmCost;
        IF ((SELECT itemcode FROM salesline WHERE stransactionid = stransId) <> itmCode)
            THEN
                UPDATE inventory SET itemstock = itemstock - qty WHERE inventoryid = (SELECT inventoryid FROM salesline WHERE stransactionid = stransId);
                UPDATE inventory SET itemstock = itemstock + qty WHERE itemcode = itmCode
                    RETURNING (SELECT inventoryid FROM inventory WHERE itemcode = itmCode) INTO invId;
                UPDATE salesline SET inventoryid = invId WHERE stransactionid = stransId;
                UPDATE salesline SET itemcode = itmCode WHERE stransactionid = stransId;
        END IF;
        IF((SELECT sqty FROM salesline WHERE stransactionid = stransId) < qty)
            THEN
                UPDATE salesline SET sqty = qty WHERE stransactionid = stransId;
                UPDATE inventory SET itemstock = itemstock + (qty-(SELECT sqty FROM salesline WHERE stransactionid = stransId)) WHERE itemcode = itmCode;

        ELSEIF ((SELECT sqty FROM salesline WHERE stransactionid = stransId) > qty)
            THEN
                UPDATE salesline SET sqty = qty WHERE stransactionid = stransId;
                UPDATE inventory SET itemstock = itemstock - ((SELECT sqty FROM salesline WHERE stransactionid = stransId) - qty) WHERE itemcode = itmCode;
        ELSE
        END IF;
        COMMIT;
    END
$$;

alter procedure updatesales(integer, integer, integer, numeric, inout integer, integer) owner to postgres;

